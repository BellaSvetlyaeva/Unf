
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ШаблонСтроки = НСтр("ru = 'Выписки банка с %1 по %2'");
	Заголовок = СтрШаблон(ШаблонСтроки, 
		Формат(Параметры.НачалоПериода, "ДФ=dd.MM.yyyy"), Формат(Параметры.КонецПериода, "ДФ=dd.MM.yyyy"));
	Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", Параметры.ВыпискиБанка.ВыгрузитьЗначения());	
	
КонецПроцедуры // ПодготовитьФормуНаСервере()

&НаСервереБезКонтекста
Функция ФайлДанныхЭД(СсылкаНаЭД)
	
	Возврат ОбменСБанками.ФормаПросмотраЭД(СсылкаНаЭД);
	
КонецФункции

&НаКлиенте
Процедура ВыпискиБанкаПриАктивизацииСтроки(Элемент)
	
	ТабличныйДокумент = ФайлДанныхЭД(Элементы.ВыпискиБанка.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьЭД(Команда)
	
	ПоказатьЗначение(, Элементы.ВыпискиБанка.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти
