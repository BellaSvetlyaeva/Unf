
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщегоНазначенияБЭДКлиент.ЗаблокироватьОткрытиеФормыНаМобильномКлиенте(Отказ);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СостояниеПодробное = ЭлектронныеДокументыЭДО.СостояниеДокументаПодробное(Объект.Ссылка);
	
	СостояниеЭДО = СостояниеПодробное.Значение;
	
	Элементы.СостояниеЭДО.РасширеннаяПодсказка.Заголовок = СостояниеПодробное.Комментарий;
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТолькоПросмотр = Истина;
	
	Элементы.ОбратныйАдрес.Видимость = ЗначениеЗаполнено(Объект.СпособОбмена)
		И СинхронизацияЭДО.ЭтоПрямойОбмен(Объект.СпособОбмена);
	
	Элементы.ДоговорКонтрагента.Видимость = ИнтеграцияЭДО.ИспользуютсяДоговорыКонтрагентов();
	
КонецПроцедуры


#КонецОбласти

