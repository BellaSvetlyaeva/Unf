#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидПродукции = Параметры.ВидПродукции;
	РежимВыбора  = Параметры.РежимВыбора;
	
	ЗаполнитьСписокОКПД2(Параметры);
	
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СписокЗЕРНО,
			"Идентификатор",
			Список.Выгрузить(, "Код").ВыгрузитьКолонку("Код"));
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокЗЕРНО,
			"ВидПродукции",
			ВидПродукции,
			ВидСравненияКомпоновкиДанных.Равно,,
			Истина);
		
	КонецЕсли;
	
	Параметры.Свойство("ВозвращатьСсылкуНаЭлементКлассификатора", ВозвращатьСсылкуНаЭлементКлассификатора);
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		УстановитьТекущуюСтроку(ВозвращатьСсылкуНаЭлементКлассификатора, Параметры.ТекущаяСтрока);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, "Список", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(Значение, "Список", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗЕРНО

&НаКлиенте
Процедура СписокЗЕРНОВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, "СписокЗЕРНО", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗЕРНОВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначенияСписка(Значение, "СписокЗЕРНО", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	
	ТекущиеДанные = Элементы.СписокЗЕРНО.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбработкаВыбораЗначенияСписка(ТекущиеДанные, "СписокЗЕРНО", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзСправочника(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбработкаВыбораЗначенияСписка(ТекущиеДанные, "Список", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	
	ОписаниеПриЗавершении = Новый ОписаниеОповещения("Подключаемый_ПриЗавершенииОперации", ЭтотОбъект);
	
	ПараметрыОбработкиСообщений = ИнтеграцияЗЕРНОСлужебныйКлиентСервер.ПараметрыОбработкиСообщений();
	ПараметрыОбработкиСообщений.Ссылка = ПредопределенноеЗначение("Перечисление.ВидыКлассификаторовЗЕРНО.ОКПД2");
	
	ИнтеграцияЗЕРНОКлиент.ПодготовитьКПередаче(
		ЭтотОбъект,
		ПараметрыОбработкиСообщений,
		ОписаниеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораЗначенияСписка(ВыбраннаяСтрока, ИмяСписка, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("ДанныеФормыСтруктура")
		Или ТипЗнч(ВыбраннаяСтрока) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ДанныеСтроки = ВыбраннаяСтрока;
	Иначе
		ДанныеСтроки = Элементы[ИмяСписка].ДанныеСтроки(ВыбраннаяСтрока);
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не ДанныеСтроки.Сопоставлено Или ВозвращатьСсылкуНаЭлементКлассификатора Тогда
			Результат = ОбработкаВыбораЗначенияИзСпискаНаСервере(ДанныеСтроки.Код);
		КонецЕсли;
		
		Если ВозвращатьСсылкуНаЭлементКлассификатора Тогда
			ВыбранноеЗначение = Результат;
		Иначе
			ВыбранноеЗначение = Новый Структура;
			
			ВыбранноеЗначение.Вставить("Код", ДанныеСтроки.Код);
			ВыбранноеЗначение.Вставить(
				"Представление",
				ИнтеграцияЗЕРНОКлиентСервер.ПредставлениеОКПД2(
					ДанныеСтроки.НаименованиеПолное, ДанныеСтроки.Код));
		КонецЕсли;
		ОповеститьОВыборе(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаВыбораЗначенияИзСпискаНаСервере(ОКПД2)
	
	Результат = ИнтеграцияЗЕРНО.ПолучитьДанныеСопоставленногоКлассификатораОКПД2(ОКПД2);
	Возврат Результат;
	
КонецФункции

#Область ЗагруженныеКодыОКПД2

&НаСервере
Функция ТекстЗапросаСписокОКПД2()
	
	ТекстЗапроса = ИнтеграцияЗЕРНО.ОпределитьТекстЗапросаКлассификатораОКПД2();
	
	ТекстЗапроса = ТекстЗапроса + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ВременнаяТаблица.Ссылка            КАК Ссылка,
	|	ВременнаяТаблица.Код               КАК Код,
	|	КлассификаторНСИЗЕРНО.Наименование КАК НаименованиеПолное,
	|	1                                  КАК Сопоставлено
	|ИЗ
	|	Справочник.КлассификаторНСИЗЕРНО КАК КлассификаторНСИЗЕРНО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО ВременнаяТаблица.Код = КлассификаторНСИЗЕРНО.Идентификатор
	|		И КлассификаторНСИЗЕРНО.ВидКлассификатора = ЗНАЧЕНИЕ(Перечисление.ВидыКлассификаторовЗЕРНО.ОКПД2)
	|ГДЕ
	|	КлассификаторНСИЗЕРНО.ВидПродукции = &ВидПродукции Или &БезОтбораПоВидуПродукции
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблица.Ссылка,
	|	ВременнаяТаблица.Код,
	|	КлассификаторНСИЗЕРНО.Наименование,
	|	КлассификаторНСИЗЕРНО.ВидПродукции";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокОКПД2(Параметры)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = ТекстЗапросаСписокОКПД2();
	
	Запрос.УстановитьПараметр("ВидПродукции",            ВидПродукции);
	Запрос.УстановитьПараметр("БезОтбораПоВидуПродукции", Не ЗначениеЗаполнено(ВидПродукции));
	
	Запрос.Текст = ТекстЗапроса;
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьТекущуюСтроку(ПоискПоСсылке, ЗначениеОтбора)
	
	Если ПоискПоСсылке Тогда
		Отбор = Новый Структура("Ссылка", ЗначениеОтбора);
		НайденныеСтроки = Список.НайтиСтроки(Отбор);
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Строка") Тогда
		Отбор = Новый Структура("Код", ЗначениеОтбора);
		НайденныеСтроки = Список.НайтиСтроки(Отбор);
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НайденныеСтроки.Количество() Тогда
		ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
		Элементы.Список.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.СписокЗЕРНО.Обновить();
	
КонецПроцедуры

#КонецОбласти