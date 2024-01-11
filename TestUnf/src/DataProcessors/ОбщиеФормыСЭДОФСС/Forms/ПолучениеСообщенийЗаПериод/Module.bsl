#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Команда = Метаданные.Обработки.ОбщиеФормыСЭДОФСС.Команды.ПолучитьСообщенияСЭДОФССЗаПериод;
	НавигационнаяСсылка = "e1cib/command/" + Команда.ПолноеИмя();
	
	Страхователи.ЗагрузитьЗначения(ЭлектронныйДокументооборотСФСС.ОрганизацииИспользующиеОбменФСС());
	
	ДатаОкончания = ТекущаяДатаСеанса();
	ДатаНачала = ДатаОкончания - 86400;
	
	ОтборыПоОрганизациям = СЭДОФССКлиентСервер.ОтборыПоОрганизациямФормы(Параметры);
	Если ОтборыПоОрганизациям <> Неопределено Тогда
		Отмеченные = СЭДОФССВызовСервера.СтрахователиИзОтборовПоОрганизациямФормы(ОтборыПоОрганизациям);
		Для Каждого Страхователь Из Отмеченные Цикл
			ЭлементСписка = Страхователи.НайтиПоЗначению(Страхователь);
			Если ЭлементСписка <> Неопределено Тогда
				ЭлементСписка.Пометка = Истина;
				АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Выбранные = ВыбранныеСтрахователи.ВыгрузитьЗначения();
	Для Каждого Страхователь Из Выбранные Цикл
		ЭлементСписка = Страхователи.НайтиПоЗначению(Страхователь);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьСообщения(Команда) 
	
	МассивСтрахователей = Новый Массив;
	Для Каждого ЭлементСписка Из Страхователи Цикл
		Если ЭлементСписка.Пометка И ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивСтрахователей.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСтрахователей.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Необходимо выбрать организацию'");
		СообщенияБЗККлиентСервер.СообщитьВФорме(ТекстОшибки, "Страхователи");
		Возврат;
	КонецЕсли;
	
	Если Не ПроверкиБЗККлиентСервер.ПериодСоответствуетТребованиям(
			ЭтотОбъект,
			"",
			"ДатаНачала",
			"ДатаОкончания",
			НСтр("ru = 'получения сообщений'")) Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Получение списка сообщений...'"), , , БиблиотекаКартинок.ДлительнаяОперация24БЗК);
	Оповещение = Новый ОписаниеОповещения("ПолучитьСообщенияПослеЗагрузки", ЭтотОбъект);
	ПараметрыПолучения = ЭлектронныйДокументооборотСФССКлиент.ПараметрыПолучитьСообщенияСЭДОЗаПериод();
	ПараметрыПолучения.Вставить("ПринудительноПовторноПолучитьСообщения", Принудительно);
	ЭлектронныйДокументооборотСФССКлиент.ПолучитьСообщенияСЭДОЗаПериод(Оповещение, МассивСтрахователей,
		ДатаНачала, ДатаОкончания, ПараметрыПолучения);
	Элементы.ФормаПолучитьСообщения.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьСообщенияПослеЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
	Оповестить(СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС(), Результат);
	СЭДОФССКлиент.ОповеститьОНеобходимостиОбновитьТекущиеДела();
	
	Если Результат.БылиОшибки Тогда
		Шаблон = НСтр("ru='Получено %1 сообщений.'");
		Текст = СтрШаблон(Шаблон, Результат.ДанныеСообщений.Количество());
		Результат.Ошибки.Вставить(0, Текст);
		ИнформированиеПользователяКлиент.ПоказатьПодробности(
			СтрСоединить(Результат.Ошибки, Символы.ПС + Символы.ПС + "----------" + Символы.ПС + Символы.ПС),
			НСтр("ru = 'Ошибки и предупреждения при получении списка сообщений'"));
		Возврат;
	КонецЕсли;

	Если Результат.ОперацияБылаОтмененаПользователем Тогда
		Шаблон = НСтр("ru='Получено %1 сообщений.'");
		Текст = СтрШаблон(Шаблон, Результат.ДанныеСообщений.Количество());
		Результат.Ошибки.Вставить(0, Текст);
		ОписаниеОшибки = НСтр("ru='Получение сообщений за период было прервано пользователем.'");
		Результат.Ошибки.Вставить(0, ОписаниеОшибки);
		ИнформированиеПользователяКлиент.ПоказатьПодробности(
			СтрСоединить(Результат.Ошибки, Символы.ПС + Символы.ПС + "----------" + Символы.ПС + Символы.ПС),
			НСтр("ru = 'Ошибки и предупреждения при получении списка сообщений'"));
		Возврат;
	КонецЕсли;
	
	Шаблон = НСтр("ru='Получено %1 сообщений.'");
	Текст = СтрШаблон(Шаблон, Результат.ДанныеСообщений.Количество());
	ИнформированиеПользователяКлиент.ПоказатьПодробности(
		Текст,
		НСтр("ru = 'Получение сообщений за период завершено'"));
	
КонецПроцедуры

#КонецОбласти
