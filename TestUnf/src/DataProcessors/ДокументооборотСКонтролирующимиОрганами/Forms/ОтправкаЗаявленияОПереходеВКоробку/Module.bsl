&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПереходВКоробку 			= Параметры.ЭтоПереходВКоробку;
	Организация 				= Параметры.Организация;
	СвойстваКриптопровайдера 	= Параметры.СвойстваКриптопровайдера; // не сохраняется в реквизиты
	ТипКриптопровайдера 		= Параметры.ТипКриптопровайдера;
	
	ПредставлениеКриптопровайдера 	= СвойстваКриптопровайдера.Представление;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Успешная отправка заявления на переход" Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОтправитьЗаявлениеЗавершение", 
			ЭтотОбъект);
			
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ОписаниеОповещения);
		ДополнительныеПараметры.Вставить("РезультатОтправки", 	  Истина);
			
		Оповестить("Длительная отправка. Выполняемое оповещение", ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявление(Команда)
	
	ДополнительныеПараметры = ДлительнаяОтправкаКлиент.ПараметрыДлительнойОтправкиЗаявления();
	ДополнительныеПараметры.Вставить("Организация", 			Организация);
	ДополнительныеПараметры.Вставить("ЭтоПереходВКоробку", 		ЭтоПереходВКоробку);
	ДополнительныеПараметры.Вставить("ТипКриптопровайдера", 	ТипКриптопровайдера);
	
	КонтекстЭДОКлиент.СформироватьИОтправитьЗаявлениеНаПереход(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	ТекстЗаголовка = НСтр("ru = 'Перенос ключа на рабочий компьютер по %1'");
	Заголовок = СтрШаблон(ТекстЗаголовка, Организация);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	УстановитьЗаголовок();
	
	Подстрока1 	= Элементы.УказаниеКриптопровайдера.Заголовок;
	Подстрока1	= СтрШаблон(Подстрока1, "");
	
	Шрифт 		= Новый Шрифт(Элементы.УказаниеКриптопровайдера.Шрифт,,,Истина);
	Подстрока2 	= Новый ФорматированнаяСтрока(ПредставлениеКриптопровайдера, Шрифт);
	
	Элементы.УказаниеКриптопровайдера.Заголовок = Новый ФорматированнаяСтрока(Подстрока1, Подстрока2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Истина Тогда
		Если Открыта() Тогда
			
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("Организация", 		Организация);
			ДополнительныеПараметры.Вставить("ЗаявлениеОтправлено", Истина);
		
			Закрыть(ДополнительныеПараметры);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти