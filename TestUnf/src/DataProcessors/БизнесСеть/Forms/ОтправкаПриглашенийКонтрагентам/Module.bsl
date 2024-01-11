
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Не БизнесСеть.ПравоВыполненияОбменаДокументами(Неопределено, Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ЗаполнятьПриОткрытии", ЗаполнятьПриОткрытии);
	
	РежимОтправки = 0;
	Если Параметры.Свойство("РежимПриглашения") Тогда
		Если Параметры.РежимПриглашения = "Поставщики" Тогда
			РежимОтправки = 1;
		ИначеЕсли Параметры.РежимПриглашения = "Покупатели" Тогда
			РежимОтправки = 2;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОрганизацияНеЗарегистрирована = Не БизнесСеть.ОрганизацияПодключена(Организация);
	КонецЕсли;
	
	Если ЗаполнятьПриОткрытии Тогда
		НачалоПериода = НачалоДня(ДобавитьМесяц(ТекущаяДатаСеанса(), -6));
		ЗаполнитьКонтрагентовПоСделкамНаСервере("ЗаполнитьПоВсемСделкам", НачалоПериода, Истина);
	КонецЕсли;
	
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОтправкиПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОрганизацияНеЗарегистрирована = Не ОрганизацияЗарегистрирована(Организация);
		УстановитьВидимостьДоступность(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокСсылкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ПриглашениеОтправлено = Ложь;
	ТекущиеДанные.Проверен              = Ложь;
	ПроверитьДанныеСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ Не НоваяСтрока
		ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.Ссылка) ИЛИ ТекущиеДанные.Проверен Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Проверен = Ложь;
	ТекущиеДанные.Зарегистрирован = Ложь;
	
	ПроверитьДанныеСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Зарегистрирован И (Поле.Имя = Элементы.СписокЗарегистрированКартинка.Имя
		ИЛИ Поле.Имя = Элементы.СписокЭлектроннаяПочта.Имя) Тогда
		БизнесСетьСлужебныйКлиент.ОткрытьПрофильУчастника(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьКонтрагентовПоСделкам(Команда)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поле ""Организация"" не заполнено.'"),,
			"Организация");
		Возврат;
	КонецЕсли;
	
	Если Команда.Имя = "ЗаполнитьПоПоставкам" Тогда
		Действие = "ЗаполнитьПоПоставкам";
	ИначеЕсли Команда.Имя = "ЗаполнитьПоЗакупкам" Тогда
		Действие = "ЗаполнитьПоЗакупкам";
	Иначе
		Действие = "ЗаполнитьПоВсемСделкам";
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Действие", Действие);
	
	ПоказатьВводДаты(Новый ОписаниеОповещения("ЗаполнитьКонтрагентовПоСделкамПродолжение", ЭтотОбъект,
		ДополнительныеПараметры), НачалоДня(ДобавитьМесяц(ОбщегоНазначенияКлиент.ДатаСеанса(), -6)),
		НСтр("ru = 'Начало периода анализа'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПодобратьКонтрагентовПродолжение", ЭтотОбъект);
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	
	ИмяФормыВыбора = БизнесСетьВызовСервера.ИмяФормыВыбораПоОпределяемомуТипу("КонтрагентБЭД");
	Если ЗначениеЗаполнено(ИмяФормыВыбора) Тогда
		ОчиститьСообщения();
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыОткрытия,,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПриглашения(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	Если ОрганизацияНеЗарегистрирована Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПодключениеОрганизацииПродолжение", ЭтотОбъект);
		
		БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Организация, ЭтотОбъект, Оповещение);
		
	Иначе
		ОтправитьПриглашенияНаСервере();
		
		Если ЗначениеЗаполнено(Организация) 
			И БизнесСетьКлиент.ТребуетсяПовторноеПодключениеОрганизации(Организация) Тогда
			
			Оповещение = Новый ОписаниеОповещения("ОтправитьДокументыВСервисПослеПодключения", ЭтотОбъект);
			БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Организация, ЭтотОбъект, Оповещение);
		КонецЕсли
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДокументыВСервисПослеПодключения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ОтправитьПриглашенияНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключениеОрганизацииПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.СтатусПодключения = "Подключена" Тогда
		
		ОрганизацияНеЗарегистрирована = Ложь;
		УстановитьВидимостьДоступность(ЭтотОбъект);
		ОтправитьПриглашенияНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКонтрагентовПоСделкамПродолжение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКонтрагентовПоСделкамНаСервере(ДополнительныеПараметры.Действие, Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтрагентовПоСделкамНаСервере(РежимЗаполнения, НачалоПериода, ТолькоНеЗарегистрированные = Ложь)
	
	ДобавляемыеДанные = Новый ТаблицаЗначений;
	
	ДобавляемыеДанные.Колонки.Добавить("Ссылка",           Новый ОписаниеТипов(Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип));
	ДобавляемыеДанные.Колонки.Добавить("ЭлектроннаяПочта", Новый ОписаниеТипов("Строка"));
	ДобавляемыеДанные.Колонки.Добавить("Зарегистрирован",  Новый ОписаниеТипов("Булево"));
	
	БизнесСетьПереопределяемый.ПолучитьКонтрагентовПоСделкам(Организация, РежимЗаполнения, НачалоПериода, 
		ДобавляемыеДанные);
		
	ПроверитьИсключитьКонтрагентов(ДобавляемыеДанные);
		
	Если ДобавляемыеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	КонтрагентыСсылки = ДобавляемыеДанные.ВыгрузитьКолонку("Ссылка");
	
	КонтрагентыБизнесСети = БизнесСеть.КонтрагентыВБизнесСети(КонтрагентыСсылки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Добавление новых строк.
	Для каждого СтрокаДанных Из ДобавляемыеДанные Цикл
		
		Если Список.НайтиСтроки(Новый Структура("Ссылка", СтрокаДанных.Ссылка)).Количество() Тогда
			// Если такой контрагент уже добавлен, пропускаем строку.
			Продолжить;
		КонецЕсли;
		
		КонтрагентЗарегистрирован = КонтрагентыБизнесСети.Найти(СтрокаДанных.Ссылка) <> Неопределено;
		
		Если ТолькоНеЗарегистрированные
			И КонтрагентЗарегистрирован Тогда
			
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Список.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДанных);
		НоваяСтрока.Зарегистрирован = КонтрагентЗарегистрирован;
		
		Если НоваяСтрока.Зарегистрирован Тогда
			// Установка признака заполнения электронной почты Истина.
			НоваяСтрока.ЭлектроннаяПочта = НСтр("ru = '<Зарегистрирован>'");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИсключитьКонтрагентов(ДанныеКонтрагентов)
	
	Результат = Новый ТаблицаЗначений;
	
	Результат.Колонки.Добавить("Ссылка",       Новый ОписаниеТипов(Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип));
	Результат.Колонки.Добавить("ИНН",          Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("КПП",          Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	
	Для каждого ЭлементКоллекции Из ДанныеКонтрагентов Цикл
		ЗаполнитьЗначенияСвойств(Результат.Добавить(), ЭлементКоллекции, "Ссылка");
	КонецЦикла;
	
	БизнесСеть.ЗаполнитьРеквизитыКонтрагентов(Результат);
	
	Для каждого ТекущийКонтрагент Из Результат Цикл
		
		Отказ = Ложь;
		ТекстОшибки = "";
		
		Идентификаторы = БизнесСеть.ИдентификаторыУчастника(
			ТекущийКонтрагент.ИНН, 
			ТекущийКонтрагент.КПП,
			ТекущийКонтрагент.Ссылка, 
			Отказ,
			ТекстОшибки);
			
		Если Не Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		
		УдаляемыеСтроки = ДанныеКонтрагентов.НайтиСтроки(Новый Структура("Ссылка", ТекущийКонтрагент.Ссылка));
		
		Для каждого ТекущаяУдаляемаяСтрока Из УдаляемыеСтроки Цикл
			ДанныеКонтрагентов.Удалить(ТекущаяУдаляемаяСтрока);
		КонецЦикла;
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьКонтрагентовПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьКонтрагентовПодбора(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовПодбора(СписокКонтрагентов)
	
	Для каждого НовыйКонтрагент Из СписокКонтрагентов Цикл
		
		Если Список.НайтиСтроки(Новый Структура("Ссылка", НовыйКонтрагент)).Количество() Тогда
			// Если такой контрагент уже добавлен, пропускаем строку.
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Ссылка = НовыйКонтрагент;
		ПроверитьДанныеСтрокиНаСервере(НоваяСтрока.Ссылка, НоваяСтрока.ЭлектроннаяПочта,
			НоваяСтрока.Зарегистрирован, НоваяСтрока.Проверен);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьПриглашенияНаСервере()
	
	Отказ = Ложь;
	Если Не БизнесСеть.ОрганизацияПодключена(Организация) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
		
	СписокПриглашений = Новый ТаблицаЗначений;
	СписокПриглашений.Колонки.Добавить("Ссылка");
	СписокПриглашений.Колонки.Добавить("ЭлектроннаяПочта", Новый ОписаниеТипов("Строка"));
	СписокПриглашений.Колонки.Добавить("Наименование",     Новый ОписаниеТипов("Строка"));
	СписокПриглашений.Колонки.Добавить("ИНН",              Новый ОписаниеТипов("Строка"));
	СписокПриглашений.Колонки.Добавить("КПП",              Новый ОписаниеТипов("Строка"));
		
	РазмерПорцииДанных = 100;
	Счетчик            = 0;
	КоличествоСтрок    = Список.Количество();
	ДанныеОтправлялись = Ложь;
	
	// Проверка заполнения электронной почты.
	Для каждого СтрокаСписка Из Список Цикл
		
		Счетчик = Счетчик + 1;
		
		// Пропускаем зарегистрированные.
		Если СтрокаСписка.Зарегистрирован = Истина
			ИЛИ СтрокаСписка.ПриглашениеОтправлено = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		ИндексСтроки = Список.Индекс(СтрокаСписка);
		
		Если Не ЗначениеЗаполнено(СтрокаСписка.Ссылка) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Поле ""Контрагент"" не заполнено.'"),,
				"Список[" + Формат(ИндексСтроки, "ЧГ=") + "].Ссылка");
			Возврат;
		КонецЕсли;
		
		СтрокаСписка.ЭлектроннаяПочта = СокрЛП(СтрокаСписка.ЭлектроннаяПочта);
		
		Если Не ЗначениеЗаполнено(СтрокаСписка.ЭлектроннаяПочта) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Поле ""Электронная почта"" не заполнено.'"),,
				"Список[" + Формат(ИндексСтроки, "ЧГ=") + "].ЭлектроннаяПочта");
			Возврат;
		КонецЕсли;
		
		Если Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(
			СтрокаСписка.ЭлектроннаяПочта, Истина) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Поле ""Электронная почта"" заполнено некорректно.'"),,
				"Список[" + Формат(ИндексСтроки, "ЧГ=") + "].ЭлектроннаяПочта");
			Возврат;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СписокПриглашений.Добавить(), СтрокаСписка);
		
		Если СписокПриглашений.Количество() = РазмерПорцииДанных 
			ИЛИ (Счетчик = КоличествоСтрок И СписокПриглашений.Количество() > 0) Тогда
			
			ВыполнитьЗапросОтправкиПриглашений(СписокПриглашений, ДанныеОтправлялись, Отказ);
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если Не ДанныеОтправлялись Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Отсутствуют незарегистрированные контрагенты для отправки приглашений.'"),,
			"Список");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗапросОтправкиПриглашений(СписокПриглашений, ДанныеОтправлялись, Отказ)
	
	// Отправка приглашений.
	Если РежимОтправки = 0 Тогда
		РольОтправителя = "";
	ИначеЕсли РежимОтправки = 1 Тогда
		// Для текста приглашения Поставщиков, роль отправителя Покупатель.
		РольОтправителя = "Покупатель";
	ИначеЕсли РежимОтправки = 3 Тогда
		// Для текста приглашения Покупателей, роль отправителя Продавец.
		РольОтправителя = "Продавец";
	КонецЕсли;	
		
	БизнесСеть.ЗаполнитьРеквизитыКонтрагентов(СписокПриглашений);
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("Организация",     Организация);
	ПараметрыМетода.Вставить("РольОтправителя", РольОтправителя);
	ПараметрыМетода.Вставить("Данные",          СписокПриглашений);
	
	ПараметрыКоманды = БизнесСеть.ПараметрыКомандыОтправкаПриглашенийКонтрагентам(ПараметрыМетода, Отказ);
	БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОтправлялись = Истина;
	
	// Установка признака "Приглашение отправлено".
	Для каждого СтрокаПриглашения Из СписокПриглашений Цикл
		СтрокаСписка = Список.НайтиСтроки(Новый Структура("Ссылка", СтрокаПриглашения.Ссылка));
		Для каждого НайденнаяСтрокаСписка Из СтрокаСписка Цикл
			НайденнаяСтрокаСписка.ПриглашениеОтправлено = Истина;
		КонецЦикла;
	КонецЦикла;
	
	СписокПриглашений.Очистить();
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
	
	Форма.Элементы.СписокГруппаЗаполнить.Видимость        = Форма.РежимОтправки = 0;
	Форма.Элементы.СписокЗаполнитьПокупателей.Видимость   = Форма.РежимОтправки = 1;
	Форма.Элементы.СписокЗаполнитьПоставщиков.Видимость   = Форма.РежимОтправки = 2;
	Форма.Элементы.ГруппаРегистрацииОрганизации.Видимость = Форма.ОрганизацияНеЗарегистрирована;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОрганизацияЗарегистрирована(Организация)
	
	Возврат БизнесСеть.ОрганизацияПодключена(Организация);

КонецФункции

&НаКлиенте
Процедура ПроверитьДанныеСтроки(ТекущиеДанные)
	
	Если Список.НайтиСтроки(Новый Структура("Ссылка", ТекущиеДанные.Ссылка)).Количество() > 1 Тогда
		// Удалить дубль строки.
		Список.Удалить(ТекущиеДанные);
		Возврат;
	КонецЕсли;
	
	ПроверитьДанныеСтрокиНаСервере(ТекущиеДанные.Ссылка, ТекущиеДанные.ЭлектроннаяПочта,
		ТекущиеДанные.Зарегистрирован, ТекущиеДанные.Проверен);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДанныеСтрокиНаСервере(Ссылка, ЭлектроннаяПочта, Зарегистрирован, Проверен)
	
	// Проверка электронной почты.
	ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(Ссылка, ЭлектроннаяПочта);
	
	ЭлектроннаяПочта = СокрЛП(ЭлектроннаяПочта);
	
	// Проверка регистрации контрагента.
	Если Проверен = Ложь Тогда
		
		Отказ = Ложь;
		
		Результат = БизнесСеть.КонтрагентыВБизнесСети(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка), Отказ);

		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Проверен = Истина;
		Зарегистрирован = ЗначениеЗаполнено(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Серый текст, если контрагент зарегистрирован.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЭлектроннаяПочта.Имя);
	ОтборГруппа = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппа.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ОтборЭлемента = ОтборГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.Зарегистрирован");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = ОтборГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ПриглашениеОтправлено");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Надпись "<Зарегистрирован>".
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЭлектроннаяПочта.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Зарегистрирован, приглашение не требуется>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	// Надпись "<Приглашение отправлено>".
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЭлектроннаяПочта.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ПриглашениеОтправлено");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Приглашение отправлено>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	// Картинка Бизнес-сети, если контрагент не зарегистрирован.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗарегистрированКартинка.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Зарегистрирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#КонецОбласти
