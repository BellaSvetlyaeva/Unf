#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	ПараметрыФормы = Новый Структура("УзелИнформационнойБазы", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.ОбъектыНезарегистрированныеПриЗацикливании.ФормаСписка", 
		ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти