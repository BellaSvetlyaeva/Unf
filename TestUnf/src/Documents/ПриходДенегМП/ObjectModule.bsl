#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Движения по регистру ДенежныеСредства Приход.
	Движения.ДенежныеСредстваМП.Записывать = Истина;
	Движение = Движения.ДенежныеСредстваМП.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Статья = Статья;
	Движение.Сумма = Сумма;
	
	// Движения по регистру ВзаиморасчетыСКонтрагентами Приход.
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Движения.ВзаиморасчетыСКонтрагентамиМП.Записывать = Истина;
		Движение = Движения.ВзаиморасчетыСКонтрагентамиМП.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Сумма = Сумма;
	КонецЕсли;
	
	Движения.Записать();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Основание = Неопределено;
	Комментарий = "";
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбщегоНазначенияМПВызовСервера.СтатьяЭтоРасчетыСКонтрагентами(Статья) Тогда
		ПроверяемыеРеквизиты.Добавить("Контрагент");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли