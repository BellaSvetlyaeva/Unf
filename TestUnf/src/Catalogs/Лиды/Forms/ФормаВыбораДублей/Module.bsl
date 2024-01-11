
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контакты = Новый Массив;
	
	Параметры.Свойство("Наименование", Наименование);
	Параметры.Свойство("НаименованиеПолное", НаименованиеПолное);
	Параметры.Свойство("ТипКИ", ТипКИ);
	Параметры.Свойство("СсылкаНаРедактируемыйОбъект", СсылкаНаРедактируемыйОбъект);
	Параметры.Свойство("ПредставлениеКИ", ПредставлениеКИ);
		
	ОбновитьТаблицуДублей();
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПроизведенаЗаменаСсылок" Тогда
		ОбновитьТаблицуДублей();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Контрагент" Тогда
		ОбновитьТаблицуДублей();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму(ИмяФормыПоТипуСсылки(Элементы.ТаблицаДублей.ТекущиеДанные.Тип),
		ПараметрыПередачи, 
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДублейПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокументыПоКонтрагенту(Команда)
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные.Тип = "Лид" ИЛИ 
		Элементы.ТаблицаДублей.ТекущиеДанные.Тип = "Контакт" Тогда
		
		ПараметрыСобытий = Новый Структура("Контакт", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Документ.Событие.Форма.ФормаСписка", ПараметрыСобытий,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура("Контрагент", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);	
	ПараметрыФормы = Новый Структура(
			"Отбор, КлючНастроек, СформироватьПриОткрытии",
			СтруктураОтбора,
			"Контрагент",
			Истина);
	
	ОткрытьФорму("Обработка.ДокументыПоКритериюОтбора.Форма.СписокДокументов",
		ПараметрыФормы,
		ЭтотОбъект,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьКонтрагентов(Команда)
	
	МассивКонтрагентов = Новый Массив;
	ДублиКонтрагентов = ТаблицаДублей.НайтиСтроки(Новый Структура("Тип", "Контрагент"));
	
	Для Каждого Дубль Из ДублиКонтрагентов Цикл
		МассивКонтрагентов.Добавить(Дубль.Ссылка);
	КонецЦикла;
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(МассивКонтрагентов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьКонтакты(Команда)
	
	МассивКонтактов = Новый Массив;
	ДублиКонтактов = ТаблицаДублей.НайтиСтроки(Новый Структура("Тип", "Контакт"));
	
	Для Каждого Дубль Из ДублиКонтактов Цикл
		МассивКонтактов.Добавить(Дубль.Ссылка);
	КонецЦикла;
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(МассивКонтактов);
	
КонецПроцедуры

&НаКлиенте
Процедура НекачественныйЛид(Команда)
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка) <> Тип("СправочникСсылка.Лиды") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЕстьПравоПоРЛС(Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка) Тогда
		ТекстПредупреждения = НСтр("ru = 'Нет прав на чтение объекта'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;

	НекачественныйЛид = Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка;
	Оповещение = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыНекачественногоЛида",ЭтотОбъект);
	ОткрытьФорму("Справочник.Лиды.Форма.ФормаНекачественныйЛидКанбан",,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьЛиды(Команда)
	
	МассивЛидов = Новый Массив;
	ДублиЛидов = ТаблицаДублей.НайтиСтроки(Новый Структура("Тип", "Контакт"));
	
	Для Каждого Дубль Из ДублиЛидов Цикл
		МассивЛидов.Добавить(Дубль.Ссылка);
	КонецЦикла;
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(МассивЛидов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиККонтакту(Команда)
	
	ТекущийКонтакт = Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка;
	ЕстьПравоПоРЛС = ЕстьПравоПоРЛС(ТекущийКонтакт);
	
	Если НЕ ЕстьПравоПоРЛС Тогда
		ТекстПредупреждения = НСтр("ru = 'Нет прав на чтение объекта'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ПараметрыКонтрагента = Новый Структура("Ключ", ТекущийКонтакт);
	ОткрытьФорму("Справочник.КонтактныеЛица.Форма.ФормаЭлемента", ПараметрыКонтрагента);

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЛиду(Команда)
	
	ТекущийЛид    = Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка;
	ЕстьПравоПоРЛС = ЕстьПравоПоРЛС(ТекущийЛид);

	Если ЗначениеЗаполнено(СсылкаНаРедактируемыйОбъект) Тогда
		ПараметрыКонтрагента = Новый Структура("Ключ", ТекущийЛид);
		ОткрытьФорму("Справочник.Лиды.Форма.ФормаЭлемента", ПараметрыКонтрагента);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЕстьПравоПоРЛС Тогда
		ТекстПредупреждения = НСтр("ru = 'Нет прав на чтение объекта'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ВариантЗавершения = ВариантЗавершенияЛида(ТекущийЛид);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВопросПерейтиКОбъекту",ЭтотОбъект);
	Если НЕ ЗначениеЗаполнено(ВариантЗавершения) Тогда
		ТекстВопроса = НСтр("ru = 'Продолжить работу с выбранным лидом без сохранения текущего?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Лид помечен как некачественный. Продолжить работу с выбранным лидом без сохранения текущего?'");
	КонецЕсли; 
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиККонтрагенту(Команда)
	
	ТекущийКонтрагент    = Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка;
	ЕстьПравоПоРЛС = ЕстьПравоПоРЛС(ТекущийКонтрагент);
	
	Если НЕ ЕстьПравоПоРЛС Тогда
		ТекстПредупреждения = НСтр("ru = 'Нет прав на чтение объекта'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ПараметрыКонтрагента = Новый Структура("Ключ", ТекущийКонтрагент);
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыКонтрагента);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьТаблицуДублей()
		
	Если ЗначениеЗаполнено(Наименование) Тогда
		ОбновитьСписокДублейПоНаименованию();
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеПолное) Тогда
		ОбновитьСписокДублейПоПолномуНаименованию();
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипКИ) Тогда
		ОбновитьСписокДублейПоКИ();
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДублейПоПолномуНаименованию()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 20
	|	Контрагенты.Ссылка КАК Ссылка,
	|	Контрагенты.Код КАК Код,
	|	Контрагенты.Наименование КАК Наименование,
	|	ВЫРАЗИТЬ(Контрагенты.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолное,
	|	""Контрагент"" КАК Тип,
	|	1 КАК РеквизитДопУпорядочивания,
	|	ВЫБОР
	|		КОГДА Контрагенты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК СостояниеЭлементов,
	|	Контрагенты.Ответственный.Наименование КАК ОтветственныйНаименование
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	(Контрагенты.НаименованиеПолное ПОДОБНО &Наименование
	|			ИЛИ Контрагенты.Наименование ПОДОБНО &Наименование)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Контакты.Ссылка,
	|	Контакты.Код,
	|	Контакты.Наименование,
	|	"""",
	|	""Контакт"",
	|	2,
	|	ВЫБОР
	|		КОГДА Контакты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Контакты.Ответственный.Наименование
	|ИЗ
	|	Справочник.КонтактныеЛица КАК Контакты
	|ГДЕ
	|	Контакты.Наименование ПОДОБНО &Наименование
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Лиды.Ссылка,
	|	Лиды.Код,
	|	Лиды.Наименование,
	|	ВЫРАЗИТЬ(Лиды.НаименованиеКомпании КАК СТРОКА(1000)),
	|	""Лид"",
	|	3,
	|	ВЫБОР
	|		КОГДА Лиды.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Лиды.Ответственный.Наименование
	|ИЗ
	|	Справочник.Лиды КАК Лиды
	|ГДЕ
	|	Лиды.ВариантЗавершения <> ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.ПереведенВПокупателя)
	|	И (Лиды.НаименованиеКомпании ПОДОБНО &Наименование
	|			ИЛИ Лиды.Наименование ПОДОБНО &Наименование)
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания,
	|	Наименование";
	
	Запрос.УстановитьПараметр("Наименование", НаименованиеПолное);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДублей.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДублейПоКИ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 20
	|	Контрагенты.Ссылка КАК Ссылка,
	|	Контрагенты.Код КАК Код,
	|	Контрагенты.Наименование КАК Наименование,
	|	ВЫРАЗИТЬ(Контрагенты.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолное,
	|	ВЫРАЗИТЬ(Контрагенты.АдресЭПДляПоиска КАК СТРОКА(1000)) КАК ПредставлениеКИ,
	|	""Контрагент"" КАК Тип,
	|	1 КАК РеквизитДопУпорядочивания,
	|	ВЫБОР
	|		КОГДА Контрагенты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК СостояниеЭлементов,
	|	Контрагенты.Ответственный.Наименование КАК ОтветственныйНаименование
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.АдресЭПДляПоиска ПОДОБНО &ПредставлениеКИ
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Контакты.Ссылка,
	|	Контакты.Код,
	|	Контакты.Наименование,
	|	"""",
	|	ВЫРАЗИТЬ(Контакты.АдресЭПДляПоиска КАК СТРОКА(1000)),
	|	""Контакт"",
	|	2,
	|	ВЫБОР
	|		КОГДА Контакты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Контакты.Ответственный.Наименование
	|ИЗ
	|	Справочник.КонтактныеЛица КАК Контакты
	|ГДЕ
	|	Контакты.АдресЭПДляПоиска ПОДОБНО &ПредставлениеКИ
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Лиды.Ссылка,
	|	Лиды.Код,
	|	Лиды.Наименование,
	|	ВЫРАЗИТЬ(Лиды.НаименованиеКомпании КАК СТРОКА(1000)),
	|	ВЫРАЗИТЬ(Лиды.АдресЭПДляПоиска КАК СТРОКА(1000)),
	|	""Лид"",
	|	3,
	|	ВЫБОР
	|		КОГДА Лиды.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Лиды.Ответственный.Наименование
	|ИЗ
	|	Справочник.Лиды КАК Лиды
	|ГДЕ
	|	Лиды.ВариантЗавершения <> ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.ПереведенВПокупателя)
	|	И Лиды.АдресЭПДляПоиска ПОДОБНО &ПредставлениеКИ
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания,
	|	Наименование";
	
	Если ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "АдресЭП", "НомерТелефона");
		ПредставлениеКИ = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(ПредставлениеКИ);
		ПредставлениеКИ = СтрЗаменить(ПредставлениеКИ, "+", "");
		Если СтрНачинаетсяС(ПредставлениеКИ, "7") Тогда
			ПредставлениеКИ = Сред(ПредставлениеКИ, 2, СтрДлина(ПредставлениеКИ) - 1);
		КонецЕсли;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПредставлениеКИ", "%"+ПредставлениеКИ+"%");
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДублей.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Дубль Из ТаблицаДублей Цикл
		
		ИндексКИ = СтрНайти(Дубль.ПредставлениеКИ, ПредставлениеКИ);
		КонечныйИндекс = СтрНайти(Дубль.ПредставлениеКИ,",",,ИндексКИ);
		КонечныйИндекс = ?(КонечныйИндекс = 0, СтрДлина(Дубль.ПредставлениеКИ), КонечныйИндекс - 1);
		
		Дубль.ПредставлениеКИ = Сред(Дубль.ПредставлениеКИ, ИндексКИ, КонечныйИндекс - 1);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДублейПоНаименованию()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 20
	|	Контрагенты.Ссылка КАК Ссылка,
	|	Контрагенты.Код КАК Код,
	|	Контрагенты.Наименование КАК Наименование,
	|	""Контрагент"" КАК Тип,
	|	1 КАК РеквизитДопУпорядочивания,
	|	ВЫБОР
	|		КОГДА Контрагенты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК СостояниеЭлементов,
	|	Контрагенты.Ответственный.Наименование КАК ОтветственныйНаименование
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	(Контрагенты.НаименованиеПолное ПОДОБНО &Наименование
	|			ИЛИ Контрагенты.Наименование ПОДОБНО &Наименование)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Контакты.Ссылка,
	|	Контакты.Код,
	|	Контакты.Наименование,
	|	""Контакт"",
	|	2,
	|	ВЫБОР
	|		КОГДА Контакты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Контакты.Ответственный.Наименование
	|ИЗ
	|	Справочник.КонтактныеЛица КАК Контакты
	|ГДЕ
	|	Контакты.Наименование ПОДОБНО &Наименование
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Лиды.Ссылка,
	|	Лиды.Код,
	|	Лиды.Наименование,
	|	""Лид"",
	|	3,
	|	ВЫБОР
	|		КОГДА Лиды.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Лиды.Ответственный.Наименование
	|ИЗ
	|	Справочник.Лиды КАК Лиды
	|ГДЕ
	|	Лиды.ВариантЗавершения <> ЗНАЧЕНИЕ(Перечисление.ВариантЗавершенияРаботыСЛидом.ПереведенВПокупателя)
	|	И (Лиды.Наименование ПОДОБНО &Наименование
	|			ИЛИ Лиды.НаименованиеКомпании ПОДОБНО &Наименование)
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания,
	|	Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДублей.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаКомандыКонтрагентов.Доступность = Элементы.ТаблицаДублей.ТекущиеДанные.Тип = "Контрагент";
	Элементы.ГруппаКомандыКонтактов.Доступность    = Элементы.ТаблицаДублей.ТекущиеДанные.Тип = "Контакт";
	Элементы.ГруппаКомандыЛидов.Доступность        = Элементы.ТаблицаДублей.ТекущиеДанные.Тип = "Лид";
	
	Элементы.ОткрытьДокументыПоКонтрагенту.Заголовок = ЗаголовокГиперссылкиДокументы(Элементы.ТаблицаДублей.ТекущиеДанные)
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоДокументовКонтрагента(Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокументыПоКритериюОтбора.Ссылка) КАК КоличествоДокументов
		|ИЗ
		|	КритерийОтбора.ДокументыПоКонтрагенту(&Контрагент) КАК ДокументыПоКритериюОтбора";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.КоличествоДокументов;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

&НаКлиенте
Процедура Изменить(Команда)
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму(ИмяФормыПоТипуСсылки(Элементы.ТаблицаДублей.ТекущиеДанные.Тип),
		ПараметрыПередачи,
		Элементы.ТаблицаДублей);

КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ТаблицаДублейНаименованиеПолное.Видимость = ЗначениеЗаполнено(НаименованиеПолное);
	Элементы.ТаблицаДублейПредставлениеКИ.Видимость    = ЗначениеЗаполнено(ТипКИ);
	Элементы.ТаблицаДублейПредставлениеКИ.Заголовок = 
		?(ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон, НСтр("ru = 'Телефон'"), НСтр("ru = 'E-mail'"));
	
	Заголовок = ЗаголовокФормы();

	Контрагенты = ТаблицаДублей.НайтиСтроки(Новый Структура("Тип", "Контрагент"));
	Контакты    = ТаблицаДублей.НайтиСтроки(Новый Структура("Тип", "Контакт"));
	Лиды        = ТаблицаДублей.НайтиСтроки(Новый Структура("Тип", "Лид"));
	
	Элементы.ОбъединитьКонтрагентов.Видимость = Контрагенты.Количество() > 1;
	Элементы.ОбъединитьКонтакты.Видимость     = Контакты.Количество() > 1;
	Элементы.ОбъединитьЛиды.Видимость        = Лиды.Количество() > 1;
	
	Элементы.ПерейтиККонтрагенту.Видимость = Контрагенты.Количество() > 0;
	Элементы.ПерейтиККонтакту.Видимость    = Контрагенты.Количество() = 0 И Контакты.Количество() > 0;
	Элементы.ПерейтиКЛиду.Видимость        = Контрагенты.Количество() = 0 И Контакты.Количество() = 0 И Лиды.Количество() > 0;
	Элементы.НекачественныйЛид.Видимость   = Лиды.Количество() > 0;
		
КонецПроцедуры

&НаСервере
Функция ЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Список дублей по '");
	
	Если ЗначениеЗаполнено(ПредставлениеКИ) Тогда
		КИ = ?(ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон, НСтр("ru='номеру телефона'"), НСтр("ru='e-mail'"));
		Возврат Заголовок + КИ;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеПолное) Тогда
		Заголовок = Заголовок + НСтр("ru='юр.названию'");
		Возврат Заголовок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		Заголовок = Заголовок + НСтр("ru='представлению'");
		Возврат Заголовок;
	КонецЕсли;
		
КонецФункции

&НаСервере
Функция ЕстьПравоПоРЛС(Ссылка)
	Возврат УправлениеДоступом.ЧтениеРазрешено(Ссылка);
КонецФункции

&НаСервере
Функция ВариантЗавершенияЛида(ТекущийЛид)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийЛид, "ВариантЗавершения");
КонецФункции

&НаКлиенте
Процедура ОбработатьВопросПерейтиКОбъекту(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ВыбранДубльЛида", Истина);
	ПараметрыЗакрытия.Вставить("ВыбранныйЛид",    Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Функция ИмяФормыПоТипуСсылки(Тип)
	
	Если Тип = "Контрагент" Тогда
		Возврат "Справочник.Контрагенты.ФормаОбъекта";
	КонецЕсли;
	
	Если Тип = "Контакт" Тогда
		Возврат "Справочник.КонтактныеЛица.ФормаОбъекта";
	КонецЕсли;
	
	Если Тип = "Лид" Тогда
		Возврат "Справочник.Лиды.ФормаОбъекта";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ЗаголовокГиперссылкиДокументы(ТекущиеДанные)
	
	КоличествоДокументов = ПолучитьКоличествоДокументовКонтрагента(ТекущиеДанные.Ссылка);
	
	Если ТекущиеДанные.Тип = "Контрагент" Тогда
		Возврат СтрШаблон(НСтр("ru='Документы (%1)'"), КоличествоДокументов);
	КонецЕсли;
	
	Если ТекущиеДанные.Тип = "Контакт" Тогда
		Возврат СтрШаблон(НСтр("ru='События (%1)'"), КоличествоДокументов);
	КонецЕсли;
	
	Если ТекущиеДанные.Тип = "Лид" Тогда
		Возврат СтрШаблон(НСтр("ru='События (%1)'"), КоличествоДокументов);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыНекачественногоЛида(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПеревестиВНекачественныйЛидСервер(Результат);

КонецПроцедуры

&НаСервере
Процедура ПеревестиВНекачественныйЛидСервер(ДанныеНекачественногоЛида)
	
	Попытка
		
		ЛидОбъект = НекачественныйЛид.ПолучитьОбъект();
		
		ЛидОбъект.СостояниеЛида = Справочники.СостоянияЛидов.Завершен;
		ЛидОбъект.ДатаЗавершенияРаботы = ТекущаяДатаСеанса();
		ЛидОбъект.ВариантЗавершения = Перечисления.ВариантЗавершенияРаботыСЛидом.НекачественныйЛид;
		ЛидОбъект.ПричинаНеуспешногоЗавершенияРаботы = ДанныеНекачественногоЛида.ПричинаНеуспешногоЗавершенияРаботы;
		ЛидОбъект.ЗаметкиЗавершенияРаботы = ДанныеНекачественногоЛида.Комментарий;
		
		ЛидОбъект.Записать();
		
		Лид = ТаблицаДублей.НайтиСтроки(Новый Структура("Ссылка", НекачественныйЛид.Ссылка));
		ТаблицаДублей.Удалить(ТаблицаДублей.Индекс(Лид[0]));
		
	Исключение
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), НекачественныйЛид);
	КонецПопытки;
	
	НекачественныйЛид = Справочники.Лиды.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти
