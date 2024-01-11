
#Область ПрограммныйИнтерфейс

// Подключает глобальный обработчик "ПослеОтправкиСообщения" системы взаимодействия,
// для автоматического удаления отвеченных сообщений из Входящего Контакт-центра.
//
Процедура ПодключитьУдалениеОбсужденийИзВходящего() Экспорт
	
	Обработчик = Новый ОписаниеОповещения("ПослеОтправкиСообщенияОбсуждений", КонтактЦентрКлиент);
	СистемаВзаимодействия.ПодключитьОбработчикПослеОтправкиСообщения(Обработчик);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПослеОтправкиСообщенияОбсуждений(Сообщение, Обсуждение, ДополнительныеПараметры) Экспорт
	
	Если Не ИнтеграцииДоступны() Тогда
		Возврат;
	КонецЕсли;
	
	Если Обсуждение.Интеграция = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтактЦентрВызовСервера.УдалитьИзВходящего(Обсуждение.Идентификатор);
	
	Оповестить("Запись_КонтактЦентрВходящее");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнтеграцииДоступны()
	
	ОписаниеСистемы = Новый СистемнаяИнформация;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии("8.3.17.0", ОписаниеСистемы.ВерсияПриложения) > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
