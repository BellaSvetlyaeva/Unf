#Область СлужебныйПрограммныйИнтерфейс

Функция АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(ПараметрыСканирования, Знач Объект, УникальныйИдентификатор, ВидМаркируемойПродукции) Экспорт
	
	ТаблицаШтрихкодов = Объект.АкцизныеМарки.Выгрузить();
	ШтрихкодыМаркируемойПродукции = ИнтеграцияИСУНФ.ШтрихкодыСодержащиеВидыПродукции(
		ТаблицаШтрихкодов.ВыгрузитьКолонку("АкцизнаяМарка"), ВидМаркируемойПродукции);
		
	Если ИнтеграцияИСМПКлиентСерверПовтИсп.ПоддерживаетсяЧастичноеВыбытие(
		ВидМаркируемойПродукции,
		ПараметрыСканирования.ВидОперацииИСМП) Тогда
		
		МассивУпаковок    = Новый Массив();
		КэшИсходныхДанных = Новый Соответствие();
		
		Для Каждого ШтрихкодУпаковки Из ШтрихкодыМаркируемойПродукции Цикл
			
			НовыйЭлемент = ШтрихкодированиеИСМП.НовыйЭлементКоллекцииУпаковокДляРаспределенияПоТоварам();
			НовыйЭлемент.ШтрихкодУпаковки = ШтрихкодУпаковки;
			
			МассивУпаковок.Добавить(НовыйЭлемент);
			
			КэшИсходныхДанных.Вставить(ШтрихкодУпаковки, НовыйЭлемент);
			
		КонецЦикла;
	
		Для Каждого СтрокаТаблицы Из ТаблицаШтрихкодов Цикл
			
			ДанныеРезультата = КэшИсходныхДанных.Получить(СтрокаТаблицы.АкцизнаяМарка);
			Если ДанныеРезультата = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеРезультата.ЧастичноеВыбытиеКоличество     = СтрокаТаблицы.ЧастичноеВыбытиеКоличество;
			ДанныеРезультата.ЧастичноеВыбытиеВариантУчета   = СтрокаТаблицы.ЧастичноеВыбытиеВариантУчета;
			ДанныеРезультата.ЧастичноеВыбытиеНоменклатура   = СтрокаТаблицы.ЧастичноеВыбытиеНоменклатура;
			ДанныеРезультата.ЧастичноеВыбытиеХарактеристика = СтрокаТаблицы.ЧастичноеВыбытиеХарактеристика;
			
		КонецЦикла;
		
	Иначе
		
		МассивУпаковок = ШтрихкодыМаркируемойПродукции;
		
	КонецЕсли;
	
	ДанныеПроверяемогоДокумента = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковок(
		МассивУпаковок, ПараметрыСканирования);
	
	ТаблицаМаркируемойПродукции = ПроверкаИПодборПродукцииИСМП.ТаблицаМаркируемойПродукцииДокумента(Объект, ВидМаркируемойПродукции);
	
	
	// Обработка ранее заведенных штрихкодов, содержащих в поле Серия ссылку на справочник ПартииНоменклатуры
	Для Каждого Элемент Из ДанныеПроверяемогоДокумента.МаркированныеТовары Цикл
		Если ТипЗнч(Элемент.Серия) = Тип("СправочникСсылка.ПартииНоменклатуры") Тогда
			Элемент.Серия = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элемент Из ТаблицаМаркируемойПродукции Цикл
		
		Если ТипЗнч(Элемент.Серия) = Тип("СправочникСсылка.ПартииНоменклатуры") 
			Или ТипЗнч(Элемент.Серия) = Тип("СправочникСсылка.СерииНоменклатуры") И НЕ ЗначениеЗаполнено(Элемент.Серия) Тогда
			Элемент.Серия = Неопределено;
		КонецЕсли;
		
	КонецЦикла;

	ДанныеХранилища = Новый Структура("ДеревоУпаковок, МаркированныеТовары, ТаблицаМаркируемойПродукции",
		ДанныеПроверяемогоДокумента.ДеревоУпаковок,
		ДанныеПроверяемогоДокумента.МаркированныеТовары,
		ТаблицаМаркируемойПродукции);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеХранилища, УникальныйИдентификатор);
	
КонецФункции

Функция ПолучитьСтруктурнуюЕдиницуПоУмолчанию(Документ) Экспорт
	
	ПравилаЗаполненияДляСтруктурнойЕдиницы = Новый Соответствие;
	ЗаполнениеОбъектовУНФПереопределяемый.ПриОпределенииПравилУстановкиСтруктурныхЕдиниц(
	ПравилаЗаполненияДляСтруктурнойЕдиницы);
	
	ПредопределеннаяСтруктурнаяЕдиница = ПравилаЗаполненияДляСтруктурнойЕдиницы[ТипЗнч(Документ.ПолучитьОбъект())];
	
	Возврат ПредопределеннаяСтруктурнаяЕдиница;
	
КонецФункции

#КонецОбласти