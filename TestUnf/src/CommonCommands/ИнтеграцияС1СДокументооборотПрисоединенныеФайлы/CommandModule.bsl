#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПередВыполнениемКоманды(
		ПараметрыВыполненияКоманды.Источник);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьПрисоединенныеФайлы(
		ПараметрКоманды,,,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти