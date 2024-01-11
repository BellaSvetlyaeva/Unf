#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОптимизации = ИнтеграцияСАТУРНСлужебный.ПараметрыОптимизации();
	
	КоличествоЗапросовВМинуту           = ПараметрыОптимизации.КоличествоЗапросовВМинуту;
	ТаймаутHTTPЗапросов                 = ПараметрыОптимизации.ТаймаутHTTPЗапросов;
	АвторизацияHTTPТестовыйКонтурЛогин  = ПараметрыОптимизации.АвторизацияHTTPТестовыйКонтурЛогин;
	АвторизацияHTTPТестовыйКонтурПароль = ПараметрыОптимизации.АвторизацияHTTPТестовыйКонтурПароль;
	КоличествоЭлементовСтраницыОтвета   = ПараметрыОптимизации.КоличествоЭлементовСтраницыОтвета;
	ДатаОграниченияГлубиныДереваПартий  = ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий;
	
	ДополнитьСписокВыбора("КоличествоЗапросовВМинуту",     Ложь,   НСтр("ru = 'в минуту'"));
	ДополнитьСписокВыбора("ТаймаутHTTPЗапросов",           Истина, НСтр("ru = 'секунда'"), Истина);
	
	ЗаполнитьПредставленияПодсказокЭлементов();
	
	// Обновление состояния элементов
	УстановитьВидимостьДоступность();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоЗапросовВМинутуПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЗапросовВМинутуОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовСтраницыОтветаПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовСтраницыОтветаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутHTTPЗапросовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутHTTPЗапросовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияHTTPТестовыйКонтурЛогинПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияHTTPТестовыйКонтурЛогинОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияHTTPТестовыйКонтурПарольПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияHTTPТестовыйКонтурПарольОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияHTTPТестовыйКонтурПарольОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Элементы.АвторизацияHTTPТестовыйКонтурПароль.РежимПароля = Не Элементы.АвторизацияHTTPТестовыйКонтурПароль.РежимПароля;
КонецПроцедуры

&НаКлиенте
Процедура ДатаОграниченияГлубиныДереваПартийПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОграниченияГлубиныДереваПартийОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТекстПодсказкиПоЗначению(Значение, СклоняемоеЗначение, Знач Падеж = "Именительный")
		
	Результат = ПолучитьСклоненияСтрокиПоЧислу(
		СклоняемоеЗначение,
		Значение,,
		"ЧС=Количественное",
		СтрШаблон("ПД=%1", Падеж));
	
	Если Результат.Количество() Тогда
		Возврат СокрЛП(СтрЗаменить(Результат[0], Значение, ""));
	Иначе
		Возврат СклоняемоеЗначение;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииНастройкиКлиент(Элемент)
	
	Результат = ПриИзмененииНастройкиСервер(Элемент.Имя);
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииНастройкиСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	ЗаполнитьПредставленияПодсказокЭлементов();
	
	НачатьТранзакцию();
	Попытка
		
		ПараметрыОптимизации = ИнтеграцияСАТУРНСлужебный.ПараметрыОптимизации();
		ПараметрыОптимизации.КоличествоЗапросовВМинуту           = КоличествоЗапросовВМинуту;
		ПараметрыОптимизации.ТаймаутHTTPЗапросов                 = ТаймаутHTTPЗапросов;
		ПараметрыОптимизации.АвторизацияHTTPТестовыйКонтурЛогин  = АвторизацияHTTPТестовыйКонтурЛогин;
		ПараметрыОптимизации.АвторизацияHTTPТестовыйКонтурПароль = АвторизацияHTTPТестовыйКонтурПароль;
		ПараметрыОптимизации.КоличествоЭлементовСтраницыОтвета   = КоличествоЭлементовСтраницыОтвета;
		ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий  = ДатаОграниченияГлубиныДереваПартий;
		
		ИнтеграцияСАТУРНСлужебный.ЗаписатьПараметрыОптимизации(ПараметрыОптимизации);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнфрмацияОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнфрмацияОшибки));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьДоступность(РеквизитПутьКДанным = "")
	
	ПраваНаРедактирование = ПраваНаРедактированиеЭлементовФормы();
	
	Для Каждого ЭлементФормы Из Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
			
			МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементФормы.ПутьКДанным, ".");
			ИмяРеквизитаФормы = МассивПодстрок[МассивПодстрок.ВГраница()];
			ПравоТолькоПросмотр = Не ПраваНаРедактирование.Получить(ИмяРеквизитаФормы);
			ЭлементФормы.ТолькоПросмотр = ПравоТолькоПросмотр; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ИнтеграцияСАТУРНКлиентСервер.РежимРаботыСТестовымКонтуромСАТУРН() Тогда
		Элементы.АвторизацияHTTPТестовыйКонтурЛогин.Видимость  = Ложь;
		Элементы.АвторизацияHTTPТестовыйКонтурПароль.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставленияПодсказокЭлементов()
	
	Источник = Новый Структура();
	Источник.Вставить("ТаймаутHTTPЗапросов", НСтр("ru = 'секунда'"));
	
	Для Каждого КлючИЗначение Из Источник Цикл
		ТекстПодсказки = ТекстПодсказкиПоЗначению(ЭтотОбъект[КлючИЗначение.Ключ], КлючИЗначение.Значение);
		Элементы[КлючИЗначение.Ключ].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПраваНаРедактированиеЭлементовФормы()
	
	Соответствие = Новый Соответствие;
	
	НастройкиОбменаСАТУРН = ИнтеграцияСАТУРНСлужебный.ПараметрыОптимизации();
	ПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Константы.НастройкиОбменаСАТУРН);
	Для Каждого КлючЗначение Из НастройкиОбменаСАТУРН Цикл
		Соответствие.Вставить(КлючЗначение.Ключ, ПравоРедактирования);
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьСписокВыбора(ИмяРеквизита, СформироватьПредставлениеДаты = Ложь, ПроизвольноеПредставление = Неопределено, СклонятьПредставление = Ложь)

	СписокВыбора = Элементы[ИмяРеквизита].СписокВыбора;
	Значение     = ЭтотОбъект[ИмяРеквизита];
	
	Если СписокВыбора.НайтиПоЗначению(Значение) <> Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПредставлениеЗначения = Строка(Значение);
	Если СформироватьПредставлениеДаты И Значение > 0 Тогда
		ПредставлениеЗначения = ПредставлениеВремени(Значение);
	КонецЕсли;
	
	Если ПроизвольноеПредставление <> Неопределено Тогда
		Если СклонятьПредставление Тогда
			ПредставлениеЗначения = СтрШаблон(
				"%1 %2",
				Значение,
				ТекстПодсказкиПоЗначению(Значение, ПроизвольноеПредставление));
		Иначе
			ПредставлениеЗначения = СтрШаблон("%1 %2", Значение, ПроизвольноеПредставление);
		КонецЕсли;
	КонецЕсли;
	
	СписокВыбора.Добавить(Значение, ПредставлениеЗначения);
	СписокВыбора.СортироватьПоЗначению();
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеВремени(ОбщееКоличествоСекунд)
	
	ОбщаяДата = Дата(1, 1, 1) + ОбщееКоличествоСекунд;
	
	Дней   = ДеньГода(ОбщаяДата) - 1;
	Часов  = Час(ОбщаяДата);
	Минут  = Минута(ОбщаяДата);
	Секунд = Секунда(ОбщаяДата);
	
	Строки = Новый Массив;
	
	Если Дней > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 дн.'"), Дней));
	КонецЕсли;
	Если Часов > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 ч.'"), Часов));
	КонецЕсли;
	Если Минут > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 мин.'"), Минут));
	КонецЕсли;
	Если Секунд > 0 Или Строки.Количество() = 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 сек.'"), Секунд));
	КонецЕсли;
	
	Возврат СтрСоединить(Строки, " ");
	
КонецФункции

#КонецОбласти