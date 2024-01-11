#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		ИЛИ ДанныеЗаполнения = Неопределено Тогда
	
		ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
		
	Иначе
		
		Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ЗаполнитьКорректировочноеУведомлениеОВвозеПрослеживаемыхТоваров(
			ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
		
	КонецЕсли;
	
	ПрослеживаемостьПереопределяемый.ОбработкаЗаполненияДокумента(
		ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПрослеживаемостьПереопределяемый.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПрослеживаемостьБРУ.ОбработкаПроведенияУведомление(ПараметрыПроведения, Движения, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПрослеживаемостьПереопределяемый.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	
	Движения.Записать();
	
	ПрослеживаемостьБРУ.ОбработкаУдаленияПроведенияУведомление(Ссылка, ДополнительныеСвойства.Основание);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Основание", 
		?(Ссылка.НомерКорректировки = 0, Ссылка.ПервичныйДокумент, Ссылка.ОснованиеКорректировки));
	
	ПрослеживаемостьБРУ.ПроверитьДублированиеНомераКорректировкиВУведомленияхОВвозе(ЭтотОбъект, РежимЗаписи);
	
	ПрослеживаемостьПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НомерКорректировки = 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("КодТНВЭДПослеИзменения");
		МассивНепроверяемыхРеквизитов.Добавить("КодОКПД2КорректировочныйПослеИзменения");
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмеренияПослеИзменения");
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаПрослеживаемостиПослеИзменения");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтранаПроисхожденияПослеИзменения");
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПрослеживаемости");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Сумма");
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РНПТ) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтранаПроисхождения");
		
	КонецЕсли;
		
	ПрослеживаемостьПереопределяемый.ОбработкаПроверкиЗаполнения(
		ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли