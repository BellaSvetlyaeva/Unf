#Область СлужебныйПрограммныйИнтерфейс

// Отправляет событие в фоне.
//
Процедура ОтправитьСобытиеВФоне(ИмяСобытия) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
	
	Параметры = Новый Массив();
	Параметры.Добавить(ИмяСобытия);
	
	ФоновыеЗадания.Выполнить(
		"СборСтатистикиМПСервер.ОтправитьСобытие",
		Параметры,
		Новый УникальныйИдентификатор,
		"ОтправкаСобытия");
	
#КонецЕсли

КонецПроцедуры // ОтправитьСобытиеВФоне()

// Отправляет событие с дополнительными данными в фоне.
//
Процедура ОтправитьСобытиеСДопДаннымиВФоне(ИмяСобытия, ДопДанные) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	Параметры = Новый Массив();
	Параметры.Добавить(ИмяСобытия);
	Параметры.Добавить(ДопДанные);
	
	ФоновыеЗадания.Выполнить(
		"СборСтатистикиМПСервер.ОтправитьСобытиеСДопДанными",
		Параметры,
		Новый УникальныйИдентификатор,
		"ОтправкаСобытияСДопДанными");
	
	#КонецЕсли
	
КонецПроцедуры // ОтправитьСобытиеСДопДаннымиВФоне()

// Отправляет событие с дополнительными данными в фоне.
//
Процедура ОтправитьСобытиеGAВФоне(ПараметрыСобытия) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	Параметры = Новый Массив();
	Параметры.Добавить(ПараметрыСобытия);
	//Параметры.Добавить(ДопДанные);
	
	ФоновыеЗадания.Выполнить(
		"СборСтатистикиМПСервер.ОтправитьСобытиеGA",
		Параметры,
		Новый УникальныйИдентификатор,
		"ОтправитьСобытиеGA");
	
	#КонецЕсли
	
КонецПроцедуры // ОтправитьСобытиеGAВФоне()

// Отправить событие.
//
Процедура ОтправитьСобытие(ИмяСобытия) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	Попытка
		HTTPСоединение = Новый HTTPСоединение("unf-stat1c-gpt-msk.1c.ru", 80,,,,5);
		
		ПутьНаСервере = 
			"/unf-stat1c/hs/analytics/sendstats/"
			+ СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторПриложения() + "/"
			+ СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторЭкземпляра() + "/"
			+ ИмяСобытия;
		
		HTTPЗапрос = Новый HTTPЗапрос(ПутьНаСервере);
		Результат = HTTPСоединение.Получить(HTTPЗапрос);
	Исключение
		// Сбор статистики
		Инфо = ИнформацияОбОшибке();
		ПолноеОписание = ПодробноеПредставлениеОшибки(Инфо);
		СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОшибкуВGA(ПолноеОписание);
		// Конец сбор статистики
	КонецПопытки;
	
	#КонецЕсли
	
КонецПроцедуры // ОтправитьСобытие()

// Отправить событие с дополнительными данными.
//
Процедура ОтправитьСобытиеСДопДанными(ИмяСобытия, ДопДанные) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	Попытка
		HTTPСоединение = Новый HTTPСоединение("unf-stat1c-gpt-msk.1c.ru", 80,,,,5);
		
		ПутьНаСервере = 
			"/unf-stat1c/hs/analytics/sendstats/"
			+ СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторПриложения() + "/"
			+ СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторЭкземпляра() + "/"
			+ ИмяСобытия;
		
		HTTPЗапрос = Новый HTTPЗапрос(ПутьНаСервере);
		HTTPЗапрос.УстановитьТелоИзСтроки(ДопДанные);
		Результат = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		// Сбор статистики
		Инфо = ИнформацияОбОшибке();
		ПолноеОписание = ПодробноеПредставлениеОшибки(Инфо);
		СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОшибкуВGA(ПолноеОписание);
		// Конец сбор статистики
	КонецПопытки;
	
	#КонецЕсли
	
КонецПроцедуры // ОтправитьСобытиеСДопДанными()

Процедура ОтправитьСобытиеGA(ПараметрыСобытия) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	Попытка
		HTTPСоединение = Новый HTTPСоединение("www.google-analytics.com", 80,,,,5);
		
		ПутьНаСервере = СформироватьПутьНаСервере(ПараметрыСобытия); 
		HTTPЗапрос = Новый HTTPЗапрос(ПутьНаСервере);

		Результат = HTTPСоединение.Получить(HTTPЗапрос);
	Исключение
	КонецПопытки;
	
	#КонецЕсли
	
КонецПроцедуры // ОтправитьСобытиеGA() 

Функция СформироватьПутьНаСервере(ПараметрыСобытия) Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	ПутьНаСервере = 
		"/collect?v=%v%&tid=%tid%&cid=%cid%&ds=app&av=%av%&aiid=%aiid%&an=%an%%ПараметрыСобытия%&ua=%ua%&sr=%ШиринаЭкрана%x%ВысотаЭкрана%&z=%z%";
	
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%v%", СборСтатистикиМПКлиентСервер.ПолучитьВерсиюПротоколаGA());
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%an%", Метаданные.Синоним);
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%tid%", СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторGA());
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%cid%", СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторЭкземпляра());
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%av%", ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ТекущаяВерсияПриложения"));
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%aiid%", СборСтатистикиМПКлиентСервер.ПолучитьИдентификаторПриложенияURL());
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%ПараметрыСобытия%", ПараметрыСобытия);
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%ua%", ПолучитьUserAgent());
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел();
	ПутьНаСервере = СтрЗаменить(ПутьНаСервере, "%z%", Строка(Формат(ГенераторСлучайныхЧисел.СлучайноеЧисло(0, 999999), "ЧДЦ=; ЧГ=0")));
	
	ПутьНаСервере = КодироватьСтроку(ПутьНаСервере, СпособКодированияСтроки.URLВКодировкеURL);
	
	Возврат ПутьНаСервере;
	
	#КонецЕсли
	
КонецФункции // СформироватьПутьНаСервере()

Функция ПолучитьUserAgent() Экспорт
	
	#Если МобильноеПриложениеСервер Тогда
		
	UserAgent = "";
	Если ОбщегоНазначенияМПВызовСервера.ЭтоПланшет1С() Тогда
		UserAgent = "Mozilla/5.0 (Linux; Android 6.0; TAB730 Build/MRA58K; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/50.0.2661.86 Safari/537.36";
	ИначеЕсли ОбщегоНазначенияМПВызовСервера.ВерсияОС() = "iOS" Тогда
		Если ОбщегоНазначенияМПВызовСервера.ЭтоСмартфон() Тогда
			UserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_5 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G36 Safari/601.1";
		Иначе
			UserAgent = "Mozilla/5.0 (iPad; CPU OS 9_3_5 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G36 Safari/601.1";
		КонецЕсли;
	ИначеЕсли ОбщегоНазначенияМПВызовСервера.ВерсияОС() = "Windows" Тогда
		UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36";
	Иначе
		Если ОбщегоНазначенияМПВызовСервера.ЭтоСмартфон() Тогда
			UserAgent = "Mozilla/5.0 (Linux; Android 7.0; Nexus 5 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.123 Mobile Safari/537.36";
		Иначе
			UserAgent = "Mozilla/5.0 (Linux; Android 7.0; Nexus 10 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.123 Mobile Safari/537.36";
		КонецЕсли;
	КонецЕсли;
	
	Возврат UserAgent;
	
	#КонецЕсли

КонецФункции

#КонецОбласти

