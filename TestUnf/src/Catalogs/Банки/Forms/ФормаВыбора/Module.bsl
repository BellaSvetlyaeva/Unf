
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокНайденныхБанков") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка",
			Параметры.СписокНайденныхБанков, ВидСравненияКомпоновкиДанных.ВСписке);
		Элементы.Список.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы;
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать банк из классификатора.
		|Подобрать?'");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЭтоГруппа", Группа);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОпределитьНеобходимостьПодбораБанкаИзКлассификатора", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Истина, Истина);
	ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура-обработчик результата вопроса о подборе банка из классификатора
//
//
Процедура ОпределитьНеобходимостьПодбораБанкаИзКлассификатора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = КодВозвратаДиалога.Да Тогда
		
		ПараметрыФормы = Новый Структура("РежимВыбора, ЗакрыватьПриВыборе, МножественныйВыбор", Истина, Истина, Истина);
		ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, ЭтотОбъект);
		
	Иначе
		
		Если ДополнительныеПараметры.ЭтоГруппа Тогда
			
			ОткрытьФорму("Справочник.Банки.ФормаГруппы", Новый Структура("ЭтоГруппа",Истина), ЭтотОбъект);
			
		Иначе
			
			ОткрытьФорму("Справочник.Банки.ФормаОбъекта");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
