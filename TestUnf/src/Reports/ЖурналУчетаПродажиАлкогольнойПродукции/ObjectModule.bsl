#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.РазрешеноИзменятьВарианты = Ложь;
	Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские
//                                                                                 настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	
	ПараметрыОтчета = КомпоновщикНастроек.Настройки;
	
	Период	= ПараметрыОтчета.ПараметрыДанных.НайтиЗначениеПараметра(
				Новый ПараметрКомпоновкиДанных("Период")).Значение;
					
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	Иначе
		Организация = ПараметрыОтчета.ПараметрыДанных.НайтиЗначениеПараметра(
			Новый ПараметрКомпоновкиДанных("Организация")).Значение;
	КонецЕсли;
		
	Если Не ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам") Тогда
		Склад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	Иначе
		Склад = ПараметрыОтчета.ПараметрыДанных.НайтиЗначениеПараметра(
			Новый ПараметрКомпоновкиДанных("Склад")).Значение;
	КонецЕсли;
					
	ВыводитьТитульныйЛист = ПараметрыОтчета.ПараметрыДанных.НайтиЗначениеПараметра(
								Новый ПараметрКомпоновкиДанных("ВыводитьТитульныйЛист")).Значение;
								
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнено значение обязательного параметра ""Организация""'");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Склад) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнено значение обязательного параметра ""Склад""'");
	КонецЕсли;
					
	МассивНастроек = Новый Массив;
	
	ДатаНачалаИспользованияНовойФормыЖурнала = Дата(2016, 1, 1, 0, 0, 0);
	
	Если Период.ДатаНачала>=ДатаНачалаИспользованияНовойФормыЖурнала Тогда
		
		МассивНастроек.Добавить(Новый Структура("НовыйФормат, Макет, ДатаНачала, ДатаОкончания, СведенияОбОрганизации, АдресМагазина",
												Истина,
												Отчеты.ЖурналУчетаПродажиАлкогольнойПродукции.ПолучитьМакет("ПФ_MXL_164"),
												Период.ДатаНачала,
												Период.ДатаОкончания,
												ПечатьДокументовУНФ.СведенияОЮрФизЛице(Организация, Период.ДатаОкончания),
												УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Склад, Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы)));
		
	ИначеЕсли Период.ДатаОкончания < ДатаНачалаИспользованияНовойФормыЖурнала Тогда
		
		МассивНастроек.Добавить(Новый Структура("НовыйФормат, Макет, ДатаНачала, ДатаОкончания, СведенияОбОрганизации",
												Ложь,
												Отчеты.ЖурналУчетаПродажиАлкогольнойПродукции.ПолучитьМакет("Макет"),
												Период.ДатаНачала,
												Период.ДатаОкончания,
												ПечатьДокументовУНФ.СведенияОЮрФизЛице(Организация, Период.ДатаОкончания)));
		
	Иначе
		
		МассивНастроек.Добавить(Новый Структура("НовыйФормат, Макет, ДатаНачала, ДатаОкончания, СведенияОбОрганизации",
												Ложь,
												Отчеты.ЖурналУчетаПродажиАлкогольнойПродукции.ПолучитьМакет("Макет"),
												Период.ДатаНачала,
												ДатаНачалаИспользованияНовойФормыЖурнала-86400,
												ПечатьДокументовУНФ.СведенияОЮрФизЛице(Организация, ДатаНачалаИспользованияНовойФормыЖурнала-86400)));
		МассивНастроек.Добавить(Новый Структура("НовыйФормат, Макет, ДатаНачала, ДатаОкончания, СведенияОбОрганизации, АдресМагазина",
												Истина,
												Отчеты.ЖурналУчетаПродажиАлкогольнойПродукции.ПолучитьМакет("ПФ_MXL_164"),
												ДатаНачалаИспользованияНовойФормыЖурнала,
												Период.ДатаОкончания,
												ПечатьДокументовУНФ.СведенияОЮрФизЛице(Организация, Период.ДатаОкончания),
												УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Склад, Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы)));
		
	КонецЕсли;

	ВыводитьГоризонтальныйРазделительСтраниц = Ложь;
	
	Для Каждого ТекНастройка Из МассивНастроек Цикл
		
		Если ВыводитьГоризонтальныйРазделительСтраниц Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		//ТИТУЛЬНЫЙ ЛИСТ +
		Если ВыводитьТитульныйЛист = Истина Тогда
			ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("ТитульныйЛист");
			
			ОбластьМакета.Параметры.ПредставлениеПериода = ПредставлениеПериода(Период.ДатаНачала, Период.ДатаОкончания);
			ОбластьМакета.Параметры.НазваниеОрганизации = ПечатьДокументовУНФ.ОписаниеОрганизации(ТекНастройка.СведенияОбОрганизации, "ПолноеНаименование");
			Если НЕ ТекНастройка.НовыйФормат Тогда
				ОбластьМакета.Параметры.Склад = Склад;
			Иначе
				ОбластьМакета.Параметры.ИННКПП = ТекНастройка.СведенияОбОрганизации.ИНН 
					+ ?(Организация.ЮридическоеФизическоеЛицо=Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, " / " + ТекНастройка.СведенияОбОрганизации.КПП, "");
				ОбластьМакета.Параметры.Адрес = ТекНастройка.АдресМагазина;
			КонецЕсли;
			
			ДокументРезультат.Вывести(ОбластьМакета);
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			
			ДокументРезультат.Область("R1:R" + ДокументРезультат.ВысотаТаблицы).Имя = "ТитульныйЛист";
		КонецЕсли;
		//ТИТУЛЬНЫЙ ЛИСТ -
		
		//ШАПКА +
		ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("Шапка");
		ДокументРезультат.Вывести(ОбластьМакета);
		ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(11, , 11, );
		//ШАПКА -
		
		//СТРОКИ ОТЧЕТА +
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("Склад", Склад);
		Если МассивНастроек.Количество() = 2 Тогда
			Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(Период.ДатаНачала));
			Запрос.УстановитьПараметр("ДатаОкончания", НачалоДня(ДатаНачалаИспользованияНовойФормыЖурнала));
			Запрос.УстановитьПараметр("ДатаНачала164", НачалоДня(ДатаНачалаИспользованияНовойФормыЖурнала));
			Запрос.УстановитьПараметр("ДатаОкончания164", КонецДня(Период.ДатаОкончания));
		Иначе 
			Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(Период.ДатаНачала));
			Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Период.ДатаОкончания));
			Запрос.УстановитьПараметр("ДатаНачала164", НачалоДня(Период.ДатаНачала));
			Запрос.УстановитьПараметр("ДатаОкончания164", КонецДня(Период.ДатаОкончания));
		КонецЕсли;
		
		Если ТекНастройка.НовыйФормат Тогда
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПродажиОбороты.Период КАК ДатаПродажи,
			|	ПродажиОбороты.Номенклатура.НаименованиеПолное КАК НаименованиеПродукции,
			|	ПродажиОбороты.Номенклатура.ВидАлкогольнойПродукции.Код КАК КодВидаПродукции,
			|	ПродажиОбороты.Номенклатура.ОбъемДАЛ * 10 КАК Емкость,
			|	ПродажиОбороты.КоличествоОборот КАК Количество
			|ИЗ
			|	РегистрНакопления.Продажи.Обороты(
			|			&ДатаНачала164,
			|			&ДатаОкончания164,
			|			День,
			|			Номенклатура.АлкогольнаяПродукция
			|				И Документ.Организация = &Организация
			|				И (Документ.СтруктурнаяЕдиница = &Склад
			|					ИЛИ Документ.СтруктурнаяЕдиницаРезерв = &Склад)
			|				И (ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ЧекККМ)
			|					ИЛИ ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ОтчетОРозничныхПродажах)
			|					ИЛИ ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.РасходнаяНакладная)
			|					ИЛИ ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ЗаказПокупателя)
			|						И Документ.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд)
			|					ИЛИ ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ПриходнаяНакладная)
			|						И Документ.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя))) КАК ПродажиОбороты
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаПродажи";
			
		Иначе
			
			Запрос.УстановитьПараметр("Приход", ВидДвиженияНакопления.Приход);
			Запрос.УстановитьПараметр("ПустаяСтрока", "");
			Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));
			
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ДвиженияТоваров.Регистратор КАК Регистратор,
			|	ДвиженияТоваров.Период КАК Период,
			|	ДвиженияТоваров.Регистратор.Номер КАК Номер,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ПриходнаяНакладная.ДатаВходящегоДокумента
			|		ИНАЧЕ &ПустаяДата
			|	КОНЕЦ КАК ДатаВходящегоДокумента,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ПриходнаяНакладная.НомерВходящегоДокумента
			|		ИНАЧЕ &ПустаяСтрока
			|	КОНЕЦ КАК НомерВходящегоДокумента,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(Контрагенты.НаименованиеПолное, &ПустаяСтрока) КАК СТРОКА(200))
			|		ИНАЧЕ &ПустаяСтрока
			|	КОНЕЦ КАК НаименованиеКонтрагента,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ЕСТЬNULL(Контрагенты.ИНН, &ПустаяСтрока)
			|		ИНАЧЕ &ПустаяСтрока
			|	КОНЕЦ КАК ИНН,
			|	ЕСТЬNULL(ДвиженияТоваров.Номенклатура.ВидАлкогольнойПродукции, &ПустаяСтрока) КАК ВидПродукции,
			|	ЕСТЬNULL(ДвиженияТоваров.Номенклатура.ВидАлкогольнойПродукции.Код, &ПустаяСтрока) КАК КодВида,
			|	ЕСТЬNULL(ДвиженияТоваров.Номенклатура.ОбъемДАЛ, 0) * 10 КАК Емкость,
			|	СУММА(ДвиженияТоваров.Количество) КАК Количество,
			|	СУММА(ЕСТЬNULL(ДвиженияТоваров.Номенклатура.ОбъемДАЛ, 0) * ДвиженияТоваров.Количество) КАК Объем,
			|	ДвиженияТоваров.ВидДвижения КАК ВидДвижения,
			|	ДвиженияТоваров.Регистратор.ВидОперации КАК ВидОперации,
			|	ДвиженияТоваров.КоррСтруктурнаяЕдиница КАК КоррСтруктурнаяЕдиница,
			|	ДвиженияТоваров.Номенклатура КАК Номенклатура
			|ИЗ
			|	РегистрНакопления.Запасы КАК ДвиженияТоваров
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная КАК ПриходнаяНакладная
			|		ПО (ПриходнаяНакладная.Ссылка = ДвиженияТоваров.Регистратор)
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
			|		ПО (Контрагенты.Ссылка = ПриходнаяНакладная.Контрагент)
			|ГДЕ
			|	ДвиженияТоваров.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
			|	И ДвиженияТоваров.СтруктурнаяЕдиница = &Склад
			|	И ДвиженияТоваров.Регистратор.Организация = &Организация
			|	И ДвиженияТоваров.Номенклатура.ВидАлкогольнойПродукции <> ЗНАЧЕНИЕ(Справочник.ВидыАлкогольнойПродукции.ПустаяСсылка)
			|	И НЕ(ТИПЗНАЧЕНИЯ(ДвиженияТоваров.Регистратор) = ТИП(Документ.ЗаказПокупателя)
			|					И ДвиженияТоваров.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу)
			|				ИЛИ ТИПЗНАЧЕНИЯ(ДвиженияТоваров.Регистратор) = ТИП(Документ.РезервированиеЗапасов)
			|				ИЛИ ТИПЗНАЧЕНИЯ(ДвиженияТоваров.Регистратор) = ТИП(Документ.ЗаказПокупателя)
			|					И ДвиженияТоваров.СодержаниеПроводки = ""Резервирование запасов"")
			|
			|СГРУППИРОВАТЬ ПО
			|	ДвиженияТоваров.Регистратор,
			|	ДвиженияТоваров.Период,
			|	ДвиженияТоваров.Регистратор.Номер,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ПриходнаяНакладная.ДатаВходящегоДокумента
			|		ИНАЧЕ &ПустаяДата
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ПриходнаяНакладная.НомерВходящегоДокумента
			|		ИНАЧЕ &ПустаяСтрока
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(Контрагенты.НаименованиеПолное, &ПустаяСтрока) КАК СТРОКА(200))
			|		ИНАЧЕ &ПустаяСтрока
			|	КОНЕЦ,
			|	ВЫБОР
			|		КОГДА ДвиженияТоваров.Регистратор ССЫЛКА Документ.ПриходнаяНакладная
			|			ТОГДА ЕСТЬNULL(Контрагенты.ИНН, &ПустаяСтрока)
			|		ИНАЧЕ &ПустаяСтрока
			|	КОНЕЦ,
			|	ДвиженияТоваров.Номенклатура.ВидАлкогольнойПродукции,
			|	ЕСТЬNULL(ДвиженияТоваров.Номенклатура.ОбъемДАЛ, 0) * 10,
			|	ДвиженияТоваров.ВидДвижения,
			|	ЕСТЬNULL(ДвиженияТоваров.Номенклатура.ВидАлкогольнойПродукции.Код, &ПустаяСтрока),
			|	ДвиженияТоваров.Регистратор.ВидОперации,
			|	ДвиженияТоваров.КоррСтруктурнаяЕдиница,
			|	ДвиженияТоваров.Номенклатура
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
			
			Если Не ЗначениеЗаполнено(Склад) Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ДвиженияТоваров.СтруктурнаяЕдиница = &Склад", "");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ДвиженияТоваров.Регистратор.Организация = &Организация", "");
			КонецЕсли;
			
		КонецЕсли;
		
		НомерСтроки = 0;
		
		Если ТекНастройка.НовыйФормат Тогда
			
			// Строки отчета +
			Выгрузка = Запрос.Выполнить().Выгрузить();
			
			Период = Выгрузка.Скопировать(,"ДатаПродажи");
			Период.Свернуть("ДатаПродажи");
			
			Для каждого День Из Период Цикл
				
				ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("Строка");
				
				СтрокиДня = Выгрузка.Скопировать(Новый Структура("ДатаПродажи", День.ДатаПродажи));
				
				Для Каждого ТекСтрока Из СтрокиДня Цикл
					
					НомерСтроки = НомерСтроки + 1;
					
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
					ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
					
					ДокументРезультат.Вывести(ОбластьМакета);
					
				КонецЦикла;
				
				// Итоги +
				ИтогиПоКоду = СтрокиДня.Скопировать();
				ИтогиПоКоду.Свернуть("КодВидаПродукции", "Количество");
				Для Каждого ТекСтрока Из ИтогиПоКоду Цикл
					ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("ИтогиПоКоду");
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
					ДокументРезультат.Вывести(ОбластьМакета);
				КонецЦикла;
				
				ИтогиПоНаименованию = СтрокиДня.Скопировать();
				ИтогиПоНаименованию.Свернуть("НаименованиеПродукции", "Количество");
				Для Каждого ТекСтрока Из ИтогиПоНаименованию Цикл
					ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("ИтогиПоНаименованию");
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ТекСтрока);
					ДокументРезультат.Вывести(ОбластьМакета);
				КонецЦикла;
				
				ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("ИтогиПоКоличеству");
				ОбластьМакета.Параметры.Количество = СтрокиДня.Итог("Количество");
				ДокументРезультат.Вывести(ОбластьМакета);
				// Итоги -
				
			КонецЦикла;
			// Строки отчета -
			
		Иначе
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			ИтогоОбъемПриход = 0;
			ИтогоОбъемРасход = 0;
			ИтогоКоличествоПриход = 0;
			ИтогоКоличествоРасход = 0;
			
			ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("Строка");
			
			Пока Выборка.Следующий() Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Выборка);
				ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
				ОбластьМакета.Параметры.Регистратор = Выборка.Регистратор;
				
				ПродукцияНаименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)",
				Выборка.ВидПродукции, СокрЛП(Выборка.Номенклатура));
				
				Если Выборка.ВидДвижения = ВидДвиженияНакопления.Приход
					И НЕ (ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ПриходнаяНакладная")
					И Выборка.ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя)
					И НЕ (ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.РасходнаяНакладная")
					И Выборка.ВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратПоставщику) Тогда
					
					ОбластьМакета.Параметры.РегистраторПриход = Выборка.Регистратор;
					
					Если ЗначениеЗаполнено(Выборка.ДатаВходящегоДокумента) Тогда
						ОбластьМакета.Параметры.ДатаТТН = Выборка.ДатаВходящегоДокумента;
					Иначе
						ОбластьМакета.Параметры.ДатаТТН = Выборка.Период;
					КонецЕсли;
					Если ЗначениеЗаполнено(Выборка.НомерВходящегоДокумента) Тогда
						ОбластьМакета.Параметры.НомерТТН = Выборка.НомерВходящегоДокумента;
					Иначе
						ОбластьМакета.Параметры.НомерТТН = Выборка.Номер;
					КонецЕсли;
					Если ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ПриходнаяНакладная")
						И Выборка.ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная.ПоступлениеОтПоставщика Тогда
						ОбластьМакета.Параметры.Поставщик = Выборка.НаименованиеКонтрагента;
						ОбластьМакета.Параметры.ИННПриход = Выборка.ИНН;
					Иначе
						ОбластьМакета.Параметры.Поставщик = ТекНастройка.СведенияОбОрганизации.ПолноеНаименование;
						ОбластьМакета.Параметры.ИННПриход = ТекНастройка.СведенияОбОрганизации.ИНН;
					КонецЕсли;
					
					ОбластьМакета.Параметры.ВидПродукцииПриход = ПродукцияНаименование;
					ОбластьМакета.Параметры.КодВидаПриход = Выборка.КодВида;
					
					ОбластьМакета.Параметры.ЕмкостьПриход = Выборка.Емкость;
					ОбластьМакета.Параметры.КоличествоПриход = Выборка.Количество;
					
					ОбластьМакета.Параметры.РегистраторРасход = Неопределено;
					ОбластьМакета.Параметры.СодержаниеРасход = "";
					ОбластьМакета.Параметры.ВидПродукцииРасход = "";
					ОбластьМакета.Параметры.ЕмкостьРасход = 0;
					ОбластьМакета.Параметры.КоличествоРасход = 0;
					
					ИтогоОбъемПриход = ИтогоОбъемПриход + Выборка.Объем;
					ИтогоКоличествоПриход = ИтогоКоличествоПриход + Выборка.Количество;
					
				Иначе
					
					ОбластьМакета.Параметры.РегистраторПриход = Неопределено;
					ОбластьМакета.Параметры.ДатаТТН = "";
					ОбластьМакета.Параметры.НомерТТН = "";
					ОбластьМакета.Параметры.Поставщик = "";
					ОбластьМакета.Параметры.ИННПриход = "";
					ОбластьМакета.Параметры.ВидПродукцииПриход = "";
					ОбластьМакета.Параметры.КодВидаПриход = "";
					ОбластьМакета.Параметры.ЕмкостьПриход = 0;
					ОбластьМакета.Параметры.КоличествоПриход = 0;
					
					ОбластьМакета.Параметры.РегистраторРасход = Выборка.Регистратор;
					
					ОбъемРасход = Выборка.Объем;
					КоличествоРасход = Выборка.Количество;
					
					Если ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах")
						ИЛИ (ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.РасходнаяНакладная")
						И Выборка.ВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю)
						ИЛИ (ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ПриходнаяНакладная")
						И Выборка.ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя) Тогда
						
						СодержаниеОперации = НСтр("ru = 'Проданная продукция'");
						
					ИначеЕсли ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.РасходнаяНакладная")
						И Выборка.ВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ВозвратПоставщику Тогда
						
						СодержаниеОперации = НСтр("ru = 'Продукция, возвращенная поставщику'");
						ОбъемРасход = - ОбъемРасход;
						КоличествоРасход = - КоличествоРасход;
						
					ИначеЕсли ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.СписаниеЗапасов") Тогда
						
						СодержаниеОперации = НСтр("ru = 'Недостачи продукции'");
						
					ИначеЕсли ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ПеремещениеЗапасов")
						И Выборка.ВидОперации = Перечисления.ВидыОперацийПеремещениеЗапасов.Перемещение
						И Выборка.КоррСтруктурнаяЕдиница.ТипСтруктурнойЕдиницы <> Перечисления.ТипыСтруктурныхЕдиниц.Подразделение Тогда
						
						СодержаниеОперации = НСтр("ru = 'Продукция, переданная в другое подразделение'");
						
					Иначе
						
						СодержаниеОперации = НСтр("ru = 'Списанная продукция'");
						
					КонецЕсли;
					
					ОбластьМакета.Параметры.СодержаниеРасход = СодержаниеОперации;
					ОбластьМакета.Параметры.ВидПродукцииРасход = ПродукцияНаименование;
					ОбластьМакета.Параметры.ЕмкостьРасход = Выборка.Емкость;
					ОбластьМакета.Параметры.КоличествоРасход = КоличествоРасход;
					
					ИтогоОбъемРасход = ИтогоОбъемРасход + ОбъемРасход;
					ИтогоКоличествоРасход = ИтогоКоличествоРасход + КоличествоРасход;
					
				КонецЕсли;
				
				ДокументРезультат.Вывести(ОбластьМакета);
				
				ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область("СтрокиДляПовтора");
				
			КонецЦикла;
			//СТРОКИ ОТЧЕТА -
			
			//ИТОГИ +
			ОбластьМакета = ТекНастройка.Макет.ПолучитьОбласть("Итоги");
			
			ОбластьМакета.Параметры.ОбъемПриход = ИтогоОбъемПриход;
			ОбластьМакета.Параметры.ОбъемРасход = ИтогоОбъемРасход;
			ОбластьМакета.Параметры.КоличествоПриход = ИтогоКоличествоПриход;
			ОбластьМакета.Параметры.КоличествоРасход = ИтогоКоличествоРасход;
			
			ДокументРезультат.Вывести(ОбластьМакета);
			//ИТОГИ -
			
		КонецЕсли;
		
		ДокументРезультат.АвтоМасштаб = Истина;
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ВыводитьГоризонтальныйРазделительСтраниц = Истина;
		
	КонецЦикла;
	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Продажи'");
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли