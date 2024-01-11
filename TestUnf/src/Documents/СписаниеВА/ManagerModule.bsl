#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеВА);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат КАК СчетУчетаАмортизации,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.СчетЗатрат.ТипСчета КАК ТипСчетаАмортизации,
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаДокумента.ВнеоборотныйАктив.СчетУчета КАК СчетУчета,
	|	ТаблицаДокумента.ВнеоборотныйАктив.СчетАмортизации КАК СчетАмортизации,
	|	ТаблицаДокумента.Ссылка.Корреспонденция КАК СчетУчетаСписания,
	|	ТаблицаДокумента.Ссылка.Корреспонденция.ТипСчета КАК ТипСчетаСписания,
	|	ТаблицаДокумента.Стоимость КАК Стоимость,
	|	ТаблицаДокумента.Амортизация КАК Амортизация,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК АмортизацияЗаМесяц,
	|	ТаблицаДокумента.ОстаточнаяСтоимость КАК ОстаточнаяСтоимость,
	|	ИСТИНА КАК ФиксированнаяСтоимость,
	|	ТаблицаДокумента.Проект КАК Проект
	|ПОМЕСТИТЬ ВременнаяТаблицаВнеоборотныеАктивы
	|ИЗ
	|	Документ.СписаниеВА.ВнеоборотныеАктивы КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(&МоментВремени, ) КАК ПараметрыВнеоборотныхАктивовСрезПоследних
	|		ПО (&Организация = ПараметрыВнеоборотныхАктивовСрезПоследних.Организация)
	|			И ТаблицаДокумента.ВнеоборотныйАктив = ПараметрыВнеоборотныхАктивовСрезПоследних.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеВА КАК СписаниеВА
	|		ПО ТаблицаДокумента.Ссылка = СписаниеВА.Ссылка
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	Запрос.Выполнить();
	
	СформироватьТаблицаЗапасы(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДоходыИРасходы(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаВнеоборотныеАктивы(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаСостоянияВнеоборотныхАктивов(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства);
	СформироватьТаблицаУправленческий(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаСписаниеВА, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если ПроведениеДокументовУНФ.КонтрольОстатковВыключен() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы содержат записи, необходимо выполнить контроль
	// возникновения отрицательных остатков.	
	Если СтруктураВременныеТаблицы.ДвиженияВнеоборотныеАктивыИзменение  Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияВнеоборотныеАктивыИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияВнеоборотныеАктивыИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияВнеоборотныеАктивыИзменение.ВнеоборотныйАктив) КАК ВнеоборотныйАктивПредставление,
		|	ЕСТЬNULL(ВнеоборотныеАктивыОстатки.СтоимостьОстаток, 0) КАК СтоимостьОстаток,
		|	ЕСТЬNULL(ВнеоборотныеАктивыОстатки.АмортизацияОстаток, 0) КАК АмортизацияОстаток,
		|	ДвиженияВнеоборотныеАктивыИзменение.СтоимостьПередЗаписью КАК СтоимостьПередЗаписью,
		|	ДвиженияВнеоборотныеАктивыИзменение.СтоимостьПриЗаписи КАК СтоимостьПриЗаписи,
		|	ДвиженияВнеоборотныеАктивыИзменение.СтоимостьИзменение КАК СтоимостьИзменение,
		|	ДвиженияВнеоборотныеАктивыИзменение.СтоимостьИзменение + ЕСТЬNULL(ВнеоборотныеАктивыОстатки.СтоимостьОстаток, 0) КАК ОстаточнаяСтоимость,
		|	ДвиженияВнеоборотныеАктивыИзменение.АмортизацияПередЗаписью КАК АмортизацияПередЗаписью,
		|	ДвиженияВнеоборотныеАктивыИзменение.АмортизацияПриЗаписи КАК АмортизацияПриЗаписи,
		|	ДвиженияВнеоборотныеАктивыИзменение.АмортизацияИзменение КАК АмортизацияИзменение,
		|	ДвиженияВнеоборотныеАктивыИзменение.АмортизацияИзменение + ЕСТЬNULL(ВнеоборотныеАктивыОстатки.АмортизацияОстаток, 0) КАК НачисленнаяАмортизация
		|ИЗ
		|	ДвиженияВнеоборотныеАктивыИзменение КАК ДвиженияВнеоборотныеАктивыИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.Остатки(
		|				&МоментКонтроля,
		|				(Организация, ВнеоборотныйАктив) В
		|					(ВЫБРАТЬ
		|						ДвиженияВнеоборотныеАктивыИзменение.Организация КАК Организация,
		|						ДвиженияВнеоборотныеАктивыИзменение.ВнеоборотныйАктив КАК ВнеоборотныйАктив
		|					ИЗ
		|						ДвиженияВнеоборотныеАктивыИзменение КАК ДвиженияВнеоборотныеАктивыИзменение)) КАК ВнеоборотныеАктивыОстатки
		|		ПО (ДвиженияВнеоборотныеАктивыИзменение.Организация = ДвиженияВнеоборотныеАктивыИзменение.Организация)
		|			И (ДвиженияВнеоборотныеАктивыИзменение.ВнеоборотныйАктив = ДвиженияВнеоборотныеАктивыИзменение.ВнеоборотныйАктив)
		|ГДЕ
		|	(ЕСТЬNULL(ВнеоборотныеАктивыОстатки.СтоимостьОстаток, 0) < 0
		|			ИЛИ ЕСТЬNULL(ВнеоборотныеАктивыОстатки.АмортизацияОстаток, 0) < 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ДокументОбъектСписаниеВА = ДокументСсылкаСписаниеВА.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по амортизации имущества.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ВнеоборотныеАктивы(ДокументОбъектСписаниеВА, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаЗапасы(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("ПрочиеРасходы", НСтр("ru = 'Прочие расходы'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.СчетУчетаАмортизации КАК СчетУчета,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК Сумма,
	|	ИСТИНА КАК ФиксированнаяСтоимость,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет) КАК ВидДвиженияУправленческий,
	|	&НачислениеАмортизации КАК СодержаниеПроводки
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.АмортизацияЗаМесяц > 0
	|	И (ТаблицаДокумента.ТипСчетаАмортизации = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.НезавершенноеПроизводство)
	|			ИЛИ ТаблицаДокумента.ТипСчетаАмортизации = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.КосвенныеЗатраты))
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаЗапасы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДоходыИРасходы(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("ПрочиеРасходы", НСтр("ru = 'Прочие расходы'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаДокумента.СчетУчетаАмортизации КАК СчетУчета,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК Аналитика,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК СуммаРасходов,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК Сумма,
	|	ТаблицаДокумента.Проект КАК Проект,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет) КАК ВидДвиженияУправленческий,
	|	&НачислениеАмортизации КАК СодержаниеПроводки
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.АмортизацияЗаМесяц > 0
	|	И (ТаблицаДокумента.ТипСчетаАмортизации = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Расходы)
	|			ИЛИ ТаблицаДокумента.ТипСчетаАмортизации = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее),
	|	НЕОПРЕДЕЛЕНО,
	|	ТаблицаДокумента.СчетУчетаСписания,
	|	ТаблицаДокумента.ВнеоборотныйАктив,
	|	ТаблицаДокумента.Стоимость - ТаблицаДокумента.Амортизация - ТаблицаДокумента.АмортизацияЗаМесяц,
	|	ТаблицаДокумента.Стоимость - ТаблицаДокумента.Амортизация - ТаблицаДокумента.АмортизацияЗаМесяц,
	|	ТаблицаДокумента.Проект КАК Проект,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет),
	|	&ПрочиеРасходы
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Стоимость - ТаблицаДокумента.Амортизация - ТаблицаДокумента.АмортизацияЗаМесяц > 0
	|	И (ТаблицаДокумента.ТипСчетаСписания = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Расходы)
	|			ИЛИ ТаблицаДокумента.ТипСчетаСписания = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаУправленческий(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("СписаниеАмортизации", НСтр("ru = 'Списание амортизации'"));
	Запрос.УстановитьПараметр("ПрочиеРасходы", НСтр("ru = 'Прочие расходы'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ТаблицаДокумента.СчетУчетаАмортизации КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	0 КАК СуммаВалДт,
	|	ТаблицаДокумента.СчетАмортизации КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	0 КАК СуммаВалКт,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК Сумма,
	|	ВЫРАЗИТЬ(&НачислениеАмортизации КАК СТРОКА(100)) КАК Содержание
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.АмортизацияЗаМесяц > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический),
	|	ТаблицаДокумента.СчетАмортизации,
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	ТаблицаДокумента.СчетУчета,
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	ТаблицаДокумента.АмортизацияЗаМесяц + ТаблицаДокумента.Амортизация,
	|	&СписаниеАмортизации
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.АмортизацияЗаМесяц + ТаблицаДокумента.Амортизация > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический),
	|	ТаблицаДокумента.СчетУчетаСписания,
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	ТаблицаДокумента.СчетУчета,
	|	НЕОПРЕДЕЛЕНО,
	|	0,
	|	ТаблицаДокумента.Стоимость - ТаблицаДокумента.Амортизация - ТаблицаДокумента.АмортизацияЗаМесяц,
	|	&ПрочиеРасходы
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Стоимость - ТаблицаДокумента.Амортизация - ТаблицаДокумента.АмортизацияЗаМесяц > 0";

	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаУправленческий()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВнеоборотныеАктивы(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НачислениеАмортизации", НСтр("ru = 'Начисление амортизации'"));
	Запрос.УстановитьПараметр("СписаниеАмортизации", НСтр("ru = 'Списание амортизации'"));
	Запрос.УстановитьПараметр("СписаниеВнеоборотногоАктиваСУчета", НСтр("ru = 'Списание имущества с учета'"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК Амортизация,
	|	0 КАК Стоимость,
	|	ТаблицаДокумента.АмортизацияЗаМесяц КАК Сумма,
	|	ТаблицаДокумента.СчетАмортизации КАК СчетУчета,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Кредит) КАК ВидДвиженияУправленческий,
	|	&НачислениеАмортизации КАК СодержаниеПроводки
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.АмортизацияЗаМесяц > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	ТаблицаДокумента.НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.ВнеоборотныйАктив,
	|	ТаблицаДокумента.АмортизацияЗаМесяц + ТаблицаДокумента.Амортизация,
	|	0,
	|	ТаблицаДокумента.АмортизацияЗаМесяц + ТаблицаДокумента.Амортизация,
	|	ТаблицаДокумента.СчетАмортизации,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет),
	|	&СписаниеАмортизации
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.АмортизацияЗаМесяц + ТаблицаДокумента.Амортизация > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3,
	|	ТаблицаДокумента.НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.ВнеоборотныйАктив,
	|	0,
	|	ТаблицаДокумента.Стоимость,
	|	ТаблицаДокумента.Стоимость,
	|	ТаблицаДокумента.СчетУчета,
	|	ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Кредит),
	|	&СписаниеВнеоборотногоАктиваСУчета
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Стоимость > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВнеоборотныеАктивы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаВнеоборотныеАктивы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСостоянияВнеоборотныхАктивов(ДокументСсылкаСписаниеВА, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияВнеоборотныхАктивов.СнятСУчета) КАК Состояние,
	|	ЛОЖЬ КАК НачислятьАмортизацию,
	|	ЛОЖЬ КАК НачислятьАмортизациюВТекущемМесяце
	|ИЗ
	|	ВременнаяТаблицаВнеоборотныеАктивы КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСостоянияВнеоборотныхАктивов", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаСостоянияВнеоборотныхАктивов()

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли