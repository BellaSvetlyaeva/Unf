#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьДоступность();
	ВосстановитьНастройкиФормы();
	ЗаполнитьДанныеФормы();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОтборОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("РежимБезМестХранения", Истина);
	
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", "Отбор",
		ОповещениеВыбораОрганизаций(),, ПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("РежимБезМестХранения", Истина);
	
	ИнтеграцияСАТУРНКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", "Отбор",
		ОповещениеВыбораОрганизаций(),, ПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Ложь, "Отбор", "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Истина, Ложь, "Отбор", "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор", "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор", "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ОрганизацииСАТУРН, Ложь, "Отбор", "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияСАТУРНКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ОрганизацияСАТУРН, Ложь, "Отбор", "Отбор");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВремяПоследнегоВыполненияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполнитьДействие(НавигационнаяСсылкаФорматированнойСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполнитьДействие(НавигационнаяСсылкаФорматированнойСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииБезНастроекНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ОрганизацииСАТУРНБезНастроек.Количество() > 0 Тогда
		ОрганизацииСАТУРНБезНастроек.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения("ПослеВыбораОрганизацииБезНастроек", ЭтотОбъект),
			НСтр("ru = 'Создать настройку'"),
			ОрганизацииСАТУРНБезНастроек[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаНастроек

&НаКлиенте
Процедура ТаблицаНастроекПриАктивизацииСтроки(Элемент)
	
	ТаблицаНастроекАктивизацияСтроки();	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	
	Если Элементы.ТаблицаНастроек.ТекущийЭлемент = Элементы.ТаблицаНастроекНастройкаОбмена Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("НастройкаОбмена", ТекущиеДанные.НастройкаОбмена);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершениеРедактированияНастройкиОбмена",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.НастройкаОбмена);
		
		ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийСАТУРН.Форма.ФормаЭлемента",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли Элементы.ТаблицаНастроек.ТекущийЭлемент = Элементы.ТаблицаНастроекРасписаниеСтрокой Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущиеДанные.Расписание);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
		
		ДиалогРасписания.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект, ДополнительныеПараметры));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ДополнительныеПараметры = Неопределено;
	Иначе
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("НастройкаОбмена", ТекущиеДанные.НастройкаОбмена);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеРедактированияНастройкиОбмена",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийСАТУРН.Форма.ФормаЭлемента",,
		ЭтотОбъект,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.ПометкаУдаления Тогда
			ТекстВопроса = СтрШаблон(НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
				ТекущиеДанные.НастройкаОбмена);
		Иначе
			ТекстВопроса = СтрШаблон(НСтр("ru = 'Пометить ""%1"" на удаление?'"),
				ТекущиеДанные.НастройкаОбмена);
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("НастройкаОбмена", ТекущиеДанные.НастройкаОбмена);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОтветНаВопросПриИзмененииПометкиУдаления",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекИспользованиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Использование = ТекущиеДанные.Использование;
	ТекущиеДанные.Использование = Не Использование;
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(ТекущиеДанные);
	
	УстановитьИспользованиеИндивидуальныхНастроек(МассивСтрок, Использование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДанныеФормы(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ТекущаяНастройкаОбмена = Неопределено;
	Иначе
		ТекущаяНастройкаОбмена = ТекущиеДанные.НастройкаОбмена;
	КонецЕсли;
	
	ЗаполнитьДанныеФормы();
	
	Если ТекущаяНастройкаОбмена <> Неопределено Тогда
		УстановитьТекущуюСтрокуНастроек(ТекущаяНастройкаОбмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьИспользованиеРегламентныхЗаданий(Команда)
	
	ВыделенныеСтроки = Элементы.ТаблицаНастроек.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьИспользованиеИндивидуальныхНастроек(ВыделенныеСтроки, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьИспользованиеРегламентныхЗаданий(Команда)
	
	ВыделенныеСтроки = Элементы.ТаблицаНастроек.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьИспользованиеИндивидуальныхНастроек(ВыделенныеСтроки, Ложь);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекИспользование.Имя);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекРасписаниеСтрокой.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекПометкаУдаления.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекСостояние.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекСостояниеОшибка.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	РедактированиеНастроекРегламентныхЗаданий = ПравоДоступа(
		"Редактирование", Метаданные.Справочники.НастройкиРегламентныхЗаданийСАТУРН);
	
	Если Не РедактированиеНастроекРегламентныхЗаданий Тогда
		Элементы.ТаблицаНастроек.ТолькоПросмотр = Истина;
		Элементы.ТаблицаНастроекРасписаниеСтрокой.Доступность = Ложь;
		Элементы.ТаблицаНастроекВключитьИспользованиеРегламентныхЗаданий.Доступность = Ложь;
		Элементы.ТаблицаНастроекОтключитьИспользованиеРегламентныхЗаданий.Доступность = Ложь;
		Элементы.Действия.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#Область ДействияСНастройкамиФормы

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	СтруктураОтбораОрганизаций = ИнтеграцияСАТУРНКлиентСервер.СтруктураОтбораОрганизаций(ОрганизацииСАТУРН, Неопределено, Ложь);
	СтруктураОтбораОрганизаций.Организация = ОрганизацияСАТУРН;
	СтруктураОтбораОрганизаций.Представление = ОрганизацииСАТУРНПредставление;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкиРегламентныхЗаданийСАТУРН", "СтруктураОтбораОрганизаций", СтруктураОтбораОрганизаций);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	СтруктураОтбораОрганизаций = Неопределено;
	Параметры.Свойство("СтруктураОтбораОрганизаций", СтруктураОтбораОрганизаций);
	
	Если СтруктураОтбораОрганизаций = Неопределено Тогда
		СтруктураОтбораОрганизаций = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиРегламентныхЗаданийСАТУРН", "СтруктураОтбораОрганизаций");
	КонецЕсли;
	
	Если СтруктураОтбораОрганизаций = Неопределено Тогда
		ИнтеграцияСАТУРНКлиентСервер.НастроитьОтборПоОрганизации(ЭтотОбъект, , "Отбор", "Отбор");
	Иначе
		ИнтеграцияСАТУРНКлиентСервер.НастроитьОтборПоОрганизации(ЭтотОбъект, СтруктураОтбораОрганизаций, "Отбор", "Отбор");
	КонецЕсли;
	
	СобытияФормСАТУРН.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

#КонецОбласти

#Область ОтборПоОрганизации

&НаКлиенте
Функция ОповещениеВыбораОрганизаций()
	
	Возврат Новый ОписаниеОповещения("ПослеВыбораОрганизации", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораОрганизации(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбновлениеДанныхФормы();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВыполнитьОбновлениеДанныхФормы()
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ТекущаяНастройкаОбмена = Неопределено;
	Иначе
		ТекущаяНастройкаОбмена = ТекущиеДанные.НастройкаОбмена;
	КонецЕсли;
	
	ЗаполнитьДанныеФормы();
	СохранитьНастройкиФормы();
	
	Если ТекущаяНастройкаОбмена <> Неопределено Тогда
		УстановитьТекущуюСтрокуНастроек(ТекущаяНастройкаОбмена);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормы()
	
	ТаблицаНастроек.Очистить();
	
	ДанныеРегламентныхЗаданий = ОбменДаннымиСАТУРН.ДанныеРегламентныхЗаданий();
	
	ДопустимоеВремяВыполнения = ОбменДаннымиСАТУРН.ДопустимоеВремяВыполненияРегламентногоЗаданияПоНастройкеОбмена();
	
	Запрос = ОбменДаннымиСАТУРН.ЗапросНастроекРегламентыхЗаданий(
		ИнтеграцияСАТУРНКлиентСервер.СтруктураОтбораОрганизаций(ОрганизацииСАТУРН, Неопределено, Ложь));
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВГраница = РезультатЗапроса.ВГраница();
	
	Выборка = РезультатЗапроса[ВГраница].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТаблицы = ТаблицаНастроек.Добавить();
		СтрокаТаблицы.НастройкаОбмена                = Выборка.Настройка;
		СтрокаТаблицы.Организация                    = Выборка.Организация;
		СтрокаТаблицы.ПометкаУдаления                = Выборка.ПометкаУдаления;
		СтрокаТаблицы.ДатаНачалаПоследнегоВыполнения = Выборка.ДатаНачалаВыполнения;
		СтрокаТаблицы.ВремяПоследнегоВыполнения      = Выборка.ВремяВыполнения;
		СтрокаТаблицы.ВидНастройкиОбмена             = Выборка.ВидНастройкиОбмена;
		Если ЗначениеЗаполнено(Выборка.РегламентноеЗадание) Тогда
			ДанныеРегламентногоЗадания = ДанныеРегламентныхЗаданий[Выборка.РегламентноеЗадание];
		Иначе
			ДанныеРегламентногоЗадания = Неопределено;
		КонецЕсли;
		Если ДанныеРегламентногоЗадания = Неопределено Тогда
			СтрокаТаблицы.Расписание = Новый РасписаниеРегламентногоЗадания;
		Иначе
			СтрокаТаблицы.РегламентноеЗадание = Выборка.РегламентноеЗадание;
			СтрокаТаблицы.Использование       = ДанныеРегламентногоЗадания.Использование;
			СтрокаТаблицы.Расписание          = ДанныеРегламентногоЗадания.Расписание;
		КонецЕсли;
		СтрокаТаблицы.РасписаниеСтрокой = Строка(СтрокаТаблицы.Расписание);
		
		Если Выборка.ПометкаУдаления
			И Выборка.ПометкаУдаленияОрганизация Тогда
			СтрокаТаблицы.Состояние = НСтр("ru = 'Организация и регламентное задание помечены на удаление'");
			СтрокаТаблицы.Действия.Добавить("СнятьПометкуУдаленияОрганизацииИНастройки");
		ИначеЕсли Выборка.ПометкаУдаленияОрганизация Тогда
			СтрокаТаблицы.Состояние = НСтр("ru = 'Организация помечена на удаление'");
			СтрокаТаблицы.СостояниеОшибка = Истина;
			СтрокаТаблицы.Действия.Добавить("СнятьПометкуУдаленияОрганизации");
			СтрокаТаблицы.Действия.Добавить("ПометитьНаУдалениеНастройку");
		ИначеЕсли Выборка.ПометкаУдаления Тогда
			СтрокаТаблицы.Состояние = НСтр("ru = 'Регламентное задание помечено на удаление'");
			СтрокаТаблицы.Действия.Добавить("СнятьПометкуУдаленияНастройкиИВключитьРегламентноеЗадание");
		ИначеЕсли Не СтрокаТаблицы.Использование Тогда
			СтрокаТаблицы.Состояние = НСтр("ru = 'Регламентное задание отключено'");
			СтрокаТаблицы.СостояниеОшибка = Истина;
			СтрокаТаблицы.Действия.Добавить("ВключитьРегламентноеЗадание");
		ИначеЕсли Выборка.ВремяВыполнения > ДопустимоеВремяВыполнения Тогда
			СтрокаТаблицы.Состояние = СтрШаблон(
				НСтр("ru = 'Последний обмен выполнялся длительное время - %1'"),
				ПредставлениеВремениВыполнения(Выборка.ВремяВыполнения));
		КонецЕсли;
		
	КонецЦикла;
	
	ОрганизацииСАТУРНБезНастроек.Очистить();
	Выборка = РезультатЗапроса[ВГраница - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОрганизацияБезНастроек = ОрганизацииСАТУРНБезНастроек.Добавить();
		ОрганизацияБезНастроек.Представление = Выборка.ОрганизацияПредставление;
		ОрганизацияБезНастроек.Значение      = Выборка.Организация;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИспользованиеИндивидуальныхНастроек(МассивСтрок, Использование)
	
	ОчиститьСообщения();
	
	СоответствиеСтрок                    = Новый Соответствие;
	ОбновитьПовторноИспользуемыеЗначения = Истина;
	ДанныеОповещенийИзмененаНастройка    = Новый Массив;
	
	Для Каждого Строка Из МассивСтрок Цикл
		
		Если ТипЗнч(Строка) = Тип("ДанныеФормыЭлементКоллекции") Тогда
			ДанныеСтроки = Строка;
			ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		Иначе
			ИдентификаторСтроки = Строка;
			ДанныеСтроки = ТаблицаНастроек.НайтиПоИдентификатору(ИдентификаторСтроки);
			Если ДанныеСтроки = Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Использование
			И ДанныеСтроки.ПометкаУдаления Тогда
			Продолжить;
		ИначеЕсли ДанныеСтроки.Использование <> Использование
			Или Не ЗначениеЗаполнено(ДанныеСтроки.РегламентноеЗадание) Тогда
			СтруктураСтроки = Новый Структура;
			СтруктураСтроки.Вставить("НастройкаОбмена",     ДанныеСтроки.НастройкаОбмена);
			СтруктураСтроки.Вставить("РегламентноеЗадание", ДанныеСтроки.РегламентноеЗадание);
			СтруктураСтроки.Вставить("Расписание",          ДанныеСтроки.Расписание);
			СтруктураСтроки.Вставить("Использование",       Использование);
			СтруктураСтроки.Вставить("Обработан",           Ложь);
			СоответствиеСтрок.Вставить(ИдентификаторСтроки, СтруктураСтроки);
		КонецЕсли;
		
		Если ДанныеСтроки.ВидНастройкиОбмена = ПредопределенноеЗначение("Перечисление.ВидыНастроекОбменаСАТУРН.ОбменДанными") Тогда
			ПараметрыОповещения = Новый Структура();
			ПараметрыОповещения.Вставить("ВидНастройкиОбмена", ДанныеСтроки.ВидНастройкиОбмена);
			ПараметрыОповещения.Вставить("ОрганизацияСАТУРН",  ДанныеСтроки.Организация);
			ДанныеОповещенийИзмененаНастройка.Добавить(ПараметрыОповещения);
			ОбновитьПовторноИспользуемыеЗначения = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СоответствиеСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьИспользованиеИндивидуальныхНастроекСервер(СоответствиеСтрок);
	
	Для Каждого КлючИЗначение Из СоответствиеСтрок Цикл
		Если КлючИЗначение.Значение.Обработан Тогда
			ДанныеСтроки = ТаблицаНастроек.НайтиПоИдентификатору(КлючИЗначение.Ключ);
			Если ДанныеСтроки <> Неопределено Тогда
				Если Не ЗначениеЗаполнено(ДанныеСтроки.РегламентноеЗадание) Тогда
					ДанныеСтроки.РегламентноеЗадание = КлючИЗначение.Значение.РегламентноеЗадание;
				КонецЕсли;
				ДанныеСтроки.Использование = КлючИЗначение.Значение.Использование;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ТекущаяНастройкаОбмена = Неопределено;
	Иначе
		ТекущаяНастройкаОбмена = ТекущиеДанные.НастройкаОбмена;
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		ЗаполнитьДанныеФормы();
		Если ТекущаяНастройкаОбмена <> Неопределено Тогда
			УстановитьТекущуюСтрокуНастроек(ТекущаяНастройкаОбмена);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбновитьПовторноИспользуемыеЗначения Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Для Каждого ДанныеОповещения Из ДанныеОповещенийИзмененаНастройка Цикл
		Оповестить(
			СобытияФормСАТУРНКлиент.ИмяСобытияИзмененаНастройкаАвтоматическогоОбмена(),
			ДанныеОповещения,
			ЭтотОбъект);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИспользованиеИндивидуальныхНастроекСервер(СоответствиеСтрок)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого КлючИЗначение Из СоответствиеСтрок Цикл
		Попытка
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("Использование", КлючИЗначение.Значение.Использование);
			ПараметрыЗадания.Вставить("Расписание",    КлючИЗначение.Значение.Расписание);
			Если ЗначениеЗаполнено(КлючИЗначение.Значение.РегламентноеЗадание) Тогда
				РегламентныеЗаданияСервер.ИзменитьЗадание(КлючИЗначение.Значение.РегламентноеЗадание, ПараметрыЗадания);
			Иначе
				КлючИЗначение.Значение.РегламентноеЗадание = СоздатьРегламентноеЗаданиеПоНастройкеОбмена(
					КлючИЗначение.Значение.НастройкаОбмена,
					ПараметрыЗадания);
			КонецЕсли;
			КлючИЗначение.Значение.Обработан = Истина;
		Исключение
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
				НСтр("ru = 'При изменении признака использования регламентного задания для настройки обмена <%1> возникла ошибка: %2.'"),
				КлючИЗначение.Значение.НастройкаОбмена,
				ОписаниеОшибки()));
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьРегламентноеЗаданиеПоНастройкеОбмена(НастройкаОбмена, ПараметрыЗадания)
	
	Объект = НастройкаОбмена.ПолучитьОбъект();
	Объект.ДополнительныеСвойства.Вставить("Расписание",    Новый РасписаниеРегламентногоЗадания);
	Объект.ДополнительныеСвойства.Вставить("Использование", Ложь);
	ЗаполнитьЗначенияСвойств(Объект.ДополнительныеСвойства, ПараметрыЗадания);
	Объект.Записать();
	
	Возврат Объект.РегламентноеЗадание;
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеРедактированияНастройкиОбмена(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьДанныеФормы();
	
	Если ДополнительныеПараметры <> Неопределено
		И ЗначениеЗаполнено(ДополнительныеПараметры.НастройкаОбмена) Тогда
		УстановитьТекущуюСтрокуНастроек(ДополнительныеПараметры.НастройкаОбмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтрокуНастроек(НастройкаОбмена)
	
	Для Каждого Строка Из ТаблицаНастроек Цикл
		Если Строка.НастройкаОбмена = НастройкаОбмена Тогда
			Элементы.ТаблицаНастроек.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросПриИзмененииПометкиУдаления(ОтветНаВопрос, ДополнительныеПараметры) Экспорт

	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ИзменитьПометкуУдаления(ДополнительныеПараметры.НастройкаОбмена);
		ЗаполнитьДанныеФормы();
		УстановитьТекущуюСтрокуНастроек(ДополнительныеПараметры.НастройкаОбмена);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьПометкуУдаления(Данные)
	
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		Массив = Данные;
	Иначе
		Массив = Новый Массив;
		Массив.Добавить(Данные);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Для Каждого Ссылка Из Массив Цикл
			Объект = Ссылка.ПолучитьОбъект();
			Объект.УстановитьПометкуУдаления(Не Объект.ПометкаУдаления);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		
		Строка = ТаблицаНастроек.НайтиПоИдентификатору(ДополнительныеПараметры.ВыбраннаяСтрока);
		Если Строка <> Неопределено Тогда
			Если Не ЗначениеЗаполнено(Строка.РегламентноеЗадание) Тогда
				МассивСтрок = Новый Массив;
				МассивСтрок.Добавить(Строка);
				УстановитьИспользованиеИндивидуальныхНастроек(МассивСтрок, Строка.Использование);
			КонецЕсли;
			УстановитьРасписаниеРегламентногоЗадания(Строка.РегламентноеЗадание, Расписание);
			Строка.Расписание = Расписание;
			Строка.РасписаниеСтрокой = Строка(Расписание);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьРасписаниеРегламентногоЗадания(РегламентноеЗадание, Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание, ПараметрыЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекАктивизацияСтроки()
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.Действия.Количество() = 0 Тогда
		Действия = Новый ФорматированнаяСтрока("");
	Иначе
		МассивСтрок = Новый Массив;
		Для Каждого ЭлементДействия Из ТекущиеДанные.Действия Цикл
			Если МассивСтрок.Количество() > 0 Тогда
				МассивСтрок.Добавить(Символы.ПС);
			КонецЕсли;
			ДобавитьДействие(МассивСтрок, ЭлементДействия);
		КонецЦикла;
		Действия = Новый ФорматированнаяСтрока(МассивСтрок);
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.ВремяПоследнегоВыполнения = 0 Тогда
		ВремяПоследнегоВыполнения = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Регламентное задание еще не выполнялось'"));
	Иначе
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(СтрШаблон(
			НСтр("ru = 'Последний запуск %1. Время выполнения %2'"),
			ТекущиеДанные.ДатаНачалаПоследнегоВыполнения,
			ПредставлениеВремениВыполнения(ТекущиеДанные.ВремяПоследнегоВыполнения)));
		МассивСтрок.Добавить(" - ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'История выполнения'"),,,,
			"ОткрытьИсториюВыполненияПоНастройке"));
			
		ВремяПоследнегоВыполнения = Новый ФорматированнаяСтрока(МассивСтрок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеВремениВыполнения(ВремяВыполнения)
	
	Если ВремяВыполнения > 0 Тогда
		Если ВремяВыполнения < 60 Тогда
			Результат = НСтр("ru = 'менее минуты'");
		ИначеЕсли ВремяВыполнения > 86400 Тогда
			Результат = НСтр("ru = 'более суток'");
		ИначеЕсли ВремяВыполнения < 3600 Тогда
			Результат = СтрШаблон(
				НСтр("ru = '%1 мин.'"),
				Цел(ВремяВыполнения / 60));
		Иначе
			Результат = СтрШаблон(
				НСтр("ru = '%1 ч. %2 мин.'"),
				Цел(ВремяВыполнения / 3600),
				Цел((ВремяВыполнения % 3600) / 60));
		КонецЕсли;
	Иначе
		Результат = НСтр("ru = 'неизвестно'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьДействие(МассивСтрок, ЭлементДействия)
	
	Если ЭлементДействия.Значение = "СнятьПометкуУдаленияОрганизацииИНастройки" Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Снять пометку удаления с организации и настройки регламентного задания'"),,,,
			ЭлементДействия.Значение));
	ИначеЕсли ЭлементДействия.Значение = "СнятьПометкуУдаленияОрганизации" Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Снять пометку удаления с организации'"),,,,
			ЭлементДействия.Значение));
	ИначеЕсли ЭлементДействия.Значение = "СнятьПометкуУдаленияНастройкиИВключитьРегламентноеЗадание" Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Снять пометку удаления с настройки и включить регламентное задание'"),,,,
			ЭлементДействия.Значение));
	ИначеЕсли ЭлементДействия.Значение = "ПометитьНаУдалениеНастройку" Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Пометить на удаление настройку регламентного задания'"),,,,
			ЭлементДействия.Значение));
	ИначеЕсли ЭлементДействия.Значение = "ВключитьРегламентноеЗадание" Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Включить регламентное задание'"),,,,
			ЭлементДействия.Значение));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействие(ТекущееДействие)
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущееДействие = "СнятьПометкуУдаленияОрганизацииИНастройки" Тогда
		
		Массив = Новый Массив;
		Массив.Добавить(ТекущиеДанные.Организация);
		Массив.Добавить(ТекущиеДанные.НастройкаОбмена);
		
		ИзменитьПометкуУдаления(Массив);
		ЗаполнитьДанныеФормы();
		УстановитьТекущуюСтрокуНастроек(ТекущиеДанные.НастройкаОбмена);
		
	ИначеЕсли ТекущееДействие = "СнятьПометкуУдаленияОрганизации" Тогда
		
		ИзменитьПометкуУдаления(ТекущиеДанные.Организация);
		ЗаполнитьДанныеФормы();
		УстановитьТекущуюСтрокуНастроек(ТекущиеДанные.НастройкаОбмена);
		
	ИначеЕсли ТекущееДействие = "СнятьПометкуУдаленияНастройкиИВключитьРегламентноеЗадание" Тогда
		
		ИзменитьПометкуУдаления(ТекущиеДанные.НастройкаОбмена);
		
		ТекущиеДанные.ПометкаУдаления = Ложь;
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(ТекущиеДанные);
		
		УстановитьИспользованиеИндивидуальныхНастроек(МассивСтрок, Истина);
		
	ИначеЕсли ТекущееДействие = "ПометитьНаУдалениеНастройку" Тогда
		
		ИзменитьПометкуУдаления(ТекущиеДанные.НастройкаОбмена);
		ЗаполнитьДанныеФормы();
		УстановитьТекущуюСтрокуНастроек(ТекущиеДанные.НастройкаОбмена);
		
	ИначеЕсли ТекущееДействие = "ВключитьРегламентноеЗадание" Тогда
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(ТекущиеДанные);
		
		УстановитьИспользованиеИндивидуальныхНастроек(МассивСтрок, Истина);
		
	ИначеЕсли ТекущееДействие = "ОткрытьИсториюВыполненияПоНастройке" Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Отбор", Новый Структура);
		ПараметрыОткрытия.Отбор.Вставить("НастройкаРегламентногоЗадания", ТекущиеДанные.НастройкаОбмена);
		
		ОткрытьФорму("РегистрСведений.ИсторияВыполненияОбменовССАТУРН.ФормаСписка",
			ПараметрыОткрытия,
			ЭтотОбъект,
			ТекущиеДанные.НастройкаОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОрганизацииБезНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ТаблицаНастроек.ТекущиеДанные;
	
	ДополнительныеПараметры = Новый Структура;
	Если ТекущиеДанные = Неопределено Тогда
		ДополнительныеПараметры.Вставить("НастройкаОбмена", Неопределено);
	Иначе
		ДополнительныеПараметры.Вставить("НастройкаОбмена", ТекущиеДанные.НастройкаОбмена);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеРедактированияНастройкиОбмена",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", Новый Структура);
	ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ОрганизацияСАТУРН", Результат.Значение);
	
	ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийСАТУРН.Форма.ФормаЭлемента",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
