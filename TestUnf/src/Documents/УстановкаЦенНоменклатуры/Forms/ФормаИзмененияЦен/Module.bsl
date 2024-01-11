
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИзменитьОднуКолонку = Истина;

	Параметры.Свойство("ВидРасчета", ВариантИзменения);
	
	КэшЗначений = Неопределено;
	Параметры.Свойство("КэшЗначений", КэшЗначений);
	
	Параметры.Свойство("ДатаДокумента", ДатаДокумента);

	Если ВариантИзменения = "Сумма" Тогда

		Заголовок = НСтр("ru ='Изменить на сумму'");

	ИначеЕсли ВариантИзменения = "Процент" Тогда

		Заголовок = НСтр("ru ='Изменить на процент'");

	ИначеЕсли ВариантИзменения = "Округление" Тогда

		Заголовок = НСтр("ru ='Округление'");

	ИначеЕсли ВариантИзменения = "Очистить" Тогда

		Заголовок = НСтр("ru ='Очистить'");

	ИначеЕсли ВариантИзменения = "Формула" Тогда

		Заголовок = НСтр("ru ='Изменить по формуле'");

	ИначеЕсли ВариантИзменения = "Валюта" Тогда

		Заголовок = НСтр("ru ='Изменить валюту'");

	КонецЕсли;

	Элементы.Страницы.ТекущаяСтраница = Элементы["Страница" + ВариантИзменения];

	Для Каждого ЭлементПеречисления Из Параметры.КэшЗначений.ВыбранныеВидыЦен Цикл

		ДобавитьВидЦеныВСписокВыбора(ЭлементПеречисления);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	ИсторияФормул = Настройки.Получить("ИсторияФормул");
	Если ИсторияФормул = Неопределено Тогда

		Возврат;

	КонецЕсли;

	ИсторияИспользованияФормул = СтрРазделить(ИсторияФормул, "~");
	Для Каждого ЭлементМассива Из ИсторияИспользованияФормул Цикл

		Если Не ЗначениеЗаполнено(ЭлементМассива) Тогда

			Продолжить;

		КонецЕсли;

		Элементы.Формула.СписокВыбора.Добавить(ЭлементМассива);

	КонецЦикла;

	Если Элементы.Формула.СписокВыбора.Количество() > 0 Тогда

		Элементы.Формула.КнопкаВыпадающегоСписка = Истина;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПересчитатьПоКурсуПриИзменении(Элемент)
	
	СтатистикаИспользованияФормКлиент.ПриИнтерактивномДействии(ЭтотОбъект, Элементы.ПересчитатьПоКурсу, "Нажатие");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОднуКолонкуПриИзменении(Элемент)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекущийВидЦен", "Видимость",
		ИзменитьОднуКолонку);

КонецПроцедуры

&НаКлиенте
Процедура ФормулаОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОткрытьКонструкторФормулы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	Если ИзменитьОднуКолонку И Не ЗначениеЗаполнено(ТекущийВидЦен) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Выберите вид цены'");
		Сообщение.Поле = "ТекущийВидЦен";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Результат = Новый Структура;
	Результат.Вставить("ВыборПроизведен", Истина);
	Результат.Вставить("ЗаполнятьПоТекущемуВидуЦен", ?(ИзменитьОднуКолонку, 0, 1));
	Результат.Вставить("ИдентификаторТекущегоВидаЦен", ТекущийВидЦен);
	Результат.Вставить("ВариантИзменения", ВариантИзменения);
	Результат.Вставить("ОбластьПрименения", ОбластьПрименения);
	Результат.Вставить("ПсихологическоеОкругление", ПсихологическоеОкругление);

	Если ВариантИзменения = "Сумма" Тогда

		Результат.Вставить("Сумма", Сумма);

	ИначеЕсли ВариантИзменения = "Процент" Тогда

		Результат.Вставить("Процент", Процент);

	ИначеЕсли ВариантИзменения = "Округление" Тогда

		Результат.Вставить("ОкруглениеПорядок", ОкруглениеПорядок);
		Результат.Вставить("ОкруглениеВБольшуюСторону", ОкруглениеВБольшуюСторону);

	ИначеЕсли ВариантИзменения = "Формула" Тогда

		Результат.Вставить("Формула", Формула);
		ВнестиФормулуВИсториюИспользований(Формула);
		
	ИначеЕсли ВариантИзменения = "Валюта" Тогда
		
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Выберите валюту'");
			Сообщение.Поле = "Валюта";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		
		Результат.Вставить("ПересчитатьПоКурсу", ПересчитатьПоКурсу);
		Результат.Вставить("ДатаКурса", ДатаДокумента);
		Результат.Вставить("Валюта", Валюта);
		
	КонецЕсли;

	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)

	Результат = Новый Структура;
	Результат.Вставить("ВыборПроизведен", Ложь);

	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьФормулу(Команда)

	ОткрытьКонструкторФормулы();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьКонструкторФормулы()
	ПараметрыФормулы = Новый Структура;
	ПараметрыФормулы.Вставить("Формула", Формула);
	ПараметрыФормулы.Вставить("ЭтоФормированиеЦен", Истина);

	ОписаниеОповещения = Новый ОписаниеОповещения("КонструкторФормулЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ВидыЦен.Форма.КонструкторФормул", ПараметрыФормулы, Элементы.Формула, , , ,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура КонструкторФормулЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Результат = КодВозвратаДиалога.Да Тогда

		Результат.Свойство("Формула", Формула);

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ВнестиФормулуВИсториюИспользований(Формула)

	Если ПустаяСтрока(Формула) Тогда

		Возврат;

	КонецЕсли;

	Если ПустаяСтрока(ИсторияФормул) Тогда

		ИсторияФормул = "~~~~";

	КонецЕсли;

	МассивФормул = СтрРазделить(ИсторияФормул, "~", Истина);

	ИндексЭтойФормулы = МассивФормул.Найти(СокрЛП(Формула));
	Если ИндексЭтойФормулы = Неопределено Тогда

		ИндексЭтойФормулы = 4;

	КонецЕсли;

	КопияМассиваФормул = Новый Массив(5);
	КопияМассиваФормул[0] = СокрЛП(Формула);

	СтандартноеПриращение = 1;
	Для ИндексМассива = 0 По 4 Цикл

		Если ИндексМассива = ИндексЭтойФормулы Тогда

			СтандартноеПриращение = 0;
			Продолжить;

		КонецЕсли;

		СохраненнаяФормула = СокрЛП(Строка(МассивФормул[ИндексМассива]));
		КопияМассиваФормул[ИндексМассива + СтандартноеПриращение] = СохраненнаяФормула;

	КонецЦикла;

	ИсторияФормул = СтрСоединить(КопияМассиваФормул, "~");

КонецПроцедуры

&НаСервере
Процедура ДобавитьВидЦеныВСписокВыбора(Элемент)

	Если Элементы.ТекущийВидЦен.СписокВыбора.НайтиПоЗначению(Элемент.Ключ.ИдентификаторФормул) = Неопределено Тогда

		Если ВариантИзменения = "Валюта" Тогда
			Если Элемент.Ключ.НесколькоВалютДляЦен Тогда
				
				Элементы.ТекущийВидЦен.СписокВыбора.Добавить(Элемент.Ключ.ИдентификаторФормул,
					Элемент.Ключ.Наименование);
					
			КонецЕсли;
		Иначе
			Элементы.ТекущийВидЦен.СписокВыбора.Добавить(Элемент.Ключ.ИдентификаторФормул, Элемент.Ключ.Наименование);
		КонецЕсли;

	КонецЕсли;

	Если Элемент.Значение.Количество() > 0 Тогда

		Для Каждого ПодчиненныйЭлемент Из Элемент.Значение Цикл

			ДобавитьВидЦеныВСписокВыбора(ПодчиненныйЭлемент);

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти