
#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСсылкуНаОсновнуюОрганизацию()
	
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецФункции

&НаСервере
Функция СформироватьТекстЗаголовка(Заголовок, Знач ИсходнаяСумма, РазделятьРазряды = Истина, ТекущаяСтраница)
	
	Если РазделятьРазряды И ИсходнаяСумма <> 0 Тогда
		ФорматированнаяСумма = Формат(ИсходнаяСумма, НСтр("ru = 'ЧДЦ=2; ЧРГ='' ''; ЧН=—; ЧГ=3,0'"));
		Разделитель = СтрДлина(ФорматированнаяСумма) - 3;
		СтрокаРазрядТысячи = Лев(ФорматированнаяСумма, Разделитель - 4);
		СтрокаРазрядЕдиницы = Сред(ФорматированнаяСумма, Разделитель - 3);
	Иначе
		ФорматированнаяСумма = Формат(ИсходнаяСумма, НСтр("ru = 'ЧДЦ=0; ЧРГ='' ''; ЧН=—; ЧГ=3,0'"));
	КонецЕсли;
	
	ЭлементыСтроки = Новый Массив;
	ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, Заголовок, , WebЦвета.Серый); 
	ЭлементыСтроки.Добавить(Новый Структура("Строка", Символы.ПС));
	
	Если РазделятьРазряды И ИсходнаяСумма <> 0 Тогда
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина, , , , 300);
		ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, СтрокаРазрядТысячи, Шрифт, WebЦвета.Золотой);
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , , , , , 250);
		ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, СтрокаРазрядЕдиницы, Шрифт, WebЦвета.Золотой);
	ИначеЕсли ИсходнаяСумма = 0 Тогда
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , , , , , 200);
		ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, НСтр("ru = 'нет данных'"), Шрифт, WebЦвета.Золотой);
	Иначе
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина, , , , 300);
		ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, Строка(ИсходнаяСумма), Шрифт, WebЦвета.Золотой);
	КонецЕсли;
	
	Возврат СкомпоноватьФорматированнуюСтроку(ЭлементыСтроки);
	
КонецФункции

&НаКлиенте
Функция ПолучитьИндикаторТекущейСтраницы(ТекущаяСтраница)
	
	Индикатор = "○○○○○";
	
	Если ТекущаяСтраница = 1 Тогда
		Индикатор = "●○○○○";
	ИначеЕсли ТекущаяСтраница = 2 Тогда
		Индикатор = "○●○○○";
	ИначеЕсли ТекущаяСтраница = 3 Тогда
		Индикатор = "○○●○○";
	ИначеЕсли ТекущаяСтраница = 4 Тогда
		Индикатор = "○○○●○";
	ИначеЕсли ТекущаяСтраница = 5 Тогда
		Индикатор = "○○○○●";
	КонецЕсли;
	
	Возврат Индикатор;
	
КонецФункции

&НаСервере
Процедура ПолучитьНазваниеОрганизации()
	
	МояФирма = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.Организации.ОрганизацияПоУмолчанию(),"Наименование");
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКоличествоЗаказовВРаботеНаСервере()
	
	Элементы.ЗаказовВРаботе.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='заказов в работе';en='Orders In Progress'"),
		ПолучитьКоличествоЗаказовВСостоянииВРаботе(),
		Ложь,
		2);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСуммуОстаткаТоваров() 
	
	Запрос = Новый Запрос();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ЕСТЬNULL(ОстаткиТоваровОстатки.КоличествоОстаток, 0) * ЕСТЬNULL(ЦеныПоставщиковСрезПоследних.Цена, 0)), 0) КАК СуммаОстатка
	|ИЗ
	|	РегистрНакопления.Запасы.Остатки КАК ОстаткиТоваровОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних КАК ЦеныПоставщиковСрезПоследних
	|		ПО ОстаткиТоваровОстатки.Номенклатура = ЦеныПоставщиковСрезПоследних.Номенклатура";
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаОстатков.Следующий() Тогда
		Возврат ВыборкаОстатков.СуммаОстатка;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьКоличествоЗаказовВРаботе()
	
	ПолучитьКоличествоЗаказовВРаботеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуЗаказовВРаботеНаСервере()
	
	Элементы.ЗаказовНаСумму.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='сумма заказов в работе';en='Amount Of Orders'"),
		ПолучитьСуммуЗаказовВСостоянииВРаботе(),
		Истина,
		1);
	
КонецПроцедуры

Функция ПолучитьКоличествоЗаказовВСостоянииВРаботе() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Заказ.Ссылка) КАК КоличествоЗаказов
	|ИЗ
	|	Документ.ЗаказПокупателя КАК Заказ
	|ГДЕ
	|	НЕ Заказ.ПометкаУдаления
	|	И Заказ.Проведен
	|	И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.Завершен)";
	
	ВыборкаЗаказов = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗаказов.Следующий() Тогда
		Возврат ВыборкаЗаказов.КоличествоЗаказов;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСуммуЗаказовВСостоянииВРаботе() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Заказ.СуммаДокумента), 0) КАК СуммаЗаказов
	|ИЗ
	|	Документ.ЗаказПокупателя КАК Заказ
	|ГДЕ
	|	НЕ Заказ.ПометкаУдаления
	|	И Заказ.Проведен
	|	И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.Завершен)";
	
	ВыборкаЗаказов = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗаказов.Следующий() Тогда
		Возврат ВыборкаЗаказов.СуммаЗаказов;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьСуммуЗаказовВРаботе()
	
	ПолучитьСуммуЗаказовВРаботеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуОстаткаТоваровВЦенахПоставщиковНаСервере()
	
	Элементы.ТоваровНаСумму.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='остаток товаров на сумму';en='Goods In The Amount'"),
		ПолучитьСуммуОстаткаТоваров(),
		Истина,
		3);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков()
	
	ПолучитьСуммуОстаткаТоваровВЦенахПоставщиковНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуОстаткаНашихДолговНаСервере()
	
	Элементы.МыДолжны.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='мы должны';en='Our Duty'"),
		ПолучитьОстатокНашихДолгов(),
		Истина,
		5);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуОстаткаНашихДолгов()
	
	ПолучитьСуммуОстаткаНашихДолговНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОстатокНашихДолгов()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаОстаток,
	|	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.Остатки КАК ВзаиморасчетыСКонтрагентамиОстатки";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	
	СуммаОстаток = ТаблицаРезультатаЗапроса.Итог("СуммаОстаток");
	
	Возврат - СуммаОстаток;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОстатокДолговНам()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаОстаток,
	|	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями.Остатки КАК ВзаиморасчетыСКонтрагентамиОстатки";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	
	СуммаОстаток = ТаблицаРезультатаЗапроса.Итог("СуммаОстаток");
	
	Возврат СуммаОстаток;
	
КонецФункции

&НаСервере
Процедура ПолучитьСуммуОстаткаДолговНамНаСервере()
	
	Элементы.ДолгиНам.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='долги нам';en='Debt Us'"),
		ПолучитьОстатокДолговНам(),
		Истина,
		4);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуОстаткаДолговНам()
	
	ПолучитьСуммуОстаткаДолговНамНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, Текст, Шрифт = Неопределено, Цвет = Неопределено)
	
	НовыйЭлемент = Новый Структура;
	НовыйЭлемент.Вставить("Строка", Текст);
	Если Шрифт = Неопределено Тогда
		НовыйЭлемент.Вставить("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста));
	Иначе
		НовыйЭлемент.Вставить("Шрифт", Шрифт);
	КонецЕсли;
	Если Цвет = Неопределено Тогда
		НовыйЭлемент.Вставить("ЦветТекста", ЦветаСтиля.ЦветТекстаФормы);
	Иначе
		НовыйЭлемент.Вставить("ЦветТекста", Цвет);
	КонецЕсли; 
	ЭлементыСтроки.Добавить(НовыйЭлемент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СкомпоноватьФорматированнуюСтроку(ЭлементыСтроки)
	
	Строка = "";
	Шрифт = Неопределено;
	ЦветТекста = Неопределено;
	ЦветФона = Неопределено;
	МассивФорматированныхСтрок = Новый Массив;
	
	Для Каждого Элемент Из ЭлементыСтроки Цикл
		Элемент.Свойство("Строка", Строка);
		Элемент.Свойство("Шрифт", Шрифт);
		Элемент.Свойство("ЦветТекста", ЦветТекста);
		Элемент.Свойство("ЦветФона", ЦветФона);
		МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(Строка, Шрифт, ЦветТекста, ЦветФона)); 
	КонецЦикла;
	
	
	Возврат Новый ФорматированнаяСтрока(МассивФорматированныхСтрок); // АПК:1356 - можно использовать составную форматированную строку,
																	 // так как массив строк формируется из переданного в функцию текста.
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьНазваниеОрганизации();
	
	НужноОбновитьИнтерфейс = Ложь;
	
	ТекущийРежимЗапускаУНФ = Константы.ТекущийРежимЗапускаУНФ.Получить();
	Если ТекущийРежимЗапускаУНФ = Перечисления.РежимыЗапускаУНФ.МобильноеПриложение Тогда
		Запрос = Новый Запрос();
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СборкаЗапасов.Ссылка
		|ИЗ
		|	Документ.СборкаЗапасов КАК СборкаЗапасов";
		Выборка = Запрос.Выполнить().Выбрать();
		ПодсистемаПроизводствоВключена = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Получить();
		Если Выборка.Следующий() Тогда
			Если НЕ ПодсистемаПроизводствоВключена Тогда
				Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Установить(Истина);
				НужноОбновитьИнтерфейс = Истина;
			КонецЕсли;
		Иначе
			Если ПодсистемаПроизводствоВключена Тогда
				Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Установить(Ложь);
				НужноОбновитьИнтерфейс = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Получить();
	Элементы.Группа12.Видимость = ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб;
	Элементы.Группа11.Видимость = ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб;
	Элементы.Группа17.Видимость = ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьНастройки" Тогда
		ПолучитьНазваниеОрганизации();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилсяЗаказ" Тогда
		ПодключитьОбработчикОжидания("ПолучитьСуммуЗаказовВРаботе", 0.1, Истина);
		ПодключитьОбработчикОжидания("ПолучитьКоличествоЗаказовВРаботе", 0.2, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилосьКоличествоТовара" Тогда
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилосьКоличествоТовара"
		ИЛИ ИмяСобытия = "ИзменилосьКоличествоДенег" Тогда
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаНашихДолгов", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПолучитьСуммуЗаказовВРаботе", 0.1, Истина);
	ПодключитьОбработчикОжидания("ПолучитьКоличествоЗаказовВРаботе", 0.2, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаНашихДолгов", 0.5, Истина);
	
	Если НужноОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Настройки(Команда)
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", Новый Структура("Ключ", ПолучитьСсылкуНаОсновнуюОрганизацию()));
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийВиджет(Направление)
	
	ТекущийВиджет = ПолучитьИндексТекущегоВиджета();
	
	Если ТекущийВиджет + Направление > 5 Тогда
		ПоказатьВиджет(1);
	ИначеЕсли ТекущийВиджет + Направление < 1 Тогда
		ПоказатьВиджет(5);
	Иначе
		ПоказатьВиджет(ТекущийВиджет + Направление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИндексТекущегоВиджета()
	
	ТекущийВиджет = 0;
	
	Если Элементы.ЗаказовНаСумму.Видимость Тогда
		ТекущийВиджет = 1;
	ИначеЕсли Элементы.ЗаказовВРаботе.Видимость Тогда
		ТекущийВиджет = 2;
	ИначеЕсли Элементы.ТоваровНаСумму.Видимость Тогда
		ТекущийВиджет = 3;
	ИначеЕсли Элементы.ДолгиНам.Видимость Тогда
		ТекущийВиджет = 4;
	ИначеЕсли Элементы.МыДолжны.Видимость Тогда
		ТекущийВиджет = 5;
	КонецЕсли;
	
	Возврат ТекущийВиджет;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВиджет(НомерВиджета)
	
	Элементы.ЗаказовНаСумму.Видимость = Ложь;
	Элементы.ЗаказовВРаботе.Видимость = Ложь;
	Элементы.ТоваровНаСумму.Видимость = Ложь;
	Элементы.ДолгиНам.Видимость = Ложь;
	Элементы.МыДолжны.Видимость = Ложь;
	
	Если НомерВиджета = 1 Тогда
		Элементы.ЗаказовНаСумму.Видимость = Истина;
	ИначеЕсли НомерВиджета = 2 Тогда
		Элементы.ЗаказовВРаботе.Видимость = Истина;
	ИначеЕсли НомерВиджета = 3 Тогда
		Элементы.ТоваровНаСумму.Видимость = Истина;
	ИначеЕсли НомерВиджета = 4 Тогда
		Элементы.ДолгиНам.Видимость = Истина;
	ИначеЕсли НомерВиджета = 5 Тогда
		Элементы.МыДолжны.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ДекорацияИндикатор.Заголовок = ПолучитьИндикаторТекущейСтраницы(НомерВиджета);
	
КонецПроцедуры

&НаКлиенте
Процедура Лево(Команда)
	
	СледующийВиджет(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура Право(Команда)
	
	СледующийВиджет(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ЗаказПокупателя.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация3Нажатие(Элемент)
	
	ОткрытьФорму("Документ.РасходнаяНакладная.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация5Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ПоступлениеВКассу.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация7Нажатие(Элемент)
	
	ОткрытьФорму("Документ.РасходИзКассы.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация11Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ЗаказПокупателя.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация15Нажатие(Элемент)
	
	ОткрытьФорму("Документ.РасходнаяНакладная.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация17Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация13Нажатие(Элемент)
	
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКассе.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация19Нажатие(Элемент)
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация21Нажатие(Элемент)
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация31Нажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	Вариант =  СсылкаВариантаОтчета("ДвижениеДенежныхСредств", "Основной");
	ВариантыОтчетовКлиент.ОткрытьФормуОтчета(ЭтаФорма, Вариант, ПараметрыОткрытия);
	
КонецПроцедуры

Функция СсылкаВариантаОтчета(ИмяОтчета, КлючВарианта)
	
	Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Отчет." + ИмяОтчета);
	Возврат ВариантыОтчетов.ВариантОтчета(Отчет, КлючВарианта);
	
КонецФункции

&НаКлиенте
Процедура Декорация25Нажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	Вариант =  СсылкаВариантаОтчета("Продажи", "Основной");
	ВариантыОтчетовКлиент.ОткрытьФормуОтчета(ЭтаФорма, Вариант, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация33Нажатие(Элемент)
	
	ПодключитьОбработчикОжидания("ПолучитьСуммуЗаказовВРаботе", 0.1, Истина);
	ПодключитьОбработчикОжидания("ПолучитьКоличествоЗаказовВРаботе", 0.2, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаНашихДолгов", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация9Нажатие(Элемент)
	
	ОткрытьФорму("Документ.СборкаЗапасов.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация23Нажатие(Элемент)
	
	ОткрытьФорму("Документ.СборкаЗапасов.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти
