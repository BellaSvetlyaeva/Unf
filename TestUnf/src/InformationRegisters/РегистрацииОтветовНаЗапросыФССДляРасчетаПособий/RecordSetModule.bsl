#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Состояние = СостояниеРегистрации(Запись);
	КонецЦикла;
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	Фильтр = Новый Структура("Состояние", Перечисления.СостоянияДокументаСЭДОФСС.Принят);
	ПринятыеОтветыНаЗапросы = Выгрузить().Скопировать(Фильтр, "ИсходящийДокумент").ВыгрузитьКолонку("ИсходящийДокумент");
	Если ПринятыеОтветыНаЗапросы.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВходящийЗапросФССДляРасчетаПособия.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК ВходящийЗапросФССДляРасчетаПособия
		|ГДЕ
		|	ВходящийЗапросФССДляРасчетаПособия.ОтветНаЗапрос В(&ПринятыеОтветыНаЗапросы)
		|	И НЕ ВходящийЗапросФССДляРасчетаПособия.Обработан";
		Запрос.УстановитьПараметр("ПринятыеОтветыНаЗапросы", ПринятыеОтветыНаЗапросы);
		УстановитьПривилегированныйРежим(Истина);
		МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Для Каждого ВходящийЗапрос Из МассивСсылок Цикл
			ВходящийЗапросОбъект = ВходящийЗапрос.ПолучитьОбъект();
			ВходящийЗапросОбъект.Обработан = Истина;
			СЭДОФСС.ЗаписатьДокумент(ВходящийЗапросОбъект, Истина);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СостояниеРегистрации(Запись)
	
	Если Не ЗначениеЗаполнено(Запись.ДатаОтправки) И Не ЗначениеЗаполнено(Запись.ДатаОтправкиОператору) Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ПустаяСсылка(); // Не отправлен.
		
	ИначеЕсли ЗначениеЗаполнено(Запись.ДоставкаТекстОшибки) Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ОшибкаПриОтправке; // Ошибка при отправке.
		
	ИначеЕсли Запись.ЕстьОшибкиЛогическогоКонтроля Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ОшибкаЛогическогоКонтроля; // Отправлен, получены ошибки.
		
	ИначеЕсли Запись.Зарегистрирован Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.Принят;
		
	ИначеЕсли ВРег(Запись.РегистрацияСтатус) = "RECEIVED" Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.Отправлен; // Отправлен, но не зарегистрирован.
		
	ИначеЕсли ВРег(Запись.РегистрацияСтатус) = "ERROR" Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.НеПринят; // Отправлен, но не зарегистрирован.
		
	ИначеЕсли Запись.ОтправленОператору И Не Запись.Доставлен Тогда
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ОтправленОператору; // Передан оператору для доставки.
		
	Иначе
		
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.Отправлен; // Отправлен - заполнена дата отправка, нет информации о статусе.
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти



#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли