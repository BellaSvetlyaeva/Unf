///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запуск фонового задания по проверке контрагента в карточке контрагента.
//	Запускается при редактировании реквизитов внутри карточки контрагента.
//
// Параметры:
//  ПараметрыЗапуска - Структура - Параметры запуска фонового задания. Ключи:
//		"Контрагент"
//		"ИНН"
//		"КПП"
//		"СохранятьРезультатСразуПослеПроверки"
//		"АдресХранилища"
Процедура ПроверитьКонтрагентаПриИзменении(Знач ПараметрыЗапуска) Экспорт  
	
	Попытка
		
		Параметры = Новый Массив;
		Параметры.Добавить(ПараметрыЗапуска);
		
		ФоновыеЗадания.Выполнить("ПроверкаКонтрагентов.ПроверитьКонтрагентаФоновоеЗадание", 
			Параметры,, НСтр("ru = 'Проверка контрагента'"));
		
	Исключение
		
		// Исключение возникнет в случае запуска фонового задания с таким же ключем.
		// Специальной обработки не требуется.
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		РаботаСКонтрагентами.ЗаписатьОшибкуВЖурналРегистрации(
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			"ПроверкаКонтрагентов",
			НСтр("ru = 'Запуск проверки при изменении реквизитов контрагентов'",
					ОбщегоНазначения.КодОсновногоЯзыка()));
		
	КонецПопытки;
	
КонецПроцедуры

// Определяет, завершилось ли фоновое задание.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - Идентификатор фонового задания по проверке контрагента.
// Возвращаемое значение:
//  Булево - Истина, если фоновое задание завершилось.
//
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) Экспорт
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

// Определение цветов выделения результатов проверки контрагентов.
//
// Возвращаемое значение:
//  Структура - Имена ключей - это названия цветов, которые необходимо определить.
// 		Список ключей см ПроверкаКонтрагентов.ЦветаРезультатовПроверки().
Функция ЦветаРезультатовПроверки() Экспорт
	
	Возврат ПроверкаКонтрагентов.ЦветаРезультатовПроверки();
	
КонецФункции

// Проверяет, что проверка включена и есть необходимые права.
// Возвращаемое значение:
//  Булево - Истина, если есть нужные права на проверку и проверка включена.
//
Функция ИспользованиеПроверкиВозможно() Экспорт
	
	Возврат ПроверкаКонтрагентов.ИспользованиеПроверкиВозможно();
	
КонецФункции

#Область ОпределениеСостоянияКонтрагента

// На основе результата предыдущей проверки (записи в регистр) определяет,
// существует ли контрагент.
//
// Параметры:
//  КонтрагентСсылка - ОпределяемыйТип.КонтрагентБИП - Проверяемый контрагент.
//  ИНН - Строка - ИНН контрагента.
//  КПП - Строка - КПП контрагента.
// Возвращаемое значение:
//  Булево  - Истина, если контрагент существует.
//
Функция КонтрагентСуществует(
	Знач КонтрагентСсылка,
	Знач ИНН,
	Знач КПП) Экспорт
	
	КонтрагентСуществует = Истина;
	
	// Получаем состояние контрагента из регистра сведений.
	Состояние = ТекущееСохраненноеСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП);
	
	// По состоянию определяем, существует ли контрагент или нет.
	КонтрагентСуществует = ПроверкаКонтрагентовКлиентСервер.ЭтоСостояниеДействующегоКонтрагента(Состояние);
	
	Возврат КонтрагентСуществует;
	
КонецФункции

// Получает состояние контрагента из регистра сведений.
//
// Параметры:
//  КонтрагентСсылка - ОпределяемыйТип.КонтрагентБИП - Проверяемый контрагент.
//  ИНН - Строка - ИНН контрагента.
//  КПП - Строка - КПП контрагента.
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияСуществованияКонтрагента - Состояние контрагента.
//
Функция ТекущееСохраненноеСостояниеКонтрагента(
	Знач КонтрагентСсылка,
	Знач ИНН,
	Знач КПП) Экспорт
	
	Если ЗначениеЗаполнено(КонтрагентСсылка) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СостоянияКонтрагентов.Состояние КАК Состояние
			|ИЗ
			|	РегистрСведений.СостоянияКонтрагентов КАК СостоянияКонтрагентов
			|ГДЕ
			|	СостоянияКонтрагентов.Контрагент = &Контрагент
			|	И СостоянияКонтрагентов.ИНН = &ИНН
			|	И СостоянияКонтрагентов.КПП = &КПП";
		
		Запрос.УстановитьПараметр("ИНН",        ИНН);
		Запрос.УстановитьПараметр("КПП",        КПП);
		Запрос.УстановитьПараметр("Контрагент", КонтрагентСсылка);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		// Определяем состояние из регистра.
		Пока РезультатЗапроса.Следующий() Цикл
			Состояние = РезультатЗапроса.Состояние;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Определяет, завершилось ли фоновое задание по проверке контрагента в карточке контрагента.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - Идентификатор фонового задания по проверке контрагента.
// Возвращаемое значение:
//  Булево - Истина, если фоновое задание завершилось.
//
Функция ПроверкаКонтрагентовЗавершилась(Знач ИдентификаторЗадания) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		Возврат Истина;
	Иначе
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			Возврат Истина;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			Возврат Истина;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область НастройкиПроверки

// Запоминает, что больше не нужно показывать предложение использовать сервис.
//
Процедура ЗапомнитьЧтоБольшеНеНужноПоказыватьПредложениеИспользоватьСервис() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПроверкаКонтрагентов.ВключитьВыключитьПроверкуКонтрагентов(Ложь);
	
КонецПроцедуры

// Выполняет действия при включении и отключении проверки.
//
// Параметры:
//  ВключитьПроверку - Булево - Истина, если проверку необходимо включить.
//
Процедура ПриВключенииВыключенииПроверки(Знач ВключитьПроверку) Экспорт
	
	ПроверкаКонтрагентов.ВключитьВыключитьПроверкуКонтрагентов(ВключитьПроверку);
	ПроверкаКонтрагентов.ЗапуститьФоновуюПроверкуКонтрагентовПослеИзмененияНастройкиПриНеобходимости();
	
КонецПроцедуры

// Результат проверки параметров доступа к веб-сервису ФНС.
//
// Возвращаемое значение:
//  Булево - Доступ к веб-сервису ФНС по проверке контрагентов есть.
//
Функция РезультатПроверкиПараметровДоступа() Экспорт
	
	Если ПроверкаКонтрагентов.ЕстьДоступКВебСервисуФНС() Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Проверка доступа к веб-сервису успешно пройдена'");
		
	Иначе
		
		ПредупреждениеПроОтсутствиеДоступа = Новый ФорматированнаяСтрока(НСтр("ru = 'Доступ к веб-сервису отсутствует'"));
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
			ПереходКНастройкамПроксиСервера = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Настроить параметры прокси-сервера'"),,,, "e1cib/command/ОбщаяКоманда.ПереходКНастройкамДоступаКВебСервису");
		Иначе
			ПереходКНастройкамПроксиСервера = "";
		КонецЕсли;
			
		Возврат Новый ФорматированнаяСтрока(
			ПредупреждениеПроОтсутствиеДоступа,
			Символы.ПС, 
			ПереходКНастройкамПроксиСервера);
			
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РезультатРаботыФоновогоЗаданияПроверкиКонтрагентовВДокументе(Знач РеквизитыПроверкиКонтрагентов) Экспорт
	
	ЗаданиеВыполнено = ПроверкаКонтрагентовЗавершилась(РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания);
	
	ЕстьДоступКВебСервисуФНС = Ложь;
	ДанныеВКэшСовпадаютСФНС = 
		ЗаданиеВыполнено
		И ПроверкаКонтрагентов.РезультатПроверкиКонтрагентовВДокументеСовпадаетСДаннымиФНС(
			РеквизитыПроверкиКонтрагентов, 
			ЕстьДоступКВебСервисуФНС);
		
	Результат = Новый Структура();
	Результат.Вставить("ЗаданиеВыполнено", 			ЗаданиеВыполнено);
	Результат.Вставить("ЕстьДоступКВебСервисуФНС", 	ЕстьДоступКВебСервисуФНС);
	Результат.Вставить("ДанныеВКэшСовпадаютСФНС", 	ДанныеВКэшСовпадаютСФНС);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗапомнитьРезультатПроверкиСправочникаПослеПредварительнойПроверки(
	Знач ДанныеКонтрагента,
	Знач ДополнительныеПараметры) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		ДанныеКонтрагента.Вставить(
			"ОбластьДанныхВспомогательныеДанные",
			ИнтернетПоддержкаПользователей.ЗначениеРазделителяСеанса());
	КонецЕсли;
	
	ДанныеКонтрагентов = Новый Массив;
	ДанныеКонтрагентов.Добавить(ДанныеКонтрагента);
	
	ПроверкаКонтрагентов.ЗапомнитьРезультатыПроверкиСправочника(ДанныеКонтрагентов, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти