#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("УстановитьОсновноеРабочееМесто") Тогда
		
		РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.УстановитьОсновноеРабочееМестоВОрганизации(ЭтотОбъект);
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРаботуНаНеполнуюСтавку") Тогда
			ТаблицаТекущегоНабора = Выгрузить();
			Для Каждого ЗаписьНабора Из ТаблицаТекущегоНабора Цикл
				ЗаписьНабора.КоличествоСтавок = 1;
			КонецЦикла;
			Загрузить(ТаблицаТекущегоНабора);
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("Сотрудники", ВыгрузитьКолонку("Сотрудник"));
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
			|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация КАК Организация
			|ПОМЕСТИТЬ ВТОрганизацииСотрудников
			|ИЗ
			|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|ГДЕ
			|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
		
		Запрос.Выполнить();
		
		ДополнительныеСвойства.Вставить("ОрганизацииСотрудников", Запрос.МенеджерВременныхТаблиц);
		
		ИнтеграцияУправлениеПерсоналомСобытия.ТекущиеКадровыеДанныеСотрудниковПередЗаписью(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		Если ДополнительныеСвойства.Свойство("ОрганизацииСотрудников") Тогда
			
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ОрганизацииСотрудников;
			Запрос.УстановитьПараметр("Сотрудники", ВыгрузитьКолонку("Сотрудник"));
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
				|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация КАК Организация
				|ПОМЕСТИТЬ ВТТекущиеОрганизацииСотрудников
				|ИЗ
				|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
				|ГДЕ
				|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ЕСТЬNULL(ТекущиеОрганизацииСотрудников.Сотрудник, ОрганизацииСотрудников.Сотрудник) КАК Сотрудник,
				|	ЕСТЬNULL(ТекущиеОрганизацииСотрудников.Организация, ОрганизацииСотрудников.Организация) КАК Организация,
				|	ВЫБОР
				|		КОГДА ТекущиеОрганизацииСотрудников.Сотрудник ЕСТЬ NULL
				|			ТОГДА -1
				|		ИНАЧЕ 1
				|	КОНЕЦ КАК ФлагИзменений
				|ИЗ
				|	ВТТекущиеОрганизацииСотрудников КАК ТекущиеОрганизацииСотрудников
				|		ПОЛНОЕ СОЕДИНЕНИЕ ВТОрганизацииСотрудников КАК ОрганизацииСотрудников
				|		ПО ТекущиеОрганизацииСотрудников.Сотрудник = ОрганизацииСотрудников.Сотрудник
				|			И ТекущиеОрганизацииСотрудников.Организация = ОрганизацииСотрудников.Организация
				|ГДЕ
				|	ЕСТЬNULL(ОрганизацииСотрудников.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) <> ЕСТЬNULL(ТекущиеОрганизацииСотрудников.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				
				ТаблицаАнализаИзменений = КадровыйУчет.ТаблицаАнализаИзменений();
				
				Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(ТаблицаАнализаИзменений.Добавить(), Выборка);
				КонецЦикла;
				
				КадровыйУчет.ОбработатьИзменениеОрганизацийВНабореПоТаблицеИзменений(ТаблицаАнализаИзменений);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИнтеграцияУправлениеПерсоналомСобытия.ТекущиеКадровыеДанныеСотрудниковПриЗаписи(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли