#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодробноОСервисе(Команда)
	
	КабинетСотрудникаКлиент.ОткрытьНавигационнуюСсылкуПодробноОСервисе();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКабинетСотрудников(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ИнтеграцияССервисомКабинетСотрудника");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	ЗакрытьФормуНаСервере();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗакрытьФормуНаСервере()
	
	Константы.ПоказыватьПриглашениеКабинетСотрудника.Установить(Ложь);
	
КонецПроцедуры

#КонецОбласти