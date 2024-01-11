///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПрикладныеОперацииОплаты

// Производит поиск идентификатора заказа на оплату или возврата,
// если идентификатор еще не был создан, создает новый.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий оплату
//    в информационной базе;
//  ИдентификаторМерчанта - Строка - идентификатор магазина в которой производится оплата;
//  НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//    настройка подключения к Системе быстрых платежей;
//  ИдентификаторОплаты - Строка - идентификатор оплаты в Системе быстрых платежей. Передается
//    если известен на момент проведения операции;
//  КонтролироватьСтатусОперации - Булево - признак контроля потребности в генерации нового
//    идентификатора оплаты;
//  ОтложенноеПолучениеСтатуса - Булево - признак загрузки статуса оплаты регламентным заданием.
//
// Возвращаемое значение:
//  Строка - идентификатор оплаты (внешний идентификатор 1С по отношению к Системе быстрых платежей).
//
Функция НовыйИдентификаторОперации(
		ДокументОперации,
		ИдентификаторМерчанта,
		НастройкаПодключения,
		ИдентификаторОплаты = "",
		КонтролироватьСтатусОперации = Истина,
		ОтложенноеПолучениеСтатуса = Ложь) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИдентификаторыОперацийСБПc2b");
		ЭлементБлокировки.УстановитьЗначение("ДокументОперации", ДокументОперации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.ИдентификаторыОперацийСБПc2b.СоздатьМенеджерЗаписи();
		Запись.ДокументОперации = ДокументОперации;
		Запись.Прочитать();
		
		Если Не КонтролироватьСтатусОперации
			Или ТребуетсяГенерацияНовогоИдентификатора(Запись.Идентификатор, Запись.СтатусОперации) Тогда
			Запись.Идентификатор = Новый УникальныйИдентификатор;
			Запись.ДокументОперации = ДокументОперации;
			Запись.ИдентификаторМерчанта = ИдентификаторМерчанта;
			Запись.НастройкаПодключения = НастройкаПодключения;
			Запись.ИдентификаторОплаты = ИдентификаторОплаты;
			Запись.ИдентификаторСессии = "";
			Запись.ИдентификаторОперации = "";
			Запись.СтатусОперации = "";
			Запись.ПлатежнаяСсылка = "";
			Запись.ОтложенноеПолучениеСтатуса = Ложь;
			Запись.КоличествоПопыток = 0;
			Запись.ДатаОперации = Неопределено;
			Запись.СуммаОперации = 0;
			Запись.ПериодИспользования = Неопределено;
			Запись.ДатаЗапросаСтатуса = Неопределено;
			Запись.ПараметрыАктивации = Неопределено;
			Запись.ОтложенноеПолучениеСтатуса = ОтложенноеПолучениеСтатуса;
			Запись.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При формировании идентификатора оплаты возникли ошибки:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			ТекстИсключения,
			Истина);
		
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	
	Возврат Запись.Идентификатор;
	
КонецФункции

// Производит поиск идентификатора заказа на оплату или возврата.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий операцию
//   в информационной базе;
//
// Возвращаемое значение:
//   Строка - идентификатор оплаты в Системе быстрых платежей.
//
Функция ИдентификаторОперации(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.Идентификатор КАК Идентификатор
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Идентификатор;
	КонецЕсли;
	
КонецФункции

// Производит поиск функциональная ссылка операции в Системе быстрых платежей.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий операцию
//   в информационной базе;
//
// Возвращаемое значение:
//   Строка - QR-код в Системе быстрых платежей.
//
Функция ПлатежнаяСсылкаОперации(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ПлатежнаяСсылка КАК ПлатежнаяСсылка
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ПлатежнаяСсылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Производит поиск идентификатора заказа на оплату или заказа на возврат в Системе быстрых платежей.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий операцию
//  в информационной базе;
//
// Возвращаемое значение:
//   Структура - идентификаторы оплаты в Системе быстрых платежей.
//
Функция ИдентификаторыОперацииСБП(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОплаты КАК ИдентификаторОплаты,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОперации КАК ИдентификаторОперации
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат НовыйИдентификаторыОперацииСБП(
			ВыборкаДетальныеЗаписи.ИдентификаторОплаты,
			ВыборкаДетальныеЗаписи.ИдентификаторОперации);
	КонецЕсли;
	
КонецФункции

// Производит поиск идентификатора сессии возврата.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий оплату
//    в информационной базе;
//
// Возвращаемое значение:
//   Строка - идентификаторы сессии.
//
Функция ИдентификаторСессии(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторСессии КАК ИдентификаторСессии
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ИдентификаторСессии;
	КонецЕсли;
	
КонецФункции

// Получает данные для определения статуса выполнения операции в Системе быстрых платежей.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий оплату
//    в информационной базе;
//  ПериодИспользования - Дата - срок действия QR-кода.
//
// Возвращаемое значение:
//  Структура - идентификаторы оплаты в Системе быстрых платежей.
//
Функция ПараметрыОпределенияСтатусаОперации(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОплаты КАК ИдентификаторОплаты,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОперации КАК ИдентификаторОперации,
		|	ИдентификаторыОперацийСБПc2b.ДатаЗапросаСтатуса КАК ДатаЗапросаСтатуса,
		|	ИдентификаторыОперацийСБПc2b.СтатусОперации КАК СтатусОперации,
		|	ИдентификаторыОперацийСБПc2b.ПериодИспользования КАК ПериодИспользования,
		|	ИдентификаторыОперацийСБПc2b.ДатаОперации КАК ДатаОперации,
		|	ИдентификаторыОперацийСБПc2b.СуммаОперации КАК СуммаОперации,
		|	ИдентификаторыОперацийСБПc2b.ПараметрыАктивации КАК ПараметрыАктивации
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("ИдентификаторОплаты", ВыборкаДетальныеЗаписи.ИдентификаторОплаты);
		Результат.Вставить("ИдентификаторОперации", ВыборкаДетальныеЗаписи.ИдентификаторОперации);
		Результат.Вставить("ДатаЗапросаСтатуса", ВыборкаДетальныеЗаписи.ДатаЗапросаСтатуса);
		Результат.Вставить("СтатусОперации", ВыборкаДетальныеЗаписи.СтатусОперации);
		Результат.Вставить("ПериодИспользования", ВыборкаДетальныеЗаписи.ПериодИспользования);
		Результат.Вставить("ДатаОперации", ВыборкаДетальныеЗаписи.ДатаОперации);
		Результат.Вставить("СуммаОперации", ВыборкаДетальныеЗаписи.СуммаОперации);
		Результат.Вставить("ПараметрыАктивации", ВыборкаДетальныеЗаписи.ПараметрыАктивации);
		
		// Если не было успешного получения статуса, необходимо
		// запрашивать наличие callback.
		Если Не ЗначениеЗаполнено(Результат.ДатаЗапросаСтатуса) Тогда
			Результат.ДатаЗапросаСтатуса = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Возврат Результат;
		
	КонецЕсли;
	
КонецФункции

// Получает данные по документу операции.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий оплату
//    в информационной базе;
//
// Возвращаемое значение:
//  Структура, Неопределено - данные операции.
//
Функция ДанныеОперации(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОплаты КАК ИдентификаторОплаты,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОперации КАК ИдентификаторОперации,
		|	ИдентификаторыОперацийСБПc2b.СтатусОперации КАК СтатусОперации,
		|	ИдентификаторыОперацийСБПc2b.ДатаОперации КАК ДатаОперации,
		|	ИдентификаторыОперацийСБПc2b.СуммаОперации КАК СуммаОперации,
		|	ДанныеОперацийСБПc2b.Оплата КАК Оплата
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОперацийСБПc2b КАК ДанныеОперацийСБПc2b
		|		ПО ИдентификаторыОперацийСБПc2b.Идентификатор = ДанныеОперацийСБПc2b.Идентификатор
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("ИдентификаторОплаты",   ВыборкаДетальныеЗаписи.ИдентификаторОплаты);
		Результат.Вставить("ИдентификаторОперации", ВыборкаДетальныеЗаписи.ИдентификаторОперации);
		Результат.Вставить("СтатусОперации",        ВыборкаДетальныеЗаписи.СтатусОперации);
		Результат.Вставить("ДатаОперации",          ВыборкаДетальныеЗаписи.ДатаОперации);
		Результат.Вставить("СуммаОперации",         ВыборкаДетальныеЗаписи.СуммаОперации);
		Результат.Вставить("Оплата",                ВыборкаДетальныеЗаписи.Оплата);
		
		Возврат Результат;
		
	КонецЕсли;
	
КонецФункции

// Получает настройки подключения по документам операций.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий операцию СБП
//    в информационной базе;
//
// Возвращаемое значение:
//  Массив Из СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей
//   - используемые в документах настройки подключения.
//
Функция НастройкиПодключенияПоДокументуОперации(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлатежнаяСсылкаСБПc2b.Ссылка КАК ДокументОперации
	|ПОМЕСТИТЬ ВТ_ДокументыОперации
	|ИЗ
	|	Документ.ПлатежнаяСсылкаСБПc2b КАК ПлатежнаяСсылкаСБПc2b
	|ГДЕ
	|	ПлатежнаяСсылкаСБПc2b.ОснованиеПлатежа = &ДокументОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ДокументОперации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИдентификаторыОперацийСБПc2b.НастройкаПодключения КАК НастройкаПодключения
	|ИЗ
	|	ВТ_ДокументыОперации КАК ВТ_ДокументыОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
	|		ПО ВТ_ДокументыОперации.ДокументОперации = ИдентификаторыОперацийСБПc2b.ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НастройкиПодключения = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НастройкиПодключения.Добавить(Выборка.НастройкаПодключения);
		
	КонецЦикла;
	
	Возврат НастройкиПодключения;
	
КонецФункции

// См. СистемаБыстрыхПлатежейСлужебный.ИнформацияДляТехническойПоддержки.
//
Функция ИнформацияДляТехническойПоддержки(ДокументОперации) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Данные операции c2b:'")
		+ Символы.ПС
		+ Символы.ПС;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.Идентификатор КАК Идентификатор,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОплаты КАК ИдентификаторОплаты,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОперации КАК ИдентификаторОперации,
		|	ИдентификаторыОперацийСБПc2b.ДатаОперации КАК ДатаОперации,
		|	ИдентификаторыОперацийСБПc2b.ДатаЗапросаСтатуса КАК ДатаЗапросаСтатуса,
		|	ИдентификаторыОперацийСБПc2b.СтатусОперации КАК СтатусОперации,
		|	ИдентификаторыОперацийСБПc2b.ПараметрыАктивации КАК ПараметрыАктивации,
		|	ИдентификаторыОперацийСБПc2b.ПлатежнаяСсылка КАК ПлатежнаяСсылка
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Информация о выполнении операции c2b не обнаружена в базе данных.'");;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Идентификатор:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.Идентификатор)
		+ Символы.ПС;
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Идентификатор оплаты:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.ИдентификаторОплаты)
		+ Символы.ПС; 
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Идентификатор операции:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.ИдентификаторОперации)
		+ Символы.ПС;
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Платежная ссылка:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.ПлатежнаяСсылка)
		+ Символы.ПС;
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Параметры активации:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.ПараметрыАктивации)
		+ Символы.ПС;
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Дата операции:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.ДатаОперации)
		+ Символы.ПС;
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Дата запроса статуса:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.ДатаЗапросаСтатуса)
		+ Символы.ПС;
	ТекстСообщения = ТекстСообщения
		+ НСтр("ru = 'Статус операции:'")
		+ СистемаБыстрыхПлатежейСлужебный.ОбработатьЗначениеДляТехническойПоддержки(
			ВыборкаДетальныеЗаписи.СтатусОперации)
		+ Символы.ПС
		+ Символы.ПС;
	
	Возврат ТекстСообщения;
	
КонецФункции

// Выполняет поиск и информации об оплате в регистре и устанавливает новое значение
// идентификатора Системы быстрых платежей и периода действия.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий оплату
//    в информационной базе;
//  ИдентификаторОплаты - Строка - идентификатор оплаты в Системе быстрых платежей;
//  ПериодИспользования - Дата - срок действия QR-кода;
//  ПлатежнаяСсылка - Строка - идентификатор, по которому выполняется оплата;
//  СтатусОперации - Строка - текущий статус операции;
//  ПараметрыАктивации - Строка идентификатор параметров активации кассовой ссылки.
//
Процедура ЗаписатьДанныеОплатыСБП(
		ДокументОперации,
		ИдентификаторОплаты,
		ПериодИспользования,
		ПлатежнаяСсылка,
		СтатусОперации,
		ПараметрыАктивации = Неопределено) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИдентификаторыОперацийСБПc2b");
		ЭлементБлокировки.УстановитьЗначение("ДокументОперации", ДокументОперации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.ИдентификаторыОперацийСБПc2b.СоздатьМенеджерЗаписи();
		Запись.ДокументОперации = ДокументОперации;
		Запись.Прочитать();
		
		Если Не ЗначениеЗаполнено(Запись.ДокументОперации) Тогда
			ВызватьИсключение НСтр("ru = 'Информация о документе оплаты не обнаружена, не возможно записать идентификатор СБП.'");
		КонецЕсли;
		
		Запись.ИдентификаторОплаты = СтрЗаменить(ИдентификаторОплаты, Символы.НПП, "");
		Запись.СтатусОперации = СтатусОперации;
		Запись.ПлатежнаяСсылка = ПлатежнаяСсылка;
		Запись.ПараметрыАктивации = ПараметрыАктивации;
		
		// Период использования должен фиксироваться только при первом
		// запросе QR-кода.
		Если Не ЗначениеЗаполнено(Запись.ПериодИспользования) Тогда
			Запись.ПериодИспользования = ПериодИспользования;
		КонецЕсли;
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При записи идентификатора СБП возникли ошибки:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			ТекстИсключения,
			Истина);
		
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	
КонецПроцедуры

// Выполняет поиск и информации об оплате в регистре и устанавливает новое значение
// идентификатора операции, статуса операции, даты операции и даты определения статуса.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий оплату
//    в информационной базе;
//  ИдентификаторОперации - Строка - идентификатор оплаты в Системе быстрых платежей;
//  ДатаОперации - Дата - дата операции в Системе быстрых платежей;
//  СтатусОперации - Строка - статус операции в Системе быстрых платежей;
//  ИдентификаторСессии - Строка - идентификатор сессии операции;
//  ДатаЗапросаСтатуса - Дата - дата последней операции получения статуса.
//
Процедура ЗаписатьСтатусОперации(
		ДокументОперации,
		ИдентификаторОперации,
		ДатаОперации,
		СтатусОперации,
		СуммаОперации = Неопределено,
		ИдентификаторСессии = "",
		ДатаЗапросаСтатуса = Неопределено) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИдентификаторыОперацийСБПc2b");
		ЭлементБлокировки.УстановитьЗначение("ДокументОперации", ДокументОперации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.ИдентификаторыОперацийСБПc2b.СоздатьМенеджерЗаписи();
		Запись.ДокументОперации = ДокументОперации;
		Запись.Прочитать();
		
		Если Не ЗначениеЗаполнено(Запись.ДокументОперации) Тогда
			ВызватьИсключение НСтр("ru = 'Информация о документе оплаты не обнаружена, невозможно записать данные.'");
		КонецЕсли;
		
		Запись.ИдентификаторОперации = ИдентификаторОперации;
		Запись.ДатаОперации = ДатаОперации;
		Если СуммаОперации <> Неопределено Тогда
			Запись.СуммаОперации = СуммаОперации;
		КонецЕсли;
		Запись.СтатусОперации = СтатусОперации;
		Запись.ИдентификаторСессии = ИдентификаторСессии;
		Запись.КоличествоПопыток = Запись.КоличествоПопыток + 1;
		Если ЗначениеЗаполнено(ДатаЗапросаСтатуса) Тогда
			Запись.ДатаЗапросаСтатуса = ДатаЗапросаСтатуса;
		КонецЕсли;
		
		Если Запись.КоличествоПопыток > МаксимальноеКоличествоПопытокЗапросаСтатуса(ЗначениеЗаполнено(Запись.ПериодИспользования)) Тогда
			Запись.ОтложенноеПолучениеСтатуса = Ложь;
		КонецЕсли;
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При записи данных возникли ошибки:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			ТекстИсключения,
			Истина);
		
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	
КонецПроцедуры

// Выполняет установку признака загрузки статуса регламентным заданием, если
// ранее под документу была сгенерирован идентификатор оплаты СБП .
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ, который отражает
//    продажу в информационной базе;
//  Значение - Булево - если Истина, данные статуса будут загружены регламентным заданием.
//
// Возвращаемое значение:
//  Булево - Истина, если признак отложенной загрузки статуса установлен,
//   Ложь если операция не найдена.
//
Функция УстановитьОтложенноеПолучениеСтатуса(ДокументОперации, Значение) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИдентификаторыОперацийСБПc2b");
		ЭлементБлокировки.УстановитьЗначение("ДокументОперации", ДокументОперации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.ИдентификаторыОперацийСБПc2b.СоздатьМенеджерЗаписи();
		Запись.ДокументОперации = ДокументОперации;
		Запись.Прочитать();
		
		// Если записи нет, обновление данных не имеет смысла.
		Если Не ЗначениеЗаполнено(Запись.ИдентификаторОплаты) Тогда
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецЕсли;
		
		// Включать отложенную загрузку имеет смысл только для операций,
		// которые не находятся в терминальном состоянии.
		Если Значение И Запись.СтатусОперации <> СистемаБыстрыхПлатежейСлужебный.ИдентификаторСтатусаВПроцессе() Тогда
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецЕсли;
		
		Запись.ОтложенноеПолучениеСтатуса = Значение;
		Если Запись.ОтложенноеПолучениеСтатуса Тогда
			Запись.КоличествоПопыток = 0;
		КонецЕсли;
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При записи идентификатора СБП возникли ошибки:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			ТекстИсключения,
			Истина);
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Увеличивает значение количества попыток запроса статуса.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ, который отражает
//    операцию в информационной базе;
//
Процедура УвеличитьКоличествоПопытокЗапросаСтатуса(ДокументОперации) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИдентификаторыОперацийСБПc2b");
		ЭлементБлокировки.УстановитьЗначение("ДокументОперации", ДокументОперации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.ИдентификаторыОперацийСБПc2b.СоздатьМенеджерЗаписи();
		Запись.ДокументОперации = ДокументОперации;
		Запись.Прочитать();
		
		Если Не ЗначениеЗаполнено(Запись.ДокументОперации) Тогда
			ВызватьИсключение НСтр("ru = 'Информация о документе оплаты не обнаружена, не возможно записать данные.'");
		КонецЕсли;
		
		Запись.КоличествоПопыток = Запись.КоличествоПопыток + 1;
		Если Запись.КоличествоПопыток > МаксимальноеКоличествоПопытокЗапросаСтатуса(ЗначениеЗаполнено(Запись.ПериодИспользования)) Тогда
			Запись.ОтложенноеПолучениеСтатуса = Ложь;
		КонецЕсли;
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При записи данных возникли ошибки:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			ТекстИсключения,
			Истина);
		
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;
	
КонецПроцедуры

// Получает данные отложенных операций для дальнейшей обработки статусов.
//
// Возвращаемое значение:
//  Соответствие - данные операций:
//
Функция ОтложенныеОперации() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации КАК ДокументОперации,
		|	ДанныеОперацийСБПc2b.Оплата КАК Оплата,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОплаты КАК ИдентификаторОплаты,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторОперации КАК ИдентификаторОперации,
		|	ИдентификаторыОперацийСБПc2b.ДатаЗапросаСтатуса КАК ДатаЗапросаСтатуса,
		|	ИдентификаторыОперацийСБПc2b.НастройкаПодключения КАК НастройкаПодключения,
		|	ИдентификаторыОперацийСБПc2b.НастройкаПодключения.ИдентификаторУчастника КАК ИдентификаторУчастника,
		|	ИдентификаторыОперацийСБПc2b.ПериодИспользования КАК ПериодИспользования,
		|	ИдентификаторыОперацийСБПc2b.СтатусОперации КАК СтатусОперации,
		|	ИдентификаторыОперацийСБПc2b.КоличествоПопыток КАК КоличествоПопыток,
		|	ИдентификаторыОперацийСБПc2b.ДатаОперации КАК ДатаОперации,
		|	ИдентификаторыОперацийСБПc2b.СуммаОперации КАК СуммаОперации,
		|	ИдентификаторыОперацийСБПc2b.ПараметрыАктивации КАК ПараметрыАктивации,
		|	ВЫБОР
		|		КОГДА ИдентификаторыОперацийСБПc2b.ДокументОперации ССЫЛКА Документ.ПлатежнаяСсылкаСБПc2b
		|			ТОГДА ВЫРАЗИТЬ(ИдентификаторыОперацийСБПc2b.ДокументОперации КАК Документ.ПлатежнаяСсылкаСБПc2b).ОснованиеПлатежа
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК ДокументОснование
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОперацийСБПc2b КАК ДанныеОперацийСБПc2b
		|		ПО ИдентификаторыОперацийСБПc2b.Идентификатор = ДанныеОперацийСБПc2b.Идентификатор
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ОтложенноеПолучениеСтатуса
		|	И ИдентификаторыОперацийСБПc2b.НастройкаПодключения.Используется
		|	И ИдентификаторыОперацийСБПc2b.СтатусОперации <> """"
		|ИТОГИ ПО
		|	ИдентификаторУчастника";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИдентификаторУчастника = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаИдентификаторУчастника.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(ВыборкаИдентификаторУчастника.ИдентификаторУчастника) Тогда
			Продолжить;
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи = ВыборкаИдентификаторУчастника.Выбрать();
		
		ДанныеОпераций = Новый Массив;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ДанныеОперации = Новый Структура;
			ДанныеОперации.Вставить("ДокументОперации", ВыборкаДетальныеЗаписи.ДокументОперации);
			ДанныеОперации.Вставить("Оплата", ВыборкаДетальныеЗаписи.Оплата);
			ДанныеОперации.Вставить("ИдентификаторОплаты", ВыборкаДетальныеЗаписи.ИдентификаторОплаты);
			ДанныеОперации.Вставить("ИдентификаторОперации", ВыборкаДетальныеЗаписи.ИдентификаторОперации);
			ДанныеОперации.Вставить("ДатаЗапросаСтатуса", ВыборкаДетальныеЗаписи.ДатаЗапросаСтатуса);
			ДанныеОперации.Вставить("НастройкаПодключения", ВыборкаДетальныеЗаписи.НастройкаПодключения);
			ДанныеОперации.Вставить("ПериодИспользования", ВыборкаДетальныеЗаписи.ПериодИспользования);
			ДанныеОперации.Вставить("СтатусОперации", ВыборкаДетальныеЗаписи.СтатусОперации);
			ДанныеОперации.Вставить("КоличествоПопыток", ВыборкаДетальныеЗаписи.КоличествоПопыток);
			ДанныеОперации.Вставить("ПараметрыАктивации", ВыборкаДетальныеЗаписи.ПараметрыАктивации);
			
			ПараметрыОперации = СистемаБыстрыхПлатежейСлужебный.НовыйОписаниеПараметровОперации();
			ЗаполнитьЗначенияСвойств(ПараметрыОперации, ВыборкаДетальныеЗаписи);
			ПараметрыОперации.ИдентификаторОперации = ВыборкаДетальныеЗаписи.ИдентификаторОперации;
			ДанныеОперации.Вставить("ПараметрыОперации", ПараметрыОперации);
			
			ДанныеОпераций.Добавить(ДанныеОперации);
		КонецЦикла;
		
		Результат.Вставить(
			ВыборкаИдентификаторУчастника.ИдентификаторУчастника,
			ДанныеОпераций);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Формирует структуру данных для формы платежной ссылки в Системе быстрых платежей.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ отражающий операцию
//    в информационной базе;
//
// Возвращаемое значение:
//  Структура - данные для формы платежной ссылки в Системе быстрых платежей
//
Функция ДанныеДляФормированияПлатежнойСсылкиОперацииСБП(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.Идентификатор КАК Идентификатор,
		|	ИдентификаторыОперацийСБПc2b.ПлатежнаяСсылка КАК ПлатежнаяСсылка,
		|	ИдентификаторыОперацийСБПc2b.СтатусОперации КАК СтатусОперации,
		|	ДанныеОперацийСБПc2b.ДатаОперации КАК ДатаОперации,
		|	ДанныеОперацийСБПc2b.СуммаОперации КАК СуммаОперации,
		|	ДанныеОперацийСБПc2b.НазначениеПлатежа КАК НазначениеПлатежа,
		|	ИдентификаторыОперацийСБПc2b.НастройкаПодключения КАК НастройкаПодключения,
		|	ИдентификаторыОперацийСБПc2b.ИдентификаторМерчанта КАК ИдентификаторМерчанта,
		|	ВЫБОР
		|		КОГДА ИдентификаторыОперацийСБПc2b.ДокументОперации ССЫЛКА Документ.ПлатежнаяСсылкаСБПc2b
		|			ТОГДА ВЫРАЗИТЬ(ИдентификаторыОперацийСБПc2b.ДокументОперации КАК Документ.ПлатежнаяСсылкаСБПc2b).ОснованиеПлатежа
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК ДокументОснование
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОперацийСБПc2b КАК ДанныеОперацийСБПc2b
		|		ПО ИдентификаторыОперацийСБПc2b.Идентификатор = ДанныеОперацийСБПc2b.Идентификатор
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор",         ВыборкаДетальныеЗаписи.Идентификатор);
		Результат.Вставить("СтатусОперации",        ВыборкаДетальныеЗаписи.СтатусОперации);
		Результат.Вставить("ПлатежнаяСсылка",       ВыборкаДетальныеЗаписи.ПлатежнаяСсылка);
		Результат.Вставить("ДатаОперации",          ВыборкаДетальныеЗаписи.ДатаОперации);
		Результат.Вставить("СуммаОперации",         ВыборкаДетальныеЗаписи.СуммаОперации);
		Результат.Вставить("НазначениеПлатежа",     ВыборкаДетальныеЗаписи.НазначениеПлатежа);
		Результат.Вставить("НастройкаПодключения",  ВыборкаДетальныеЗаписи.НастройкаПодключения);
		Результат.Вставить("ИдентификаторМерчанта", ВыборкаДетальныеЗаписи.ИдентификаторМерчанта);
		Результат.Вставить("ДокументОснование",     ВыборкаДетальныеЗаписи.ДокументОснование);
		
		Возврат Результат;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СверкаВзаиморасчетов

// Определяет документы оплат для проведения сверки взаиморасчетов за период.
//
// Параметры:
//  НачалоПериода - Дата - начало периода отбора;
//  КонецПериода - Дата - окончание периода отбора;
//
// Возвращаемое значение:
//  Массив из ДокументОперацииСБП - документы оплат за период.
//
Функция ДокументНастройкиПодключенияЗаПериод(
		НастройкаПодключения,
		НачалоПериода,
		КонецПериода) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБПc2b.ДокументОперации КАК ДокументОперации
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|ГДЕ
		|	ИдентификаторыОперацийСБПc2b.НастройкаПодключения = &НастройкаПодключения
		|	И ИдентификаторыОперацийСБПc2b.ДатаОперации МЕЖДУ &НачалоПериода И &КонецПериода";
	
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("НастройкаПодключения", НастройкаПодключения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Добавить(ВыборкаДетальныеЗаписи.ДокументОперации);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Определяет параметры документов оплат для проведения сверки взаиморасчетов за период.
//
// Параметры:
//  НачалоПериода - Дата - начало периода отбора;
//  КонецПериода - Дата - окончание периода отбора;
//
// Возвращаемое значение:
//  Массив из Структура - данные документов оплат за период.
//
Функция ОперацииНастройкиПодключенияЗаПериод(
		НастройкаПодключения,
		НачалоПериода,
		КонецПериода) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИдентификаторыОперацийСБПc2b.ДокументОперации КАК ДокументОперации,
	|	ИдентификаторыОперацийСБПc2b.ИдентификаторОперации КАК ИдентификаторОперации
	|ПОМЕСТИТЬ ВТ_ДокументыОпераций
	|ИЗ
	|	РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
	|ГДЕ
	|	ИдентификаторыОперацийСБПc2b.ДатаОперации МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ИдентификаторыОперацийСБПc2b.НастройкаПодключения = &НастройкаПодключения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДокументыОпераций.ДокументОперации КАК ДокументОперации,
	|	ВТ_ДокументыОпераций.ИдентификаторОперации КАК ИдентификаторОперации
	|ИЗ
	|	ВТ_ДокументыОпераций КАК ВТ_ДокументыОпераций
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ВТ_ДокументыОпераций.ДокументОперации) <> ТИП(Документ.ПлатежнаяСсылкаСБПc2b)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДокументыОпераций.ДокументОперации.ОснованиеПлатежа КАК ДокументОперации,
	|	ВТ_ДокументыОпераций.ИдентификаторОперации КАК ИдентификаторОперации,
	|	ВТ_ДокументыОпераций.ДокументОперации.Сумма КАК Сумма,
	|	ИСТИНА КАК Выполнена,
	|	"""" КАК ТипОперации
	|ИЗ
	|	ВТ_ДокументыОпераций КАК ВТ_ДокументыОпераций
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ВТ_ДокументыОпераций.ДокументОперации) = ТИП(Документ.ПлатежнаяСсылкаСБПc2b)";
	
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("НастройкаПодключения", НастройкаПодключения);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Результат = Новый Структура;
	Результат.Вставить("ОперацииПолныхОплат",    РезультатыЗапроса[1].Выгрузить());
	Результат.Вставить("ОперацииЧастичныхОплат", РезультатыЗапроса[2].Выгрузить());
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыФункции

// Определяет максимальное количество попыток запроса статуса
// для отложенных операций.
//
// Параметры:
//  Оплата - Булево - признак операции оплаты.
//
// Возвращаемое значение:
//  Число - максимальное количество попыток.
//
Функция МаксимальноеКоличествоПопытокЗапросаСтатуса(Оплата) Экспорт
	
	Если Оплата Тогда
		Возврат 400;
	Иначе
		Возврат 10;
	КонецЕсли;
	
КонецФункции

// Создает описание идентификаторов оплаты СБП.
//
// Возвращаемое значение:
//  ИдентификаторОплаты - Строка - идентификатор оплаты в СБП;
//  ИдентификаторОперации - Строка - идентификатор оплаты в Системе быстрых платежей.
//
Функция НовыйИдентификаторыОперацииСБП(
		ИдентификаторОплаты,
		ИдентификаторОперации) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторОплаты", ИдентификаторОплаты);
	Результат.Вставить("ИдентификаторОперации", ИдентификаторОперации);
	
	Возврат Результат;
	
КонецФункции

// Определяет необходимость создания идентификатора операции
// или его обновления.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - текущий идентификатор операции;
//  СтатусОперации - Строка - текущий статус операции.
//
// Возвращаемое значение:
//  Булево  - если Истина, необходимо создать новый идентификатор.
//
Функция ТребуетсяГенерацияНовогоИдентификатора(Идентификатор, СтатусОперации)
	
	// Если еще не был создан необходимо
	// сгенерировать новый.
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Если операция находится в терминальном статусе
	// и результат по этой операции отрицательный, необходимо
	// обновить идентификатор.
	Если СтатусОперации = "EXCEEDED"
		Или СтатусОперации = "NOT_PAID"
		Или СтатусОперации = "NO_INFO"
		Или СтатусОперации = "DECLINED" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
