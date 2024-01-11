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
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)";

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура формирования таблицы платежного календаря.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.ДатаОплаты КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Ссылка.ТипДенежныхСредств,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыУтвержденияПлатежей.Утвержден) КАК СтатусУтвержденияПлатежа,
	|	ТаблицаДокумента.Ссылка КАК СчетНаОплату,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщикам) КАК Статья,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Ссылка.Касса
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.Ссылка.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов
	|		ИНАЧЕ ТаблицаДокумента.Ссылка.ВалютаДокумента
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ВЫРАЗИТЬ(-ТаблицаДокумента.СуммаОплаты * ВЫБОР
	|						КОГДА КурсыВалютРасчетов.Курс <> 0
	|								И КурсыВалютДокумента.Кратность <> 0
	|							ТОГДА КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность / (ЕСТЬNULL(КурсыВалютРасчетов.Курс, 1) * ЕСТЬNULL(КурсыВалютДокумента.Кратность, 1))
	|						ИНАЧЕ 1
	|					КОНЕЦ КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ -ТаблицаДокумента.СуммаОплаты
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.ПлатежныйКалендарь КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютРасчетов
	|		ПО ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютДокумента
	|		ПО ТаблицаДокумента.Ссылка.ВалютаДокумента = КурсыВалютДокумента.Валюта
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Процедура формирования таблицы денежных средств в резерве.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ЗаказПоставщику - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.ДатаОплаты КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.Ссылка.ТипДенежныхСредств,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Ссылка.Касса
	|		КОГДА ТаблицаДокумента.Ссылка.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.Ссылка.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	ТаблицаДокумента.Ссылка КАК Документ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов
	|		ИНАЧЕ ТаблицаДокумента.Ссылка.ВалютаДокумента
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.Договор.РасчетыВУсловныхЕдиницах
	|			ТОГДА ВЫРАЗИТЬ(ТаблицаДокумента.СуммаОплаты * ВЫБОР
	|						КОГДА КурсыВалютРасчетов.Курс <> 0
	|								И КурсыВалютДокумента.Кратность <> 0
	|							ТОГДА КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность / (ЕСТЬNULL(КурсыВалютРасчетов.Курс, 1) * ЕСТЬNULL(КурсыВалютДокумента.Кратность, 1))
	|						ИНАЧЕ 1
	|					КОНЕЦ КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ ТаблицаДокумента.СуммаОплаты
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.ПлатежныйКалендарь КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютРасчетов
	|		ПО ТаблицаДокумента.Ссылка.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютДокумента
	|		ПО ТаблицаДокумента.Ссылка.ВалютаДокумента = КурсыВалютДокумента.Валюта
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И ТаблицаДокумента.Ссылка.ЗапланироватьОплату
	|	И ТаблицаДокумента.Ссылка.РезервироватьДенежныеСредства";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваВРезерве", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Процедура формирования таблицы счетов на оплату.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаОплатаСчетовИЗаказов(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.Ссылка КАК СчетНаОплату,
	|	ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Контрагент.ВестиУчетОплатыПоСчетам
	|	И ТаблицаДокумента.Ссылка = &Ссылка
	|	И ТаблицаДокумента.СуммаДокумента <> 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОплатаСчетовИЗаказов", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаОплатаСчетовИЗаказов()

// Формирует таблицу данных документа.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	СтруктураДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаОплатаСчетовИЗаказов(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаСчетНаОплатуПоставщика, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если НЕ Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРезервированиеДенежныхСредств") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|	ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|	ДенежныеСредстваВРезервеОстатки.Документ КАК Документ,
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток КАК ВРезерве
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, Документ = &СсылкаНаДокумент) КАК ДенежныеСредстваВРезервеОстатки
		|ГДЕ
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваВРезервеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Организация КАК ОрганизацияПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Валюта КАК ВалютаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредствПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК ОстатокДенежныхСредств,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0) + ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) - ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК ВРезерве,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК СвободныйОстаток
		|ИЗ
		|	ДвиженияДенежныеСредстваВРезервеИзменение КАК ДвиженияДенежныеСредстваВРезервеИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредства.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваОстатки
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = ДенежныеСредстваОстатки.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = ДенежныеСредстваОстатки.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = ДенежныеСредстваОстатки.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = ДенежныеСредстваОстатки.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НеснижаемыеОстаткиДенежныхСредств.СрезПоследних(&МоментКонтроля, ) КАК НеснижаемыеОстаткиДенежныхСредствСрезПоследних
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|			СУММА(ДенежныеСредстваВРезервеОстатки.СуммаОстаток) КАК СуммаОстаток
		|		ИЗ
		|			РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваВРезервеОстатки
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ДенежныеСредстваВРезервеОстатки.Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта) КАК РезервыПоДокументам
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = РезервыПоДокументам.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = РезервыПоДокументам.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = РезервыПоДокументам.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = РезервыПоДокументам.Валюта
		|ГДЕ
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) - (ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) + ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0)) < 0");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		Запрос.УстановитьПараметр("СсылкаНаДокумент", ДокументСсылкаСчетНаОплатуПоставщика);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если 	 НЕ МассивРезультатов[0].Пустой() 
			 ИЛИ НЕ МассивРезультатов[1].Пустой() Тогда
			ДокументОбъектСчетНаОплатуПоставщика = ДокументСсылкаСчетНаОплатуПоставщика.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам в резерве.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ДенежныеСредстваВРезерве(ДокументОбъектСчетНаОплатуПоставщика, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам с учетом резервов.
		Если НЕ МассивРезультатов[1].Пустой() Тогда //Если остатка денежных средств не хватает, то выводить ошибку по резервам нет смысла
			Если ДокументСсылкаСчетНаОплатуПоставщика.РезервироватьДенежныеСредства Тогда
				ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
				КонтрольОстатковУНФ.ДенежныеСредстваСУчетомРезервов(ДокументСсылкаСчетНаОплатуПоставщика, ВыборкаИзРезультатаЗапроса, Отказ);
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

// Поля загрузки данных из внешнего источника.
// 
// Параметры:
//  ТаблицаПолейЗагрузки - см. ЗагрузкаДанныхИзВнешнегоИсточника.СоздатьТаблицуПолейОписанияЗагрузки
//  НастройкиЗагрузкиДанных - см. ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере
//
Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	ОписанияТиповПолей = ЗагрузкаДанныхИзВнешнегоИсточника.НовыйОписанияТиповПолейЗагрузки();

	ПоказыватьНоменклатуруПоставщиков = ПолучитьФункциональнуюОпцию("УчетНоменклатурыПоставщиков");
	Если ПоказыватьНоменклатуруПоставщиков Тогда

		ИмяГруппыПолей = "НоменклатураПоставщиков";
		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.НоменклатураПоставщиков");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Идентификатор", НСтр(
			"ru = 'Идентификатор'"), ОписанияТиповПолей.ОписаниеТиповСтрока110, ОписаниеТиповКолонка, ИмяГруппыПолей,
			1, , Ложь, ПоказыватьНоменклатуруПоставщиков);
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "АртикулПоставщика", НСтр(
			"ru = 'Артикул поставщика'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка,
			ИмяГруппыПолей, 2, , Ложь, ПоказыватьНоменклатуруПоставщиков);
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки,
			"НоменклатураПоставщиковНаименование", НСтр("ru = 'Номенклатура поставщиков (наименование)'"),
			ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка, ИмяГруппыПолей, 3, , Ложь,
			ПоказыватьНоменклатуруПоставщиков);

	КонецЕсли;

	ИмяГруппыПолей = "Номенклатура";
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПоляНоменклатуры(ТаблицаПолейЗагрузки, ОписаниеТиповКолонка,
		ОписанияТиповПолей, НастройкиЗагрузкиДанных);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Содержание", НСтр(
		"ru = 'Содержание'"), ОписанияТиповПолей.ОписаниеТиповСтрока1000, ОписанияТиповПолей.ОписаниеТиповСтрока1000, ,
		, , , НастройкиЗагрузкиДанных.СодержаниеВидимо);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПоляГруппыНоменклатуры(ТаблицаПолейЗагрузки, ОписанияТиповПолей,
		ОписаниеТиповКолонка);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПоляХарактеристики(ТаблицаПолейЗагрузки, ОписанияТиповПолей);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЭтоУслуга", НСтр(
		"ru = 'Это услуга'", ОбщегоНазначения.КодОсновногоЯзыка()), ОписанияТиповПолей.ОписаниеТиповБулево,
		ОписанияТиповПолей.ОписаниеТиповБулево);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Картинка", НСтр(
		"ru = 'Картинка'", ОбщегоНазначения.КодОсновногоЯзыка()), ОписанияТиповПолей.ОписаниеТиповСтрока1000,
		ОписанияТиповПолей.ОписаниеТиповСтрока1000, , , , , Ложь);

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда

		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Партия", НСтр(
			"ru = 'Партия (наименование)'"), ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка);

	КонецЕсли;

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Количество", НСтр(
		"ru = 'Количество'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписанияТиповПолей.ОписаниеТиповЧисло15_3, , ,
		Истина);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения, СправочникСсылка.ЕдиницыИзмерения");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЕдиницаИзмерения", НСтр(
		"ru = 'Ед. изм.'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка, , , , ,
		ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения"));

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Цена", НСтр("ru = 'Цена'"),
		ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписанияТиповПолей.ОписаниеТиповЧисло15_2, , , Ложь);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.СтавкиНДС");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "СтавкаНДС", НСтр(
		"ru = 'Ставка НДС'"), ОписанияТиповПолей.ОписаниеТиповСтрока50, ОписаниеТиповКолонка);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "СуммаНДС", НСтр(
		"ru = 'Сумма НДС'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписанияТиповПолей.ОписаниеТиповЧисло15_2);

КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	НастройкиПоиска				= НастройкиЗагрузкиДанных.НастройкиПоиска;
	
	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	ТаблицаДублирующихСтрок = ЗагрузкаДанныхИзВнешнегоИсточника.ПустаяТаблицаДублирующихСтрокНоменклатуры();
	НастройкиПоиска.Вставить("ТаблицаДублирующихСтрок", ТаблицаДублирующихСтрок);

	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		НоменклатураСопоставлена = Ложь;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "НоменклатураПоставщиков") 
			И (ЗначениеЗаполнено(СтрокаТаблицыФормы.АртикулПоставщика)
			ИЛИ ЗначениеЗаполнено(СтрокаТаблицыФормы.Идентификатор)
			ИЛИ ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураПоставщиковНаименование)) Тогда
		
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуруПоставщиков(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных);	
			НоменклатураСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураПоставщиков);
		КонецЕсли;
		
		Если НЕ НоменклатураСопоставлена Тогда
		
			// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуру(СтрокаТаблицыФормы, НастройкиПоиска);
		
		КонецЕсли; 
		
		// Содержание
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Содержание, СтрокаТаблицыФормы.Содержание_ВходящиеДанные);
		
		СтрокаТаблицыФормы.СчетУчетаЗапасов = Справочники.Номенклатура.СчетУчетаЗапасов();
		СтрокаТаблицыФормы.СчетУчетаЗатрат = ?(ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуПроизводство"), 
			ПланыСчетов.Управленческий.НезавершенноеПроизводство, ПланыСчетов.Управленческий.КоммерческиеРасходы);
		СтрокаТаблицыФормы.СчетУчетаДоходов = ?(СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ПодарочныйСертификат"), 
			ПланыСчетов.Управленческий.ПрочиеДоходы, ПланыСчетов.Управленческий.ПустаяСсылка());
			
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "НаправлениеДеятельности") Тогда
				
			ЗначениеПоУмолчанию = Справочники.НаправленияДеятельности.Прочее;
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНаправлениеДеятельности(СтрокаТаблицыФормы.НаправлениеДеятельности, СтрокаТаблицыФормы.НаправлениеДеятельности_ВходящиеДанные, ЗначениеПоУмолчанию);
			
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "МетодОценки") Тогда
				
			ЗначениеПоУмолчанию = Перечисления.МетодОценкиЗапасов.ПоСредней;
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьМетодОценки(СтрокаТаблицыФормы.МетодОценки, СтрокаТаблицыФормы.МетодОценки_ВходящиеДанные, ЗначениеПоУмолчанию);
			
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "СпособПополнения") Тогда
				
			ЗначениеПоУмолчанию = Перечисления.СпособыПополненияЗапасов.Закупка;
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСпособПополнения(СтрокаТаблицыФормы.СпособПополнения, СтрокаТаблицыФормы.СпособПополнения_ВходящиеДанные, ЗначениеПоУмолчанию);
			
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "КатегорияНоменклатуры_ВходящиеДанные")
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "КатегорияНоменклатуры") Тогда
		
			ЗначениеПоУмолчанию = Справочники.КатегорииНоменклатуры.БезКатегории;					
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКатегориюНоменклатуры(СтрокаТаблицыФормы.КатегорияНоменклатуры, СтрокаТаблицыФормы.КатегорияНоменклатуры_ВходящиеДанные, ЗначениеПоУмолчанию);
			
		КонецЕсли;
		
		// Характеристика по Владельцу и Наименованию
		Если НЕ НоменклатураСопоставлена И ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") И ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
			
			Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
				
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьХарактеристику(СтрокаТаблицыФормы);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "Родитель")
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "РодительНаименование")
			И ЗначениеЗаполнено(СтрокаТаблицыФормы.РодительНаименование) Тогда
			
			ЗначениеПоУмолчанию = Справочники.Номенклатура.ПустаяСсылка();
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьРодителяНоменклатуры(СтрокаТаблицыФормы.Родитель, "", СтрокаТаблицыФормы.РодительНаименование, ЗначениеПоУмолчанию);
			
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "ЭтоУслуга_ВходящиеДанные") Тогда
			
			СтрокаТаблицыФормы.ЭтоУслуга = СтрокаТаблицыФормы.ЭтоУслуга_ВходящиеДанные;
			
		КонецЕсли;
		
		// Партия по Владельцу и Наименованию
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда
			
			Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
				
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьПартию(СтрокаТаблицыФормы.Партия, СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Партия_ВходящиеДанные);
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Количество
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Количество, СтрокаТаблицыФормы.Количество_ВходящиеДанные, 1);
		
		// ЕдиницыИзмерения по Наименованию (так же рассмотреть возможность прикрутить пользовательские ЕИ)
		ЗначениеПоУмолчанию = ?(ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура), СтрокаТаблицыФормы.Номенклатура.ЕдиницаИзмерения, Справочники.КлассификаторЕдиницИзмерения.шт);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьЕдиницыИзмерения(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.ЕдиницаИзмерения, СтрокаТаблицыФормы.ЕдиницаИзмерения_ВходящиеДанные, ЗначениеПоУмолчанию);
		
		// Цена
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Цена, СтрокаТаблицыФормы.Цена_ВходящиеДанные, 1);
		
		// СтавкаНДС по наименованию
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСтавкуНДС(СтрокаТаблицыФормы.СтавкаНДС, СтрокаТаблицыФормы.СтавкаНДС_ВходящиеДанные, Неопределено);
		
		// СуммаНДС
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.СуммаНДС, СтрокаТаблицыФормы.СуммаНДС_ВходящиеДанные, 0);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ТаблицаСопоставленияДанных.ЗагрузитьКолонку(ТаблицаДублирующихСтрок.ВыгрузитьКолонку("КлючСвязи"), "_КлючСвязи");
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	НоменклатураЗаполнена = ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура);
	ЗагрузкаНоменклатурыВозможна = Ложь;
	Если НЕ НоменклатураЗаполнена Тогда
		ЗагрузкаНоменклатурыВозможна = (ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураНаименование) ИЛИ ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураНаименованиеПолное));
	КонецЕсли;

	Если НоменклатураЗаполнена Тогда
			
		СтрокаТаблицыФормы[ИмяСлужебногоПоля] = (СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас 
				ИЛИ СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга)
			И СтрокаТаблицыФормы.Количество <> 0;
		СтрокаТаблицыФормы._СтрокаСопоставлена = НоменклатураЗаполнена;
		
	Иначе
		
		 СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗагрузкаНоменклатурыВозможна;
			
	КонецЕсли;	
	
КонецПроцедуры

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