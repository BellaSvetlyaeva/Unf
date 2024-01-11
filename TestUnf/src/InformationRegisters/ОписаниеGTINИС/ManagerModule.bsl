#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Инициализировать данные описания.
// 
// Возвращаемое значение:
//  Структура - Инициализировать данные описания:
// * ВидУпаковки                       - ПеречислениеСсылка.ВидыУпаковокИС - Вид упаковки.
// * КоличествоПотребительскихУпаковок - Число                             - Количество потребительских упаковок.
Функция ИнициализироватьДанныеОписания() Экспорт
	
	ДанныеУпаковки = Новый Структура("GTIN, ВидУпаковки, КоличествоПотребительскихУпаковок");
	
	Возврат ДанныеУпаковки;
	
КонецФункции

// Возвращает описание входящих GTIN
//
// Параметры:
//   GTIN - Строка, Массив Из Строка - GTIN для которых требуется получить описание ИС
//
// Возвращаемое значение:
//   Соответствие - найденные GTIN с их описанием:
//    * Ключ - - Строка - GTIN элемента,
//    * Значение - Структура - описание элемента:
//      ** ВидУпаковки - ПеречислениеСсылка.ВидыУпаковокИС - вид упаковки,
//      ** КоличествоПотребительскихУпаковок - Число - количество потребительских кодов маркировки по GTIN
//         (1 для потребительских, количество вложенных для групповых и логистических).
Функция ПолучитьОписание(Знач GTIN) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Соответствие;
	
	Если ТипЗнч(GTIN) = Тип("Строка") Тогда
		Параметр = Новый Массив;
		Параметр.Добавить(GTIN);
		GTIN = Параметр;
	КонецЕсли;
	
	Если GTIN.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОписаниеGTINИС.GTIN                              КАК GTIN,
		|	ОписаниеGTINИС.ВидУпаковки                       КАК ВидУпаковки,
		|	ОписаниеGTINИС.КоличествоПотребительскихУпаковок КАК КоличествоПотребительскихУпаковок
		|ИЗ
		|	РегистрСведений.ОписаниеGTINИС КАК ОписаниеGTINИС
		|ГДЕ
		|	ОписаниеGTINИС.GTIN В (&GTIN)");
	
	Запрос.УстановитьПараметр("GTIN", GTIN);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеУпаковки = Новый Структура("ВидУпаковки, КоличествоПотребительскихУпаковок");
		ЗаполнитьЗначенияСвойств(ДанныеУпаковки, Выборка);
		Результат.Вставить(Выборка.GTIN, ДанныеУпаковки);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЭтоНабор(GTIN) Экспорт
	
	Описание = ПолучитьОписание(GTIN).Получить(GTIN);
	Если Описание = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Описание.ВидУпаковки = Перечисления.ВидыУпаковокИС.Набор;
	КонецЕсли;
	
КонецФункции

// Сохраняет описание GTIN
//
// Параметры:
//   ДанныеОписания    - См. ИнициализироватьДанныеОписания.
//   СохраненныеДанные - См. ИнициализироватьДанныеОписания.
//
Процедура УстановитьОписание(ДанныеОписания, СохраненныеДанные = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОписаниеGTINИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.GTIN.Установить(ДанныеОписания.GTIN, Истина);
	
	Если СохраненныеДанные = Неопределено Тогда
		НаборЗаписей.Прочитать();
	КонецЕсли;
	
	Если НаборЗаписей.Выбран() И СохраненныеДанные = Неопределено Тогда
		
		Если НаборЗаписей.Количество() Тогда
			ЗаписьНабора = НаборЗаписей[0];
		Иначе
			ЗаписьНабора = НаборЗаписей.Добавить();
			ЗаписьНабора.GTIN = ДанныеОписания.GTIN;
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеОписания, "ВидУпаковки")
			И ДанныеОписания.ВидУпаковки <> Неопределено Тогда
			ЗаписьНабора.ВидУпаковки = ДанныеОписания.ВидУпаковки;
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеОписания, "КоличествоПотребительскихУпаковок")
			И ДанныеОписания.КоличествоПотребительскихУпаковок <> Неопределено Тогда
			ЗаписьНабора.КоличествоПотребительскихУпаковок = ДанныеОписания.КоличествоПотребительскихУпаковок;
		КонецЕсли;
		
	ИначеЕсли СохраненныеДанные <> Неопределено Тогда
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, ДанныеОписания);
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеОписания, "ВидУпаковки")
			И ДанныеОписания.ВидУпаковки = Неопределено Тогда
			ЗаписьНабора.ВидУпаковки = СохраненныеДанные.ВидУпаковки;
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеОписания, "КоличествоПотребительскихУпаковок")
			И ДанныеОписания.КоличествоПотребительскихУпаковок = Неопределено Тогда
			ЗаписьНабора.КоличествоПотребительскихУпаковок = СохраненныеДанные.КоличествоПотребительскихУпаковок;
		КонецЕсли;
		
	Иначе
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, ДанныеОписания);
		
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Сохраняет описание GTIN, если ранее не было установлено, по переданный таблице данных.
//
// Параметры:
//   ТаблицаОписания - ТаблицаЗначений - Описание:
// 	* GTIN                              - ОпределяемыйТип.GTIN              - GTIN.
//  * ВидУпаковки                       - ПеречислениеСсылка.ВидыУпаковокИС - Вид упаковки.
//  * КоличествоПотребительскихУпаковок - Число                             - Плановое количество вложенных потребительских упаковок.
// 
// Возвращаемое значение:
//  Булево - Описание установлено.
Функция УстановитьОписаниеПоТаблице(ТаблицаОписания) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОписаниеGTINИС");
		ЭлементБлокировки.ИсточникДанных = ТаблицаОписания;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("GTIN", "GTIN");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ИсходнаяТаблица.GTIN,
		|	ИсходнаяТаблица.ВидУпаковки,
		|	ИсходнаяТаблица.КоличествоПотребительскихУпаковок
		|ПОМЕСТИТЬ ИсходнаяТаблица
		|ИЗ
		|	&ИсходнаяТаблица КАК ИсходнаяТаблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсходнаяТаблица.GTIN,
		|	ИсходнаяТаблица.ВидУпаковки,
		|	ИсходнаяТаблица.КоличествоПотребительскихУпаковок
		|ИЗ
		|	ИсходнаяТаблица КАК ИсходнаяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписаниеGTINИС КАК ОписаниеGTINИС
		|		ПО ИсходнаяТаблица.GTIN = ОписаниеGTINИС.GTIN
		|ГДЕ
		|	ИсходнаяТаблица.ВидУпаковки = ЗНАЧЕНИЕ(Перечисление.ВидыУпаковокИС.ПустаяСсылка)
		|	И НЕ ОписаниеGTINИС.GTIN ЕСТЬ NULL
		|	ИЛИ ИсходнаяТаблица.ВидУпаковки <> ЗНАЧЕНИЕ(Перечисление.ВидыУпаковокИС.ПустаяСсылка)
		|	И (ОписаниеGTINИС.GTIN ЕСТЬ NULL
		|	ИЛИ ИсходнаяТаблица.ВидУпаковки <> ОписаниеGTINИС.ВидУпаковки
		|	ИЛИ ИсходнаяТаблица.КоличествоПотребительскихУпаковок <> ОписаниеGTINИС.КоличествоПотребительскихУпаковок)
		|");
		
		Запрос.УстановитьПараметр("ИсходнаяТаблица", ТаблицаОписания);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.ОписаниеGTINИС.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.GTIN.Установить(Выборка.GTIN);
			
			Если ЗначениеЗаполнено(Выборка.ВидУпаковки) Тогда
				ЗаписьНабора = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьНабора, Выборка);
			КонецЕсли;
			
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
		Возврат Истина;
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось записать набор записей регистра сведений ОписаниеGTIN ИС по причине: %1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
				НСтр("ru = 'ГосИС: Запись планового количества вложенных потребительских упаковок'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ОписаниеGTINИС, Неопределено,
			ТекстСообщения);
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#КонецЕсли