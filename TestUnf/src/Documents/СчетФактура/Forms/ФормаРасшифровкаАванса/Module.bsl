
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, СуммаВключаетНДС) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(СуммаВключаетНДС, 
		СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
		СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтогиРаспределенныхСумм()
	
	ИтогоАвансыСуммаВклНДС = Авансы.Итог("Сумма");
	ИтогоАвансыСуммаНДС = Авансы.Итог("СуммаНДС");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРасшифровкуАванса()
	
	Если НЕ КэшЗначений.ЭтоКорректировкаАвансаНДС20 Тогда
		
		ОчиститьСуммыДоКорректировки();
		ОбновитьИтогиРаспределенныхСумм();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеТабличнойЧасти(Отказ)
	
	Если КэшЗначений.ЭтоКорректировкаАвансаНДС20 Тогда
		
		ИмяСписка = НСтр("ru = 'Расшифровка аванса'");
		
		Для каждого СтрокаТаблица Из Авансы Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблица.КорректируемыйСчетФактура) Тогда
				
				ИндексСтроки = Авансы.Индекс(СтрокаТаблица);
				
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность", НСтр("ru = 'Счет-фактура'"), ИндексСтроки, ИмяСписка);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , СтрШаблон("Авансы[%1].КорректируемыйСчетФактура", ИндексСтроки), , Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьЗаголовкиСтрок(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.НадписьДоИзменения     = НСтр("ru = 'до изменения:'");
	СтрокаТабличнойЧасти.НадписьПослеИзменения  = НСтр("ru = 'после изменения:'");
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВХранилищеРасшифровкуАванса()
	
	ПоместитьВоВременноеХранилище(Авансы.Выгрузить(), КэшЗначений.АдресРасшифровки);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРасчетнуюСтавкуНДС(СтавкаНДС)
	Перем СтавкаНДСРасчетная;
	
	Если ЗначениеЗаполнено(СтавкаНДС) Тогда
		
		СтавкаНДСРасчетная = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСРасчетная(СтавкаНДС);
		
	КонецЕсли;
	
	Если ТипЗнч(СтавкаНДСРасчетная) <> Тип("СправочникСсылка.СтавкиНДС")
		ИЛИ НЕ СтавкаНДСРасчетная.Расчетная Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ Ставки.Ссылка ИЗ Справочник.СтавкиНДС КАК Ставки ГДЕ Ставки.Ставка = 18 И Ставки.Расчетная");
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			СтавкаНДСРасчетная = Выборка.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтавкаНДСРасчетная;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеНоменклатураПриИзменении(НоменклатураСсылка)
	Перем ПараметрыНоменклатуры;
	
	Если НЕ ЗначениеЗаполнено(НоменклатураСсылка) Тогда
		
		Возврат ПараметрыНоменклатуры;
		
	КонецЕсли;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоменклатураСсылка, "ВидСтавкиНДС");
	
	СтавкаНДСРасчетная = ПолучитьРасчетнуюСтавкуНДС(Справочники.СтавкиНДС.СтавкаНДС(ЗначенияРеквизитов.ВидСтавкиНДС));
	Если ТипЗнч(СтавкаНДСРасчетная) = Тип("СправочникСсылка.СтавкиНДС")
		И СтавкаНДСРасчетная.Расчетная Тогда
		
		ПараметрыНоменклатуры = Новый Структура;
		ПараметрыНоменклатуры.Вставить("СтавкаНДС", СтавкаНДСРасчетная);
		
	КонецЕсли;
	
	Возврат ПараметрыНоменклатуры;
	
КонецФункции

&НаСервере
Процедура ПеренестиЗапасыВТабличнуюЧастьАвансов(ДокументСсылка, ИмяТабличнойЧасти, ЭтоЗаказПокупателя)
	
	Если ЭтоЗаказПокупателя Тогда
		
		Если ДокументСсылка.ОжидаетсяВыборВариантаКП = Ложь Тогда
			
			МассивСтрок = ДокументСсылка[ИмяТабличнойЧасти].НайтиСтроки(Новый Структура("НомерВариантаКП", ДокументСсылка.ОсновнойВариантКП));
			ТаблицаЗапасов = ДокументСсылка[ИмяТабличнойЧасти].Выгрузить(МассивСтрок);
			
		Иначе
			
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'В заказе покупателя не выбран основной вариант коммерческого предложения'"));
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		ТаблицаЗапасов = ДокументСсылка[ИмяТабличнойЧасти].Выгрузить();
		
	КонецЕсли;
	
	// Наборы
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНаборы") И ТаблицаЗапасов.Колонки.Найти("НоменклатураНабора")<>Неопределено Тогда
		Сворачивать = Ложь;
		Для каждого СтрокаТаблицы Из ТаблицаЗапасов Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НоменклатураНабора) Тогда
				Продолжить;
			КонецЕсли;
			Сворачивать = Истина;
			СтрокаТаблицы.Номенклатура = СтрокаТаблицы.НоменклатураНабора;
			СтрокаТаблицы.Характеристика = СтрокаТаблицы.ХарактеристикаНабора;
		КонецЦикла; 
		Если Сворачивать Тогда
			ТаблицаЗапасов.Свернуть("Номенклатура, Характеристика, СтавкаНДС", "Сумма, СуммаНДС");
		КонецЕсли; 
	КонецЕсли; 
	// КонецНаборы
	
	ВалютаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "ВалютаДокумента");
	НациональнаяВалюта = Константы.НациональнаяВалюта.Получить();
	Если ВалютаДокумента <> Неопределено И ВалютаДокумента <> НациональнаяВалюта Тогда
		КурсИКратность = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(КэшЗначений.Дата, Новый Структура("Валюта", ВалютаДокумента));
	Иначе
		КурсИКратность = Новый Структура("Курс, Кратность", 1, 1);
		ВалютаДокумента = НациональнаяВалюта;
	КонецЕсли;
	
	СтавкаНДСБезНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
	Для каждого СтрокаТаблицы Из ТаблицаЗапасов Цикл
		
		Если СтрокаТаблицы.СтавкаНДС = СтавкаНДСБезНДС Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		НоваяСтрока = Авансы.Добавить();
		НоваяСтрока.Номенклатура				= СтрокаТаблицы.Номенклатура;
		НоваяСтрока.ХарактеристикаНоменклатуры	= СтрокаТаблицы.Характеристика;
		НоваяСтрока.Сумма						= СтрокаТаблицы.Сумма + ?(ДокументСсылка.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
		НоваяСтрока.СуммаНДС					= СтрокаТаблицы.СуммаНДС;
		НоваяСтрока.СтавкаНДС					= ПолучитьРасчетнуюСтавкуНДС(СтрокаТаблицы.СтавкаНДС);
		
		Если ВалютаДокумента <> КэшЗначений.Валюта Тогда
			НоваяСтрока.Сумма = НоваяСтрока.Сумма * КурсИКратность.Курс / КурсИКратность.Кратность;
			
			СтавкаНДСЧисло = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(НоваяСтрока.СтавкаНДС);
			НоваяСтрока.СуммаНДС = НоваяСтрока.Сумма - (НоваяСтрока.Сумма) / ((СтавкаНДСЧисло + 100) / 100);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДокументСсылка.СуммаНДСДоставки <> 0 Тогда
		
		НоваяСтрока = Авансы.Добавить();
		НоваяСтрока.Содержание					= ДокументСсылка.НоменклатураДоставки;
		НоваяСтрока.Сумма						= ДокументСсылка.СтоимостьДоставки + ?(ДокументСсылка.СуммаВключаетНДС, 0, ДокументСсылка.СуммаНДСДоставки);
		НоваяСтрока.СуммаНДС					= ДокументСсылка.СуммаНДСДоставки;
		НоваяСтрока.СтавкаНДС					= ПолучитьРасчетнуюСтавкуНДС(ДокументСсылка.СтавкаНДСДоставки);
		
		Если ВалютаДокумента <> КэшЗначений.Валюта Тогда
			НоваяСтрока.Сумма = НоваяСтрока.Сумма * КурсИКратность.Курс / КурсИКратность.Кратность;
			
			СтавкаНДСЧисло = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(НоваяСтрока.СтавкаНДС);
			НоваяСтрока.СуммаНДС = НоваяСтрока.Сумма - (НоваяСтрока.Сумма) / ((СтавкаНДСЧисло + 100) / 100);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьРеквизитовНДС20()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыКорректировкаНДС20", "Видимость", КэшЗначений.ДопустимаКорректировка = Истина);
	
	Если КэшЗначений.ДопустимаКорректировка = Истина Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыКорректировкаНДС20",			"Пометка", КэшЗначений.ЭтоКорректировкаАвансаНДС20);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыКорректируемыйСчетФактура",	"Видимость", КэшЗначений.ЭтоКорректировкаАвансаНДС20);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыЗаголовкиСтрок",				"Видимость", КэшЗначений.ЭтоКорректировкаАвансаНДС20);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыСуммаДоКорректировки",		"Видимость", КэшЗначений.ЭтоКорректировкаАвансаНДС20);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыСтавкаНДСДоКорректировки",	"Видимость", КэшЗначений.ЭтоКорректировкаАвансаНДС20);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АвансыСуммаНДСДоКорректировки",		"Видимость", КэшЗначений.ЭтоКорректировкаАвансаНДС20);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбора()
	
	НовыйПараметрОрганизация = Новый ПараметрВыбора("Отбор.Организация", КэшЗначений.Организация);
	НовыйПараметрКонтрагент = Новый ПараметрВыбора("Отбор.Контрагент", КэшЗначений.Контрагент);
	НовыйПараметрВидОперации = Новый ПараметрВыбора("Отбор.ВидОперации", Перечисления.ВидыОперацийСчетФактура.Аванс);
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(НовыйПараметрОрганизация);
	МассивПараметров.Добавить(НовыйПараметрКонтрагент);
	МассивПараметров.Добавить(НовыйПараметрВидОперации);
	
	ЭтотОбъект.Элементы["АвансыКорректируемыйСчетФактура"].ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблицыАвансы()
	
	Для Каждого СтрокаТаблицы Из Авансы Цикл
		
		ЗаполнитьЗаголовкиСтрок(СтрокаТаблицы);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСуммыДоКорректировки()
	
	Для Каждого СтрокаАванса Из Авансы Цикл
		
		Если СтрокаАванса.СуммаДоКорректировки > 0 Тогда
			
			СтрокаАванса.Сумма		= СтрокаАванса.Сумма - СтрокаАванса.СуммаДоКорректировки;
			
			СтрокаАванса.СтавкаНДС	= СтрокаАванса.СтавкаНДСДоКорректировки;
			ЗначениеСтавкиНДС		= УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаАванса.СтавкаНДС);
			СтрокаАванса.СуммаНДС	= СтрокаАванса.Сумма - (СтрокаАванса.Сумма) / ((ЗначениеСтавкиНДС + 100) / 100);
			
		КонецЕсли;
		
		СтрокаАванса.СуммаДоКорректировки		= 0;
		СтрокаАванса.СуммаНДСДоКорректировки	= 0;
		СтрокаАванса.СтавкаНДСДоКорректировки	= Неопределено;
		СтрокаАванса.КорректируемыйСчетФактура	= Неопределено;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПараметрыДоплатыКАвансу(ДанныеСтроки)
	Перем СтавкаНДС, СтавкаНДСРасчетная;
	
	Если НЕ ЗначениеЗаполнено(ДанныеСтроки.СтавкаНДС) Тогда
		
		Возврат ДанныеСтроки;
		
	КонецЕсли;
	
	ПараметрыДоплаты = Новый Структура(
		"СуммаДоКорректировки
		|,СтавкаНДСДоКорректировки
		|,СуммаНДСДоКорректировки
		|,Сумма
		|,СтавкаНДС
		|,СуммаНДС");
	
	Если ДанныеСтроки.СтавкаНДС.Расчетная = Истина Тогда
		
		СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДС(ДанныеСтроки.СтавкаНДС.Ставка);
		СтавкаНДСРасчетная = ДанныеСтроки.СтавкаНДС;
		
	Иначе
		
		СтавкаНДС = ДанныеСтроки.СтавкаНДС;
		СтавкаНДСРасчетная = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСРасчетная(ДанныеСтроки.СтавкаНДС);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КорректируемыйСФ",	ДанныеСтроки.КорректируемыйСчетФактура);
	Запрос.УстановитьПараметр("Сумма",				ДанныеСтроки.Сумма);
	Запрос.УстановитьПараметр("СтавкаНДС",			СтавкаНДС);
	Запрос.УстановитьПараметр("СтавкаНДСРасчетная",	СтавкаНДСРасчетная);
	Запрос.УстановитьПараметр("СуммаНДС",			ДанныеСтроки.СуммаНДС);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(СчетФактураВыданныйАвансы.Сумма) КАК СуммаДоКорректировки,
	|	МАКСИМУМ(СчетФактураВыданныйАвансы.СтавкаНДС) КАК СтавкаНДСДоКорректировки,
	|	СУММА(СчетФактураВыданныйАвансы.СуммаНДС) КАК СуммаНДСДоКорректировки,
	|	СчетФактураВыданныйАвансы.Ссылка КАК КорректируемыйСчетФактура,
	|	&Сумма + СУММА(СчетФактураВыданныйАвансы.Сумма) КАК Сумма,
	|	&СтавкаНДСРасчетная КАК СтавкаНДС
	|ИЗ
	|	Документ.СчетФактура.Авансы КАК СчетФактураВыданныйАвансы
	|ГДЕ
	|	СчетФактураВыданныйАвансы.Ссылка = &КорректируемыйСФ
	|	И (СчетФактураВыданныйАвансы.СтавкаНДС = &СтавкаНДС
	|			ИЛИ СчетФактураВыданныйАвансы.СтавкаНДС = &СтавкаНДСРасчетная)
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетФактураВыданныйАвансы.Ссылка";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		
		Возврат ПараметрыДоплаты;
		
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ПараметрыДоплаты, Выборка);
	
	Если ЗначениеЗаполнено(ПараметрыДоплаты.СтавкаНДС) Тогда
		
		ЗначениеСтавкиНДС			= УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(ПараметрыДоплаты.СтавкаНДС);
		ПараметрыДоплаты.СуммаНДС	= ПараметрыДоплаты.Сумма - (ПараметрыДоплаты.Сумма) / ((ЗначениеСтавкиНДС + 100) / 100);
		
	КонецЕсли;
	
	Возврат ПараметрыДоплаты;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИменаПолей = 
		"Ссылка
		|,Дата
		|,ВидОперации
		|,Организация
		|,Контрагент,Договор
		|,Валюта
		|,НаВозврат
		|,АдресРасшифровки
		|,ДопустимаКорректировка";
	
	КэшЗначений = Новый Структура(ИменаПолей);
	ЗаполнитьЗначенияСвойств(КэшЗначений, Параметры);
	
	ДоступныеВидыОпераций = Новый Массив;
	ДоступныеВидыОпераций.Добавить(Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу);
	ДоступныеВидыОпераций.Добавить(Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПереработку);
	КэшЗначений.Вставить("ДоступныеВидыОпераций", ДоступныеВидыОпераций);
	
	КэшЗначений.Вставить("ЭтоКорректировкаАвансаНДС20", (КэшЗначений.ВидОперации = Перечисления.ВидыОперацийСчетФактура.КорректировкаАванса));
	
	ВидСтавкиНДСПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КэшЗначений.Организация, "ВидСтавкиНДСПоУмолчанию");
	Если НЕ ЗначениеЗаполнено(ВидСтавкиНДСПоУмолчанию) Тогда
		
		ВидСтавкиНДСПоУмолчанию = Перечисления.ВидыСтавокНДС.Общая;
		
	КонецЕсли;
	
	КэшЗначений.Вставить("СтавкаНДСПоУмолчанию", УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСРасчетная(Справочники.СтавкиНДС.СтавкаНДС(ВидСтавкиНДСПоУмолчанию, КэшЗначений.Дата)));
	
	УстановитьВидимостьРеквизитовНДС20();
	УстановитьПараметрыВыбора();
	
	Параметры.Свойство("Сумма", СуммаДокумента);
	Параметры.Свойство("СуммаНДС", СуммаНДСДокумента);
	
	СуммаВсего = СуммаДокумента + СуммаНДСДокумента;
	
	Авансы.Загрузить(ПолучитьИзВременногоХранилища(КэшЗначений.АдресРасшифровки));
	ЗаполнитьДобавленныеКолонкиТаблицыАвансы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИтогиРаспределенныхСумм();
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ЗаполнитьПоЗаказу(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидыОпераций", КэшЗначений.ДоступныеВидыОпераций);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораЗаказаПокупателя", ЭтотОбъект);
	ОткрытьФорму("Документ.ЗаказПокупателя.Форма.ФормаВыбора", ПараметрыОткрытия, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораЗаказаПокупателя(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		ПеренестиЗапасыВТабличнуюЧастьАвансов(Результат, "Запасы", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСчету(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораСчетаНаОплатуПокупателя", ЭтотОбъект);
	ОткрытьФорму("Документ.СчетНаОплату.ФормаВыбора", ПараметрыОткрытия, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСчетаНаОплатуПокупателя(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("ДокументСсылка.СчетНаОплату") Тогда
		
		ПеренестиЗапасыВТабличнуюЧастьАвансов(Результат, "Запасы", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Перем Отказ;
	
	ПроверитьЗаполнениеТабличнойЧасти(Отказ);
	Если Отказ <> Истина Тогда
		
		ЗаписатьВХранилищеРасшифровкуАванса();
		
		КэшЗначений.Вставить("ВыполненаКоманда", КодВозвратаДиалога.OK);
		Закрыть(КэшЗначений);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КорректировкаНДС20(Команда)
	
	КэшЗначений.ЭтоКорректировкаАвансаНДС20 = НЕ КэшЗначений.ЭтоКорректировкаАвансаНДС20;
	
	УстановитьВидимостьРеквизитовНДС20();
	ОбновитьРасшифровкуАванса();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементов

&НаКлиенте
Процедура АвансыКорректируемыйСчетФактураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Авансы.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.КорректируемыйСчетФактура) Тогда
		
		ДанныеСтроки = Новый Структура("КорректируемыйСчетФактура, Сумма, СтавкаНДС, СуммаНДС");
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТабличнойЧасти);
		
		ПараметрыДоплаты = ПараметрыДоплатыКАвансу(ДанныеСтроки);
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ПараметрыДоплаты);
		
	КонецЕсли;
	
	ОбновитьИтогиРаспределенныхСумм();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектАвансыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные  = Элементы.Авансы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НовыеПараметры = ПолучитьДанныеНоменклатураПриИзменении(ТекущиеДанные.Номенклатура);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, НовыеПараметры);
	
	РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Истина);
	
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные  = Элементы.Авансы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Истина);
	ОбновитьИтогиРаспределенныхСумм();
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСтавкаНДСПриИзменении(Элемент)
	
	ТекущиеДанные  = Элементы.Авансы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Истина);
	ОбновитьИтогиРаспределенныхСумм();
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСуммаНДСПриИзменении(Элемент)
	
	ОбновитьИтогиРаспределенныхСумм();
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыКорректируемыйСчетФактураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = КэшЗначений.Ссылка Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru='Нельзя выбирать в качестве корректируемого документа этот же документ'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока 
		И НЕ Копирование Тогда
		
		РасчетнаяСтавкаНДС 								= КэшЗначений.СтавкаНДСПоУмолчанию;
		Элемент.ТекущиеДанные.СтавкаНДС					= РасчетнаяСтавкаНДС;
		Элемент.ТекущиеДанные.СтавкаНДСДоКорректировки	= РасчетнаяСтавкаНДС;
		
	КонецЕсли;
	
	ЗаполнитьЗаголовкиСтрок(Элемент.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти