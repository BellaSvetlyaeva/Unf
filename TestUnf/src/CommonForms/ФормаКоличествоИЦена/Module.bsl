#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ЗначениеЗаполнения);

	Если Параметры.ЗначениеЗаполнения.Свойство("ВладелецЕдиницИзмерения") Тогда

		Номенклатура = Параметры.ЗначениеЗаполнения.ВладелецЕдиницИзмерения;
		ЕдиницаИзмерения = ?(ЗначениеЗаполнено(Номенклатура), Номенклатура.ЕдиницаИзмерения,
			Справочники.ЕдиницыИзмерения.ПустаяСсылка());

	КонецЕсли;

	Элементы.Цена.Доступность = ЦенаДоступна;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	Закрыть(Новый Структура("ЕдиницаИзмерения, Количество, Цена", ЕдиницаИзмерения, Количество, Цена));

КонецПроцедуры

#КонецОбласти
