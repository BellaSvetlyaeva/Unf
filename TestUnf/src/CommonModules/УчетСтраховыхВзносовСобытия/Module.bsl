
#Область СлужебныеПроцедурыИФункции

Процедура УстановитьФункциональныеОпцииУчетСтраховыхВзносов(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписиФО = РегистрыСведений.НастройкиУчетаСтраховыхВзносов.СоздатьНаборЗаписей();
	ЗаписиФО.Отбор.Организация.Установить(Источник.Ссылка);
	ЗаписиФО.Прочитать();
	Если ЗаписиФО.Количество() = 0 Тогда
		
		СтрокаФО = ЗаписиФО.Добавить();
		СтрокаФО.Организация = Источник.Ссылка;
		
		УстановитьПривилегированныйРежим(Истина);
		ЗаписиФО.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтавкуФССНСНовойОрганизации(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписиСтавокФССНС = РегистрыСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.СоздатьНаборЗаписей();
	ЗаписиСтавокФССНС.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
	ЗаписиСтавокФССНС.Отбор.Организация.Установить(Источник.Ссылка);
	ЗаписиСтавокФССНС.Прочитать();
	Если ЗаписиСтавокФССНС.Количество() = 0 Тогда
		
		ЗаписьПоУмолчанию = РегистрыСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.ЗаписьПоУмолчанию();
		НоваяЗапись = ЗаписиСтавокФССНС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьПоУмолчанию);
		НоваяЗапись.Организация = Источник.Ссылка;
		
		УстановитьПривилегированныйРежим(Истина);
		ЗаписиСтавокФССНС.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьФункциональныеОпцииИспользованияСтраховыхВзносовПоКлассамУсловийТрудаПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоОрганизациям = Неопределено;
	ПроверятьИспользованиеФункциональнойОпции = Ложь;
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.КлассыУсловийТрудаПоДолжностям") Тогда
		Если Источник.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		Если ТипЗнч(Источник[0].Должность) = Тип("СправочникСсылка.Должности") Тогда
			ПроверятьИспользованиеФункциональнойОпции = Истина;
		Иначе
			УчетСтраховыхВзносовВнутренний.ЗаполнитьОтборПоОрганизацииПриУстановкеИспользованияСтраховыхВзносовПоКлассамУсловийТруда(ОтборПоОрганизациям, Источник[0].Должность);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.Должности") Тогда
		ПроверятьИспользованиеФункциональнойОпции = Истина;
	КонецЕсли;
	
	Если ПроверятьИспользованиеФункциональнойОпции Тогда
		ИмяОпции = "ИспользоватьШтатноеРасписание";
		ФункциональнаяОпцияИспользуется = (Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		Если ФункциональнаяОпцияИспользуется И ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьФункциональныеОпции = Истина;
	Если Источник.ДополнительныеСвойства.Свойство("ОбновитьНастройкиИспользованияСтраховыхВзносовПоКлассамУсловийТруда") Тогда
		УстановитьФункциональныеОпции = Источник.ДополнительныеСвойства.ОбновитьНастройкиИспользованияСтраховыхВзносовПоКлассамУсловийТруда;
	КонецЕсли;
	
	Если УстановитьФункциональныеОпции Тогда
		УчетСтраховыхВзносов.УстановитьФункциональныеОпцииИспользованияСтраховыхВзносовПоКлассамУсловийТруда(ОтборПоОрганизациям);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
