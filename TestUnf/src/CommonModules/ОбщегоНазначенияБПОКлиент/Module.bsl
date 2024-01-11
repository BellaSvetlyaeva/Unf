
#Область ПрограммныйИнтерфейс

// Возвращает текущую дату, происходит обращение к серверу, для получения точной даты.
//
// Возвращаемое значение:
//  Дата - текущая дата сеанса.
//
Функция ДатаСеанса() Экспорт
	
	ДатаСеанса = МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса();
	Если ЗначениеЗаполнено(ДатаСеанса) Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	Возврат ОбщегоНазначенияБПОСлужебныйВызовСервера.ДатаСеанса();
	
КонецФункции

#Область РаботаСXML

// Функция читает корневой элемент XML.
//
// Параметры:
//  СтрокаXML - Строка - XML строка.
//
// Возвращаемое значение:
//  Структура
//
Функция ПрочитатьКорневойЭлементXML(СтрокаXML) Экспорт
	
#Если ВебКлиент Тогда
	Возврат ОбщегоНазначенияБПОСлужебныйВызовСервера.ПрочитатьКорневойЭлементXML(СтрокаXML);
#Иначе
	Результат = Новый Структура();
	Если Не ПустаяСтрока(СтрокаXML) Тогда
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(СтрокаXML);
		ЧтениеXML.ПерейтиКСодержимому();
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
				Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
					Результат.Вставить(ЧтениеXML.Имя, ЧтениеXML.Значение);
				КонецЦикла
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает Истина, если внедрена Библиотека стандартных подсистем
//
// Возвращаемое значение:
//  Булево.
Функция ИспользуетсяБСП() Экспорт
	
	// Вызов БСП
	Возврат ПараметрПриложения("СтандартныеПодсистемы.ПараметрыКлиента") <> Неопределено;
	// Конец Вызов БСП
	
КонецФункции

// Возвращает установленную версию БСП, если БСП не установлена тогда
// возвращает "0.0.0.0"
//
// Возвращаемое значение:
//  Строка
Функция ВерсияБСП() Экспорт
	Возврат ПараметрПриложения("БПО.ВерсияБСП");
КонецФункции

Функция ПараметрПриложения(Знач ИмяПараметра) Экспорт
	
	// Вызов БСП
	Если ТипЗнч(ПараметрыПриложения) = Тип("Соответствие") Тогда
		Возврат ПараметрыПриложения[ИмяПараметра]; // Переменная в модуле приложения
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	// Конец Вызов БСП
	
КонецФункции

Процедура УстановитьПараметрПриложения(Знач ИмяПараметра, Значение) Экспорт
	
	// Вызов БСП
	Если ТипЗнч(ПараметрыПриложения) = Тип("Соответствие") Тогда
		ПараметрыПриложения[ИмяПараметра] = Значение; // Переменная в модуле приложения
	КонецЕсли;
	// Конец Вызов БСП
	
КонецПроцедуры

Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	// Вызов БСП
	МодульСтандартныеПодсистемыКлиент = ОбщийМодуль("СтандартныеПодсистемыКлиент");
	Возврат МодульСтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	// Конец Вызов БСП
	
КонецФункции


// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//   ИмяСобытия - Строка
//   Комментарий - Строка, Неопределено -
//   Метаданные - ОбъектМетаданных - 
//
Процедура ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытия, Комментарий = Неопределено, ПредставлениеУровня = "Ошибка", Метаданные = Неопределено) Экспорт
	
	Если ИспользуетсяБСП() Тогда
		
		// Вызов БСП
		МодульЖурналРегистрацииКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ЖурналРегистрацииКлиент");
		МодульЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, ПредставлениеУровня, Комментарий);
		// Конец Вызов БСП
		
	Иначе
		
		ОбщегоНазначенияБПОСлужебныйВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ИмяСобытия, Комментарий, ПредставлениеУровня, Метаданные);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылку(Ссылка) Экспорт
	
	// Вызов БСП
	МодульФайловаяСистемаКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ФайловаяСистемаКлиент");
	МодульФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
	// Конец Вызов БСП
	
КонецПроцедуры 

#Область ОповещениеПользователя

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
//@skip-check method-too-many-params
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Знач КлючДанных = Неопределено, Знач Поле = "",
	Знач ПутьКДанным = "", Отказ = Ложь) Экспорт
	
	Если ИспользуетсяБСП() Тогда
		
		// Вызов БСП
		МодульОбщегоНазначенияКлиент = ОбщийМодуль("ОбщегоНазначенияКлиент");
		МодульОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщенияПользователю, КлючДанных, Поле, ПутьКДанным, Отказ);
		// Конец Вызов БСП
		
	Иначе
		СообщитьПользователюБПО(ТекстСообщенияПользователю, КлючДанных, Поле, ПутьКДанным, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УсловныеВызовы

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для вызова необязательных подсистем.

// Возвращает Истина, если функциональная подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
// 
// Параметры:
//   ПолноеИмяПодсистемы - Строка
//
// Возвращаемое значение:
//  Булево - Истина, если существует.
//
Функция ПодсистемаСуществует(Знач ПолноеИмяПодсистемы) Экспорт
	
	Если ИспользуетсяБСП() Тогда
		
		// Вызов БСП
		МодульОбщегоНазначенияКлиент = ОбщийМодуль("ОбщегоНазначенияКлиент");
		Возврат МодульОбщегоНазначенияКлиент.ПодсистемаСуществует(ПолноеИмяПодсистемы);
		// Конец Вызов БСП
		
	Иначе
		ИмяПараметра = "БПО.ПодсистемыКонфигурации";
		ИменаПодсистем = ПараметрыПриложения[ИмяПараметра];
		Возврат ИменаПодсистем.Получить(ПолноеИмяПодсистемы) <> Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает ссылку на общий модуль или модуль менеджера по имени.
//
// Параметры:
//  Имя - Строка - имя общего модуля.
//
// Возвращаемое значение:
//  ОбщийМодуль - общий модуль.
//
Функция ОбщийМодуль(Знач Имя) Экспорт
	
	Модуль = Вычислить(Имя);
	
#Если Не ВебКлиент Тогда
	
	// В веб-клиенте не проверяется
	// т.к. при обращении к модулям с вызовом сервера типа такого модуля в веб-клиенте не существует.
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Общий модуль ""%1"" не существует.'"), 
			Имя);
	КонецЕсли;
	
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

#КонецОбласти

#Область ТекущееОкружение

////////////////////////////////////////////////////////////////////////////////
// Функции описания текущего окружения клиентского приложения и операционной системы.

// Возвращает Истина, если клиентское приложение запущено под управлением ОС Windows.
//
// Возвращаемое значение:
//  Булево - если нет клиентского приложения, возвращается Ложь.
//
Функция ЭтоWindowsКлиент() Экспорт
	
	ТипПлатформыКлиента = ТипПлатформыКлиента();
	Возврат ТипПлатформыКлиента = ТипПлатформы.Windows_x86
		Или ТипПлатформыКлиента = ТипПлатформы.Windows_x86_64;
	
КонецФункции

// Возвращает Истина, если клиентское приложение запущено под управлением ОС Linux.
//
// Возвращаемое значение:
//  Булево - если нет клиентского приложения, возвращается Ложь.
//
Функция ЭтоLinuxКлиент() Экспорт
	
	ТипПлатформыКлиента = ТипПлатформыКлиента();
	Возврат ТипПлатформыКлиента = ТипПлатформы.Linux_x86
		Или ТипПлатформыКлиента = ТипПлатформы.Linux_x86_64;
	
КонецФункции

// Возвращает Истина, если клиентское приложение запущено под управлением macOS.
//
// Возвращаемое значение:
//  Булево - если нет клиентского приложения, возвращается Ложь.
//
Функция ЭтоMacOSКлиент() Экспорт
	
	ТипПлатформыКлиента = ТипПлатформыКлиента();
	Возврат ТипПлатформыКлиента = ТипПлатформы.MacOS_x86
		Или ТипПлатформыКлиента = ТипПлатформы.MacOS_x86_64;
	
КонецФункции

// Возвращает Истина, если приложение запущено через веб-клиент
//
// Возвращаемое значение:
//  Булево - признак веб клиента.
//
Функция ЭтоВебКлиент() Экспорт
	
#Если ВебКлиент Тогда
	Возврат Истина;
#Иначе
	Возврат Ложь;
#КонецЕсли

КонецФункции

// Возвращает Истина, если клиентское приложение подключено к базе через веб-сервер.
//
// Возвращаемое значение:
//  Булево - Истина, если подключен.
//
Функция КлиентПодключенЧерезВебСервер() Экспорт
	
	Возврат СтрНайти(ВРег(СтрокаСоединенияИнформационнойБазы()), "WS=") = 1;
	
КонецФункции

// Возвращает Истина, если включен режим отладки.
//
// Возвращаемое значение:
//  Булево - Истина, если включен режим отладки.
//
Функция РежимОтладки() Экспорт
	
	Возврат СтрНайти(ПараметрЗапуска, "РежимОтладки") > 0;
	
КонецФункции

// Возвращает объем оперативной памяти, доступной клиентскому  приложению.
//
// Возвращаемое значение:
//  Число - количество гигабайтов оперативной памяти с точностью до десятых долей.
//  Неопределено - нет клиентского приложения, то есть ТекущийРежимЗапуска() = Неопределено.
//
Функция ОперативнаяПамятьДоступнаяКлиентскомуПриложению() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат Окр(СистемнаяИнформация.ОперативнаяПамять / 1024, 1);
	
КонецФункции

// Возвращает тип платформы клиента.
//
// Возвращаемое значение:
//  ТипПлатформы, Неопределено - тип платформы на которой запущен клиент. В режиме веб-клиента, если тип 
//                               платформы иной, чем описан в типе ТипПлатформы, то возвращается Неопределено.
//
Функция ТипПлатформыКлиента() Экспорт
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Возврат СистемнаяИнфо.ТипПлатформы;
	
КонецФункции

#КонецОбласти

#Область ДоступныеПодсистемы

// Возвращает Истина, если используется устройства ввода и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяУстройстваВвода() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода");
	
КонецФункции

// Возвращает Истина, если используется устройства "Шаблоны магнитных карт" и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяШаблоныМагнитныхКарт() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода.ШаблоныМагнитныхКарт");
	
КонецФункции

// Возвращает Истина, если используется подсистемы фискальных устройств и эти подсистемы существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяЧекопечатающиеУстройства() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства");
	
КонецФункции

// Возвращает Истина, если используется "Кассовая смена" и эти подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяКассоваяСмена() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.КассоваяСмена");
	
КонецФункции               

// Возвращает Истина, если используется "РассылкаЭлектронныхЧеков" и эти подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяРассылкаЭлектронныхЧеков() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.РассылкаЭлектронныхЧеков");
	
КонецФункции               

// Возвращает Истина, если используется "ФорматноЛогическийКонтроль" и эти подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяФорматноЛогическийКонтроль() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.ФорматноЛогическийКонтроль");
	
КонецФункции  

// Возвращает Истина, если используется "Маркировка" и эти подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяМаркировка() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.Маркировка");
	
КонецФункции  

// Возвращает Истина, если используется подсистема "Платежные системы" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПлатежныеСистемы() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ПлатежныеСистемы");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Дисплеи покупателя" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяДисплеиПокупателя() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ДисплеиПокупателя");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Весовое оборудование" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяВесовоеОборудование() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ВесовоеОборудование");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Терминалы сбора данных" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяТерминалыСбораДанных() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ТерминалыСбораДанных");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Принтеры этикеток" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПринтерыЭтикеток() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ПринтерыЭтикеток");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Считыватель RFID" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяСчитывательRFID() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.СчитывательRFID");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Офлайн-оборудование" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяОфлайнОборудование() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ОфлайнОборудование");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Печать этикеток и ценников" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяПечатьЭтикетокИЦенников() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПечатьЭтикетокИЦенников");
	
КонецФункции

// Возвращает Истина, если используется подсистема "Электронные сертификаты НСПК" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяЭлектронныеСертификатыНСПК() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ЭлектронныеСертификаты");
	
КонецФункции

// Возвращает Истина если существует подсистема СтандартныеПодсистемы.ОценкаПроизводительности
// и можно выполнять оценку производительности
// 
// Возвращаемое значение:
//   Булево
Функция ИспользуетсяОценкаПроизводительности() Экспорт
	
	// Вызов БСП
	Возврат ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности");
	// Конец Вызов БСП
	
КонецФункции    

// Возвращает Истина если существует подсистема СтандартныеПодсистемы.БазоваяФункциональность
// 
// Возвращаемое значение:
//   Булево
Функция ИспользуетсяБазоваяФункциональность() Экспорт
	
	// Вызов БСП
	Возврат ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность");
	// Конец Вызов БСП
	
КонецФункции    

// Возвращает Истина если существует подсистема ПоддержкаОборудования.СообщенияВСлужбуТехническойПоддержки
//
// Возвращаемое значение:
//   Булево
Функция ИспользуетсяСообщенияВСлужбуТехническойПоддержки() Экспорт
	
	// Вызов БИП
	Возврат ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") 
		И ПодсистемаСуществует("ПоддержкаОборудования.СообщенияВСлужбуТехническойПоддержки");
	// Конец Вызов БСП
	
КонецФункции

// Возвращает Истина, если используется подсистема "СертификатыНУЦМинцифры" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяСертификатыНУЦМинцифры() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ЭлектронныеСертификаты.СертификатыНУЦМинцифры");
	
КонецФункции

// Возвращает Истина, если используется подсистема "РаспределеннаяФискализация" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяРаспределеннаяФискализация() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.РаспределеннаяФискализация");
	
КонецФункции

// Возвращает Истина, если используется "АвтономнаяККТ" и эти подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяАвтономнаяККТ() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ЧекопечатающиеУстройства.АвтономнаяККТ");
	
КонецФункции  

// Возвращает Истина, если используется подсистема "НастройкиПрограммы" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяНастройкиПрограммыБПО() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.НастройкиПрограммы");
	
КонецФункции

// Возвращает Истина, если используется подсистема "УстройствоРаспознавания" и эта подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользуетсяУстройствоРаспознавания() Экспорт
	
	Возврат ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройствоРаспознавания");
	
КонецФункции

#КонецОбласти

#Область ОценкаПроизводительности

// Начинает замер времени если используется подсистема Оценка производительности, если передано значение ПользовательскоеОповещение,
// тогда оно будет подменено оповещением завершения замера, а затем будет вызвано ПользовательскоеОповещение.
// 
// Параметры:
//  КлючеваяОперация - Строка - имя ключевой операции
//  ПользовательскоеОповещение - ОписаниеОповещения - оповещение которое будет подменено
//  ФиксироватьСОшибкой - Булево - признак автоматической фиксации ошибки. 
//  АвтоЗавершение - Булево - Истина - признак автоматического завершения замера.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция ЗамерВремениБПО(КлючеваяОперация, ПользовательскоеОповещение = Неопределено, ФиксироватьСОшибкой = Ложь, АвтоЗавершение = Ложь) Экспорт
	
	УИДЗамера = Неопределено;
#Если Не МобильноеПриложениеКлиент Тогда 
	Если ИспользуетсяОценкаПроизводительности() Тогда
		
		// Вызов БСП
		МодульОценкаПроизводительностиКлиент = ОбщийМодуль("ОценкаПроизводительностиКлиент");
		УИДЗамера = МодульОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация, ФиксироватьСОшибкой, АвтоЗавершение);
		// Конец Вызов БСП
		
		КонтекстЗамера = Новый Структура();
		КонтекстЗамера.Вставить("УИДЗамера", УИДЗамера);
		КонтекстЗамера.Вставить("ПользовательскоеОповещение", ПользовательскоеОповещение);
		КонтекстЗамера.Вставить("МодульОценкаПроизводительностиКлиент", МодульОценкаПроизводительностиКлиент);
		// Подменить пользовательское оповещение
		ПользовательскоеОповещение = Новый ОписаниеОповещения("ЗамерВремениБПО_ЗавершениеЗамера", ЭтотОбъект, КонтекстЗамера);
	КонецЕсли;
#КонецЕсли
	
	Возврат УИДЗамера;
	
КонецФункции

// Завершает замер времени если используется подсистема Оценка производительности
// 
// Параметры:
//  УИДЗамера -УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//  ВыполненСОшибкой - Булево - признак того, что замер не был выполнен до конца.
//
Процедура ЗавершитьЗамерВремениБПО(УИДЗамера, ВыполненСОшибкой = Ложь) Экспорт
	
#Если Не МобильноеПриложениеКлиент Тогда 
	Если ИспользуетсяОценкаПроизводительности() Тогда
		
		// Вызов БСП
		МодульОценкаПроизводительностиКлиент = ОбщийМодуль("ОценкаПроизводительностиКлиент");
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера, ВыполненСОшибкой);
		// Конец Вызов БСП
		
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

// Процедура подменяемая в качестве пользовательского оповещения
//
// Параметры:
//  Результат - см. МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании
//  КонтекстЗамера - Структура - контекст оповещения замера:
//   * УИДЗамера - УникальныйИдентификатор
//   * ПользовательскоеОповещение - ОписаниеОповещения
//   * МодульОценкаПроизводительностиКлиент - ОбщийМодуль
//
Процедура ЗамерВремениБПО_ЗавершениеЗамера(Результат, КонтекстЗамера) Экспорт
	
#Если Не МобильноеПриложениеКлиент Тогда 
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("Результат") Тогда
		ВыполненСОшибкой = Не Результат.Результат;
	Иначе
		ВыполненСОшибкой = Ложь;
	КонецЕсли;
	
	МодульОценкаПроизводительностиКлиент = КонтекстЗамера.МодульОценкаПроизводительностиКлиент;
	МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(КонтекстЗамера.УИДЗамера, ВыполненСОшибкой);
	
	// Выполнить подмененное оповещение
	Если КонтекстЗамера.ПользовательскоеОповещение<>Неопределено Тогда
		ВыполнитьОбработкуОповещения(КонтекстЗамера.ПользовательскоеОповещение, Результат);
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОповещениеПользователя

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
// @skip-check method-too-many-params
Процедура СообщитьПользователюБПО(
	Знач ТекстСообщенияПользователю,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	//@skip-check empty-except-statement
	Попытка
		Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
			Сообщение.ПутьКДанным = ПутьКДанным;
		КонецЕсли;
	Исключение
	
	КонецПопытки;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти
