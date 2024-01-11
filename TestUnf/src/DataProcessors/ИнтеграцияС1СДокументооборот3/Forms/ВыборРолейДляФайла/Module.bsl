#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВладелецФайлов", ВладелецФайлов);
	
	Для Каждого Файл Из Параметры.СписокФайлов Цикл
		ЗаполнитьЗначенияСвойств(СписокФайлов.Добавить(), Файл);
	КонецЦикла;
	
	Параметры.Свойство("ДоступныеРоли", ДоступныеРоли);
	Параметры.Свойство("ВыбраннаяРоль", ВыбраннаяРоль);
	Параметры.Свойство("ИдентификаторФормыВладельца", ИдентификаторФормыВладельца);
	
	Если ЗначениеЗаполнено(ВыбраннаяРоль) Тогда
		ИндексСтроки = Неопределено;
		Для Каждого Стр Из ДоступныеРоли Цикл
			Если Стр.Значение = ВыбраннаяРоль Тогда
				ИндексСтроки = Стр.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ИндексСтроки) Тогда
			Элементы.ДоступныеРоли.ТекущаяСтрока = ИндексСтроки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоступныеРолиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	// закрыть форму
	ГотовоВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ГотовоВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ГотовоВыполнить()
	
	ВыбраннаяРоль = Элементы.ДоступныеРоли.ТекущиеДанные.Значение;
	
	ВсегоФайлов = СписокФайлов.Количество();
	Для Номер = 1 По ВсегоФайлов Цикл
		ИндексФайла = ВсегоФайлов - Номер;
		Если СписокФайлов[ИндексФайла].РольФайлаID = ВыбраннаяРоль Тогда
			СписокФайлов.Удалить(ИндексФайла);
		КонецЕсли;
	КонецЦикла;
	
	Если СписокФайлов.Количество() > 0 Тогда
		ИнтеграцияС1СДокументооборот3Клиент.ЗаменитьРольФайлов(
			СписокФайлов,
			ВыбраннаяРоль,
			ВладелецФайлов,
			ИдентификаторФормыВладельца);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти