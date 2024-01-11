
#Область ПрограммныйИнтерфейс

#Область СобытияФормы

Процедура ПриСозданииНаСервере(Форма, ИмяГруппыРазмещения = "", СписокКонтекстноеМеню = Неопределено) Экспорт
	
	ПроверитьСоздатьРеквизитыПанели(Форма, ИмяГруппыРазмещения, СписокКонтекстноеМеню);
	УстановитьУсловноеОформление(Форма);
	Форма.ИспользуетсяРаботаССобытиями = ПолучитьФункциональнуюОпцию("ИспользоватьСобытия");
	
	Если Форма.ЕстьТаблицаДанныеПанелиКонтактнойИнформации
		И Форма.ДанныеПанелиКонтактнойИнформации.Количество() = 0 Тогда
		ДанныеПанели = ДанныеПанелиКонтактнойИнформации(Неопределено);
		ЗаполнитьДанныеПанелиКИ(Форма, ДанныеПанели);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, Контрагент, ИмяГруппыРазмещения = "", СписокКонтекстноеМеню = Неопределено) Экспорт
	
	ПроверитьСоздатьРеквизитыПанели(Форма, ИмяГруппыРазмещения, СписокКонтекстноеМеню);
	ОбновитьДанныеПанели(Форма, Контрагент);
	
КонецПроцедуры

#КонецОбласти

Процедура ОбновитьДанныеПанели(Форма, ВладелецКИ) Экспорт
	
	Если НЕ Форма.ЕстьТаблицаДанныеПанелиКонтактнойИнформации Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПанели = ДанныеПанелиКонтактнойИнформации(ВладелецКИ);
	ЗаполнитьДанныеПанелиКИ(Форма, ДанныеПанели);
	
КонецПроцедуры

// Данные владельца контактной информации для дальнейшего заполнения панели.
// См. КонтактнаяИнформацияПанельУНФКлиент.ЗаполнитьДанныеПанелиКИ()
//
// Параметры:
//  ВладелецКИ - ОпределяемыйТип.ВладелецКонтактнойИнформации
// 
// Возвращаемое значение:
//   - Массив
//
Функция ДанныеПанелиКонтактнойИнформации(ВладелецКИ) Экспорт
	
	ДанныеПанелиКонтактнойИнформации = Новый Массив;
	
	Если ВладелецКИ = Неопределено Тогда
		ДобавитьСообщениеОбОтсутствииДанных(ДанныеПанелиКонтактнойИнформации);
		Возврат ДанныеПанелиКонтактнойИнформации;
	КонецЕсли;
	
	МодульМенеджераВладельцаКИ = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ВладелецКИ);
	МодульМенеджераВладельцаКИ.ЗаполнитьДанныеПанелиКонтактнаяИнформация(ВладелецКИ, ДанныеПанелиКонтактнойИнформации);
	
	Если ДанныеПанелиКонтактнойИнформации.Количество() = 0 Тогда
		ДобавитьСообщениеОбОтсутствииДанных(ДанныеПанелиКонтактнойИнформации);
	КонецЕсли;
	
	Возврат ДанныеПанелиКонтактнойИнформации;
	
КонецФункции

Функция ИндексПиктограммыПоТипу(ТипКИ) Экспорт
	
	Если ТипКИ = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		ИндексКартинки = 2;
	ИначеЕсли ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
		ИндексКартинки = 1;
	ИначеЕсли ТипКИ = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
		ИндексКартинки = 3;
	ИначеЕсли ТипКИ = Перечисления.ТипыКонтактнойИнформации.Skype Тогда
		ИндексКартинки = 0;
	ИначеЕсли ТипКИ = Перечисления.ТипыКонтактнойИнформации.Другое Тогда
		ИндексКартинки = 4;
	ИначеЕсли ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		ИндексКартинки = 0;
	ИначеЕсли ТипКИ = Перечисления.ТипыКонтактнойИнформации.Факс Тогда
		ИндексКартинки = 0;
	Иначе
		ИндексКартинки = 4;
	КонецЕсли;
	
	Возврат ИндексКартинки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьРеквизитФормы(Реквизиты, Имя)
	
	Для каждого Реквизит Из Реквизиты Цикл
		Если Реквизит.Имя = Имя Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьКомандаФормы(Команды, Имя)
	
	Для каждого Команда Из Команды Цикл
		Если Команда.Имя = Имя Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура ПроверитьСоздатьРеквизитыПанели(Форма, ИмяГруппыРазмещения, СписокКонтекстноеМеню)
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент()
		И СписокКонтекстноеМеню <> Неопределено
		И НЕ ЕстьКомандаФормы(Форма.Команды, "СписокПоказатьКонтактнуюИнформациюТекущегоОбъекта") Тогда
		
		СоздатьКонтекстнуюКомандуПросмотраКИ(Форма, СписокКонтекстноеМеню);
	КонецЕсли;
	
	Если ЕстьРеквизитФормы(Форма.ПолучитьРеквизиты(), "ЕстьТаблицаДанныеПанелиКонтактнойИнформации") Тогда
		Возврат;
	КонецЕсли;
	
	НужноСоздатьТаблицуФормы = НЕ (ОбщегоНазначения.ЭтоМобильныйКлиент() И СписокКонтекстноеМеню <> Неопределено);
	
	ДобавляемыеРеквизиты = Новый Массив;
	
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ЕстьТаблицаДанныеПанелиКонтактнойИнформации", Новый ОписаниеТипов("Булево")));
	Если НЕ ЕстьРеквизитФормы(Форма.ПолучитьРеквизиты(), "ИспользуетсяРаботаССобытиями") Тогда
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользуетсяРаботаССобытиями", Новый ОписаниеТипов("Булево")));
	КонецЕсли;

	Если НужноСоздатьТаблицуФормы Тогда
		// Создадим таблицу значений
		ИмяТаблицы = "ДанныеПанелиКонтактнойИнформации";
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяТаблицы, Новый ОписаниеТипов("ТаблицаЗначений")));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Отображение", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИндексПиктограммы", Новый ОписаниеТипов("Число"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипОтображаемыхДанных", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20)), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ВладелецКИ", Новый ОписаниеТипов("СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица, СправочникСсылка.Лиды,СправочникСсылка.КонтактыЛидов, Строка"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Родитель", Новый ОписаниеТипов("СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица, СправочникСсылка.Лиды,СправочникСсылка.КонтактыЛидов"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПредставлениеКИ", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(500)), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипКИ", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыКонтактнойИнформации"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("СписокПодразделенийГоловногоКонтрагента", Новый ОписаниеТипов("СписокЗначений"), ИмяТаблицы));
	КонецЕсли;
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Если НужноСоздатьТаблицуФормы Тогда
		
		// Создадим элементы
		ТаблицаФормы = Форма.Элементы.Добавить(ИмяТаблицы, Тип("ТаблицаФормы"), Форма.Элементы[ИмяГруппыРазмещения]);
		ТаблицаФормы.ПутьКДанным = ИмяТаблицы;
		ТаблицаФормы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		ТаблицаФормы.ИзменятьСоставСтрок = Ложь;
		ТаблицаФормы.ИзменятьПорядокСтрок = Ложь;
		ТаблицаФормы.РежимВыделенияСтроки = РежимВыделенияСтрокиТаблицы.Строка;
		ТаблицаФормы.Шапка = Ложь;
		ТаблицаФормы.АвтоВводНовойСтроки = Ложь;
		ТаблицаФормы.РазрешитьНачалоПеретаскивания = Ложь;
		ТаблицаФормы.РазрешитьПеретаскивание = Ложь;
		ТаблицаФормы.ГоризонтальнаяПолосаПрокрутки = ИспользованиеПолосыПрокрутки.НеИспользовать;
		ТаблицаФормы.ВертикальнаяПолосаПрокрутки = ИспользованиеПолосыПрокрутки.НеИспользовать;
		ТаблицаФормы.ГоризонтальныеЛинии = Ложь;
		ТаблицаФормы.ВертикальныеЛинии = Ложь;
		ТаблицаФормы.ЦветРамки = ЦветаСтиля.ЦветФонаФормы;
		ТаблицаФормы.Высота = 10;
		ТаблицаФормы.РастягиватьПоГоризонтали = Ложь;
		Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
			ТаблицаФормы.ИспользованиеТекущейСтроки = ИспользованиеТекущейСтрокиТаблицы.ОтображениеВыделения;
		КонецЕсли;
		ТаблицаФормы.УстановитьДействие("Выбор",				"Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор");
		ТаблицаФормы.УстановитьДействие("ПриАктивизацииСтроки",	"Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки");
		
		Отображение = Форма.Элементы.Добавить(ИмяТаблицы + "Отображение", Тип("ПолеФормы"), ТаблицаФормы);
		Отображение.ПутьКДанным = ИмяТаблицы + ".Отображение";
		Отображение.Вид = ВидПоляФормы.ПолеНадписи;
		Отображение.РежимРедактирования = РежимРедактированияКолонки.Вход;
		Отображение.АвтоВысотаЯчейки = Истина;
		Отображение.Ширина = 23;
		
		Пиктограмма = Форма.Элементы.Добавить(ИмяТаблицы + "Пиктограмма", Тип("ПолеФормы"), ТаблицаФормы);
		Пиктограмма.ПутьКДанным = ИмяТаблицы + ".ИндексПиктограммы";
		Пиктограмма.Вид = ВидПоляФормы.ПолеКартинки;
		Пиктограмма.КартинкаЗначений = БиблиотекаКартинок.КоллекцияДействияКонтактнаяИнформация;
		Пиктограмма.АвтоВысотаЯчейки = Истина;
		Пиктограмма.ГиперссылкаЯчейки = Истина;
		Пиктограмма.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, -1);
		Пиктограмма.Ширина = 1;
		Пиктограмма.РастягиватьПоГоризонтали = Ложь;
		Пиктограмма.РастягиватьПоВертикали = Ложь;
		
		КартинкаГоловного = Форма.Элементы.Добавить(ИмяТаблицы + "КартинкаГоловного", Тип("ПолеФормы"), ТаблицаФормы);
		КартинкаГоловного.ПутьКДанным = ИмяТаблицы + ".ИндексПиктограммы";
		КартинкаГоловного.Вид = ВидПоляФормы.ПолеКартинки;
		КартинкаГоловного.КартинкаЗначений = БиблиотекаКартинок.ИерархияГоловнойСписок;
		КартинкаГоловного.АвтоВысотаЯчейки = Истина;
		КартинкаГоловного.ГиперссылкаЯчейки = Истина;
		КартинкаГоловного.Ширина = 1;
		КартинкаГоловного.РастягиватьПоГоризонтали = Ложь;
		КартинкаГоловного.РастягиватьПоВертикали = Ложь;

		ДобавитьКомандуКонтекстногоМеню(
			Форма,
			"КонтекстноеМенюПанелиКартаЯндекс",
			НСтр("ru = 'Адрес на Яндекс.Картах'"),
			НСтр("ru = 'Показывает адрес на картах Яндекс.Карты'"),
			ТаблицаФормы.КонтекстноеМеню,
			БиблиотекаКартинок.ЯндексКарты);
		
		ДобавитьКомандуКонтекстногоМеню(
			Форма,
			"КонтекстноеМенюПанелиКартаGoogle",
			НСтр("ru = 'Адрес на Google Maps'"),
			НСтр("ru = 'Показывает адрес на карте Google Maps'"),
			ТаблицаФормы.КонтекстноеМеню,
			БиблиотекаКартинок.GoogleMaps);
		
		Форма.ЕстьТаблицаДанныеПанелиКонтактнойИнформации = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьКонтекстнуюКомандуПросмотраКИ(Форма, СписокКонтекстноеМеню)
	
	ДобавитьКомандуКонтекстногоМеню(
		Форма,
		"СписокПоказатьКонтактнуюИнформациюТекущегоОбъекта",
		НСтр("ru = 'Показать контактную информацию'"),
		"",
		Форма.Элементы[СписокКонтекстноеМеню]);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформление(Форма)
	
	Если НЕ Форма.ЕстьТаблицаДанныеПанелиКонтактнойИнформации Тогда
		Возврат;
	КонецЕсли;
	
	// 1. Значение контактной информации - обычный стиль, контактные лица - выделяем
	НовоеУсловноеОформление = Форма.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ЦветТекстаПравойПанелиОтборов;
	Оформление.Использование 	= Истина;
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("Шрифт");
	Оформление.Значение 		= ШрифтыСтиля.ШрифтПравойПанелиОтборов;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.ВСписке;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ДанныеПанелиКонтактнойИнформации.ТипОтображаемыхДанных");
	ЗначенияОтбора = Новый СписокЗначений;
	ЗначенияОтбора.Добавить("КонтактноеЛицо","КонтактноеЛицо");
	ЗначенияОтбора.Добавить("ГоловнойКонтрагент","ГоловнойКонтрагент");
	Отбор.ПравоеЗначение 	= ЗначенияОтбора;
	
	ОформляемоеПоле = НовоеУсловноеОформление.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле			= Новый ПолеКомпоновкиДанных("ДанныеПанелиКонтактнойИнформацииОтображение");
	ОформляемоеПоле.Использование	= Истина;
	
	// 2. Не отображать картинку головного контрагента для строк
	НовоеУсловноеОформление = Форма.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("Видимость");
	Оформление.Значение 		= Ложь;
	Оформление.Использование 	= Истина;
		
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.НеРавно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ДанныеПанелиКонтактнойИнформации.ТипОтображаемыхДанных");
	Отбор.ПравоеЗначение 	= "ГоловнойКонтрагент";
	
	ОформляемоеПоле = НовоеУсловноеОформление.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле			= Новый ПолеКомпоновкиДанных("ДанныеПанелиКонтактнойИнформацииКартинкаГоловного");
	ОформляемоеПоле.Использование	= Истина;
	
	// 3. Не отображать иконку КИ для головного контрагента
	НовоеУсловноеОформление = Форма.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("Видимость");
	Оформление.Значение 		= Ложь;
	Оформление.Использование 	= Истина;
		
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ДанныеПанелиКонтактнойИнформации.ТипОтображаемыхДанных");
	Отбор.ПравоеЗначение 	= "ГоловнойКонтрагент";
	
	ОформляемоеПоле = НовоеУсловноеОформление.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле			= Новый ПолеКомпоновкиДанных("ДанныеПанелиКонтактнойИнформацииПиктограмма");
	ОформляемоеПоле.Использование	= Истина;
		
КонецПроцедуры

Процедура ДобавитьСообщениеОбОтсутствииДанных(ДанныеПанелиКонтактнойИнформации)
	
	НоваяСтрока = Новый Структура;
	НоваяСтрока.Вставить("Отображение", НСтр("ru='<Нет контактных данных>'"));
	НоваяСтрока.Вставить("ИндексПиктограммы", -1);
	НоваяСтрока.Вставить("ТипОтображаемыхДанных", "НетДанных");
	НоваяСтрока.Вставить("ВладелецКИ", Неопределено);
	ДанныеПанелиКонтактнойИнформации.Добавить(НоваяСтрока);
	
КонецПроцедуры

Процедура ДобавитьКомандуКонтекстногоМеню(Форма, ИмяКоманды, Заголовок, Подсказка, Родитель, Картинка = Неопределено)
	
	Если Форма.Команды.Найти(ИмяКоманды) = Неопределено Тогда
		Команда = Форма.Команды.Добавить(ИмяКоманды);
		Команда.Заголовок = Заголовок;
		Команда.Подсказка = Подсказка;
		Команда.Действие = "Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду";
		Если Картинка <> Неопределено Тогда
			Команда.Картинка = Картинка;
		КонецЕсли;
	КонецЕсли;
	
	Кнопка = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Родитель);
	Кнопка.ИмяКоманды = ИмяКоманды;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПанелиКИ(Форма, ДанныеПанели) Экспорт
	
	Форма.ДанныеПанелиКонтактнойИнформации.Очистить();
	
	Для каждого Строка Из ДанныеПанели Цикл
		НоваяСтрока = Форма.ДанныеПанелиКонтактнойИнформации.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
