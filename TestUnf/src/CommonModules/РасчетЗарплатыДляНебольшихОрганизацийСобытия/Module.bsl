////////////////////////////////////////////////////////////////////////////////
// РасчетЗарплатыДляНебольшихОрганизаций: 
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьУсловиеРасчетаЗарплатыДляНебольшихОрганизаций(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("РасчетЗарплатыДляНебольшихОрганизаций") Тогда
		
		Если НЕ РасчетЗарплатыДляНебольшихОрганизаций.РасчетЗарплатыДляНебольшихОрганизацийВозможен() Тогда
			
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый.ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников(),
				РасчетЗарплатыДляНебольшихОрганизаций.ПорогЗапрета());
				
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДокументыПередЗаписью(Источник, Отказ) Экспорт
	
	Если НЕ Отказ И Источник.ЭтоНовый() Тогда
		
		ТекстИсключения = "";
		Если НЕ ПолучитьФункциональнуюОпцию("РасчетЗарплатыДляНебольшихОрганизаций") Тогда
			
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый.ТекстСообщенияОНевозможностиСоздаватьДокументыПриОтключеннойНастройке(),
				Источник.Метаданные().Синоним);
				
			Отказ = Истина
			
		ИначеЕсли НЕ РасчетЗарплатыДляНебольшихОрганизаций.РасчетЗарплатыДляНебольшихОрганизацийВозможен() Тогда
			
			ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый.ТекстСообщенияОНевозможностиСоздаватьДокументыПриПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников(),
				РасчетЗарплатыДляНебольшихОрганизаций.ПорогЗапрета(),
				Источник.Метаданные().Синоним);
			
			Отказ = Истина;
			
		КонецЕсли;
		
		Если Отказ Тогда
			
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОтключенииНачисленияЗарплаты() Экспорт
	
	Константы.РасчетЗарплатыДляНебольшихОрганизаций.Установить(Ложь);
	
КонецПроцедуры

Процедура ПриОтключенииРасчетаЗарплатыДляНебольшихОрганизаций() Экспорт

	МенеджерЗаписи = РегистрыСведений.НастройкиРасчетаЗарплаты.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() И МенеджерЗаписи.ИспользоватьНачисленияПоДоговорам Тогда
		МенеджерЗаписи.ИспользоватьНачисленияПоДоговорам = Ложь;
		МенеджерЗаписи.Записать();
	КонецЕсли;

	МенеджерЗаписи = РегистрыСведений.НастройкиКадровогоУчета.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() И МенеджерЗаписи.ИспользоватьРаботуНаНеполнуюСтавку Тогда
		МенеджерЗаписи.ИспользоватьРаботуНаНеполнуюСтавку = Ложь;
		МенеджерЗаписи.Записать();
	КонецЕсли;

КонецПроцедуры


Процедура ОтключениеНеИспользуемойФункциональностиЗарплатаКадрыПередЗаписью(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.Значение Тогда
		ВызватьИсключение НСтр("ru='Функциональность не используется в этой конфигурации. Действие не выполнено'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТекущиеКадровыеДанныеСотрудников(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.Значение
		И Источник.ДополнительныеСвойства.Свойство("ЗаполнитьТекущиеКадровыеДанныеСотрудников") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		// УНФ
		// В УНФ в справочнике сотрудники может быть пустое значение реквизита Физлицо в существующих базах,
		// которые были созданы до того, как в УНФ физ. лицо стало создаваться при записи сотрудника.
		// Конец УНФ
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
			|	Сотрудники.Ссылка КАК Сотрудник,
			|	Сотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
			|ПОМЕСТИТЬ ВТСотрудникиПериоды
			|ИЗ
			|	Справочник.Сотрудники КАК Сотрудники
			|ГДЕ
			|	Сотрудники.Физлицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)";
		
		Запрос.Выполнить();
		
		ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Сотрудник");
		
		ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
			"КадроваяИсторияСотрудников",
			Запрос.МенеджерВременныхТаблиц,
			Ложь,
			ОписаниеФильтра);
		
		ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
			"ВидыЗанятостиСотрудников",
			Запрос.МенеджерВременныхТаблиц,
			Ложь,
			ОписаниеФильтра);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СотрудникиПериоды.ФизическоеЛицо КАК ФизическоеЛицо,
			|	СотрудникиПериоды.Сотрудник КАК Сотрудник,
			|	СотрудникиПериоды.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	КадроваяИсторияСотрудников.Организация КАК ТекущаяОрганизация,
			|	КадроваяИсторияСотрудников.Подразделение КАК ТекущееПодразделение,
			|	КадроваяИсторияСотрудников.Должность КАК ТекущаяДолжность,
			|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
			|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
			|	ВидыЗанятостиСотрудников.ВидЗанятости КАК ТекущийВидЗанятости,
			|	ВЫБОР
			|		КОГДА ВидыЗанятостиСотрудников.ВидЗанятости ЕСТЬ NULL
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК ОформленПоТрудовомуДоговору
			|ИЗ
			|	ВТСотрудникиПериоды КАК СотрудникиПериоды
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|		ПО СотрудникиПериоды.ФизическоеЛицо = ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо
			|			И СотрудникиПериоды.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|			И СотрудникиПериоды.ГоловнаяОрганизация = ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадроваяИсторияСотрудниковСрезПоследних КАК КадроваяИсторияСотрудников
			|		ПО СотрудникиПериоды.Период = КадроваяИсторияСотрудников.Период
			|			И СотрудникиПериоды.Сотрудник = КадроваяИсторияСотрудников.Сотрудник
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВидыЗанятостиСотрудниковСрезПоследних КАК ВидыЗанятостиСотрудников
			|		ПО СотрудникиПериоды.Период = ВидыЗанятостиСотрудников.Период
			|			И СотрудникиПериоды.Сотрудник = ВидыЗанятостиСотрудников.Сотрудник";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			
			НаборЗаписей = РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Загрузить(РезультатЗапроса.Выгрузить());
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("УстановитьОсновноеРабочееМесто", Истина);
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНеобходимостьЗаполненияТекущихКадровыхДанныхСотрудников(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.Значение Тогда
		
		Если Константы.ИспользоватьКадровыйУчет.Получить() Тогда
			Источник.ДополнительныеСвойства.Вставить("ЗаполнитьТекущиеКадровыеДанныеСотрудников", Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриПримененииТарифаСтраховыхВзносов(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ПрименяетсяАУСН = Ложь;
	Для Каждого Запись Из Источник Цикл
		Если Запись.ВидТарифа = Справочники.ВидыТарифовСтраховыхВзносов.АУСН Тогда
			ПрименяетсяАУСН = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПрименяетсяАУСН Тогда
		РасчетЗарплатыДляНебольшихОрганизаций.ПодготовитьНачисленияАУСН();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьНачислениеАУСНПриЗаписи(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если РасчетЗарплатыДляНебольшихОрганизаций.ПрименяетсяАУСН() Тогда
		Если Не Источник.ДополнительныеСвойства.Свойство("ЗаписьНачисленияПриАУСН") Тогда
			РасчетЗарплатыДляНебольшихОрганизаций.ПодготовитьНачислениеПриАУСН(Источник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

