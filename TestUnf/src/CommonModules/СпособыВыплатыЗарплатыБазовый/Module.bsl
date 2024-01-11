////////////////////////////////////////////////////////////////////////////////
// Способы выплаты зарплаты.
// Процедуры и функции объекта и менеджера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

// АПК:1328-выкл При обновлении ИБ ответственное чтение не требуется

Процедура НачальноеЗаполнение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ИСТИНА КАК ЗначениеИстина
	               |ИЗ
	               |	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	               |ГДЕ
	               |	СпособыВыплатыЗарплаты.Предопределенный = ЛОЖЬ";
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;	
	
	// Гарантируем, что статьи расходов созданы и заполнены
	ЗарплатаКадры.СтатьиРасходовЗарплатаНачальноеЗаполнениеПоСпособамРасчетов();
	
	СтатьиРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	ОплатаТруда	= СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.ОплатаТруда];
	ДоговораГПХ = СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами];
	
	СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.СоздатьЭлемент();
	СпособВыплаты.Наименование            = НСтр("ru = 'Аванс'");
	СпособВыплаты.Поставляемый            = Истина;
	СпособВыплаты.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.Аванс;
	СпособВыплаты.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Аванс;
	СпособВыплаты.СтатьяРасходов          = ОплатаТруда;
	СпособВыплаты.ОкончательныйРасчетНДФЛ = Ложь;
	СпособВыплаты.Округление              = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
	
	СпособВыплатыСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СпособыВыплатыЗарплаты.Зарплата");
	Если СпособВыплатыСсылка <> Неопределено Тогда
		СпособВыплаты = СпособВыплатыСсылка.ПолучитьОбъект();
		СпособВыплаты.Наименование            = НСтр("ru = 'Зарплата'");
		СпособВыплаты.Поставляемый            = Истина;
		СпособВыплаты.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
		СпособВыплаты.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
		СпособВыплаты.СтатьяРасходов          = ОплатаТруда;
		СпособВыплаты.ОкончательныйРасчетНДФЛ = Истина;
		СпособВыплаты.Округление              = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();	
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
	КонецЕсли;
	
	СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.СоздатьЭлемент();
	СпособВыплаты.Наименование            = НСтр("ru = 'По договорам ГПХ'");
	СпособВыплаты.Поставляемый            = Истина;
	СпособВыплаты.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	СпособВыплаты.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	СпособВыплаты.СтатьяРасходов          = ДоговораГПХ;
	СпособВыплаты.ОкончательныйРасчетНДФЛ = Истина;
	СпособВыплаты.Округление              = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
	
КонецПроцедуры

// АПК:1328-вкл

#КонецОбласти

#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроверкиЗаполнения(СпособВыплаты, Отказ, ПроверяемыеРеквизиты) Экспорт
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМенеджера

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	СтатьиРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	ОплатаТруда	= СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.ОплатаТруда];
	ДоговораГПХ = СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОплатаТруда", ОплатаТруда);
	Запрос.УстановитьПараметр("ДоговораГПХ", ДоговораГПХ);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.Аванс)
	|			ТОГДА 10
	|		КОГДА СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.Зарплата)
	|			ТОГДА 20
	|		ИНАЧЕ 30
	|	КОНЕЦ + ВЫБОР
	|		КОГДА СпособыВыплатыЗарплаты.СтатьяРасходов = &ОплатаТруда
	|			ТОГДА 1
	|		КОГДА СпособыВыплатыЗарплаты.СтатьяРасходов = &ДоговораГПХ
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК Вес
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	НЕ СпособыВыплатыЗарплаты.ПометкаУдаления
	|	И &ПараметрыОтбора
	|
	|УПОРЯДОЧИТЬ ПО
	|	Вес,
	|	СпособыВыплатыЗарплаты.Наименование";
	
	УсловияОтбора = Новый Массив;
	Для Каждого ЭлементОтбора Из Параметры.Отбор Цикл
		ИмяПараметра = "Отбор" + ЭлементОтбора.Ключ;
		Запрос.УстановитьПараметр(ИмяПараметра, ЭлементОтбора.Значение);
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда
			УсловияОтбора.Добавить(СтрШаблон("СпособыВыплатыЗарплаты.%1 В (&%2)", ЭлементОтбора.Ключ, ИмяПараметра));
		Иначе
			УсловияОтбора.Добавить(СтрШаблон("СпособыВыплатыЗарплаты.%1 = &%2", ЭлементОтбора.Ключ, ИмяПараметра));
		КонецЕсли; 
	КонецЦикла;
	Если УсловияОтбора.Количество() = 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПараметрыОтбора", "ИСТИНА");
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПараметрыОтбора", СтрСоединить(УсловияОтбора, " И "));
	КонецЕсли;	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
