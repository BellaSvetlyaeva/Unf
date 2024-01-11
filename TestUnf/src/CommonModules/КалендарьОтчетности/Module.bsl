#Область ПрограммныйИнтерфейс

///////////////////////////////////////////////////////////////////////////////
// Размещаются процедуры и функции для работы по разделу Календарь отчетности

Функция ЗапуститьЗаполнениеВФоне(ИдентификаторФормы, Организация = Неопределено, ИзменилсяВидОрганизации = Ложь) Экспорт
	
	КлючФоновогоЗадания = "ОбновлениеЗадачОтчетности";
	Если Организация <> Неопределено Тогда 
		КлючФоновогоЗадания = КлючФоновогоЗадания + Организация.УникальныйИдентификатор();
	КонецЕсли; 
	
    ЕстьАктивныеФоновыеЗаданияОбновлениеЗадачОтчетности = КалендарьОтчетности.ЕстьАктивныеФоновыеЗаданияОбновлениеЗадачОтчетности(КлючФоновогоЗадания);
	Если ЕстьАктивныеФоновыеЗаданияОбновлениеЗадачОтчетности Тогда  	
		Возврат Ложь;
	КонецЕсли; 	
	
	ИмяПроцедуры           = "КалендарьОтчетности.ЗаполнитьВФоне";
	НаименованиеЗадания = НСтр("ru = 'Обновление списка задач отчетности.'");
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина; 
	ПараметрыВыполнения.Вставить("Организация", Организация);
	ПараметрыВыполнения.Вставить("ИзменилсяВидОрганизации", ИзменилсяВидОрганизации);
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыВыполнения, ПараметрыВыполнения); 
	
	Возврат Результат; 
	
КонецФункции

Процедура ЗаполнитьВФоне(Параметры, ВременноеХранилищеРезультата) Экспорт
	Перем Организация;
	
	Если Параметры <> Неопределено Тогда
		
		Параметры.Свойство("Организация", Организация);
		
	КонецЕсли;	
	
	ИзмененыЗадачи = ЗарегистрироватьНовыеСобытияКалендаряОтчетностиКИсполнению(Организация);
	
	ПоместитьВоВременноеХранилище(ИзмененыЗадачи, ВременноеХранилищеРезультата);
	
КонецПроцедуры


// Функция анализирует, появились ли новые события календаря отчетности, 
// чтобы зарегистрировать их к исполнению у текущего абонента 
// Анализ производится по всем или выбранной организациям абонента. 
// 
Функция ЗарегистрироватьНовыеСобытияКалендаряОтчетностиКИсполнению(Организация = Неопределено) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КалендарьПодготовкиОтчетности.Ссылка КАК СобытиеКалендаря,
	|	КалендарьПодготовкиОтчетности.ПрименяетсяДляИП КАК ПрименяетсяДляИП,
	|	КалендарьПодготовкиОтчетности.ПрименяетсяДляООО КАК ПрименяетсяДляООО,
	|	КалендарьПодготовкиОтчетности.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия,
	|	ВЫБОР
	|		КОГДА ЗадачиКалендаря.Родитель = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.АУСН)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПрименяетсяДляАУСН,
	|	ВЫБОР
	|		КОГДА ЗадачиКалендаря.Родитель = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.УСН)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПрименяетсяДляУСН,
	|	ВЫБОР
	|		КОГДА ЗадачиКалендаря.Родитель = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ЕНВД)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПрименяетсяДляЕНВД,
	|	ВЫБОР
	|		КОГДА ЗадачиКалендаря.Родитель = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ФСРАР)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПрименяетсяДляАлко,
	|	ВЫБОР
	|		КОГДА ЗадачиКалендаря.Ссылка В (&МассивЗадачПоСотрудникам)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПрименяетсяДляСотрудников,
	|	ВЫБОР
	|		КОГДА ЗадачиКалендаря.Ссылка = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ТорговыйСбор)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПрименяетсяДляТорговыйСбор,
	|	КалендарьПодготовкиОтчетности.ПометкаУдаления КАК ПометкаУдаления
	|ПОМЕСТИТЬ ВТКалендарь
	|ИЗ
	|	Справочник.КалендарьПодготовкиОтчетности КАК КалендарьПодготовкиОтчетности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗадачиКалендаряПодготовкиОтчетности КАК ЗадачиКалендаря
	|		ПО КалендарьПодготовкиОтчетности.Задача = ЗадачиКалендаря.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Ссылка,
	|	Организации.ЮридическоеФизическоеЛицо КАК ВидОрганизации,
	|	Организации.ИПИспользуетТрудНаемныхРаботников КАК ИПИспользуетТрудНаемныхРаботников,
	|	Организации.ДатаРегистрации КАК ДатаРегистрации
	|ПОМЕСТИТЬ ВТОрганизации
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И Организации.ИспользуетсяОтчетность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СобытияКРегистрацииПоОрганизациям.СобытиеКалендаря КАК СобытиеКалендаря,
	|	СобытияКРегистрацииПоОрганизациям.Организация КАК Организация,
	|	СобытияКРегистрацииПоОрганизациям.СобытиеКалендаря.Задача КАК Задача,
	|	ЗарегистрированныеСобытияКалендаря.Ссылка КАК ЗаписьКалендаря
	|ИЗ
	|	(ВЫБРАТЬ
	|		КалендарьПодготовкиОтчетности.СобытиеКалендаря КАК СобытиеКалендаря,
	|		ОрганизацииАбонента.Ссылка КАК Организация
	|	ИЗ
	|		ВТОрганизации КАК ОрганизацииАбонента
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СистемыНалогообложенияОрганизаций.СрезПоследних КАК СистемыНалогообложенияОрганизаций
	|			ПО ОрганизацииАбонента.Ссылка = СистемыНалогообложенияОрганизаций.Организация
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТКалендарь КАК КалендарьПодготовкиОтчетности
	|			ПО (ОрганизацииАбонента.ВидОрганизации = &ИП
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляИП
	|					ИЛИ ОрганизацииАбонента.ВидОрганизации = &ООО
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляООО)
	|				И (ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикУСН, ЛОЖЬ)
	|					ИЛИ НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляУСН)
	|				И (ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикЕНВД, ЛОЖЬ)
	|					ИЛИ НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляЕНВД)
	|				И (ОрганизацииАбонента.ВидОрганизации = &ООО
	|					ИЛИ ОрганизацииАбонента.ИПИспользуетТрудНаемныхРаботников
	|					ИЛИ НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляСотрудников)
	|				И (ЕСТЬNULL(СистемыНалогообложенияОрганизаций.РозничнаяПродажаАлкоголя, ЛОЖЬ)
	|					ИЛИ НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляАлко)
	|				И (ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикТорговыйСбор, ЛОЖЬ)
	|					ИЛИ НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляТорговыйСбор)
	|				И ОрганизацииАбонента.ДатаРегистрации <= КалендарьПодготовкиОтчетности.ДатаОкончанияСобытия
	|				И (ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПрименяетсяАУСН, ЛОЖЬ)
	|					ИЛИ НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляАУСН)
	|	ГДЕ
	|		&Условие
	|		И НЕ КалендарьПодготовкиОтчетности.ПометкаУдаления
	|		И ВЫБОР
	|				КОГДА СистемыНалогообложенияОрганизаций.ПрименяетсяАУСН
	|					ТОГДА КалендарьПодготовкиОтчетности.СобытиеКалендаря.Задача В (&СписокЗадачАУСН)
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ
	|		И ВЫБОР
	|				КОГДА КалендарьПодготовкиОтчетности.СобытиеКалендаря.Задача В (&МассивЗадачВзносыИП)
	|						И ГОД(КалендарьПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия) >= 2023
	|						И (ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикУСН, ЛОЖЬ)
	|								И СистемыНалогообложенияОрганизаций.ОбъектНалогообложения = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовНалогообложения.Доходы)
	|							ИЛИ СистемыНалогообложенияОрганизаций.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.ОсобыйПорядок)
	|								И ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПрименяетсяПатент, ЛОЖЬ))
	|					ТОГДА ВЫБОР
	|							КОГДА КалендарьПодготовкиОтчетности.СобытиеКалендаря.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыИП)
	|									И КОНЕЦПЕРИОДА(КалендарьПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия, МЕСЯЦ) >= КОНЕЦПЕРИОДА(&ТекущаяДата, ГОД)
	|								ТОГДА ИСТИНА
	|							КОГДА КалендарьПодготовкиОтчетности.СобытиеКалендаря.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300ТР)
	|									И ГОД(КалендарьПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия) >= ГОД(НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(&ТекущаяДата, ГОД, 1), ГОД))
	|								ТОГДА ИСТИНА
	|							ИНАЧЕ ЛОЖЬ
	|						КОНЕЦ
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ) КАК СобытияКРегистрацииПоОрганизациям
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗарегистрированныеСобытияКалендаря
	|		ПО СобытияКРегистрацииПоОрганизациям.СобытиеКалендаря = ЗарегистрированныеСобытияКалендаря.СобытиеКалендаря
	|			И СобытияКРегистрацииПоОрганизациям.Организация = ЗарегистрированныеСобытияКалендаря.Организация
	|ГДЕ
	|	(ЗарегистрированныеСобытияКалендаря.Ссылка ЕСТЬ NULL
	|			ИЛИ ЗарегистрированныеСобытияКалендаря.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СобытияКРегистрацииПоОрганизациям.СобытиеКалендаря.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКалендарь КАК КалендарьПодготовкиОтчетности
	|		ПО ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = КалендарьПодготовкиОтчетности.СобытиеКалендаря
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОрганизации КАК ОрганизацииАбонента
	|		ПО ЗаписиКалендаряПодготовкиОтчетности.Организация = ОрганизацииАбонента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СистемыНалогообложенияОрганизаций.СрезПоследних КАК СистемыНалогообложенияОрганизаций
	|		ПО ЗаписиКалендаряПодготовкиОтчетности.Организация = СистемыНалогообложенияОрганизаций.Организация
	|ГДЕ
	|	(НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления
	|				И (ОрганизацииАбонента.ВидОрганизации = &ООО
	|						И НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляООО
	|					ИЛИ ОрганизацииАбонента.ВидОрганизации = &ИП
	|						И НЕ КалендарьПодготовкиОтчетности.ПрименяетсяДляИП
	|					ИЛИ НЕ ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикУСН, ЛОЖЬ)
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляУСН
	|					ИЛИ НЕ ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПрименяетсяАУСН, ЛОЖЬ)
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляАУСН
	|					ИЛИ НЕ ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикЕНВД, ЛОЖЬ)
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляЕНВД
	|					ИЛИ КалендарьПодготовкиОтчетности.ПрименяетсяДляСотрудников
	|						И ОрганизацииАбонента.ВидОрганизации = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФИЗическоеЛицо)
	|						И НЕ ОрганизацииАбонента.ИПИспользуетТрудНаемныхРаботников
	|					ИЛИ НЕ ЕСТЬNULL(СистемыНалогообложенияОрганизаций.РозничнаяПродажаАлкоголя, ЛОЖЬ)
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляАлко
	|					ИЛИ НЕ ЕСТЬNULL(СистемыНалогообложенияОрганизаций.ПлательщикТорговыйСбор, ЛОЖЬ)
	|						И КалендарьПодготовкиОтчетности.ПрименяетсяДляТорговыйСбор
	|					ИЛИ КалендарьПодготовкиОтчетности.ПометкаУдаления)
	|			ИЛИ ОрганизацииАбонента.ДатаРегистрации > КалендарьПодготовкиОтчетности.ДатаОкончанияСобытия
	|				И &Условие)");
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ИП", Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
	Запрос.УстановитьПараметр("ООО", Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
	МассивЗадачПоСотрудникам = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ПолучитьМассивЗадачПоСотрудникам(Организация);
	Запрос.УстановитьПараметр("МассивЗадачПоСотрудникам", МассивЗадачПоСотрудникам); 
	
	МассивЗадачВзносыИП = 	Новый Массив;
	МассивЗадачВзносыИП.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыИП); 
	МассивЗадачВзносыИП.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300ТР); 
	
	Запрос.УстановитьПараметр("МассивЗадачВзносыИП", МассивЗадачВзносыИП);
	
	МассивЗадачАУСН = Справочники.ЗадачиКалендаряПодготовкиОтчетности.ПолучитьМассивЗадачДляАУСН(Организация);
	Запрос.УстановитьПараметр("СписокЗадачАУСН", МассивЗадачАУСН); 
	
	Если Организация <> Неопределено Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", "ОрганизацииАбонента.Ссылка = &Организация");
	Иначе
		Запрос.УстановитьПараметр("Условие", Истина);
	КонецЕсли;
	БылиИзмененыЗадачи = Ложь;
	
	ПакетЗапроса = Запрос.ВыполнитьПакет();
	
	НачатьТранзакцию(); 	
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ЗаписиКалендаряПодготовкиОтчетности");     
    	Блокировка.Заблокировать();
		
		// Задачи к регистрации
		Результат = ПакетЗапроса[2];
		
		Если НЕ Результат.Пустой() Тогда
			БылиИзмененыЗадачи = Истина;
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если ЗначениеЗаполнено(Выборка.ЗаписьКалендаря) Тогда 
					ЗаписьКалендаряПодготовкиОтчетности = Выборка.ЗаписьКалендаря.ПолучитьОбъект();
					ЗаписьКалендаряПодготовкиОтчетности.УстановитьПометкуУдаления(Ложь);
				Иначе
					ЗаписьКалендаряПодготовкиОтчетности = Справочники.ЗаписиКалендаряПодготовкиОтчетности.СоздатьЭлемент();
				КонецЕсли;
				ЗаписьКалендаряПодготовкиОтчетности.Организация = Выборка.Организация;
				ЗаписьКалендаряПодготовкиОтчетности.СобытиеКалендаря = Выборка.СобытиеКалендаря;
				ЗаписьКалендаряПодготовкиОтчетности.Состояние = Перечисления.СостоянияСобытийКалендаря.НеНачато;
				ЗаписьКалендаряПодготовкиОтчетности.ДополнительнаяИнформация = КалендарьОтчетностиПовтИсп.ПолучитьНачальныйСтатусСобытияПоВидуЗадачи(Выборка.Задача);
				ЗаписьКалендаряПодготовкиОтчетности.Записать();
			КонецЦикла;
		КонецЕсли;
		
		// Задачи к удалению
		Результат = ПакетЗапроса[3];
		Если НЕ Результат.Пустой() Тогда
			БылиИзмененыЗадачи = Истина;
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				ОбъектЗаписьКалендаря = Выборка.Ссылка.ПолучитьОбъект();
				ОбъектЗаписьКалендаря.УстановитьПометкуУдаления(Истина);
			КонецЦикла;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		// Вероятно запущен еще один процесс обновления
		// Поэтому не обрабатываем исключение
		ОтменитьТранзакцию(); 
	КонецПопытки;
	
	РассчитатьСуммыНалоговПоДаннымИБ();
	
	Возврат БылиИзмененыЗадачи;
	
КонецФункции

// Возвращает дату смены последнего события
//
//
Функция ПолучитьДатуСменыСостояния(Организация, СобытиеКалендаря) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряПодготовкиОтчетности.ДатаСменыСостояния КАК ДатаСменыСостояния
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|ГДЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация = &Организация
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = &СобытиеКалендаря
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СобытиеКалендаря", СобытиеКалендаря);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДатаСменыСостояния;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции


Процедура РассчитатьСуммыНалоговПоДаннымИБ() Экспорт
	Если Месяц(ТекущаяДатаСеанса()) <= 4 Тогда
		ДатаНачалаРасчета = Дата(Год(ТекущаяДатаСеанса())-1,6,1);
	Иначе
		ДатаНачалаРасчета = НачалоГода(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ДатаОкончанияРасчета = КонецГода(КонецГода(ТекущаяДатаСеанса())+1);
	// Формирование записей КУДиР
	РегламентированнаяОтчетностьУСН.ВыполнитьФормированияВсехЗаписейКУДИР(ДатаОкончанияРасчета);
	// Получение задач, которые не выполнялись
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала",ДатаНачалаРасчета);
	Запрос.УстановитьПараметр("ДатаОкончания",ДатаОкончанияРасчета);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Ссылка КАК Ссылка,
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация КАК Организация,
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия,
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.Задача КАК Задача
	|ПОМЕСТИТЬ ВТЗаписиКОбработке
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ДатаПервогоВходаВСистему КАК ДатаПервогоВходаВСистему
	|		ПО (ИСТИНА)
	|ГДЕ
	|	НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.ЭтоТочныйРасчет
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.Завершено
	|	И НЕ(ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия <= ДатаПервогоВходаВСистему.Значение
	|				И ЗаписиКалендаряПодготовкиОтчетности.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСобытийКалендаря.НеНачато))
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия МЕЖДУ &ДатаНачала И &ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия,
	|	ЗаписиКОбработке.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ВЫБОР
	|		КОГДА ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.АвансовыйПлатежПоУСН)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоАвансовыйОтчет
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|ГДЕ
	|	ЗаписиКОбработке.Задача В (ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.АвансовыйПлатежПоУСН), ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалог))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация КАК Организация,
	|	МАКСИМУМ(ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаОкончанияСобытия) КАК ДатаОкончанияСобытия
	|ПОМЕСТИТЬ ВТРассчитанныеЗаписиЕНВД
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|ГДЕ
	|	НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД)
	|	И ЗаписиКалендаряПодготовкиОтчетности.ЭтоТочныйРасчет
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТРассчитанныеЗаписиЕНВД.Организация КАК Организация,
	|	ЗаписиКалендаряПодготовкиОтчетности.СуммаНалога КАК СуммаНалога
	|ПОМЕСТИТЬ ВТРассчитанныеЗаписиЕНВДСНалогом
	|ИЗ
	|	ВТРассчитанныеЗаписиЕНВД КАК ВТРассчитанныеЗаписиЕНВД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КалендарьПодготовкиОтчетности КАК КалендарьПодготовкиОтчетности
	|		ПО ВТРассчитанныеЗаписиЕНВД.ДатаОкончанияСобытия = КалендарьПодготовкиОтчетности.ДатаОкончанияСобытия
	|			И (КалендарьПодготовкиОтчетности.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД))
	|			И (НЕ КалендарьПодготовкиОтчетности.ПометкаУдаления)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|		ПО (КалендарьПодготовкиОтчетности.Ссылка = ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря)
	|			И ВТРассчитанныеЗаписиЕНВД.Организация = ЗаписиКалендаряПодготовкиОтчетности.Организация
	|			И (НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия,
	|	ЕСТЬNULL(ВТРассчитанныеЗаписиЕНВДСНалогом.СуммаНалога, 0) КАК СуммаНалога
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРассчитанныеЗаписиЕНВДСНалогом КАК ВТРассчитанныеЗаписиЕНВДСНалогом
	|		ПО (ВТРассчитанныеЗаписиЕНВДСНалогом.Организация = ЗаписиКОбработке.Организация)
	|ГДЕ
	|	ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|ГДЕ
	|	ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300ТР)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|ГДЕ
	|	ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыИП)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|ГДЕ
	|	ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.НалогиСотрудников)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|ГДЕ
	|	ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.ТорговыйСбор)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаписиКОбработке.Ссылка КАК Ссылка,
	|	ЗаписиКОбработке.Организация КАК Организация,
	|	ЗаписиКОбработке.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКОбработке.ДатаДокументаОбработкиСобытия КАК ДатаДокументаОбработкиСобытия,
	|	ЗаписиКОбработке.ДатаОкончанияСобытия КАК ДатаОкончанияСобытия
	|ИЗ
	|	ВТЗаписиКОбработке КАК ЗаписиКОбработке
	|ГДЕ
	|	ЗаписиКОбработке.Задача = ЗНАЧЕНИЕ(Справочник.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыЗаСотрудников)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКОбработке.ДатаОкончанияСобытия";
	Пакет = Запрос.ВыполнитьПакет();
	
	// Выполняем задачи по УСН
	ЗадачиПоУСН = Пакет[1].Выбрать();
	Пока ЗадачиПоУСН.Следующий() Цикл
		Если ЗадачиПоУСН.ЭтоАвансовыйОтчет Тогда
			РегламентированнаяОтчетностьУСН.ВыполнитьРасчетАвансовогоПлатежаПредварительный(ЗадачиПоУСН.Организация, ЗадачиПоУСН.ДатаОкончанияСобытия, ЗадачиПоУСН.ДатаДокументаОбработкиСобытия, ЗадачиПоУСН.Ссылка);
		Иначе
			РегламентированнаяОтчетностьУСН.ВыполнитьРасчетЕдиногоНалогаПредварительный(ЗадачиПоУСН.Организация, ЗадачиПоУСН.ДатаОкончанияСобытия, ЗадачиПоУСН.ДатаДокументаОбработкиСобытия, ЗадачиПоУСН.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	// Заполняем задачи по ЕНВД суммой налога за предыдущие периоды
	ЗадачиПоЕНВД = Пакет[4].Выбрать();
	Пока ЗадачиПоЕНВД.Следующий() Цикл
		НалогПоЕНВДОбъект = ЗадачиПоЕНВД.Ссылка.ПолучитьОбъект();
		Если НалогПоЕНВДОбъект.СуммаНалога <> ЗадачиПоЕНВД.СуммаНалога Тогда
			
			НачатьТранзакцию();
			Попытка
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник.ЗаписиКалендаряПодготовкиОтчетности");
				Блокировка.Заблокировать();
				
				НалогПоЕНВДОбъект.СуммаНалога = ЗадачиПоЕНВД.СуммаНалога;
				НалогПоЕНВДОбъект.Записать();
				
				ЗафиксироватьТранзакцию();
			Исключение
				// Вероятно запущен еще один процесс обновления
				// Поэтому не обрабатываем исключение
				ОтменитьТранзакцию(); 
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	// Выполняем задачи по доходам свыше 300 тыс.руб.
	
	ЗадачиОплатаСвыше300тр = Пакет[5].Выбрать();
	Пока ЗадачиОплатаСвыше300тр.Следующий() Цикл
		РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРПриДоходахСвыше300трПредварительный(ЗадачиОплатаСвыше300тр.Организация, ЗадачиОплатаСвыше300тр.ДатаОкончанияСобытия, ЗадачиОплатаСвыше300тр.ДатаДокументаОбработкиСобытия, ЗадачиОплатаСвыше300тр.Ссылка);
	КонецЦикла;
	
	ЗадачиОплатаСтраховыеВзносыИП = Пакет[6].Выбрать();
	Пока ЗадачиОплатаСтраховыеВзносыИП.Следующий() Цикл
		РегламентированнаяОтчетностьУСН.ВыполнитьРасчетВзносовВПФРиФССПредварительный(ЗадачиОплатаСтраховыеВзносыИП.Организация, ЗадачиОплатаСтраховыеВзносыИП.ДатаОкончанияСобытия, ЗадачиОплатаСтраховыеВзносыИП.ДатаДокументаОбработкиСобытия, ЗадачиОплатаСтраховыеВзносыИП.Ссылка);
	КонецЦикла;
	
	ЗадачиОплатаНалогиСотрудников = Пакет[7].Выбрать();
	Пока ЗадачиОплатаНалогиСотрудников.Следующий() Цикл
		РегламентированнаяОтчетностьСотрудники.ВыполнитьРасчетВзносовИНалоговПоСотрудникамПредварительный(ЗадачиОплатаНалогиСотрудников.Организация, ЗадачиОплатаНалогиСотрудников.ДатаОкончанияСобытия, ЗадачиОплатаНалогиСотрудников.ДатаДокументаОбработкиСобытия, ЗадачиОплатаНалогиСотрудников.Ссылка);
	КонецЦикла;
	
	ЗадачиОплатаТорговыйСбор = Пакет[8].Выбрать();
	Пока ЗадачиОплатаТорговыйСбор.Следующий() Цикл
		РегламентированнаяОтчетностьУСН.ВыполнитьРасчетТорговогоСбораПредварительный(ЗадачиОплатаТорговыйСбор.Организация, ЗадачиОплатаТорговыйСбор.ДатаОкончанияСобытия, ЗадачиОплатаТорговыйСбор.Ссылка);
	КонецЦикла;  
	
	ЗадачиСтраховыеВзносыЗаСотрудников = Пакет[9].Выбрать();
	Пока ЗадачиСтраховыеВзносыЗаСотрудников.Следующий() Цикл
		РегламентированнаяОтчетностьСотрудники.ВыполнитьРасчетВзносовПоСотрудникамПредварительный(ЗадачиСтраховыеВзносыЗаСотрудников.Организация, ЗадачиСтраховыеВзносыЗаСотрудников.ДатаДокументаОбработкиСобытия, ЗадачиСтраховыеВзносыЗаСотрудников.ДатаДокументаОбработкиСобытия, ЗадачиСтраховыеВзносыЗаСотрудников.Ссылка);
	КонецЦикла;

КонецПроцедуры

// -----------------------------------------------------------------------------
// Секция поиска документов для отчетности

// Функция осуществляет поиск подходящего события календаря по задаче
// Поиск находит первое событие по передаваемой задаче, по которой работа пользователя
// не была еще завершена.
//
// Параметры:
//		ЗадачаКалендаря - СправочникСсылка.ЗадачиКалендаряОтчетности
//		Организация - СправочникСсылка.Организации - по некоторым ОЕ события могут быть уже завершены
//
Функция НайтиСобытиеКалендаряПоЗадаче(ЗадачаКалендаря, Организация) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря КАК СобытиеКалендаря
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|ГДЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация = &Организация
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.Завершено
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.Задача = &Задача
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ПометкаУдаления
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаНачалаСобытия");
	
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Задача",ЗадачаКалендаря);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СобытиеКалендаря;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция осуществляет поиск подходящего события календаря по задаче
// Поиск находит первое событие по передаваемой задаче, по которой работа пользователя
// не была еще завершена.
//
// Параметры:
//		ЗадачаКалендаря - СправочникСсылка.ЗадачиКалендаряОтчетности
//		Организация - СправочникСсылка.Организации - по некоторым ОЕ события могут быть уже завершены
//   Возвращает:
//		Структура:
//			СобытиеКалендаря
//			СостояниеСобытия
//
Функция ПолучитьСтруктуруСобытияКалендаряПоЗадаче(ЗадачаКалендаря, Организация) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря КАК СобытиеКалендаря,
	|	ЗаписиКалендаряПодготовкиОтчетности.Состояние КАК СостояниеСобытия
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|ГДЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация = &Организация
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.Завершено
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.Задача = &Задача
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ПометкаУдаления
	|	И НЕ ЗаписиКалендаряПодготовкиОтчетности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря.ДатаНачалаСобытия");
	
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Задача",ЗадачаКалендаря);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Новый Структура("СобытиеКалендаря, СостояниеСобытия", Выборка.СобытиеКалендаря, Выборка.СостояниеСобытия);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСобытиеРасчетаЕдиногоНалогаВПериоде(ПериодОтчетности) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарьПодготовкиОтчетности.Ссылка
	|ИЗ
	|	Справочник.КалендарьПодготовкиОтчетности КАК КалендарьПодготовкиОтчетности
	|ГДЕ
	|	КалендарьПодготовкиОтчетности.Задача = &Задача
	|	И КалендарьПодготовкиОтчетности.ДатаДокументаОбработкиСобытия МЕЖДУ &ДатаНачалаСобытия И &ДатаОкончанияСобытия");
	
	Запрос.УстановитьПараметр("Задача", Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалог);
	Запрос.УстановитьПараметр("ДатаНачалаСобытия", НачалоГода(ПериодОтчетности));
	Запрос.УстановитьПараметр("ДатаОкончанияСобытия", КонецГода(ПериодОтчетности));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Конец секции поиска
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// секция работы с документы отчетности

// Процедура записывает состояние в регистр состояния событий по отчетности
//
Процедура ЗаписатьСостояниеСобытияКалендаря(Организация, СобытиеКалендаря, СостояниеКалендаря, ДополнительнаяИнформация, СуммаНалога = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаписиКалендаряПодготовкиОтчетности.Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|ГДЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация = &Организация
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = &СобытиеКалендаря";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СобытиеКалендаря", СобытиеКалендаря);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Запись = Выборка.Ссылка.ПолучитьОбъект();
	Иначе
		Запись = Справочники.ЗаписиКалендаряПодготовкиОтчетности.СоздатьЭлемент();
	КонецЕсли;    
    Запись.Организация				= Организация;
	Запись.СобытиеКалендаря			= СобытиеКалендаря;
	Запись.Состояние				= СостояниеКалендаря;
	Запись.ДополнительнаяИнформация	= ДополнительнаяИнформация;
	Запись.ДатаСменыСостояния		= ТекущаяДатаСеанса();
	Если СуммаНалога <> Неопределено Тогда
		Запись.СуммаНалога = СуммаНалога;
		Запись.ЭтоТочныйРасчет = Истина;
	КонецЕсли;   
	
	НачатьТранзакцию(); 	
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ЗаписиКалендаряПодготовкиОтчетности");     
		ЭлементБлокировки.УстановитьЗначение("Ссылка",Запись.Ссылка);
		Блокировка.Заблокировать();
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение    
		// Вероятно запущен еще один процесс обновления
		// Поэтому не обрабатываем исключение
		ОтменитьТранзакцию(); 
	КонецПопытки; 
	
КонецПроцедуры    

Процедура ЗаписатьСобытиеКалендаря(Запись) Экспорт
	НачатьТранзакцию(); 	
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ЗаписиКалендаряПодготовкиОтчетности");     
		ЭлементБлокировки.УстановитьЗначение("Ссылка",Запись.Ссылка);
		Блокировка.Заблокировать();
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		// Вероятно запущен еще один процесс обновления
		// Поэтому не обрабатываем исключение
		ОтменитьТранзакцию(); 
	КонецПопытки;   
КонецПроцедуры	

Функция ЕстьАктивныеФоновыеЗаданияОбновлениеЗадачОтчетности(КлючФоновогоЗадания) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Ключ", КлючФоновогоЗадания);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	АктивныеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат (АктивныеФоновыеЗадания.Количество() > 0);
	
КонецФункции

Функция ПолучитьАктивныеФоновыеЗаданияОбновлениеЗадачОтчетности(КлючФоновогоЗадания) Экспорт 
	
	Отбор = Новый Структура;
	Отбор.Вставить("Ключ", КлючФоновогоЗадания);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	АктивныеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат АктивныеФоновыеЗадания;
	
КонецФункции

// Процедура по событию календаря и организации возвращает состояние события
//
Функция ПолучитьСостояниеСобытияКалендаря(Организация, СобытиеКалендаря) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряПодготовкиОтчетности.Состояние
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|ГДЕ
	|	ЗаписиКалендаряПодготовкиОтчетности.Организация = &Организация
	|	И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = &СобытиеКалендаря");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СобытиеКалендаря", СобытиеКалендаря);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Состояние;
	Иначе
		Возврат Перечисления.СостоянияСобытийКалендаря.Заполнить;
	КонецЕсли;
	
КонецФункции
 
// Процедура определяет состояние события календаря на основании документа
// отчетности
//
// В случае, если не удается определить состояние события, то возвращает Неопределено
//
// Параметры: 
//		ДокументОтчетности - ДокументСсылка
//
// Возвращает:
//		Перечисление.СостояниеСобытийКалендаряОтчетности или Неопределено
//
Функция ПолучитьСостояниеСобытияКалендаряПоДокументуОтчетности(ДокументОтчетности) Экспорт
	
	ИмяДокумента = ДокументОтчетности.Метаданные().Имя;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаписиКалендаряПодготовкиОтчетности.Состояние КАК Состояние
	|ИЗ
	|	Справочник.ЗаписиКалендаряПодготовкиОтчетности КАК ЗаписиКалендаряПодготовкиОтчетности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ." + ИмяДокумента +" КАК ДокументОтчетности
	|		ПО ЗаписиКалендаряПодготовкиОтчетности.Организация = ДокументОтчетности.Организация
	|			И ЗаписиКалендаряПодготовкиОтчетности.СобытиеКалендаря = ДокументОтчетности.СобытиеКалендаря
	|			И (ДокументОтчетности.Ссылка = &Документ)");
	
	Запрос.УстановитьПараметр("Документ", ДокументОтчетности);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Состояние;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции



// Процедура записывает состояние в регистр состояния событий по отчетности
//
Процедура ЗавершитьСобытиеКалендаряОтчетности(Организация, СобытиеКалендаря, ДополнительнаяИнформация) Экспорт
	
	НачатьТранзакцию();
	
	
	Ссылка = Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьЗаписьКалендаря(Организация, СобытиеКалендаря);
	
	Если Ссылка <> Неопределено Тогда
		Запись = Ссылка.ПолучитьОбъект();
	Иначе
		Запись = Справочники.ЗаписиКалендаряПодготовкиОтчетности.СоздатьЭлемент();
	КонецЕсли;
	
	Запись.Организация				= Организация;
	Запись.СобытиеКалендаря			= СобытиеКалендаря;
	Запись.Состояние				= Перечисления.СостоянияСобытийКалендаря.Завершено;
	Запись.ДополнительнаяИнформация	= ДополнительнаяИнформация;
	Запись.ДатаСменыСостояния		= ТекущаяДатаСеанса();
	Запись.Завершено = Истина;
	Запись.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// конец секции работы с документами отчетности
// -----------------------------------------------------------------------------

#КонецОбласти
