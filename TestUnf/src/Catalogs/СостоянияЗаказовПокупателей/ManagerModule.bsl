#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Если Не НачальноеЗаполнениеЭлементовВыполнено() Тогда
		Элемент = Элементы.Добавить();
		Элемент.Наименование = НСтр("ru='В работе'");
	КонецЕсли;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Завершен";
	Элемент.Наименование = НСтр("ru='Завершен'");
	Элемент.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ПрошедшееСобытие);
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлемента
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	Объект.УстановитьНовыйКод();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Будет удалена в следующей версии.
//
Процедура ЗаполнитьПоставляемыеСостояния() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СостоянияЗаказовПокупателей.Ссылка
		|ИЗ
		|	Справочник.СостоянияЗаказовПокупателей КАК СостоянияЗаказовПокупателей
		|ГДЕ
		|	СостоянияЗаказовПокупателей.Предопределенный = ЛОЖЬ";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		// 1. Состояние "В работе"
		Состояние = Справочники.СостоянияЗаказовПокупателей.СоздатьЭлемент();
		Состояние.Наименование	= НСтр("ru='В работе'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Состояние);
		
		// 2. Состояние "Завершен"
		Состояние = Справочники.СостоянияЗаказовПокупателей.Завершен.ПолучитьОбъект();
		Состояние.Цвет = Новый ХранилищеЗначения(ЦветаСтиля.ПрошедшееСобытие);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Состояние);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить справочник ""Состояния заказов покупателей"" по умолчанию по причине:
				|%1'"), 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.СостоянияЗаказовПокупателей, , ТекстСообщения);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей") Тогда
		Параметры.Вставить("ВидЗаказа", Справочники.ВидыЗаказовПокупателей.Основной);
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	Запрос = Новый Запрос;
	КоличествоЭлементовБыстрогоВыбора = 15;
	ДобавлятьПорядок = Истина;
	
	Если Параметры.Свойство("ВидЗаказа") И ЗначениеЗаполнено(Параметры.ВидЗаказа) Тогда
		
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 15
			|	ВидыЗаказовПокупателейПорядокСостояний.Состояние КАК Состояние,
			|	ВидыЗаказовПокупателейПорядокСостояний.Состояние.Наименование КАК Наименование,
			|	ВидыЗаказовПокупателейПорядокСостояний.Состояние.Цвет КАК Цвет
			|ИЗ
			|	Справочник.ВидыЗаказовПокупателей.ПорядокСостояний КАК ВидыЗаказовПокупателейПорядокСостояний
			|ГДЕ
			|	ВидыЗаказовПокупателейПорядокСостояний.Ссылка = &ВидЗаказа
			|	И ВидыЗаказовПокупателейПорядокСостояний.Состояние.ПометкаУдаления = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	ВидыЗаказовПокупателейПорядокСостояний.НомерСтроки";
		
		Запрос.УстановитьПараметр("ВидЗаказа", Параметры.ВидЗаказа);
		
	Иначе
		
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 15
			|	СостоянияЗаказовПокупателей.Ссылка КАК Состояние,
			|	СостоянияЗаказовПокупателей.Наименование КАК Наименование,
			|	СостоянияЗаказовПокупателей.Цвет КАК Цвет
			|ИЗ
			|	Справочник.СостоянияЗаказовПокупателей КАК СостоянияЗаказовПокупателей
			|ГДЕ
			|	СостоянияЗаказовПокупателей.ПометкаУдаления = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Наименование";
		
		ДобавлятьПорядок = Ложь;
		
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "15", КоличествоЭлементовБыстрогоВыбора);
	Выборка = Запрос.Выполнить().Выбрать();
	НомерПоПорядку = 0;
	ЖирныйШрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);
	
	Пока Выборка.Следующий() Цикл
		
		НомерПоПорядку = НомерПоПорядку + 1;
		Цвет = Выборка.Цвет.Получить();
		Если Цвет = Неопределено Тогда
			Цвет = ЦветаСтиля.ЦветТекстаПоля;
		КонецЕсли;
		
		КомпонентыФС = Новый Массив;
		Если ДобавлятьПорядок Тогда
			КомпонентыФС.Добавить(Строка(НомерПоПорядку) + ". ");
		КонецЕсли;
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(Выборка.Наименование,
			?(Выборка.Состояние = Справочники.СостоянияЗаказовПокупателей.Завершен, ЖирныйШрифт, Неопределено),
			Цвет));
		
		ДанныеВыбора.Добавить(Выборка.Состояние, Новый ФорматированнаяСтрока(КомпонентыФС));	// АПК:1356 Используются локализованные имена состояний
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора
			И Параметры.Свойство("ВидЗаказа") И ЗначениеЗаполнено(Параметры.ВидЗаказа) Тогда
				ВыбраннаяФорма = "Справочник.ВидыЗаказовПокупателей.Форма.ФормаСпискаЭтапов";
	Иначе
		ВыбраннаяФорма = "Справочник.СостоянияЗаказовПокупателей.Форма.ФормаСписка";
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачальноеЗаполнениеЭлементовВыполнено()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЗаказовПокупателей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СостоянияЗаказовПокупателей КАК СостоянияЗаказовПокупателей
	|ГДЕ
	|	СостоянияЗаказовПокупателей.Предопределенный = ЛОЖЬ";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли