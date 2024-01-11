
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЭтоДоверенностьФТС = (Параметры.РежимыИспользования = "ФТС");
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.Список.ПодчиненныеЭлементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.ОрганизацияОтбора.Видимость = Ложь;
		
	ИначеЕсли Параметры.Свойство("Отбор") И ТипЗнч(Параметры.Отбор) = Тип("Структура")
		И Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		ОрганизацияОтбора = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
		
		ТипЭлементОтбораКомпоновкиДанных = Тип("ЭлементОтбораКомпоновкиДанных");
		ОтборПоОрганизации = Список.Отбор.Элементы.Добавить(ТипЭлементОтбораКомпоновкиДанных);
		ОтборПоОрганизации.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
		ОтборПоОрганизации.ПравоеЗначение = ОрганизацияОтбора;
		ОтборПоОрганизации.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборПоОрганизации.Использование = Истина;
	КонецЕсли;
	
	ТипЭлементОтбораКомпоновкиДанных = Тип("ЭлементОтбораКомпоновкиДанных");
	ОтборРежимыИспользования = Список.Отбор.Элементы.Добавить(ТипЭлементОтбораКомпоновкиДанных);
	ОтборРежимыИспользования.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РежимыИспользования");
	ОтборРежимыИспользования.ПравоеЗначение = ?(ЭтоДоверенностьФТС, "ФТС", "");
	ОтборРежимыИспользования.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборРежимыИспользования.Использование = Истина;
	
	Если ЭтоДоверенностьФТС Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Машиночитаемые доверенности (ФТС)'");
		Элементы.ГруппаЗагрузить.Видимость = Ложь;
		Элементы.КодНалоговогоОрганаПредставления.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Завершение обновления"
		ИЛИ ИмяСобытия = "Завершение расшифровки"
		ИЛИ ИмяСобытия = "Завершение групповой отправки"
		ИЛИ ТипЗнч(Источник) <> Тип("ФормаКлиентскогоПриложения")
		И (СтрНайти(ИмяСобытия, "Запись_") > 0
		ИЛИ ИмяСобытия = "Завершение отправки в контролирующий орган"
		ИЛИ ИмяСобытия = "Завершение отправки"
		ИЛИ ИмяСобытия = "Актуализация состояния отправки") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтбораПриИзменении(Элемент)
	
	Если Список.Отбор.Элементы.Количество() = 0 Тогда
		ОтборОрганизация = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Иначе
		ОтборОрганизация = Список.Отбор.Элементы[0]
	КонецЕсли;
	ОтборОрганизация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ОтборОрганизация.ПравоеЗначение = ОрганизацияОтбора;
	ОтборОрганизация.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОрганизация.Использование = ЗначениеЗаполнено(ОрганизацияОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДоверенность(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Организация", 			ОрганизацияОтбора);
	ПараметрыФормы.Вставить("РежимыИспользования", 	?(ЭтоДоверенностьФТС, "ФТС", ""));
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиРаспределенныйРеестр.ФормаОбъекта",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьДанныеМЧДРР(ОписаниеОповещения,, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат.СсылкаНаДоверенность) Тогда
		ОткрытьФорму(
			"Справочник.МашиночитаемыеДоверенностиРаспределенныйРеестр.ФормаОбъекта",
			Новый Структура("Ключ, ОбновитьСостояниеПриОткрытии", Результат.СсылкаНаДоверенность, Истина),,
			Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
