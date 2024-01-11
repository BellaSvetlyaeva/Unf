#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПредопределенныеПроцедурыОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		Если ПометкаУдаления И Действует Тогда
			Действует = Ложь;
		КонецЕсли;
		
		Если СпособПредоставления = Перечисления.СпособыПредоставленияСкидокНаценок.Округление
			И ЗначениеЗаполнено(Родитель)
			Тогда
			
			Отказ = Истина;
			Возврат;
		КонецЕсли;		
		
		ЕстьУточненияПоНоменклатуре = ?(ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоНоменклатуре, НоменклатураГруппыЦеновыеГруппы.Количество() > 0, Ложь);
		ЕстьУточненияПоКатегориям = ?(ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоКатегориям, НоменклатураГруппыЦеновыеГруппы.Количество() > 0, Ложь);
		ЕстьУточненияПоЦеновымГруппам = ?(ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоЦеновымГруппам, НоменклатураГруппыЦеновыеГруппы.Количество() > 0, Ложь);
		ЕстьУточненияПоСегментамНоменклатуры = ?(ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоСегменту, НоменклатураГруппыЦеновыеГруппы.Количество() > 0, Ложь);

		ЕстьРасписание = Ложь;
		Для Каждого ТекущаяСтрокаРасписания Из ВремяПоДнямНедели Цикл
			Если ТекущаяСтрокаРасписания.Выбран Тогда
				ЕстьРасписание = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ЕстьОграниченияПоПолучателямКонтрагентам = ПолучателиСкидкиКонтрагенты.Количество() > 0;
		ЕстьОграниченияПоПолучателямСкладам = ПолучателиСкидкиСклады.Количество() > 0;
		ЕстьОграниченияПоПолучателямСегментам = ПолучателиСкидкиСегменты.Количество() > 0;

		Если ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоНоменклатуре
			ИЛИ ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоКатегориям Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы.ЗначениеУточнения
				|ПОМЕСТИТЬ ВТ_АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы
				|ИЗ
				|	&НоменклатураГруппыЦеновыеГруппы КАК АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ ПЕРВЫЕ 1
				|	ВТ_АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы.ЗначениеУточнения
				|ИЗ
				|	ВТ_АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы КАК ВТ_АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы
				|ГДЕ
				|	ВТ_АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы.ЗначениеУточнения.ЭтоГруппа";
			
			Запрос.УстановитьПараметр("ПоНоменклатуре", ВариантОграниченияПоНоменклатуре);
			Запрос.УстановитьПараметр("НоменклатураГруппыЦеновыеГруппы", НоменклатураГруппыЦеновыеГруппы.Выгрузить());
			
			Результат = Запрос.Выполнить();
			
			ЕстьГруппыВУточненииПоНоменклатуре = Не Результат.Пустой();
		Иначе
			ЕстьГруппыВУточненииПоНоменклатуре = Ложь;
		КонецЕсли;
		
		// Удалим строки с пустым условием и определим, есть ли условия по дисконтным картам
		ЕстьУсловияПоДК = Ложь;
		ЕстьУсловияПредъявленПромокод = Ложь;
		ЕстьУсловияАктивацииВручную = Ложь;
		МУдаляемыеСтроки = Новый Массив;
		КоличествоУсловийЗаПромокод = 0;
		КоличествоУсловийЗаАктивациюВручную = 0;
		Для каждого ТекущееУсловие Из УсловияПредоставления Цикл
			Если ТекущееУсловие.УсловиеПредоставления.Пустая() Тогда
				МУдаляемыеСтроки.Добавить(ТекущееУсловие);
			ИначеЕсли ТекущееУсловие.УсловиеПредоставления.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаДисконтнуюКарту
				Или ТекущееУсловие.УсловиеПредоставления.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж Тогда
				ЕстьУсловияПоДК = Истина;
			ИначеЕсли ТекущееУсловие.УсловиеПредоставления.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаПромокод Тогда
				ЕстьУсловияПредъявленПромокод = Истина;
				КоличествоУсловийЗаПромокод = КоличествоУсловийЗаПромокод + 1;
			ИначеЕсли ТекущееУсловие.УсловиеПредоставления.УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаАктивациюВручную Тогда
				ЕстьУсловияАктивацииВручную = Истина;
				КоличествоУсловийЗаАктивациюВручную = КоличествоУсловийЗаАктивациюВручную + 1;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого УдаляемаяСтрока Из МУдаляемыеСтроки Цикл
			УсловияПредоставления.Удалить(УдаляемаяСтрока);
		КонецЦикла;
		
		Если КоличествоУсловийЗаПромокод > 1 Тогда
			ТекстСообщения = НСтр("ru='Допустимо использовать только одно условие типа ""За промокод"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "УсловияПредоставления", "Объект.УсловияПредоставления", Отказ);
			Отказ = Истина;			
		КонецЕсли;	
		Если КоличествоУсловийЗаАктивациюВручную > 1 Тогда
			ТекстСообщения = НСтр("ru='Допустимо использовать только одно условие типа ""За активацию вручную"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "УсловияПредоставления", "Объект.УсловияПредоставления", Отказ);
			Отказ = Истина;			
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СпособПредоставления <> Перечисления.СпособыПредоставленияСкидокНаценок.Сумма Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаПредоставления");
	КонецЕсли;

	Если СпособПредоставления <> Перечисления.СпособыПредоставленияСкидокНаценок.Подарок Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаборПодарков");
	КонецЕсли;

	Если Не ЭтоПравилоНачисленияБонусов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БонуснаяПрограмма");
	КонецЕсли;
	
	Если СпособПредоставления <> Перечисления.СпособыПредоставленияСкидокНаценок.Сообщение Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТекстСообщения");
		МассивНепроверяемыхРеквизитов.Добавить("МоментВыдачиСообщения");
	КонецЕсли;
	
	Если СпособПредоставления <> Перечисления.СпособыПредоставленияСкидокНаценок.Промокод Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СкидкаНаСледующуюПокупкуПоПромокоду");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		ВалютаПредоставления = Константы.ВалютаУчета.Получить();
	Иначе
		ВариантСовместногоПрименения = Константы.ВариантыСовместногоПримененияСкидокНаценок.Получить();
	КонецЕсли;
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьИнформациюВСлужебномРегистреСведений(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Обновим информацию в служебном регистре сведений, который используется для оптимизации количества случаев,
	// в которых требуется выполнять расчет автоматических скидок.
	НаборЗаписей = РегистрыСведений.СлужебныйАвтоматическиеСкидки.СоздатьНаборЗаписей();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить();
	ЭлементБлокировки.Область = "РегистрСведений.ДатыЗапретаИзменения";
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
			|ГДЕ
			|	АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = &ЗаРазовыйОбъемПродаж
			|	И АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.КритерийОграниченияПримененияЗаОбъемПродаж = &Сумма
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ПометкаУдаления
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
			|ГДЕ
			|	АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = &ЗаКомплектПокупки
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ПометкаУдаления
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиКонтрагенты КАК АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты
			|ГДЕ
			|	АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты.Ссылка.ПометкаУдаления
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиСклады КАК АвтоматическиеСкидкиПолучателиСкидкиСклады
			|ГДЕ
			|	АвтоматическиеСкидкиПолучателиСкидкиСклады.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиСклады.Ссылка.ПометкаУдаления
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиСклады.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиСегменты КАК АвтоматическиеСкидкиПолучателиСкидкиСегменты
			|ГДЕ
			|	АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка.ПометкаУдаления
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ВремяПоДнямНедели КАК АвтоматическиеСкидкиВремяПоДнямНедели
			|ГДЕ
			|	АвтоматическиеСкидкиВремяПоДнямНедели.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиВремяПоДнямНедели.Ссылка.ПометкаУдаления
			|	И НЕ АвтоматическиеСкидкиВремяПоДнямНедели.Ссылка.ЭтоПравилоНачисленияБонусов
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ИСТИНА
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
			|ГДЕ
			|	АвтоматическиеСкидкиУсловияПредоставления.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = &ЗаДеньРождения
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
			|ГДЕ
			|	АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = &ЗаРазовыйОбъемПродаж
			|	И АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.КритерийОграниченияПримененияЗаОбъемПродаж = &Сумма
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
			|ГДЕ
			|	АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = &ЗаКомплектПокупки
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиКонтрагенты КАК АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты
			|ГДЕ
			|	АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиПолучателиСкидкиКонтрагенты.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиСклады КАК АвтоматическиеСкидкиПолучателиСкидкиСклады
			|ГДЕ
			|	АвтоматическиеСкидкиПолучателиСкидкиСклады.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиСклады.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиПолучателиСкидкиСклады.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиСегменты КАК АвтоматическиеСкидкиПолучателиСкидкиСегменты
			|ГДЕ
			|	АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.ВремяПоДнямНедели КАК АвтоматическиеСкидкиВремяПоДнямНедели
			|ГДЕ
			|	АвтоматическиеСкидкиВремяПоДнямНедели.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиВремяПоДнямНедели.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиВремяПоДнямНедели.Ссылка.ЭтоПравилоНачисленияБонусов
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ИСТИНА
			|ИЗ
			|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
			|ГДЕ
			|	АвтоматическиеСкидкиУсловияПредоставления.Ссылка.Действует
			|	И НЕ АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ПометкаУдаления
			|	И АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления.УсловиеПредоставления = &ЗаДеньРождения
			|	И АвтоматическиеСкидкиУсловияПредоставления.Ссылка.ЭтоПравилоНачисленияБонусов
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ИСТИНА КАК Поле1
			|ИЗ
			|	Справочник.АвтоматическиеСкидки КАК АвтоматическиеСкидки
			|ГДЕ
			|	НЕ АвтоматическиеСкидки.ПометкаУдаления
			|	И АвтоматическиеСкидки.Действует";
		
		Запрос.УстановитьПараметр("ЗаРазовыйОбъемПродаж", Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж);
		Запрос.УстановитьПараметр("ЗаКомплектПокупки", Перечисления.УсловияПредоставленияСкидокНаценок.ЗаКомплектПокупки);
		Запрос.УстановитьПараметр("ЗаДеньРождения", Перечисления.УсловияПредоставленияСкидокНаценок.ЗаДеньРождения);
		Запрос.УстановитьПараметр("Сумма", Перечисления.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Сумма);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		МРезультатов = Запрос.ВыполнитьПакет();
		
		Запись = НаборЗаписей.Добавить();
		Запись.ПравилоНачисленияБонусов = Ложь;
		
		// Есть скидка с условием от суммы.
		Выборка = МРезультатов[0].Выбрать();
		Запись.ЕстьСкидкиСУсловиямиОтСуммы = Выборка.Следующий();
		
		// Есть скидка за комплект покупки.
		Выборка = МРезультатов[1].Выбрать();
		Запись.ЕстьСкидкиСУсловиямиЗаКомплектПокупки = Выборка.Следующий();
		
		// Есть скидки с ограничением по контрагенту.
		Выборка = МРезультатов[2].Выбрать();
		Запись.ЕстьСкидкиСПолучателямиКонтрагенты = Выборка.Следующий();
		
		// Есть скидки с ограничением по контрагенту.
		Выборка = МРезультатов[3].Выбрать();
		Запись.ЕстьСкидкиСПолучателямиСклады = Выборка.Следующий();
		
		// Есть скидки с ограничением по сегментам.
		Выборка = МРезультатов[4].Выбрать();
		Запись.ЕстьСкидкиСПолучателямиСегменты= Выборка.Следующий();
		
		// Есть скидки с расписанием.
		Выборка = МРезультатов[5].Выбрать();
		Запись.ЕстьСкидкиСРасписанием = Выборка.Следующий();
		
		Запись = НаборЗаписей.Добавить();
		Запись.ПравилоНачисленияБонусов = Истина;
		
		// Есть правило с условием от суммы.
		Выборка = МРезультатов[6].Выбрать();
		Запись.ЕстьСкидкиСУсловиямиОтСуммы = Выборка.Следующий();
		
		// Есть правило за комплект покупки.
		Выборка = МРезультатов[7].Выбрать();
		Запись.ЕстьСкидкиСУсловиямиЗаКомплектПокупки = Выборка.Следующий();
		
		// Есть правило с ограничением по контрагенту.
		Выборка = МРезультатов[8].Выбрать();
		Запись.ЕстьСкидкиСПолучателямиКонтрагенты = Выборка.Следующий();
		
		// Есть правило с ограничением по контрагенту.
		Выборка = МРезультатов[9].Выбрать();
		Запись.ЕстьСкидкиСПолучателямиСклады = Выборка.Следующий();
		
		// Есть правило с ограничением по сегменту.
		Выборка = МРезультатов[10].Выбрать();
		Запись.ЕстьСкидкиСПолучателямиСегменты = Выборка.Следующий();
		
		// Есть правило с расписанием.
		Выборка = МРезультатов[11].Выбрать();
		Запись.ЕстьСкидкиСРасписанием = Выборка.Следующий();
		
		НаборЗаписей.Записать();
		
		// Есть действующие скидки.
		Выборка = МРезультатов[12].Выбрать();
		Константы.ЕстьАвтоматическиеСкидки.Установить(Выборка.Следующий());
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Отказ = Истина;
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Автоматические скидки. Служебная информация по автоматическим скидкам'",
			     ОбщегоНазначения.КодОсновногоЯзыка()),
			?(Отказ, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация),
			,
			,
			ПредставлениеОшибки,
			РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
	
	Если Отказ Тогда
		ВызватьИсключение
			НСтр("ru = 'Не удалось записать служебную информацию по автоматическим скидкам, наценкам.
			           |Подробности в журнале регистрации.'");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи.
//
Процедура ПриЗаписи(Отказ)
	
	// Требуется обновить служебную информацию в режиме ОбменДанными.Загрузка
	Если ОбменДанными.Загрузка Тогда
		Если НЕ (ДополнительныеСвойства.Свойство("РегистрироватьСлужебныйАвтоматическиеСкидки")
			И ДополнительныеСвойства.РегистрироватьСлужебныйАвтоматическиеСкидки = Ложь) Тогда
			ОбновитьИнформациюВСлужебномРегистреСведений(Отказ);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	ОбновитьИнформациюВСлужебномРегистреСведений(Отказ);
	
КонецПроцедуры

// Проверяет заполненность характеристик у товаров, в виде которых указан признак использования характеристик
//
// Параметры:
//  Объект - СправочникОбъект.АвтоматическиеСкидки - объект, в табличных частях которого необходимо проверить
//                                                   заполненность характеристик
//  Отказ - Булево - признак отказа
//
Процедура ПроверитьЗаполнениеХарактеристик(Объект, Отказ)
	
	Перем ЭтоГруппа;
	Если НЕ Отказ Тогда
	
		НеПроверятьУслуги = Ложь;
		
		ИспользоватьХарактеристики = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики");
		
		МассивИменТабличныхЧастей = Новый Массив;
		МассивИменТабличныхЧастей.Добавить("НаборПодарков");
		Для Каждого ИмяТабличнойЧасти Из МассивИменТабличныхЧастей Цикл
						
			ТаблицаРеквизитов = ТаблицаЗначенийРеквизитовНоменклатурыТабличнойЧасти(Объект[ИмяТабличнойЧасти]);
			
			Для Каждого СтрокаТЧ Из Объект[ИмяТабличнойЧасти] Цикл
				
				Номенклатура = СтрокаТЧ.Номенклатура;
				
				Если Не ЗначениеЗаполнено(Номенклатура) Тогда Продолжить КонецЕсли;
				
				НомерСтроки = СтрокаТЧ.НомерСтроки;
				
				ЭтоНоменклатура = ?(ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура"), Истина, Ложь);
				
				Если Не ЭтоНоменклатура Тогда 
					Продолжить 
				КонецЕсли;
				
				ЭтоГруппа = ТаблицаРеквизитов[НомерСтроки - 1].ЭтоГруппа;
				Если ЭтоГруппа Тогда 
					Продолжить 
				КонецЕсли;
				
				ПроверятьЗаполнениеХарактеристики = ТаблицаРеквизитов[НомерСтроки - 1].ПроверятьЗаполнениеХарактеристики;
				
				ПроверятьЗаполнениеХарактеристикВТабЧасти = ПроверятьЗаполнениеХарактеристики И ИспользоватьХарактеристики;
				
				ТипНоменклатуры = ТаблицаРеквизитов[НомерСтроки - 1].ТипНоменклатуры;
				
				Если НеПроверятьУслуги И ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
					Продолжить;
				КонецЕсли;
				
				Если ПроверятьЗаполнениеХарактеристикВТабЧасти
					И Не ЗначениеЗаполнено(СтрокаТЧ.Характеристика) Тогда
					ТекстСообщения = СтрШаблон(НСтр(
						"ru = 'В таблице ""%1"" для номенклатуры %2 в строке %3 заполнение поля ""Характеристика"" является обязательным.'"),
						ИмяТабличнойЧасти, Номенклатура, НомерСтроки);
					КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабличнойЧасти, НомерСтроки,
						"Характеристика");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект, КонтекстноеПоле, , Отказ);
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;		
	КонецЕсли;
	
КонецПроцедуры

Функция ТаблицаЗначенийРеквизитовНоменклатурыТабличнойЧасти(ТабличнаяЧасть)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТабличнаяЧасть", ТабличнаяЧасть.Выгрузить(, "НомерСтроки, Номенклатура"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабличнаяЧасть.Номенклатура КАК НоменклатураТабЧасти,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ Итог
	|ИЗ
	|	&ТабличнаяЧасть КАК ТабличнаяЧасть
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Итог.НомерСтроки КАК НомерСтроки,
	|	Итог.НоменклатураТабЧасти КАК Номенклатура,
	|	Номенклатура.ЭтоГруппа КАК ЭтоГруппа,
	|	Номенклатура.ПроверятьЗаполнениеХарактеристики КАК ПроверятьЗаполнениеХарактеристики,
	|	Номенклатура.ПроверятьЗаполнениеПартий КАК ПроверятьЗаполнениеПартий,
	|	Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
	|ИЗ
	|	Итог КАК Итог
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО Итог.НоменклатураТабЧасти = Номенклатура.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли