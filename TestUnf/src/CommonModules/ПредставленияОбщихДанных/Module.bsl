#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработкаПолученияДанныхВыбора(Источник, ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + Параметры.СтрокаПоиска + "%");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Источник.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА Представления.Использовать
	|			ТОГДА Представления.Наименование
	|		ИНАЧЕ Источник.Наименование
	|	КОНЕЦ КАК Наименование
	|ПОМЕСТИТЬ ВТНаименования
	|ИЗ
	|	#Источник КАК Источник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредставленияОснованийУвольнения КАК Представления
	|		ПО Источник.Ссылка = Представления.Объект
	|ГДЕ
	|	&УсловияОтбора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Наименования.Ссылка КАК Ссылка,
	|	Наименования.Наименование КАК Наименование
	|ИЗ
	|	ВТНаименования КАК Наименования
	|ГДЕ
	|	Наименования.Наименование ПОДОБНО &СтрокаПоиска";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Источник", Метаданные.НайтиПоТипу(ТипЗнч(Источник)).ПолноеИмя());
	
	УсловияОтбора = Новый Массив;
	Если Параметры.Свойство("Отбор") И ЗначениеЗаполнено(Параметры.Отбор) Тогда
		
		Для Каждого ЭлементОтбора Из Параметры.Отбор Цикл
			УсловиеСравнения = " = ";
			Если ТипЗнч(ЭлементОтбора.Значение) = Тип("Массив")
				Или ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда
				
				УсловиеСравнения = " В ";
			КонецЕсли;
			ИмяПараметра = "Параметр" + Запрос.Параметры.Количество();
			УсловияОтбора.Добавить("Источник." + ЭлементОтбора.Ключ + " " + УсловиеСравнения + " (&" + ИмяПараметра + ")");
			Запрос.УстановитьПараметр(ИмяПараметра, ЭлементОтбора.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияОтбора) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловияОтбора", СтрСоединить(УсловияОтбора, Символы.ПС + " И "));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловияОтбора", "ИСТИНА");
	КонецЕсли;
	
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает текст запроса в динамическом списке объекта с настраиваемым представлением.
//
// Параметры:
//  Список - ТаблицаФормы - элемент формы динамического списка, для которого устанавливаются свойства.
//
Процедура ПриСозданииНаСервереФормыСДинамическимСписком(Список) Экспорт
	
	Форма = Список.Родитель;
	Пока ТипЗнч(Форма) <> Тип("ФормаКлиентскогоПриложения") Цикл
		Форма = Форма.Родитель;
	КонецЦикла;
	
	ДинамическийСписок = Форма[Список.ПутьКДанным];
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОсновнаяТаблица.Ссылка КАК Ссылка,
		|	ОсновнаяТаблица.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА Представления.Использовать
		|			ТОГДА Представления.Наименование
		|		ИНАЧЕ ОсновнаяТаблица.Наименование
		|	КОНЕЦ КАК Наименование,
		|	ВЫБОР
		|		КОГДА Представления.Использовать
		|			ТОГДА Представления.ТекстОснования
		|		ИНАЧЕ ОсновнаяТаблица.ТекстОснования
		|	КОНЕЦ КАК ТекстОснования
		|ИЗ
		|	#ОсновнаяТаблица КАК ОсновнаяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредставленияОснованийУвольнения КАК Представления
		|		ПО ОсновнаяТаблица.Ссылка = Представления.Объект";
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОсновнаяТаблица.Ссылка КАК Ссылка,
		|	ОсновнаяТаблица.ПометкаУдаления КАК ПометкаУдаления,
		|	ОсновнаяТаблица.Наименование КАК Наименование,
		|	ОсновнаяТаблица.ТекстОснования КАК ТекстОснования
		|ИЗ
		|	#ОсновнаяТаблица КАК ОсновнаяТаблица";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ОсновнаяТаблица", ДинамическийСписок.ОсновнаяТаблица);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = ДинамическийСписок.ОсновнаяТаблица;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса                 = ТекстЗапроса;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Список, СвойстваСписка);
	
КонецПроцедуры

// Устанавливает текст запроса в динамическом списке объекта оснований увольнения с настраиваемым
// представлением.
//
// Параметры:
//  Список - ТаблицаФормы - элемент формы динамического списка, для которого устанавливаются свойства.
//
Процедура ПриСозданииНаСервереФормыОснованийУвольненияСДинамическимСписком(Список) Экспорт
	
	Форма = Список.Родитель;
	Пока ТипЗнч(Форма) <> Тип("ФормаКлиентскогоПриложения") Цикл
		Форма = Форма.Родитель;
	КонецЦикла;
	
	ДинамическийСписок = Форма[Список.ПутьКДанным];
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОсновнаяТаблица.Ссылка КАК Ссылка,
		|	ОсновнаяТаблица.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА Представления.Использовать
		|			ТОГДА Представления.Наименование
		|		ИНАЧЕ ОсновнаяТаблица.Наименование
		|	КОНЕЦ КАК Наименование,
		|	ВЫБОР
		|		КОГДА Представления.Использовать
		|			ТОГДА Представления.ТекстОснования
		|		ИНАЧЕ ОсновнаяТаблица.ТекстОснования
		|	КОНЕЦ КАК ТекстОснования,
		|	ОсновнаяТаблица.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА ОснованияУвольненияВАрхиве.ОснованиеУвольнения ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ВАрхиве
		|ИЗ
		|	#ОсновнаяТаблица КАК ОсновнаяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредставленияОснованийУвольнения КАК Представления
		|		ПО ОсновнаяТаблица.Ссылка = Представления.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОснованияУвольненияВАрхиве КАК ОснованияУвольненияВАрхиве
		|		ПО ОсновнаяТаблица.Ссылка = ОснованияУвольненияВАрхиве.ОснованиеУвольнения
		|{ГДЕ
		|	(ВЫБОР
		|			КОГДА ОснованияУвольненияВАрхиве.ОснованиеУвольнения ЕСТЬ NULL
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ = &ВАрхиве),
		|	(ОсновнаяТаблица.СрокДействия = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ ОсновнаяТаблица.СрокДействия > &РабочаяДата)}";
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОсновнаяТаблица.Ссылка КАК Ссылка,
		|	ОсновнаяТаблица.ПометкаУдаления КАК ПометкаУдаления,
		|	ОсновнаяТаблица.Наименование КАК Наименование,
		|	ОсновнаяТаблица.ТекстОснования КАК ТекстОснования,
		|	ОсновнаяТаблица.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА ОснованияУвольненияВАрхиве.ОснованиеУвольнения ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ВАрхиве
		|ИЗ
		|	#ОсновнаяТаблица КАК ОсновнаяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОснованияУвольненияВАрхиве КАК ОснованияУвольненияВАрхиве
		|		ПО ОсновнаяТаблица.Ссылка = ОснованияУвольненияВАрхиве.ОснованиеУвольнения
		|{ГДЕ
		|	(ВЫБОР
		|			КОГДА ОснованияУвольненияВАрхиве.ОснованиеУвольнения ЕСТЬ NULL
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ = &ВАрхиве),
		|	(ОсновнаяТаблица.СрокДействия = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ ОсновнаяТаблица.СрокДействия > &РабочаяДата)}";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ОсновнаяТаблица", ДинамическийСписок.ОсновнаяТаблица);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = ДинамическийСписок.ОсновнаяТаблица;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса                 = ТекстЗапроса;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Список, СвойстваСписка);
	
КонецПроцедуры

Процедура ПриПолученииДанныхНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ИспользуетсяПредставлениеОбъекта = Ложь;
	Элементы = Форма.Элементы;
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ПредставлениеОбъекта = РегистрыСведений.ПредставленияОснованийУвольнения.СоздатьМенеджерЗаписи();
		Если Не ТекущийОбъект.Ссылка.Пустая() Тогда
			ПредставлениеОбъекта.Объект = ТекущийОбъект.Ссылка;
			ПредставлениеОбъекта.Прочитать();
		КонецЕсли;
		Форма.ЗначениеВРеквизитФормы(ПредставлениеОбъекта, "Представление");
		ИспользуетсяПредставлениеОбъекта = ПредставлениеОбъекта.Использовать;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПредставлениеИспользовать", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаЗаписатьИЗакрыть", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаЗаписать", "Видимость", Истина);
	КонецЕсли;
	
	Если ИспользуетсяПредставлениеОбъекта Тогда
		Элементы.ПредставлениеНаименование.Видимость = Истина;
		Элементы.ПредставлениеТекстОснования.Видимость = Истина;
		Элементы.Наименование.Видимость = Ложь;
		Элементы.ТекстОснования.Видимость = Ложь;
	Иначе
		Элементы.ПредставлениеНаименование.Видимость = Ложь;
		Элементы.ПредставлениеТекстОснования.Видимость = Ложь;
		Элементы.Наименование.Видимость = Истина;
		Элементы.ТекстОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьНаСервере(Форма) Экспорт
	
	Если Форма.Представление.Использовать Тогда
		ПредставлениеОснованияУвольнения = Форма.РеквизитФормыВЗначение("Представление");
		ПредставлениеОснованияУвольнения.Объект = Форма.Объект.Ссылка;
		ПредставлениеОснованияУвольнения.Записать();
	Иначе
		НаборЗаписей = РегистрыСведений.ПредставленияОснованийУвольнения.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Форма.Объект.Ссылка);
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Форма.Модифицированность = Ложь;
	
	ПриПолученииДанныхНаСервере(Форма, Форма.Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Данные.Ссылка);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Представления.Использовать,
		|	Представления.Наименование
		|ИЗ
		|	РегистрСведений.ПредставленияОснованийУвольнения КАК Представления
		|ГДЕ
		|	Представления.Объект = &Ссылка";
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			Если Выборка.Использовать Тогда
				Представление = Выборка.Наименование;
				СтандартнаяОбработка = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
