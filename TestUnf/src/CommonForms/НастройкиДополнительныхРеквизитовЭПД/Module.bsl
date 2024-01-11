
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипыДокументовЭПД = Новый Структура;
	
	ОбменСГИСЭПД.ПриОпределенииСтандартныхТиповДокументов(ТипыДокументовЭПД);
	
	Для Каждого КиЗ Из ТипыДокументовЭПД Цикл
		Элементы.ТипДокумента.СписокВыбора.Добавить(КиЗ.Значение);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ТипДокумента) Тогда
		ЗаполнитьСписокГруппДанных();	
	КонецЕсли;
	
	УстановитьОтборыДинамическогоСписка();

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьОтборыДинамическогоСписка();
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьСписокГруппДанных()
	
	ГруппаДанных = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ГруппаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипДокумента", ТипДокумента);
	Если ЗначениеЗаполнено(ГруппаДанных) Тогда
		ПараметрыФормы.Вставить("ГруппаДанных", ГруппаДанных);
	КонецЕсли;
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ГруппаДанныхНачалоВыбора_Завершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.НастройкиДополнительныхРеквизитовЭПД.Форма.ФормаВыбораГруппыДанных", 
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ГруппаДанныхНачалоВыбора_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ГруппаДанных = Результат.ГруппаДанных;
		УстановитьОтборыДинамическогоСписка();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ГруппаДанныхПриИзменении(Элемент)
	
	УстановитьОтборыДинамическогоСписка();

КонецПроцедуры


&НаСервере
Процедура УстановитьОтборыДинамическогоСписка()
	
	СписокКонтрагентов = Новый СписокЗначений;
	СписокКонтрагентов.Добавить(Контрагент);
	СписокКонтрагентов.Добавить(Новый(ТипЗнч(Контрагент)));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДополнительныеРеквизиты,
		"Контрагент",
		СписокКонтрагентов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(Контрагент));

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДополнительныеРеквизиты,
		"ТипДокумента",
		ТипДокумента,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(ТипДокумента));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДополнительныеРеквизиты,
		"ГруппаДанных",
		ГруппаДанных,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ГруппаДанных));
		
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Не Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТипДокумента", ТипДокумента);
		ПараметрыФормы.Вставить("ГруппаДанных", ГруппаДанных);
		ОткрытьФорму("РегистрСведений.НастройкиДополнительныхРеквизитовЭПД.Форма.ФормаЗаписи", ПараметрыФормы)
	КонецЕсли;

КонецПроцедуры