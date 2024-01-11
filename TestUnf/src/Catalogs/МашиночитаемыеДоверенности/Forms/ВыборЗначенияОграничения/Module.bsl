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
	
	Если Не ЗначениеЗаполнено(Параметры.КодОграничения) Тогда
		ВызватьИсключение НСтр("ru='Не выбран код ограничения'");
	КонецЕсли;
	
	Таблица = МашиночитаемыеДоверенностиФНСПовтИсп.ЗначенияОграничений().Скопировать(
		Новый Структура("КодОграничения", Параметры.КодОграничения));
	ТаблицаЗначенийОграничений.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.ТаблицаЗначенийОграничений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("Код, Наименование",
		Элементы.ТаблицаЗначенийОграничений.ТекущиеДанные.Код,
		Элементы.ТаблицаЗначенийОграничений.ТекущиеДанные.Наименование));
		
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Выбрать(Неопределено);
КонецПроцедуры

#КонецОбласти