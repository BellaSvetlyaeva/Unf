
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сертификаты.Очистить();
	СообщениеОписание = Параметры.Описание;
	
	СообщениеПолучено = Параметры.СообщениеПолучено;
	СообщениеПоследняяРасшифровка = Параметры.СообщениеПоследняяРасшифровка;
	СообщениеТип = Параметры.СообщениеТипСообщения;
	СообщениеОтправитель = Параметры.СообщениеОтправитель;
	ТранспортноеСообщение = Параметры.ТранспортноеСообщение;	
	Для Каждого ВхСертификат Из Параметры.Сертификаты Цикл 
		НовыйСертификат = Сертификаты.Добавить();
		НовыйСертификат.Описание = ВхСертификат.Значение.Описание;
		НовыйСертификат.Отпечаток = ВхСертификат.Значение.ОтпечатокСтрокой;
		НовыйСертификат.Издатель = ВхСертификат.Значение.ИздательСтрокой;
		НовыйСертификат.СерийныйНомер = ВхСертификат.Значение.СерийныйНомерСтрокой;
		НовыйСертификат.Текущий = ВхСертификат.Значение.Текущий;
		НовыйСертификат.Дополнительно = ВхСертификат.Значение.Дополнительно;
		НовыйСертификат.ОтпечатокИлиСерийныйНомер = 
			?(
				ЗначениеЗаполнено(ВхСертификат.Значение.ОтпечатокСтрокой),
				ВхСертификат.Значение.ОтпечатокСтрокой,
				ВхСертификат.Значение.СерийныйНомерСтрокой
			);
	КонецЦикла;
	
	Элементы.РасшифровыватьСообщение.Видимость = Не Параметры.СкрытьПереключатель;
	РасшифровыватьСообщение = Не Параметры.Игнорировать;
	ОбновитьСтроку = Параметры.НомерСтроки;
	
	ОбновитьНадписиБлокировки(Параметры.Свойства);
	Элементы.НадписьВнимание.Видимость = Не РасшифровыватьСообщение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасшифровыватьСообщениеПриИзменении(Элемент)
	
	РасшифровыватьСообщение = НЕ Булево(РасшифровыватьСообщение); // Отменим переключение
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеДиалогаРасшифровыватьСообщения", ЭтотОбъект, Неопределено);
	ЭтотОбъект.ВладелецФормы.ПереключениеРасшифровкиПоСообщениям(ОповещениеОЗакрытии,, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаТехническаяИнформацияНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ТранспортноеСообщение) Тогда 
		ПоказатьЗначение(, ТранспортноеСообщение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "СертификатыОписание" Тогда
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Отпечаток) Тогда
			ДанныеСертификата = Новый Структура("Отпечаток", Элемент.ТекущиеДанные.Отпечаток);
			КриптографияЭДКОКлиентСервер.КонтекстМоделиХраненияКлюча(Истина, ДанныеСертификата);
			КриптографияЭДКОКлиент.ПоказатьСертификат(ДанныеСертификата);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Расшифровать(Команда)
	
	ИсхКонтекст = Новый Структура("Форма, Параметр", ЭтотОбъект, "СообщениеПоследняяРасшифровка");
	ЭтотОбъект.ВладелецФормы.Расшифровать(Команда, ИсхКонтекст);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПрименитьОформлениеТумблера()
	
	Если РасшифровыватьСообщение Тогда 		
		//Элементы.ФлагВнимание.Видимость = Ложь;
		Элементы.НадписьВнимание.Видимость = Ложь;
	Иначе 
		//Элементы.ФлагВнимание.Видимость = Истина;
		Элементы.НадписьВнимание.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписиБлокировки(Свойства)
	Если ЗначениеЗаполнено(Свойства.ДатаБлокировки) Тогда 
		Элементы.НадписьВнимание.Заголовок = СтрШаблон("расшифровка отключена с %1 по инициативе пользователя ""%2""",
			Свойства.ДатаБлокировки,
			Свойства.ИнициаторБлокировки
		);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеДиалогаРасшифровыватьСообщения(Результат, ДопПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда 
			ОбновитьНадписиБлокировки(Результат.ОбновленныеСвойства);
			Результат = Результат.Результат;
		КонецЕсли;
		РасшифровыватьСообщение = Не Результат;
		ПрименитьОформлениеТумблера();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
