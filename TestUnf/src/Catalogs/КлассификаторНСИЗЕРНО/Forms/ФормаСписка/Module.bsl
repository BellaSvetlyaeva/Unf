#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидКлассификатора = Параметры.ВидКлассификатора;
	
	Если ЗначениеЗаполнено(ВидКлассификатора) Тогда
		Заголовок = СтрШаблон(НСтр("ru = 'Классификатор НСИ ""%1""'"), ВидКлассификатора);
		Элементы.СписокЗагрузитьКлассификаторы.Заголовок = НСтр("ru = 'Загрузить классификатор из ФГИС ""Зерно""'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВидКлассификатора", ВидКлассификатора);
	Иначе
		Заголовок = НСтр("ru = 'Классификатор НСИ (Все классификаторы)'");
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьКлассификаторы(Команда)
	
	ЗапросКлассификаторовЗавершение = Новый ОписаниеОповещения("Подключаемый_ЗапросКлассификаторовЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = ИнтеграцияЗЕРНОСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаСправочника();
	ПараметрыФормы.ТипЗапроса     = "Классификаторы";
	ПараметрыФормы.СсылкаНаОбъект = ВидКлассификатора;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуЗапросаСправочника(ПараметрыФормы, ЭтотОбъект, ЗапросКлассификаторовЗавершение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если ВидКлассификатора = Перечисления.ВидыКлассификаторовЗЕРНО.ОКПД2
		Или Не ЗначениеЗаполнено(ВидКлассификатора) Тогда
		Элементы.ВидПродукции.Видимость = Истина;
	Иначе
		Элементы.ВидПродукции.Видимость = Ложь;
	КонецЕсли;
	
	Если ВидКлассификатора = Перечисления.ВидыКлассификаторовЗЕРНО.ПотребительскоеСвойство
		Или Не ЗначениеЗаполнено(ВидКлассификатора) Тогда
		Элементы.ЕдиницаИзмерения.Видимость = Истина;
	Иначе
		Элементы.ЕдиницаИзмерения.Видимость = Ложь;
	КонецЕсли;
	
	Если ВидКлассификатора = Перечисления.ВидыКлассификаторовЗЕРНО.ЕдиницаИзмерения
		Или Не ЗначениеЗаполнено(ВидКлассификатора) Тогда
		Элементы.УсловноеОбозначение.Видимость = Истина;
	Иначе
		Элементы.УсловноеОбозначение.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СписокЗагрузитьКлассификаторы.Видимость = ИнтеграцияЗЕРНО.ДоступнаЗагрузкаКлассификаторов();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапросКлассификаторовЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Элементы.Список.Обновить();

КонецПроцедуры

#КонецОбласти