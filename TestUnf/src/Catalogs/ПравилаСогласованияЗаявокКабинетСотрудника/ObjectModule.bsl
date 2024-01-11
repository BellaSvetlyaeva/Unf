#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ШаблонНаименование = НСтр("ru = 'Правило согласования %1'");
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Наименование = СтрШаблон(ШаблонНаименование, Подразделение);
	ИначеЕсли ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Наименование = СтрШаблон(ШаблонНаименование, ФизическоеЛицо);
	Иначе
		Наименование = СтрШаблон(ШаблонНаименование, НСтр("ru = 'для всех (остальных) подразделений'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли