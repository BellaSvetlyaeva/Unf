#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДоступныеВидыПродукцииИС = ИнтеграцияИСКлиентСервер.ВидыПродукцииИСМП();
	СобытияФормИСМП.НастроитьВидПродукцииПриСозданииНаСервере(ЭтотОбъект, ДоступныеВидыПродукцииИС);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элементы.Организация.ПодсказкаВвода = "<для всех организаций>";

КонецПроцедуры

#КонецОбласти
