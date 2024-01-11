
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
	Результат.Добавить(Новый Структура("Имя, Представление", "Ведомость", 
		НСтр("ru = 'Товары, переданные на комиссию'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Остатки", 
		НСтр("ru = 'Остатки запасов переданных'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ЗапасыВПереработке", 
		НСтр("ru = 'Запасы, переданные в переработку'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ЗапасыНаОтветхранении", 
		НСтр("ru = 'Запасы, переданные на ответхранение'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПереданные, "Ведомость");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о товарах, переданных на комиссию за указанный период времени.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Продажи.Подсистемы.ТоварыИУслуги, "Важный");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Закупки.Подсистемы.ТоварыИУслуги, "Важный");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Склад.Подсистемы.Склад, "Важный");
	Вариант.ФункциональныеОпции.Добавить("ПередачаТоваровНаКомиссию");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПереданные, "ЗапасыВПереработке");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о запасах, переданных в переработку за указанный период времени.'");
	Вариант.Размещение.Удалить(Метаданные.Подсистемы.Закупки.Подсистемы.ТоварыИУслуги);
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Закупки.Подсистемы.Переработка, "Важный");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Склад.Подсистемы.Склад, "Важный");
	Вариант.ФункциональныеОпции.Добавить("ПередачаСырьяВПереработку");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПереданные, "ЗапасыНаОтветхранении");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о запасах, переданных на ответственное хранение за указанный период времени.'");
	Вариант.ФункциональныеОпции.Добавить("ПередачаЗапасовНаОтветхранение");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПереданные, "Остатки");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию об остатках запасов, принятых на комиссию, в переработку и на ответственное хранение.'");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли