#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьНаименование();
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ВходящийКонтекст)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ОбработкаЗаполненияОбъекта(ЭтотОбъект, ВходящийКонтекст);
	
	Если ТипЗнч(ВходящийКонтекст) = Тип("Структура") Тогда
	
		Если ВходящийКонтекст.Свойство("Организация") 
			И ЗначениеЗаполнено(ВходящийКонтекст.Организация) Тогда
			Организация = ВходящийКонтекст.Организация;
		КонецЕсли;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(Организация) 
			И РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			Модуль 		= ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			Организация = Модуль.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ВходящийКонтекст) = Тип("Структура")
		И ВходящийКонтекст.Свойство("Отпечаток")
		И ВходящийКонтекст.Свойство("ДвДанныеСертификата") Тогда
		
		ДвДанныеСертификата	= ВходящийКонтекст.ДвДанныеСертификата;
		Отпечаток			= ВходящийКонтекст.Отпечаток;
		
	КонецЕсли;
	
	Сертификат = Новый ХранилищеЗначения(ДвДанныеСертификата);
	
	Дата = МестноеВремя(ТекущаяДатаСеанса(), ЧасовойПоясСеанса());
	
	ПометкаУдаления = Ложь;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	ПометкаУдаления = Ложь;
	Получатель = Документы.УведомлениеОПредоставленииПолномочийПредставителю.ПолучательУведомления(Организация);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьПолучателя(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПолучателя(Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Получатель";

	Если ЗначениеЗаполнено(Организация) Тогда
		
		КодОрганаПФР = "";
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		КонтекстЭДОСервер.ОпределитьОрганПФРОрганизации(Организация, КодОрганаПФР);
		
		Если НЕ ЗначениеЗаполнено(Получатель) Тогда
			
			Если ЗначениеЗаполнено(КодОрганаПФР) Тогда
				
				УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
				Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
					
					ПолучательПоКоду = Справочники.ОрганыПФР.НайтиПоКоду(КодОрганаПФР);
					
					Если НЕ ЗначениеЗаполнено(ПолучательПоКоду) Тогда
						
						РезультатПроверкиТекстОшибки = "Направление ПФР " + КодОрганаПФР + " не подключено. ";
						РезультатПроверки.ТекстОшибки = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
							РезультатПроверкиТекстОшибки, Истина);
						Если УчетнаяЗапись.СпецОператорСвязи = Перечисления.СпецоператорыСвязи.КалугаАстрал Тогда
							РезультатПроверки.ТекстОшибки = РезультатПроверки.ТекстОшибки + "Для подключения направления отправьте заявление на подключение направления 1С-Отчетности";
						Иначе
							РезультатПроверки.ТекстОшибки = РезультатПроверки.ТекстОшибки + "Для подключения направления обратитесь к своему оператору эл. документооборота";
						КонецЕсли;
						
					КонецЕсли;

				Иначе
					РезультатПроверки.ТекстОшибки = "Для отправки уведомления подключите 1С-Отчетность";
				КонецЕсли;
					
			Иначе
				РезультатПроверки.ТекстОшибки = "Укажите код органа ПФР в карточке организации";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецПроцедуры

Процедура ЗаполнитьНаименование() Экспорт
	
	Наименование = СтрШаблон("Уведомление о предоставлении полномочий представителю (СФР)");
	
КонецПроцедуры

Процедура УстановитьОтказ(Отказ, РезультатПроверки)
	
	Если ЗначениеЗаполнено(РезультатПроверки.ТекстОшибки) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстОшибки,ЭтотОбъект,,РезультатПроверки.Поле);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли