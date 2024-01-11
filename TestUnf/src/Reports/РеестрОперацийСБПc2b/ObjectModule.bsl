///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкаПодключения = ПолучитьПараметр(
		КомпоновщикНастроек.ПолучитьНастройки(),
		"НастройкаПодключения");
	
	Если Не ЗначениеЗаполнено(НастройкаПодключения.Значение) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Настройка подключения""'"),
			,
			,
			,
			Отказ);
	КонецЕсли;
	
	Период = ПолучитьПараметр(
		КомпоновщикНастроек.ПолучитьНастройки(),
		"Период");
	
	Если Не ЗначениеЗаполнено(Период.Значение.ДатаНачала)
		Или Не ЗначениеЗаполнено(Период.Значение.ДатаОкончания) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Период""'"),
			,
			,
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	
	Если Не ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		ЗаполнитьОписаниеОшибкиФормированияОтчета(
			ДокументРезультат,
			"ИППНеПодключена");
		Возврат;
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	Период = ПолучитьПараметр(НастройкиОтчета, "Период");
	НастройкаПодключения = ПолучитьПараметр(НастройкиОтчета, "НастройкаПодключения");
	
	РезультатОперации = СистемаБыстрыхПлатежейСлужебный.НовыйРезультатОперации();
	РезультатОперации.Вставить("ДанныеОпераций", Неопределено);
	
	ПараметрыНастройкиПодключения = СистемаБыстрыхПлатежейСлужебный.ПараметрыНастройкиПодключения(
		НастройкаПодключения.Значение);
	
	ДатаЗапросаСтатуса = ТекущаяДатаСеанса();
	РезультатЗапросаОтчета = СервисПереводыСБПc2b.ЗапросОтчетаПоСверкеОпераций(
		ПараметрыНастройкиПодключения,
		Период.Значение.ДатаНачала,
		Период.Значение.ДатаОкончания,
		ДатаЗапросаСтатуса);
	
	Если ЗначениеЗаполнено(РезультатЗапросаОтчета.КодОшибки) Тогда
		ЗаполнитьОписаниеОшибкиФормированияОтчета(
			ДокументРезультат,
			РезультатЗапросаОтчета.КодОшибки,
			РезультатЗапросаОтчета.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	Если РезультатЗапросаОтчета.СтатусОперации <> СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполнена() Тогда
		
		НастройкиВызова = СистемаБыстрыхПлатежейСлужебный.НовыйИтеративныйВызовОперации(180);
		
		Пока СистемаБыстрыхПлатежейСлужебный.ВозможенВызовОперации(НастройкиВызова) Цикл
			
			РезультатЗапросаСтатуса = СервисПереводыСБПc2b.СостояниеОтчетаПоСверкеОпераций(
				ПараметрыНастройкиПодключения,
				РезультатЗапросаОтчета.Идентификатор,
				ДатаЗапросаСтатуса);
			
			Если РезультатЗапросаСтатуса.СтатусОперации <> СистемаБыстрыхПлатежейКлиентСервер.СтатусОперацииВыполняется() Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗначениеЗаполнено(РезультатЗапросаСтатуса.КодОшибки) Тогда
			ЗаполнитьОписаниеОшибкиФормированияОтчета(
				ДокументРезультат,
				РезультатЗапросаСтатуса.КодОшибки,
				РезультатЗапросаСтатуса.СообщениеОбОшибке);
			Возврат;
		КонецЕсли;
	Иначе
		РезультатЗапросаСтатуса = РезультатЗапросаОтчета;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РезультатЗапросаСтатуса.КодОшибки) Тогда
		ЗаполнитьОписаниеОшибкиФормированияОтчета(
			ДокументРезультат,
			РезультатЗапросаСтатуса.КодОшибки,
			РезультатЗапросаСтатуса.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеОпераций.Идентификатор КАК ИдентификаторОплаты,
		|	ДанныеОпераций.ТипОперации КАК ТипОперации,
		|	ДанныеОпераций.ДатаОперации КАК ДатаОперации,
		|	ДанныеОпераций.Сумма КАК Сумма,
		|	ДанныеОпераций.СуммаКомиссии КАК СуммаКомиссии,
		|	ДанныеОпераций.ИдентификаторОплаты КАК ИдентификаторОперации
		|ПОМЕСТИТЬ ВТ_ОперацииВСервисе
		|ИЗ
		|	&ДанныеОпераций КАК ДанныеОпераций
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОперацииВСервисе.ИдентификаторОплаты КАК ИдентификаторОплаты,
		|	ВТ_ОперацииВСервисе.ТипОперации КАК ТипОперации,
		|	ВТ_ОперацииВСервисе.ДатаОперации КАК ДатаОперации,
		|	ВТ_ОперацииВСервисе.Сумма КАК Сумма,
		|	ВТ_ОперацииВСервисе.СуммаКомиссии КАК СуммаКомиссии,
		|	ВТ_ОперацииВСервисе.ИдентификаторОперации КАК ИдентификаторОперации,
		|	ВЫБОР
		|		КОГДА ИдентификаторыОперацийСБПc2b.ДокументОперации ССЫЛКА Документ.ПлатежнаяСсылкаСБПc2b
		|			ТОГДА ВЫРАЗИТЬ(ИдентификаторыОперацийСБПc2b.ДокументОперации КАК Документ.ПлатежнаяСсылкаСБПc2b).ОснованиеПлатежа
		|		ИНАЧЕ ИдентификаторыОперацийСБПc2b.ДокументОперации
		|	КОНЕЦ КАК ДокументОперации
		|ИЗ
		|	ВТ_ОперацииВСервисе КАК ВТ_ОперацииВСервисе
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыОперацийСБПc2b КАК ИдентификаторыОперацийСБПc2b
		|		ПО ВТ_ОперацииВСервисе.ИдентификаторОперации = ИдентификаторыОперацийСБПc2b.ИдентификаторОперации
		|			И (ИдентификаторыОперацийСБПc2b.НастройкаПодключения = &НастройкаПодключения)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОперации";
	
	Запрос.УстановитьПараметр("ДанныеОпераций", РезультатЗапросаСтатуса.ДанныеОпераций);
	Запрос.УстановитьПараметр("НастройкаПодключения", НастройкаПодключения.Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВнешниеНаборыДанных = Новый Структура("ДанныеРеестра", РезультатЗапроса.Выгрузить());
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(
		СхемаКомпоновкиДанных,
		НастройкиОтчета,
		ДанныеРасшифровки);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(
		МакетКД,
		ВнешниеНаборыДанных,
		ДанныеРасшифровки);
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
	
	УстановитьПримечания(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует описание ошибки формирования отчета.
//
// Параметры:
//  ДокументРезультат - ТабличныйДокумент - документ для заполнения;
//  КодОшибки - Строка - код ошибки сервиса;
//  СообщениеОбОшибке - Строка - информация об ошибке для пользователя.
//
Процедура ЗаполнитьОписаниеОшибкиФормированияОтчета(
		ДокументРезультат,
		КодОшибки,
		СообщениеОбОшибке = "")
	
	Макет = ПолучитьМакет("ОшибкиОтчета");
	Если КодОшибки = "ИППНеПодключена" Тогда
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			ИмяОбласти = "ИППНеПодключена";
		Иначе
			ИмяОбласти = "ИППНеПодключенаОбычныйПользователь";
		КонецЕсли;
	ИначеЕсли КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиОшибкаПодключения() Тогда
		ИмяОбласти = "ОшибкаПодключения";
	ИначеЕсли КодОшибки = "ОшибкаИспользованиеОтчетаЗапрещено" Тогда
		ИмяОбласти = "ОшибкаИспользованиеОтчетаЗапрещено";
	Иначе
		ИмяОбласти = "ОшибкаНеУдалосьСформироватьОтчет";
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Если ИмяОбласти = "ОшибкаНеУдалосьСформироватьОтчет" Тогда
		Область.Параметры.СообщениеОбОшибке = СообщениеОбОшибке;
	ИначеЕсли ИмяОбласти = "ИППНеПодключена" Тогда
		Область.Параметры.ПодключитьИнтернетПоддержкуПользователей
			= "ПодключитьИнтернетПоддержкуПользователейРеестрСБП";
	КонецЕсли;
	
	ДокументРезультат.Вывести(Область);
	
КонецПроцедуры

// Возвращает значение параметра компоновки данных.
//
// Параметры:
//  Настройки - НастройкиКомпоновкиДанных, ПользовательскиеНастройкиКомпоновкиДанных, КомпоновщикНастроекКомпоновкиДанных, 
//              КоллекцияЗначенийПараметровКомпоновкиДанных, ОформлениеКомпоновкиДанных - 
//              Настройки, в которых происходит поиск параметра. Не поддерживает тип ДанныеРасшифровкиКомпоновкиДанных.
//  Параметр - Строка, ПараметрКомпоновкиДанных - Имя параметра СКД, для которого нужно вернуть значение параметра.
//
// Возвращаемое значение:
//  ПараметрКомпоновкиДанных, ЗначениеПараметраНастроекКомпоновкиДанных - Искомый параметр.
//
Функция ПолучитьПараметр(Настройки, Параметр)
	
	ЗначениеПараметра = Неопределено;
	ПолеПараметр = ?(ТипЗнч(Параметр) = Тип("Строка"), Новый ПараметрКомпоновкиДанных(Параметр), Параметр);
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.Найти(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ОформлениеКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.НайтиЗначениеПараметра(ПолеПараметр);
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Добавляет примечания в результат отчета.
//
// Параметры:
//  ДокументРезультат - ТабличныйДокумент - результат отчета.
//
Процедура УстановитьПримечания(ДокументРезультат)
	
	Область = ДокументРезультат.НайтиТекст(НСтр("ru = 'Дата операции'"),,,, Истина);
	Если Область <> Неопределено Тогда
		Область.Примечание.Текст = НСтр("ru = 'Дата формирования операции
			|в банке без учета часового пояса (UTC).'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
