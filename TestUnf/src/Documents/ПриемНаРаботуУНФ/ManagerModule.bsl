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

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаПриемНаРаботу, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ 
	|	&Организация КАК Организация,
	|	ПриемНаРаботуСотрудники.НомерСтроки,
	|	ПриемНаРаботуСотрудники.Сотрудник,
	|	ПриемНаРаботуСотрудники.СтруктурнаяЕдиница,
	|	ПриемНаРаботуСотрудники.Должность,
	|	ПриемНаРаботуСотрудники.ГрафикРаботы,
	|	ПриемНаРаботуСотрудники.ЗанимаемыхСтавок,
	|	ПриемНаРаботуСотрудники.Период
	|ПОМЕСТИТЬ ТаблицаСотрудники
	|ИЗ
	|	Документ.ПриемНаРаботуУНФ.Сотрудники КАК ПриемНаРаботуСотрудники
	|ГДЕ
	|	ПриемНаРаботуСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	&Организация КАК Организация,
	|	ПриемНаРаботуСотрудники.НомерСтроки,
	|	ПриемНаРаботуСотрудники.Сотрудник,
	|	ПриемНаРаботуСотрудники.Период,
	|	ПриемНаРаботуНачисленияУдержания.ВидНачисленияУдержания,
	|	ПриемНаРаботуНачисленияУдержания.Валюта,
	|	ПриемНаРаботуНачисленияУдержания.Сумма,
	|	ПриемНаРаботуНачисленияУдержания.СчетЗатрат
	|ПОМЕСТИТЬ ТаблицаНачисленияУдержания
	|ИЗ
	|	Документ.ПриемНаРаботуУНФ.Сотрудники КАК ПриемНаРаботуСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуУНФ.НачисленияУдержания КАК ПриемНаРаботуНачисленияУдержания
	|		ПО ПриемНаРаботуСотрудники.КлючСвязи = ПриемНаРаботуНачисленияУдержания.КлючСвязи
	|			И ПриемНаРаботуСотрудники.Ссылка = ПриемНаРаботуНачисленияУдержания.Ссылка
	|ГДЕ
	|	ПриемНаРаботуСотрудники.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Организация,
	|	ПриемНаРаботуСотрудники.НомерСтроки,
	|	ПриемНаРаботуСотрудники.Сотрудник,
	|	ПриемНаРаботуСотрудники.Период,
	|	ПриемНаРаботуНалогиНаДоходы.ВидНачисленияУдержания,
	|	ПриемНаРаботуНалогиНаДоходы.Валюта,
	|	0,
	|	НЕОПРЕДЕЛЕНО
	|ИЗ
	|	Документ.ПриемНаРаботуУНФ.Сотрудники КАК ПриемНаРаботуСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуУНФ.НалогиНаДоходы КАК ПриемНаРаботуНалогиНаДоходы
	|		ПО ПриемНаРаботуСотрудники.КлючСвязи = ПриемНаРаботуНалогиНаДоходы.КлючСвязи
	|			И ПриемНаРаботуСотрудники.Ссылка = ПриемНаРаботуНалогиНаДоходы.Ссылка
	|ГДЕ
	|	ПриемНаРаботуСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	ТаблицаСотрудники.Организация,
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.СтруктурнаяЕдиница,
	|	ТаблицаСотрудники.Должность,
	|	ТаблицаСотрудники.ГрафикРаботы,
	|	ТаблицаСотрудники.ЗанимаемыхСтавок,
	|	ТаблицаСотрудники.Период
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	ТаблицаНачисленияУдержания.Организация,
	|	ТаблицаНачисленияУдержания.НомерСтроки,
	|	ТаблицаНачисленияУдержания.Сотрудник,
	|	ТаблицаНачисленияУдержания.Период,
	|	ТаблицаНачисленияУдержания.ВидНачисленияУдержания,
	|	ТаблицаНачисленияУдержания.Валюта,
	|	ТаблицаНачисленияУдержания.Сумма,
	|	ТаблицаНачисленияУдержания.СчетЗатрат,
	|	ИСТИНА КАК Актуальность
	|ИЗ
	|	ТаблицаНачисленияУдержания КАК ТаблицаНачисленияУдержания");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПриемНаРаботу);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСотрудники", 				МассивРезультатов[2].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеНачисленияИУдержания", МассивРезультатов[3].Выгрузить());
	
	СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#Область ИнтерфейсПечати

Процедура СформироватьКадровыйПриказ(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;
	
	Макет				= УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент	= ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати		= Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеСведенияОПриеме.Ссылка
	|	,ОбщиеСведенияОПриеме.Номер
	|	,ОбщиеСведенияОПриеме.Дата КАК ДатаДокумента
	|	,ОбщиеСведенияОПриеме.Организация КАК Организация
	|	,ОбщиеСведенияОПриеме.Организация.Префикс КАК Префикс
	|	,ОбщиеСведенияОПриеме.Организация.КодПоОКПО КАК КодПоОКПО
	|	,ОбщиеСведенияОПриеме.ПодписьРуководителя.Должность КАК ДолжностьРуководителя
	|	,ОбщиеСведенияОПриеме.ПодписьРуководителя.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
	|ИЗ Документ.ПриемНаРаботуУНФ КАК ОбщиеСведенияОПриеме
	|ГДЕ ОбщиеСведенияОПриеме.Ссылка В(&МассивОбъектов)
	|
	|;Выбрать
	|	СведенияОСотрудниках.КлючСвязи КАК КлючСвязи
	|	,СведенияОСотрудниках.Период КАК ДатаПриема
	|	,Неопределено КАК ДатаЗавершенияТрудовогоДоговора
	|	,Неопределено КАК ДлительностьИспытательногоСрока
	|	,СведенияОСотрудниках.Сотрудник.Наименование КАК Работник
	|	,СведенияОСотрудниках.Сотрудник.Код КАК ТабельныйНомер
	|	,СведенияОСотрудниках.СтруктурнаяЕдиница КАК Подразделение
	|	,СведенияОСотрудниках.Должность.Наименование КАК Должность
	|	,Выбор КОГДА СведенияОСотрудниках.Сотрудник.ТипЗанятости = Значение(Перечисление.ТипыЗанятости.ОсновноеМестоРаботы)
	|		ТОГДА ""Основное место работы""
	|		ИНАЧЕ ""Работа по совместительству"" КОНЕЦ КАК УсловияПриема
	|ИЗ Документ.ПриемНаРаботуУНФ.Сотрудники КАК СведенияОСотрудниках
	|ГДЕ СведенияОСотрудниках.Ссылка В(&МассивОбъектов)
	|
	|;Выбрать
	|	СведенияОНачислениях.КлючСвязи КАК КлючСвязи
	|	,СведенияОНачислениях.Сумма КАК СуммаНачисления
	|	,ВидНачисленияУдержания.Наименование КАК ПредставлениеНачисления
	|ИЗ Документ.ПриемНаРаботуУНФ.НачисленияУдержания КАК СведенияОНачислениях
	|ГДЕ СведенияОНачислениях.Ссылка В(&МассивОбъектов)
	|	И СведенияОНачислениях.ВидНачисленияУдержания.Тип = Значение(Перечисление.ТипыНачисленийИУдержаний.Начисление)
	|УПОРЯДОЧИТЬ ПО СведенияОНачислениях.НомерСтроки";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОбщиеСведенияОПриеме = РезультатЗапроса[0].Выгрузить();
	СведенияОСотрудниках = РезультатЗапроса[1].Выгрузить();
	СведенияОНачислениях = РезультатЗапроса[2].Выгрузить();
	
	Для каждого ДанныеСотрудника Из СведенияОСотрудниках Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало, ДанныеПечати);
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ОбщиеСведенияОПриеме[0].Организация, ОбщиеСведенияОПриеме[0].ДатаДокумента, ,);
		ДанныеПечати.Вставить("НазваниеОрганизации", ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
		ДанныеПечати.Вставить("КодПоОКПО", ОбщиеСведенияОПриеме[0].КодПоОКПО);
		ДанныеПечати.Вставить("НомерДокумента", ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ОбщиеСведенияОПриеме[0].ДатаДокумента, ОбщиеСведенияОПриеме[0].Номер, ОбщиеСведенияОПриеме[0].Префикс));
		ДанныеПечати.Вставить("ДатаДокумента", ОбщиеСведенияОПриеме[0].ДатаДокумента);
		
		ДанныеПечати.Вставить("ДатаПриема", ДанныеСотрудника.ДатаПриема);
		ДанныеПечати.Вставить("ДатаЗавершенияТрудовогоДоговора", ДанныеСотрудника.ДатаЗавершенияТрудовогоДоговора);
		ДанныеПечати.Вставить("Работник", ДанныеСотрудника.Работник);
		ДанныеПечати.Вставить("ТабельныйНомер", ДанныеСотрудника.ТабельныйНомер);
		ДанныеПечати.Вставить("Подразделение", ДанныеСотрудника.Подразделение);
		ДанныеПечати.Вставить("Должность", ДанныеСотрудника.Должность);
		ДанныеПечати.Вставить("УсловияПриема", ДанныеСотрудника.УсловияПриема);
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("КлючСвязи", ДанныеСотрудника.КлючСвязи);
		
		ДанныеПечати.Вставить("ОкладТарифнаяСтавкаЦелаяЧасть", Неопределено);
		ДанныеПечати.Вставить("ОкладТарифнаяСтавкаДробнаяЧасть", Неопределено);
		ДанныеПечати.Вставить("Надбавка", Неопределено);
		ДанныеПечати.Вставить("ВалютаТарифнойСтавки", НСтр("ru ='руб.'"));
		ДанныеПечати.Вставить("КопейкиТарифнойСтавки", НСтр("ru ='коп.'"));
		
		ПорядковыйНомерНачисления = 0;
		
		НайденныеСтроки = СведенияОНачислениях.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаНачисления Из НайденныеСтроки Цикл
			
			Если ПорядковыйНомерНачисления = 0 Тогда
				
				ДанныеПечати.ОкладТарифнаяСтавкаЦелаяЧасть = Цел(СтрокаНачисления.СуммаНачисления);
				ДанныеПечати.ОкладТарифнаяСтавкаДробнаяЧасть = Формат(СтрокаНачисления.СуммаНачисления - ДанныеПечати.ОкладТарифнаяСтавкаЦелаяЧасть, "ЧН=00");
				
				ПорядковыйНомерНачисления = ПорядковыйНомерНачисления + 1;
				
			ИначеЕсли ПорядковыйНомерНачисления = 1 Тогда
				
				ДанныеПечати.Надбавка  = СокрЛП(СтрокаНачисления.ПредставлениеНачисления) + ": " + Строка(СтрокаНачисления.СуммаНачисления);
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ДанныеПечати.Вставить("ДлительностьИспытательногоСрока", ДанныеСотрудника.ДлительностьИспытательногоСрока);
		ДанныеПечати.Вставить("ДолжностьРуководителя", ОбщиеСведенияОПриеме[0].ДолжностьРуководителя);
		ДанныеПечати.Вставить("РуководительРасшифровкаПодписи", ОбщиеСведенияОПриеме[0].РуководительРасшифровкаПодписи);
		
		Макет.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(Макет);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбщиеСведенияОПриеме[0].Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Приказ_Т1");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриемНаРаботу_Т1";
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ПриемНаРаботуУНФ.ПФ_MXL_Т1";
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Т-1 (Приказ о приеме на работу)'");
		
		СформироватьКадровыйПриказ(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати);
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	ЭлектроннаяПочтаУНФ.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов,
		КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Приказ_Т1";
	КомандаПечати.Представление = НСтр("ru = 'Т-1 (Приказ о приеме на работу)'");
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли