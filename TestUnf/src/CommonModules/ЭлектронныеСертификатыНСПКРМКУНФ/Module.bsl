
#Область ПрограммныйИнтерфейс

// Заполняет вид оплаты "Платежная карта" с привязкой к платежной системе "Сертификат НСПК".
//
// Параметры:
//  ВидОплаты - ПеречислениеСсылка - Перечисление.ВидыБезналичныхОплат.
//
Процедура ЗаполнитьВидОплатыПлатежнаяКартаНСПК(ВидОплаты) Экспорт
	
	ВидОплаты = ОбщегоНазначения.ПредопределенныйЭлемент("Перечисление.ВидыБезналичныхОплат.БанковскаяКарта");
	
КонецПроцедуры

// Заполняет вид оплаты "Платежная система" с привязкой к платежной системе "Сертификат НСПК".
//
// Параметры:
//  ВидОплаты - ПеречислениеСсылка - Перечисление.ВидыБезналичныхОплат.
//
Процедура ЗаполнитьВидОплатыПлатежнаяСистемаНСПК(ВидОплаты) Экспорт
	
	ВидОплаты = ОбщегоНазначения.ПредопределенныйЭлемент("Перечисление.ВидыБезналичныхОплат.СертификатНСПК");
	
КонецПроцедуры

// Заполняет общие параметры подключения к сервису НСПК.
//
// Параметры:
//  ПараметрыПодключения - Структура - содержит значения по ключам АдресСервисаНСПК, КлючДоступаНСПК.
//
Процедура ЗаполнитьПараметрыПодключенияНСПК(ПараметрыПодключения) Экспорт
	
	ПараметрыПодключения.Вставить("АдресСервисаНСПК", "");
	ПараметрыПодключения.Вставить("КлючДоступаНСПК", "");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыПодключения.Вставить("ПроверятьКорневыеСертификаты", Константы.ПроверятьКорневыеСертификатыНСПК.Получить());
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения,
		ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("ЭС_НСПК_МИР", "АдресСервисаНСПК, КлючДоступаНСПК"));
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Заполняет параметры операции НСПК по кассе.
//
// Параметры:
//  ПараметрыОперации - Структура - ЭлектронныеСертификатыНСПК.ПараметрыОперацииНСПК()
//  КассаККМ - СправочникСсылка.КассыККМ - Касса ККМ, для которой необходимо получить параметры операции;
//  ИдентификаторКорзины - Строка - идентификатор корзины для операции возврата;
//  ИдентификаторЗапроса - Строка - идентификатор запроса операции.
//
Процедура ЗаполнитьПараметрыОперацииНСПКПоКассеККМ(ПараметрыОперации, КассаККМ, ИдентификаторКорзины = "", ИдентификаторЗапроса = "0") Экспорт
	
	ПараметрыПодключенияНСПК  = Новый Структура("АдресСервисаНСПК, КлючДоступаНСПК");
	ЗаполнитьПараметрыПодключенияНСПК(ПараметрыПодключенияНСПК);
	
	ПараметрыПодключенияКассыНСПК = Новый Структура("ИдентификаторНСПК, КлючКассыНСПК");
	ЗаполнитьПараметрыПодключенияКассыНСПК(ПараметрыПодключенияКассыНСПК, КассаККМ);
	
	ПараметрыПодключенияОрганизацииНСПК = Новый Структура("КлючОрганизацииНСПК");
	ЗаполнитьПараметрыПодключенияОрганизацииНСПК(ПараметрыПодключенияОрганизацииНСПК,
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КассаККМ, "Владелец"));
		
	ПараметрыОперации.АдресСервера = ПараметрыПодключенияНСПК.АдресСервисаНСПК;
	ПараметрыОперации.КлючДоступа =
		?(ЗначениеЗаполнено(ПараметрыПодключенияОрганизацииНСПК.КлючОрганизацииНСПК),
			ПараметрыПодключенияОрганизацииНСПК.КлючОрганизацииНСПК,
			ПараметрыПодключенияНСПК.КлючДоступаНСПК);
	ПараметрыОперации.ПроверятьКорневыеСертификаты = ПараметрыПодключенияНСПК.ПроверятьКорневыеСертификаты;
	ПараметрыОперации.КлючКассы = ПараметрыПодключенияКассыНСПК.КлючКассыНСПК;
	ПараметрыОперации.ИдентификаторКассы = ПараметрыПодключенияКассыНСПК.ИдентификаторНСПК;
	ПараметрыОперации.ИдентификаторКорзины = ИдентификаторКорзины;
	ПараметрыОперации.ИдентификаторЗапроса = ИдентификаторЗапроса;
	
КонецПроцедуры

// Заполняет параметры подключения кассы к сервису НСПК.
//
// Параметры:
//  ПараметрыПодключения - Структура - содержит значения по ключам ИдентификаторНСПК, КлючКассыНСПК.
//  КассаККМ - СправочникСсылка.КассыККМ - Касса ККМ, для которой необходимо получить параметры подключения.
//
Процедура ЗаполнитьПараметрыПодключенияКассыНСПК(ПараметрыПодключения, КассаККМ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения,
		ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КассаККМ, "ИдентификаторНСПК, КлючКассыНСПК"));
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Возвращает параметры подключения организации к сервису НСПК.
//
// Параметры:
//  ПараметрыПодключения - Структура - содержит значения по ключам КлючОрганизацииНСПК.
//  Организация - СправочникСсылка.Организации - Организация, для которой необходимо получить параметры подключения.
//
Процедура ЗаполнитьПараметрыПодключенияОрганизацииНСПК(ПараметрыПодключения, Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КлючОрганизацииНСПК = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Организация, "КлючОрганизацииНСПК");
	Если Не ЗначениеЗаполнено(КлючОрганизацииНСПК) Тогда
		КлючОрганизацииНСПК = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("ЭС_НСПК_МИР", "КлючДоступаНСПК");
	КонецЕсли;
	
	ПараметрыПодключения.Вставить("КлючОрганизацииНСПК", КлючОрганизацииНСПК);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Заполняет результат передачи подтверждения операции ЭС НСПК.
//
// Параметры:
//  СуммаСертификатамиНСПК - Число - сумма, оплаченная сертификатом.
//  ЧекККМ - ДокументСсылка.ЧекККМ - Чек ККМ, который необходимо отправить для подтверждения операции с ЭС НСПК.
//
Процедура ЗаполнитьСуммуОплатыСертификатамиНСПК(СуммаОплаты, ЧекККМ) Экспорт
	
	СуммаОплаты = 0;
	
	СтруктураОтбора = Новый Структура("ВидОплаты", Перечисления.ВидыБезналичныхОплат.СертификатНСПК);
	Если ТипЗнч(ЧекККМ) = Тип("ДокументСсылка.ЧекККМКоррекции") Тогда
		СтрокиОплатыСертификатамиНСПК = ЧекККМ.Оплата.НайтиСтроки(СтруктураОтбора);
	Иначе
		СтрокиОплатыСертификатамиНСПК = ЧекККМ.БезналичнаяОплата.НайтиСтроки(СтруктураОтбора);
	КонецЕсли;
	
	Для Каждого СтрокаОплаты Из СтрокиОплатыСертификатамиНСПК Цикл
		СуммаОплаты = СуммаОплаты + СтрокаОплаты.Сумма;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет возможность оплаты НСПК и заполняет форматированную строку
// с гиперссылками необходимых настроек.
// Параметры:
//  СтрокаСОшибками - ФорматированнаяСтрока - Строка с гиперссылками необходимых настроек
//  ФормаРМК - ФормаКлиентскогоПриложения - Форма рабочего места кассира
//
Процедура ПроверитьВозможностьОплатыНСПК(СтрокаСОшибками, ФормаРМК) Экспорт
	
	КассаККМ = ФормаРМК.Объект.КассаККМ;
	ТаблицаТерминалы = ФормаРМК.ТаблицаТерминалы;
	
	ЧастиФорматированнойСтроки = Новый Массив;
	
	АдресСтруктурнойЕдиницы = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		КассаККМ.СтруктурнаяЕдиница, Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы, ТекущаяДатаСеанса(), Истина);
	Если Не ЗначениеЗаполнено(АдресСтруктурнойЕдиницы) Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Необходимо указать адрес'") + Символы.НПП));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'структурной единицы.'"),,,, ПолучитьНавигационнуюСсылку(КассаККМ.СтруктурнаяЕдиница)));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	Если ТаблицаТерминалы.Количество() = 0 Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Для указанной'") + Символы.НПП));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'кассы ККМ'"),,,, ПолучитьНавигационнуюСсылку(КассаККМ)));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(Символы.НПП + НСтр("ru = 'необходимо создать эквайринговый терминал'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
		СтрокаСОшибками = Новый ФорматированнаяСтрока(ЧастиФорматированнойСтроки);
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура("ПлатежнаяСистема", Перечисления.ТипыПлатежнойСистемыККТ.СертификатНСПК);
	НайденныеСтроки = ТаблицаТерминалы.НайтиСтроки(СтруктураОтбора);
	Если НайденныеСтроки.Количество() = 0 Тогда
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'В доступные виды оплаты'") + Символы.НПП));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'эквайринговых терминалов'"),,,, ПолучитьНавигационнуюСсылку(ТаблицаТерминалы[0].ЭквайринговыйТерминал)));
		ЧастиФорматированнойСтроки.Добавить(Новый ФорматированнаяСтрока(Символы.НПП + НСтр("ru = 'необходимо добавить платежную систему Сертификат (ФЗ-491)'")));
		ЧастиФорматированнойСтроки.Добавить(Символы.ПС);
	Иначе
		СтруктураПоиска = Новый Структура("ВидОплаты", НайденныеСтроки[0].ВидПлатежнойКарты);
		МассивВидовОплат = ФормаРМК.ТаблицаПлатежныхКарт.НайтиСтроки(СтруктураПоиска);
		Если МассивВидовОплат.Количество() > 0 Тогда
			ФормаРМК.ВыбранныйВидОплаты = МассивВидовОплат[0].ИмяКоманды;
		КонецЕсли;
	КонецЕсли;
	
	СтрокаСОшибками = Новый ФорматированнаяСтрока(ЧастиФорматированнойСтроки);
	
КонецПроцедуры

// Заполняет параметры фискальной операции для отправки подтверждения в НСПК
// Параметры:
//  ПараметрыФискальнойОперации - Структура - ЭлектронныеСертификатыНСПК.ПараметрыОперацииНСПК()
//  ЧекККМ - ДокументСсылка.ЧекККМ - ЧекККМ, для которого получаются параметры операции
//
Процедура ЗаполнитьПараметрыФискальнойОперацииНСПК(ПараметрыФискальнойОперации, ЧекККМ) Экспорт
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЧекККМ, "СтруктурнаяЕдиница, КассаККМ");
	СтруктурнаяЕдиница = РеквизитыДокумента.СтруктурнаяЕдиница;
	КассаККМ = РеквизитыДокумента.КассаККМ;
	СуммаОплаченоСертификатамиНСПК = 0;
	ЗаполнитьСуммуОплатыСертификатамиНСПК(СуммаОплаченоСертификатамиНСПК, ЧекККМ);
	
	ДанныеФискальнойОперации = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ДанныеФискальнойОперации(ЧекККМ);
		
	Если ДанныеФискальнойОперации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресСтруктурнойЕдиницы = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		СтруктурнаяЕдиница, Справочники.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы, ТекущаяДатаСеанса(), Истина);
	
	ЗаполнитьПараметрыОперацииНСПКПоКассеККМ(ПараметрыФискальнойОперации, КассаККМ,
		ДанныеФискальнойОперации.ИдентификаторОплатыПлатежнойСистемы);
	
	ПараметрыФискальнойОперации.НомерФискальногоНакопителя = ДанныеФискальнойОперации.ЗаводскойНомерФН;
	ПараметрыФискальнойОперации.ФискальныйТипРасчета = ДанныеФискальнойОперации.ТипРасчета;
	ПараметрыФискальнойОперации.ФискальныйПризнакЧека = ЛЕВ(ДанныеФискальнойОперации.ФискальныйПризнак, 10);
	ПараметрыФискальнойОперации.ФискальныйЧекНомер = Строка(ДанныеФискальнойОперации.НомерЧекаККМ);
	ПараметрыФискальнойОперации.ФискальныйЧекДатаВремя = ДанныеФискальнойОперации.Дата;
	ПараметрыФискальнойОперации.ФискальныйЧекСумма = СуммаОплаченоСертификатамиНСПК;
	ПараметрыФискальнойОперации.ФискальныйМестоРасчетов = АдресСтруктурнойЕдиницы;
	ПараметрыФискальнойОперации.ФискальныйЧекСумма = СуммаОплаченоСертификатамиНСПК;
	ПараметрыФискальнойОперации.ОснованиеФискальнойОперации = ЧекККМ;
	
КонецПроцедуры

// Заполняет Организацию и КассуККМ по умолчанию
// для формы настроек НСПК.
//
// Параметры:
//  СтруктураОрганизацияКассаККМ - Структура с ключами Организация, КассаККМ;
//
Процедура ЗаполнитьЗначенияФормыНастроек(СтруктураОрганизацияКассаККМ) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КассыККМ КАК КассыККМ
	|		ПО (КассыККМ.Владелец = Организации.Ссылка)
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ КассыККМ.ПометкаУдаления
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ Организации.Ссылка = &Организация
	|		КОНЕЦ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", СтруктураОрганизацияКассаККМ.Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		ЗаполнитьЗначенияСвойств(СтруктураОрганизацияКассаККМ, Выборка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ДополнитьСведеньяОТоварах(ТабличнаяЧастьЗапасы) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	СпрНоменклатура.КодТРУ КАК КодТРУ,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.КодТРУ = """"
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ВозможнаОплатаЭС
	|ИЗ
	|	Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО Товары.Номенклатура = СпрНоменклатура.Ссылка");
	
	Запрос.УстановитьПараметр("ТаблицаТовары", ТабличнаяЧастьЗапасы.Выгрузить());
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Строка Из ТабличнаяЧастьЗапасы Цикл
		
		СтруктураПоиска = Новый Структура();
		СтруктураПоиска.Вставить("Номенклатура", Строка.Номенклатура);
		
		МассивСтрок = ТаблицаРезультат.НайтиСтроки(СтруктураПоиска);
		
		Если МассивСтрок.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Строка, МассивСтрок[0]);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВозможностьОплатыЭСВСтрокеНаСервере(СтруктураДанные) Экспорт
	
	СтруктураДанные.Вставить("КодТРУ", НСтр("ru=''"));
	СтруктураДанные.Вставить("ВозможнаОплатаЭС", Ложь);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОплатуСертификатамиНСПК")
		ИЛИ НЕ ЗначениеЗаполнено(СтруктураДанные.Номенклатура) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Номенклатура.КодТРУ КАК СТРОКА(30)) КАК КодТРУ,
	|	ВЫБОР
	|		КОГДА Номенклатура.КодТРУ = """"
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ВозможнаОплатаЭС
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура");
	
	Запрос.УстановитьПараметр("Номенклатура", СтруктураДанные.Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураДанные, Выборка);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет возможную сумму к возврату на платежную карту.
//
// Параметры:
//  Лимит - Число
//  ЧекККМПродажа - ДокументСсылка.ЧекККМ - ЧекККМ продажи по ЭС НСПК
//
Процедура ЗаполнитьЛимитВозвратаНаКартуНСПК(Лимит, ЧекККМ) Экспорт
	
	Лимит = 0;
	
	ВидОплатыПлатежнаяКартаНСПК = Неопределено;
	ЗаполнитьВидОплатыПлатежнаяКартаНСПК(ВидОплатыПлатежнаяКартаНСПК);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМОплата.Сумма КАК Сумма
	|ПОМЕСТИТЬ ВТОплаты
	|ИЗ
	|	Документ.ЧекККМ.БезналичнаяОплата КАК ЧекККМОплата
	|ГДЕ
	|	ЧекККМОплата.Ссылка = &ЧекККМ
	|	И ЧекККМОплата.ВидОплаты = &ВидОплатыПлатежнаяКартаНСПК
	|	И ЧекККМОплата.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	-ЧекККМОплата.Сумма
	|ИЗ
	|	Документ.ЧекККМВозврат.БезналичнаяОплата КАК ЧекККМОплата
	|ГДЕ
	|	ЧекККМОплата.Ссылка.ЧекККМ = &ЧекККМ
	|	И ЧекККМОплата.ВидОплаты = &ВидОплатыПлатежнаяКартаНСПК
	|	И ЧекККМОплата.Ссылка.Проведен
	|	И ЧекККМОплата.ОплатаОтменена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВТОплаты.Сумма), 0) КАК Сумма
	|ИЗ
	|	ВТОплаты КАК ВТОплаты";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЧекККМ", ЧекККМ);
	Запрос.УстановитьПараметр("ВидОплатыПлатежнаяКартаНСПК", ВидОплатыПлатежнаяКартаНСПК);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Лимит = Лимит + Выборка.Сумма;
	КонецЦикла;
	
КонецПроцедуры