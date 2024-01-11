#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Код = "" Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	УчетныеЗаписиВнешнихКалендарей.Код КАК Код,
		|	УчетныеЗаписиВнешнихКалендарей.Наименование КАК Наименование
		|ИЗ
		|	Справочник.УчетныеЗаписиВнешнихКалендарей КАК УчетныеЗаписиВнешнихКалендарей
		|ГДЕ
		|	УчетныеЗаписиВнешнихКалендарей.Наименование = &Наименование
		|	И УчетныеЗаписиВнешнихКалендарей.Провайдер = &Провайдер");
		Запрос.УстановитьПараметр("Наименование", ЭтотОбъект.Наименование);
		Запрос.УстановитьПараметр("Провайдер", ЭтотОбъект.Провайдер);
		
		РезультатВыполнения = Запрос.Выполнить();

		Если Не РезультатВыполнения.Пустой() Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.УдалитьНастройкиПоУчетнойЗаписиВнешнегоКалендаря(ЭтотОбъект.Ссылка);
	РегистрыСведений.ДанныеСобытийВнешнихКалендарей.УдалитьСобытияПоУчетнойЗаписиВнешнегоКалендаря(ЭтотОбъект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли


