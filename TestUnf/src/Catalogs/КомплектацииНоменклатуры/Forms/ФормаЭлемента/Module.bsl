
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьКэшЗначений();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// КомандыПечати
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	// Конец КомандыПечати
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиУНФ.ЗаполнитьДополнительныеПараметры(Объект, "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	ИспользоватьДопРеквизиты = (Константы.ИспользоватьДополнительныеРеквизитыИСведения.Получить() 
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "Свойства_ИспользоватьДопРеквизиты") 
		И ЭтотОбъект.Свойства_ИспользоватьДопРеквизиты);
	Если НЕ ИспользоватьДопРеквизиты Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	Если НЕ ИспользоватьДопРеквизиты Тогда
		Элементы.Дополнительно.Видимость = Ложь;
	КонецЕсли; 
	
	// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере(Метаданные.Справочники.КомплектацииНоменклатуры.ТабличныеЧасти.Состав, 
		НастройкиЗагрузкиДанных, ЭтотОбъект, Ложь);
	// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Состав");
	
	НастройкиКоличества = ПолучитьНастройкиИзмененияКоличества();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиКоличества);
		
	МобильныйКлиентУНФ.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьКэшЗначений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Состав");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	Параметр = Новый Структура("Ссылка, Недействителен", Объект.Ссылка, Объект.Недействителен);
	Оповестить("КомплектацииНоменклатурыЗаписана", Параметр, Объект.Владелец);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//Обсуждения
	ОбсужденияУНФ.ПослеЗаписиНаСервере(ТекущийОбъект);	
	// Конец Обсуждения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область Состав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого ЗначениеВыбора Из ВыбранноеЗначение Цикл
		
		СтруктураДанные = Новый Структура();
		
		Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
			Номенклатура = ЗначениеВыбора.Номенклатура;
			Характеристика = ЗначениеВыбора.Характеристика;
			СтруктураДанные.Вставить("Характеристика", Характеристика);
		Иначе
			Номенклатура = ЗначениеВыбора;
			Характеристика = Неопределено;
		КонецЕсли;
		
		СтруктураДанные.Вставить("Номенклатура", Номенклатура);
		СуществующиеСтроки = Объект.Состав.НайтиСтроки(СтруктураДанные);
		Если СуществующиеСтроки.Количество() <> 0 Тогда
			Для Каждого СтрокаТабличнойЧасти Из СуществующиеСтроки Цикл
				СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + 1;
			КонецЦикла;
			Продолжить;
		КонецЕсли; 
		
		НоваяСрока = Объект.Состав.Добавить();
		НоваяСрока.Номенклатура = Номенклатура;
		
		СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
		
		НоваяСрока.Характеристика = Характеристика;
		НоваяСрока.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
		НоваяСрока.Количество = 1;
		НоваяСрока.КоличествоПродукции = 1;
		НоваяСрока.ДоляСтоимости = 1;
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура СоставНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Состав.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗапрашиватьСбросКоличества И СбрасыватьКоличество
		И СтрокаТабличнойЧасти.Количество <> НовоеКоличествоПриИзмененииНоменклатуры Тогда
		
		ДопПараметр = Новый Структура();
		ДопПараметр.Вставить("Элемент", Элемент);
		ДопПараметр.Вставить("Количество", СтрокаТабличнойЧасти.Количество);
		Оповещение = Новый ОписаниеОповещения("СоставПодтверждениеСбросаКоличестваЗавершение", ЭтотОбъект, ДопПараметр);
		ОткрытьФорму("ОбщаяФорма.ПодтверждениеСбросаКоличества", , , , , , Оповещение);
		
	Иначе
		
		Если СбрасыватьКоличество Тогда
			НовоеКоличество = НовоеКоличествоПриИзмененииНоменклатуры;
		Иначе
			НовоеКоличество = СтрокаТабличнойЧасти.Количество;
		КонецЕсли;
		СоставНоменклатураПриИзмененииПродолжить(Элемент, НовоеКоличество);
		
	КонецЕсли;	
	
КонецПроцедуры // СоставНоменклатураПриИзменении()

&НаКлиенте
Процедура СоставПодтверждениеСбросаКоличестваЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗапрашиватьСбросКоличества = Результат.ЗапрашиватьСбросКоличества;
		Если НЕ ЗапрашиватьСбросКоличества Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		КонецЕсли;
		Если Результат.СбрасыватьКоличество Тогда
			НовоеКоличество = Результат.НовоеКоличествоПриИзмененииНоменклатуры;
		Иначе
			НовоеКоличество = ДополнительныеПараметры.Количество;
		КонецЕсли;
	Иначе
		НовоеКоличество = ДополнительныеПараметры.Количество;
	КонецЕсли;
	
	СоставНоменклатураПриИзмененииПродолжить(ДополнительныеПараметры.Элемент, НовоеКоличество);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставНоменклатураПриИзмененииПродолжить(Элемент, НовоеКоличество)

	СтрокаТабличнойЧасти = Элементы.Состав.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.Характеристика = Неопределено;
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Количество = НовоеКоличество;
	СтрокаТабличнойЧасти.КоличествоПродукции = 1;
	СтрокаТабличнойЧасти.ДоляСтоимости = 1;

КонецПроцедуры

&НаКлиенте
Процедура НедействителенПриИзменении(Элемент)
	
	Если Не Объект.Недействителен Тогда Возврат КонецЕсли;
	
	Если ЭлементОсновной() Тогда
		ПараметрыОповещения = Новый Структура();
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПредупрежденияНедействителен", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьПредупреждение(ОповещениеОЗакрытии, НСтр("ru = 'Для установки ""Недействителен"" необходимо снять свойство ""Основной"".'"), , НСтр("ru = 'Элемент выбран основным'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПредупрежденияНедействителен(Параметры) Экспорт
	Объект.Недействителен = Ложь;
КонецПроцедуры

#КонецОбласти 

&НаКлиенте
Процедура СоставПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	Если НоваяСтрока И НЕ Копирование Тогда
		СтрокаТабличнойЧасти.Количество = НовоеКоличествоПриИзмененииНоменклатуры;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ВладелецПриИзмененииСервер();		
	
КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииСервер()
	
	ЗаполнитьКэшЗначений();
	ОбновитьЭлементыДополнительныхРеквизитов();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборСостав(Команда)
	
	СтруктураОтбора = Новый Структура;
	Для каждого ПараметрВыбора Из Элементы.СоставНоменклатура.ПараметрыВыбора Цикл
		ИмяРеквизита = СтрЗаменить(ПараметрВыбора.Имя, "Отбор.", "");
		ЗначениеОтбора = ?(ТипЗнч(ПараметрВыбора.Значение) = Тип("ФиксированныйМассив"), Новый Массив(ПараметрВыбора.Значение), ПараметрВыбора.Значение);
		СтруктураОтбора.Вставить(ИмяРеквизита, ЗначениеОтбора); 
	КонецЦикла;
	СтруктураОткрытия = Новый Структура;
	СтруктураОткрытия.Вставить("Отбор", СтруктураОтбора);
	СтруктураОткрытия.Вставить("РежимВыбора", Истина);
	СтруктураОткрытия.Вставить("ЗакрыватьПриВыборе", Ложь);
	СтруктураОткрытия.Вставить("МножественныйВыбор", Истина);
	Если Элементы.Состав.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Состав.ТекущиеДанные.Номенклатура) Тогда
		СтруктураОткрытия.Вставить("ТекущаяСтрока", Элементы.Состав.ТекущиеДанные.Номенклатура);
	КонецЕсли; 
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", СтруктураОткрытия, Элементы.Состав, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = ПараметрыСозданияДопРеквизита();
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСбросаКоличества(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СтрокаПоиска", НСтр("ru = 'Сбрасывать количество при изменении номенклатуры'"));
	Оповещение = Новый ОписаниеОповещения("НастройкаСбросаКоличестваЗавершение", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.НастройкиПользователей.Форма.ФормаНастройкиПользователя", СтруктураПараметров, , , , ,
		Оповещение);
	
	СтатистикаИспользованияФормКлиент.ПриИнтерактивномДействии(ЭтотОбъект, 
		Элементы.СоставКонтекстноеМенюНастройкаСбросаКоличества, "Нажатие");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСбросаКоличестваЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НастройкиКоличества = ПолучитьНастройкиИзмененияКоличества();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиКоличества);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭлементОсновной()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КомплектацииПоУмолчанию.Комплектация КАК Комплектация
	|ИЗ
	|	РегистрСведений.КомплектацииПоУмолчанию КАК КомплектацииПоУмолчанию
	|ГДЕ
	|	КомплектацииПоУмолчанию.Комплектация = &Ссылка";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

&НаСервере
Функция ПараметрыСозданияДопРеквизита()
	
	ПараметрыФормы = Новый Структура;
	
	ТекущийНаборСвойств = Неопределено;
	Если ЗначениеЗаполнено(КэшЗначений.КатегорияНоменклатуры) Тогда
		ТекущийНаборСвойств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КэшЗначений.КатегорияНоменклатуры,
			"НаборСвойствКомплектацииНоменклатуры");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекущийНаборСвойств) Тогда
		ТекущийНаборСвойств = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_КомплектацииНоменклатуры_Общие");
	КонецЕсли; 
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("КатегорияНоменклатуры", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "КатегорияНоменклатуры"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройкиИзмененияКоличества()
	
	НастройкиКоличества = ДокументыУНФКлиентСервер.ПараметрыСбросаКоличества();
	ДокументыУНФ.ЗаполнитьНастройкиКоличества(НастройкиКоличества);
	Возврат НастройкиКоличества;
	
КонецФункции

#КонецОбласти 

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла
&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточника(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
	
	ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗагрузки) = Тип("Структура") Тогда
		
		Если РезультатЗагрузки.ОписаниеДействия = "ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника" Тогда
			
			ЗагрузкаДанныхИзВнешнегоИсточника.ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
			ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
			
		ИначеЕсли РезультатЗагрузки.ОписаниеДействия = "ОбработатьПодготовленныеДанные" Тогда
			
			ТаблицаСопоставленияДанных = РезультатЗагрузки.ТаблицаСопоставленияДанных;
			Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
				
				Если СтрокаТаблицы[ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна()] Тогда
					
					ЗаполнитьЗначенияСвойств(Объект.Состав.Добавить(), СтрокаТаблицы);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура СоставКопироватьСтроки(Команда)
	
	КопироватьСтроки("Состав", "Состав");
	
КонецПроцедуры

&НаКлиенте
Процедура СоставВставитьСтроки(Команда)
	
	ВставитьСтроки("Состав", "Состав");
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСтроки(ИмяТЧ, ИмяЭлемента)
	
	Если КопированиеТабличнойЧастиКлиент.МожноКопироватьСтроки(Объект[ИмяТЧ], Элементы[ИмяЭлемента].ТекущиеДанные) Тогда
		КоличествоСкопированных = 0;
		КопироватьСтрокиНаСервере(ИмяТЧ, ИмяЭлемента, КоличествоСкопированных);
		КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(ИмяТЧ, ИмяЭлемента)
	
	ИмяТабличнойЧасти = ИмяТЧ;
	КоличествоСкопированных = 0;
	КоличествоВставленных = 0;
	ВставитьСтрокиНаСервере(ИмяТЧ, ИмяЭлемента, КоличествоСкопированных, КоличествоВставленных);
	ОбработатьВставленныеСтроки(ИмяТЧ, ИмяЭлемента, КоличествоВставленных);
	КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура КопироватьСтрокиНаСервере(ИмяТЧ, ИмяЭлемента, КоличествоСкопированных)
	
	КопированиеТабличнойЧастиСервер.Копировать(Объект[ИмяТЧ], Элементы[ИмяЭлемента].ВыделенныеСтроки, КоличествоСкопированных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьСтрокиНаСервере(ИмяТЧ, ИмяЭлемента, КоличествоСкопированных, КоличествоВставленных)
	
	ИмяТЧ = Новый Структура("ИмяТЧ, ИмяЭлемента", ИмяТЧ, ИмяЭлемента);
	КопированиеТабличнойЧастиСервер.Вставить(Объект, ИмяТЧ, Элементы, КоличествоСкопированных, КоличествоВставленных);
	ОбработатьВставленныеСтрокиНаСервере(ИмяТЧ, ИмяЭлемента, КоличествоВставленных);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВставленныеСтроки(ИмяТЧ, ИмяЭлемента, КоличествоВставленных)
	
	Количество = Объект[ИмяТЧ].Количество();
	
	Для Итератор = 1 По КоличествоВставленных Цикл
		
		Строка = Объект[ИмяТЧ][Количество - Итератор];
		Если НЕ ЗначениеЗаполнено(Строка.КоличествоПродукции) Тогда
			Строка.КоличествоПродукции = 1;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Строка.ДоляСтоимости) Тогда
			Строка.ДоляСтоимости = 1;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Строка.Количество) Тогда
			Строка.Количество = 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВставленныеСтрокиНаСервере(ИмяТЧ, ИмяЭлемента, КоличествоВставленных)
	
	Количество = Объект[ИмяТЧ].Количество();
	
	Для Итератор = 1 По КоличествоВставленных Цикл
		
		Строка = Объект[ИмяТЧ][Количество - Итератор];
		
		СтруктураДанные = Новый Структура;
		СтруктураДанные.Вставить("Номенклатура", Строка.Номенклатура);
		
		СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
		
		Если НЕ ЗначениеЗаполнено(Строка.ЕдиницаИзмерения) Тогда
			Строка.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

