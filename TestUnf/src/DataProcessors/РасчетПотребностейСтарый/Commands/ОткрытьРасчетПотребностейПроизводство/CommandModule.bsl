
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ТолькоЗакупки", Ложь);
	ОткрытьФорму("Обработка.РасчетПотребностейСтарый.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "РасчетПотребностейПроизводство", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти 

