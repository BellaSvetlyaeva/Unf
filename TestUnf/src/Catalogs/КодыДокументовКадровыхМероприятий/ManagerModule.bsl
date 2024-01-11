#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - имена реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

// Процедура выполняет первоначальное заполнение статей ТК - оснований увольнения.
Процедура НачальноеЗаполнение() Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКлассификатор();
	
КонецПроцедуры

Процедура ЗагрузитьКлассификатор() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КодыДокументовКадровыхМероприятий.Ссылка КАК Ссылка,
		|	КодыДокументовКадровыхМероприятий.Код КАК Код
		|ИЗ
		|	Справочник.КодыДокументовКадровыхМероприятий КАК КодыДокументовКадровыхМероприятий";
	
	Классификатор = Запрос.Выполнить().Выгрузить();
	
	ДанныеМакетаКлассификатора = ОбщегоНазначения.ПрочитатьXMLВТаблицу(
		ПолучитьМакет("КодыДокументовКадровыхМероприятий").ПолучитьТекст()).Данные;
	
	Для Каждого СтрокаКалсссификатора Из ДанныеМакетаКлассификатора Цикл
		
		ЭтоГруппаКлассификатора = СтрокаКалсссификатора.ParentCode = "";
		ЭтоНовыйЭлемент = Ложь;
		
		СтрокаСсылки = Классификатор.Найти(СтрокаКалсссификатора.Code, "Код");
		Если СтрокаСсылки = Неопределено Тогда
			ЭтоНовыйЭлемент = Истина;
			Если ЭтоГруппаКлассификатора Тогда
				ОбъектСсылки = Справочники.КодыДокументовКадровыхМероприятий.СоздатьГруппу();
			Иначе
				ОбъектСсылки = Справочники.КодыДокументовКадровыхМероприятий.СоздатьЭлемент();
			КонецЕсли;
			ОбъектСсылки.Код = СтрокаКалсссификатора.Code;
		Иначе
			ОбъектСсылки = СтрокаСсылки.Ссылка.ПолучитьОбъект();
		КонецЕсли;
		ОбъектСсылки.НаименованиеПолное = СтрокаКалсссификатора.Name;
		Если Не ЭтоГруппаКлассификатора Тогда
			ОбъектСсылки.СсылкаНаНД = СтрокаКалсссификатора.Article;
			ОбъектСсылки.ИмяПредопределенныхДанных = СтрокаКалсссификатора.Id;
			СтрокаРодителя = Классификатор.Найти(СтрокаКалсссификатора.ParentCode, "Код");
			Если СтрокаРодителя <> Неопределено Тогда
				ОбъектСсылки.Родитель = СтрокаРодителя.Ссылка;
			КонецЕсли;
		КонецЕсли;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектСсылки);
		Если ЭтоНовыйЭлемент Тогда
			НоваяСтрокаКлассификатора = Классификатор.Добавить();
			НоваяСтрокаКлассификатора.Код = ОбъектСсылки.Код;
			НоваяСтрокаКлассификатора.Ссылка = ОбъектСсылки.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли