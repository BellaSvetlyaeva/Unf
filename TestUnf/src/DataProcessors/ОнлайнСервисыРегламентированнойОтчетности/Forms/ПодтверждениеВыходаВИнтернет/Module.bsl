
&НаКлиенте
Процедура Разрешить(Команда)
	
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ДоступВИнтернетОткрыт(Ложь) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешитьЗавершение", ЭтотОбъект);
		ОнлайнСервисыРегламентированнойОтчетностиКлиент.ЗапроситьПараметрыПрокси(ОписаниеОповещения);
        Возврат;
	КонецЕсли;
	
	РазрешитьФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    РазрешитьФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура РазрешитьФрагмент()
    
    ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.СохранитьИндивидуальныеНастройкиМеханизмаОнлайнСервисовРО(Истина);
    
    Закрыть(Истина);

КонецПроцедуры

&НаКлиенте
Процедура НапомнитьПозже(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Запретить(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда 
		РазделениеВключено = Истина;
	КонецЕсли;

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Информация = ОбработкаОбъект.ПолучитьМакет("ПодтверждениеВыходаВИнтернетИнформация").ПолучитьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаИнформацияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Href <> Неопределено Тогда 
		ОткрытьСправку("Обработка.ОнлайнСервисыРегламентированнойОтчетности");
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если РазделениеВключено Тогда
		Отказ = Истина;
		Закрыть(Истина);
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти