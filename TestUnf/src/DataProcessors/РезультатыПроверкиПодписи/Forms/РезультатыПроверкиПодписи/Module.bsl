#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПроверкаПолномочийВыполнялась Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(РезультатПроверки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("СвойстваПодписи") Тогда
		ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	СвойстваПодписи = Новый Структура;
	СвойстваДоверенности = Новый Структура;
	РезультатПроверки = Новый Структура;
	
	Параметры.Свойство("СвойстваПодписи", СвойстваПодписи);
	Параметры.Свойство("СвойстваДоверенности", СвойстваДоверенности);
	Параметры.Свойство("РезультатПроверки", РезультатПроверки);
	Параметры.Свойство("ПодписанныйОбъект", ПодписанныйОбъект);
	Параметры.Свойство("СообщениеЭДО", СообщениеЭДО);
	
	Если СвойстваДоверенности = Неопределено Тогда
		СвойстваДоверенности = МашиночитаемыеДоверенности.НовыеОбщиеСвойстваДоверенности();
	КонецЕсли;
	
	ПолномочияОграничены = СвойстваДоверенности.ПолномочияОграничены;
	
	Если ЗначениеЗаполнено(РезультатПроверки)
		И ЗначениеЗаполнено(РезультатПроверки.ПротоколПроверки) Тогда
		
		ПроверкаПолномочий = РезультатПроверки.ПротоколПроверки.ПроверкаМЧД.ПроверкаПолномочий;
		Если ЗначениеЗаполнено(ПроверкаПолномочий) Тогда
			ПолномочияПодтверждены = ПроверкаПолномочий.Успех;
			ТекстОшибкиПроверкиПолномочий = ПроверкаПолномочий.Ошибка;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(РезультатПроверки.ПротоколПроверки.ПроверкаМЧД.РодительскиеДанныеПолучены) Тогда
			
			НомераДоверенностей = РезультатПроверки.ПротоколПроверки.ПроверкаМЧД.РодительскиеДанныеПолучены.НомерДоверенности;
			
			Если ЗначениеЗаполнено(НомераДоверенностей) Тогда
				
				МассивДоверенностей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(НомераДоверенностей, ",");
				НомерДоверенности = МассивДоверенностей[МассивДоверенностей.ВГраница()];
				
				РодительскаяДоверенность = МашиночитаемыеДоверенностиВызовСервера.ПолучитьДоверенностьИзЖурналаПоНомеру(
					НомерДоверенности);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ПодписьОпределена = СвойстваПодписи <> Неопределено;
	
	Если Не ПодписьОпределена Тогда
		
		СвойстваПодписи = Новый Структура;
		СвойстваПодписи.Вставить("ДатаПроверкиПодписи", ТекущаяДатаСеанса());
		СвойстваПодписи.Вставить("ПодписьВерна", Ложь);
		СвойстваПодписи.Вставить("Комментарий", НСтр("ru = 'Подпись не определена'"));
		
	Иначе
		
		СвойстваПодписи.Свойство("Подпись", Подпись);
		ХешПодписи = КриптографияБЭД.ХешПодписи(Подпись);
		
	КонецЕсли;
	
	ЭлектронныйДокумент = Неопределено;
	СвойстваПодписи.Свойство("Сертификат", Сертификат);
	Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент);
	Параметры.Свойство("ПредставлениеДокумента", ПредставлениеДокумента);
	
	УстановитьУсловноеОформление();

	ОтобразитьПротоколНаФорме(СвойстваПодписи, СвойстваДоверенности, РезультатПроверки);
	
КонецПроцедуры 

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОткрытьМЧДНажатие(Элемент) 
	Если ЗначениеЗаполнено(Доверенность) Тогда
		ПоказатьЗначение( , Доверенность);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМЧДРодителяНажатие(Элемент)
	Если ЗначениеЗаполнено(РодительскаяДоверенность) Тогда
		ПоказатьЗначение(, РодительскаяДоверенность);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НадписьПроверитьПолномочияНажатие(Элемент)
	
	ПроверитьПолномочия();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПроверитьПроверенныеРодительскиеПолномочияНажатие(Элемент)
	
	ПроверитьПолномочия();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОшибкиПроверкиПолномочий

&НаКлиенте
Процедура ОшибкиПроверкиПолномочийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = ОшибкиПроверкиПолномочий[ВыбраннаяСтрока];
	
	Если Поле = Элементы.ОшибкиПроверкиПолномочийДоверенность И ЗначениеЗаполнено(ДанныеСтроки.Ссылка) Тогда
		
		ПоказатьЗначение(, ДанныеСтроки.Ссылка);
		
	ИначеЕсли Поле = Элементы.ОшибкиПроверкиПолномочийПолномочия Тогда
		
		ПоказатьПредупреждение(, ДанныеСтроки.Полномочия,, НСтр("ru = 'Полномочия'"));
		
	ИначеЕсли Поле = Элементы.ОшибкиПроверкиПолномочийТекстОшибки Тогда
		
		ПоказатьПредупреждение(, ДанныеСтроки.ТекстОшибки,, НСтр("ru = 'Результат проверки'"));
		
	ИначеЕсли Поле = Элементы.ОшибкиПроверкиПолномочийПроверка Тогда
		
		Если ЗначениеЗаполнено(ДанныеСтроки.Ссылка) Тогда
			
			ПараметрыПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеПараметрыПроверкиПолномочий();
			ПараметрыПроверки.ПодписанныйОбъект = ПодписанныйОбъект;
			ПараметрыПроверки.ХешПодписи = ХешПодписи;
			ПараметрыПроверки.НоваяДоверенность = ДанныеСтроки.Ссылка;
			ПараметрыПроверки.ТекстОшибки = ДанныеСтроки.ТекстОшибки;
			
			ПараметрыОповещения = Новый Структура("НоваяДоверенность", ДанныеСтроки.Ссылка);
			ОповещениеОЗавершении =
				Новый ОписаниеОповещения("ОбработкаРезультатаПроверкиПолномочий", ЭтотОбъект, ПараметрыОповещения);
			МашиночитаемыеДоверенностиКлиент.ПроверитьПолномочияДоверенностиВручную(
				ПараметрыПроверки, ОповещениеОЗавершении);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьПолномочия()
	
	ПараметрыПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеПараметрыПроверкиПолномочий();
	ПараметрыПроверки.ПодписанныйОбъект = ПодписанныйОбъект;
	ПараметрыПроверки.ХешПодписи = ХешПодписи;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ОбработкаРезультатаПроверкиПолномочий", ЭтотОбъект);
	
	МашиночитаемыеДоверенностиКлиент.ПроверитьПолномочияДоверенностиВручную(ПараметрыПроверки, ОповещениеОЗавершении);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра(
		"ЦветФона", ЦветаСтиля.ЦветФонаНедействительнаяМЧД);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОшибкиПроверкиПолномочий.ДоверенностьНеНастроена");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ОшибкиПроверкиПолномочийТекстОшибки");
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьПротоколНаФорме(СвойстваПодписи, СвойстваДоверенности, РезультатПроверки)
	
	ИмеетсяПротоколПроверки = Ложь; 
	ПроверкаПодписи			= СвойстваПодписи; 
	ПодписьВерна			= СвойстваПодписи.ПодписьВерна;
	ПодписьОписаниеОшибки	= СвойстваПодписи.Комментарий;
	ДатаПроверкиПодписи 	= СвойстваПодписи.ДатаПроверкиПодписи;
	Подписант				= СвойстваПодписи.КомуВыданСертификат;
	
	ТребуетсяДоверенность 	= Ложь;
	ДоверенностьНайдена 	= Ложь;
	
	Если ЗначениеЗаполнено(РезультатПроверки) Тогда 
		ПротоколПроверки 				= РезультатПроверки.ПротоколПроверки;
		ИмеетсяПротоколПроверки 		= ПротоколПроверки <> Неопределено;
		Доверенность 					= РезультатПроверки.Доверенность;
		ДоверенностьНайдена			 	= ЗначениеЗаполнено(Доверенность);
		ТребуетсяДоверенность			= РезультатПроверки.ТребуетсяДоверенность;
		Элементы.ОткрытьМЧД.Видимость 	= ДоверенностьНайдена;
	КонецЕсли;
	
	Если ПодписьВерна Тогда
		Элементы.ЗаголовокПредставлениеПроверки.Заголовок = НСтр("ru='Подпись верна'");
		Элементы.ЗаголовокПредставлениеПроверки.ЦветТекста = ЦветаСтиля.ЦветРазделаПанелиФункций;
		Элементы.ГруппаПроверкиШапка.ЦветФона = ЦветаСтиля.ЦветФонаПодсказки;	
	Иначе 
		Элементы.ЗаголовокПредставлениеПроверки.Заголовок = НСтр("ru='Подпись неверна'");
		Элементы.ЗаголовокПредставлениеПроверки.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
		Элементы.ГруппаПроверкиШапка.ЦветФона = ЦветаСтиля.ЦветФонаПредупреждения;	
	КонецЕсли;
	
	Элементы.ДиагностикаМЧД.Видимость = Истина;
	
	Если ИмеетсяПротоколПроверки И ТребуетсяДоверенность И ДоверенностьНайдена Тогда
		Если ПротоколПроверки.ВерсияПротокола = "2.0" Тогда	
			ПроверкаПодписи 		= ПротоколПроверки.ПроверкаПодписиДокумента;
			ПодписьВерна			= ПроверкаПодписи.Успех;
			ПодписьОписаниеОшибки	= ПроверкаПодписи.Ошибка;
			ДатаПроверкиПодписи		= ПроверкаПодписи.ДатаПроверки;
			
			ПроверкаДоверенности = ПротоколПроверки.ПроверкаМЧД;
			ПоказатьПроверкуМЧД(ПроверкаДоверенности, СвойстваПодписи, СвойстваДоверенности);
		Иначе
			Элементы.ДиагностикаМЧД.Видимость = Ложь;
		КонецЕсли;
	ИначеЕсли ТребуетсяДоверенность И Не ДоверенностьНайдена Тогда
		ПодписьОписаниеОшибки = НСтр("ru='Не найдена подходящая машиночитаемая доверенность.'");
		Элементы.ЗаголовокПредставлениеДоверенности.Видимость = Истина;
		Элементы.ЗаголовокПредставлениеДоверенности.Заголовок = НСтр("ru='Доверенность не найдена'");
		Элементы.ЗаголовокПредставлениеДоверенности.ЦветТекста = ЦветаСтиля.ЦветТекстаНеУдачнаяПроверкаМЧД; 
		Элементы.ГруппаПроверкиШапка.ЦветФона = ЦветаСтиля.ЦветФонаПредупреждения;
		Элементы.ДиагностикаМЧД.Видимость = Ложь;
	Иначе
		Элементы.ДиагностикаМЧД.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ДиагностикаМЧДНеНайдена.Видимость = ТребуетсяДоверенность И НЕ Элементы.ДиагностикаМЧД.Видимость;
	Элементы.ГруппаДоверенностьНеНайденаПояснение.Видимость = ЗначениеЗаполнено(СообщениеЭДО);
	Элементы.ОшибкиПроверкиПолномочий.Видимость = Ложь;
	
	Если ТребуетсяДоверенность И НЕ ДоверенностьНайдена Тогда
		
		Если ИмеетсяПротоколПроверки И ПротоколПроверки.Свойство("ОшибкиПроверкиПолномочий")
			И ПротоколПроверки.ОшибкиПроверкиПолномочий.Количество() > 0 Тогда
			
			Элементы.ОшибкиПроверкиПолномочий.Видимость = Истина;
			
			Для Каждого Ошибка Из ПротоколПроверки.ОшибкиПроверкиПолномочий Цикл
				
				СтрокаТаблицы = ОшибкиПроверкиПолномочий.Добавить();
				СтрокаТаблицы.Доверенность = Ошибка.Доверенность;
				СтрокаТаблицы.ТекстОшибки = Ошибка.ТекстОшибки;
				СтрокаТаблицы.Проверка = НСтр("ru = 'Перейти к
													|ручной проверке'");
				
				СвойстваМЧД = МашиночитаемыеДоверенности.СвойстваДоверенностиПоНомеру(Ошибка.НомерДоверенности);
				СтрокаТаблицы.Ссылка = СвойстваМЧД.Ссылка;
				
				Если ЗначениеЗаполнено(СтрокаТаблицы.Ссылка) Тогда
					
					Если ТипЗнч(СтрокаТаблицы.Ссылка) = Тип("СправочникСсылка.МЧД003") Тогда
						СтрокаТаблицы.Полномочия = Справочники.МЧД003.ТекстПолномочий(СтрокаТаблицы.Ссылка);
					Иначе
						СтрокаТаблицы.Полномочия = МашиночитаемыеДоверенности.ТекстПолномочий(, СтрокаТаблицы.Ссылка);
					КонецЕсли;
					
					СвойстваМЧД.ПравилоПроверки =
						РегистрыСведений.ПравилаПроверкиПолномочийПоМЧД.ПравилоПроверки(СвойстваМЧД.Ссылка);
						
					СвойстваМЧД.ПолномочияУказаныИзКлассификатора =
						МашиночитаемыеДоверенности.ПолномочияМЧДУказаныИзКлассификатора(
						СтрокаТаблицы.Ссылка,
						СвойстваМЧД.ВариантЗаполненияПолномочий);
						
					СтрокаТаблицы.ДоверенностьНеНастроена =
						НЕ МашиночитаемыеДоверенности.ВозможнаАвтопроверкаПолномочий(СвойстваМЧД);
					
				КонецЕсли;
			КонецЦикла;
			
			ШаблонПредупреждения = НСтр("ru = 'Найдены действующие доверенности (%1), но они не подходят по полномочиям.'");
			Элементы.ТекстПредупреждения1.Заголовок =
				СтрШаблон(ШаблонПредупреждения, ОшибкиПроверкиПолномочий.Количество());
				
		Иначе
			
			Элементы.ТекстПредупреждения1.Видимость = Ложь;
			
		КонецЕсли;
		
		Элементы.ТекстПредупреждения2.Заголовок = НСтр("ru = 'Что делать:'");
		
		ТекстРекомендации = НСтр("ru = 'получите от контрагента подходящую доверенность, загрузите ее в программу и проверьте подпись;'");
		Элементы.ТекстРекомендации1.Заголовок = ТекстРекомендации;
		
		ТекстРекомендации = НСтр("ru = 'либо запросите у контрагента этот документ с другой подписью'");
		
		Если ОшибкиПроверкиПолномочий.Количество() = 0 Тогда
			
			Элементы.ТекстРекомендации2.Заголовок = ТекстРекомендации + ".";
			Элементы.ГруппаРекомендации3.Видимость = Ложь;
			Элементы.ГруппаРекомендации4.Видимость = Ложь;
			
		Иначе
			
			Элементы.ТекстРекомендации2.Заголовок = ТекстРекомендации + ";";
			
			ТекстРекомендации = НСтр("ru = 'либо настройте правила проверки полномочий доверенностей и проверьте подпись;'");
			Элементы.ТекстРекомендации3.Заголовок = ТекстРекомендации;
			
			ТекстРекомендации = НСтр("ru = 'либо проверьте полномочия вручную, выбрав одну из найденных доверенностей.'");
			Элементы.ТекстРекомендации4.Заголовок = ТекстРекомендации;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДатаПроверкиПоФормату = ОбщегоНазначенияБЭДКлиентСервер.ДатаВремяБезСекунд(ДатаПроверкиПодписи);
	ТекстЗаголовка = СтрШаблон("%1 %2", НСтр("ru='Проверено'"), ДатаПроверкиПоФормату);
	
	Элементы.ЗаголовокДатаПроверки.Заголовок = ТекстЗаголовка;
	
	Элементы.ГруппаПодписьВерна.Видимость = СвойстваПодписи.ПодписьВерна;
	Элементы.ГруппаПодписьНеВерна.Видимость = Не СвойстваПодписи.ПодписьВерна;
	ПредставлениеПодписьНеВернаПоле = ПодписьОписаниеОшибки;
	
	Если ЗначениеЗаполнено(Доверенность) И НЕ ПолномочияОграничены Тогда
		Элементы.ЗаголовокПроверкаПолномочийВыполненоТекст.Заголовок =
			НСтр("ru = 'Полномочия доверенности не ограничены'");
	КонецЕсли;
	
КонецПроцедуры

// Показывает на форме результат проверки МЧД.
// 
// Параметры:
//  ПроверкаДоверенности см. МашиночитаемыеДоверенности.НовыйПротоколПроверкиМЧД
//  СвойстваПодписи - Структура:
//	  * ДатаПроверкиПодписи - Дата
//	  * ПодписьВерна - Булево
//	  * Комментарий - Строка
//  СвойстваДоверенности - см. МашиночитаемыеДоверенности.НовыеОбщиеСвойстваДоверенности
//  
&НаСервере
Процедура ПоказатьПроверкуМЧД(ПроверкаДоверенности, СвойстваПодписи, СвойстваДоверенности)
	
	ДоверенностьДействует = Истина;
	ДоверенностьОтозвана = Ложь; 
	ДоверенностьОтозванаНаМоментПодписи = Ложь;
	ЭтоПередоверие = ЗначениеЗаполнено(СвойстваДоверенности.НомерРодительскойДоверенности);
	
	РодительскиеДанныеПолучены = ЗначениеЗаполнено(ПроверкаДоверенности.РодительскиеДанныеПолучены)
		И ПроверкаДоверенности.РодительскиеДанныеПолучены.Успех;
		
	МножествоДоверенностей =  ЗначениеЗаполнено(ПроверкаДоверенности.РодительскиеДанныеПолучены)
		И СтрЧислоВхождений(ПроверкаДоверенности.РодительскиеДанныеПолучены, ",");
	
	Элементы.ЗаголовокПредставлениеДоверенности.Видимость = Истина;
	
	Если ЭтоПередоверие Тогда
		Элементы.ЗаголовокМЧД.Заголовок = НСтр("ru = 'Проверка передоверия'");
	КонецЕсли;
	
	Элементы.ГруппаРодителяПередоверия.Видимость = ЭтоПередоверие;
	Элементы.ГруппаРодительскиеДанныеПолучены.Видимость = Не РодительскиеДанныеПолучены;
	Элементы.ГруппаРодительскаяДоверенностьДействительнаВРеестре.Видимость = РодительскиеДанныеПолучены;
	Элементы.ГруппаГруппировкаРодительскихДоверенностей.Видимость = РодительскиеДанныеПолучены;
	Элементы.ОткрытьМЧДРодителя.Видимость = Не МножествоДоверенностей И ЗначениеЗаполнено(РодительскаяДоверенность);
	
	Для Каждого ВложеннаяПроверка Из ПроверкаДоверенности Цикл 
		
		НаименованиеПроверки = ВложеннаяПроверка.Ключ; 
		ГруппаЭлементовПроверки = Элементы.Найти("Группа" + НаименованиеПроверки);
		
		Если ГруппаЭлементовПроверки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПроверкаДоверенности[НаименованиеПроверки] = Неопределено Тогда
			ГруппаЭлементовПроверки.Видимость = Ложь;
			Продолжить;
		КонецЕсли;
		
		УспешнаяПроверка = ПроверкаДоверенности[НаименованиеПроверки].Успех
			И ЗначениеЗаполнено(СвойстваДоверенности.НомерДоверенности);
		ТекстОшибки = ПроверкаДоверенности[НаименованиеПроверки].Ошибка;
		
		Если Не УспешнаяПроверка
			И НЕ ПроверкаДоверенности[НаименованиеПроверки] = ПроверкаДоверенности.ПроверкаОператором Тогда
			ДоверенностьДействует = Ложь;
		КонецЕсли;
		
		НаправлениеСообщения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеЭДО, "Направление");		
		
		Если ПроверкаДоверенности[НаименованиеПроверки] = ПроверкаДоверенности.ПроверкаОтзываМЧД Тогда 
			
			ДоверенностьОтозвана = СвойстваДоверенности.Отозвана;
			
			Если ЗначениеЗаполнено(СвойстваДоверенности.ДатаОтзыва) Тогда
				ДоверенностьОтозванаНаМоментПодписи = СвойстваДоверенности.ДатаОтзыва < СвойстваПодписи.ДатаПодписи;
			КонецЕсли;
			
			УспешнаяПроверка = Не ДоверенностьОтозвана И ЗначениеЗаполнено(СвойстваДоверенности.НомерДоверенности);
			
			ШаблонОшибки = НСтр("ru = 'Отозвана с %1, документ подписан %2'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки,
				ОбщегоНазначенияБЭДКлиентСервер.ДатаВремяБезСекунд(СвойстваДоверенности.ДатаОтзыва),
				ОбщегоНазначенияБЭДКлиентСервер.ДатаВремяБезСекунд(СвойстваПодписи.ДатаПодписи));
			
			Если ДоверенностьОтозвана И Не ДоверенностьОтозванаНаМоментПодписи Тогда 
				
				ТекстЗаголовка = НСтр("ru='Доверенность была отозвана после подписания документа'");
				Элементы.ЗаголовокПроверкаОтзываМЧДНеВыполненоТекст.Заголовок = ТекстЗаголовка;
				Элементы.ЗаголовокПроверкаОтзываМЧДНеВыполненоКартинка.Картинка = БиблиотекаКартинок.ЖелтыйШарБЭД;
				
			КонецЕсли;
			
		ИначеЕсли ПроверкаДоверенности[НаименованиеПроверки] = ПроверкаДоверенности.ПроверкаПолномочий Тогда
			
			ПоказатьКомандуРучнойПроверки = ЗначениеЗаполнено(Доверенность)
				И ЗначениеЗаполнено(СообщениеЭДО)
				И (ТипЗнч(Доверенность) = Тип("СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов")
					ИЛИ ТипЗнч(Доверенность) = Тип("СправочникСсылка.МЧД003") И НаправлениеСообщения = Перечисления.НаправленияЭДО.Входящий)
				И МашиночитаемыеДоверенности.ДоступнаРучнаяПроверка(Доверенность);
			
			Элементы.НадписьПроверитьНепроверенныеПолномочия.Видимость = ПоказатьКомандуРучнойПроверки;
			Элементы.НадписьПроверитьПроверенныеПолномочия.Видимость = ПоказатьКомандуРучнойПроверки;
			
			Если ПроверкаДоверенности.ПроверкаПолномочий.Выполнено
				И НЕ ПроверкаДоверенности.ПроверкаПолномочий.Успех
				И НЕ ПустаяСтрока(ТекстОшибки) Тогда
				Элементы.ЗаголовокПроверкаПолномочийНеВыполненоТекст.Заголовок =
					НСтр("ru = 'Полномочия ограничены и не подтверждены'");
			КонецЕсли;
			
		ИначеЕсли ПроверкаДоверенности[НаименованиеПроверки] = 
			ПроверкаДоверенности.РодительскиеПолномочияСоответствуютПолномочиямПередоверия Тогда
			
			ПоказатьКомандуРучнойПроверки = ЗначениеЗаполнено(РодительскаяДоверенность)
				И НаправлениеСообщения = Перечисления.НаправленияЭДО.Входящий;
			
			Элементы.НадписьРодительскиеПолномочияСоответствуютПолномочиямПередоверияНеВерно.Видимость = ПоказатьКомандуРучнойПроверки;
			Элементы.НадписьРодительскиеПолномочияСоответствуютПолномочиямПередоверияВерно.Видимость = ПоказатьКомандуРучнойПроверки;
			
		КонецЕсли;
		
		ИмяЭлемента = СтрШаблон("Группа%1Выполнено", НаименованиеПроверки);
		Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			Элементы[ИмяЭлемента].Видимость = УспешнаяПроверка;
		КонецЕсли;
		
		ИмяЭлемента = СтрШаблон("Группа%1НеВыполнено", НаименованиеПроверки);
		Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			Элементы[ИмяЭлемента].Видимость = Не УспешнаяПроверка;
		КонецЕсли;
		
		ИмяЭлемента = СтрШаблон("Представление%1НеВыполненоПоле", НаименованиеПроверки);
		Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			ЭтотОбъект[ИмяЭлемента] = ТекстОшибки;
		КонецЕсли;
		
		ИмяЭлемента = СтрШаблон("Группа%1НеВыполненоПодсказка", НаименованиеПроверки);
		Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			Элементы[ИмяЭлемента].Видимость = НЕ УспешнаяПроверка И НЕ ПустаяСтрока(ТекстОшибки);
		КонецЕсли;
		
		ИмяЭлемента = СтрШаблон("Заголовок%1ВыполненоТекст", НаименованиеПроверки);
		Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			ЗаголовокРедактирования = Элементы[ИмяЭлемента].Заголовок;
			СформироватьЗаголовокРодительскихДоверенностей(ЗаголовокРедактирования, МножествоДоверенностей);
			Элементы[ИмяЭлемента].Заголовок = ЗаголовокРедактирования;
		КонецЕсли;
		
		ИмяЭлемента = СтрШаблон("Заголовок%1РучнаяПроверкаТекст", НаименованиеПроверки);
		Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			ЗаголовокРедактирования = Элементы[ИмяЭлемента].Заголовок;
			СформироватьЗаголовокРодительскихДоверенностей(ЗаголовокРедактирования, МножествоДоверенностей);
			Элементы[ИмяЭлемента].Заголовок = ЗаголовокРедактирования;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДоверенностьДействует Тогда 
		Элементы.ЗаголовокПредставлениеДоверенности.Заголовок = НСтр("ru='Доверенность действительна'");
		Элементы.ЗаголовокПредставлениеДоверенности.ЦветТекста = ЦветаСтиля.ЦветРазделаПанелиФункций;
	Иначе  
		Элементы.ЗаголовокПредставлениеДоверенности.Заголовок = НСтр("ru='Доверенность недействительна'");
		Элементы.ЗаголовокПредставлениеДоверенности.ЦветТекста = ЦветаСтиля.ЦветТекстаНеУдачнаяПроверкаМЧД; 
	КонецЕсли;
	
	Если ДоверенностьОтозвана И ДоверенностьОтозванаНаМоментПодписи Тогда 
		Элементы.ЗаголовокПредставлениеДоверенности.Заголовок = НСтр("ru='Доверенность отозвана'");
		Элементы.ЗаголовокПредставлениеДоверенности.ЦветТекста = ЦветаСтиля.ЦветТекстаНеУдачнаяПроверкаМЧД; 
		Элементы.ГруппаПроверкиШапка.ЦветФона = ЦветаСтиля.ЦветФонаПредупреждения;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНовуюДоверенность(НоваяДоверенность)
	
	Результат = Новый Структура("Успех, ПредыдущиеДанные", Ложь, Неопределено);
	
	НачатьТранзакцию();
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		НаборЗаписей = РегистрыСведений.ЭлектронныеПодписиПоМЧД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПодписанныйОбъект.Установить(ПодписанныйОбъект);
		НаборЗаписей.Отбор.ХешПодписи.Установить(ХешПодписи);
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
		НаборЗаписей.Прочитать();
		
		Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
			
			СписокПолей = "ДатаПроверки, Доверенность, ПодписьВерна, ПроверкаВыполнена, ПротоколПроверки";
			Результат.ПредыдущиеДанные = Новый Структура(СписокПолей);
			ЗаполнитьЗначенияСвойств(Результат.ПредыдущиеДанные, ЗаписьНабора);
			
			Результат.Успех = Истина;
			ЗаписьНабора.Доверенность = НоваяДоверенность;
			ЗаписьНабора.ПротоколПроверки = Неопределено;
			ЗаписьНабора.ПроверкаВыполнена = Ложь;
			
			Прервать;
			
		КонецЦикла;
		
		Если Результат.Успех Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		Операция = НСтр("ru = 'Запись проверки полномочий МЧД'");
		ПодробныйТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'Не удалось записать проверку полномочий. Подробности в журнале регистрации'");
		ОбработкаНеисправностейБЭД.ОбработатьОшибку(Операция,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами,
			ПодробныйТекстОшибки, ТекстСообщения, Доверенность);
		ОтменитьТранзакцию();
		
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Результат;
	
КонецФункции

// Обработка результата проверки полномочий.
// 
// Параметры:
//  Результат - Неопределено 
//  		  - Массив из Структура:
//  * ПодписанныйОбъект - СправочникСсылка.СообщениеЭДОПрисоединенныеФайлы
//  * ХешПодписи - Строка
//  * ПолномочияПодтверждены - Булево
//  * ТекстОшибки - Строка
//  ДополнительныеПараметры - Произвольный
&НаКлиенте
Процедура ОбработкаРезультатаПроверкиПолномочий(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Массив") ИЛИ Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("НоваяДоверенность") Тогда
		
		НоваяДоверенность = ДополнительныеПараметры.НоваяДоверенность;
		РезультатЗаписи = ЗаписатьНовуюДоверенность(НоваяДоверенность);
		
		ПараметрыОбработки = Новый Структура();
		ПараметрыОбработки.Вставить("ПредыдущиеДанные", РезультатЗаписи.ПредыдущиеДанные);
		ПараметрыОбработки.Вставить("Результат", Результат);
		ПараметрыОбработки.Вставить("НоваяДоверенность", НоваяДоверенность);
		
		Оповещение = Новый ОписаниеОповещения("ПослеПроверкиПодписей", ЭтотОбъект, ПараметрыОбработки);
		КонтекстДиагностики = ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики();
		ЭлектронныеДокументыЭДОКлиент.ПроверитьПодписиСообщения(Оповещение, СообщениеЭДО, КонтекстДиагностики);
		Возврат;
		
	КонецЕсли;
	
	ЗаписатьНовыйРезультатПроверки(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиПодписей(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат.ПроверенныеПодписи) Тогда
		ЗаписатьНовыйРезультатПроверки(ДополнительныеПараметры.Результат, ДополнительныеПараметры.НоваяДоверенность);
	Иначе
		ВернутьПредыдущийРезультатПроверки(ДополнительныеПараметры.ПредыдущиеДанные);
	КонецЕсли;
	
КонецПроцедуры


// Возвращает предыдущий результат проверки подписи по МЧД.
// 
// Параметры:
//  ПредыдущиеДанные - Структура:
//  * ДатаПроверки - Дата
//  * Доверенность - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
//  * ПодписьВерна - Булево
//  * ПроверкаВыполнена - Булево
//  * ПротоколПроверки  -см. МашиночитаемыеДоверенности.НовыйПротоколПроверкиПодписи
&НаСервере
Процедура ВернутьПредыдущийРезультатПроверки(ПредыдущиеДанные)
	
	НачатьТранзакцию();
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		НаборЗаписей = РегистрыСведений.ЭлектронныеПодписиПоМЧД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПодписанныйОбъект.Установить(ПодписанныйОбъект);
		НаборЗаписей.Отбор.ХешПодписи.Установить(ХешПодписи);
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
		НаборЗаписей.Прочитать();
		ТребуетсяЗапись = Ложь;
		
		Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
			
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ПредыдущиеДанные);
			ТребуетсяЗапись = Истина;
			
		КонецЦикла;
		
		Если ТребуетсяЗапись Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		Операция = НСтр("ru = 'Запись проверки полномочий МЧД'");
		ПодробныйТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'Не удалось записать проверку полномочий. Подробности в журнале регистрации'");
		ОбработкаНеисправностейБЭД.ОбработатьОшибку(Операция,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами,
			ПодробныйТекстОшибки, ТекстСообщения, Доверенность);
		ОтменитьТранзакцию();
		
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНовыйРезультатПроверки(Результат, НоваяДоверенность = Неопределено)
	
	ПроверкаПолномочийВыполнялась = Истина;
	ПолномочияПодтверждены = Результат[0].ПолномочияПодтверждены;
	РезультатПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыйРезультатПроверки();
	РезультатПроверки.Выполнено = Истина;
	РезультатПроверки.Успех = ПолномочияПодтверждены;
	Если НЕ ПолномочияПодтверждены Тогда
		РезультатПроверки.Ошибка = Результат[0].ТекстОшибки;
	КонецЕсли;
	
	ДанныеПроверки = МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеПроверкиПолномочий();
	ДанныеПроверки.ПодписанныйОбъект = Результат[0].ПодписанныйОбъект;
	ДанныеПроверки.ХешПодписи = Результат[0].ХешПодписи;
	ДанныеПроверки.РезультатПроверки = РезультатПроверки;
	ДанныеПроверки.РучнаяПроверка = ПолномочияПодтверждены;
	ДанныеПроверки.НомерРодительскойДоверенности = Результат[0].НомерРодительскойДоверенности;
	
	Если ЗначениеЗаполнено(НоваяДоверенность) Тогда
		
		Доверенность = НоваяДоверенность;
		СвойстваДоверенности = МашиночитаемыеДоверенности.ОбщиеСвойстваДоверенности(Доверенность);
		
	КонецЕсли;
	
	РезультатЗаписи = МашиночитаемыеДоверенностиВызовСервера.ЗаписатьРезультатПроверкиПолномочий(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПроверки));
	
	Если РезультатЗаписи.Успех
		И ЗначениеЗаполнено(РезультатЗаписи.РезультатыПроверкиПодписи) Тогда
		
		РезультатПроверки = РезультатЗаписи.РезультатыПроверкиПодписи[0];
		ОтобразитьПротоколНаФорме(СвойстваПодписи, СвойстваДоверенности, РезультатПроверки);
	
	ИначеЕсли НЕ ПустаяСтрока(РезультатЗаписи.ТекстОшибки) Тогда 
		
		ОбщегоНазначения.СообщитьПользователю(РезультатЗаписи.ТекстОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокРодительскихДоверенностей(ЗаголовокРедактирования, МножествоДоверенностей)
	
	Разделитель = СтрНайти(ЗаголовокРедактирования, "/");
	
	ЗаголовокРедактирования = ?(МножествоДоверенностей, 
		Сред(ЗаголовокРедактирования, Разделитель + 1),
		Сред(ЗаголовокРедактирования, 1, Разделитель - 1));
	
КонецПроцедуры

#КонецОбласти 
