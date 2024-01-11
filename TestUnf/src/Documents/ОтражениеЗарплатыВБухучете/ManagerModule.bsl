#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ОтражениеЗарплатыВБухучете;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти


Функция ТребуетсяУтверждениеДокументаБухгалтером(Организация = Неопределено) Экспорт
	
	// Подтверждение требуется, если используется обмен с бухгалтерией.
	ТребуетсяУтверждение = Ложь;
	
	// ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3")
		И Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		ТребуетсяУтверждение = Модуль.ОбменИспользуется(Организация);
		
	КонецЕсли;
	// Конец ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	
	ОтражениеЗарплатыВБухучетеПереопределяемый.ТребуетсяУтверждениеДокументаБухгалтером(Организация, ТребуетсяУтверждение);
	
	Возврат ТребуетсяУтверждение;
	
КонецФункции

#КонецОбласти

#КонецЕсли 