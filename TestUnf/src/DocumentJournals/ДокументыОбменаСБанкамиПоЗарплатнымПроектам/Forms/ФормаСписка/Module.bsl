#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(
		СтруктураПараметровОтбора, 
		"ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), 
		НСтр("ru = 'Сотрудник'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(
		ЭтотОбъект, 
		"Список",,
		СтруктураПараметровОтбора, 
		"СписокКритерииОтбора");
	
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ПараметрыСозданияФормыСписка = ОбменСБанкамиКлиентСервер.ПараметрыСозданияФормыСписка();
	ПараметрыСозданияФормыСписка.ГруппаКоманд.Добавить = Истина;
	ПараметрыСозданияФормыСписка.ГруппаКоманд.Родитель = Элементы.КоманднаяПанельФормы;
	ПараметрыСозданияФормыСписка.СписокДокументов.МестоРасположения = "Дата";
	
 	ОбменСБанками.ПриСозданииФормыСпискаНаСервере(ЭтотОбъект, ПараметрыСозданияФормыСписка);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЭтотОбъект.Список,
		"ПодтвержденияПолучены",
		НСтр("ru = 'Подтверждения получены'"),
		Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.ОбработатьОповещениеФормыСписка(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
	Если ИмяСобытия = "Запись_ПрисоединенныйФайл" И Параметр.ЭтоНовый Тогда
		ТипыОбъектовДляОповещенияОбИзменении = ТипыОбъектовДляОповещенияОЗаписиФайла(Источник);
		Для Каждого ТипОбъектаДляОповещенияОбИзменении Из ТипыОбъектовДляОповещенияОбИзменении Цикл
			ОповеститьОбИзменении(ТипОбъектаДляОповещенияОбИзменении);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияДокументовЗачисленияЗарплаты"));
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	// ЭлектронноеВзаимодействие.ОбменСБанками
	ОбменСБанкамиКлиент.ПриВыбореСтрокиИзСпискаДокументов(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);	
	// Конец ЭлектронноеВзаимодействие.ОбменСБанками
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСБанками
&НаКлиенте
Процедура Подключаемый_ВыполнитьСинхронизациюДиректБанк(Команда)
     ОбменСБанкамиКлиент.СинхронизироватьСБанком();
 КонецПроцедуры
 
  &НаКлиенте
Процедура Подключаемый_ОбработатьСобытиеДиректБанк(
	Параметр1 = Неопределено,
	Параметр2 = Неопределено,
	Параметр3 = Неопределено)
	ОбменСБанкамиКлиент.ОбработатьСобытиеНаФормеСписка(Параметр1, Параметр2, Параметр3)
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСБанками

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТипыОбъектовДляОповещенияОЗаписиФайла(Источник)
	
	МассивТипов = Новый Массив;
	ТипОбъекта = ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы));
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
	
	Если ТипЗнч(Источник) = Тип("Массив") Тогда
		Для каждого ПрисоединенныйФайл Из Источник Цикл
			Если МетаданныеОбъекта.РегистрируемыеДокументы.Содержит(ПрисоединенныйФайл.ВладелецФайла.Метаданные()) Тогда
				ТипДокумента = ТипЗнч(ПрисоединенныйФайл.ВладелецФайла);
				Если МассивТипов.Найти(ТипДокумента) = Неопределено Тогда
					МассивТипов.Добавить(ТипДокумента);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если МетаданныеОбъекта.РегистрируемыеДокументы.Содержит(Источник.ВладелецФайла.Метаданные()) Тогда
			ТипДокумента = ТипЗнч(Источник.ВладелецФайла);
			Если МассивТипов.Найти(ТипДокумента) = Неопределено Тогда
				МассивТипов.Добавить(ТипДокумента);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивТипов;
	
КонецФункции

#КонецОбласти
