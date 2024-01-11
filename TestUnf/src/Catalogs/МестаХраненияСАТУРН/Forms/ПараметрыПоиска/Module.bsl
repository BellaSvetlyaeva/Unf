
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыПоиска) Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыПоиска);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИнициализироватьПоляКонтактнойИнформации();
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюЭлементовФормы();
	УправлениеДоступностьюОтборовПоПодтипу();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КодОбъектаПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура БезПодтиповПриИзменении(Элемент)
	
	УправлениеДоступностьюОтборовПоПодтипу();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоПроизводственнаяПлощадкаПриИзменении(Элемент)
	
	УправлениеДоступностьюОтборовПоПодтипу();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоСкладВременногоХраненияПриИзменении(Элемент)
	
	УправлениеДоступностьюОтборовПоПодтипу();
	
КонецПроцедуры

#Область РедактированиеАдреса

&НаКлиенте
Процедура ПредставлениеАдресаПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		Адрес = "";
		Возврат;
	КонецЕсли;
	
	АдресПредставление = Текст;
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// реквизита ВидКонтактнойИнформацииАдресаДоставки.
	ТекстСообщенияОбОшибке = ПредставлениеАдресаПриИзмененииНаСервере(Текст);
	
	Если ЗначениеЗаполнено(ТекстСообщенияОбОшибке) Тогда
		ОчиститьСообщения();
		ИмяПоля = "ПредставлениеАдреса";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщенияОбОшибке,, ИмяПоля);
	КонецЕсли;
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> АдресПредставление Тогда
		АдресПредставление = Элемент.ТекстРедактирования;
		Адрес              = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           Адрес);
	ПараметрыОткрытия.Вставить("Представление",           АдресПредставление);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес организации'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Элемент, СтандартнаяОбработка)
	
	// Сбрасываем как представления, так и внутренние значения полей.
	АдресПредставление = "";
	Адрес              = "";
	ДанныеАдреса = ДанныеАдресаКлиент();
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	АдресПредставление = ВыбранноеЗначение.Представление;
	Адрес              = ВыбранноеЗначение.КонтактнаяИнформация;
	ДанныеАдреса       = ДанныеАдресаКлиент();
	
	УправлениеДоступностьюЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ОчиститьСообщения();
	
	Если Не РеквизитыПоискаКорректны() Тогда	
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	
	Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(GUID) Тогда
		ПараметрыПоиска.Вставить("GUID", GUID);
		Закрыть(ПараметрыПоиска);
		Возврат;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ПараметрыПоиска.Вставить("Идентификатор", Идентификатор);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыПоиска.Вставить("Организация", Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		ПараметрыПоиска.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Статус) Тогда
		ПараметрыПоиска.Вставить("Статус", Статус);
	КонецЕсли;
	
	Если ЭтоПроизводственнаяПлощадка Тогда
		ПараметрыПоиска.Вставить("ЭтоПроизводственнаяПлощадка", ЭтоПроизводственнаяПлощадка);
	КонецЕсли;
	
	Если ЭтоСкладВременногоХранения Тогда
		ПараметрыПоиска.Вставить("ЭтоСкладВременногоХранения",  ЭтоСкладВременногоХранения);
	КонецЕсли;
	
	Если БезПодтипов Тогда
		ПараметрыПоиска.Вставить("БезПодтипов",                 БезПодтипов);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресПредставление) Тогда
		ПараметрыПоиска.Вставить("Адрес",              Адрес);
		ПараметрыПоиска.Вставить("АдресПредставление", АдресПредставление);
		ПараметрыПоиска.Вставить("ДанныеАдреса",       ДанныеАдреса);
	КонецЕсли;
	
	Закрыть(ПараметрыПоиска);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюЭлементовФормы()
	
	УказанИдентификатор = Не ПустаяСтрока(GUID);
	
	УказанРеквизитНеТочногоСоответствия = Не ПустаяСтрока(Наименование)
	                                      Или Не ПустаяСтрока(АдресПредставление);
	
	УказанРеквизитТочногоСоответствия = УказанИдентификатор
		Или ЗначениеЗаполнено(Организация)
		Или ЗначениеЗаполнено(Идентификатор)
		Или ЗначениеЗаполнено(Статус);
	
	Элементы.Идентификатор.Доступность = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.Организация.Доступность   = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.GUIDОбъекта.Доступность   = Не УказанРеквизитНеТочногоСоответствия;
	Элементы.Статус.Доступность        = Не УказанРеквизитНеТочногоСоответствия;
	
	Элементы.ПолноеНаименование.Доступность  = Не УказанРеквизитТочногоСоответствия;
	Элементы.ГруппаПоискПоАдресу.Доступность = Не УказанРеквизитТочногоСоответствия;

	Элементы.GUIDОбъекта.ОтметкаНезаполненного = УказанИдентификатор И НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(GUID);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюОтборовПоПодтипу()
	
	Элементы.ЭтоПроизводственнаяПлощадка.Доступность = Не БезПодтипов;
	Элементы.ЭтоСкладВременногоХранения.Доступность  = Не БезПодтипов;
	Элементы.БезПодтипов.Доступность = Не ЭтоСкладВременногоХранения И Не ЭтоПроизводственнаяПлощадка;
	
	Если БезПодтипов Тогда
		
		ЭтоСкладВременногоХранения  = Ложь;
		ЭтоПроизводственнаяПлощадка = Ложь;
		
	ИначеЕсли ЭтоСкладВременногоХранения Или ЭтоПроизводственнаяПлощадка Тогда
		
		БезПодтипов = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РеквизитыПоискаКорректны()

	Отказ = Ложь;
	
	Если Не ПустаяСтрока(GUID)
		И НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(GUID) Тогда
		
		ТекстОшибки = НСтр("ru = 'Неправильно указан идентификатор'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, ,"GUID",, Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресПредставление)
		И ДанныеАдреса = Неопределено Тогда
		ДанныеАдреса = ДанныеАдресаКлиент(Ложь, Отказ);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

#Область РедактированиеАдреса

&НаКлиенте
Функция ДанныеАдресаКлиент(ОчищатьСообщения = Истина, Отказ = Ложь)
	
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияСАТУРНВызовСервера.ДанныеАдресаПоАдресуXML(Адрес, АдресПредставление);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		Если ОчищатьСообщения Тогда
			ОчиститьСообщения();
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПредставлениеАдреса");
		ДанныеАдресаСтруктурой = Неопределено;
		
		Отказ = Истина;
	КонецПопытки;
	
	Возврат ДанныеАдресаСтруктурой;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	// Реквизит формы, контролирующий работу с адресом доставки.
	// Используемые поля аналогичны полям справочника ВидыКонтактнойИнформации.
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип",                          Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("АдресТолькоРоссийский",        Истина);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	
	// Считываем данные из полей адреса в реквизиты для редактирования.
	АдресПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Адрес);
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеАдресаПриИзмененииНаСервере(Знач Представление)
	
	ТекстСообщенияОбОшибке = "";
	
	Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформацииАдреса);
	
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияСАТУРНВызовСервера.ДанныеАдресаПоАдресуXML(Адрес, АдресПредставление);
	Исключение
		ТекстСообщенияОбОшибке = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		ДанныеАдресаСтруктурой = Неопределено;
	КонецПопытки;
	
	ДанныеАдреса = ДанныеАдресаСтруктурой;
	
	Возврат ТекстСообщенияОбОшибке;
	
КонецФункции

#КонецОбласти

#КонецОбласти
