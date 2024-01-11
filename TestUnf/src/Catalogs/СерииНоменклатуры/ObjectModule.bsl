#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытийФормы

Процедура ПриЗаписи(Отказ)
	
	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Регистрация ШтрихкодаУпаковки для продукции из натурального меха.
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		ИнтеграцияИСУНФ.ЗарегистрироватьШтрихкодУпаковкиПоСерии(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Если ЭтоНовый() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	СерииНоменклатуры.Ссылка
		|ИЗ
		|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
		|ГДЕ
		|	СерииНоменклатуры.Наименование = &Наименование
		|	И СерииНоменклатуры.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Запрос.УстановитьПараметр("Наименование", СокрЛП(Наименование));
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Для номенклатуры %1 уже введена серия %2'"), Владелец, СокрЛП(Наименование));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИнтеграцияГИСМВызовСервера.ЭтоНомерКиЗ(Наименование) Тогда
		НомерКиЗГИСМ =Наименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли