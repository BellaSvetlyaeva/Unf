#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = "УправлениеНебольшойФирмой";
	Настройки.ИмяКонфигурацииПриемника.Вставить("Розница");
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.ПриПолученииДанныхОтправителя = Истина;
	Настройки.ИмяПланаОбменаДляПереходаНаНовыйОбмен = "СинхронизацияДанныхЧерезУниверсальныйФормат";
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "ОбменУНФРТ";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена УНФ-РТ'");
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки);
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = '1С:Розница 8, ред. 2.3'");
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "";
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "Розница";

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Дополнение к функционалу БСП

// Возвращает сценарий работы помощника интерактивного сопоставления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
	
	Возврат Результат;
	
КонецФункции

Функция ОбщиеДанныеУзлов()
	
	ИмяФормы = "ФормаНастройкиУзлов";
	
	Возврат "ДатаНачалаВыгрузкиДокументов, Организации, ИспользоватьОтборПоОрганизациям, РежимВыгрузкиСправочников, РежимВыгрузкиСправочниковКорреспондента, РежимВыгрузкиДокументов, РежимВыгрузкиДокументовКорреспондента, РежимВыгрузкиПриНеобходимости";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки)
	
	Возврат "";
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные между программами 1С:Розница и 1С:Управление нашей фирмой, 
	|Синхронизация является двухсторонней и позволяет иметь актуальные данные в каждой из информационных баз.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции // КраткаяИнформацияПоОбмену()

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
//   в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	Возврат "ПланОбмена.ОбменРозницаУправлениеНебольшойФирмой.Форма.ПодробнаяИнформация";
	
КонецФункции

// Возвращает сокращенное строковое представление коллекции значений.
// 
// Параметры:
//  Коллекция 						- массив или список значений.
//  МаксимальноеКоличествоЭлементов - число, максимальное количество элементов включаемое в представление.
//
// Возвращаемое значение:
//  Строка.
//
Функция СокращенноеПредставлениеКоллекцииЗначений(Коллекция, МаксимальноеКоличествоЭлементов = 3) Экспорт
	
	СтрокаПредставления = "";
	
	КоличествоЗначений			 = Коллекция.Количество();
	КоличествоВыводимыхЭлементов = Мин(КоличествоЗначений, МаксимальноеКоличествоЭлементов);
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Для НомерЗначения = 1 По КоличествоВыводимыхЭлементов Цикл
			
			СтрокаПредставления = СтрокаПредставления + Коллекция.Получить(НомерЗначения - 1) + ", ";	
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		Если КоличествоЗначений > КоличествоВыводимыхЭлементов Тогда
			СтрокаПредставления = СтрокаПредставления + ", ... ";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель - ПланОбменаОбъект - узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать - Булево - признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию - Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
	Если ТипЗнч(Отправитель) = Тип("Структура") Тогда
		
		Если Отправитель.Свойство("РежимВыгрузкиСправочников") Тогда
			ПоменятьЗначения(Отправитель, "РежимВыгрузкиСправочников", "РежимВыгрузкиСправочниковКорреспондента");
		КонецЕсли;
		
		Если Отправитель.Свойство("РежимВыгрузкиДокументов") Тогда
			ПоменятьЗначения(Отправитель, "РежимВыгрузкиДокументов", "РежимВыгрузкиДокументовКорреспондента");
		КонецЕсли;
		
	Иначе
		
		ПоменятьЗначения(Отправитель, "РежимВыгрузкиСправочников", "РежимВыгрузкиСправочниковКорреспондента");
		ПоменятьЗначения(Отправитель, "РежимВыгрузкиДокументов", "РежимВыгрузкиДокументовКорреспондента");
		
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если Параметры.Свойство("Ключ") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ВыбраннаяФорма = "ФормаУзла";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоменятьЗначения(Данные, Знач Свойство1, Знач Свойство2)
	
	Значение = Данные[Свойство1];
	
	Данные[Свойство1] = Данные[Свойство2];
	Данные[Свойство2] = Значение;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьРежимыВыгрузкиДокументов(Знач ВариантСинхронизацииДокументов, Знач Данные) Экспорт
	
	Если ВариантСинхронизацииДокументов = "ОтправлятьИПолучатьАвтоматически" Тогда
		
		Данные.РежимВыгрузкиДокументов               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	ИначеЕсли ВариантСинхронизацииДокументов = "ОтправлятьАвтоматически" Тогда
		
		Данные.РежимВыгрузкиДокументов               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		
	ИначеЕсли ВариантСинхронизацииДокументов = "ПолучатьАвтоматически" Тогда
		
		Данные.РежимВыгрузкиДокументов               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	ИначеЕсли ВариантСинхронизацииДокументов = "ОтправлятьИПолучатьВручную" Тогда
		
		Данные.РежимВыгрузкиДокументов               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьРежимыВыгрузкиСправочников(Знач ВариантСинхронизацииСправочников, Знач Данные) Экспорт
	
	Если ВариантСинхронизацииСправочников = "ОтправлятьИПолучатьАвтоматически" Тогда
		
		Данные.РежимВыгрузкиСправочников               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		Данные.РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	ИначеЕсли ВариантСинхронизацииСправочников = "ОтправлятьИПолучатьПриНеобходимости" Тогда
		
		Данные.РежимВыгрузкиСправочников               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Данные.РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
	ИначеЕсли ВариантСинхронизацииСправочников = "ОтправлятьИПолучатьВручную" Тогда
		
		Данные.РежимВыгрузкиСправочников               = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		Данные.РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВариантСинхронизацииДокументов(ВариантСинхронизацииДокументов, Знач Данные) Экспорт
	
	Если Данные.РежимВыгрузкиДокументов                = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию
		И Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииДокументов = "ОтправлятьИПолучатьАвтоматически"
		
	ИначеЕсли Данные.РежимВыгрузкиДокументов        = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию
		И Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		
		ВариантСинхронизацииДокументов = "ОтправлятьАвтоматически"
		
	ИначеЕсли Данные.РежимВыгрузкиДокументов        = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную
		И Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииДокументов = "ПолучатьАвтоматически"
		
	ИначеЕсли Данные.РежимВыгрузкиДокументов        = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную
		И Данные.РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		
		ВариантСинхронизацииДокументов = "ОтправлятьИПолучатьВручную"
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВариантСинхронизацииСправочников(ВариантСинхронизацииСправочников, Знач Данные) Экспорт
	
	Если Данные.РежимВыгрузкиСправочников             = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию
		И Данные.РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииСправочников = "ОтправлятьИПолучатьАвтоматически"
		
	ИначеЕсли Данные.РежимВыгрузкиСправочников        = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости
		И Данные.РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости Тогда
		
		ВариантСинхронизацииСправочников = "ОтправлятьИПолучатьПриНеобходимости"
		
	ИначеЕсли Данные.РежимВыгрузкиСправочников        = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную
		И Данные.РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		
		ВариантСинхронизацииСправочников = "ОтправлятьИПолучатьВручную"
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли