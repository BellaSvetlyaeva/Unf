
#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс; // Индикатор обновления интерфейса

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант"
		И (Источник = "ИспользоватьОбменБизнесСеть"
		ИЛИ Источник = "ИспользоватьСервис1СДоставка"
		ИЛИ Источник = "ИспользоватьСервис1СКурьер") Тогда
		Прочитать();
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастроитьПеревозчиковСервиса1СДоставкаНажатие(Элемент)
	ПараметрыПеревозчика = Новый Структура;
	ПараметрыПеревозчика.Вставить("ТипГрузоперевозки", 1);
	ПараметрыПеревозчика.Вставить("ОрганизацияБизнесСети", ОрганизацияБизнесСети());
	СервисДоставкиКлиент.ОткрытьФормуДоступныхПеревозчиков(ПараметрыПеревозчика);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПеревозчиковСервиса1СКурьерНажатие(Элемент)
	ПараметрыПеревозчика = Новый Структура;
	ПараметрыПеревозчика.Вставить("ТипГрузоперевозки", 2);
	ПараметрыПеревозчика.Вставить("ОрганизацияБизнесСети", ОрганизацияБизнесСети());
	СервисДоставкиКлиент.ОткрытьФормуДоступныхПеревозчиков(ПараметрыПеревозчика);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПеревозчиковСервисаЯндексДоставкаНажатие(Элемент)
	ОткрытьФорму("Справочник.НастройкиЯндексДоставки.ФормаСписка");	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьСервис1СДоставкаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьСервис1СКурьерПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьСервисЯндексДоставкаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьСервисыБизнесСеть(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Раздел", "НастройкиБизнесСеть");
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБЭД.Форма.ОбщиеНастройки",
		ПараметрыФормы,,
		"Обработка.ПанельАдминистрированияБЭД.Форма.ОбщиеНастройки." + ПараметрыФормы.Раздел);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	Прочитать();
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Если ИмяЭлемента = "НаборКонстантИспользоватьСервисЯндексДоставка" Тогда
		ОчиститьНастройкиЯндексДоставки();
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура ОчиститьНастройкиЯндексДоставки()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиЯндексДоставки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НастройкиЯндексДоставки КАК НастройкиЯндексДоставки";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НастройкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НастройкаОбъект.Заблокировать();
		НастройкаОбъект.ПометкаУдаления = Истина;
		НастройкаОбъект.Записать();
		НастройкаОбъект.Разблокировать();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	КоличествоЧастей = 2;
	
	Если ЧастиИмени.Количество() <> КоличествоЧастей Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	НовоеЗначение = НаборКонстант[ИмяКонстанты];
	СтароеЗначение = КонстантаМенеджер.Получить();
	
	Если СтароеЗначение <> НовоеЗначение Тогда
		
		ТекстОшибки = ПриПроверкеВозможностиУстановкиЗначенияКонстанты(РеквизитПутьКДанным, НовоеЗначение);
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , РеквизитПутьКДанным);
			НаборКонстант[ИмяКонстанты] = СтароеЗначение;
		Иначе
			КонстантаМенеджер.Установить(НовоеЗначение);
			ПриУстановкеЗначенияКонстанты(РеквизитПутьКДанным, НовоеЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Функция ПриПроверкеВозможностиУстановкиЗначенияКонстанты(РеквизитПутьКДанным, НовоеЗначение)
	
	ТекстОшибки = "";	
	ЕстьОбменБизнесСеть = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть");
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервис1СДоставка" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервис1СКурьер" Тогда
		
		Если (НЕ ЕстьОбменБизнесСеть 
			ИЛИ НЕ Константы["ИспользоватьОбменБизнесСеть"].Получить()) 
			И РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервис1СДоставка" Тогда
			ТекстОшибки = НСтр("ru = 'Не включена работа сервиса 1С:Бизнес-сеть. Работа с сервисом 1С:Доставка невозможна.'");
		КонецЕсли;
		
		Если (НЕ ЕстьОбменБизнесСеть 
			ИЛИ НЕ Константы["ИспользоватьОбменБизнесСеть"].Получить()) 
			И РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервис1СКурьер" Тогда
			ТекстОшибки = НСтр("ru = 'Не включена работа сервиса 1С:Бизнес-сеть. Работа с сервисом 1С:Курьер невозможна.'");
		КонецЕсли;
		
	КонецЕсли;

	Возврат ТекстОшибки;
	
КонецФункции

&НаСервере
Процедура ПриУстановкеЗначенияКонстанты(РеквизитПутьКДанным, НовоеЗначение)
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ЕстьОбменБизнесСеть = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть");
	ВключенСервисБизнесСеть = Константы["ИспользоватьОбменБизнесСеть"].Получить();
	
	Элементы.ПанельОшибки.Видимость = НЕ ЕстьОбменБизнесСеть ИЛИ (ЕстьОбменБизнесСеть И НЕ ВключенСервисБизнесСеть);
	Элементы.НаборКонстантИспользоватьСервис1СДоставка.Доступность = ЕстьОбменБизнесСеть И ВключенСервисБизнесСеть;
	Элементы.НаборКонстантИспользоватьСервис1СКурьер.Доступность = ЕстьОбменБизнесСеть И ВключенСервисБизнесСеть;
	
	Если НЕ ЯндексДоставка.Подключена() Тогда
		Элементы.НаборКонстантИспользоватьСервисЯндексДоставка.Видимость = Ложь;
		Элементы.НастроитьПеревозчиковСервисаЯндексДоставка.Видимость = Ложь;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервис1СДоставка"
		Или РеквизитПутьКДанным = "" Тогда
		Элементы.НастроитьПеревозчиковСервиса1СДоставка.Доступность =
			НаборКонстант.ИспользоватьСервис1СДоставка;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервис1СКурьер"
		Или РеквизитПутьКДанным = "" Тогда
		Элементы.НастроитьПеревозчиковСервиса1СКурьер.Доступность =
			НаборКонстант.ИспользоватьСервис1СКурьер;
		КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСервисЯндексДоставка"
		Или РеквизитПутьКДанным = "" Тогда
		Элементы.НастроитьПеревозчиковСервисаЯндексДоставка.Доступность =
			НаборКонстант.ИспользоватьСервисЯндексДоставка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОрганизацияБизнесСети()
	
	ОрганизацияБизнесСетиСсылка = Неопределено;
	
	ОбщийМодульБизнесСеть = ОбщегоНазначения.ОбщийМодуль("БизнесСеть");
	ДанныеОрганизаций = ОбщийМодульБизнесСеть.ПодключенныеОрганизации();
	
	Если ДанныеОрганизаций.Количество() Тогда
		
		Если ДанныеОрганизаций.Количество() = 1 Тогда
			ОрганизацияБизнесСетиСсылка = ДанныеОрганизаций[0].Организация;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОрганизацияБизнесСетиСсылка;
	
КонецФункции

#КонецОбласти
