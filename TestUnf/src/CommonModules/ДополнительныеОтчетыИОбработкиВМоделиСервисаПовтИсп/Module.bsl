///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция РегулирующиеКонстанты() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("НезависимоеИспользованиеДополнительныхОтчетовИОбработокВМоделиСервиса");
	Результат.Добавить("ИспользованиеКаталогаДополнительныхОтчетовИОбработокВМоделиСервиса");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

Функция КонтролируемыеРеквизиты() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("БезопасныйРежим");
	Результат.Добавить("ХранилищеОбработки");
	Результат.Добавить("ИмяОбъекта");
	Результат.Добавить("Версия");
	Результат.Добавить("Вид");
	Результат.Добавить("ПометкаУдаления");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

Функция РасширенныеОписанияПричинБлокировки() Экспорт
	
	Причины = Перечисления.ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса;
	
	Результат = Новый Соответствие();
	Результат.Вставить(Причины.БлокировкаАдминистраторомСервиса, 
		НСтр("ru = 'Использование дополнительной обработки запрещено администратором сервиса.'"));
	Результат.Вставить(Причины.БлокировкаВладельцем, 
		НСтр("ru = 'Использование дополнительной обработки запрещено владельцем обработки.'"));
	Результат.Вставить(Причины.ОбновлениеВерсииКонфигурации, 
		НСтр("ru = 'Использование дополнительной обработки временно недоступно. Попробуйте повторить через несколько минут. Приносим извинения на доставленные неудобства.'"));
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти