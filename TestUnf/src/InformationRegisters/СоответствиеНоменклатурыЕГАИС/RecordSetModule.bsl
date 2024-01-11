#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТаблицаТоваров = Выгрузить(, "Номенклатура,Характеристика");
	ИнтеграцияИСПереопределяемый.ПроверитьЗаполнениеХарактеристикВТаблицеЗначений(ТаблицаТоваров, Отказ);
	
	Если Отказ Тогда
		ШаблонСообщения = НСтр("ru='Поле ""%Характеристика%"" не заполнено'");
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Характеристика%", НСтр("ru = 'Характеристика'"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Характеристика", "Запись", Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли