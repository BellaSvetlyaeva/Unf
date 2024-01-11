
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МобильныйКлиентУНФ.НастроитьВспомогательнуюФормуМобильныйКлиент(ЭтотОбъект);
		
	ВыделенныеОбъектыМассив = Новый Массив;
	Параметры.Свойство("ВыделенныеОбъекты", ВыделенныеОбъектыМассив);
	Если ВыделенныеОбъектыМассив.Количество() > 1 Тогда
		Заголовок = НСтр("ru = 'Общие теги'");
	Иначе
		Заголовок = НСтр("ru = 'Теги'");
	КонецЕсли;
	
	Если ВыделенныеОбъектыМассив <> Неопределено И ВыделенныеОбъектыМассив.Количество() > 0 Тогда
		Для Каждого ВыделенныйОбъект Из ВыделенныеОбъектыМассив Цикл
			НовыйОбъект = ВыделенныеОбъекты.Добавить();
			НовыйОбъект.Объект = ВыделенныйОбъект.Ссылка;
		КонецЦикла;
	КонецЕсли;
	
	ЭтоФормаРедактированияТегов = Истина;
	ТегированиеОбъектов.ПриСозданииПриЧтенииНаСервере(ЭтотОбъект, ВыделенныеОбъектыМассив, ЭтоФормаРедактированияТегов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОблакоТеговОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОблакоТеговОбработкаНавигационнойСсылкиСервер(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВводаТегаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПолеВводаТегаОбработкаВыбораСервер(Элемент.Имя, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВводаТегаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПолеВводаТегаОкончаниеВводаТекстаСервер(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОбновитьТегиВыделенныхОбъектов();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОблакоТеговОбработкаНавигационнойСсылкиСервер(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ЭтоФормаРедактированияТегов = Истина;
	ТегированиеОбъектов.ОблакоТеговОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка, ЭтоФормаРедактированияТегов);
	
КонецПроцедуры

&НаСервере
Процедура ПолеВводаТегаОбработкаВыбораСервер(ИмяЭлемента, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТегированиеОбъектов.ПолеВводаТегаОбработкаВыбора(ЭтотОбъект, ИмяЭлемента, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПолеВводаТегаОкончаниеВводаТекстаСервер(Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ТегированиеОбъектов.ПолеВводаТегаОкончаниеВводаТекста(ЭтотОбъект, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТегиВыделенныхОбъектов()
	
	ОбновитьТегиВыделенныхОбъектовСервер();
	
	Если Не ТегиИзменены Тогда
		Возврат;
	КонецЕсли;
	
	ТипИзменяемыхОбъектов = ТипЗнч(ВыделенныеОбъекты[0].Объект);
	Если ТипИзменяемыхОбъектов = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ШаблонМножественногоЧисла = НСтр("ru=';%1 контакта;;%1 контактов;%1 контактов;%1 контактов'");
	ИначеЕсли ТипИзменяемыхОбъектов = Тип("СправочникСсылка.Контрагенты") Тогда
		ШаблонМножественногоЧисла = НСтр("ru=';%1 контрагента;;%1 контрагентов;%1 контрагентов;%1 контрагентов'");
	ИначеЕсли ТипИзменяемыхОбъектов = Тип("СправочникСсылка.Лиды") Тогда
		ШаблонМножественногоЧисла = НСтр("ru=';%1 лида;;%1 лидов;%1 лидов;%1 лидов'");
	Иначе
		ШаблонМножественногоЧисла = "";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ШаблонМножественногоЧисла) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстКоличествоОбъектов = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ШаблонМножественногоЧисла,
		ВыделенныеОбъекты.Количество(), ВидЧисловогоЗначения.Количественное);
	ТекстСообщения = НСтр("ru='Теги изменены для %1'");
	ТекстСообщения = СтрШаблон(ТекстСообщения, ТекстКоличествоОбъектов);
	ПоказатьОповещениеПользователя(НСтр("ru='Изменение тегов'"), , ТекстСообщения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТегиВыделенныхОбъектовСервер()
	
	НачатьТранзакцию();
	
	Попытка
		Для Каждого ВыделенныйОбъект Из ВыделенныеОбъекты Цикл
			ВладелецОбъект = ВыделенныйОбъект.Объект.ПолучитьОбъект();
			ВладелецОбъект.Заблокировать();
			
			Для Каждого Тег Из УдаляемыеТеги Цикл
				Если ВладелецОбъект.Теги.Найти(Тег.Тег) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ВладелецОбъект.Теги.Удалить(ВладелецОбъект.Теги.Найти(Тег.Тег));
			КонецЦикла;
			Для Каждого Тег Из ДанныеТегов Цикл
				Если ВладелецОбъект.Теги.Найти(Тег.Тег) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				НоваяСтрока = ВладелецОбъект.Теги.Добавить();
				НоваяСтрока.Тег = Тег.Тег;
			КонецЦикла;
			
			ВладелецОбъект.Записать();
		КонецЦикла;
		
		ТегиИзменены = Истина;
		Модифицированность = Ложь;
		
		ЗафиксироватьТранзакцию();
	Исключение
		
		ОтменитьТранзакцию();
		ТегиИзменены = Ложь;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
