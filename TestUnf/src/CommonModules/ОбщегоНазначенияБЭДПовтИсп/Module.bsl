#Область СлужебныйПрограммныйИнтерфейс

// См. ЭлектронноеВзаимодействие.НайтиСсылку
Функция НайтиСсылку(ТипОбъекта, Идентификатор = "", ДополнительныеРеквизиты = Неопределено) Экспорт
	
	Результат = Неопределено;
	ЭлектронноеВзаимодействиеПереопределяемый.НайтиСсылкуНаОбъект(ТипОбъекта, Результат, Идентификатор,
		ДополнительныеРеквизиты);
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя прикладного справочника по имени библиотечного справочника.
//
// Параметры:
//  ИмяСправочника - строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  ИмяПрикладногоСправочника - строковое имя прикладного справочника.
//
Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	СоответствиеСправочников = Новый Соответствие;
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеСправочников(СоответствиеСправочников);
	
	ИмяПрикладногоСправочника = СоответствиеСправочников.Получить(ИмяСправочника);
	
	Возврат ИмяПрикладногоСправочника;
	
КонецФункции

// См. ОбщегоНазначенияБЭД.ЗначениеФункциональнойОпции
Функция ЗначениеФункциональнойОпции(НаименованиеФО) Экспорт
	
	Возврат ОбщегоНазначенияБЭД.ЗначениеФункциональнойОпции(НаименованиеФО);
	
КонецФункции

// Получение имени объекта или реквизита в прикладном решении.
//
// Параметры:
//  ИмяПараметра - Строка - наименование в библиотеке электронных документов.
// 
// Возвращаемое значение:
//  Строка - наименование в прикладном решении.
//
Функция ИмяНаличиеОбъектаРеквизитаВПрикладномРешении(ИмяПараметра) Экспорт
	
	СоответствиеРеквизитовОбъекта = Новый Соответствие;
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов(СоответствиеРеквизитовОбъекта);
	
	Возврат СоответствиеРеквизитовОбъекта.Получить(ИмяПараметра);
	
КонецФункции

#КонецОбласти