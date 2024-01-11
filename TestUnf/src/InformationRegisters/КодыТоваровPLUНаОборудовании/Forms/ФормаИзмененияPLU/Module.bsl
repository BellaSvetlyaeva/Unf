
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПараметрыСозданияPLU") Тогда
		
		Запись.КодТовараSKU  = Параметры.ПараметрыСозданияPLU.КодSKU;
		Запись.ПравилоОбмена = Параметры.ПараметрыСозданияPLU.ПравилоОбмена;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	БылаЗапись = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если БылаЗапись Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрЗакрытия = Новый Структура;
		ПараметрЗакрытия.Вставить("КодТовараPLU", Запись.КодТовараPLU);
		Закрыть(ПараметрЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


