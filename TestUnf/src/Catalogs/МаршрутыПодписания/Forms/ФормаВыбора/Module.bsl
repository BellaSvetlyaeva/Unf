#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ВидПодписи", ВидПодписи);
	
	Если Параметры.Свойство("ПараметрыОтбора") Тогда
		
		ПараметрыОтбора = Параметры.ПараметрыОтбора;		
		Организация = ПараметрыОтбора.Организация;
		ВидПодписи = ПараметрыОтбора.ВидПодписи;
		
		ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор.Элементы, 
			НСтр("ru = 'Отбор'"), ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		ГруппаОтбораИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ГруппаОтбора, 
			НСтр("ru = 'Отбор по организации и виду подписи'"), ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораИ, "Организация", 
			ВидСравненияКомпоновкиДанных.Равно, ПараметрыОтбора.Организация, НСтр("ru = 'Маршруты переданной организации'"), Истина);
		
		Если ЗначениеЗаполнено(ВидПодписи) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораИ, "ВидПодписи", 
				ВидСравненияКомпоновкиДанных.Равно, ВидПодписи, НСтр("ru = 'Вид подписи'"), Истина);
		КонецЕсли;
					
		Заголовок = Организация;

		МассивИмен = ИменаПредопределенныхДанныхПоСхемам(ПараметрыОтбора.СхемыПодписания);
		
		Если ЗначениеЗаполнено(МассивИмен) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора, "ИмяПредопределенныхДанных", 
				ВидСравненияКомпоновкиДанных.ВСписке, МассивИмен,
				НСтр("ru = 'Предопределенные маршруты по схемам подписания'"), Истина);
		КонецЕсли;
		
	КонецЕсли;		

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ЗначениеЗаполнено(Организация) Или ЗначениеЗаполнено(ВидПодписи) Тогда
		Отказ = Истина;
		
		ЗначенияЗаполнения = Новый Структура;
		Если ЗначениеЗаполнено(Организация) Тогда
			ЗначенияЗаполнения.Вставить("Организация", Организация);
		КонецЕсли;
		Если ЗначениеЗаполнено(ВидПодписи) Тогда
			ЗначенияЗаполнения.Вставить("ВидПодписи", ВидПодписи);
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.МаршрутыПодписания.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор); 
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ИменаПредопределенныхДанныхПоСхемам(СхемыПодписания);
	
	Имена = Новый Массив;
	
	Если СхемыПодписания.Найти(Перечисления.СхемыПодписанияЭД.ОднойДоступнойПодписью) <> Неопределено Тогда
		Имена.Добавить("ОднойДоступнойПодписью");
	КонецЕсли;
	
	Если СхемыПодписания.Найти(Перечисления.СхемыПодписанияЭД.УказыватьПриСоздании) <> Неопределено Тогда
		Имена.Добавить("УказыватьПриСоздании");
	КонецЕсли;
	
	Возврат Имена;
	
КонецФункции

#КонецОбласти