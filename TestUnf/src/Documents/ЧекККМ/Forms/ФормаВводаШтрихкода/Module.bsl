#Область ПроцедурыОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	Если ИспользоватьПодключаемоеОборудование Тогда
		ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
		ТипыОборудования.СканерШтрихкода = Истина;
		МенеджерОборудования.ПриСозданииНаСервере(ЭтотОбъект, ТипыОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() И ИмяСобытия = "ScanData" Тогда
		
		Данные = Новый Массив();
		Если Параметр[1] = Неопределено Тогда
			Штрихкод = Параметр[0];
		Иначе
			Штрихкод = Параметр[1][1];
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ПослеВводаШтрихкода", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ШтрихкодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПодключитьОбработчикОжидания("ПослеВводаШтрихкода", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедураОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Отмена Тогда
		
		Закрыть();
		
	Иначе
		
		Результат = Новый Структура;
		Результат.Вставить("Штрихкод", Штрихкод);
		Результат.Вставить("РежимУдаления", Элементы.РежимУдаления.Пометка);
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если ЗначениеЗаполнено(Штрихкод) Тогда
		Отмена = Истина;
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимУдаления(Команда)
	
	Элементы.РежимУдаления.Пометка = Не Элементы.РежимУдаления.Пометка;
	ТекущийЭлемент = Элементы.Штрихкод;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВводаШтрихкода()
	
	ОК(Команды.Найти("ОК"));
	
КонецПроцедуры

#КонецОбласти