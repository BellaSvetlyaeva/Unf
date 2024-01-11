///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОнлайнОплаты".
// ОбщийМодуль.ОнлайнОплатыВызовСервера.
//
// Серверные процедуры настройки использования интеграции и настройки регламентных заданий онлайн оплат:
//  - установка признака использования интеграции;
//  - включение регламентных заданий, настройка расписания.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Включает/отключает использование регламентного задания ПолучениеУведомленийОтОнлайнОплат.
//
// Параметры:
//  ЗначениеНастройки - Булево - признак использования задания.
//
Процедура ИспользоватьАвтоматическоеПолучениеУведомленияОтОнлайнОплат(Знач ЗначениеНастройки) Экспорт
	
	ОнлайнОплаты.УстановитьПараметрЗаданияПолученияУведомленийОнлайнОплат("Использование", ЗначениеНастройки);
	
КонецПроцедуры

// Возвращает расписание регламентного задания ПолучениеУведомленийОтОнлайнОплат.
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания - расписание задания ПолучениеУведомленийОтОнлайнОплат.
//  Неопределено - если задание не найдено.
//
Функция РасписаниеЗаданияПолучениеУведомленияОтОнлайнОплат() Экспорт
	
	Задание = ОнлайнОплаты.НайтиРегламентноеЗадание("ПолучениеУведомленийОтОнлайнОплат");
	Если Задание <> Неопределено Тогда
		Возврат Задание.Расписание;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Устанавливает расписание регламентного задания ПолучениеУведомленийОтОнлайнОплат.
//
// Параметры:
//  Расписание - РасписаниеРегламентногоЗадания - расписание задания ПолучениеУведомленийОтОнлайнОплат.
//
Процедура УстановитьРасписаниеЗаданияПолучениеУведомленияОтОнлайнОплат(Знач Расписание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ОнлайнОплаты.УстановитьПараметрЗаданияПолученияУведомленийОнлайнОплат("Расписание", Расписание); 
	
КонецПроцедуры

// Обновляет настройку использования интеграции с онлайн оплатами.
//
// Параметры:
//  Значение - Булево - новое значение настройки использования.
//
Процедура УстановитьИспользованиеИнтеграции(Знач Значение) Экспорт
	
	ОнлайнОплаты.УстановитьИспользованиеИнтеграции(Значение);
	
КонецПроцедуры

#КонецОбласти