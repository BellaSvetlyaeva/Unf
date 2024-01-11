#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм
	
// Получает данные по хеш суммам для переданных упаковок. Возвращает таблицу с идентификаторами строк, требующих перемаркировки
//
// Параметры:
//	СтрокиДерева - Массив - содержит структуры с данными упаковок, для которых требуется получить хеш сумму:
//		* ИдентификаторСтроки - Число - идентификатор строки дерева маркируемой продукции
//		* ТипУпаковки - ПеречислениеСсылка.ТипыУпаковок - тип упаковки строки дерева маркируемой продукции
//		* СтатусПроверки - ПеречислениеСсылка.СтатусыПроверкиИПодбораИС - статус проверки строки дерева маркируемой продукции
//		* Штрихкод - Строка - значение штрихкода строки дерева маркируемой продукции
//		* ХешСумма - Строка - рассчитываемая хеш-сумма строки дерева маркируемой продукции
//		* ПодчиненныеСтроки - Массив - дочерние строки строки дерева маркируемой продукции
//	ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования
//	
// Возвращаемое значение:
//	Массив из Структура - содержит структуры с данными строк, для которых требуется перемаркировка
//		* ИдентификаторВДереве - Число - идентификатор строки дерева маркируемой продукции
//		* ТребуетсяПеремаркировка - Булево - признак необходимости перемаркировки
//
Функция ПересчитатьХешСуммыВсехУпаковок(СтрокиДерева, ПараметрыСканирования = Неопределено) Экспорт
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки)
			Или СтрокаДерева.ТипУпаковки = ПроверкаИПодборПродукцииИСМПКлиентСервер.ТипУпаковкиГрупповыеУпаковкиБезКоробки() Тогда
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСумм, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ШтрихкодИДанныеУпаковки = Неопределено;
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм, ШтрихкодИДанныеУпаковки);
	
	СоответствиеСтрок = Неопределено;
	
	// Обход ошибки расчета хеш суммы без учета поля ХешСуммыНормализации
	Для Каждого СтрокаПеремаркировки Из ТаблицаПеремаркировки Цикл
		
		Если СтрокаПеремаркировки.ТребуетсяПеремаркировка Тогда
			
			Если СоответствиеСтрок = Неопределено Тогда
				СоответствиеСтрок = Новый Соответствие;
				СоответствиеСтрокДерева(СтрокиДерева, СоответствиеСтрок);
			КонецЕсли;
			
			ТаблицаХешСуммБезУчетаХешСуммыНормализации = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
			СтрокаДерева = СоответствиеСтрок[СтрокаПеремаркировки.ИдентификаторВДереве];
			Если СтрокаДерева = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСуммБезУчетаХешСуммыНормализации, Истина,, Ложь);
			
			Для Каждого СтрокаХешСуммы Из ТаблицаХешСуммБезУчетаХешСуммыНормализации Цикл
				
				ДанныеУпаковки = ШтрихкодИДанныеУпаковки[СтрокаХешСуммы.Штрихкод];
				Если ДанныеУпаковки = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				Если СтрокаХешСуммы.ХешСумма = ДанныеУпаковки.ХешСумма
					И ПустаяСтрока(СтрокаХешСуммы.ХешСумма) Тогда
					СтрокаПеремаркировки.ТребуетсяПеремаркировка = (СтрокаХешСуммы.СодержимоеОтсутствует
						И (ДанныеУпаковки.Количество <> 0 Или ДанныеУпаковки.КоличествоПотребительскихУпаковок <> 0));
				Иначе
					СтрокаПеремаркировки.ТребуетсяПеремаркировка = (СтрокаХешСуммы.ХешСумма <> ДанныеУпаковки.ХешСумма);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Форма = Новый Структура;
	Форма.Вставить("ПараметрыСканирования",        ПараметрыСканирования);
	Форма.Вставить("ДеревоМаркированнойПродукции", СтрокиДерева);
	
	ПроверкаИПодборПродукцииИС.ОбработататьТаблицуПеремаркировкиСУчетомДетализации(Форма, ТаблицаПеремаркировки, ШтрихкодИДанныеУпаковки);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаПеремаркировки);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоответствиеСтрокДерева(СтрокиДерева, СоответствиеСтрокДерева)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		СоответствиеСтрокДерева.Вставить(СтрокаДерева.ИдентификаторСтроки, СтрокаДерева);
		
		СоответствиеСтрокДерева(СтрокаДерева.Строки, СоответствиеСтрокДерева);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
