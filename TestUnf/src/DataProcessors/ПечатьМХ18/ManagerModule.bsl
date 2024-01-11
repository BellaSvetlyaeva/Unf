
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ИдентификаторПечатнойФормы() Экспорт
	
	Возврат "МХ18";
	
КонецФункции

Функция ПредставлениеПФ() Экспорт
	
	Возврат НСтр("ru ='МХ18 (Накладная на передачу готовой продукции)'");
	
КонецФункции

Функция КлючПараметровПечати() Экспорт
	
	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_МХ18";
	
КонецФункции

Функция ПолныйПутьКМакету() Экспорт
	
	Возврат "Обработка.ПечатьМХ18.ПФ_MXL_МХ18";
	
КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати, ВключаяУслуги) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;

	Макет = УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати = Новый Структура;
	
	ОбластиМакета = Новый Структура;
	ОбластиМакета.Вставить("ОбластьШапка", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Шапка", "",
		Ошибки));
	ОбластиМакета.Вставить("ОбластьЗаголовокТаблицы", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"ЗаголовокТаблицы", "", Ошибки));
	ОбластиМакета.Вставить("НомерСтраницы", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"НомерСтраницы", "", Ошибки));
	ОбластиМакета.Вставить("ОбластьСтрока", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Строка", "",
		Ошибки));
	ОбластиМакета.Вставить("ОбластьИтоговПоСтранице", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"ИтогиПоСтранице", "", Ошибки));
	ОбластиМакета.Вставить("ОбластьВсего", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Всего", "",
		Ошибки));
	ОбластиМакета.Вставить("ОбластьПодвал", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Подвал", "",
		Ошибки));

	Для Каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл

		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало,
			ДанныеПечати);
		
		// :::Шапка
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеОбъекта.Организация,
			ДанныеОбъекта.ДатаДокумента);

		ДанныеПечати.Вставить("ДатаДокумента", ДанныеОбъекта.ДатаДокумента);
		ДанныеПечати.Вставить("ОрганизацияПоОКПО", СведенияОбОрганизации.КодПоОКПО);
		ДанныеПечати.Вставить("ПредставлениеОрганизации", ПечатьДокументовУНФ.ОписаниеОрганизации(
			СведенияОбОрганизации));
		ДанныеПечати.Вставить("Отправитель", ДанныеОбъекта.Отправитель);
		ДанныеПечати.Вставить("Получатель", ДанныеОбъекта.Получатель);
		ДанныеПечати.Вставить("КорСчет", ДанныеОбъекта.КорСчет);

		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеОбъекта.ДатаДокумента,
			ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс);
		ДанныеПечати.Вставить("НомерДокумента", НомерДокумента);

		ОбластиМакета.ОбластьШапка.Параметры.Заполнить(ДанныеПечати);
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет,
			ОбластиМакета.ОбластьШапка, ДанныеОбъекта.Ссылка);
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьШапка);
		
		// :::Таблица документа
		Итоги = ПодготовитьТаблицуИтогов(ДанныеОбъекта.ТаблицаЗапасы.Количество(), НомерДокумента, ДанныеОбъекта.ДатаДокумента);
		
		ДанныеПечати.Вставить("НомерСтраницы", СтрШаблон(НСтр("ru ='Страница %1'"), Итоги.НомерСтраницы));
		ОбластиМакета.ОбластьЗаголовокТаблицы.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьЗаголовокТаблицы);

		Для Каждого СтрокаЗапасы Из ДанныеОбъекта.ТаблицаЗапасы Цикл

			ДанныеПечати.Очистить();

			Итоги.НомерСтроки = Итоги.НомерСтроки + 1;

			Если Итоги.НомерСтроки <> 0 И СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент,
				ОбластиМакета, Итоги) = Ложь Тогда

				ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги);
			КонецЕсли;

			ЗаполнитьДанныеПечатиДаннымиСтрокиЗапасы(ДанныеПечати, СтрокаЗапасы);

			ОбластиМакета.ОбластьСтрока.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьСтрока);
			
			УвеличитьИтогиНаДанныеСтрокиЗапасы(Итоги, СтрокаЗапасы);
			
		КонецЦикла;

		ОбластиМакета.ОбластьИтоговПоСтранице.Параметры.Заполнить(Итоги);
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьИтоговПоСтранице);

		ОбластиМакета.ОбластьВсего.Параметры.Заполнить(Итоги);
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьВсего);
		
		// :::Подвал документа
		ДанныеПечати.Очистить();
		ДанныеПечати.Вставить("ДолжностьКладовщикаОтпустил", ДанныеОбъекта.ДолжностьКладовщикаОтпустил);
		ДанныеПечати.Вставить("РасшифровкаПодписиКладовщикаОтпустил",
			ДанныеОбъекта.РасшифровкаПодписиКладовщикаОтпустил);
		ДанныеПечати.Вставить("ДолжностьКонтролера", ДанныеОбъекта.ДолжностьКонтролера);
		ДанныеПечати.Вставить("РасшифровкаПодписиКонтролера", ДанныеОбъекта.РасшифровкаПодписиКонтролера);
		ДанныеПечати.Вставить("ДолжностьКладовщикаПринял", ДанныеОбъекта.ДолжностьКладовщикаПринял);
		ДанныеПечати.Вставить("РасшифровкаПодписиКладовщикаПринял", ДанныеОбъекта.РасшифровкаПодписиКладовщикаПринял);
		ДанныеПечати.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью",
			ПечатьДокументовУНФ.КоличествоПрописью(Итоги.НомерСтроки));
		ДанныеПечати.Вставить("СуммаПрописью", ПечатьДокументовУНФ.СформироватьСуммуПрописью(
			Итоги.ИтогСумма, ДанныеОбъекта.ВалютаДокумента));

		ОбластиМакета.ОбластьПодвал.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьПодвал);

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеОбъекта.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодготовитьТаблицуИтогов(КоличествоСтрокВТаблице, НомерДокумента, ДатаДокумента)
	
	Итоги = Новый Структура;
	
	Итоги.Вставить("НомерСтраницы", 1);
	Итоги.Вставить("НомерСтроки", 0);
	Итоги.Вставить("КоличествоСтрок", КоличествоСтрокВТаблице);
	Итоги.Вставить("ОбработаноСтрок", 0);
	
	Итоги.Вставить("КоличествоМестПоСтранице", 0);
	Итоги.Вставить("ИтогКоличествоМест", 0);
	
	Итоги.Вставить("КоличествоНаСтранице", 0);
	Итоги.Вставить("ИтогоКоличество", 0);
	
	Итоги.Вставить("СуммаНаСтранице", 0);
	Итоги.Вставить("ИтогСумма", 0);
	
	Итоги.Вставить("ИтогМассаБруттоНаСтранице", 0);
	Итоги.Вставить("ИтогМассаБрутто", 0);
	
	ПредставлениеДокумента = СтрШаблон(НСтр(
		"ru ='Накладная на передачу готовой продукции в места хранения №%1 от %2'"), НомерДокумента, Формат(
		ДатаДокумента, "ДЛФ=DD"));
	Итоги.Вставить("ПредставлениеДокумента", ПредставлениеДокумента);
	
	Возврат Итоги;
	
КонецФункции

Процедура УвеличитьИтогиНаДанныеСтрокиЗапасы(Итоги, Знач СтрокаЗапасы);
	
	Итоги.КоличествоНаСтранице = Итоги.КоличествоНаСтранице + СтрокаЗапасы.Количество;
	Итоги.ИтогоКоличество = Итоги.ИтогоКоличество + СтрокаЗапасы.Количество;
	
	Итоги.КоличествоМестПоСтранице = Итоги.КоличествоМестПоСтранице + СтрокаЗапасы.КоличествоМест;
	Итоги.ИтогКоличествоМест = Итоги.ИтогКоличествоМест + СтрокаЗапасы.КоличествоМест;
	
	Итоги.СуммаНаСтранице = Итоги.СуммаНаСтранице + СтрокаЗапасы.Сумма;
	Итоги.ИтогСумма = Итоги.ИтогСумма + СтрокаЗапасы.Сумма;
	
	Если СтрокаЗапасы.Владелец().Колонки.Найти("МассаБрутто") <> Неопределено Тогда
		Итоги.ИтогМассаБруттоНаСтранице = Итоги.ИтогМассаБруттоНаСтранице + СтрокаЗапасы.МассаБрутто;
		Итоги.ИтогМассаБрутто = Итоги.ИтогМассаБрутто + СтрокаЗапасы.МассаБрутто;
	КонецЕсли;
	
	Итоги.ОбработаноСтрок = Итоги.ОбработаноСтрок + 1;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПечатиДаннымиСтрокиЗапасы(ДанныеПечати, Знач СтрокаЗапасы)
	
	ПараметрыНоменклатуры = Новый Структура;
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаЗапасы.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаЗапасы.Характеристика);
	
	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(СтрокаЗапасы));
	ДанныеПечати.Вставить("ЕдиницаИзмеренияНаименование", СтрокаЗапасы.ЕдиницаИзмеренияНаименование);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияКодПоОКЕИ", СтрокаЗапасы.ЕдиницаИзмеренияКодПоОКЕИ);
	ДанныеПечати.Вставить("Количество", СтрокаЗапасы.Количество);
	ДанныеПечати.Вставить("ВидУпаковки", СтрокаЗапасы.ВидУпаковки);
	ДанныеПечати.Вставить("КоличествоМест", СтрокаЗапасы.КоличествоМест);
	ДанныеПечати.Вставить("КоличествоВОдномМесте", СтрокаЗапасы.КоличествоВОдномМесте);
	ДанныеПечати.Вставить("Цена", СтрокаЗапасы.Цена);
	ДанныеПечати.Вставить("Сумма", СтрокаЗапасы.Сумма);
	
	Если СтрокаЗапасы.Владелец().Колонки.Найти("МассаБрутто") <> Неопределено Тогда
		ДанныеПечати.Вставить("МассаБрутто", СтрокаЗапасы.МассаБрутто);
	КонецЕсли;
	
КонецПроцедуры

Функция СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент, ОбластиМакета, Итоги)
	
	ЕстьВсеОбласти = Истина;
	Для каждого ЭлементСтруктуры Из ОбластиМакета Цикл
		
		Если ЭлементСтруктуры.Значение = Неопределено Тогда
			
			ЕстьВсеОбласти = Ложь;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЕстьВсеОбласти Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	МассивОбластейМакета = Новый Массив;
	
	МассивОбластейМакета.Добавить(ОбластиМакета.ОбластьСтрока);
	МассивОбластейМакета.Добавить(ОбластиМакета.ОбластьИтоговПоСтранице);
	
	Если Итоги.ОбработаноСтрок = Итоги.КоличествоСтрок - 1 Тогда
		
		МассивОбластейМакета.Добавить(ОбластиМакета.ОбластьВсего);
		МассивОбластейМакета.Добавить(ОбластиМакета.ОбластьПодвал);
		
	КонецЕсли;
	
	Возврат ТабличныйДокумент.ПроверитьВывод(МассивОбластейМакета)
	
КонецФункции

Процедура ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги)
	
	Если ОбластиМакета.ОбластьИтоговПоСтранице <> Неопределено Тогда
		
		ОбластиМакета.ОбластьИтоговПоСтранице.Параметры.Заполнить(Итоги);
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьИтоговПоСтранице);
		
	КонецЕсли;
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	ОбнулитьИтогиПоСтранице(Итоги);
	
	Итоги.НомерСтраницы = Итоги.НомерСтраницы + 1;
	
	Если ОбластиМакета.НомерСтраницы <> Неопределено Тогда
		
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ПредставлениеДокумента", Итоги.ПредставлениеДокумента);
		ДанныеПечати.Вставить("ПредставлениеСтраницы", СтрШаблон(НСтр("ru ='Страница %1'"), Итоги.НомерСтраницы));
		
		ОбластиМакета.НомерСтраницы.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластиМакета.НомерСтраницы);
		
	КонецЕсли;
	
	Если ОбластиМакета.ОбластьЗаголовокТаблицы <> Неопределено Тогда
		
		ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьЗаголовокТаблицы);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбнулитьИтогиПоСтранице(Итоги)
	
	Итоги.КоличествоНаСтранице = 0;
	Итоги.КоличествоМестПоСтранице = 0;
	Итоги.СуммаНаСтранице = 0;
	Итоги.ИтогМассаБруттоНаСтранице = 0;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли