#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Заголовок;
	
	Для Каждого ЭлементСписка Из Параметры.Список Цикл
		
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Значение = ЭлементСписка.Значение;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		
		МассивСтрок = Список.НайтиСтроки(Новый Структура("Значение", Параметры.ТекущаяСтрока));
		
		Если МассивСтрок.Количество() > 0  Тогда
			Элементы.Список.ТекущаяСтрока = Список.Индекс(МассивСтрок[0]);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Закрыть(Список[Значение].Значение);
	
КонецПроцедуры

#КонецОбласти
