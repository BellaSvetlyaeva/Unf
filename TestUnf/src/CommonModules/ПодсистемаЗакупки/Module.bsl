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
	
	РежимЗапускаУНФ 			= Константы.ТекущийРежимЗапускаУНФ.Получить();
	ЭтоРозница 					= ВозможностиПриложения.ЭтоРозница();
	ЭтоУНФ 						= ВозможностиПриложения.ЭтоУНФ();
	ЭтоНастольноеПриложениеУНФ 	= ЭтоУНФ И РежимЗапускаУНФ = Перечисления.РежимыЗапускаУНФ.НастольноеПриложение;
	ВключитьФункциональностьНастольногоПриложения = ЭтоРозница ИЛИ ЭтоНастольноеПриложениеУНФ;
	СпособИспользованияВидовЦенДляВозвратов = Перечисления.СпособыИспользованияВидовЦенДляВозвратов.ДляНовыхПользователей;
	
	Если ЭтоУНФ Тогда
		
		Константы.СпособИспользованияВидовЦенДляВозвратов.Установить(СпособИспользованияВидовЦенДляВозвратов);
		// Константа.НачалоИспользованияСФ1137
		Константы.НачалоИспользованияСФ1137.Установить(Дата(2012, 04, 01));
		// Начало действия Постановления Правительства РФ № 981 (счет-фактура)
		Константы.НачалоИспользованияСФ981.Установить(Дата(2017, 10, 01));
		
		// Настройка отбора номенклатуры.
		РегистрыСведений.НастройкиПользователей.Установить(
			Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры, "ОсновнойВидОтбора");
	
		// Настройки подбора
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		ПодборНоменклатурыВДокументах.УстановитьСтандартныеНастройкиПодбора(ТекущийПользователь);
		
		// Формирование печатных форм в пользовательских единицах измерения
		Константы.ПечатьПользовательскихЕдиницИзмерения.Установить(
			Перечисления.ПечатьПользовательскихЕдиницИзмерения.ПересчитыватьВБазовуюЕдиницуИзмеренияНоменклатуры);
	
		Если ЭтоНастольноеПриложениеУНФ Тогда
			Константы.ИспользоватьПодсистемуЗакупки.Установить(Истина);
			Константы.ОтображатьДокументыПоЗакупкам.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоРозница Тогда
		
		// Константа.НачалоИспользованияСФ1137
		Константы.НачалоИспользованияСФ1137.Установить(Дата(2012, 04, 01));
		// Начало действия Постановления Правительства РФ № 981 (счет-фактура)
		Константы.НачалоИспользованияСФ981.Установить(Дата(2017, 10, 01));
		// Настройка отбора номенклатуры.
		РегистрыСведений.НастройкиПользователей.Установить(
			Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры, "ОсновнойВидОтбора");
	
		// Настройки подбора
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		ПодборНоменклатурыВДокументах.УстановитьСтандартныеНастройкиПодбора(ТекущийПользователь);
		
		// Формирование печатных форм в пользовательских единицах измерения
		Константы.ПечатьПользовательскихЕдиницИзмерения.Установить(
			Перечисления.ПечатьПользовательскихЕдиницИзмерения.ПересчитыватьВБазовуюЕдиницуИзмеренияНоменклатуры);
		
		Константы.СпособИспользованияВидовЦенДляВозвратов.Установить(СпособИспользованияВидовЦенДляВозвратов);
		Константы.ИспользоватьПодсистемуЗакупки.Установить(Истина);
		Константы.ОтображатьДокументыПоЗакупкам.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьКонстантыОбновленияРозницыДоУНФ()
	Возврат;
КонецПроцедуры

Процедура ЗаполнитьДанныеПриПереходеСРозницы()
	Возврат;
КонецПроцедуры

#КонецОбласти