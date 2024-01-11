////////////////////////////////////////////////////////////////////////////////
// Модуль формы Обработка.СопоставлениеНоменклатурыБЭД.ФормаВариантов
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Обработка параметров формы.
	Если Параметры.Свойство("ЭлементСопоставления", ЭлементСопоставления) Тогда
		
		ЗаполнитьНоменклатуруКонтрагента(ЭлементСопоставления.НоменклатураКонтрагента);
		
	КонецЕсли;
	
	Если Параметры.Свойство("АдресТаблицыВариантовСопоставления")
		И ЭтоАдресВременногоХранилища(Параметры.АдресТаблицыВариантовСопоставления) Тогда
		
		ЗаполнитьВарианты(Параметры.АдресТаблицыВариантовСопоставления, ЭлементСопоставления);
		АктивизироватьТекущийВариант(ЭлементСопоставления.НоменклатураИБ);
		
	КонецЕсли;
	
	// Настройка формы.
	УстановитьСвойстваЭлементовФормы();
	УстановитьСвойстваЭлементовНоменклатурыКонтрагентов();
	УстановитьСвойстваЭлементовНоменклатурыСервиса();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВарианты

&НаКлиенте
Процедура ВариантыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработатьВыборВарианта(Варианты.НайтиПоИдентификатору(ВыбраннаяСтрока));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВариант(Команда)
	
	ОбработатьВыборВарианта(Элементы.Варианты.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВариант(Команда)
	
	Вариант = Элементы.Варианты.ТекущиеДанные;
	
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Варианты.ТекущийЭлемент = Элементы.ВариантыНоменклатура Тогда
		ПоказатьЗначение(,Вариант.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВесьСписок(Команда)
	
	ОбработатьВыборДействия("ОткрытьСписок");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуру(Команда)
	
	ОбработатьВыборДействия("СоздатьНоменклатуру");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзСервиса(Команда)
	
	ОбработатьВыборДействия("ЗагрузитьИзСервиса");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзСервиса(Команда)
	
	ОбработатьВыборДействия("ПодобратьИзСервиса");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСФормой

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Выделим сработавшие критерии поиска.
	
	ШрифтВыделения = Метаданные.ЭлементыСтиля.ВажнаяНадписьШрифт.Значение;
	
	// Наименование
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтВыделения);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Варианты.Наименование");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Наименование");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыНоменклатура.Имя);
	
	// Артикул
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтВыделения);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Варианты.АртикулСопоставлен");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АртикулСопоставлен.Имя);
	
	// Штрихкод
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтВыделения);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Варианты.ШтрихкодСопоставлен");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ШтрихкодСопоставлен.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()
	
	Элементы.КомандаСоздатьНоменклатуру.Видимость = ЕстьПравоДобавленияНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовНоменклатурыКонтрагентов()
	
	ЗаголовокНоменклатурыКонтрагента = НСтр("ru = 'Данные для сопоставления'");
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		
		ЗаголовокНоменклатурыКонтрагента = СтрШаблон(НСтр("ru = 'Данные ""%1""'"), Владелец);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ШтрихкодыНоменклатуры) Тогда
		Элементы.ДругиеШтрихкодыНоменклатуры.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаНоменклатураКонтрагента.Заголовок = ЗаголовокНоменклатурыКонтрагента;
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьСвойстваЭлементовНоменклатурыСервиса()
	
	ИспользоватьСервис = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.РаботаСНоменклатурой") Тогда
		
		МодульРаботаСНоменклатурой = ОбщегоНазначения.ОбщийМодуль("РаботаСНоменклатурой");
		
		ИспользоватьСервисРаботаСНоменклатурой = МодульРаботаСНоменклатурой.ДоступнаФункциональностьПодсистемы();
		
		ИспользоватьСервис = ИспользоватьСервисРаботаСНоменклатурой
			И МодульРаботаСНоменклатурой.ПравоИзмененияДанных();
		
	КонецЕсли;
	
	ЕстьИдентификаторСервиса = ЗначениеЗаполнено(ЭлементСопоставления.НоменклатураКонтрагента.ИдентификаторНоменклатурыСервиса);
	Элементы.КомандаЗагрузитьИзСервиса.Видимость = ИспользоватьСервис И ЕстьИдентификаторСервиса;
	Элементы.КомандаПодобратьИзСервиса.Видимость = ИспользоватьСервис И Не ЕстьИдентификаторСервиса;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСВариантами

&НаСервере
Процедура АктивизироватьТекущийВариант(Знач НоменклатураИБ)
	
	Если Не ЗначениеЗаполнено(НоменклатураИБ.Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборТекущегоВарианта = Новый Структура("Номенклатура", НоменклатураИБ);
	НайденныеВарианты = Варианты.НайтиСтроки(ОтборТекущегоВарианта);
	
	Если ЗначениеЗаполнено(НайденныеВарианты) Тогда
		
		Элементы.Варианты.ТекущаяСтрока = НайденныеВарианты[0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВарианты(Знач АдресТаблицыВариантовСопоставления, Знач ЭлементСопоставления)
	
	Варианты.Очистить();
	
	ТаблицаВариантовСопоставления = ПолучитьИзВременногоХранилища(АдресТаблицыВариантовСопоставления);

	КлючЗаписи = Новый Структура("Владелец,Идентификатор");
	ЗаполнитьЗначенияСвойств(КлючЗаписи, ЭлементСопоставления.НоменклатураКонтрагента);
	СтрокиВариантовСопоставления = ТаблицаВариантовСопоставления.НайтиСтроки(КлючЗаписи);
	
	Для Каждого СтрокаВарианта Из СтрокиВариантовСопоставления Цикл
		НовыйВариант = Варианты.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйВариант, СтрокаВарианта);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборДействия(Знач Действие)
	
	ОписаниеДействия = Новый Структура("Действие,ЭлементСопоставления", Действие, ЭлементСопоставления);
	
	ОповеститьОВыборе(ОписаниеДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВарианта(Вариант)
	
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭлементСопоставления.НоменклатураИБ, Вариант);
	
	ОбработатьВыборДействия("ПрименитьВариант");
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСНоменклатуройКонтрагента

&НаСервере
Процедура ЗаполнитьНоменклатуруКонтрагента(Знач НоменклатураКонтрагента)
	
	Владелец                           = НоменклатураКонтрагента.Владелец;
	Идентификатор                      = НоменклатураКонтрагента.Идентификатор;
	Наименование                       = НоменклатураКонтрагента.Наименование;
	Характеристика                     = НоменклатураКонтрагента.Характеристика;
	ЕдиницаИзмерения                   = НоменклатураКонтрагента.ЕдиницаИзмерения;
	ЕдиницаИзмеренияКод                = НоменклатураКонтрагента.ЕдиницаИзмеренияКод;
	Артикул                            = НоменклатураКонтрагента.Артикул;
	СтавкаНДС                          = НоменклатураКонтрагента.СтавкаНДС;
	ШтрихкодКомбинации                 = НоменклатураКонтрагента.ШтрихкодКомбинации;
	ШтрихкодыНоменклатуры              = НоменклатураКонтрагента.ШтрихкодыНоменклатуры;
	ИдентификаторНоменклатурыСервиса   = НоменклатураКонтрагента.ИдентификаторНоменклатурыСервиса;
	ИдентификаторХарактеристикиСервиса = НоменклатураКонтрагента.ИдентификаторХарактеристикиСервиса;
	
	СвойстваУпаковки = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НовыеСвойстваУпаковки();
	СвойстваУпаковки.НаименованиеБазовойЕдиницыИзмерения = НоменклатураКонтрагента.ЕдиницаИзмерения;
	СвойстваУпаковки.КоличествоБазовойЕдиницыИзмерения   = НоменклатураКонтрагента.КоличествоБазовойЕдиницыИзмерения;
	СвойстваУпаковки.КоличествоУпаковок                  = НоменклатураКонтрагента.КоличествоУпаковок;
	СвойстваУпаковки.НаименованиеУпаковки                = НоменклатураКонтрагента.НаименованиеУпаковки;
	Если СопоставлениеНоменклатурыКонтрагентовСлужебныйКлиентСервер.УпаковкаИБазоваяЕдиницаИзмеренияРазличны(СвойстваУпаковки) Тогда
		НаименованиеУпаковки = НоменклатураКонтрагента.НаименованиеУпаковки;
	КонецЕсли;
	
	Если СтрДлина(Наименование) > 300 Тогда
		Элементы.Наименование.Высота = 3;
	ИначеЕсли СтрДлина(Наименование) > 200 Тогда
		Элементы.Наименование.Высота = 2;
	КонецЕсли;
	
	Если СтрДлина(Характеристика) > 300 Тогда
		Элементы.Характеристика.Высота = 3;
	ИначеЕсли СтрДлина(Характеристика) > 200 Тогда
		Элементы.Характеристика.Высота = 2;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Функция ЕстьПравоДобавленияНоменклатуры()
	
	ЕстьПраво = Истина;
	
	Для каждого ТипНоменклатуры Из Метаданные.ОпределяемыеТипы.НоменклатураБЭД.Тип.Типы() Цикл
		
		МетаданныеТипа = Метаданные.НайтиПоТипу(ТипНоменклатуры);
		Если МетаданныеТипа = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			ЕстьПравоДобавления = ПравоДоступа("Добавление", МетаданныеТипа);
		Исключение
			Продолжить;
		КонецПопытки;
		
		ЕстьПраво = ЕстьПраво И ЕстьПравоДобавления;
		
	КонецЦикла;
	
	Возврат ЕстьПраво;
	
КонецФункции

#КонецОбласти

#КонецОбласти
