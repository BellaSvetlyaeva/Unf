
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	ПараметрыФормы.Отбор.Вставить("ВладелецФайла", ПараметрКоманды);
	ОткрытьФорму("Справочник.СообщениеЭДОПрисоединенныеФайлы.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти