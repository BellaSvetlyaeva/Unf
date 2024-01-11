
#Область СлужебныеПроцедурыИФункции

Процедура КвартальнаяОтчетностьПФРВыполнитьНазначеннуюКоманду(Форма, Команда) Экспорт
		
КонецПроцедуры	

Процедура ПодобратьФизическихЛиц(ЭлементФормы, Организация, АдресСпискаПодобранныхСотрудников, МножественныйВыбор) Экспорт 
	
	ПараметрыОткрытияФормы = Новый Структура;
	СтруктураОтбора = Новый Структура;
	
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", МножественныйВыбор);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", НЕ МножественныйВыбор);
	ПараметрыОткрытияФормы.Вставить("Отбор", СтруктураОтбора);
	
	Если НЕ ПустаяСтрока(АдресСпискаПодобранныхСотрудников) Тогда
		ПараметрыОткрытияФормы.Вставить("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников);
	КонецЕсли; 
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыОткрытияФормы, ЭлементФормы);	
	
КонецПроцедуры

#КонецОбласти
