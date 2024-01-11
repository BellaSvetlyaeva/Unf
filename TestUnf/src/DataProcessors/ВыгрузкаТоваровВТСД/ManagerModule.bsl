#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


// Возвращает пустую структуру настроек.
// 
// Возвращаемое значение: 
//  Структура - структура настроек.
//
Функция СтруктураНастроек() Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОбязательныеПоля",               Новый Массив);
	СтруктураНастроек.Вставить("КомпоновщикНастроек",            Неопределено);
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных", Неопределено);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Подготавливает структуру данных.
//
// Параметры:
//  СтруктураНастроек - Структура - структура настреок магазина.
//  Магазин - СправочникСсылка.Магазины - магазин для получения настроек.
//  ФорматМагазина - СправочникСсылка.ФорматыМагазинов - формат магазина.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица значений данных.
//
Функция ПодготовитьСтруктуруДанных(СтруктураНастроек) Экспорт
	
	////////////////////////////////////////////////////////////////////////////////
	// ПОДГОТОВКА СХЕМЫ КОМПОНОВКИ ДАННЫХ И КОМПОНОВЩИКА НАСТРОЕК СКД
	
	// Схема компоновки.
	СхемаКомпоновкиДанных = Обработки.ВыгрузкаТоваровВТСД.ПолучитьМакет(СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных);
	
	// Подготовка компоновщика макета компоновки данных.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Настройки.Отбор.Элементы.Очистить();
	
	// Отбор компоновщика настроек.
	Если СтруктураНастроек.КомпоновщикНастроек <> Неопределено Тогда
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(Компоновщик.Настройки.Отбор, СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор);
	КонецЕсли;
	
	// Выбранные поля компоновщика настроек.
	Для Каждого ОбязательноеПоле Из СтруктураНастроек.ОбязательныеПоля Цикл
		ПолеСКД = ПечатьЭтикетокИСМПУНФ.НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	Параметр = МакетКомпоновкиДанных.ЗначенияПараметров.Найти("Склад");	

	////////////////////////////////////////////////////////////////////////////////
	// ВЫПОЛНЕНИЕ ЗАПРОСА
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновкиДанных);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Таблица = Новый ТаблицаЗначений();
	ПроцессорВывода.УстановитьОбъект(Таблица);
	ДанныеОтчета = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат Таблица;
	
КонецФункции

#КонецЕсли

#КонецОбласти