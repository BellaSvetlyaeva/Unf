#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УзелОбмена = ИнтеграцияСИнтернетМагазиномВызовСервера.ЗначениеРеквизитаОбъекта(ПараметрКоманды,
	"УзелОбменаТовары");
	
	ПараметрыФормы = Новый Структура("УзелОбмена", УзелОбмена);
	
	ОткрытьФорму("Обработка.РегистрацияИзмененийДляОбменаДанными.Форма.Форма",
	ПараметрыФормы,
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно,
	ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры

#КонецОбласти
