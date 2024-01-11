#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЖурналДокументыПоКадрам");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности	
	
	ПараметрыОткрытия = Новый Структура("ЭтоНачальнаяСтраница", Ложь);
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКадрам.ФормаСписка", ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
