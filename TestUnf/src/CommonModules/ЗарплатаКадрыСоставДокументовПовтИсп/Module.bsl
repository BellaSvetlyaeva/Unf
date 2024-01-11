// @strict-types


#Область СлужебныеПроцедурыИФункции

// Возвращает метаданные документов, в которых используется краткий состав.
// 
// Возвращаемое значение:
//  Массив из ОбъектМетаданных
Функция ДокументыИспользующиеКраткийСостав() Экспорт
	
	ТипыОбъектов = Метаданные.ОпределяемыеТипы.ДокументПоФизическомуЛицуОбъект.Тип.Типы();
	
	МетаданныеОбъектов = Новый Массив;
	Для Каждого ТипОбъекта Из ТипыОбъектов Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
		ОписаниеДокумента = ЗарплатаКадрыСоставДокументов.ОписаниеОбъектаПоПолномуИмени(МетаданныеОбъекта.ПолноеИмя());
		Если ОписаниеДокумента = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ОписаниеДокумента.ИспользоватьКраткийСостав Тогда
			МетаданныеОбъектов.Добавить(МетаданныеОбъекта);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МетаданныеОбъектов;
	
КонецФункции

#КонецОбласти
