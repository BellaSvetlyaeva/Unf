#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Мобильная телефония'"));
	ПараметрыФормы.Вставить("КлючПодсказки", "Телефония_МобильнаяТелефония");

	ОткрытьФорму("Обработка.МенеджерПодсказок.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры

#КонецОбласти
