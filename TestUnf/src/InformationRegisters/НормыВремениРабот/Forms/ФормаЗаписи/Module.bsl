#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи.Номенклатура) Тогда
		Запись.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
