#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РегистрыСведений.ПользователиСЭДО.ДобавитьТекущегоПользователя();
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Организация = Параметры.Организация;
	Если ЗначениеЗаполнено(Организация) Тогда
		Организации.Добавить(Организация);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	ПоказыватьОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая");
	Если ПоказыватьОрганизации Тогда
		ЗаполнитьСписокВыбораГоловныхОрганизаций();
		Количество = Элементы.ГоловнаяОрганизация.СписокВыбора.Количество();
		Если Количество > 1 И ЕстьФилиалы() Тогда
			ПоказыватьГоловныеОрганизации = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтборОрганизацияГруппа.Видимость = Ложь;
		Элементы.ОтборОрганизацииГруппа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПоказыватьГоловныеОрганизации Тогда
		Элементы.ОтборГоловнаяОрганизацияГруппа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияБЗК.ЕстьСохраненныеНастройкиФормы(ЭтотОбъект) Тогда
		ПослеЗагрузкиВсехНастроекФормыНаСервере();
	КонецЕсли;
	
	СЭДОФСС.ПриСозданииФормыЗапросаИлиОтветаДляРасчетаПособия(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	// Организации загружаются только в том случае, если они видны и отсутствуют в предустановленных (контекстных) фильтрах.
	Если ПоказыватьОрганизации И Не ЗначениеЗаполнено(ГоловнаяОрганизация) И Организации.Количество() = 0 Тогда
		Если ПоказыватьГоловныеОрганизации Тогда
			ГоловнаяОрганизация = Настройки["ГоловнаяОрганизация"];
		КонецЕсли;
		ИспользоватьСписокОрганизаций = Настройки["ИспользоватьСписокОрганизаций"];
		// Представления могли измениться, поэтому в список загружаются только значения.
		ОрганизацииИзНастроек = Настройки["Организации"];
		Если ТипЗнч(ОрганизацииИзНастроек) = Тип("СписокЗначений") Тогда
			Организации.ЗагрузитьЗначения(ОрганизацииИзНастроек.ВыгрузитьЗначения());
		КонецЕсли;
		СписокОрганизацийДляВыбораИзНастроек = Настройки["СписокОрганизацийДляВыбора"];
		Если ТипЗнч(СписокОрганизацийДляВыбораИзНастроек) = Тип("СписокЗначений") Тогда
			СписокОрганизацийДляВыбора.ЗагрузитьЗначения(СписокОрганизацийДляВыбораИзНастроек.ВыгрузитьЗначения());
		КонецЕсли;
		Если Не ИспользоватьСписокОрганизаций И Организации.Количество() > 0 Тогда
			Организация = Организации[0].Значение;
		КонецЕсли;
	КонецЕсли;
	Настройки.Удалить("Организация");
	Настройки.Удалить("Организации");
	Настройки.Удалить("СписокОрганизацийДляВыбора");
	Настройки.Удалить("ГоловнаяОрганизация");
	Настройки.Удалить("ИспользоватьСписокОрганизаций");
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПослеЗагрузкиВсехНастроекФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ВходящийЗапросФССДляРасчетаПособия"
		Или ИмяСобытия = "Запись_ОтветНаЗапросФССДляРасчетаПособия"
		Или ИмяСобытия = "Запись_РегистрацииОтветовНаЗапросыФССДляРасчетаПособий"
		Или ИмяСобытия = "Запись_БольничныйЛист"
		Или ИмяСобытия = "Запись_ОтпускПоУходуЗаРебенком"
		Или ИмяСобытия = "Запись_Отпуск"
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		ПодключитьОбработчикОбновленияФормы();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГоловнаяОрганизацияПриИзменении(Элемент)
	Организация = Неопределено;
	Организации.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Организации.Очистить();
	Если ЗначениеЗаполнено(Организация) Тогда
		Организации.Добавить(Организация);
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьОрганизации();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьНасколькоФилиалов(Команда)
	Организации.Очистить();
	Если ЗначениеЗаполнено(Организация) Тогда
		Организации.Добавить(Организация);
	КонецЕсли;
	ВыбратьОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокФилиалов(Команда)
	Организации.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКВыборуОдногоФилиала(Команда)
	ИспользоватьСписокОрганизаций = Ложь;
	Если Организации.Количество() > 0 Тогда
		Организация = Организации[0].Значение;
	Иначе
		Организация = Неопределено;
	КонецЕсли;
	ОрганизацияПриИзменении(Неопределено);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ВходящийЗапросФССДляРасчетаПособия", Новый Структура, Неопределено);
	СЭДОФССКлиент.ОповеститьОНеобходимостиОбновитьТекущиеДела();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область РасширениеСобытийФормы

&НаСервере
Процедура ПослеЗагрузкиВсехНастроекФормыНаСервере()
	Если ПоказыватьОрганизации Тогда
		Если Не ЗначениеЗаполнено(Организация) Тогда
			ЗначенияДляЗаполнения = Новый Структура("Организация", "Организация");
			ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
			Если ЗначениеЗаполнено(Организация) Тогда
				Организации.Добавить(Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Форма

&НаКлиенте
Процедура ПодключитьОбработчикОбновленияФормы()
	ОтключитьОбработчикОжидания("ОбновитьФормуНаКлиенте");
	ПодключитьОбработчикОжидания("ОбновитьФормуНаКлиенте", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФормуНаКлиенте()
	ОбновитьФорму();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораГоловныхОрганизаций()
	СписокВыбора = Элементы.ГоловнаяОрганизация.СписокВыбора;
	СписокВыбора.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Значение,
	|	Организации.Представление КАК Представление
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = Организации.ГоловнаяОрганизация";
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(СписокВыбора.Добавить(), СтрокаТаблицы);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму()
	ОбновитьЭлементыФормы();
	ОбновитьПараметрыСписка();
	ОбновитьНадписьСообщенияОжидаемыеОтФСС();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	
	Если Не ПоказыватьОрганизации Тогда
		Возврат;
	КонецЕсли;
	
	СвязиПараметровВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.ГоловнаяОрганизация", "ГоловнаяОрганизация"));
	КонецЕсли;
	Элементы.Организация.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	
	Если ИспользоватьСписокОрганизаций Тогда
		Элементы.ОтборОрганизацияГруппа.Видимость       = Ложь;
		Элементы.ОтборОрганизацииГруппа.Видимость = Истина;
		ПредставлениеСписка = СЭДОФСС.ПредставлениеСписка(Организации, 100);
		Если ПустаяСтрока(ПредставлениеСписка) Тогда
			ПредставлениеСписка = НСтр("ru = '<Все>'");
			Элементы.ОчиститьСписокФилиалов.Видимость = Ложь;
		Иначе
			Элементы.ОчиститьСписокФилиалов.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтборОрганизацияГруппа.Видимость       = Истина;
		Элементы.ОтборОрганизацииГруппа.Видимость = Ложь;
		ПредставлениеСписка = "";
	КонецЕсли;
	Элементы.ФилиалыПредставление.Заголовок = ПредставлениеСписка;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьСообщенияОжидаемыеОтФСС()
	КоличествоОжидаемыхСообщений = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.КоличествоОжидаемыхСообщений(
		ГоловнаяОрганизация,
		Организации.ВыгрузитьЗначения());
	Если КоличествоОжидаемыхСообщений = 0 Тогда
		Элементы.ГруппаСообщенияОжидаемыеОтФСС.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСообщенияОжидаемыеОтФСС.Видимость = Истина;
		Элементы.НадписьСообщенияОжидаемыеОтФСС.Заголовок = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru = ';Ожидается %1 ответ на сообщение о страховом случае ФСС;;Ожидается %1 ответа на сообщения о страховых случаях ФСС;Ожидается %1 ответов на сообщения о страховых случаях ФСС;'"),
			КоличествоОжидаемыхСообщений);
		Если КоличествоОжидаемыхСообщений = 1 Тогда
			Элементы.ПолучитьНовыеСообщенияСЭДОФСС.Заголовок = НСтр("ru = 'Проверить наличие ответа ФСС'");
		Иначе
			Элементы.ПолучитьНовыеСообщенияСЭДОФСС.Заголовок = НСтр("ru = 'Проверить наличие ответов ФСС'");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьФилиалы()
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ГоловнаяОрганизация <> Организации.Ссылка
	|	И Организации.ГоловнаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

#КонецОбласти

#Область Список

&НаСервере
Процедура ОбновитьПараметрыСписка()
	
	ОтборКД = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	Если ПоказыватьГоловныеОрганизации Тогда
		Если ИдентификаторОтбораГоловнаяОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораГоловнаяОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "ГоловнаяОрганизация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "ГоловнаяОрганизация", "=", ГоловнаяОрганизация);
			ИдентификаторОтбораГоловнаяОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(ГоловнаяОрганизация);
		ЭлементОтбораКД.ПравоеЗначение = ГоловнаяОрганизация;
		Элементы.СписокГоловнаяОрганизация.Видимость = Не ЭлементОтбораКД.Использование;
	КонецЕсли;
	
	Если ПоказыватьОрганизации Тогда
		Если ИдентификаторОтбораОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Организация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "Организация", "=", Организация);
			ИдентификаторОтбораОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		Количество = Организации.Количество();
		Если Количество = 0 Тогда
			ЭлементОтбораКД.Использование  = Ложь;
			Элементы.СписокОрганизация.Видимость = Истина;
		ИначеЕсли Количество = 1 Тогда
			ЭлементОтбораКД.Использование  = Истина;
			ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораКД.ПравоеЗначение = Организации[0].Значение;
			Элементы.СписокОрганизация.Видимость         = Ложь;
			Элементы.СписокГоловнаяОрганизация.Видимость = Ложь;
		Иначе
			ЭлементОтбораКД.Использование  = Истина;
			ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбораКД.ПравоеЗначение = Организации;
			Элементы.СписокОрганизация.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Организации

&НаКлиенте
Процедура ВыбратьОрганизации()
	ПараметрыВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ГоловнаяОрганизация", ГоловнаяОрганизация));
	КонецЕсли;
	Для Каждого ЭлементСписка Из Организации Цикл
		Если СписокОрганизацийДляВыбора.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СписокОрганизацийДляВыбора.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отмеченные", Организации);
	ПараметрыФормы.Вставить("ЗначенияДляВыбора", СписокОрганизацийДляВыбора);
	ПараметрыФормы.Вставить("ЗначенияДляВыбораЗаполнены", Истина);
	ПараметрыФормы.Вставить("ОграничиватьВыборУказаннымиЗначениями", Ложь);
	ПараметрыФормы.Вставить("БыстрыйВыбор", Ложь);
	ПараметрыФормы.Вставить("Представление", НСтр("ru = 'Организации'"));
	ПараметрыФормы.Вставить("ПараметрыВыбора", ПараметрыВыбора);
	ПараметрыФормы.Вставить("ОписаниеТипов", Организации.ТипЗначения);
	
	Если СписокОрганизацийДляВыбора.Количество() = 0 Тогда
		ПараметрыФормы.БыстрыйВыбор = Истина;
		ПараметрыФормы.ЗначенияДляВыбораЗаполнены = Ложь;
	КонецЕсли;
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораОрганизаций", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыФормы, ЭтотОбъект, , , , Обработчик, Режим);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОрганизаций(РезультатВыбора, ПустойПараметр) Экспорт
	Если ТипЗнч(РезультатВыбора) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	СписокОрганизацийДляВыбора = РезультатВыбора;
	ИспользоватьСписокОрганизаций = Истина;
	Организации.Очистить();
	Для Каждого ЭлементСписка Из РезультатВыбора Цикл
		Если ЭлементСписка.Пометка Тогда
			ЗаполнитьЗначенияСвойств(Организации.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
