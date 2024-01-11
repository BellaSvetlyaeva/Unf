
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройку интеграции с платежными системами на основании
// данных продажи / возврата
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияРМК - организация из документа продажи;
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектРМК - касса из документа продажи;
//
// Возвращаемое значение:
//  ТаблицаЗначений - настройки интеграции с платежной системой.
//
Функция НастройкиИнтеграции(Организация, ТорговыйОбъект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("ТорговыйОбъект", ТорговыйОбъект);
	
	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьТекстЗапросаНастройкиИнтеграции(Запрос);
	
	Если Не ЗначениеЗаполнено(Запрос.Текст) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	Интеграции 		 = РезультатЗапроса.Выгрузить();
	
	Если Интеграции.Количество() > 0 Тогда
		Возврат Интеграции;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция НастроенаОплатаПлатежнойСистемой() Экспорт
	
	НастройкиПодключения = Новый Структура();
	
	НастройкиПодключения.Вставить("ИспользоватьОплатуПлатежнымиСистемами",	Ложь);
	НастройкиПодключения.Вставить("ИспользоватьОплатуСБП", 					Ложь);
	НастройкиПодключения.Вставить("ИспользоватьОплатуЮКасса", 				Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", 	Неопределено);
	Запрос.УстановитьПараметр("ТорговыйОбъект", Неопределено);
	
	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьТекстЗапросаНастройкиИнтеграции(Запрос);

	Если ЗначениеЗаполнено(Запрос.Текст)Тогда
	
		УстановитьПривилегированныйРежим(Истина);

		РезультатЗапроса = Запрос.Выполнить();
		ТипыИнтеграций	 = РезультатЗапроса.Колонки.Интеграция.ТипЗначения;
	
		Для Каждого ТипИнтеграции Из РезультатЗапроса.Колонки.Интеграция.ТипЗначения.Типы() Цикл
		
			МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипИнтеграции);
			ВидОбъекта 		  = ?(МетаданныеОбъекта = Неопределено, "", МетаданныеОбъекта.ПолноеИмя());
		
			Если ВидОбъекта = "Справочник.НастройкиИнтеграцииСПлатежнымиСистемами" Тогда

				НастройкиПодключения.ИспользоватьОплатуСБП 					= Истина;
				НастройкиПодключения.ИспользоватьОплатуПлатежнымиСистемами 	= Истина;
				
			ИначеЕсли ВидОбъекта = "Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей" Тогда

				НастройкиПодключения.ИспользоватьОплатуСБП 					= Истина;
				НастройкиПодключения.ИспользоватьОплатуПлатежнымиСистемами 	= Истина;
				
			ИначеЕсли ВидОбъекта = "Справочник.НастройкиОнлайнОплат" Тогда

				НастройкиПодключения.ИспользоватьОплатуЮКасса 				= Истина;
				НастройкиПодключения.ИспользоватьОплатуПлатежнымиСистемами 	= Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат НастройкиПодключения;
	
КонецФункции


#КонецОбласти

#КонецЕсли
