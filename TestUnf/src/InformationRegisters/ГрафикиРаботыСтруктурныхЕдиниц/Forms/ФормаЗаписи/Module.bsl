
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ГрафикРаботы") Тогда
		Запись.ГрафикРаботы = Параметры.ГрафикРаботы;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
