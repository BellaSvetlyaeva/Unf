#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текущее состояние классификатора контактов.
// 
// Возвращаемое значение:
//  Структура - Ключи: 
//    * КлассификаторКонтактовЗаполнен - Булево
//    * ЕстьКонтактыСозданныеПоСобытию - Булево
//
Функция ТекущееСостояние() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторКонтактов.Ссылка
	|ИЗ
	|	Справочник.КлассификаторКонтактов КАК КлассификаторКонтактов
	|ГДЕ
	|	КлассификаторКонтактов.Пользователь = &Пользователь
	|	И НЕ КлассификаторКонтактов.СозданПоСобытию
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторКонтактов.Ссылка
	|ИЗ
	|	Справочник.КлассификаторКонтактов КАК КлассификаторКонтактов
	|ГДЕ
	|	КлассификаторКонтактов.Пользователь = &Пользователь
	|	И КлассификаторКонтактов.СозданПоСобытию");
	Запрос.УстановитьПараметр("Пользователь", 
	Пользователи.ТекущийПользователь());
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Результат = Новый Структура;
	Результат.Вставить("КлассификаторКонтактовЗаполнен", Не РезультатЗапроса[0].Пустой());
	Результат.Вставить("ЕстьКонтактыСозданныеПоСобытию", Не РезультатЗапроса[1].Пустой());
	
	Возврат Результат;
	
КонецФункции

// Возвращает ссылку на КлассификаторКонтактов по указанному идентификатору.
//
// Параметры:
//  Идентификатор	 - Строка - идентификатор объекта
//  Пользователь	 - СправочникСсылка.Пользователи - пользователь,для которого будет производиться поиск объекта.
// 
// Возвращаемое значение:
//  СправочникСсылка.КлассификаторКонтактов - ссылка на найденный элемент справочника КлассификаторКонтактов.
//  Для случая когда элемент с указанным идентификатором не найден, возвращается ПустаяСсылка.
//
Функция СсылкаПоИдентификатору(Идентификатор, Пользователь) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Справочники.КлассификаторКонтактов.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КлассификаторКонтактов.Ссылка
	|ИЗ
	|	Справочник.КлассификаторКонтактов КАК КлассификаторКонтактов
	|ГДЕ
	|	КлассификаторКонтактов.Пользователь = &Пользователь
	|	И КлассификаторКонтактов.Key = &Key");
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Key",
	ОбменСGoogle.КлючИзИдентификатора(Идентификатор, ТипЗнч(Справочники.КлассификаторКонтактов)));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.КлассификаторКонтактов.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Ссылка;
	
КонецФункции

// Возвращает объект типа КлассификаторКонтактовОбъект по указанному идентификатору.
// В случае если объект по переданным параметрам не будет найден,
// будет создан новый объект и заполнен переданными параметрами.
//
// Параметры:
//  Идентификатор	 - Строка - идентификатор объекта
//  Пользователь	 - СправочникСсылка.Пользователи - пользователь,для которого будет производиться поиск объекта.
// 
// Возвращаемое значение:
//  СправочникОбъект.КлассификаторКонтактов - найденный или созданный в соответствии с параметрами объект.
//  Неопределено - для случая когда Идентификатор не указан.
//
Функция ОбъектПоИдентификатору(Идентификатор, Пользователь) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СсылкаНаОбъект = СсылкаПоИдентификатору(Идентификатор, Пользователь);
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат СсылкаНаОбъект.ПолучитьОбъект();
	КонецЕсли;
	
	Результат = СоздатьЭлемент();
	Результат.Пользователь = Пользователь;
	Результат.Id = Идентификатор;
	Возврат Результат;
	
КонецФункции

// Заполняет контактную информацию контрагента или контактного лица
// из реквизита JSON классификатора контактов
//
// Параметры:
//  КонтактнаяИнформация - ДанныеФормыКоллекция - контактная информация для заполнения
//  ДанныеКонтактаJSON	 - Строка - значение реквизита JSON из классификатора
//                         для заполнения контактной информации
//  ТипЗначения			 - Тип - тип объекта, для которого заполняется контактная информация
Процедура ЗаполнитьКонтактнуюИнформациюИзJSON(КонтактнаяИнформация, Знач ДанныеКонтактаJSON, Знач ТипЗначения) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеКонтактаJSON) Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ДанныеКонтактаJSON);
	ПрочитанныеДанные = ПрочитатьJSON(ЧтениеJSON, Истина);
	
	ЗаполнитьEmail(КонтактнаяИнформация, ПрочитанныеДанные["gd$email"], ТипЗначения);
	ЗаполнитьНомераТелефонов(КонтактнаяИнформация, ПрочитанныеДанные["gd$phoneNumber"], ТипЗначения);
	ЗаполнитьАдреса(КонтактнаяИнформация, ПрочитанныеДанные["gd$structuredPostalAddress"], ТипЗначения);
	ЗаполнитьСайты(КонтактнаяИнформация, ПрочитанныеДанные["gContact$website"], ТипЗначения);
	
КонецПроцедуры

// Возвращает контактную информацию контрагента или контактного лица
// из реквизита JSON классификатора контактов
//
// Параметры:
//  ДанныеКонтактаJSON	 - Строка - значение реквизита JSON из классификатора
//                         для заполнения контактной информации
//
Функция КонтактнаяИнформацияИзJSON(Знач ДанныеКонтактаJSON) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Email", Новый Массив);
	Результат.Вставить("Телефон", Новый Массив);
	Результат.Вставить("Адрес", Новый Массив);
	Результат.Вставить("Сайт", Новый Массив);
	
	Если Не ЗначениеЗаполнено(ДанныеКонтактаJSON) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ДанныеКонтактаJSON);
	ПрочитанныеДанные = ПрочитатьJSON(ЧтениеJSON, Истина);
	
	Результат.Email = ИзвлечьEmail(ПрочитанныеДанные["gd$email"]);
	Результат.Телефон = ИзвлечьНомераТелефонов(ПрочитанныеДанные["gd$phoneNumber"]);
	Результат.Адрес = ИзвлечьАдреса(ПрочитанныеДанные["gd$structuredPostalAddress"]);
	Результат.Сайт = ИзвлечьСайты(ПрочитанныеДанные["gContact$website"]);
	Возврат Результат;
	
КонецФункции

// Функция возвращает список значений для обработчика АвтоПодбор в поле выбора
//
// Параметры:
//  СтрокаПоиска			 - Строка - строка, используемая при поиске данных, по которой осуществляется быстрый выбор
//  ТолькоКлассификатор		 - Булево - при установке в значение Истина поиск будет осуществляться только по классификатору,
//                             Ложь - данные для выбора будут предлагаться в консолидированном виде, по справочнику и классификатору
//  ТипЗначения				 - Тип - тип значения, которое будет подставляться в поле ввода
//  Отбор					 - Структура - значение, передаваемое в обработчик АвтоПодбора Параметры.Отбор
// 
// Возвращаемое значение:
//  СписокЗначений - значение параметра ДанныеВыбора для обработчика АвтоПодбор
//  Неопределено - в случае когда параметр СтрокаПоиска не указан
//
Функция СписокАвтоПодбора(Знач СтрокаПоиска, Знач ТолькоКлассификатор, Знач ТипЗначения, Знач Отбор) Экспорт
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	
	Запрос = ЗапросДляСпискаАвтоПодбора(СтрокаПоиска, ТипЗначения, Отбор);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ТипЗначения = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		КонтрагентыКонтактов = ПолучитьКонтрагентыКонтактов(РезультатЗапроса);
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Порядок = 1 Тогда
			
			Если ТолькоКлассификатор Тогда
				Продолжить;
			КонецЕсли;
			
			ПредставлениеЭлемента = ПредставлениеЭлементаСписка(Выборка.Представление, СтрокаПоиска);
			Если ТипЗнч(Выборка.Ссылка) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
				ПредставлениеЭлемента = ПредставлениеКонтакта(ПредставлениеЭлемента, Выборка.Ссылка, КонтрагентыКонтактов);
			КонецЕсли;
			
			Результат.Добавить(Выборка.Ссылка, ПредставлениеЭлемента);
			Продолжить;
			
		КонецЕсли;
		
		// Выборка.СозданПоСобытию может быть Null
		Если Выборка.СозданПоСобытию = Ложь Тогда
			ДобавитьПредставлениеКонтакта(Результат, Выборка, СтрокаПоиска);
		ИначеЕсли Выборка.СозданПоСобытию = Истина Тогда
			ДобавитьПредставлениеСозданногоПоСобытиюКонтакта(Результат, Выборка, СтрокаПоиска);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция КонтактКакСвязаться(ЭлементКлассификатораКонтактов) Экспорт
	
	Результат = Новый Структура("Контакт, КакСвязаться");
	
	ДанныеКонтакта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	ЭлементКлассификатораКонтактов,
	"Id, Title, JSON, СозданПоСобытию");
	
	Результат.Контакт = ДанныеКонтакта.Title;
	
	Если ДанныеКонтакта.СозданПоСобытию Тогда
		Результат.КакСвязаться = ДанныеКонтакта.Id;
		Возврат Результат;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ДанныеКонтакта.JSON);
	ПрочитанныеДанные = ПрочитатьJSON(ЧтениеJSON, Истина);
	Если ЗначениеЗаполнено(ПрочитанныеДанные["gd$email"]) Тогда
		Результат.КакСвязаться = ПрочитанныеДанные["gd$email"][0]["address"];
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьКонтактКакСвязаться(КонтактОбъект, Контакт, КакСвязаться) Экспорт
	
	ДанныеДляЗаписи = Новый Соответствие;
	ДанныеДляЗаписи["gd$email"] = Новый Массив;
	ДанныеДляЗаписи["gd$email"].Добавить(Новый Структура("address", КакСвязаться));
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеДляЗаписи);
	
	КонтактОбъект.JSON = ЗаписьJSON.Закрыть();
	КонтактОбъект.Title = Контакт;
	КонтактОбъект.ДатаСинхронизации = ТекущаяДатаСеанса();
	КонтактОбъект.СозданПоСобытию = Истина;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Пользователь)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДанныеВыбора = СписокАвтоПодбора(Параметры.СтрокаПоиска, Истина, Тип("СправочникСсылка.Контрагенты"), Параметры.Отбор);
	СтандартнаяОбработка = Не ЗначениеЗаполнено(ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросДляСпискаАвтоПодбора(СтрокаПоиска, ТипЗначения, Отбор)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 10
	|	ЭлементыСправочника.Ссылка КАК Ссылка,
	|	ЭлементыСправочника.Наименование КАК Представление,
	|	"""" КАК Организация,
	|	1 КАК Порядок
	|ПОМЕСТИТЬ Существующие
	|ИЗ
	|	Справочник.Контрагенты КАК ЭлементыСправочника
	|ГДЕ
	|	ЭлементыСправочника.Наименование ПОДОБНО &СтрокаПоиска
	|	И &УсловиеПоРеквизитуСправочника
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 10
	|	Существующие.Ссылка КАК Ссылка,
	|	Существующие.Представление КАК Представление,
	|	Существующие.Организация КАК Организация,
	|	NULL КАК Идентификатор,
	|	NULL КАК СозданПоСобытию,
	|	Существующие.Порядок КАК Порядок
	|ИЗ
	|	Существующие КАК Существующие
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 10
	|	КлассификаторКонтактов.Ссылка,
	|	КлассификаторКонтактов.Title,
	|	КлассификаторКонтактов.Organization,
	|	КлассификаторКонтактов.Id,
	|	КлассификаторКонтактов.СозданПоСобытию,
	|	2
	|ИЗ
	|	Справочник.КлассификаторКонтактов КАК КлассификаторКонтактов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Существующие КАК Существующие
	|		ПО КлассификаторКонтактов.Title = Существующие.Представление
	|ГДЕ
	|	КлассификаторКонтактов.Пользователь = &Пользователь
	|	И (КлассификаторКонтактов.Title ПОДОБНО &СтрокаПоиска
	|			ИЛИ КлассификаторКонтактов.Organization ПОДОБНО &СтрокаПоиска
	|			ИЛИ ВЫБОР
	|				КОГДА КлассификаторКонтактов.СозданПоСобытию
	|					ТОГДА КлассификаторКонтактов.Id ПОДОБНО &СтрокаПоиска
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|	И НЕ КлассификаторКонтактов.ПометкаУдаления
	|	И ВЫБОР
	|			КОГДА Существующие.Представление ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ КлассификаторКонтактов.Title <> Существующие.Представление
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Существующие.Порядок,
	|	Существующие.Представление";
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗначения);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Контрагенты", ОбъектМетаданных.ПолноеИмя());
	
	НаложитьОтборПоПризнакуНедействителен(ТекстЗапроса, ОбъектМетаданных);
	
	НаложитьОтборПоГруппе(ТекстЗапроса, ОбъектМетаданных);
	
	Результат = Новый Запрос(ТекстЗапросаСОтборамиПоПолямВводПоСтроке(ТекстЗапроса, ОбъектМетаданных));
	
	НаложитьОтбор(Результат, Отбор);
	
	Результат.Текст = СтрЗаменить(Результат.Текст, "И &УсловиеПоРеквизитуСправочника", "");
	Результат.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	Результат.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Если ОбъектМетаданных.ПолноеИмя() = "Справочник.Контрагенты" Тогда
		
		ТелефонДляПоиска = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(СтрокаПоиска);
		ТелефонДляПоиска = СтрЗаменить(ТелефонДляПоиска, "+", "");
		Если СтрНачинаетсяС(ТелефонДляПоиска, "7") Тогда
			ПоисковоеВыражение = Сред(ТелефонДляПоиска, 2, СтрДлина(ТелефонДляПоиска) - 1);
		КонецЕсли;
		Результат.УстановитьПараметр("НомерТелефонаДляПоиска", ТелефонДляПоиска);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура НаложитьОтборПоПризнакуНедействителен(ТекстЗапроса, ОбъектМетаданных)
	
	Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("Недействителен", ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"И &УсловиеПоРеквизитуСправочника",
	"И НЕ ЭлементыСправочника.Недействителен
	|И &УсловиеПоРеквизитуСправочника");
	
КонецПроцедуры

Процедура НаложитьОтборПоГруппе(ТекстЗапроса, ОбъектМетаданных)
	
	Если Не ОбъектМетаданных.Иерархический Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбъектМетаданных.ВидИерархии <> Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"И &УсловиеПоРеквизитуСправочника",
	"И &УсловиеПоРеквизитуСправочника
	|И НЕ ЭлементыСправочника.ЭтоГруппа");
	
КонецПроцедуры

Функция ТекстЗапросаСОтборамиПоПолямВводПоСтроке(ТекстЗапроса, ОбъектМетаданных)
	
	КомпонентыПоля = Новый Массив;
	КомпонентыУсловия = Новый Массив;
	ШаблонПоля = "КОГДА ЭлементыСправочника.%1 ПОДОБНО &СтрокаПоиска
	|	ТОГДА ЭлементыСправочника.%2";
	ШаблонУсловия = "ЭлементыСправочника.%1 ПОДОБНО &СтрокаПоиска";
	Для каждого Поле Из ОбъектМетаданных.ВводПоСтроке Цикл
		Если Поле.Имя = "Наименование" Тогда
			ЗапросПоле = СтрШаблон(ШаблонПоля, "Наименование", "Наименование");
			ЗапросУсловие = СтрШаблон(ШаблонУсловия, "Наименование");
		Иначе
			НаименованиеЭлементаВСкобках = " + "" ("" + ЭлементыСправочника.Наименование + "")""";
			ЗапросПоле = СтрШаблон(ШаблонПоля, Поле.Имя, Поле.Имя + НаименованиеЭлементаВСкобках);
			ЗапросУсловие = СтрШаблон(ШаблонУсловия, Поле.Имя);
		КонецЕсли;
		КомпонентыПоля.Добавить(ЗапросПоле);
		КомпонентыУсловия.Добавить(ЗапросУсловие);
	КонецЦикла;
	
	УсловиеПредставления = СтрШаблон("(%1)", СтрСоединить(КомпонентыУсловия, " ИЛИ "));
	ПолеПредставление = "ВЫБОР
	|%1
	|ИНАЧЕ ЭлементыСправочника.Наименование
	|КОНЕЦ КАК Представление,";
	ПолеПредставление = СтрШаблон(ПолеПредставление, СтрСоединить(КомпонентыПоля, Символы.ПС));
	
	ШаблонПолеПредставление = "ЭлементыСправочника.Наименование КАК Представление,";
	ШаблонУсловиеПредставления = "ЭлементыСправочника.Наименование ПОДОБНО &СтрокаПоиска";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ШаблонУсловиеПредставления, УсловиеПредставления);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ШаблонПолеПредставление, ПолеПредставление);
	
	КомпонентыЗапроса = СтрРазделить(ТекстЗапроса, ";");
	ШаблонДляДобавления = КомпонентыЗапроса[0];
	ШаблонДляДобавления = СтрЗаменить(ШаблонДляДобавления, "РАЗРЕШЕННЫЕ", "");
	ШаблонДляДобавления = СтрЗаменить(ШаблонДляДобавления, "ПОМЕСТИТЬ Существующие", "");
	
	ДобавленныеКомпоненты = Новый Массив;
	ДобавленныеКомпоненты.Добавить(КомпонентыЗапроса[0]);
	
	Если ОбъектМетаданных.ПолноеИмя() = "Справочник.Контрагенты" Тогда
		ДобавленныеКомпоненты.Добавить(ТекстЗапросаКонтактыПоАдресуЭПНомеруТелефона());
	КонецЕсли;
	
	Результат = Новый Массив;
	Результат.Добавить(СтрСоединить(ДобавленныеКомпоненты, "
	|ОБЪЕДИНИТЬ 
	|"));
	
	Результат.Добавить(КомпонентыЗапроса[1]);
	
	Возврат СтрСоединить(Результат, ";");
	
КонецФункции

Процедура НаложитьОтбор(Запрос, Отбор)
	
	Если Не ЗначениеЗаполнено(Отбор) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Отбор Цикл
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"И &УсловиеПоРеквизитуСправочника",
		СтрШаблон("И ЭлементыСправочника.%1 = &Параметр%1
		|И &УсловиеПоРеквизитуСправочника", КлючИЗначение.Ключ));
		Запрос.УстановитьПараметр(СтрШаблон("Параметр%1", КлючИЗначение.Ключ), КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

Функция ПредставлениеЭлементаСписка(Представление, СтрокаПоиска)
	
	Позиция = Найти(НРег(Представление), НРег(СтрокаПоиска));
	Если Позиция>0 Тогда
		ТекстДо = Лев(Представление, Позиция-1);
		ТекстЦентр = Сред(Представление, Позиция, СтрДлина(СтрокаПоиска));
		ТекстПосле = Сред(Представление, Позиция+СтрДлина(СтрокаПоиска));
		ВыделенныйТекст = Новый ФорматированнаяСтрока(ТекстЦентр, Новый Шрифт(Новый Шрифт,,, Истина), WebЦвета.ЗеленыйЛес);
		Результат = Новый ФорматированнаяСтрока(ТекстДо, ВыделенныйТекст, ТекстПосле);
	Иначе
		Результат = Представление;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьНомераТелефонов(КонтактнаяИнформация, ДанныеТелефонов, ТипЗначения)
	
	Если ТипЗнч(ДанныеТелефонов) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеТелефонов Цикл
		
		ТекЗначение = ТекЭлемент["$t"];
		
		Если Не ЗначениеЗаполнено(ТекЗначение) Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = КонтактнаяИнформация.НайтиСтроки(
		Новый Структура("Представление", ТекЗначение));
		
		Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаКИ = НайтиИлиДобавитьНовуюСтрокуКИ(КонтактнаяИнформация, Перечисления.ТипыКонтактнойИнформации.Телефон);
		
		СтрокаКИ.Представление = ТекЗначение;
		Если ТипЗначения = Тип("СправочникСсылка.Контрагенты") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента;
		ИначеЕсли ТипЗначения = Тип("СправочникСсылка.КонтактныеЛица") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица;
		ИначеЕсли ТипЗначения = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица;
		КонецЕсли;
		
		СтрокаКИ.Значение = ЗначениеПоляНомерТелефона(ТекЭлемент);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИзвлечьНомераТелефонов(ДанныеТелефонов)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(ДанныеТелефонов) <> Тип("Массив") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеТелефонов Цикл
		
		ТекЗначение = ТекЭлемент["$t"];
		
		Если Не ЗначениеЗаполнено(ТекЗначение) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеТелефона = Новый Структура("Представление,Значение");
		ОписаниеТелефона.Представление = ТекЗначение;
		ОписаниеТелефона.Значение = ЗначениеПоляНомерТелефона(ТекЭлемент);
		Результат.Добавить(ОписаниеТелефона);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеПоляНомерТелефона(ДанныеТелефона)
	
	Если Не ЗначениеЗаполнено(ДанныеТелефона["uri"]) Тогда
		Возврат ДанныеТелефона["$t"];
	КонецЕсли;
	
	ЗначениеДляРазбора = СтрЗаменить(ДанныеТелефона["uri"], "tel:", "");
	
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(
	ЗначениеДляРазбора,
	Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьEmail(КонтактнаяИнформация, ДанныеЭлектроннойПочты, ТипЗначения)
	
	Если ТипЗнч(ДанныеЭлектроннойПочты) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеЭлектроннойПочты Цикл
		
		ТекЗначение = ТекЭлемент["address"];
		
		Если Не ЗначениеЗаполнено(ТекЗначение) Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = КонтактнаяИнформация.НайтиСтроки(
		Новый Структура("Представление", ТекЗначение));
		
		Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаКИ = НайтиИлиДобавитьНовуюСтрокуКИ(КонтактнаяИнформация, Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		СтрокаКИ.Представление = ТекЗначение;
		Если ТипЗначения = Тип("СправочникСсылка.Контрагенты") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагента;
		ИначеЕсли ТипЗначения = Тип("СправочникСсылка.КонтактныеЛица") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица;
		КонецЕсли;
		
		СтрокаКИ.Значение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(СтрокаКИ.Представление, СтрокаКИ.Вид);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИзвлечьEmail(ДанныеЭлектроннойПочты)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(ДанныеЭлектроннойПочты) <> Тип("Массив") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеЭлектроннойПочты Цикл
		ТекЗначение = ТекЭлемент["address"];
		Если Не ЗначениеЗаполнено(ТекЗначение) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеEmail = Новый Структура("Представление,Значение");
		ОписаниеEmail.Представление = ТекЗначение;
		ОписаниеEmail.Значение = "";
		Результат.Добавить(ОписаниеEmail);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьАдреса(КонтактнаяИнформация, ДанныеАдресов, ТипЗначения)
	
	Если ТипЗначения <> Тип("СправочникСсылка.Контрагенты") 
		И ТипЗначения <> Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеАдресов) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеАдресов Цикл
		
		КонтактнаяИнформацияАдрес = КонтактнаяИнформацияАдрес(ТекЭлемент);
		
		Если Не ЗначениеЗаполнено(КонтактнаяИнформацияАдрес) Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = КонтактнаяИнформация.НайтиСтроки(
		Новый Структура("Представление", КонтактнаяИнформацияАдрес.Представление));
		
		Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаКИ = НайтиИлиДобавитьНовуюСтрокуКИ(КонтактнаяИнформация, Перечисления.ТипыКонтактнойИнформации.Адрес);
		СтрокаКИ.Представление = КонтактнаяИнформацияАдрес.Представление;
		СтрокаКИ.Значение      = КонтактнаяИнформацияАдрес.Значение;
		
		Если ТипЗначения = Тип("СправочникСсылка.Контрагенты") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента;
		КонецЕсли;
		
		Если ТипЗначения = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИзвлечьАдреса(ДанныеАдресов)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(ДанныеАдресов) <> Тип("Массив") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеАдресов Цикл
		КонтактнаяИнформацияАдрес = КонтактнаяИнформацияАдрес(ТекЭлемент);
		Если Не ЗначениеЗаполнено(КонтактнаяИнформацияАдрес) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеАдреса = Новый Структура("Представление,Значение");
		ОписаниеАдреса.Представление = КонтактнаяИнформацияАдрес.Представление;
		ОписаниеАдреса.Значение = КонтактнаяИнформацияАдрес.Значение;
		Результат.Добавить(ОписаниеАдреса);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция КонтактнаяИнформацияАдрес(ДанныеАдреса)
	
	Результат = Новый Структура;
	
	Если ТипЗнч(ДанныеАдреса) <> Тип("Соответствие") Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПоляАдреса = РаботаСАдресамиКлиентСервер.ПоляАдреса();
	ПоляАдреса.Представление = КомпонентаАдреса(ДанныеАдреса["gd$formattedAddress"]);
	ПоляАдреса.Страна = КомпонентаАдреса(ДанныеАдреса["gd$country"]);
	ПоляАдреса.Индекс = КомпонентаАдреса(ДанныеАдреса["gd$postcode"]);
	ПоляАдреса.Регион = КомпонентаАдреса(ДанныеАдреса["gd$region"]);
	ПоляАдреса.Район = КомпонентаАдреса(ДанныеАдреса["gd$neighborhood"]);
	ПоляАдреса.Город = КомпонентаАдреса(ДанныеАдреса["gd$city"]);
	ПоляАдреса.Улица = КомпонентаАдреса(ДанныеАдреса["gd$street"]);
	ПоляАдреса.Дом = КомпонентаАдреса(ДанныеАдреса["gd$pobox"]);
	
	Результат.Вставить("Значение", РаботаСАдресами.ПоляАдресаВJSON(ПоляАдреса));
	Результат.Вставить("Представление", УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Результат.Значение));
	
	Возврат Результат;
	
КонецФункции

Функция КомпонентаАдреса(Компонента)
	
	Если ТипЗнч(Компонента) <> Тип("Соответствие") Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СокрЛП(СтрЗаменить(Компонента["$t"], Символы.ПС, " "));
	
КонецФункции

Процедура ЗаполнитьСайты(КонтактнаяИнформация, ДанныеВебСайтов, ТипЗначения)
	
	Если ТипЗначения <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеВебСайтов) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеВебСайтов Цикл
		
		ТекЗначение = ТекЭлемент["href"];
		
		НайденныеСтроки = КонтактнаяИнформация.НайтиСтроки(
		Новый Структура("Представление", ТекЗначение));
		
		Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаКИ = НайтиИлиДобавитьНовуюСтрокуКИ(КонтактнаяИнформация, Перечисления.ТипыКонтактнойИнформации.ВебСтраница);
		СтрокаКИ.Представление = ТекЗначение;
		СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагента;
		СтрокаКИ.Значение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(СтрокаКИ.Представление, СтрокаКИ.Вид);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИзвлечьСайты(ДанныеВебСайтов)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(ДанныеВебСайтов) <> Тип("Массив") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ДанныеВебСайтов Цикл
		ТекЗначение = ТекЭлемент["href"];
		
		ОписаниеСайта = Новый Структура("Представление,Значение");
		ОписаниеСайта.Представление = ТекЗначение;
		ОписаниеСайта.Значение = "";
		Результат.Добавить(ОписаниеСайта);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция НайтиИлиДобавитьНовуюСтрокуКИ(КонтактнаяИнформация, ТипКонтактнойИнформации)
	
	НайденныеСтроки = КонтактнаяИнформация.НайтиСтроки(
	Новый Структура("Тип", ТипКонтактнойИнформации));
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Если Не ЗначениеЗаполнено(НайденнаяСтрока.Представление) Тогда
			Возврат НайденнаяСтрока;
		КонецЕсли;
	КонецЦикла;
	
	// Добавляем новую строку КИ с группировкой по типу КИ
	КоличествоЭлементовКоллекции = КонтактнаяИнформация.Количество();
	ИндексВставки = КоличествоЭлементовКоллекции;
	
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		ТекущийИндекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		Если КонтактнаяИнформация[ТекущийИндекс].Тип = ТипКонтактнойИнформации Тогда
			ИндексВставки = ТекущийИндекс + 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Результат = КонтактнаяИнформация.Вставить(ИндексВставки);
	Результат.Тип = ТипКонтактнойИнформации;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьПредставлениеКонтакта(СписокКонтактов, Данные, СтрокаПоиска)
	
	Если ЗначениеЗаполнено(Данные.Организация) Тогда
		Представление = СтрШаблон("%1 (%2)", Данные.Представление, Данные.Организация);
	Иначе
		Представление = Данные.Представление;
	КонецЕсли;
	
	СписокКонтактов.Добавить(
	Данные.Ссылка,
	ПредставлениеЭлементаСписка(Представление, СтрокаПоиска),,
	БиблиотекаКартинок.GoogleДобавить);
	
КонецПроцедуры

Процедура ДобавитьПредставлениеСозданногоПоСобытиюКонтакта(СписокКонтактов, Данные, СтрокаПоиска)
	
	Если Данные.Представление <> Данные.Идентификатор Тогда
		Представление = СтрШаблон("%1 (%2)", Данные.Представление, Данные.Идентификатор);
	Иначе
		Представление = Данные.Представление;
	КонецЕсли;
	
	СписокКонтактов.Добавить(
	Данные.Ссылка,
	ПредставлениеЭлементаСписка(Представление, СтрокаПоиска),,
	БиблиотекаКартинок.КонтактнаяИнформацияЭлПочта);
	
КонецПроцедуры

Функция ПолучитьКонтрагентыКонтактов(Выборка)
	
	ТаблицаКонтактов = Выборка.Выгрузить();
	Контакты = ТаблицаКонтактов.ВыгрузитьКолонку("Ссылка");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Контрагенты.Представление КАК Представление,
	|	СвязиКонтрагентКонтакт.Контакт КАК Контакт
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО (Контрагенты.Ссылка = СвязиКонтрагентКонтакт.Контрагент)
	|ГДЕ
	|	СвязиКонтрагентКонтакт.Контакт В(&Контакты)
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Контакты", Контакты);
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция ПредставлениеКонтакта(ПредставлениеЭлемента, Контакт, КонтрагентКонтакт)
	
	Контрагенты = КонтрагентКонтакт.НайтиСтроки(Новый Структура("Контакт", Контакт));
	
	СтрокаКонтрагентов = Новый Массив;
	Для Каждого Контрагент Из Контрагенты Цикл
		СтрокаКонтрагент = Строка(Контрагент.Представление);
		СтрокаКонтрагентов.Добавить(СтрокаКонтрагент);
	КонецЦикла;
	
	ПредставлениеКонтрагентов = ?(СтрокаКонтрагентов.Количество()>0, "(Контрагенты: " + СтрСоединить(СтрокаКонтрагентов, ", "), "(<нет связей>") + ")";
	ПредставлениеКонтакта = Новый ФорматированнаяСтрока(ПредставлениеЭлемента," ", ПредставлениеКонтрагентов);
	
	Возврат ПредставлениеКонтакта;
	
КонецФункции

Функция ТекстЗапросаКонтактыПоАдресуЭПНомеруТелефона()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 10
	|	СвязиКонтрагентКонтакт.Контрагент КАК Ссылка,
	|	ВЫБОР
	|		КОГДА КонтактныеЛица.АдресЭПДляПоиска ПОДОБНО &СтрокаПоиска
	|			ТОГДА КонтактныеЛица.АдресЭПДляПоиска + "" ("" + Контрагенты.Наименование + "")""
	|		КОГДА КонтактныеЛица.НомерТелефонаДляПоиска ПОДОБНО &СтрокаПоиска
	|				ИЛИ КонтактныеЛица.НомерТелефонаДляПоиска ПОДОБНО &НомерТелефонаДляПоиска
	|			ТОГДА КонтактныеЛица.НомерТелефонаДляПоиска + "" ("" + Контрагенты.Наименование + "")""
	|		ИНАЧЕ Контрагенты.Наименование
	|	КОНЕЦ КАК Представление,
	|	"""" КАК Организация,
	|	1 КАК Порядок
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО СвязиКонтрагентКонтакт.Контакт = КонтактныеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО СвязиКонтрагентКонтакт.Контрагент = Контрагенты.Ссылка
	|ГДЕ
	|	(КонтактныеЛица.АдресЭПДляПоиска ПОДОБНО &СтрокаПоиска
	|			ИЛИ КонтактныеЛица.НомерТелефонаДляПоиска ПОДОБНО &СтрокаПоиска
	|			ИЛИ КонтактныеЛица.НомерТелефонаДляПоиска ПОДОБНО &НомерТелефонаДляПоиска)
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ
	|	И КонтактныеЛица.Недействителен = ЛОЖЬ";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли