#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.СерииНоменклатуры.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияСерииНоменклатурыИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияСерииНоменклатурыИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияСерииНоменклатурыИзменение Тогда
		
		// Если временная таблица "ДвиженияСерииНоменклатурыИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияСерииНоменклатурыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СерииНоменклатуры.НомерСтроки КАК НомерСтроки,
		|	СерииНоменклатуры.Номенклатура КАК Номенклатура,
		|	СерииНоменклатуры.Характеристика КАК Характеристика,
		|	СерииНоменклатуры.Партия КАК Партия,
		|	СерииНоменклатуры.Серия КАК Серия,
		|	СерииНоменклатуры.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	СерииНоменклатуры.Ячейка КАК Ячейка,
		|	ВЫБОР
		|		КОГДА СерииНоменклатуры.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА СерииНоменклатуры.Количество
		|		ИНАЧЕ -СерииНоменклатуры.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью,
		|	СерииНоменклатуры.Организация КАК Организация
		|ПОМЕСТИТЬ ДвиженияСерииНоменклатурыПередЗаписью
		|ИЗ
		|	РегистрНакопления.СерииНоменклатуры КАК СерииНоменклатуры
		|ГДЕ
		|	СерииНоменклатуры.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияСерииНоменклатурыИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияСерииНоменклатурыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияСерииНоменклатурыИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСерииНоменклатурыИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияСерииНоменклатурыИзменение.Характеристика КАК Характеристика,
		|	ДвиженияСерииНоменклатурыИзменение.Партия КАК Партия,
		|	ДвиженияСерииНоменклатурыИзменение.Серия КАК Серия,
		|	ДвиженияСерииНоменклатурыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияСерииНоменклатурыИзменение.Ячейка КАК Ячейка,
		|	ДвиженияСерииНоменклатурыИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
		|	ДвиженияСерииНоменклатурыИзменение.Организация КАК Организация
		|ПОМЕСТИТЬ ДвиженияСерииНоменклатурыПередЗаписью
		|ИЗ
		|	ДвиженияСерииНоменклатурыИзменение КАК ДвиженияСерииНоменклатурыИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СерииНоменклатуры.НомерСтроки,
		|	СерииНоменклатуры.Номенклатура,
		|	СерииНоменклатуры.Характеристика,
		|	СерииНоменклатуры.Партия,
		|	СерииНоменклатуры.Серия,
		|	СерииНоменклатуры.СтруктурнаяЕдиница,
		|	СерииНоменклатуры.Ячейка,
		|	ВЫБОР
		|		КОГДА СерииНоменклатуры.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА СерииНоменклатуры.Количество
		|		ИНАЧЕ -СерииНоменклатуры.Количество
		|	КОНЕЦ,
		|	СерииНоменклатуры.Организация
		|ИЗ
		|	РегистрНакопления.СерииНоменклатуры КАК СерииНоменклатуры
		|ГДЕ
		|	СерииНоменклатуры.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияСерииНоменклатурыИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияСерииНоменклатурыИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСерииНоменклатурыИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияСерииНоменклатурыИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияСерииНоменклатурыИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияСерииНоменклатурыИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияСерииНоменклатурыИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияСерииНоменклатурыИзменение.Характеристика КАК Характеристика,
	|	ДвиженияСерииНоменклатурыИзменение.Партия КАК Партия,
	|	ДвиженияСерииНоменклатурыИзменение.Серия КАК Серия,
	|	ДвиженияСерииНоменклатурыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияСерииНоменклатурыИзменение.Ячейка КАК Ячейка,
	|	СУММА(ДвиженияСерииНоменклатурыИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияСерииНоменклатурыИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияСерииНоменклатурыИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи,
	|	ДвиженияСерииНоменклатурыИзменение.Организация КАК Организация
	|ПОМЕСТИТЬ ДвиженияСерииНоменклатурыИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияСерииНоменклатурыПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияСерииНоменклатурыПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияСерииНоменклатурыПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияСерииНоменклатурыПередЗаписью.Партия КАК Партия,
	|		ДвиженияСерииНоменклатурыПередЗаписью.Серия КАК Серия,
	|		ДвиженияСерииНоменклатурыПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияСерииНоменклатурыПередЗаписью.Ячейка КАК Ячейка,
	|		ДвиженияСерииНоменклатурыПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияСерииНоменклатурыПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи,
	|		ДвиженияСерииНоменклатурыПередЗаписью.Организация КАК Организация
	|	ИЗ
	|		ДвиженияСерииНоменклатурыПередЗаписью КАК ДвиженияСерииНоменклатурыПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияСерииНоменклатурыПриЗаписи.НомерСтроки,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Номенклатура,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Характеристика,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Партия,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Серия,
	|		ДвиженияСерииНоменклатурыПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Ячейка,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияСерииНоменклатурыПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияСерииНоменклатурыПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияСерииНоменклатурыПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Количество,
	|		ДвиженияСерииНоменклатурыПриЗаписи.Организация
	|	ИЗ
	|		РегистрНакопления.СерииНоменклатуры КАК ДвиженияСерииНоменклатурыПриЗаписи
	|	ГДЕ
	|		ДвиженияСерииНоменклатурыПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияСерииНоменклатурыИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияСерииНоменклатурыИзменение.Номенклатура,
	|	ДвиженияСерииНоменклатурыИзменение.Характеристика,
	|	ДвиженияСерииНоменклатурыИзменение.Партия,
	|	ДвиженияСерииНоменклатурыИзменение.Серия,
	|	ДвиженияСерииНоменклатурыИзменение.СтруктурнаяЕдиница,
	|	ДвиженияСерииНоменклатурыИзменение.Ячейка,
	|	ДвиженияСерииНоменклатурыИзменение.Организация
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияСерииНоменклатурыИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	Серия,
	|	СтруктурнаяЕдиница,
	|	Ячейка");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияСерииНоменклатурыИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияСерииНоменклатурыИзменение", НЕ РезультатЗапроса.Пустой());
	
	// Временная таблица "ДвиженияСерииНоменклатурыПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСерииНоменклатурыПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	// Регистрация ШтрихкодовУпаковок для продукции из натурального меха.
	ЗарегистрироватьШтрихкодыУпаковокПродукцииИзНатуральногоМеха(СтруктураВременныеТаблицы.МенеджерВременныхТаблиц);
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьШтрихкодыУпаковокПродукцииИзНатуральногоМеха(МенеджерВременныхТаблиц)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ")
		И НЕ ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(Перечисления.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДвиженияСерииНоменклатурыИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияСерииНоменклатурыИзменение.Характеристика КАК Характеристика,
	|	ДвиженияСерииНоменклатурыИзменение.Серия КАК Серия,
	|	СерииНоменклатуры.НомерКиЗГИСМ КАК Штрихкод,
	|	СерииНоменклатуры.RFIDTID КАК RFIDTID,
	|	СерииНоменклатуры.RFIDUser КАК RFIDUser,
	|	СерииНоменклатуры.RFIDEPC КАК RFIDEPC,
	|	СерииНоменклатуры.EPCGTIN КАК EPCGTIN
	|ПОМЕСТИТЬ втДанныеСерий
	|ИЗ
	|	ДвиженияСерииНоменклатурыИзменение КАК ДвиженияСерииНоменклатурыИзменение
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|		ПО ДвиженияСерииНоменклатурыИзменение.Серия = СерииНоменклатуры.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ДвиженияСерииНоменклатурыИзменение.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	СерииНоменклатуры.НомерКиЗГИСМ <> """"
	|	И СправочникНоменклатура.ВидПродукцииИС = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха)
	|	И СправочникНоменклатура.ИспользоватьХарактеристики
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеСерий.Номенклатура КАК Номенклатура,
	|	втДанныеСерий.Характеристика КАК Характеристика,
	|	втДанныеСерий.Серия КАК Серия,
	|	втДанныеСерий.Штрихкод КАК Штрихкод
	|ИЗ
	|	втДанныеСерий КАК втДанныеСерий
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
	|		ПО втДанныеСерий.Штрихкод = ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода
	|ГДЕ
	|	ШтрихкодыУпаковокТоваров.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеСерий.Штрихкод КАК ЗначениеШтрихкода,
	|	втДанныеСерий.RFIDTID КАК RFIDTID,
	|	втДанныеСерий.RFIDUser КАК RFIDUser,
	|	втДанныеСерий.RFIDEPC КАК RFIDEPC,
	|	втДанныеСерий.EPCGTIN КАК EPCGTIN
	|ИЗ
	|	втДанныеСерий КАК втДанныеСерий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеRFIDИСМП КАК ДанныеRFIDИСМП
	|		ПО втДанныеСерий.RFIDTID = ДанныеRFIDИСМП.RFIDTID
	|ГДЕ
	|	НЕ втДанныеСерий.RFIDTID = """"
	|	И ДанныеRFIDИСМП.RFIDTID ЕСТЬ NULL";
	
	РезультатПакета = Запрос.ВыполнитьПакет();
	
	// Создание ШтрихкодаУпаковки.
	ВыборкаШтрихкоды = РезультатПакета[РезультатПакета.Количество() - 2].Выбрать();
	Пока ВыборкаШтрихкоды.Следующий() Цикл
		ДанныеШтрихкода = ИнтеграцияИСУНФ.ДанныеШтрихкодаПродукцииИзНатуральногоМеха();
		ЗаполнитьЗначенияСвойств(ДанныеШтрихкода, ВыборкаШтрихкоды);
		Справочники.ШтрихкодыУпаковокТоваров.СоздатьШтрихкодУпаковки(ДанныеШтрихкода);
	КонецЦикла;
	
	// Регистрация данных RFID.
	ВыборкаRFID = РезультатПакета[РезультатПакета.Количество() - 1].Выбрать();
	Пока ВыборкаRFID.Следующий() Цикл
		ДанныеRFID = РегистрыСведений.ДанныеRFIDИСМП.НовыйЭлементЗаписиДанных();
		ЗаполнитьЗначенияСвойств(ДанныеRFID, ВыборкаRFID);
		
		Попытка
			РегистрыСведений.ДанныеRFIDИСМП.ЗаписатьДанные(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеRFID));
		Исключение
			ТекстСообщения = НСтр("ru='Не удалось записать данные RFID в регистр ""Данные RFID ИС МП"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли