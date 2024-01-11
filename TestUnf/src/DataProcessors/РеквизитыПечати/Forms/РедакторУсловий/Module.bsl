#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("ТекстУсловий") Тогда
		ТекстУсловий = Параметры.ТекстУсловий;
	КонецЕсли;
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если Параметры.Свойство("Условия") Тогда
		Условия = Параметры.Условия;
	КонецЕсли;
		 
	РаботаСФормойДокумента.НастроитьВидимостьГруппыИнформации(ЭтотОбъект, "ГруппаИнформацияПоУсловиям",
							"ПоказыватьИнформациюПоУсловиям");
	 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияИнформацияПоНовойСхемеЗакрытьНажатие(Элемент)

	Элементы.ГруппаИнформацияПоУсловиям.Видимость = Ложь;	
	СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(ТекстУсловий);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьТекстУсловий(Команда)
	
	ТекстУсловий = ПолучитьТекстУсловийИзШаблона(Условия);
	 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме()

	РаботаСФормойДокумента.СохранитьВидимостьГруппыИнформации(ИмяФормы,
			"ПоказыватьИнформациюПоУсловиям", Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстУсловийИзШаблона(Условия)
	
	Текст = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Условия, "ТекстУсловий");
	Возврат Текст;
	 
КонецФункции

#КонецОбласти