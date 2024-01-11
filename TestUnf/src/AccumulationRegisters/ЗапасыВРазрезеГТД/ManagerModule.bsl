#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЕстьОстаткиПоЗапасамВРазрезеГТД() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗапасыВРазрезеГТДОстатки.НомерГТД
		|ИЗ
		|	РегистрНакопления.ЗапасыВРазрезеГТД.Остатки КАК ЗапасыВРазрезеГТДОстатки";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРазрезеГТДИзменение") Тогда
		
		Возврат
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ЗапасыВРазрезеГТД.НомерСтроки КАК НомерСтроки,
	|	ЗапасыВРазрезеГТД.Организация КАК Организация,
	|	ЗапасыВРазрезеГТД.Номенклатура КАК Номенклатура,
	|	ЗапасыВРазрезеГТД.НомерГТД КАК НомерГТД,
	|	ЗапасыВРазрезеГТД.Партия КАК Партия,
	|	ЗапасыВРазрезеГТД.Характеристика КАК Характеристика,
	|	ЗапасыВРазрезеГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ЗапасыВРазрезеГТД.Количество КАК КоличествоПередЗаписью,
	|	ЗапасыВРазрезеГТД.Количество КАК КоличествоИзменение,
	|	ЗапасыВРазрезеГТД.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыВРазрезеГТДИзменение
	|ИЗ
	|	РегистрНакопления.ЗапасыВРазрезеГТД КАК ЗапасыВРазрезеГТД");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыВРазрезеГТДИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли