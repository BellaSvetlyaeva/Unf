///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОФД".
// ОбщийМодуль.ОФДВызовСервера.
//
// Серверные процедуры настройки подключения к ОФД:
//  - проверка полноправности пользователя.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. ОФДПовтИсп.ЭтоПолноправныйПользователь.
//
Функция ЭтоПолноправныйПользователь() Экспорт
	
	Возврат ОФДПовтИсп.ЭтоПолноправныйПользователь();
	
КонецФункции

// См. ОФДПовтИсп.НастройкаПодключенияДоступна.
//
Функция НастройкаПодключенияДоступна() Экспорт
	
	Возврат ОФДПовтИсп.НастройкаПодключенияДоступна();
	
КонецФункции

#КонецОбласти
