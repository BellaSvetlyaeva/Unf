

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовУведомлений.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	Если Параметры.Свойство("Основание") Тогда
		Основание           = Параметры.Основание;
	КонецЕсли;
	Если Параметры.Свойство("Ключ") Тогда
		Ключ 				= Параметры.Ключ;
	КонецЕсли;
	Если Параметры.Свойство("ИзменитьВидУведомления") Тогда
		ИзменитьВидУведомления = Истина;
	КонецЕсли;
	
	ФормыДокумента   = Новый ФиксированноеСоответствие(
		Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ПолучитьСоответствиеВидовУведомленийФормам());
		
	ВидыУведомлений = ПолучитьСписокВидовУведомлений();
	Для Каждого ВидУведомления Из ВидыУведомлений Цикл
		НоваяСтрока = СписокВидовУведомлений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВидУведомления);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидУведомления") Тогда
		ВидУведомленияПриОткрытии = Параметры.ВидУведомления;
		ВыделенныйЭлементСписка = СписокВидовУведомлений.НайтиПоЗначению(ВидУведомленияПриОткрытии);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовУведомлений.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовУведомлений()

	СписокВидовУведомлений = Новый СписокЗначений;
	ВидыУведомлений = ПрослеживаемостьБРУ.ВидыУведомлений();
	
	СписокВидовУведомлений.Добавить(ВидыУведомлений.Уведомление, НСтр("ru = 'Уведомление о ввозе прослеживаемых товаров'"));
	СписокВидовУведомлений.Добавить(ВидыУведомлений.КорректировочноеУведомление, НСтр("ru = 'Корректировочное уведомление о ввозе прослеживаемых товаров'"));
	
	Возврат СписокВидовУведомлений;

КонецФункции

&НаКлиенте
Процедура СписокВидовУведомленийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовУведомлений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидУведомления)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура();
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидУведомления", ВыбранныйВидУведомления);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание", Основание);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Ключ);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	Если ИзменитьВидУведомления И ВыбранныйВидУведомления <> ВидУведомленияПриОткрытии Тогда
		СтруктураПараметров.Вставить("ИзменитьВидУведомления", ИзменитьВидУведомления);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	Если ВыбранныйВидУведомления = "КорректировочноеУведомлениеОВввозе" Тогда
		
		КлючеваяОперация = "СоздатьФормыДокументаКорректировочная";
	Иначе
		КлючеваяОперация = "СозданиеФормыДокументаОсновная";
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	Если ФормыДокумента[ВыбранныйВидУведомления] = "ФормаДокументаКорректировочная"
		И НЕ ЗначениеЗаполнено(Основание) Тогда
		
		ОткрытьФорму("Документ.УведомлениеОВвозеПрослеживаемыхТоваров.Форма." + "ФормаПодбора", СтруктураПараметров, ВладелецФормы);
		
	Иначе
		
		ОткрытьФорму("Документ.УведомлениеОВвозеПрослеживаемыхТоваров.Форма." + ФормыДокумента[ВыбранныйВидУведомления], СтруктураПараметров, ВладелецФормы);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
