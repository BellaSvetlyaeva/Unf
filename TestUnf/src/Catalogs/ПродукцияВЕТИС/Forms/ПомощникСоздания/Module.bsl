
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПродукцияВЕТИС = Параметры.ПродукцияВЕТИС;
	
	Если ЗначениеЗаполнено(ПродукцияВЕТИС) Тогда
		РежимИзменения = Истина;
		ПродукцияВЕТИСПриИзмененииНаСервере();
	Иначе
		РежимИзменения = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗначенияЗаполнения")
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения) Тогда
		
		ЗаполнитьЗначенияЗаполнения(Параметры.ЗначенияЗаполнения);
		
	КонецЕсли;
	
	Для Каждого НастройкаОбмена Из ИнтеграцияВЕТИС.НастройкиОбменаВЕТИС().ОбменНаСервере Цикл
		Элементы.ХозяйствующийСубъект.СписокВыбора.Добавить(НастройкаОбмена.Ключ);
	КонецЦикла;
	Если Элементы.ХозяйствующийСубъект.СписокВыбора.Количество() = 1 Тогда
		ХозяйствующийСубъект = Элементы.ХозяйствующийСубъект.СписокВыбора[0].Значение;
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(GTIN) И СтрДлина(GTIN) < 8 Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Длина GTIN не может быть менее 8 символов'"),,
			"GTIN",
			,
			Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ОписаниеПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьВидПродукции" Тогда
		ОткрытьФормыВыбораВидаПродукции();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПродукция" Тогда
		ПоказатьЗначение(,Продукция);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьВидПродукции" Тогда
		ПоказатьЗначение(,ВидПродукции);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаПродукция
		И ПроверитьЗаполнение() Тогда
		
		ДанныеПродукции = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныеПродукции();
		ДанныеПродукции.ТипПродукции = ТипПродукции;
		ДанныеПродукции.Продукция = Продукция;
		ДанныеПродукции.ВидПродукции = ВидПродукции;
		Если РежимИзменения Тогда
			ДанныеПродукции.Ссылка = ПродукцияВЕТИС;
		КонецЕсли;
		
		ДанныеПродукции.Наименование = Наименование;
		ДанныеПродукции.КодТНВЭД = КодТНВЭД;
		ДанныеПродукции.Артикул = Артикул;
		ДанныеПродукции.GTIN = GTIN;
		ДанныеПродукции.СоответствуетГОСТ = СоответствуетГОСТ;
		ДанныеПродукции.ГОСТ = ГОСТ;
		ДанныеПродукции.ИдентификаторВерсии = ИдентификаторВерсии;
		
		ДанныеПродукции.ФасовкаУпаковка = ФасовкаУпаковка;
		ДанныеПродукции.ФасовкаКоличествоУпаковок = ФасовкаКоличествоУпаковок;
		ДанныеПродукции.ФасовкаЕдиницаИзмерения = ФасовкаЕдиницаИзмерения;
		ДанныеПродукции.ФасовкаКоличествоЕдиницВУпаковке = ФасовкаКоличествоЕдиницВУпаковке;
		
		ДанныеПродукции.ХозяйствующийСубъектПроизводитель = ХозяйствующийСубъектПроизводитель;
		ДанныеПродукции.ХозяйствующийСубъектСобственникТорговойМарки = ХозяйствующийСубъектСобственникТорговойМарки;
		ДанныеПродукции.Производители = Новый Массив;
		Для Каждого СтрокаТЧ Из Производители Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.Производитель) Тогда
				ДанныеПродукции.Производители.Добавить(СтрокаТЧ.Производитель);
			КонецЕсли;
		КонецЦикла;
		
		РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросНаСозданиеИзменениеПродукции(
			ХозяйствующийСубъект,
			ДанныеПродукции,
			УникальныйИдентификатор);
			
		ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящееСообщение") Тогда
		
		ПоказатьЗначение(, ВходящееСообщение);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящееСообщение") Тогда
		
		ПоказатьЗначение(, ИсходящееСообщение);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьРезультат") Тогда
		
		ПоказатьЗначение(, ПродукцияВЕТИС);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПродукция;
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПереключитьНаСтраницуОжиданияРезультатаЗапроса(РезультатОбмена)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОжидание;
	ИсходящееСообщение = РезультатОбмена.Изменения[0].ИсходящееСообщение;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		ПереключитьНаСтраницуОжиданияРезультатаЗапроса(РезультатОбмена);
		СформироватьТекстОжиданиеРезультатаОбменаВЕТИС();
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	ДанныеДляОбработки = Неопределено;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		ДанныеДляОбработки = ЭлементДанных;
	КонецЦикла;
	
	Если ДанныеДляОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОтклонена")
		ИЛИ НЕ ПустаяСтрока(ДанныеДляОбработки.ТекстОшибки) Тогда
		
		ВывестиИнформациюОбОшибке(ДанныеДляОбработки.ТекстОшибки);
		
	ИначеЕсли ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена") Тогда
		
		ВывестиИнформациюОУспешномРезультатеОбмена(Изменения);
		ОповеститьОбЗаписиОбъектов(ДанныеДляОбработки);
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстОжиданиеРезультатаОбменаВЕТИС()
	
	Строки = Новый Массив;
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru='на %1 продукции %2 передан в ВетИС.'"), СтрокаТипОперации("Ожидание"), Наименование)));
	
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'Получение ответа от сервера может занять продолжительное время.
			           |Дождитесь ответа или закройте окно для продолжения
			           |выполнения операции в фоновом режиме.'")));
	
	ТекстОжидание = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОбОшибке(ТекстОшибки)
	
	Строки = Новый Массив;
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'Ошибка:'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
		
	ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОшибка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОУспешномРезультатеОбмена(Изменения)

	ОбъектЗапроса = Изменения[0].Объект;
	Если ТипЗнч(ОбъектЗапроса) = Тип("Массив") Тогда
		ОбъектЗапроса = Изменения[0].Объект[0];
	КонецЕсли;
	ПродукцияВЕТИС    = ОбъектЗапроса;
	ВходящееСообщение = Изменения[0].ВходящееСообщение;
	
	ПараметрыЗаписи = Новый Структура;
	Оповестить(
		"Запись_ПродукцияВЕТИС",
		ПараметрыЗаписи,
		ПродукцияВЕТИС);
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'На'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru = 'о %1 продукции %2 получен'"), СтрокаТипОперации("Получение"), Наименование)));
	
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ответ'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Строки.Добавить(".");
	Строки.Добавить(Символы.ПС);
	
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru = '%1 продукция'"), СтрокаТипОперации("Завершено"))));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(ПродукцияВЕТИС),, ЦветГиперссылки,, "ОткрытьРезультат"));
	Строки.Добавить(".");
	
	ТекстРезультат = Новый ФорматированнаяСтрока(Строки);
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросРезультат;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформациюОВидеТипеПродукции(Форма)
	
	ИнформацияОВидеТипеПродукции = ПродукцияВЕТИСВызовСервера.ИнформацияОВидеТипеПродукции(
		Форма.ТипПродукции,
		Форма.Продукция,
		Форма.ВидПродукции);
		
	Форма.ОписаниеПродукции = ИнформацияОВидеТипеПродукции.Текст;
	Форма.Элементы.ОписаниеПродукции.Подсказка = ИнформацияОВидеТипеПродукции.Подсказка;
	
КонецПроцедуры

&НаКлиенте
Функция СтрокаТипОперации(СтадияОперации)

	ТипОперацииСтрокой = "";
	Если РежимИзменения Тогда
		Если СтадияОперации = "Завершено" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'Изменена'");
		ИначеЕсли СтадияОперации = "Ожидание" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'изменение'");
		ИначеЕсли СтадияОперации = "Получение" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'изменение'");
		КонецЕсли;
	Иначе
		Если СтадияОперации = "Завершено" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'Добавлена'");
		ИначеЕсли СтадияОперации = "Ожидание" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'добавление'");
		ИначеЕсли СтадияОперации = "Получение" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'добавление'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТипОперацииСтрокой;

КонецФункции

&НаКлиенте
Процедура ОповеститьОбЗаписиОбъектов(ДанныеДляОбработки)
	
	Если ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена")
		И ДанныеДляОбработки.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ЗапросНаРегистрациюИзменениеПродукции") Тогда
		
		Оповестить("Запись_ПродукцияВЕТИС", ПродукцияВЕТИС, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПродукцияВЕТИСПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПродукцияВЕТИС.Идентификатор       КАК Идентификатор,
	|	ПродукцияВЕТИС.ИдентификаторВерсии КАК ИдентификаторВерсии
	|ИЗ
	|	Справочник.ПродукцияВЕТИС КАК ПродукцияВЕТИС
	|ГДЕ
	|	ПродукцияВЕТИС.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ПродукцияВЕТИС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		РезультатВыполненияЗапроса = ПродукцияВЕТИСВызовСервера.НаименованиеПродукцииПоGUID(Выборка.Идентификатор);
		Если РезультатВыполненияЗапроса.Элемент <> Неопределено Тогда
			
			ЭлементДанных = РезультатВыполненияЗапроса.Элемент;
			ДанныеПродукции = ИнтеграцияВЕТИС.ДанныеНаименованияПродукции(ЭлементДанных);
			
			Наименование           = ДанныеПродукции.Наименование;
			ТипПродукции           = ДанныеПродукции.ТипПродукции;
			Продукция              = ДанныеПродукции.Продукция;
			ВидПродукции           = ДанныеПродукции.ВидПродукции;
			GTIN                   = ДанныеПродукции.GTIN;
			Артикул                = ДанныеПродукции.Артикул;
			ГОСТ                   = ДанныеПродукции.ГОСТ;
			КодТНВЭД               = ДанныеПродукции.КодТНВЭД;
			СоответствуетГОСТ      = ДанныеПродукции.СоответствуетГОСТ;
			ИдентификаторВерсии    = ДанныеПродукции.ИдентификаторВерсии;
			
			ЗаполнитьСписокВыбораДоступныхЕдиницИзмерения();
			
			ФасовкаЕдиницаИзмерения          = ДанныеПродукции.ФасовкаЕдиницаИзмерения;
			ФасовкаКоличествоЕдиницВУпаковке = ДанныеПродукции.ФасовкаКоличествоЕдиницВУпаковке;
			ФасовкаКоличествоУпаковок        = ДанныеПродукции.ФасовкаКоличествоУпаковок;
			ФасовкаУпаковка                  = ДанныеПродукции.ФасовкаУпаковка;
			
			ХозяйствующийСубъектПроизводитель            = ДанныеПродукции.ХозяйствующийСубъектПроизводитель;
			ХозяйствующийСубъектСобственникТорговойМарки = ДанныеПродукции.ХозяйствующийСубъектСобственникТорговойМарки;
			
			Производители.Очистить();
			Для Каждого Производитель Из ДанныеПродукции.Производители Цикл
				НоваяСтрока = Производители.Добавить();
				НоваяСтрока.Производитель = Производитель;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормыВыбораВидаПродукции()
	ПараметрыФормыКлассификатора = Новый Структура("ВыборВидаПродукции", Истина);
	ОткрытьФорму("Обработка.КлассификаторыВЕТИС.Форма.КлассификаторИерархииПродукции",
		ПараметрыФормыКлассификатора,ЭтаФорма,,,,
		Новый ОписаниеОповещения("КлассификаторПродукцииПриЗавершенииВыбора",ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПродукцииПриЗавершенииВыбора(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ПолучитьИерархиюПродукции(Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьИерархиюПродукции(ВыбраннаяПродукция)
	
	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВыбраннаяПродукция, "ТипПродукции, Продукция");
	Если ЗначениеЗаполнено(Результат.Продукция) Тогда
		ВидПродукции = ВыбраннаяПродукция;
		Продукция    = Результат.Продукция;
		ТипПродукции = Результат.ТипПродукции;
	КонецЕсли;
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	ЗаполнитьСписокВыбораДоступныхЕдиницИзмерения();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораДоступныхЕдиницИзмерения()
	
	ДоступныеЕдиницыИзменения = Новый Массив;
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		ДоступныеЕдиницыИзменения = Новый Массив(ИнтеграцияВЕТИСПовтИсп.ДоступныеЕдиницыИзменения(ВидПродукции));
	КонецЕсли;
	
	Элементы.ФасовкаЕдиницаИзмерения.СписокВыбора.ЗагрузитьЗначения(ДоступныеЕдиницыИзменения);
	
	Если ДоступныеЕдиницыИзменения.Количество() = 1 Тогда
		ФасовкаЕдиницаИзмерения = ДоступныеЕдиницыИзменения[0];
	ИначеЕсли Элементы.ФасовкаЕдиницаИзмерения.СписокВыбора.НайтиПоЗначению(ФасовкаЕдиницаИзмерения) = Неопределено Тогда
		ФасовкаЕдиницаИзмерения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияЗаполнения(СтруктураЗаполнения)
	Если СтруктураЗаполнения.Свойство("ВидПродукции")
		И ЗначениеЗаполнено(СтруктураЗаполнения.ВидПродукции) Тогда
		
		ТипПродукции = СтруктураЗаполнения.ТипПродукции;
		Продукция    = СтруктураЗаполнения.Продукция;
		ВидПродукции = СтруктураЗаполнения.ВидПродукции;
	КонецЕсли;
	
	ХозяйствующийСубъектПроизводитель = СтруктураЗаполнения.ХозяйствующийСубъектПроизводитель;
	Если ЗначениеЗаполнено(СтруктураЗаполнения.Производитель) Тогда
		НоваяСтрока = Производители.Добавить();
		НоваяСтрока.Производитель = СтруктураЗаполнения.Производитель;
	КонецЕсли;
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	ЗаполнитьСписокВыбораДоступныхЕдиницИзмерения();
	
КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Если Форма.РежимИзменения Тогда
		
		Форма.Заголовок = НСтр("ru = 'Изменение продукции'");
		
	Иначе
		
		Форма.Заголовок = НСтр("ru = 'Создание продукции'");
		
	КонецЕсли;
	
	Если Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.СтраницаПродукция Тогда
		ВывестиИнформациюОВидеТипеПродукции(Форма);
	КонецЕсли;
	
	УправлениеЭлементамиНавигацииПомощника(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиНавигацииПомощника(Форма)

	Элементы = Форма.Элементы;
	Элементы.Закрыть.Заголовок = НСтр("ru = 'Закрыть'");
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПродукция Тогда
		
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Истина;
		Элементы.Закрыть.Видимость = Истина;
		Элементы.Далее.Заголовок = НСтр("ru = 'Далее'");
		
		Элементы.ПродукцияВЕТИС.Видимость = Форма.РежимИзменения;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОжидание Тогда
		
		Элементы.Назад.Видимость   = Ложь;
		Элементы.Далее.Видимость   = Ложь;
		Элементы.Закрыть.Заголовок = НСтр("ru = 'Продолжить в фоне'");
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОшибка Тогда
		
		Элементы.Назад.Видимость = Истина;
		Элементы.Далее.Видимость = Ложь;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросРезультат Тогда
		
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти