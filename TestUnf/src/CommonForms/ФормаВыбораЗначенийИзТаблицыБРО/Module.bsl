
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.ТаблицаЗначений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбратьСтрокуТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьСтрокуТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокуТаблицы()
	
	ВозвращаемыеЗначения = Новый Структура;
	НомерКолонки = 1;
	ИмяКолонки = "Колонка1";
	Пока Элементы.ТаблицаЗначений.ТекущиеДанные.Свойство(ИмяКолонки) Цикл
		Если НЕ Элементы["ТаблицаЗначений" + ИмяКолонки].Видимость Тогда
			Прервать;
		КонецЕсли;
		ВозвращаемыеЗначения.Вставить(ИмяКолонки, Элементы.ТаблицаЗначений.ТекущиеДанные[ИмяКолонки]);
		НомерКолонки = НомерКолонки + 1;
		ИмяКолонки = "Колонка" + Формат(НомерКолонки, "ЧГ=");
	КонецЦикла;
	
	Закрыть(ВозвращаемыеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеТаблицы = ПолучитьИзВременногоХранилища(Параметры.ОписаниеТаблицы);
	
	ВременнаяТаблица = ОписаниеТаблицы[0];
	ТаблицаЗначений.Загрузить(ВременнаяТаблица);
	
	КолонкаНаФорме = Неопределено;
	Для каждого Колонка Из ВременнаяТаблица.Колонки Цикл
		КолонкаНаФорме = Элементы["ТаблицаЗначений" + Колонка.Имя];
		КолонкаНаФорме.Видимость = Истина;
		КолонкаНаФорме.Заголовок = Колонка.Заголовок;
		КолонкаНаФорме.Ширина = Колонка.Ширина;
	КонецЦикла;
	
	ИсходнаяСтрока = ТаблицаЗначений.НайтиСтроки(Параметры.СтруктураДляПоиска);
	Если ИсходнаяСтрока.Количество() > 0 Тогда
		Элементы.ТаблицаЗначений.ТекущаяСтрока = ИсходнаяСтрока[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Заголовок = ОписаниеТаблицы[1];
	
КонецПроцедуры

#КонецОбласти