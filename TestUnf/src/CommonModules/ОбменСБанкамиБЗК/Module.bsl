
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.ОбменСБанками

// См. ОбменСБанкамиПереопределяемый.ПолучитьАктуальныеВидыЭД
Процедура ПолучитьАктуальныеВидыЭД(Массив) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ЗаполнитьАктуальныеВидыЭД(Массив);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ЗаполнитьПараметрыЭДПоИсточнику
Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима
Процедура ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим) Экспорт
	Если СтрНайти(ВРег(Константы.ЗаголовокСистемы.Получить()), ВРег("DirectBank")) > 0 Тогда
		ИспользуетсяТестовыйРежим = Истина;
	КонецЕсли;
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПриФормированииXMLФайла
Процедура ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ЗаполнитьТабличныйДокумент
Процедура ЗаполнитьТабличныйДокумент(Знач ИмяФайла, ТабличныйДокумент) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ЗаполнитьТабличныйДокументПоПрямомуОбменуСБанками(ИмяФайла, ТабличныйДокумент);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПриПолученииXMLФайла
Процедура ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПриОпределенииКомандДиректБанк
Процедура ПриОпределенииКомандДиректБанк(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ЗарплатныеПроекты) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатныеПроектыИспользующиеДиректБанк = Справочники.ЗарплатныеПроекты.ИспользующиеДиректБанк();
	Для Каждого Команда Из Команды Цикл
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(
			Команда.Значение, 
			"ЗарплатныйПроект", 
			ЗарплатныеПроектыИспользующиеДиректБанк, 
			ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЦикла;
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСБанками

#Область УстаревшиеПроцедурыИФункции

// Устарела в версии БЭД 1.6.1. Следует отказаться от использования.
// См. ОбменСБанкамиПереопределяемый.ПодготовитьСтруктуруОбъектовКомандЭДО
Процедура ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО);
КонецПроцедуры

#КонецОбласти


#КонецОбласти

#КонецОбласти


