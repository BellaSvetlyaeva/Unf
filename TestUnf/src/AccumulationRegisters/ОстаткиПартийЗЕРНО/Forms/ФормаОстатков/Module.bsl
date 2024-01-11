#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// РаботаСПолямимСоставногоТипа
	СобытияФормИС.ПоляСоставногоТипаИнициализация(ЭтотОбъект, ИменаЭлементовПолейСоставногоТипа());
	// Конец РаботаСПолямимСоставногоТипа
	
	Если Параметры.РежимВыбора Тогда
		НастроитьСписокДляВыбора();
	Иначе
		УстановитьБыстрыйОтборСервер();
	КонецЕсли;
	
	НастроитьЗапросСписка();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПартииСтрокойПриИзменении(Элемент)
	
	ПолеСоставногоТипаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПартииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПолеОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойПриИзменении(Элемент)
	
	ПолеСоставногоТипаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлеваторСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПолеОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеСтрокойПриИзменении(Элемент)
	
	ПолеСоставногоТипаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеСтрокойОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПолеОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НеСопоставленныеКлючиАдресовОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СопоставитьМестоположение" Тогда
		НеСопоставленныеКлючиАдресовСтруктураОтбора(ЭтотОбъект);
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("СтруктураОтбора",
			НеСопоставленныеКлючиАдресовСтруктураОтбора(ЭтотОбъект));
		ОткрытьФорму(
			"Справочник.КлючиАдресовЗЕРНО.Форма.СопоставлениеКлючейАдресов",
			ПараметрыОткрытияФормы, ЭтотОбъект,,,,
			Новый ОписаниеОповещения("НеСопоставленныеКлючиОкончаниеРедактирования", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ДанныеДляСписка = ДанныеДляСписка(Строки);
	
	ОрганизацииКонтрагенты = ДанныеДляСписка.ОрганизацииКонтрагенты;
	Местоположения         = ДанныеДляСписка.Местоположения;
	Партии                 = ДанныеДляСписка.Партии;
	
	ЦветТребуетВнимания = ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС;
	
	Для Каждого Строка Из Строки Цикл
		
		Если Не ПустаяСтрока(Строка.Значение.Данные.НаименованиеВидаСХКультуры) Тогда
			ВидСХПродукции = СтрШаблон(НСтр("ru = '%1 (ОКПД2: %2)'"),
				Строка.Значение.Данные.НаименованиеВидаСХКультуры,
				Строка.Значение.Данные.ОКПД2);
			Оформление = Строка.Значение.Оформление.Получить("ОКПД2"); 
			Если Оформление <> Неопределено Тогда
				Оформление.УстановитьЗначениеПараметра("Текст", ВидСХПродукции);
			КонецЕсли;
		Иначе
			ВидСХПродукции = Строка.Значение.Данные.ОКПД2
		КонецЕсли;
		
		Оформление = Строка.Значение.Оформление["Партия"];
		Если Оформление <> Неопределено Тогда
			Оформление.УстановитьЗначениеПараметра(
				"Текст", Строка.Значение.Данные.ИдентификаторПартии);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.ВладелецПартии) Тогда
			Оформление = Строка.Значение.Оформление["ВладелецПартииПредставление"];
			Если Оформление <> Неопределено Тогда
				Данные = ОрганизацииКонтрагенты[Строка.Значение.Данные.ВладелецПартии];
				Если Данные = Неопределено Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", НСтр("ru = '<не сопоставлен>'"));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				ИначеЕсли Не ЗначениеЗаполнено(Данные.ОрганизацияКонтрагент) Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 <не сопоставлен>'"), Данные.КлючПредставление));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				Иначе
					Оформление.УстановитьЗначениеПараметра(
						"Текст", Данные.ОрганизацияКонтрагентПредставление);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Элеватор) Тогда
			Оформление = Строка.Значение.Оформление["ЭлеваторПредставление"];
			Если Оформление <> Неопределено Тогда
				Данные = ОрганизацииКонтрагенты[Строка.Значение.Данные.Элеватор];
				Если Данные = Неопределено Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", НСтр("ru = '<не сопоставлен>'"));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				ИначеЕсли Не ЗначениеЗаполнено(Данные.ОрганизацияКонтрагент) Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 <не сопоставлен>'"), Данные.КлючПредставление));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				Иначе
					Оформление.УстановитьЗначениеПараметра(
						"Текст", Данные.ОрганизацияКонтрагентПредставление);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Местоположение) Тогда
			Оформление = Строка.Значение.Оформление["МестоположениеПредставление"];
			Если Оформление <> Неопределено Тогда
				Данные = Местоположения[Строка.Значение.Данные.Местоположение];
				Если Данные = Неопределено Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", НСтр("ru = '<не сопоставлено>'"));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				ИначеЕсли Данные.СкладКонтрагентКоличество = 0 Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 <не сопоставлен>'"), Данные.КлючПредставление));
					Оформление.УстановитьЗначениеПараметра(
						"ЦветТекста", ЦветТребуетВнимания);
				ИначеЕсли Данные.СкладКонтрагентКоличество = 1 Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 (%2)'"),
							Данные.СкладКонтрагентПредставление,
							Данные.КлючПредставление));
				Иначе
					Оформление.УстановитьЗначениеПараметра(
						"Текст", СтрШаблон(НСтр("ru = '%1 ( + еще %2 )'"),
							Данные.СкладКонтрагентПредставление,
							Данные.СкладКонтрагентКоличество - 1));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Партия) Тогда
			Оформление = Строка.Значение.Оформление["Продукция"];
			Данные = Партии[Строка.Значение.Данные.Партия];
			Если Данные = Неопределено
				Или Не ЗначениеЗаполнено(Данные.Номенклатура) Тогда
				Если Оформление <> Неопределено Тогда
					Оформление.УстановитьЗначениеПараметра(
						"Текст", ВидСХПродукции);
				КонецЕсли;
			Иначе
				Если Не ЗначениеЗаполнено(Строка.Значение.Данные.Номенклатура) Тогда
					Строка.Значение.Данные.Номенклатура   = Данные.Номенклатура;
					Строка.Значение.Данные.Характеристика = Данные.Характеристика;
					Строка.Значение.Данные.Серия          = Данные.Серия;
				КонецЕсли;
				Если Оформление <> Неопределено Тогда
					Если Данные.Количество > 1 Тогда
						Оформление.УстановитьЗначениеПараметра(
							"Текст", СтрШаблон(НСтр("ru = '%1 ( + еще %2 )'"),
								Данные.Представление,
								Данные.Количество - 1));
					Иначе
						Оформление.УстановитьЗначениеПараметра(
							"Текст", Данные.Представление);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора
		Или ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если Поле.Имя = "СписокМестоположениеПредставление" Тогда
		Если ЗначениеЗаполнено(ДанныеСтроки.Местоположение) Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ДанныеСтроки.Местоположение);
			
			ОткрытьФорму("Справочник.КлючиАдресовЗЕРНО.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект,,,,
				Новый ОписаниеОповещения("МестоположениеОкончаниеРедактирования", ЭтотОбъект),
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "СписокПартия" Или Поле.Имя = "СписокПродукция" Тогда
		Если ЗначениеЗаполнено(ДанныеСтроки.Партия) Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ДанныеСтроки.Партия);
			
			ОткрытьФорму("Справочник.РеестрПартийЗЕРНО.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект,,,,
				Новый ОписаниеОповещения("ПартияОкончаниеРедактирования", ЭтотОбъект),
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.Список, Истина) Тогда
		ОповеститьОВыборе(ИнтеграцияЗЕРНОКлиентСервер.РезультатВыбораПартииЗЕРНО(Элементы.Список.ТекущиеДанные));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьПартию(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеПартии = Новый Массив;
	
	Для каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		Если ТипЗнч(СтрокаСписка) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ДанныеСтроки = Элементы.Список.ДанныеСтроки(СтрокаСписка);
			ВыбранныеПартии.Добавить(ДанныеСтроки.Партия);
		КонецЕсли;
	КонецЦикла;
	
	Если ВыбранныеПартии.Количество() > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ВыбранныеПартии);
		
		ОткрытьФорму("Документ.ФормированиеПартийИзДругихПартийЗЕРНО.ФормаОбъекта", ПараметрыФормы);
		
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьПартии(Команда)
	
	ЗапросСДИЗЗавершение = Новый ОписаниеОповещения("ЗапросПартийЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = ИнтеграцияЗЕРНОСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаСправочника();
	ПараметрыФормы.ВидЗапроса     = 2;
	ПараметрыФормы.ТипЗапроса     = "Партии";
	ПараметрыФормы.СсылкаНаОбъект = ПредопределенноеЗначение("Справочник.РеестрПартийЗЕРНО.ПустаяСсылка");
	
	Если ВладелецПартииСписок.Количество() > 0 Тогда
		ПараметрыФормы.Организация = ОрганизацияИзСписка(ВладелецПартииСписок);
	ИначеЕсли ЭлеваторСписок.Количество() > 0 Тогда
		ПараметрыФормы.Организация = ОрганизацияИзСписка(ЭлеваторСписок);
	КонецЕсли;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуЗапросаСправочника(ПараметрыФормы, ЭтотОбъект, ЗапросСДИЗЗавершение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СписокСтатусов = Новый СписокЗначений();
	СписокСтатусов.Добавить(Перечисления.СтатусыПартийЗЕРНО.Аннулировано);
	СписокСтатусов.Добавить(Перечисления.СтатусыПартийЗЕРНО.ВАрхиве);
	СписокСтатусов.Добавить(Перечисления.СтатусыПартийЗЕРНО.Заблокировано);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗапросСписка()
	
	Если Элементы.Список.РежимВыбора
		И Параметры.Свойство("Номенклатура")
		И ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		ТекстУсловия = "Остатки.Партия = СоответствиеПартий.Партия";
	Иначе
		ТекстУсловия = "ЛОЖЬ";
	КонецЕсли;
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "&УсловиеСоответствиеПартий", ТекстУсловия);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокДляВыбора()
	
	Элементы.Список.РежимВыбора = Истина;
	Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Одиночный;
	
	Элементы.ВладелецПартииСтрокой.ТолькоПросмотр = Истина;
	Элементы.ЭлеваторСтрокой.ТолькоПросмотр       = Истина;
	Элементы.МестоположениеСтрокой.ТолькоПросмотр = Истина;
	
	Элементы.НеСопоставленныеКлючиАдресов.Видимость = Ложь;
	
	Элементы.ФормаСформироватьПартию.Видимость = Ложь;
	
	НастроитьОтборСпискаДляВыбора();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтборСпискаДляВыбора()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Статус", Перечисления.СтатусыПартийЗЕРНО.Подписано, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	Если Параметры.ЭтоЭкспорт <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ЭтоЭкспорт", Параметры.ЭтоЭкспорт, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияВладелецПартии) Тогда
		ВладелецПартии = Параметры.ОрганизацияВладелецПартии;
		Подразделение = Параметры.ПодразделениеВладелецПартии;
		ПриИзмененииОтбора(ЭтотОбъект, "ВладелецПартии", Истина, Ложь);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияЭлеватор) Тогда
		Элеватор = Параметры.ОрганизацияЭлеватор;
		ПриИзмененииОтбора(ЭтотОбъект, "Элеватор", Истина, Ложь);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Грузоотправитель) Тогда
		Местоположение = Параметры.Грузоотправитель;
		ПриИзмененииОтбора(ЭтотОбъект, "Местоположение", Истина, Ложь);
	ИначеЕсли ЗначениеЗаполнено(Параметры.Местоположение) Тогда
		МестоположениеКлючи.Добавить(Параметры.Местоположение);
		МестоположениеСписок.ЗагрузитьЗначения(МестоположенияПоКлючам(МестоположениеКлючи.ВыгрузитьЗначения()));
		Если МестоположениеСписок.Количество() = 0 Тогда
			МестоположениеСписок.Добавить();
		КонецЕсли;
		ПриИзмененииОтбора(ЭтотОбъект, "МестоположениеСписок", Ложь, Ложь);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ВидПродукции) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ВидПродукции", Параметры.ВидПродукции, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
	ЗаполненоОКПД2 = ЗначениеЗаполнено(Параметры.ОКПД2); 
	
	Если ЗаполненоОКПД2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ОКПД2", Параметры.ОКПД2, ВидСравненияКомпоновкиДанных.НачинаетсяС,, Истина);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ДоступныйОстаток", 0, ВидСравненияКомпоновкиДанных.Больше,, Истина);
	
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		
		Если ЗаполненоОКПД2 Тогда
			Массив = ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("Номенклатура");
		Иначе
			Массив = Новый Массив;
		КонецЕсли;
		
		Массив.Добавить(Параметры.Номенклатура);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Номенклатура", Массив, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
		Если ЗначениеЗаполнено(Параметры.Характеристика) Тогда
			
			Если ЗаполненоОКПД2 Тогда
				Массив = ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("ХарактеристикаНоменклатуры");
			Иначе
				Массив = Новый Массив;
			КонецЕсли;
			
			Массив.Добавить(Параметры.Характеристика);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
				"Характеристика", Массив, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.Серия) Тогда
			Массив = ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатуры");
			Массив.Добавить(Параметры.Серия);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
				"Серия", Массив, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Организации = Неопределено;
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			
			Ключи = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(
				Организации.ВыгрузитьЗначения());
			
			КоличествоКлючей = Ключи.Количество();
			
			Если КоличествоКлючей > 0 Тогда
				
				МассивЭлеваторов = ЭлеваторыПоКлючам(Ключи);
				
				КоличествоЭлеваторов = МассивЭлеваторов.Количество();
				Если КоличествоЭлеваторов > 0 И КоличествоЭлеваторов = КоличествоКлючей Тогда
					ЭлеваторСписок = Организации;
					ЭлеваторКлючи.ЗагрузитьЗначения(Ключи);
					ПриИзмененииОтбора(ЭтотОбъект, "ЭлеваторСписок", Ложь, Ложь);
				Иначе
					ВладелецПартииСписок = Организации;
					ВладелецПартииКлючи.ЗагрузитьЗначения(Ключи);
					ПриИзмененииОтбора(ЭтотОбъект, "ВладелецПартииСписок", Ложь, Ложь);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьНадписьНеСопоставленныеКлючиАдресов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииОтбора(Форма, Имя, ОбновлятьКлючи = Истина, ОбновлятьНадписьКлючиАдресов = Истина)
	
	Если Прав(Имя, 6) = "Список" Тогда
		
		ИмяЭлементаОтбора        = Лев(Имя, СтрДлина(Имя) - 6);
		ИмяЭлементаОтбораСписок  = Имя;
		ИмяЭлементаОтбораСтрокой = СтрШаблон("%1Строкой", ИмяЭлементаОтбора);
		
		Форма[ИмяЭлементаОтбора]        = Неопределено;
		Форма[ИмяЭлементаОтбораСтрокой] = Строка(Форма[ИмяЭлементаОтбораСписок]);
		
	ИначеЕсли Прав(Имя, 7) = "Строкой" Тогда
		
		ИмяЭлементаОтбора        = Лев(Имя, СтрДлина(Имя) - 7);;
		ИмяЭлементаОтбораСписок  = СтрШаблон("%1Список", ИмяЭлементаОтбора);
		ИмяЭлементаОтбораСтрокой = Имя;
		
		Форма[ИмяЭлементаОтбораСписок].Очистить();
		Если ЗначениеЗаполнено(Форма[ИмяЭлементаОтбора]) Тогда
			Форма[ИмяЭлементаОтбораСписок].Добавить(Форма[ИмяЭлементаОтбора]);
		КонецЕсли;
		
	Иначе
		
		ИмяЭлементаОтбора        = Имя;
		ИмяЭлементаОтбораСписок  = СтрШаблон("%1Список", ИмяЭлементаОтбора);
		ИмяЭлементаОтбораСтрокой = СтрШаблон("%1Строкой", ИмяЭлементаОтбора);
		
		Форма[ИмяЭлементаОтбораСписок].Очистить();
		Если ЗначениеЗаполнено(Форма[ИмяЭлементаОтбора]) Тогда
			Форма[ИмяЭлементаОтбораСписок].Добавить(Форма[ИмяЭлементаОтбора]);
		КонецЕсли;
		Форма[ИмяЭлементаОтбораСтрокой] = Строка(Форма[ИмяЭлементаОтбора]);
		
	КонецЕсли;
	
	ИмяЭлементаОтбораКлючи = СтрШаблон("%1Ключи", ИмяЭлементаОтбора);
	
	Форма.Элементы[ИмяЭлементаОтбораСтрокой].РедактированиеТекста = Форма[ИмяЭлементаОтбораСписок].Количество() < 2;
	
	Если ОбновлятьКлючи Тогда
		Если ИмяЭлементаОтбора = "ВладелецПартии" Тогда
			Форма[ИмяЭлементаОтбораКлючи].ЗагрузитьЗначения(
				КлючиДляОтбора(Форма[ИмяЭлементаОтбораСписок].ВыгрузитьЗначения(), Форма.Подразделение, ИмяЭлементаОтбора));
		Иначе
			Форма[ИмяЭлементаОтбораКлючи].ЗагрузитьЗначения(
				КлючиДляОтбора(Форма[ИмяЭлементаОтбораСписок].ВыгрузитьЗначения(),, ИмяЭлементаОтбора));
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, ИмяЭлементаОтбора, Форма[ИмяЭлементаОтбораКлючи],
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Форма[ИмяЭлементаОтбораСписок].Количество() > 0);

	Если ОбновлятьНадписьКлючиАдресов Тогда
		ОбновитьНадписьНеСопоставленныеКлючиАдресов(Форма);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьНеСопоставленныеКлючиАдресов(Форма)
	
	КлючиАдресов = НеСопоставленныеКлючиАдресов(
		НеСопоставленныеКлючиАдресовСтруктураОтбора(Форма));
	
	КоличествоКлючей = КлючиАдресов.Количество();
	
	Если КоличествоКлючей > 0 Тогда
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(
			НСтр("ru = 'На остатках имеются партии с несопоставленным местоположением.'"));
		МассивСтрок.Добавить(" ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru = 'Сопоставить (%1)'"), КоличествоКлючей),,,,
			"СопоставитьМестоположение"));
		ФорматированнаяСтрока = Новый ФорматированнаяСтрока(МассивСтрок);
	Иначе
		ФорматированнаяСтрока = "";
	КонецЕсли;
	
	Форма.НеСопоставленныеКлючиАдресов = ФорматированнаяСтрока;
	Форма.Элементы.НеСопоставленныеКлючиАдресов.Видимость = КоличествоКлючей > 0;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НеСопоставленныеКлючиАдресовСтруктураОтбора(Форма)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВладелецПартии", Форма.ВладелецПартииКлючи);
	Отбор.Вставить("Элеватор",       Форма.ЭлеваторКлючи);
	Отбор.Вставить("Местоположение", Форма.МестоположениеКлючи);
	
	Возврат Отбор;
	
КонецФункции

&НаСервереБезКонтекста
Функция НеСопоставленныеКлючиАдресов(Отбор)
	
	Возврат ИнтеграцияЗЕРНО.НеСопоставленныеКлючиАдресов(Отбор);
	
КонецФункции

&НаСервереБезКонтекста
Функция КлючиДляОтбора(Знач ДанныеДляОтбора, Знач Подразделение = Неопределено, Знач ИмяЭлементаОтбора)
	
	Если ИмяЭлементаОтбора = "ВладелецПартии" Тогда
		
		ТаблицаИсточникиРеквизитов = ИнтеграцияЗЕРНО.НоваяТаблицаОрганизацияКонтрагентПодразделение();
		Для Каждого ЭлементОрганизация Из ДанныеДляОтбора Цикл
			ИнтеграцияЗЕРНО.ДобавитьВТаблицуОтбораОрганизациюПодразделение(
				ТаблицаИсточникиРеквизитов, ЭлементОрганизация, Подразделение);
		КонецЦикла;
		
		Возврат Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(ТаблицаИсточникиРеквизитов);
		
	ИначеЕсли ИмяЭлементаОтбора = "Элеватор" Тогда
		
		Возврат Справочники.КлючиРеквизитовОрганизацийЗЕРНО.КлючиПоОрганизациямКонтрагентам(ДанныеДляОтбора);
		
	ИначеЕсли ИмяЭлементаОтбора = "Местоположение" Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Местоположение", ДанныеДляОтбора);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КлючиАдресовОператорыАдреса.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КлючиАдресовЗЕРНО.ОператорыАдреса КАК КлючиАдресовОператорыАдреса
		|ГДЕ
		|	КлючиАдресовОператорыАдреса.СкладКонтрагент В (&Местоположение)";
		
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		 
	КонецЕсли;
	
	Возврат Новый Массив;
	
КонецФункции

&НаСервереБезКонтекста
Функция МестоположенияПоКлючам(Ключи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ключи", Ключи);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КлючиАдресовОператорыАдреса.СкладКонтрагент КАК СкладКонтрагент
	|ИЗ
	|	Справочник.КлючиАдресовЗЕРНО.ОператорыАдреса КАК КлючиАдресовОператорыАдреса
	|ГДЕ
	|	КлючиАдресовОператорыАдреса.Ссылка В (&Ключи)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СкладКонтрагент");
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭлеваторыПоКлючам(Ключи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ключи", Ключи);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КлючиРеквизитовОрганизаций.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлючиРеквизитовОрганизацийЗЕРНО КАК КлючиРеквизитовОрганизаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РеестрЭлеваторовЗЕРНО КАК РеестрЭлеваторов
	|		ПО КлючиРеквизитовОрганизаций.ИНН = РеестрЭлеваторов.ИНН
	|		И КлючиРеквизитовОрганизаций.КПП = РеестрЭлеваторов.КПП
	|ГДЕ
	|	КлючиРеквизитовОрганизаций.Ссылка В (&Ключи)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура ЗапросПартийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура МестоположениеОкончаниеРедактирования(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
	ОбновитьНадписьНеСопоставленныеКлючиАдресов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПартияОкончаниеРедактирования(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура НеСопоставленныеКлючиОкончаниеРедактирования(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
	ОбновитьНадписьНеСопоставленныеКлючиАдресов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ОрганизацияИзСписка(СписокЗначений)
	
	ТипЗнчОрганизация = ТипЗнч(Организация);
	
	Для Каждого ЭлементСписка Из СписокЗначений Цикл
		Если ТипЗнч(ЭлементСписка.Значение) = ТипЗнчОрганизация Тогда
			Возврат СписокЗначений[0].Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ПолеОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяЭлементаОтбора = Лев(Элемент.Имя, СтрДлина(Элемент.Имя) - 7);
	ИмяЭлементаОтбораСписок = СтрШаблон("%1Список", ИмяЭлементаОтбора);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВыбранныеЗначения", ЭтотОбъект[ИмяЭлементаОтбораСписок].ВыгрузитьЗначения());
	ПараметрыОткрытия.Вставить("ИмяЭлементаОтбора", ИмяЭлементаОтбора);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаОтбора", ИмяЭлементаОтбора);
	
	ОткрытьФорму("РегистрНакопления.ОстаткиПартийЗЕРНО.Форма.ФормаВыбораЗначений", ПараметрыОткрытия, ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПолеОтбораОкончаниеВыбора", ЭтотОбъект, ДополнительныеПараметры),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОтбораОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЭлементаОтбораСписок = СтрШаблон("%1Список", ДополнительныеПараметры.ИмяЭлементаОтбора);
	ЭтотОбъект[ИмяЭлементаОтбораСписок].ЗагрузитьЗначения(Результат);
	ПриИзмененииОтбора(ЭтотОбъект, ИмяЭлементаОтбораСписок);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеДляСписка(Строки)
	
	ДанныеДляСписка = Новый Структура;
	ДанныеДляСписка.Вставить("ОрганизацииКонтрагенты", Новый Соответствие);
	ДанныеДляСписка.Вставить("Местоположения",         Новый Соответствие);
	ДанныеДляСписка.Вставить("Партии",                 Новый Соответствие);
	
	Ключи        = Новый Массив;
	КлючиАдресов = Новый Массив;
	Партии       = Новый Массив;
	
	Для Каждого Строка Из Строки Цикл
		Если ЗначениеЗаполнено(Строка.Значение.Данные.ВладелецПартии) Тогда
			Если Ключи.Найти(Строка.Значение.Данные.ВладелецПартии) = Неопределено Тогда
				Ключи.Добавить(Строка.Значение.Данные.ВладелецПартии);
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Элеватор) Тогда
			Если Ключи.Найти(Строка.Значение.Данные.Элеватор) = Неопределено Тогда
				Ключи.Добавить(Строка.Значение.Данные.Элеватор);
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Местоположение) Тогда
			Если КлючиАдресов.Найти(Строка.Значение.Данные.Местоположение) = Неопределено Тогда
				КлючиАдресов.Добавить(Строка.Значение.Данные.Местоположение);
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Строка.Значение.Данные.Партия) Тогда
			Если Партии.Найти(Строка.Значение.Данные.Партия) = Неопределено Тогда
				Партии.Добавить(Строка.Значение.Данные.Партия);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ОрганизацииКонтрагенты = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.ОрганизацииКонтрагентыПоКлючам(Ключи);
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Ключ",                  Новый ОписаниеТипов("СправочникСсылка.КлючиРеквизитовОрганизацийЗЕРНО"));
	Таблица.Колонки.Добавить("ОрганизацияКонтрагент", Метаданные.ОпределяемыеТипы.ОрганизацияКонтрагентГосИС.Тип);
	Таблица.Колонки.Добавить("Подразделение",         Метаданные.ОпределяемыеТипы.Подразделение.Тип);
	Таблица.Колонки.Добавить("ЭтоОрганизация",        Новый ОписаниеТипов("Булево"));
	
	Для Каждого КлючИЗначение Из ОрганизацииКонтрагенты Цикл
		Строка = Таблица.Добавить();
		Строка.Ключ = КлючИЗначение.Ключ;
		Если ЗначениеЗаполнено(КлючИЗначение.Значение.Организация) Тогда
			Строка.ОрганизацияКонтрагент = КлючИЗначение.Значение.Организация;
			Строка.Подразделение         = КлючИЗначение.Значение.Подразделение;
			Строка.ЭтоОрганизация        = Истина;
		ИначеЕсли ЗначениеЗаполнено(КлючИЗначение.Значение.Контрагент) Тогда
			Строка.ОрганизацияКонтрагент = КлючИЗначение.Значение.Контрагент;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица",      Таблица);
	Запрос.УстановитьПараметр("КлючиАдресов", КлючиАдресов);
	Запрос.УстановитьПараметр("Партии",       Партии);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Ключ,
	|	Таблица.ОрганизацияКонтрагент,
	|	Таблица.Подразделение,
	|	Таблица.ЭтоОрганизация
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ключ,
	|	ПРЕДСТАВЛЕНИЕ(Таблица.Ключ) КАК КлючПредставление,
	|	Таблица.ОрганизацияКонтрагент,
	|	Таблица.Подразделение,
	|	ПРЕДСТАВЛЕНИЕ(Таблица.ОрганизацияКонтрагент) КАК ОрганизацияКонтрагентПредставление,
	|	Таблица.ЭтоОрганизация
	|ИЗ
	|	Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлючиАдресов.Ссылка КАК Ключ,
	|	ПРЕДСТАВЛЕНИЕ(КлючиАдресов.Ссылка) КАК КлючПредставление,
	|	ПРЕДСТАВЛЕНИЕ(КлючиАдресовОператорыАдресаПервые.СкладКонтрагент) КАК СкладКонтрагентПредставление,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КлючиАдресовОператорыАдреса.СкладКонтрагент) КАК СкладКонтрагентКоличество
	|ИЗ
	|	Справочник.КлючиАдресовЗЕРНО КАК КлючиАдресов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАдресовЗЕРНО.ОператорыАдреса КАК КлючиАдресовОператорыАдреса
	|		ПО КлючиАдресов.Ссылка = КлючиАдресовОператорыАдреса.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАдресовЗЕРНО.ОператорыАдреса КАК КлючиАдресовОператорыАдресаПервые
	|		ПО КлючиАдресов.Ссылка = КлючиАдресовОператорыАдресаПервые.Ссылка
	|		И КлючиАдресовОператорыАдресаПервые.НомерСтроки = 1
	|ГДЕ
	|	КлючиАдресов.Ссылка В (&КлючиАдресов)
	|СГРУППИРОВАТЬ ПО
	|	КлючиАдресов.Ссылка,
	|	КлючиАдресовОператорыАдресаПервые.СкладКонтрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлючиПартийЗЕРНО.Партия КАК Партия,
	|	СоответствиеПартийЗЕРНО.Номенклатура КАК Номенклатура,
	|	СоответствиеПартийЗЕРНО.Характеристика КАК Характеристика,
	|	СоответствиеПартийЗЕРНО.Серия КАК Серия,
	|	ПРЕДСТАВЛЕНИЕ(СоответствиеПартийЗЕРНО.Номенклатура) КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(СоответствиеПартийЗЕРНО.Характеристика) КАК ХарактеристикаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(СоответствиеПартийЗЕРНО.Серия) КАК СерияПредставление
	|ИЗ
	|	РегистрСведений.КлючиПартийЗЕРНО КАК КлючиПартийЗЕРНО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеПартийЗЕРНО КАК СоответствиеПартийЗЕРНО
	|		ПО СоответствиеПартийЗЕРНО.Партия = КлючиПартийЗЕРНО.Партия
	|ГДЕ
	|	КлючиПартийЗЕРНО.Партия В (&Партии)";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВГраница = РезультатЗапроса.ВГраница();
	
	Выборка = РезультатЗапроса[ВГраница - 2].Выбрать();
	Пока Выборка.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("КлючПредставление",                  Выборка.КлючПредставление);
		Данные.Вставить("ОрганизацияКонтрагент",              Выборка.ОрганизацияКонтрагент);
		Данные.Вставить("Подразделение",                      Выборка.Подразделение);
		Данные.Вставить("ОрганизацияКонтрагентПредставление", Выборка.ОрганизацияКонтрагентПредставление);
		Данные.Вставить("ЭтоОрганизация",                     Выборка.ЭтоОрганизация);
		ДанныеДляСписка.ОрганизацииКонтрагенты.Вставить(Выборка.Ключ, Данные);
	КонецЦикла;
	
	Выборка = РезультатЗапроса[ВГраница - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("КлючПредставление",            Выборка.КлючПредставление);
		Данные.Вставить("СкладКонтрагентПредставление", Выборка.СкладКонтрагентПредставление);
		Данные.Вставить("СкладКонтрагентКоличество",    Выборка.СкладКонтрагентКоличество);
		ДанныеДляСписка.Местоположения.Вставить(Выборка.Ключ, Данные);
	КонецЦикла;
	
	Выборка = РезультатЗапроса[ВГраница].Выбрать();
	Пока Выборка.Следующий() Цикл
		Данные = ДанныеДляСписка.Партии[Выборка.Партия];
		Если Данные = Неопределено Тогда
			Данные = Новый Структура;
			Данные.Вставить("Номенклатура",   Выборка.Номенклатура);
			Данные.Вставить("Характеристика", Выборка.Характеристика);
			Данные.Вставить("Серия",          Выборка.Серия);
			Данные.Вставить("Количество",     1);
			Если ЗначениеЗаполнено(Данные.Номенклатура) Тогда
				Данные.Вставить("Представление",  ПредставлениеНоменклатуры(
					Выборка.НоменклатураПредставление,
					Выборка.ХарактеристикаПредставление,
					Выборка.СерияПредставление));
			Иначе
				Данные.Вставить("Представление", "");
			КонецЕсли;
			ДанныеДляСписка.Партии.Вставить(Выборка.Партия, Данные);
		Иначе
			Данные.Количество = Данные.Количество + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеДляСписка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеНоменклатуры(НоменклатураПредставление, ХарактеристикаПредставление, СерияПредставление)
	
	Массив = Новый Массив;
	
	Если Не ПустаяСтрока(НоменклатураПредставление) Тогда
		Массив.Добавить(НоменклатураПредставление);
	КонецЕсли;
	Если Не ПустаяСтрока(ХарактеристикаПредставление) Тогда
		Массив.Добавить(ХарактеристикаПредставление);
	КонецЕсли;
	Если Не ПустаяСтрока(СерияПредставление) Тогда
		Массив.Добавить(СерияПредставление);
	КонецЕсли;
	
	Возврат СтрСоединить(Массив, ", ");
	
КонецФункции

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСПолямимСоставногоТипа

&НаКлиенте
Процедура ПолеСоставногоТипаПриИзменении(Элемент)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаПриИзменении(ЭтотОбъект, Элемент);
	
	ПриИзмененииОтбора(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
	ПриИзмененииОтбора(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЭтотОбъект[СтрЗаменить(Элемент.Имя, "Строкой", "Список")].Количество() > 1 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиент.ПолеСоставногоТипаАвтоПодбор(ЭтотОбъект,
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСоставногоТипаОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	СобытияФормИСКлиент.ПолеСоставногоТипаОкончаниеВыбора(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
	ПриИзмененииОтбора(ЭтотОбъект, ДополнительныеПараметры.Элемент.Имя);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИменаЭлементовПолейСоставногоТипа()
	
	Возврат "ВладелецПартииСтрокой,ЭлеваторСтрокой,МестоположениеСтрокой";
	
КонецФункции

#КонецОбласти

#КонецОбласти
