
#Область ПрограммныйИнтерфейс

// Определяет дополнительные параметры, которые будут выгружены в сервис рассылок при экспорте контактов.
//
// Параметры:
//  ОписаниеПолей - ТаблицаЗначений - Возвращаемое значение. Таблица, содержащая выгружаемые параметры:
//   * Имя - Строка - Уникальное имя параметра.
//   * Представление - Строка - Представление параметра, отображается пользователю.
//
Процедура ПриОпределенииПользовательскихПолейАдреснойКниги(ОписаниеПолей) Экспорт
	
	НовоеПоле = ОписаниеПолей.Добавить();
	НовоеПоле.Имя = "smallbiz_1c_type";
	НовоеПоле.Представление = НСтр("ru='Тип контакта 1С'");
	
	НовоеПоле = ОписаниеПолей.Добавить();
	НовоеПоле.Имя = "smallbiz_1c_baseName";
	НовоеПоле.Представление = НСтр("ru='Наименование'");
	
	НовоеПоле = ОписаниеПолей.Добавить();
	НовоеПоле.Имя = "smallbiz_1c_fullName";
	НовоеПоле.Представление = НСтр("ru='Юридическое название'");
	
	НовоеПоле = ОписаниеПолей.Добавить();
	НовоеПоле.Имя = "smallbiz_1c_managerName";
	НовоеПоле.Представление = НСтр("ru='Ответственный'");
	
	НовоеПоле = ОписаниеПолей.Добавить();
	НовоеПоле.Имя = "smallbiz_1c_promocode";
	НовоеПоле.Представление = НСтр("ru='Промокод'");
	
КонецПроцедуры

// Позволяет дополнить выгружаемые параметры контакта при экспорте.
//
// Параметры:
//  Контакт - ОпределяемыйТип.КонтактСобытия - Экспортируемый контакт.
//  ДанныеПолучателя - Структура - Возвращаемое значение. Содержит передаваемые параметры в сервис:
//   * Ключ - Строка - Имя параметра, определенное в ПриОпределенииПользовательскихПолейАдреснойКниги().
//   * Значение - Строка - Значение параметра.
//
Процедура ПриДобавленииПолейПолучателяАдреснойКниги(Контакт, ДанныеПолучателя) Экспорт
	
 	Если ТипЗнч(Контакт) = Тип("Строка") Тогда
		ДанныеПолучателя.Вставить("smallbiz_1c_baseName", Контакт);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контакт) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыКонтакта = Новый Структура;
	РеквизитыКонтакта.Вставить("Наименование");
	РеквизитыКонтакта.Вставить("Ответственный");
	РеквизитыКонтакта.Вставить("ОтветственныйНаименование", "Ответственный.Наименование");
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") Тогда
		РеквизитыКонтакта.Вставить("НаименованиеПолное");
	КонецЕсли;
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Лиды") ИЛИ ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактыЛидов") Тогда
		РеквизитыКонтакта.Вставить("НаименованиеКомпании");
	КонецЕсли;
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактыЛидов") Тогда
		ДанныеКонтакта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контакт.Владелец, РеквизитыКонтакта);
		ДанныеКонтакта.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контакт, "Наименование");
	Иначе
		ДанныеКонтакта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контакт, РеквизитыКонтакта);
	КонецЕсли;
	
	ДанныеПолучателя.Вставить("smallbiz_1c_type", ИмяТипаКонтактаПоСсылке(Контакт));
	ДанныеПолучателя.Вставить("smallbiz_1c_baseName", ДанныеКонтакта.Наименование);
	
	Если ДанныеКонтакта.Свойство("НаименованиеПолное") Тогда
		ДанныеПолучателя.Вставить("smallbiz_1c_fullName", ДанныеКонтакта.НаименованиеПолное);
	КонецЕсли;
	Если ДанныеКонтакта.Свойство("НаименованиеКомпании") Тогда
		ДанныеПолучателя.Вставить("smallbiz_1c_fullName", ДанныеКонтакта.НаименованиеКомпании);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеКонтакта.Ответственный) Тогда
		ДанныеПолучателя.Вставить("smallbiz_1c_managerName", ДанныеКонтакта.ОтветственныйНаименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяТипаКонтактаПоСсылке(Ссылка)
	
	Возврат ТипыКонтактов().Получить(ТипЗнч(Ссылка));
	
КонецФункции

Функция ТипыКонтактов()
	
	ТипыКонтактов = Новый Соответствие;
	ТипыКонтактов.Вставить(Тип("СправочникСсылка.КонтактныеЛица"), НСтр("ru='Контакт'"));
	ТипыКонтактов.Вставить(Тип("СправочникСсылка.Контрагенты"), НСтр("ru='Контрагент'"));
	ТипыКонтактов.Вставить(Тип("СправочникСсылка.Лиды"), НСтр("ru='Лид'"));
	ТипыКонтактов.Вставить(Тип("СправочникСсылка.КонтактыЛидов"), НСтр("ru='Лид'"));
	
	Возврат ТипыКонтактов;
	
КонецФункции

#КонецОбласти