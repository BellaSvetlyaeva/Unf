
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();
	Параметры = Новый Структура();
	Параметры.Вставить("ТипГрузоперевозки", 1);
	СервисДоставкиКлиент.ОткрытьФормуОтслеживанияЗаказа(Параметры);
	
КонецПроцедуры

#КонецОбласти

