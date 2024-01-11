////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает максимально допустимую длину номера договора в зависимости от версии формата обмена.
//
// Параметры:
//  ФорматФайла - ПеречислениеСсылка.ФорматыФайловОбменаПоЗарплатномуПроекту
//
// Возвращаемое значение:
//  Число
//
Функция МаксимальнаяДлинаНомераДоговора(ФорматФайла) Экспорт
	
	Если ФорматФайла = ПредопределенноеЗначение("Перечисление.ФорматыФайловОбменаПоЗарплатномуПроекту.Версия36")
		Или ФорматФайла = ПредопределенноеЗначение("Перечисление.ФорматыФайловОбменаПоЗарплатномуПроекту.Версия37") Тогда
		Возврат 40;
	Иначе
		Возврат 8;
	КонецЕсли;	
	
КонецФункции	

Функция ПривестиСтрокуКИдентификатору(СтрокаДляПреобразования) Экспорт
	
	СтрокаВИдентификатор = СтрЗаменить(СтрокаДляПреобразования, ".", "_");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "-", "_");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, " ", "");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "~", "");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "%", "");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "/", "");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, ":", "");
	
	Возврат СтрокаВИдентификатор;
	
КонецФункции

#КонецОбласти
