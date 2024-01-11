
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Вызывается при работе в модели сервиса для получения сведений о предопределенных вариантах отчета.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Имя           - Строка - имя варианта отчета; например, "Основной";
//    * Представление - Строка - имя варианта отчета; например, НСтр("ru = 'Динамика изменений файлов'").
//
Функция ВариантыНастроек() Экспорт 
	
	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "ВедомостьКратко", 
		НСтр("ru = 'Взаиморасчеты (кратко)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Ведомость", 
		НСтр("ru = 'Взаиморасчеты'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Остатки", 
		НСтр("ru = 'Остатки по взаиморасчетам'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ВедомостьКраткоКонтекст", 
		НСтр("ru = 'Взаиморасчеты с контрагентом'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "АнализНезачтенныхАвансовКонтекст", 
		НСтр("ru = 'Незачтенные авансы'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Взаиморасчеты, "ВедомостьКраткоКонтекст");
	Вариант.Описание = НСтр("ru = 'Динамика изменения долга контрагента за указанный период.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Взаиморасчеты, "АнализНезачтенныхАвансовКонтекст");
	Вариант.Описание = НСтр("ru = 'Анализ незачтенных авансов при закрытии месяца.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Взаиморасчеты, "Ведомость");
	Вариант.Описание = НСтр("ru = 'Отчет отображает динамику взаиморасчетов с покупателями и поставщиками сводно за выбранный период времени.'");
	Для Каждого РазмещениеВПодсистеме Из Вариант.Размещение Цикл
		Вариант.Размещение.Вставить(РазмещениеВПодсистеме.Ключ, "СмТакже");
	КонецЦикла; 
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Взаиморасчеты, "Остатки");
	Вариант.Описание = НСтр("ru = 'Отчет отображает состояние взаиморасчетов с покупателями и поставщиками сводно за выбранный период времени.'");
	Для Каждого РазмещениеВПодсистеме Из Вариант.Размещение Цикл
		Вариант.Размещение.Вставить(РазмещениеВПодсистеме.Ключ, "СмТакже");
	КонецЦикла; 
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Взаиморасчеты, "ВедомостьКратко");
	Вариант.Описание = НСтр("ru = 'Отчет отображает динамику взаиморасчетов с покупателями и поставщиками сводно за выбранный период времени в валюте расчетов (кратко).'");
	Для Каждого РазмещениеВПодсистеме Из Вариант.Размещение Цикл
		Вариант.Размещение.Вставить(РазмещениеВПодсистеме.Ключ, "Важный");
	КонецЦикла; 
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли