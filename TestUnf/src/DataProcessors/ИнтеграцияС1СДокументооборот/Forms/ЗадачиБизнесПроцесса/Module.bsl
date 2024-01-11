#Область ОписаниеПеременных

&НаКлиенте
Перем НомерАктивизированнойСтроки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НомерАктивизированнойСтроки = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Задачи.
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.6.2")
			И Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("3.0.1.1") Тогда
		Если Параметры.Свойство("ВнешнийОбъект") Тогда
			БизнесПроцесс = Параметры.ВнешнийОбъект.presentation;
			БизнесПроцессID = Параметры.ВнешнийОбъект.ID;
			БизнесПроцессТип = Параметры.ВнешнийОбъект.type;
			УстановитьВидимостьКолонокЗадач();
			ОбновитьСписокЗадачНаСервере();
		КонецЕсли;
	Иначе
		Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтотОбъект);
		Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
		Элементы.ЗадачиПроцесса.Видимость = Ложь;
	КонецЕсли;
	
	// Принятие задач к исполнению.
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("1.2.7.3.CORP") Тогда
		Элементы.ПринятьКИсполнению.Видимость = Ложь;
		Элементы.ЗадачиПроцессаКонтекстноеМенюПринятьКИсполнению.Видимость = Ложь;
	КонецЕсли;
	// Отмена принятия задач к исполнению.
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("2.1.18.1.CORP") Тогда
		Элементы.ОтменитьПринятиеКИсполнению.Видимость = Ложь;
		Элементы.ЗадачиПроцессаКонтекстноеМенюОтменитьПринятиеКИсполнению.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьОформлениеЗадач(УсловноеОформление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотЗадача" И Источник = ЭтотОбъект Тогда
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачи

&НаКлиенте
Процедура ЗадачиПроцессаПриАктивизацииСтроки(Элемент)
	
	Если НомерАктивизированнойСтроки <> Элемент.ТекущаяСтрока Тогда
		
		НомерАктивизированнойСтроки = Элемент.ТекущаяСтрока;
		СтрокаЗадачи = Элементы.ЗадачиПроцесса.ТекущиеДанные;
		Если СтрокаЗадачи = Неопределено Или СтрокаЗадачи.Группировка Или СтрокаЗадачи.Выполнена Тогда
			Элементы.ПринятьКИсполнению.Доступность = Ложь;
			Элементы.ЗадачиПроцессаКонтекстноеМенюПринятьКИсполнению.Доступность = Ложь;
			Элементы.ОтменитьПринятиеКИсполнению.Доступность = Ложь;
			Элементы.ЗадачиПроцессаКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = Ложь;
		Иначе
			Элементы.ПринятьКИсполнению.Доступность = Не СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ЗадачиПроцессаКонтекстноеМенюПринятьКИсполнению.Доступность = Не СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ОтменитьПринятиеКИсполнению.Доступность = СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ЗадачиПроцессаКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = СтрокаЗадачи.ПринятаКИсполнению;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ЗадачиПроцесса.ТекущиеДанные <> Неопределено Тогда
		Если Не Элементы.ЗадачиПроцесса.ТекущиеДанные.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ID", Элементы.ЗадачиПроцесса.ТекущиеДанные.ЗадачаID);
			ПараметрыФормы.Вставить("type", Элементы.ЗадачиПроцесса.ТекущиеДанные.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача",
				ПараметрыФормы, ЭтотОбъект, Элементы.ЗадачиПроцесса.ТекущиеДанные.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокЗадачНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачу(Команда)
	
	Если Элементы.ЗадачиПроцесса.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Элементы.ЗадачиПроцесса.ТекущиеДанные.Группировка Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ID", Элементы.ЗадачиПроцесса.ТекущиеДанные.ЗадачаID);
		ПараметрыФормы.Вставить("type", Элементы.ЗадачиПроцесса.ТекущиеДанные.ЗадачаТип);
		ПараметрыФормы.Вставить("ТипПроцесса",Элементы.ЗадачиПроцесса.ТекущиеДанные.ПроцессТип);
		ПараметрыФормы.Вставить("ТочкаМаршрута",Элементы.ЗадачиПроцесса.ТекущиеДанные.ТочкаМаршрута);
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача",
			ПараметрыФормы, ЭтотОбъект, Элементы.ЗадачиПроцесса.ТекущиеДанные.ЗадачаID);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	ПринятьЗадачиКИсполнению();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	ОтменитьПринятиеЗадачКИсполнению();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекущуюСтроку(ЗадачаID) 
	
	Если ЗначениеЗаполнено(ЗадачаID) Тогда
		Если Элементы.ЗадачиПроцесса.Отображение = ОтображениеТаблицы.Список Тогда
			СтрокиЗадачи = ЗадачиПроцесса.ПолучитьЭлементы();
			Для Каждого СтрокаЗадачи Из СтрокиЗадачи Цикл
				Если СтрокаЗадачи.ЗадачаID = ЗадачаID Тогда
					Элементы.ЗадачиПроцесса.ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого ГруппаДерева Из ЗадачиПроцесса.ПолучитьЭлементы() Цикл
				СтрокиЗадачи = ГруппаДерева.ПолучитьЭлементы();
				Для Каждого СтрокаЗадачи Из СтрокиЗадачи Цикл
					Если СтрокаЗадачи.ЗадачаID = ЗадачаID Тогда
						Элементы.ЗадачиПроцесса.ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПринятьЗадачиКИсполнению()
	
	МассивСтрок = Элементы.ЗадачиПроцесса.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадач = Новый Массив;
		Для Каждого Элемент Из МассивСтрок Цикл
			Если ЗначениеЗаполнено(ЗадачиПроцесса.НайтиПоИдентификатору(Элемент).ЗадачаID) Тогда
				МассивЗадач.Добавить(ЗадачиПроцесса.НайтиПоИдентификатору(Элемент).ЗадачаID);
			КонецЕсли;
		КонецЦикла;
		Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
		ИнтеграцияС1СДокументооборот.ПринятьЗадачуКИсполнению(Прокси, МассивЗадач);
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПринятиеЗадачКИсполнению()
	
	МассивСтрок = Элементы.ЗадачиПроцесса.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадач = Новый Массив;
		Для Каждого Элемент Из МассивСтрок Цикл
			Если ЗначениеЗаполнено(ЗадачиПроцесса.НайтиПоИдентификатору(Элемент).ЗадачаID) Тогда
				МассивЗадач.Добавить(ЗадачиПроцесса.НайтиПоИдентификатору(Элемент).ЗадачаID);
			КонецЕсли;
		КонецЦикла;
		Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
		ИнтеграцияС1СДокументооборот.ОтменитьПринятиеЗадачКИсполнению(Прокси, МассивЗадач);
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеЗадач(УсловноеОформление)
	
	// установка оформления для просроченных задач
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиПроцесса.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиПроцесса.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = КонецДня(ТекущаяДатаСеанса());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиПроцесса.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиПроцессаСрокИсполнения");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗадачиПроцесса(Прокси, Выполненные, БизнесПроцессТип, БизнесПроцессID)
	
	СписокУсловий = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "byUser";
	Условие.value = Ложь;
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withExecuted";
	Условие.value = Истина;
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "businessProcess";
	Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		БизнесПроцессID,
		БизнесПроцессТип);
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "typed";
	Условие.value = Истина;
	УсловияОтбора.Добавить(Условие);
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMBusinessProcessTask",
		СписокУсловий);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокЗадач(ЗадачиXDTO)
	
	ТекущаяЗадача = Элементы.ЗадачиПроцесса.ТекущаяСтрока;
	Если ТекущаяЗадача <> неопределено Тогда
		ТекущаяЗадача = ЗадачиПроцесса.НайтиПоИдентификатору(ТекущаяЗадача).ЗадачаID;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ЗадачиПроцесса"); // ДеревоЗначений
	
	ТаблицаЗадач = Новый ТаблицаЗначений;
	Для Каждого Колонка Из Дерево.Колонки Цикл
		ТаблицаЗадач.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	Для Каждого ЗадачаXDTO Из ЗадачиXDTO Цикл
		СтрокаЗадачи = ТаблицаЗадач.Добавить();
		ЗаполнитьСтрокуЗадачи(СтрокаЗадачи, ЗадачаXDTO.object);
	КонецЦикла;
	
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		Элементы.ЗадачиПроцесса.Отображение = ОтображениеТаблицы.Дерево;
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
		ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для Каждого СтрокаГруппировки Из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(
				Новый Структура(РежимГруппировки,СтрокаГруппировки[РежимГруппировки]));
			Для Каждого Строка Из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
			КонецЦикла;
		КонецЦикла;
	Иначе
		Элементы.ЗадачиПроцесса.Отображение = ОтображениеТаблицы.Список;
		Для Каждого Строка Из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево,"ЗадачиПроцесса");
	ТаблицаЗадачСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач,УникальныйИдентификатор);
	УстановитьТекущуюСтроку(ТекущаяЗадача);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонокЗадач()
	
	Если БизнесПроцессТип = "DMBusinessProcessApproval"
		Или БизнесПроцессТип = "DMBusinessProcessConfirmation" Тогда
		Элементы.ЗадачиПроцессаЗадача.Видимость = Истина;
		Элементы.ЗадачиПроцессаЦикл.Видимость = Истина;
		Элементы.ЗадачиПроцессаРезультат.Видимость = Истина;
		Элементы.ЗадачиПроцессаРецензия.Видимость = Истина;
		Элементы.ЗадачиПроцессаИсполнитель.Видимость = Истина;
		
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessPerformance" 
		Или БизнесПроцессТип = "DMBusinessProcessOrder" 
		Или БизнесПроцессТип = "DMBusinessProcessRegistration" 
		Или БизнесПроцессТип = "DMBusinessProcessOutgoingDocumentProcessing"
		Или БизнесПроцессТип = "DMBusinessProcessInternalDocumentProcessing"
		Или БизнесПроцессТип = "DMBusinessProcessIncomingDocumentProcessing" Тогда
		Элементы.ЗадачиПроцессаЗадача.Видимость = Истина;
		Элементы.ЗадачиПроцессаИсполнительСправа.Видимость = Истина;
		Элементы.ЗадачиПроцессаВыполнена.Видимость = Истина;
		
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessAcquaintance" Тогда
		Элементы.ЗадачиПроцессаИсполнитель.Видимость = Истина;
		Элементы.ЗадачиПроцессаОзнакомился.Видимость = Истина;
		
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessConsideration" Тогда
		Элементы.ЗадачиПроцессаИсполнитель.Видимость = Истина;
		Элементы.ЗадачиПроцессаЗадача.Видимость = Истина;
		Элементы.ЗадачиПроцессаВыполнена.Видимость = Истина;
		
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessIssuesSolution" Тогда
		Элементы.ЗадачиПроцессаЗадача.Видимость = Истина;
		Элементы.ЗадачиПроцессаИсполнительСправа.Видимость = Истина;
		Элементы.ЗадачиПроцессаРецензия.Видимость = Истина;
		
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessInvitation" Тогда
		Элементы.ЗадачиПроцессаИсполнитель.Видимость = Истина;
		Элементы.ЗадачиПроцессаЦикл.Видимость = Истина;
		Элементы.ЗадачиПроцессаЗадача.Видимость = Истина;
		Элементы.ЗадачиПроцессаРезультат.Видимость = Истина;
		Элементы.ЗадачиПроцессаКомментарий.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуЗадачи(СтрокаЗадачи,ЗадачаXDTO)
	
	Важность = 1;
	Если ЗадачаXDTO.importance.objectID.ID = "Низкая" Тогда //@NON-NLS-1
		Важность = 0;
	ИначеЕсли ЗадачаXDTO.importance.objectID.ID = "Обычная" Тогда //@NON-NLS-1
		Важность = 1;
	ИначеЕсли ЗадачаXDTO.importance.objectID.ID = "Высокая" Тогда //@NON-NLS-1
		Важность = 2;
	КонецЕсли;
	
	СтрокаЗадачи.Важность = Важность;
	СтрокаЗадачи.ВажностьСтрокой = ЗадачаXDTO.importance.name;
	СтрокаЗадачи.КартинкаЗадачи = ?(ЗадачаXDTO.executed,1,0);
	СтрокаЗадачи.Выполнена = ЗадачаXDTO.executed;
	СтрокаЗадачи.ТочкаМаршрута = ЗадачаXDTO.businessProcessStep;
	СтрокаЗадачи.СрокИсполнения = ЗадачаXDTO.dueDate;
	СтрокаЗадачи.Записана = ЗадачаXDTO.beginDate;
	СтрокаЗадачи.Автор = ЗадачаXDTO.author.name;
	СтрокаЗадачи.ПринятаКИсполнению = ЗадачаXDTO.accepted;
	СтрокаЗадачи.Номер = ЗадачаXDTO.number;
	СтрокаЗадачи.Дата = ЗадачаXDTO.beginDate;
	СтрокаЗадачи.Рецензия = ЗадачаXDTO.executionComment;
	СтрокаЗадачи.Комментарий = ЗадачаXDTO.executionComment;
	СтрокаЗадачи.ДатаВыполнения = ЗадачаXDTO.endDate;
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.performer.user,"Исполнитель");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.parentBusinessProcess,"Процесс");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.target,"Предмет");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO,"Задача");
	
	// Заполним строки задач по типу бизнес процесса
	Если БизнесПроцессТип = "DMBusinessProcessApproval" Тогда
		СтрокаЗадачи.Цикл = ЗадачаXDTO.iterationNumber;
		Если ЗадачаXDTO.objectID.type = "DMBusinessProcessApprovalTaskApproval" Тогда
			ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.approvalResult,"Результат");
		КонецЕсли;
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessConfirmation" Тогда
		СтрокаЗадачи.Цикл = ЗадачаXDTO.iterationNumber;
		Если ЗадачаXDTO.objectID.type = "DMBusinessProcessConfirmationTaskConfirmation" Тогда
			ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.confirmationResult,"Результат");
		КонецЕсли;
	ИначеЕсли БизнесПроцессТип = "DMBusinessProcessInvitation" Тогда
		СтрокаЗадачи.Цикл = ЗадачаXDTO.iterationNumber;
		Если ЗадачаXDTO.objectID.type = "DMBusinessProcessInvitationTaskInvitation" Тогда
			ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.invitationResult,"Результат");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Если ЗначениеЗаполнено(БизнесПроцессID) Тогда
		ЗадачиПроцессаXDTO = ПолучитьЗадачиПроцесса(Прокси, Выполненные, БизнесПроцессТип, БизнесПроцессID);
		ЗаполнитьСписокЗадач(ЗадачиПроцессаXDTO);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектныйРеквизит(Приемник, Источник, ИмяРеквизита)
	
	Если Источник <> Неопределено Тогда
		Приемник[ИмяРеквизита] = Источник.name;
		Приемник[ИмяРеквизита + "ID"] = Источник.objectID.ID;
		Приемник[ИмяРеквизита + "Тип"] = Источник.objectID.type;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти