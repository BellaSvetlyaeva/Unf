#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПередВыполнениемКоманды(
		ПараметрыВыполненияКоманды.Источник);
	
	ОткрытьФорму(
		"ОбщаяФорма.ИнтеграцияС1СДокументооборотЗадачиИсполнителя",,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти