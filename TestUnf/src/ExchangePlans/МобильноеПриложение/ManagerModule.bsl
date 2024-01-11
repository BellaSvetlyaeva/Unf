#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция должна возвращать:
// Истина, в том случае, если корреспондент поддерживает сценарий обмена, 
// в котором текущая ИБ работает в локальном режиме, 
// а корреспондент в модели сервиса. 
// 
// Ложь - если такой сценарий обмена не поддерживается.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции // КорреспондентВМоделиСервиса()

// Получает массив узлов обмена, используемых в настройках обмена.
//
Функция ПолучитьИспользуемыеУзлыПланаОбмена() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МобильноеПриложение.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
		|ГДЕ
		|	НЕ МобильноеПриложение.ПометкаУдаления
		|	И МобильноеПриложение.Ссылка <> &ЭтотУзел");
		
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.МобильноеПриложение.ЭтотУзел());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает имя семейства конфигураций. 
// Используется для поддержки обменов с измененными конфигурациями в сервисе.
//
Функция ИмяКонфигурацииИсточника() Экспорт
	
	Возврат "УправлениеНебольшойФирмой";
	
КонецФункции // ИмяКонфигурацииИсточника()

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
// 
// Параметры:
//	Настройки - Структура - Содержит настройки по умолчанию
//
// Пример:
//	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
//@skip-warning
Процедура ОпределитьНастройки(Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли