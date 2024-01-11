///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	УстановитьОтбор(Новый Структура("ПоказыватьЗавершенные", ПоказыватьЗавершенные));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Автор", Пользователи.ТекущийПользователь());
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеБизнесПроцессов(Список.УсловноеОформление);
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Метаданные.РегистрыСведений.ДанныеБизнесПроцессов.ПолноеИмя(), 
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтбор(Настройки);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьЗавершенныеПриИзменении(Элемент)
	
	УстановитьОтбор(Новый Структура("ПоказыватьЗавершенные", ПоказыватьЗавершенные));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(,Элементы.Список.ТекущиеДанные.БизнесПроцесс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(,Элемент.ТекущиеДанные.БизнесПроцесс);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПометкаУдаления(Команда)
	БизнесПроцессыИЗадачиКлиент.СписокБизнесПроцессовПометкаУдаления(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиБизнесПроцесса(Команда)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ЗадачиПоБизнесПроцессу",
		Новый Структура("ЗначениеОтбора", Элементы.Список.ТекущиеДанные.БизнесПроцесс));
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрута(Команда)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КартаМаршрутаБизнесПроцесса.Форма", 
		Новый Структура("БизнесПроцесс", Элементы.Список.ТекущиеДанные.БизнесПроцесс));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор(ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Завершен", Ложь,,, Не ПараметрыОтбора["ПоказыватьЗавершенные"]);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Завершен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗавершенныйБизнесПроцесс);
	
КонецПроцедуры

#КонецОбласти
