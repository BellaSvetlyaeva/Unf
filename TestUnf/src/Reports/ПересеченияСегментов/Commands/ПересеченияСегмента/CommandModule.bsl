#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если Не ЗначениеЗаполнено(ПараметрКоманды) Тогда
		Возврат;
	КонецЕсли;

	Если ВыбранаГруппа(ПараметрКоманды) Тогда
		ВызватьИсключение НСтр("ru = 'Нельзя выбирать группу сегментов.'");
	КонецЕсли;

	ПараметрыИОтборОтчета = Новый Структура("СегментОтбора", ПараметрКоманды);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "ПересеченияСегментаКонтрагентов");
	ПараметрыФормы.Вставить("Отбор", ПараметрыИОтборОтчета);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);

	ОткрытьФорму("Отчет.ПересеченияСегментов.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, Истина,
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыбранаГруппа(Сегмент)

	Возврат Сегмент.ЭтоГруппа;

КонецФункции

#КонецОбласти
