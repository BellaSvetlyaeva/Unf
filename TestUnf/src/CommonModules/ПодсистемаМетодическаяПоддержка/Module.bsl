#Область ПрограммныйИнтерфейс

// См. ОбновлениеИнформационнойБазыУНФ.ОбновлениеРозницыДоУНФ
Процедура ОбновлениеРозницыДоУНФ() Экспорт
	
	УстановитьКонстантыОбновленияРозницыДоУНФ();
	ЗаполнитьДанныеПриПереходеСРозницы();
	
КонецПроцедуры

// Процедура выполняет первоначальное заполнение данных подсистемы и включение функциональности при первом запуске приложения
//
Процедура ПриПервомЗапуске() Экспорт
	
	УстановитьКонстантыНачальногоЗаполнения();
	ПервоначальноеЗаполнениеОбъектовПодсистемы();
	
КонецПроцедуры

// Процедура выполняет первоначальное заполнение данных подсистемы
//
Процедура ПервоначальноеЗаполнениеОбъектовПодсистемы() Экспорт
	Возврат;
КонецПроцедуры

// Процедура выполняет первоначальное включение функциональности подсистемы
//
Процедура УстановитьКонстантыНачальногоЗаполнения() Экспорт
	
	РежимЗапускаУНФ = Константы.ТекущийРежимЗапускаУНФ.Получить();
	ЭтоРозница 		= ВозможностиПриложения.ЭтоРозница();
	ЭтоУНФ 			= ВозможностиПриложения.ЭтоУНФ();
	
	ЭтоНастольноеПриложениеУНФ = ЭтоУНФ И РежимЗапускаУНФ = Перечисления.РежимыЗапускаУНФ.НастольноеПриложение;
	ВключитьФункциональностьНастольногоПриложения = ЭтоРозница ИЛИ ЭтоНастольноеПриложениеУНФ;
	
	Если ЭтоУНФ Тогда
		
		Константы.ИспользоватьВидеоматериалы.Установить(Истина);
		
		Если ЭтоНастольноеПриложениеУНФ Тогда
			Константы.ОтображатьМакетОписанияИзменений.Установить(Истина);
			Константы.ОтображатьПереходКПанелиОтчетовОсновнойРаздел.Установить(Истина);
			Константы.ИспользоватьФормуИнформационногоЦентра.Установить(Истина);
			Константы.ОтображатьБыстрыеДействия.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоРозница Тогда
		Константы.ОтображатьМакетОписанияИзменений.Установить(Истина);
		Константы.ОтображатьПереходКПанелиОтчетовОсновнойРаздел.Установить(Истина);
		Константы.ИспользоватьФормуИнформационногоЦентра.Установить(Истина);
		Константы.ОтображатьБыстрыеДействия.Установить(Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьКонстантыОбновленияРозницыДоУНФ()
	Константы.ИспользоватьВидеоматериалы.Установить(Истина);
КонецПроцедуры

Процедура ЗаполнитьДанныеПриПереходеСРозницы()
	Возврат;
КонецПроцедуры

#КонецОбласти