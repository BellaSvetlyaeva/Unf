#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Документ") Тогда
		Отказ = Ложь;
		ВызватьИсключение НСтр("ru = 'Не передан документ.'");
	КонецЕсли;
	
	СсылкаНаДокумент = Параметры.Документ;
	ЭтоЗачетПредоплаты = Параметры.ЭтоЗачетПредоплаты;
	
	ЗаполнитьТаблицу();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицу()
	
	ФормироватьПоДвижениям = Истина;
	Модифицированность = Ложь;
	
	Если ЭтоЗачетПредоплаты Тогда
		ТаблицаДляПросмотра = РасчетыПросмотрИнформацииОбОплате.ПолучитьТабличныйДокументОплатаПоДокументуОплаты(СсылкаНаДокумент,
			ФормироватьПоДвижениям, Модифицированность,, Истина);
	Иначе
		ТаблицаДляПросмотра = РасчетыПросмотрИнформацииОбОплате.ПолучитьТабличныйДокументОплатаПоДокументуОтгрузки(СсылкаНаДокумент,
			ФормироватьПоДвижениям, Модифицированность,, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
