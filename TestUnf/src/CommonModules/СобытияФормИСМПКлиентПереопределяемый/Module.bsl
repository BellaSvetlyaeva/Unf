#Область СобытияЭлементовФорм

// Клиентская переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
// 
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "Выбор".
//   ВыбраннаяСтрока         - ДанныеФормыЭлементКоллекции - выбранный элемент коллекции.
//   Поле                    - ПолеФормы - поле формы события "Выбор".
//   СтандартнаяОбработка    - Булево - установить ложь, если требуется отказываться от выполнения стандартной обработки.
//   ДополнительныеПараметры - Структура  - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт

	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
// 
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "ПриАктивизации".
//   ДополнительныеПараметры - Структура  - значения дополнительных параметров влияющих на обработку.
Процедура ПриАктивизацииСтроки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если Форма.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента"
		И СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ГиперссылкаОткрытьФормуНастройкиПараметровНоменклатурыИСМП") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("Гиперссылка", НавигационнаяСсылкаФорматированнойСтроки);
		ПараметрыОповещения.Вставить("ИмяЭлемента", "НастройкаПараметровНоменклатурыИСМП");
		
		Оповестить("ГиперссылкаОткрытьФормуНастройкиПараметровНоменклатурыИСМП", ПараметрыОповещения, Форма);
		
		
	ИначеЕсли Форма.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента"
		И СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ГиперссылкаОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("Гиперссылка", НавигационнаяСсылкаФорматированнойСтроки);
		ПараметрыОповещения.Вставить("ИмяЭлемента", "ОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП");
		
		Оповестить("ГиперссылкаОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП", ПараметрыОповещения, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма, для которой выполняется команда
//  Команда                 - Произвольный     - команда формы
//  ДополнительныеПараметры - Произвольный     - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Команда) = Тип("Строка") Тогда
		ИмяКоманды = Команда;
	Иначе
		ИмяКоманды = Команда.Имя;
	КонецЕсли;
	
	Если ИмяКоманды = "ОтправитьРаспоряжениеНаПриемкуКладовщику" Тогда
		Контекст = Новый Структура;
		Контекст.Вставить("ОтправитьРаспоряжениеНаПриемкуКладовщику");
		Форма.Подключаемый_ВыполнитьПереопределяемуюКомандуНаСервере(Контекст, Неопределено);
	КонецЕсли;
	
КонецПроцедуры  

#КонецОбласти

#Область РаботаСТСД

// В процедуре нужно реализовать алгоритм передачи данных в ТСД.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, инициировавшая выгрузку.
Процедура ВыгрузитьДанныеВТСД(Форма) Экспорт
	
	ПодключаемоеОборудованиеУНФКлиент.ВыгрузитьДокументВТСД(Форма, Ложь, Новый Структура("ИмяТаблицыВыборки", "Товары"));
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм заполнения формы данными из ТСД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после заполнения данных формы,
//  Форма - ФормаКлиентскогоПриложения - форма, данные в которой требуется заполнить,
//  РезультатВыполнения - (См. МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании).
Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Номенклатура

// Выполняется при создании номенклатуры из формы МОТП. Требуется определить и открыть форму (диалога) создания номенклатуры.
//
// Параметры:
//  Владелец     - ФормаКлиентскогоПриложения            - Форма владелец.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
Процедура ПриСозданииНоменклатуры(Владелец, ДанныеСтроки, СтандартнаяОбработка, ВидПродукцииИС) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриСозданииНоменклатуры(Владелец, ДанныеСтроки, СтандартнаяОбработка, ВидПродукцииИС);
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора номенклатуры.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип..Номенклатура - Результат выбора.
//  ИсточникВыбора          - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки подбора,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Обрабатывает результат выбора в форму документа ИСМП (например из формы подбора номенклатуры,
//   при использовании множественного выбора вместо закрытия формы подбора с общим результатом).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки сопоставления,
//  ВыбранноеЗначение - Произвольный - результат выбора.
//  ИсточникВыбора    - ФормаКлиентскогоПриложения - форма, в которой произведен выбор.
Процедура ОбработкаВыбора(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область ПараметрыВыбора

// Устанавливает параметры выбора контрагента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора.
//   ТолькоЮрЛицаНерезиденты - Неопределено, Булево - Признак нерезидента.
//   ИмяПоляВвода            - Строка               - имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораКонтрагента(Форма, ТолькоЮрЛицаНерезиденты = Неопределено, ИмяПоляВвода = "Контрагент") Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Открывает форму подбора контрагентов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой вызывается команда открытия обработки подбора,
//  ПараметрыФормы - Структура - Параметры формы,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
Процедура ОткрытьФормуПодбораКонтрагента(Форма, ПараметрыФормы = Неопределено, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаСписка", ПараметрыФормы, Форма,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора контрагента.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип.КонтрагентГосИС - Результат выбора.
//  ИсточникВыбора          - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораКонтрагента(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Контрагенты") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ХарактеристикиНоменклатуры

// Выполняется при начале выбора характеристики. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец     - ФормаКлиентскогоПриложения            - форма, в которой вызывается команда выбора характеристики.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится выбор.
//  СтандартнаяОбработка - Булево - Выключается в переопределении
//  Описание - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//
Процедура ПриНачалеВыбораХарактеристики(
	Владелец, ДанныеСтроки, СтандартнаяОбработка, ИмяКолонкиНоменклатура="Номенклатура", Описание=Неопределено) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриНачалеВыбораХарактеристики(Владелец, ДанныеСтроки, СтандартнаяОбработка, ИмяКолонкиНоменклатура, Описание);
	
КонецПроцедуры

// Выполняется при создании характеристики из формы МОТП. Требуется пепеопределить и открыть форму (диалога)
// создания характеристики при необходимости.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения            - Форма владелец.
//  ДанныеСтроки         - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
//  Элемент              - ПолеВвода                   - элемент в котором создается характеристика.
//  СтандартнаяОбработка - Булево                      - Признак стандартной обработки.
Процедура ПриСозданииХарактеристики(Владелец, ДанныеСтроки, Элемент, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора характеристики.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип.ХарактеристикаНоменклатуры - результат выбора.
//  ИсточникВыбора          - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораХарактеристики(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ОбработкаВыбораХарактеристики(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

// Выполняет действия при изменении характеристики номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СерииНоменклатуры

// Выполняет действия при изменении серии номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииСерии(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора серии.
// 
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип.СерияНоменклатуры - результат выбора.
//  ИсточникВыбора         - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
//  ПараметрыУказанияСерий - (См. ПроверкаИПодборПродукцииМОТП.ПараметрыУказанияСерий).
Процедура ОбработкаВыбораСерии(Форма, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий) Экспорт
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.СерииНоменклатуры.Форма.ФормаВыбора" Тогда
		
		ИмяТЧТовары = "Товары";
		Если ТипЗнч(ПараметрыУказанияСерий) = Тип("Структура") Тогда
			ПараметрыУказанияСерий.Свойство("ИмяТЧТовары", ИмяТЧТовары);
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, ИмяТЧТовары) Тогда
			
			ТекущиеДанные = Форма.Элементы[ИмяТЧТовары].ТекущиеДанные;
			ТекущиеДанные.Серия = ВыбранноеЗначение;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Количество

// Выполняет действия при изменении подобранного количества в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область СуммаИНДС

// Выполняет действия при изменении ставки НДС в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииСтавкиНДС(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриИзмененииСтавкиНДС(Форма, ТекущаяСтрока);
	
КонецПроцедуры

// Выполняет действия при изменении суммы в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииСуммы(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриИзмененииСуммы(Форма, ТекущаяСтрока);
	
КонецПроцедуры

// Выполняет действия при изменении суммы НДС в строке таблицы формы.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииСуммыНДС(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Выполняет действия при изменении цены в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
Процедура ПриИзмененииЦены(Форма, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриИзмененииЦены(Форма, ТекущаяСтрока);
	
КонецПроцедуры

Процедура ПриНачалеВыбораКодТНВЭД(Владелец, ДанныеСтроки, СтандартнаяОбработка, Описание = Неопределено) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриНачалеВыбораКодТНВЭД(Владелец, ДанныеСтроки, СтандартнаяОбработка, Описание);
	
КонецПроцедуры

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ФормаВладелец - ФормаУправляемогоПриложения - форма-владелец.
//  Реквизиты     - Структура        - (См. ИнтеграцияИСМПКлиентСервер.РеквизитыСозданияКонтрагента)
//
Процедура ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("ИНН",                Реквизиты.ИНН);
	Основание.Вставить("КПП",                Реквизиты.КПП);
	Основание.Вставить("Наименование",       Реквизиты.Наименование);
	Основание.Вставить("НаименованиеПолное", Реквизиты.НаименованиеПолное);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Выполняет действия при изменении производственного объекта в форме настройки обмена с СУЗ.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие.
Процедура ПриИзмененииПроизводственногоОбъекта(Форма) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
