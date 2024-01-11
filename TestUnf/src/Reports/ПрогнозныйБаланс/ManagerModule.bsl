
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
	Результат.Добавить(Новый Структура("Имя, Представление", "Основной", 
		НСтр("ru = 'Бюджет по балансу'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "План-фактный анализ", 
		НСтр("ru = 'Бюджет по балансу (план-фактный анализ)'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ПрогнозныйБаланс, "Основной");
	Вариант.Описание = НСтр("ru = 'Отчет формирует бюджет по балансовому листу по указанному сценарию.'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ПрогнозныйБаланс, "План-фактный анализ");
	Вариант.Описание = НСтр("ru = 'Отчет показывает план-фактный анализ исполнения бюджета по балансовому листу.'");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли