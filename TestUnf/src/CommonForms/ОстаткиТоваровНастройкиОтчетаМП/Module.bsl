
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики

	ЭтаФорма.ОстаткиТоваровАртикул = НЕ Константы.ОстаткиТоваровСкрыватьАртикулМП.Получить();
	ЭтаФорма.ОстаткиТоваровСуммаЗакупки = НЕ Константы.ОстаткиТоваровСкрыватьСуммуЗакупкиМП.Получить();
	ЭтаФорма.ОстаткиТоваровСуммаПродажи = НЕ Константы.ОстаткиТоваровСкрыватьСуммуПродажиМП.Получить();
	ЭтаФорма.ОстаткиТоваровЦенаЗакупки = НЕ Константы.ОстаткиТоваровСкрыватьЦенуЗакупкиМП.Получить();
	ЭтаФорма.ОстаткиТоваровЦенаПродажи = НЕ Константы.ОстаткиТоваровСкрыватьЦенуПродажиМП.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	Константы.ОстаткиТоваровСкрыватьАртикулМП.Установить(НЕ ЭтаФорма.ОстаткиТоваровАртикул);
	Константы.ОстаткиТоваровСкрыватьСуммуЗакупкиМП.Установить(НЕ ЭтаФорма.ОстаткиТоваровСуммаЗакупки);
	Константы.ОстаткиТоваровСкрыватьСуммуПродажиМП.Установить(НЕ ЭтаФорма.ОстаткиТоваровСуммаПродажи);
	Константы.ОстаткиТоваровСкрыватьЦенуЗакупкиМП.Установить(НЕ ЭтаФорма.ОстаткиТоваровЦенаЗакупки);
	Константы.ОстаткиТоваровСкрыватьЦенуПродажиМП.Установить(НЕ ЭтаФорма.ОстаткиТоваровЦенаПродажи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	Оповестить("ОбновлениеНастроекОтчета", , ЭтаФорма);

КонецПроцедуры

#КонецОбласти