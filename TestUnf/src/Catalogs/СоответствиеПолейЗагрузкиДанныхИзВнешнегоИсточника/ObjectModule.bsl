#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполнить настройки полей.
// 
// Параметры:
//  НоваяНастройка - Строка - Новая настройка
//  ПроверятьНастройку - Булево - Проверять настройку
Процедура ЗаполнитьНастройкиПолей(НоваяНастройка, ПроверятьНастройку = Истина) Экспорт
	
	Если ПроверятьНастройку Тогда

		Если НастройкаПоставляемаяСоответствуетТекущей() Тогда
			
			ЗаполнитьСоответствияПолейНастройкой(НоваяНастройка);

		КонецЕсли;
		
	Иначе

		ЗаполнитьСоответствияПолейНастройкой(НоваяНастройка);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти	
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Перем ПолныйПутьОбъектЗагрузки;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("ОбъектЗагрузки", ОбъектЗагрузки);
		ДанныеЗаполнения.Свойство("ИмяТабличнойЧасти", ИмяТабличнойЧасти);
		ДанныеЗаполнения.Свойство("ПолныйПутьОбъектЗагрузки", ПолныйПутьОбъектЗагрузки);
		
		ПолныйПутьОбъектЗагрузки = ?(ПолныйПутьОбъектЗагрузки = Неопределено, "", ПолныйПутьОбъектЗагрузки);
		
		ВыбранныеПоля = Неопределено;
		Если ДанныеЗаполнения.Свойство("ВыбранныеПоля", ВыбранныеПоля) Тогда
			
			Если ТипЗнч(ВыбранныеПоля) = Тип("Соответствие") Тогда
				
				ДоступныеПоляЗагрузкиДанных = Справочники.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника.ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника(
					ОбъектЗагрузки, ИмяТабличнойЧасти, Истина, ПолныйПутьОбъектЗагрузки);
				Для каждого ЭлементСоответствия Из ВыбранныеПоля Цикл
					
					Если ТипЗнч(ЭлементСоответствия.Ключ) = Тип("Строка") И ДоступныеПоляЗагрузкиДанных.Свойство(
						ЭлементСоответствия.Ключ) Тогда
						
						ОписаниеПоля = ДоступныеПоляЗагрузкиДанных[ЭлементСоответствия.Ключ];
						
					Иначе
						
						ОписаниеПоля = Строка(ЭлементСоответствия.Ключ);
						
					КонецЕсли;
					
					Если ОписаниеПоля = Неопределено Тогда
						
						Продолжить;
						
					КонецЕсли;
					
					НоваяСтрока = СоответствияПолей.Добавить();
					НоваяСтрока.НомерКолонки		= ЭлементСоответствия.Значение;
					НоваяСтрока.ПредставлениеПоля	= ОписаниеПоля;
					
					Если ТипЗнч(ЭлементСоответствия.Ключ) = Тип("Строка") Тогда
						
						НоваяСтрока.ИмяПоля = ЭлементСоответствия.Ключ;
						
					Иначе
						
						НоваяСтрока.ДополнительныйРеквизит = ЭлементСоответствия.Ключ;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкаПоставляемаяСоответствуетТекущей()
	
	Если СоответствияПолей.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;

	ТаблицаПоставляемойНастройки = Справочники.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника.НастройкуВТаблицу(
		ПоставляемаяНастройка);
		
	ТаблицаТекущейНастройки = СоответствияПолей.Выгрузить();
	ТаблицаТекущейНастройки.Сортировать("НомерКолонки");
	
	Для Каждого ПоставляемаяСтрока Из ТаблицаПоставляемойНастройки Цикл
		
		ТекущаяСтрока = ТаблицаТекущейНастройки.Найти(ПоставляемаяСтрока.НомерКолонки, "НомерКолонки");
		Если ТекущаяСтрока = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ПоставляемаяСтрока.ИмяПоля <> ТекущаяСтрока.ИмяПоля
			Или ПоставляемаяСтрока.ПредставлениеПоля <> ТекущаяСтрока.ПредставлениеПоля Тогда
				
				Возврат Ложь;
				
		КонецЕсли;
		
	КонецЦикла;
	 
	Возврат Истина;
	
КонецФункции

Процедура ЗаполнитьСоответствияПолейНастройкой(ПоставляемаяНастройка)
	
	ТаблицаПоставляемойНастройки = Справочники.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника.НастройкуВТаблицу(
		ПоставляемаяНастройка);
		
	СоответствияПолей.Загрузить(ТаблицаПоставляемойНастройки);	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли