
#Область СлужебныеПроцедурыИФункции

// Функция - Код классификатора номенклатуры ЕГАИС
//
// Параметры:
//  ШтрихкодАкцизнойМарки - Строка - Штрихкод акцизной марки
//  КэшКодовАлкогольнойПродукции - Неопределено, Соответствие - кэшированные значения
// 
// Возвращаемое значение:
//  Строка - строка с кодом номенклатуры по классификатору егаис
//
Функция КодКлассификатораНоменклатурыЕГАИС(ШтрихкодАкцизнойМарки, КэшКодовАлкогольнойПродукции = Неопределено) Экспорт
	
	Возврат АкцизныеМаркиКлиентСервер.КодКлассификатораНоменклатурыЕГАИС(ШтрихкодАкцизнойМарки, КэшКодовАлкогольнойПродукции);
	
КонецФункции

// Заполняет сопоставленную номенклатуру и данные классификатора по считанной акцизной марке.
//
Процедура ЗаполнитьСопоставленнуюНоменклатуруПоАкцизнойМарке(Штрихкод, ДанныеШтрихкода, КэшКодовАлкогольнойПродукции = Неопределено) Экспорт
	
	Если ДанныеШтрихкода.СоставКодаМаркировки <> Неопределено
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкода.СоставКодаМаркировки, "КодАлкогольнойПродукции") Тогда
		КодАлкогольнойПродукции = ДанныеШтрихкода.СоставКодаМаркировки.КодАлкогольнойПродукции;
	Иначе
		КодАлкогольнойПродукции = КодКлассификатораНоменклатурыЕГАИС(Штрихкод, КэшКодовАлкогольнойПродукции);
	КонецЕсли;
	
	ДанныеШтрихкода.МаркируемаяПродукция    = Истина;
	ДанныеШтрихкода.КодАлкогольнойПродукции = КодАлкогольнойПродукции;
	
	ПустаяНоменклатура         = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Номенклатура");
	ПустаяХарактеристика       = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("ХарактеристикаНоменклатуры");
	ПустаяСерия                = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("СерияНоменклатуры");
	ПустаяСправка2             = Справочники.Справки2ЕГАИС.ПустаяСсылка();
	
	СписокЗапросов = Новый СписокЗначений;
	
	СписокЗапросов.Добавить(
	"ВЫБРАТЬ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка                            КАК АлкогольнаяПродукция,
	|	ЕСТЬNULL(ДанныеШтрихкодовУпаковок.Номенклатура,   &ПустаяНоменклатура)   КАК Номенклатура,
	|	ЕСТЬNULL(ДанныеШтрихкодовУпаковок.Характеристика, &ПустаяХарактеристика) КАК Характеристика,
	|	ЕСТЬNULL(ДанныеШтрихкодовУпаковок.Серия,          &ПустаяСерия)          КАК Серия,
	|	ЕСТЬNULL(ДанныеШтрихкодовУпаковок.Справка2,       &ПустаяСправка2)       КАК Справка2,
	|	ЕСТЬNULL(ДанныеШтрихкодовУпаковок.ИдентификаторУпаковки, """")           КАК ИдентификаторУпаковки
	|ПОМЕСТИТЬ ДанныеШтрихкодовУпаковок
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК ДанныеШтрихкодовУпаковок
	|		ПРАВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО ДанныеШтрихкодовУпаковок.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|ГДЕ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Код = &КодАлкогольнойПродукции");
	
	СписокЗапросов.Добавить(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	|	ДанныеШтрихкодовУпаковок.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	ДанныеШтрихкодовУпаковок.Номенклатура             КАК Номенклатура,
	|	ДанныеШтрихкодовУпаковок.Характеристика           КАК Характеристика,
	|	ДанныеШтрихкодовУпаковок.Серия                    КАК Серия,
	|	ДанныеШтрихкодовУпаковок.Справка2                 КАК Справка2,
	|	ДанныеШтрихкодовУпаковок.ИдентификаторУпаковки    КАК ИдентификаторУпаковки
	|ИЗ
	|	ДанныеШтрихкодовУпаковок КАК ДанныеШтрихкодовУпаковок",
	"ВсеСопоставление");
	
	СписокЗапросов.Добавить(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	|	ДанныеШтрихкодовУпаковок.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	ДанныеШтрихкодовУпаковок.Номенклатура             КАК Номенклатура,
	|	ДанныеШтрихкодовУпаковок.Характеристика           КАК Характеристика
	|ИЗ
	|	ДанныеШтрихкодовУпаковок КАК ДанныеШтрихкодовУпаковок",
	"ТолькоНоменклатура");
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАлкогольнойПродукции", КодАлкогольнойПродукции);
	Запрос.УстановитьПараметр("ПустаяНоменклатура",      ПустаяНоменклатура);
	Запрос.УстановитьПараметр("ПустаяХарактеристика",    ПустаяХарактеристика);
	Запрос.УстановитьПараметр("ПустаяСерия",             ПустаяСерия);
	Запрос.УстановитьПараметр("ПустаяСправка2",          ПустаяСправка2);
	
	РезультатЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, СписокЗапросов, Ложь);
	
	//@skip-warning
	ВыборкаВсеСопоставление   = РезультатЗапроса["ВсеСопоставление"].Выбрать();
	//@skip-warning
	ВыборкаТолькоНоменклатура = РезультатЗапроса["ТолькоНоменклатура"].Выбрать();
	
	Если ВыборкаВсеСопоставление.Количество() = 1 Тогда
		
		ВыборкаВсеСопоставление.Следующий();
		
		ДанныеШтрихкода.АлкогольнаяПродукция    = ВыборкаВсеСопоставление.АлкогольнаяПродукция;
		ДанныеШтрихкода.Номенклатура            = ВыборкаВсеСопоставление.Номенклатура;
		ДанныеШтрихкода.Характеристика          = ВыборкаВсеСопоставление.Характеристика;
		ДанныеШтрихкода.Серия                   = ВыборкаВсеСопоставление.Серия;
		ДанныеШтрихкода.Справка2                = ВыборкаВсеСопоставление.Справка2;
		
	ИначеЕсли ВыборкаТолькоНоменклатура.Количество() = 1 Тогда
		
		ВыборкаТолькоНоменклатура.Следующий();
		
		ДанныеШтрихкода.АлкогольнаяПродукция    = ВыборкаТолькоНоменклатура.АлкогольнаяПродукция;
		ДанныеШтрихкода.Номенклатура            = ВыборкаТолькоНоменклатура.Номенклатура;
		ДанныеШтрихкода.Характеристика          = ВыборкаТолькоНоменклатура.Характеристика;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(РезультатВыбора, РезультатОбработкиШтрихкода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеШтрихкода = РезультатОбработкиШтрихкода.ДанныеШтрихкода;
	
	Если Не ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
		ДанныеШтрихкода.АлкогольнаяПродукция    = РезультатВыбора.АлкогольнаяПродукция;
		ДанныеШтрихкода.КодАлкогольнойПродукции = РезультатВыбора.КодАлкогольнойПродукции;
	КонецЕсли;
	
	ДанныеШтрихкода.ДополнительныеПараметры = РезультатВыбора.ДополнительныеПараметры;
	
	ДанныеШтрихкода.Номенклатура   = РезультатВыбора.Номенклатура;
	ДанныеШтрихкода.Характеристика = РезультатВыбора.Характеристика;
	ДанныеШтрихкода.Серия          = РезультатВыбора.Серия;
	
	Если ДанныеШтрихкода.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.ШтрихкодУпаковки) Тогда
			
			НовыеРеквизиты = Новый Структура;
			НовыеРеквизиты.Вставить("Номенклатура",   РезультатВыбора.Номенклатура);
			НовыеРеквизиты.Вставить("Характеристика", РезультатВыбора.Характеристика);
			НовыеРеквизиты.Вставить("Серия",          РезультатВыбора.Серия);
			
			Справочники.ШтрихкодыУпаковокТоваров.ИзменитьШтрихкодУпаковки(
				ДанныеШтрихкода.ШтрихкодУпаковки, НовыеРеквизиты);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
			СоответствиеНоменклатурыЕГАИС = РегистрыСведений.СоответствиеНоменклатурыЕГАИС.СоздатьМенеджерЗаписи();
			СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция = ДанныеШтрихкода.АлкогольнаяПродукция;
			СоответствиеНоменклатурыЕГАИС.Номенклатура         = ДанныеШтрихкода.Номенклатура;
			СоответствиеНоменклатурыЕГАИС.Характеристика       = ДанныеШтрихкода.Характеристика;
			СоответствиеНоменклатурыЕГАИС.Серия                = ДанныеШтрихкода.Серия;
			СоответствиеНоменклатурыЕГАИС.Справка2             = ДанныеШтрихкода.Справка2;
			СоответствиеНоменклатурыЕГАИС.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

Функция ОбработатьДанныеШтрихкодаПослеВыбораСправки2(РезультатВыбора, РезультатОбработкиШтрихкода) Экспорт
	
	ДанныеШтрихкода = РезультатОбработкиШтрихкода.ДанныеШтрихкода;
	
	ЗаполнитьДанныеШтрихкодаПоСправке2(ДанныеШтрихкода, РезультатВыбора);
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

// Получает тип акцизной марки из классификатора.
// 
// Параметры:
//  Код - Строка - Код типа акцизной марки
// 
// Возвращаемое значение:
//  Структура - Тип акцизной марки:
//   * Код - Строка - Код типа акцизной марки
//   * Наименование - Строка - Наименование типа акцизной марки
//   * ВидМарки - Строка - Вид акцизной марки
Функция ТипАкцизнойМарки(Код) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Код"         , "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ВидМарки"    , "");
	
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	СтрокаТаблицы = ТаблицаКлассификатора.Найти(Код, "Код");
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, СтрокаТаблицы);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает список найденных типов марок по введенному коду.
// 
// Параметры:
//  Код - Строка - Код или часть кода акцизной марки
// 
// Возвращаемое значение:
//  СписокЗначений - подходящие типы марок:
//   * Значение - Строка - код типа акцизной марки
//   * Представление - Строка - представление типа акцизной марки
//
Функция ДанныеВыбораТипаМарки(Код) Экспорт
	
	Результат = Новый СписокЗначений;
	
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	Для Каждого СтрокаТаблицы Из ТаблицаКлассификатора Цикл
		
		Если СтрНайти(СтрокаТаблицы.Код, СокрЛП(Код)) <> 0 Тогда
			Результат.Добавить(СтрокаТаблицы.Код, СтрокаТаблицы.ВидМарки + " " + СтрокаТаблицы.Наименование + " (" + СтрокаТаблицы.Код + ")");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьДанныеШтрихкодаПоСправке2(ДанныеШтрихкода, Справка2) Экспорт
	
	ДанныеШтрихкода.Справка2 = Справка2;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Справки2ЕГАИС.АлкогольнаяПродукция           КАК АлкогольнаяПродукция,
	|	Справки2ЕГАИС.АлкогольнаяПродукция.Код       КАК КодАлкогольнойПродукции,
	|	Справки2ЕГАИС.ДокументОснование              КАК ДокументОснование,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура   КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика КАК Характеристика,
	|	СоответствиеНоменклатурыЕГАИС.Серия          КАК Серия
	|ПОМЕСТИТЬ ВтДанные
	|ИЗ
	|	Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО СоответствиеНоменклатурыЕГАИС.Справка2 = Справки2ЕГАИС.Ссылка
	|ГДЕ
	|	Справки2ЕГАИС.Ссылка = &Справка2
	|
	|;
	|ВЫБРАТЬ
	|	1                               КАК Приоритет,
	|	Товары.Справка2                 КАК Справка2,
	|	Товары.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция.Код КАК КодАлкогольнойПродукции,
	|	Товары.Номенклатура             КАК Номенклатура,
	|	Товары.Характеристика           КАК Характеристика,
	|	Товары.Серия                    КАК Серия
	|ПОМЕСТИТЬ ВтСопоставлениеНоменклатуры
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтДанные КАК ВтДанные
	|		ПО ВтДанные.ДокументОснование = Товары.Ссылка
	|ГДЕ
	|	Товары.Справка2 = &Справка2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1                               КАК Приоритет,
	|	Товары.Справка2                 КАК Справка2,
	|	Товары.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция.Код КАК КодАлкогольнойПродукции,
	|	Товары.Номенклатура             КАК Номенклатура,
	|	Товары.Характеристика           КАК Характеристика,
	|	Товары.Серия                    КАК Серия
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтДанные КАК ВтДанные
	|		ПО ВтДанные.ДокументОснование = Товары.Ссылка
	|ГДЕ
	|	Товары.Справка2 = &Справка2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2                                КАК Приоритет,
	|	ВтДанные.АлкогольнаяПродукция    КАК АлкогольнаяПродукция,
	|	ВтДанные.КодАлкогольнойПродукции КАК КодАлкогольнойПродукции,
	|	ВтДанные.ДокументОснование       КАК ДокументОснование,
	|	ВтДанные.Номенклатура            КАК Номенклатура,
	|	ВтДанные.Характеристика          КАК Характеристика,
	|	ВтДанные.Серия                   КАК Серия
	|ИЗ
	|	ВтДанные КАК ВтДанные
	|
	|;
	|ВЫБРАТЬ
	|	ВтСопоставлениеНоменклатуры.Приоритет               КАК Приоритет,
	|	ВтСопоставлениеНоменклатуры.АлкогольнаяПродукция    КАК АлкогольнаяПродукция,
	|	ВтСопоставлениеНоменклатуры.КодАлкогольнойПродукции КАК КодАлкогольнойПродукции,
	|	ВтСопоставлениеНоменклатуры.Номенклатура            КАК Номенклатура,
	|	ВтСопоставлениеНоменклатуры.Характеристика          КАК Характеристика,
	|	ВтСопоставлениеНоменклатуры.Серия                   КАК Серия
	|ИЗ
	|	ВтСопоставлениеНоменклатуры
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет ВОЗР
	|");
	
	Запрос.УстановитьПараметр("Справка2", Справка2);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ДанныеШтрихкода.АлкогольнаяПродукция    = Выборка.АлкогольнаяПродукция;
		ДанныеШтрихкода.КодАлкогольнойПродукции = Выборка.КодАлкогольнойПродукции;
		
		Если Выборка.Количество() = 1
			Или Выборка.Приоритет = 1 Тогда
			ДанныеШтрихкода.Номенклатура   = Выборка.Номенклатура;
			ДанныеШтрихкода.Характеристика = Выборка.Характеристика;
			ДанныеШтрихкода.Серия          = Выборка.Серия;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти