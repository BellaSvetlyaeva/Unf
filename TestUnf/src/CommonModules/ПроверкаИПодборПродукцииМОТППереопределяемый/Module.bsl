#Область СлужебныйПрограммныйИнтерфейс

#Область ПараметрыИнтеграцииФормыПроверкиИПодбора

// Заполняет специфику применения интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма для которой применяются параметры интеграции.
//
Процедура ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма) Экспорт
	
	Если Не СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ПриходнаяНакладная") Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаТабачнойПродукции = Форма.Элементы.Найти("ГруппаСканированиеИПроверкаТабачнойПродукции");
	
	Если ГруппаТабачнойПродукции <> Неопределено Тогда
		
		Ссылка = Форма.Объект.Ссылка;
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			Статус = ОбменСКонтрагентами.СтатусДокументооборота(Ссылка);
			Если Статус.ЭлектронныйДокумент = Неопределено Тогда
				ГруппаТабачнойПродукции.Видимость = Ложь;
			КонецЕсли;
		Иначе
			ГруппаТабачнойПродукции.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
