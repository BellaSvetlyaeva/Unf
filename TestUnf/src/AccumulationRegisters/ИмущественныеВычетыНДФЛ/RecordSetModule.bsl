#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// АПК:277-выкл допустимое исключение
	ИнтеграцияУправлениеПерсоналомСобытия.ИмущественныеВычетыНДФЛПередЗаписью(ЭтотОбъект);
	// АПК:277-вкл
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// АПК:277-выкл допустимое исключение
	ИнтеграцияУправлениеПерсоналомСобытия.ИмущественныеВычетыНДФЛПриЗаписи(ЭтотОбъект);
	// АПК:277-вкл
	
КонецПроцедуры



#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли