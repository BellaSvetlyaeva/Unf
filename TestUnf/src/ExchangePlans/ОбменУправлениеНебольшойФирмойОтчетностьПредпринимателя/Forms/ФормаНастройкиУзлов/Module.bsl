//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Если Не ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов) Тогда
		ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДатаСеанса());
	КонецЕсли;
	
	РежимСинхронизацииОрганизаций =
		?(ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям")
	;
	
	ПолучитьОписаниеКонтекста();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ИспользоватьОтборПоОрганизациям =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
	Если Не ИспользоватьОтборПоОрганизациям Тогда
		Организации.Очистить();
	КонецЕсли;
	
	ПолучитьОписаниеКонтекста();
	
	ОбменДаннымиКлиент.ФормаНастройкиУзловКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтаФорма[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьОписаниеКонтекста()
	
	// дата начала выгрузки документов
	Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов) Тогда
		ДатаНачалаВыгрузкиДокументовОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Данные будут синхронизироваться, начиная с %1'"),
			Формат(ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
	Иначе
		ДатаНачалаВыгрузкиДокументовОписание = НСтр("ru = 'Данные будут синхронизироваться за весь период ведения учета в программах'");
	КонецЕсли;
	
	// отбор по Организациям
	Если ИспользоватьОтборПоОрганизациям Тогда
		ОрганизацииОписание = НСтр("ru = 'Только по организациям:'") + Символы.ПС + ИспользуемыеЭлементы("Организации");
	Иначе
		ОрганизацииОписание = НСтр("ru = 'По всем организациям.'");
	КонецЕсли;
	
	ОписаниеКонтекста = (""
		+ ДатаНачалаВыгрузкиДокументовОписание
		+ Символы.ПС
		+ Символы.ПС
		+ ОрганизацииОписание);
	
КонецПроцедуры

&НаСервере
Функция ИспользуемыеЭлементы(ИмяТаблицы)
	
	Возврат СтрСоединить(
	ЭтаФорма[ИмяТаблицы].Выгрузить(Новый Структура("Использовать", Истина)).ВыгрузитьКолонку("Представление"),
	Символы.ПС);
	
КонецФункции

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзмененииЗначения()
	
	Элементы.Организации.Доступность =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
КонецПроцедуры


#КонецОбласти
