#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьРеквизитыПоПараметрам();
	
	БылиВнесеныИзменения = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПроверитьМодифицированностьФормы();
	
	СтруктураРеквизитовФормы = Новый Структура;
	
	СтруктураРеквизитовФормы.Вставить("БылиВнесеныИзменения", БылиВнесеныИзменения);
	
	СтруктураРеквизитовФормы.Вставить("КратностьДня", КратностьДня);
	
	Закрыть(СтруктураРеквизитовФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизитыПоПараметрам()
	
	Если Параметры.Свойство("КратностьДня") Тогда
		КратностьДня = Параметры.КратностьДня;
		КратностьДняПриОткрытии = Параметры.КратностьДня;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьМодифицированностьФормы()
	
	БылиВнесеныИзменения = Ложь;
	
	ИзмененияКратностьДня = КратностьДняПриОткрытии <> КратностьДня;
	
	Если ИзмененияКратностьДня Тогда
		БылиВнесеныИзменения = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
