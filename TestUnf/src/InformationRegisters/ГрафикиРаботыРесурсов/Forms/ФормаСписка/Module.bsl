
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РесурсПредприятия") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "РесурсПредприятия",
			Параметры.РесурсПредприятия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
