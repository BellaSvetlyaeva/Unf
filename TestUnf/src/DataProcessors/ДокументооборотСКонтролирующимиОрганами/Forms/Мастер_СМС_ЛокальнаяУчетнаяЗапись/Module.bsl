#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЭДОКлиент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Инициализация(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключаемый_ОбновитьТелефон();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТелефонМобильныйПриИзменении(Элемент)
	
	ТелефонМобильныйИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаПриИзменении(Элемент)
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТелефонМобильныйИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Представление    = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	ТелефонМобильный = Представление;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		ТелефонМобильный = Текст;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефон");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТелефон", 1.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленияПриИзменении(Элемент)
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ ДанныеУказаныКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
	ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы); 
	ДополнительныеПараметры.Вставить("ПараметрыФормы", 		ПараметрыФормы);
	ДополнительныеПараметры.Вставить("Модифицированность", 	Модифицированность);
	
	Модифицированность = Ложь;
	
	Закрыть(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеУказаныКорректно()

	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	ЭлектроннаяПочтаВведенаКорректно = КонтекстЭДОСервер.ЭлектроннаяПочтаВведенаКорректно(
		ЭлектроннаяПочта,
		Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение,
		Истина);
	
	МобильныйУказанКорректно = ОбработкаЗаявленийАбонентаКлиентСервер.МобильныйУказанКорректно(ЭтотОбъект);

	Возврат ЭлектроннаяПочтаВведенаКорректно И МобильныйУказанКорректно;
	
КонецФункции
 
&НаКлиенте
Процедура Подключаемый_ОбновитьТелефон()
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(ТелефонМобильный);
	
	Если ЗначениеЗаполнено(Представление) Тогда
		ТелефонМобильный = Представление;
		Элементы.ТелефонМобильный.ОбновитьТекстРедактирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;

КонецПроцедуры

&НаСервере
Процедура Инициализация(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
