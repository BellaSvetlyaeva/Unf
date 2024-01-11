
#Область ПрограммныйИнтерфейс

#Область ПараметрыРегистрации

// Функция возвращает поддерживает ли фискальное устройство.
// 
// Параметры:
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Идентификатор устройства
// 
// Возвращаемое значение:
//  Булево - Фискальное устройство поддерживает проверку кодов маркировки
Функция ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства);
	
КонецФункции

// Функция возвращает для фискального устройства версию ФФД.
// 
// Параметры:
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Идентификатор устройства.
// 
// Возвращаемое значение:
//  Неопределено - Фискальное устройство поддерживает версию ФФД
Функция ФискальноеУстройствоПоддерживаетВерсиюФФД(ИдентификаторУстройства) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ФискальноеУстройствоПоддерживаетВерсиюФФД(ИдентификаторУстройства);
	
КонецФункции

#КонецОбласти

#Область ФормированиеДанныхККТ

// Получить таблицу параметров смены из ККТ.
//
// Параметры:
//  ДанныеXML - Строка - строка XML
//  РевизияИнтерфейса - Число - ревизия интерфейса
//  НомерСменыККТ - Число - номер смены
//  НомерЧекаККТ - Число - номер чека
//
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьПараметрыСменыИзXMLПакета(ДанныеXML, РевизияИнтерфейса = 0, НомерСменыККТ = 0, НомерЧекаККТ = 0) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПолучитьПараметрыСменыИзXMLПакета(ДанныеXML, РевизияИнтерфейса, НомерСменыККТ, НомерЧекаККТ);
	
КонецФункции

// Возвращает XML текст инфо-квитанции
// Параметры:
//  Данные - Структура
//  ШиринаСтроки - Число
//  Ревизия - Строка
//
// Возвращаемое значение:
//  Строка - Строка XML
//
Функция XMLПакетИнфоКвитанции(Данные,  ШиринаСтроки, Ревизия) Экспорт
	
	Шаблон = ШаблоныФискальныхДокументов.ШаблонИнфоКвитанция(ШиринаСтроки, Данные);
	НефискальныйДокумент = ШаблоныФискальныхДокументов.ВывестиКакТекст(Шаблон);
	Возврат ОборудованиеЧекопечатающиеУстройства.ПолучитьXMLПакетДляТекста(НефискальныйДокумент, Ревизия);
	
КонецФункции

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

#Область ФискальныеОперации

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ЗаписатьФискальнуюОперацию.
// Записать операцию в журнал фискальных операций.
//
// Параметры:
//   ПараметрыФискализации - Структура - 
Процедура ЗаписатьФискальнуюОперацию(ПараметрыФискализации) Экспорт
	
	ОборудованиеЧекопечатающиеУстройства.ЗаписатьФискальнуюОперацию(ПараметрыФискализации);
	
КонецПроцедуры

// АПК: 142-выкл обратная совместимость

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ДанныеФискальнойОперации.
// Получить данные журнала фискальных операций.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ-основание.
//  ИдентификаторЗаписи - РегистрСведенийЗапись.ФискальныеОперации - запись фискальной операции.
//  ТипыДокументов - ПеречислениеСсылка.ТипыФискальныхДокументовККТ - типы документов.
//  ТипРасчета - ПеречислениеСсылка.ТипыРасчетаДенежнымиСредствами - тип расчета.
//  ФискальныйПризнак - Строка - Фискальный признак документа
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * НомерСменыККМ - Число - Номер чека ККМ.
//   * Сумма - Число - Сумма.
//   * ДокументОснование - ДокументСсылка - Документ-основание.
//   * ДанныеXML - ХранилищеЗначения - Данные чека, переданные в ККТ (XML).
//
Функция ДанныеФискальнойОперации(ДокументСсылка, ИдентификаторЗаписи = Неопределено, ТипыДокументов = Неопределено, ТипРасчета = Неопределено, ФискальныйПризнак = Неопределено) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ДанныеФискальнойОперации(ДокументСсылка, ИдентификаторЗаписи, ТипыДокументов, ТипРасчета, ФискальныйПризнак);
	
КонецФункции

// АПК: 142-вкл

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ФискальнаяОперацииПоИдентификатору.
// Получить данные журнала фискальных операций.
//
// Параметры:
//  ИдентификаторЗаписи - РегистрСведенийЗапись.ФискальныеОперации - Идентификатор записи.
// 
// Возвращаемое значение:
// РегистрСведенийЗапись.ФискальныеОперации.
Функция ФискальнаяОперацииПоИдентификатору(ИдентификаторЗаписи) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ФискальнаяОперацииПоИдентификатору(ИдентификаторЗаписи);
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.СписокФискальныхОпераций.
// Получить список журнала фискальных операций.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ-основание.
//  ТипыДокументов - ПеречислениеСсылка.ТипыФискальныхДокументовККТ - типы фискальных документов.
//  ТипРасчета - ПеречислениеСсылка.ТипыРасчетаДенежнымиСредствами - типы расчета.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * НомерСменыККМ - Число - Номер чека ККМ.
//   * Сумма - Число - Сумма.
//   * ДокументОснование - ОпределяемыйТип.ОснованиеФискальнойОперацииБПО - Документ-основание.
//   * ДанныеXML - ХранилищеЗначения - Данные чека, переданные в ККТ (XML).
//
Функция СписокФискальныхОпераций(ДокументСсылка, ТипыДокументов = Неопределено, ТипРасчета = Неопределено) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.СписокФискальныхОпераций(ДокументСсылка, ТипыДокументов, ТипРасчета);
	
КонецФункции

#КонецОбласти

#Область ОчередьЧековККТ 

// Устарела: следует использовать РаспределеннаяФискализация.ДобавитьЧекВОчередьЧековККТ.
// Добавить чек в очередь чеков ККТ.
//
// Параметры:
//  ПараметрыЧекаККТ - Структура - Параметры чека ККТ:
//  * ПозицииЧека - Массив из См. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойСтрокиЧека - .
//  ПараметрыПакетнойОперации - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыПакетнойОперацииВОчередиЧеков
// Возвращаемое значение:
//  РегистрСведенийЗапись.ОчередьЧековККТ.
Функция ДобавитьЧекВОчередьЧековККТ(ПараметрыЧекаККТ, ПараметрыПакетнойОперации = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		Возврат МодульРаспределеннаяФискализация.ДобавитьЧекВОчередьЧековККТ(ПараметрыЧекаККТ, ПараметрыПакетнойОперации);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать РаспределеннаяФискализация.ДанныеЧекаВОчереди.
// Данные чека из очереди.
//
// Параметры:
//  ИдентификаторЗаписи - РегистрСведенийЗапись.ФискальныеОперации - Идентификатор записи.
// 
// Возвращаемое значение:
//  Структура.
Функция ДанныеЧекаВОчереди(ИдентификаторЗаписи) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		Возврат МодульРаспределеннаяФискализация.ДанныеЧекаВОчереди(ИдентификаторЗаписи);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать РаспределеннаяФискализация.ЧекиВОчередиНаФискализацию.
// Чеки в очереди на фискализацию.
//
// Параметры:
//  КассаККМ - ОпределяемыйТип.КассаБПО - Касса по которой провести фискализацию, если не указано тогда по всем.
//
// Возвращаемое значение:
//  Массив.
Функция ЧекиВОчередиНаФискализацию(КассаККМ = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		Возврат МодульРаспределеннаяФискализация.ЧекиВОчередиНаФискализацию(КассаККМ);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать РаспределеннаяФискализация.УдалитьЧекИзОчереди.
// Удалить чек из очереди.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ-основание.
// 
Процедура УдалитьЧекИзОчереди(ДокументСсылка) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		МодульРаспределеннаяФискализация.УдалитьЧекИзОчереди(ДокументСсылка);
	КонецЕсли;
	
КонецПроцедуры

// Устарела: следует использовать РаспределеннаяФискализация.ОчиститьОчередьЧеков.
// Очистить очередь чеков.
//
Процедура ОчиститьОчередьЧеков() Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		МодульРаспределеннаяФискализация.ОчиститьОчередьЧеков();
	КонецЕсли;
	
КонецПроцедуры

// Устарела: следует использовать РаспределеннаяФискализация.ЗаписатьСтатусЧекаВОчереди.
// Записать статус чека в очереди.
//
// Параметры:
//  ПараметрыФискализации - Структура:
//   * ИдентификаторФискальнойЗаписи - Строка
//   * ДокументОснование - ДокументСсылка
//   * РезультатВыполненияПакетнойОперации - Структура
//  СтатусЧека - ПеречислениеСсылка.СтатусЧекаККТВОчереди
//  ОборудованиеККТ - СправочникСсылка.ПодключаемоеОборудование -
//  ТекстОшибки - Строка
Процедура ЗаписатьСтатусЧекаВОчереди(ПараметрыФискализации, СтатусЧека, ОборудованиеККТ = Неопределено, ТекстОшибки = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		МодульРаспределеннаяФискализация.ЗаписатьСтатусЧекаВОчереди(ПараметрыФискализации, СтатусЧека, ОборудованиеККТ, ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Устарела: следует использовать РаспределеннаяФискализация.ПолучитьСтатусЧекаВОчереди.
// Данные чека из очереди.
//
// Параметры:
//  ИдентификаторЗаписи - РегистрСведенийЗапись.ФискальныеОперации - Идентификатор записи.
// 
// Возвращаемое значение:
//  Структура.
Функция ПолучитьСтатусЧекаВОчереди(ИдентификаторЗаписи) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		Возврат МодульРаспределеннаяФискализация.ПолучитьСтатусЧекаВОчереди(ИдентификаторЗаписи);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать РаспределеннаяФискализация.ПолучитьФискальнуюОперацию.
// Данные чека из очереди по фискальный признаку и номеру чеку ККМ.
// 
// Параметры:
//  ФискальныйПризнак - Строка - Фискальный признак
//  НомерЧекаККМ - Строка - Номер чека ККМ
// 
// Возвращаемое значение:
//  Неопределено, Структура - Получить фискальную операцию:
//  * ДокументОснование - ОпределяемыйТип.ОснованиеФискальнойОперацииБПО.
//  * ИдентификаторЗаписи - УникальныйИдентификатор.
//  * ФискальныйПризнак - Строка - 
//  * НомерСменыККМ - Число.
//  * НомерЧекаККМ - Число. 
Функция ПолучитьФискальнуюОперацию(ФискальныйПризнак, НомерЧекаККМ = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		Возврат МодульРаспределеннаяФискализация.ПолучитьФискальнуюОперацию(ФискальныйПризнак, НомерЧекаККМ);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ФормированиеДанныхККТ

// Устарела: следует использовать МенеджерОборудованияМаркировка.КодТовараЗаполняетсяДляТиповИдентификаторов.
// Возвращает, для каких типов идентификаторов будет заполняться код товара.
//
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.ТипыИдентификаторовТовараККТ
//
Функция КодТовараЗаполняетсяДляТиповИдентификаторов() Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.КодТовараЗаполняетсяДляТиповИдентификаторов();
	Иначе
		Возврат Новый Массив();
	КонецЕсли;
	
КонецФункции             

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ТипыТоваровДляЗаполненияОтраслевогоРеквизита.
// Возвращает для каких типов товаров будет заполняться отраслевой реквизит.
//
// Возвращаемое значение:
//   Структура: 
//  * ИзделияИзНатуральногоМеха - Булево - Заполнения для изделия из натурального меха. 
//  * ОбъемноСортовойУчет - Булево - Заполнения для товаров объемно сортового учета.
//  * МолочнаяПродукцияСНечитаемымиКМ - Булево - Заполнения для молочной продукция с нечитаемыми КМ.
//
Функция ТипыТоваровДляЗаполненияОтраслевогоРеквизита() Экспорт;
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ТипыТоваровДляЗаполненияОтраслевогоРеквизита();
	
КонецФункции   

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ОтраслевойРеквизитЗаполняетсяДляТиповТоваров.
// Возвращает для каких типов товаров будет заполняться отраслевой реквизит.
//
// Возвращаемое значение:
//   Структура - см.ТипыТоваровДляЗаполненияОтраслевогоРеквизита()  
//
Функция ОтраслевойРеквизитЗаполняетсяДляТиповТоваров() Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ОтраслевойРеквизитЗаполняетсяДляТиповТоваров();
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ВедетсяОбъемноСортовойУчет.
// Возвращает ведется объемно сортовой учет.
//
// Возвращаемое значение:
//  Булево.
//           
Функция ВедетсяОбъемноСортовойУчет() Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ВедетсяОбъемноСортовойУчет();
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.КодТовараИдентифицируетЭкземпляр.
// Идентифицирует ли код товара (значение тега 1162) экземпляр товара.
//
// Параметры:
//   РеквизитКодаТовара - Строка - Значение реквизита кода товара в BASE64.
//   ШтриховойКодТовара - Строка - Штриховой код товара.
//
// Возвращаемое значение:
//  Булево - Истина - Если код товара идентифицирует экземпляр товара.
//
Функция КодТовараИдентифицируетЭкземпляр(Знач РеквизитКодаТовара = Неопределено, Знач ШтриховойКодТовара = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.КодТовараИдентифицируетЭкземпляр(РеквизитКодаТовара, ШтриховойКодТовара);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.СформироватьТаблицуПараметровДляОперацииФН.
// Сформировать таблицу параметров в XML для операции с ФН.
// 
// Параметры:
//  СтруктураПараметров - Структура
//  РевизияИнтерфейса - Число - Ревизия интерфейса
//
// Возвращаемое значение:
//  ЗаписьXML.
//
Функция СформироватьТаблицуПараметровДляОперацииФН(СтруктураПараметров, РевизияИнтерфейса = 0) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.СформироватьТаблицуПараметровДляОперацииФН(СтруктураПараметров, РевизияИнтерфейса);
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ПараметрыИзXMLПакетаККТ.
// Получить таблицу параметров из ККТ.
// 
// Параметры:
//  Данные - Структура - Данные.
//  РевизияИнтерфейса - Число - Ревизия интерфейса
// 
// Возвращаемое значение:
//  Структура - Параметры из XMLПакета ККТ:
//  * ПризнакФискализации - Строка.
//  * НомерДокументаФискализации - Число.
//  * ДатаВремяФискализации - Дата.
Функция ПараметрыИзXMLПакетаККТ(Данные, РевизияИнтерфейса = 0) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПараметрыИзXMLПакетаККТ(Данные, РевизияИнтерфейса);
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.СформироватьXMLПакетДляФискализацияЧека.
// Процедура формирует XML пакет для Фискализация чека.
// 
// Параметры:
//  ОбщиеПараметры - Структура - параметры чека
//  ПараметрыФискализации - Структура - параметры фискализации чека.
//  ВключатьПерсональныеДанные - Булево - Включать персональные данные.
//  ПерсональныеДанные - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыПерсональныеДанныеПокупателя.
//  ТипПерсональныхДанных - ПеречислениеСсылка.ТипыПерсональныхДанныхККТ - Тип персональных данных.
Процедура СформироватьXMLПакетДляФискализацияЧека(ОбщиеПараметры, ПараметрыФискализации, ВключатьПерсональныеДанные = Ложь, 
	ПерсональныеДанные = Неопределено, ТипПерсональныхДанных = Неопределено) Экспорт
	
	ОборудованиеЧекопечатающиеУстройства.СформироватьXMLПакетДляФискализацияЧека(
		ОбщиеПараметры,
		ПараметрыФискализации,
		ВключатьПерсональныеДанные, 
		ПерсональныеДанные,
		ТипПерсональныхДанных);
	
КонецПроцедуры

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.СформироватьXMLПакетДляЧекаКоррекции.
// Процедура формирует XML пакет для Фискализация чека коррекции.
// 
// Параметры:
//  ОбщиеПараметры - Структура - параметры чека
//  ПараметрыФискализации - Структура - параметры фискализации чека.
Процедура СформироватьXMLПакетДляЧекаКоррекции(ОбщиеПараметры, ПараметрыФискализации) Экспорт
	
	ОборудованиеЧекопечатающиеУстройства.СформироватьXMLПакетДляЧекаКоррекции(ОбщиеПараметры, ПараметрыФискализации);
	
КонецПроцедуры

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ПолучитьXMLПакетДляОперации.
// Получить XMLПакет для операции.
// 
// Параметры:
//  ОбщиеПараметры - Структура, Булево - Общие параметры
//  РевизияИнтерфейса - Число - Ревизия интерфейса
// 
// Возвращаемое значение:
//  Строка - Получить XMLПакет для операции
Функция ПолучитьXMLПакетДляОперации(ОбщиеПараметры, РевизияИнтерфейса = 0) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПолучитьXMLПакетДляОперации(ОбщиеПараметры, РевизияИнтерфейса);
	
КонецФункции   

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ПолучитьXMLПакетДляТекста.
// Получить XMLПакет для текста.
// 
// Параметры:
//  СтрокаТекста - Строка, Структура - Строка текста
//  РевизияИнтерфейса - Число - Ревизия интерфейса
// 
// Возвращаемое значение:
//  Массив из ЗаписьXML - Получить XMLПакет для текста.
Функция ПолучитьXMLПакетДляТекста(СтрокаТекста, РевизияИнтерфейса = 0) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПолучитьXMLПакетДляТекста(СтрокаТекста, РевизияИнтерфейса);
	
КонецФункции  

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ПолучитьПараметрыСостоянияИзXMLПакета.
// Получить параметры состояния из XML пакета.
// 
// Параметры:
//  Данные - Произвольный.
//  НомерСмены - Неопределено - Номер смены
// 
// Возвращаемое значение:
//  Структура - Получить параметры состояния из XMLПакета:
//  * ДатаСменыККТ - Число -
//  * НомерСменыККТ - Число -
//  * НомерЧекаККТ - Число -
//  * НомерЧекаЗаСмену - Число -
//  * СтатусСмены - Неопределено -
//  * СчетчикиОперацийПриход - Структура -:
//    * КоличествоЧеков - Число.
//    * СуммаЧеков - Число.
//    * КоличествоЧековКоррекции - Число.
//    * СуммаЧековКоррекции - Число.
//  * СчетчикиОперацийВозвратПрихода - Структура -:
//    * КоличествоЧеков - Число.
//    * СуммаЧеков - Число.
//    * КоличествоЧековКоррекции - Число.
//    * СуммаЧековКоррекции - Число.
//  * СчетчикиОперацийРасход - Структура -:
//    * КоличествоЧеков - Число.
//    * СуммаЧеков - Число.
//    * КоличествоЧековКоррекции - Число.
//    * СуммаЧековКоррекции - Число.
//  * СчетчикиОперацийВозвратРасхода - Структура -:
//    * КоличествоЧеков - Число.
//    * СуммаЧеков - Число.
//    * КоличествоЧековКоррекции - Число.
//    * СуммаЧековКоррекции - Число.
//  * КоличествоЧеков - Число.
//  * ОстатокНаличных - Число.
//  * ПревышеноВремяОжиданияОтветаОФД - Булево -
//  * КоличествоНепереданныхФД - Неопределено -
//  * НомерПервогоНепереданногоФД - Неопределено -
//  * ДатаПервогоНепереданногоФД - Неопределено -
//  * НеобходимаСрочнаяЗаменаФН - Булево -
//  * ПамятьФНПереполнена - Булево -
//  * РесурсФНИсчерпан - Булево -
Функция ПолучитьПараметрыСостоянияИзXMLПакета(Данные, НомерСмены = Неопределено) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПолучитьПараметрыСостоянияИзXMLПакета(Данные, НомерСмены);
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ЗаполнитьРезультатыФискализацияЧекаИзXMLПакета.
// Заполнить результаты фискализация чека из XML пакета.
//
// Параметры:
//  ПараметрыФискализации - Структура 
Процедура ЗаполнитьРезультатыФискализацияЧекаИзXMLПакета(ПараметрыФискализации) Экспорт
	
	ОборудованиеЧекопечатающиеУстройства.ЗаполнитьРезультатыФискализацияЧекаИзXMLПакета(ПараметрыФискализации);
	
КонецПроцедуры

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ЗаполнитьXMLПакетыДляТекстовогоДокумента.
// Процедура заполняет XML пакет для печати текстового документа
// 
// Параметры:
//  ТестовыеЧеки - Массив из Строка - 
//  НефискальныеДокументы - Массив из см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//  ПараметрыПодключения - См. МенеджерОборудованияКлиентСервер.ПараметрыПодключения
//  ШиринаСтроки - Число - ширина строки печатающего устройства
//
Процедура ЗаполнитьXMLПакетыДляТекстовогоДокумента(ТестовыеЧеки, НефискальныеДокументы, ПараметрыПодключения, ШиринаСтроки = 32) Экспорт
	
	ОборудованиеЧекопечатающиеУстройства.ЗаполнитьXMLПакетыДляТекстовогоДокумента(ТестовыеЧеки, НефискальныеДокументы, ПараметрыПодключения, ШиринаСтроки);
	
КонецПроцедуры  

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ЗагрузитьДанныеФискализацииИзXML.
// Получить структуру чека из XML.
// 
// Параметры:
//  ДанныеXML - Строка -Данные XML
// 
// Возвращаемое значение:
//  Структура - Загрузить данные фискализации из XML:
//  * ДанныеКоррекции - Структура -:
//    ** НомерПредписания - Число -
//    ** ДатаКоррекции - Дата -
//    ** ОписаниеКоррекции - Строка -
//    ** ТипКоррекции - Число -
//  * НеприменениеККТ - Булево -
//  * КорректируемыйДокумент - Произвольный -
//  * ЕстьПерсональныеДанные - Булево -
//  * ИндивидуальныйРежимПодготовкиДанныхКПередачеВОФД - Булево -
//  * ДопустимоеРасхождениеФорматноЛогическогоКонтроля - Число -
//  * СпособФорматноЛогическогоКонтроля - Неопределено -
//  * СформироватьЧекКоррекции - Булево -
//  * ДополнительныйРеквизитПользователя - Структура -:
//    ** Значение - Произвольный -
//    ** Наименование - Строка -
//  * ДополнительныйРеквизит - Неопределено -
//  * НефискальныеДокументы - Массив из ОпределяемыйТип.ОснованиеФискальнойОперацииБПО -
//  * КассаККМ - Произвольный -
//  * ШаблонЧека - Произвольный -
//  * ТаблицаОплат - Массив -
//  * ПозицииЧека - Массив -
//  * КопийЧека - Число -
//  * ТекстПодвала - Строка -
//  * ТекстШапки - Строка -
//  * ДатаВремя - Дата -
//  * НомерСмены - Число -
//  * НомерЧека - Строка -
//  * НомерКассы - Строка -
//  * НаименованиеМагазина - Строка -
//  * АдресМагазина - Строка -
//  * ОрганизацияКПП - Строка -
//  * ОрганизацияИНН - Строка -
//  * ОрганизацияНазвание - Строка -
//  * СерийныйНомер - Строка -
//  * ПолучательИНН - Строка -
//  * Получатель - Строка -
//  * ДанныеПоставщика - Структура -:
//    ** ИНН - Строка -
//    ** Наименование - Строка -
//    ** Телефон - Строка -
//  * ДанныеАгента - Структура -:
//    ** ОператорПоПриемуПлатежей - Структура -:
//       *** Телефон - Неопределено -
//    ** ОператорПеревода - Структура -:
//       *** Телефон - Строка -
//       *** Наименование - Строка -
//       *** Адрес - Строка -
//       *** ИНН - Строка -
//    ** ПлатежныйАгент - Структура -:
//       *** Операция - Строка -
//       *** Телефон - Строка -
//  * ПризнакАгента - Неопределено -
//  * ПокупательНомер - Строка -
//  * ПокупательEmail - Строка -
//  * ОтправительEmail - Строка -
//  * МестоРасчетов - Строка -
//  * АдресРасчетов - Строка -
//  * СистемаНалогообложения - ПеречислениеСсылка.ТипыСистемНалогообложенияККТ -
//  * Отправляет1СEmail - Булево -
//  * Отправляет1СSMS - Булево -
//  * ТипРасчета - ПеречислениеСсылка.ТипыРасчетаДенежнымиСредствами -
//  * Электронно - Булево -
//  * ТорговыйОбъект - Неопределено -
//  * Организация - Неопределено -
//  * ИдентификаторФискальнойЗаписи - Неопределено -
//  * ДокументОснование - Неопределено -
//  * КассирИНН - Неопределено -
//  * Кассир - Строка -
//  * КорректируемыйДокумент - ОпределяемыйТип.ОснованиеКассовогоЧекаКоррекцииБПО
//  * НеприменениеККТ - Булево -
//  * ДанныеКоррекции - Структура -:
//    ** ТипКоррекции - Число -
//    ** ОписаниеКоррекции - Строка
//    ** ДатаКоррекции - Дата
//    ** НомерПредписания  - Число
Функция ЗагрузитьДанныеФискализацииИзXML(ДанныеXML) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ЗагрузитьДанныеФискализацииИзXML(ДанныеXML);
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.СформироватьXMLДляЗапросаКМ.
// Сформировать XML для запроса КМ.
// 
// Параметры:
//  ПараметрыОперации - Структура - Параметры операции.  
// 
// Возвращаемое значение:
//   Строка
//
Функция СформироватьXMLДляЗапросаКМ(ПараметрыОперации) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.СформироватьXMLДляЗапросаКМ(ПараметрыОперации);
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции  

// Устарела: следует использовать МенеджерОборудованияМаркировка.ПолучитьРезультатыЗапросаКМИзXMLПакета.
// Получить результаты запроса КМ из XML пакета.
// 
// Параметры:
//  ДанныеXML - Строка - XML.
// 
// Возвращаемое значение:
//  Структура - Получить результаты запроса КМИз XMLПакета:
//   * КодМаркировкиПроверен - Булево -
//   * РезультатПроверки - Булево -
Функция ПолучитьРезультатыЗапросаКМИзXMLПакета(ДанныеXML) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.ПолучитьРезультатыЗапросаКМИзXMLПакета(ДанныеXML);
	Иначе
		Возврат Новый Структура();
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.ПолучитьРезультатыОИСМКМИзXMLПакета.
// Получить результаты запроса ОИСМ КМ из XML пакета.
// 
// Параметры:
//  ДанныеXML - Строка - XML.
//  Параметры - Неопределено - Параметры
// 
// Возвращаемое значение:
//  Неопределено, Структура - Получить результаты ОИСМКМИз XMLПакета:
//   * ИдентификаторЗапроса - УникальныйИдентификатор.
//   * СтатусРезультата - ПеречислениеСсылка.СтатусРезультатаЗапросаКМ.
//   * РезультатПроверкиОИСМ - Булево -
//   * КодРезультатаПроверкиОИСМ - Число -
//   * РезультатПроверкиОИСМПредставление - Строка -
//   * РезультатПроверкиСведенийОТоваре - Булево
//   * РезультатПроверкиСведенийОТовареПФ - Булево
//   * КодОбработкиЗапроса - Число
//   * СтатусОбработкиЗапроса - ПеречислениеСсылка.СтатусОбработкиЗапросаКМ.
//   * СтатусТовара - Неопределено -
Функция ПолучитьРезультатыОИСМКМИзXMLПакета(ДанныеXML, Параметры = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.ПолучитьРезультатыОИСМКМИзXMLПакета(ДанныеXML, Параметры);
	Иначе
		Возврат Новый Структура();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

// Устарела: следует использовать ФорматноЛогическийКонтроль.ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов.
// Выполняет проверку обязательности заполняет тэгов.
//
// Параметры:
//  Параметры - Структура 
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование
//  ОписаниеОшибки - Строка
// 
// Возвращаемое значение:
//  Булево.
Функция ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяФорматноЛогическийКонтроль() Тогда
		МодульФорматноЛогическийКонтроль = ОбщегоНазначенияБПО.ОбщийМодуль("ФорматноЛогическийКонтроль");
		Возврат МодульФорматноЛогическийКонтроль.ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки);
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать ФорматноЛогическийКонтроль.ПривестиДанныеКТребуемомуФормату.
// Процедура приводит к формату согласованному с ФНС.
//
// Параметры:
//  ОсновныеПараметры - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//  Отказ - Булево
//  ОписаниеОшибки - Строка
//  ИсправленыОсновныеПараметры - Булево
Процедура ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяФорматноЛогическийКонтроль() Тогда
		МодульФорматноЛогическийКонтроль = ОбщегоНазначенияБПО.ОбщийМодуль("ФорматноЛогическийКонтроль");
		МодульФорматноЛогическийКонтроль.ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, ИсправленыОсновныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.ШаблонЧека.
// Функция формирует шаблон чека.
//
// Параметры:
//  ОбщиеПараметры - См. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//  ТипОборудования - Строка - типы оборудования строкой.
//  ДополнительныйТекст - Строка - дополнительный текст шаблона чека.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование
//
// Возвращаемое значение:
//  Структура.
Функция ШаблонЧека(ОбщиеПараметры, ТипОборудования, ДополнительныйТекст = Неопределено, ИдентификаторУстройства = Неопределено) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ШаблонЧека(ОбщиеПараметры, ТипОборудования, ДополнительныйТекст, ИдентификаторУстройства);
	
КонецФункции

// Устарела: следует использовать ОборудованиеЧекопечатающиеУстройства.СформироватьФискальныйДокумент.
// Функция формирует табличный документ по данным фискального чека.
//
// Параметры:
//  ТипДокумента - Число
//   ОбщиеПараметры - Структура - параметры фискального документа загруженная из данных XML
//                    см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//   РеквизитыЧека - Структура - параметры фискального документа из регистра сведений фискальные документы
//                    см. ДанныеФискальнойОперации()
//   ФорматФФД - Строка - формат фискальных данных, влияет на вывод таблицы оплаты при "1.0" 
//                        используются только виды оплат "НАЛИЧНЫМИ", "ЭЛЕКТРОННО"
//
// Возвращаемое значение:
//  ТабличныйДокумент - табличный документ со сформированным фискальным документом, может быть сохранен в любой формат.
//
Функция СформироватьФискальныйДокумент(ТипДокумента, ОбщиеПараметры, РеквизитыЧека, ФорматФФД = "1.1") Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.СформироватьФискальныйДокумент(ТипДокумента, ОбщиеПараметры, РеквизитыЧека, ФорматФФД);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПередОткрытиемКассовойСмены(ПараметрыПодключения, ДанныеОперации) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПередОткрытиемКассовойСмены(ПараметрыПодключения, ДанныеОперации);
	
КонецФункции

Функция ПередЗакрытиемКассовойСмены(ПараметрыПодключения, ДанныеОперации) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПередЗакрытиемКассовойСмены(ПараметрыПодключения, ДанныеОперации);
	
КонецФункции

Функция ПослеОткрытияКассовойСмены(ПараметрыПодключения, РезультатВыполнения) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПослеОткрытияКассовойСмены(ПараметрыПодключения, РезультатВыполнения);
	
КонецФункции

Функция ПослеЗакрытияКассовойСмены(ПараметрыПодключения, РезультатВыполнения) Экспорт
	
	Возврат ОборудованиеЧекопечатающиеУстройства.ПослеЗакрытияКассовойСмены(ПараметрыПодключения, РезультатВыполнения);
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Коды маркировки

// Устарела: следует использовать МенеджерОборудованияМаркировка.КодПланируемыйСтатусМаркируемогоТовара.
// Получить код планируемого статус маркируемого товара
// 
// Параметры:
//  ПланируемыйСтатусМаркируемогоТовара - ПеречислениеСсылка.ПланируемыйСтатусМаркируемогоТовара - Планируемый статус маркируемого товара.  
// 
// Возвращаемое значение:
//  Число - Код планируемого статус маркируемого товара по ОФД
//
Функция КодПланируемыйСтатусМаркируемогоТовара(ПланируемыйСтатусМаркируемогоТовара) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.КодПланируемыйСтатусМаркируемогоТовара(ПланируемыйСтатусМаркируемогоТовара);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.КодОтветаОИСМОСтатусеТовара.
// Получить код ответ ОИСМ о статусе товара
// 
// Параметры:
//  ОтветОИСМОСтатусеТовара - ПеречислениеСсылка.ОтветОИСМОСтатусеТовара - Ответ от ИСМО.  
// 
// Возвращаемое значение:
//  Число - Ответ ОИСМ о статусе товара по ОФД
//
Функция КодОтветаОИСМОСтатусеТовара(ОтветОИСМОСтатусеТовара) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.КодОтветаОИСМОСтатусеТовара(ОтветОИСМОСтатусеТовара);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.ОтветОИСМОСтатусеТовараПоКоду.
// Получить ответ ОИСМ о статусе товара по коду.
// 
// Параметры:
//  ОтветОИСМОСтатусеТовара - Число - Ответ от ИСМО.  
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ОтветОИСМОСтатусеТовара - Ответ ОИСМ.
//
Функция ОтветОИСМОСтатусеТовараПоКоду(ОтветОИСМОСтатусеТовара) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.ОтветОИСМОСтатусеТовараПоКоду(ОтветОИСМОСтатусеТовара);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.КодТипаМаркировкиККТ.
// Получить код типа маркировки ККТ по коду.
// 
// Параметры:
//  ТипМаркировкиККТ - ПеречислениеСсылка.ТипыМаркировкиККТ - Тип маркировки ККТ.
// 
// Возвращаемое значение:
//  Строка, Произвольный - Код типа маркировки ККТ
Функция КодТипаМаркировкиККТ(ТипМаркировкиККТ) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.КодТипаМаркировкиККТ(ТипМаркировкиККТ);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.ТипМаркировкиККТПоКоду.
// Получить код типа маркировки ККТ.
// 
// Параметры:
//  КодТипМаркировкиККТ - Число - Код тип маркировки ККТ
// 
// Возвращаемое значение:
//  Произвольный, ПеречислениеСсылка.ТипыМаркировкиККТ - Тип маркировки ККТПо коду
Функция ТипМаркировкиККТПоКоду(КодТипМаркировкиККТ) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.ТипМаркировкиККТПоКоду(КодТипМаркировкиККТ);
	КонецЕсли;
	
КонецФункции

// Устарела: следует использовать МенеджерОборудованияМаркировка.СтатусРезультатаЗапросаКМПоКоду.
// Получить статус результата запроса КМ по коду.
// 
// Параметры:
//  КодСтатуса - Число - Код статуса.
// 
// Возвращаемое значение:
//  Произвольный, ПеречислениеСсылка.СтатусРезультатаЗапросаКМ - Статус результата запроса КМПо коду
Функция СтатусРезультатаЗапросаКМПоКоду(КодСтатуса) Экспорт
	
	Если ОбщегоНазначенияБПО.ИспользуетсяМаркировка() Тогда
		МодульМенеджерОборудованияМаркировка = ОбщегоНазначенияБПО.ОбщийМодуль("МенеджерОборудованияМаркировка");
		Возврат МодульМенеджерОборудованияМаркировка.СтатусРезультатаЗапросаКМПоКоду(КодСтатуса);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
