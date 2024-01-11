#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Удаление проверяемых реквизитов из структуры, в зависимости от функциональной 
	// опции.
	Если НЕ Константы.ФункциональнаяОпцияИспользоватьБюджетирование.Получить()
		  И ТипСчета <> Перечисления.ТипыСчетов.КосвенныеЗатраты Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетЗакрытия");
	КонецЕсли;
	
	Если Константы.ФункциональнаяОпцияИспользоватьБюджетирование.Получить()
	   И ТипСчета <> Перечисления.ТипыСчетов.НезавершенноеПроизводство
	   И ТипСчета <> Перечисления.ТипыСчетов.КосвенныеЗатраты Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетЗакрытия");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипСчета <> Перечисления.ТипыСчетов.Доходы
	   И ТипСчета <> Перечисления.ТипыСчетов.Расходы
	   И ТипСчета <> Перечисления.ТипыСчетов.НезавершенноеПроизводство
	   И ТипСчета <> Перечисления.ТипыСчетов.КосвенныеЗатраты
	   И ТипСчета <> Перечисления.ТипыСчетов.ПрочиеДоходы
	   И ТипСчета <> Перечисления.ТипыСчетов.ПрочиеРасходы
	   И ТипСчета <> Перечисления.ТипыСчетов.ПроцентыПоКредитам Тогда
		СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	КонецЕсли;
	
	Если ТипСчета <> Перечисления.ТипыСчетов.НезавершенноеПроизводство
	   И ТипСчета <> Перечисления.ТипыСчетов.КосвенныеЗатраты Тогда
		СчетЗакрытия = ПланыСчетов.Управленческий.ПустаяСсылка();
	КонецЕсли;
	
	Порядок = " " + ПолучитьПорядокКода();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Порядок = "";
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли