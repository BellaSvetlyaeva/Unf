///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через Билайн.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст 			  - Строка - текст сообщения, длиной не более 480 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин			  - Строка - логин пользователя услуги отправки sms;
//  Пароль			  - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.ОтправитьSMS.
//
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	// Подготовка строки получателей.
	СтрокаПолучателей = МассивПолучателейСтрокой(НомераПолучателей);
	
	// Проверка на заполнение обязательных параметров.
	Если ПустаяСтрока(СтрокаПолучателей) Или ПустаяСтрока(Текст) Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверные параметры сообщения'");
		Возврат Результат;
	КонецЕсли;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Соответствие;
	ПараметрыЗапроса.Вставить("user", Логин);
	ПараметрыЗапроса.Вставить("pass", Пароль);
	ПараметрыЗапроса.Вставить("gzip", "none");
	ПараметрыЗапроса.Вставить("action", "post_sms");
	ПараметрыЗапроса.Вставить("message", Текст);
	ПараметрыЗапроса.Вставить("target", СтрокаПолучателей);
	ПараметрыЗапроса.Вставить("sender", ИмяОтправителя);
	
	// Отправка запроса.
	Ответ = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если Ответ = Неопределено Тогда
		Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + НСтр("ru = 'Соединение не установлено'");
		ПроверитьСпособАвторизации(Результат);
		
		Возврат Результат;
	КонецЕсли;
	
	// Обработка результата запроса (получение идентификаторов сообщений).
	СтруктураОтвета = Новый ЧтениеXML;
	СтруктураОтвета.УстановитьСтроку(Ответ);
	ОписаниеОшибки = "";
	Пока СтруктураОтвета.Прочитать() Цикл 
		Если СтруктураОтвета.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если СтруктураОтвета.Имя = "sms" Тогда 
				ИдентификаторСообщения = "";
				НомерПолучателя = "";
				Пока СтруктураОтвета.ПрочитатьАтрибут() Цикл 
					Если СтруктураОтвета.Имя = "id" Тогда 
						ИдентификаторСообщения = СтруктураОтвета.Значение;
					ИначеЕсли СтруктураОтвета.Имя = "phone" Тогда
						НомерПолучателя = СтруктураОтвета.Значение;
					КонецЕсли;
				КонецЦикла;
				Если Не ПустаяСтрока(НомерПолучателя) Тогда
					ОтправленноеСообщение = Новый Структура("НомерПолучателя,ИдентификаторСообщения",
						НомерПолучателя, ИдентификаторСообщения);
					Результат.ОтправленныеСообщения.Добавить(ОтправленноеСообщение);
				КонецЕсли;
			ИначеЕсли СтруктураОтвета.Имя = "error" Тогда
				СтруктураОтвета.Прочитать();
				ОписаниеОшибки = ОписаниеОшибки + СтруктураОтвета.Значение + Символы.ПС;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СтруктураОтвета.Закрыть();
	
	Результат.ОписаниеОшибки = СокрП(ОписаниеОшибки);
	Если Не ПустаяСтрока(Результат.ОписаниеОшибки) Тогда
		ПроверитьСпособАвторизации(Результат)
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьСпособАвторизации(Результат)
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = ОтправкаSMS.НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не НастройкиОтправкиSMS.Свойство("СпособАвторизации") Или НастройкиОтправкиSMS.СпособАвторизации <> "ПоЛогинуИПаролюA2P" Тогда
		ТекстПредупреждения = НСтр("ru = 'Сервис отправки SMS теперь доступен по новому адресу https://a2p-sms.beeline.ru/.
			|Обратитесь в техподдержку Билайн для получения нового логина и пароля для доступа к услуге, затем в настройках переключите ""Способ авторизации"" на ""a2p-sms.beeline.ru"" и введите новые логин и пароль.'");
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение, , , ТекстПредупреждения);
			
		Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + Символы.ПС + Символы.ПС + ТекстПредупреждения;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке.
//  НастройкиОтправкиSMS   - см. ОтправкаSMS.НастройкиОтправкиSMS.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.СтатусДоставки.
//
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	Логин = НастройкиОтправкиSMS.Логин;
	Пароль = НастройкиОтправкиSMS.Пароль;

	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Соответствие;
	ПараметрыЗапроса.Вставить("user", Логин);
	ПараметрыЗапроса.Вставить("pass", Пароль);
	ПараметрыЗапроса.Вставить("gzip", "none");
	ПараметрыЗапроса.Вставить("action", "status");
	ПараметрыЗапроса.Вставить("sms_id", ИдентификаторСообщения);
	
	// Отправка запроса.
	Ответ = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если Ответ = Неопределено Тогда
		Возврат "Ошибка";
	КонецЕсли;
	
	// Обработка результата запроса.
	SMSSTS_CODE = "";
	ТекущийSMS_ID = "";
	СтруктураОтвета = Новый ЧтениеXML;
	СтруктураОтвета.УстановитьСтроку(Ответ);
	Пока СтруктураОтвета.Прочитать() Цикл 
		Если СтруктураОтвета.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если СтруктураОтвета.Имя = "MESSAGE" Тогда 
				Пока СтруктураОтвета.ПрочитатьАтрибут() Цикл 
					Если СтруктураОтвета.Имя = "SMS_ID" Тогда 
						ТекущийSMS_ID = СтруктураОтвета.Значение;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли СтруктураОтвета.Имя = "SMSSTC_CODE" И ИдентификаторСообщения = ТекущийSMS_ID Тогда
				СтруктураОтвета.Прочитать();
				SMSSTS_CODE = СтруктураОтвета.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СтруктураОтвета.Закрыть();
	
	Возврат СтатусДоставкиSMS(SMSSTS_CODE); 
	
КонецФункции

Функция СтатусДоставкиSMS(СтатусСтрокой)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("queued", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("wait", "Отправляется");
	СоответствиеСтатусов.Вставить("accepted", "Отправлено");
	СоответствиеСтатусов.Вставить("delivered", "Доставлено");
	СоответствиеСтатусов.Вставить("failed", "НеДоставлено");
	СоответствиеСтатусов.Вставить("-20163", "НеДоставлено");
	
	Результат = СоответствиеСтатусов[НРег(СтатусСтрокой)];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ВыполнитьЗапрос(ПараметрыЗапроса)
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = ОтправкаSMS.НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Истина);
	
	Протокол = "http";
	Сервер = "beeline.amega-inform.ru";
	АдресРесурса = "/sendsms/";
	ЗащищенноеСоединение = Неопределено;
	
	Если НастройкиОтправкиSMS.Свойство("СпособАвторизации") И НастройкиОтправкиSMS.СпособАвторизации = "ПоЛогинуИПаролюA2P" Тогда
		Протокол = "https";
		Сервер = "a2p-sms-https.beeline.ru";
		АдресРесурса = "/public/http/";
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	КонецЕсли;
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос(АдресРесурса, ПараметрыЗапроса);
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение(Сервер,,,, ПолучениеФайловИзИнтернета.ПолучитьПрокси(Протокол), 60, ЗащищенноеСоединение);
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если HTTPОтвет <> Неопределено Тогда
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрос ""%1"" не выполнен. Код состояния: %2.'"), ПараметрыЗапроса["action"], HTTPОтвет.КодСостояния) + Символы.ПС
				+ HTTPОтвет.ПолучитьТелоКакСтроку();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
			
		Возврат HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция МассивПолучателейСтрокой(Массив)
	Результат = "";
	Для Каждого Элемент Из Массив Цикл
		Номер = ФорматироватьНомер(Элемент);
		Если НЕ ПустаяСтрока(Номер) Тогда 
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ",";
			КонецЕсли;
			Результат = Результат + Номер;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив
//
Функция Разрешения() Экспорт
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	Разрешения = Новый Массив;
	
	Протокол = "HTTP";
	Адрес = "beeline.amega-inform.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через Билайн (старый).'");
	
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Протокол = "HTTPS";
	Адрес = "a2p-sms-https.beeline.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через Билайн (новый).'");
	
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
		
	Возврат Разрешения;
	
КонецФункции

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.АдресОписанияУслугиВИнтернете = "https://beeline.ru/business/products-and-solutions/svyaz-s-klientami/sms-rassylki/pryamie-sms-rassilki-paket-bazoviy/";
	Настройки.ПриОпределенииСпособовАвторизации = Истина;
	Настройки.ПриОпределенииПолейАвторизации = Истина;
	Настройки.ПриЗаполненииСпискаТекущихДел = Истина;
	
	Настройки.ИнформацияПоСпособамАвторизации.Вставить("ПоЛогинуИПаролю", СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Сервис отправки SMS теперь доступен по <a href=""https://a2p-sms.beeline.ru/"">новому адресу</a>.
		|Обратитесь в <a href=""https://www.beeline.amega-inform.ru/support/"">техподдержку Билайн</a> для получения нового логина и пароля для доступа к услуге, затем переключите <b>Способ авторизации</b> и введите новые логин и пароль.'")));
	
КонецПроцедуры

Процедура ПриОпределенииПолейАвторизации(СпособыАвторизации) Экспорт
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Логин", НСтр("ru = 'Логин'"));
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'Пароль'"), Истина);
	
	СпособыАвторизации.Вставить("ПоЛогинуИПаролюA2P", ПоляАвторизации);
	
КонецПроцедуры

Процедура ПриОпределенииСпособовАвторизации(СпособыАвторизации) Экспорт
	
	СпособыАвторизации.Очистить();
	СпособыАвторизации.Добавить("ПоЛогинуИПаролюA2P", НСтр("ru = 'a2p-sms.beeline.ru (рекомендуется)'"));
	СпособыАвторизации.Добавить("ПоЛогинуИПаролю", НСтр("ru = 'beeline.amega-inform.ru'"));
	
КонецПроцедуры

// Параметры:
//   ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяДела = "ОтправкаSMS";
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если МодульТекущиеДелаСервер.ДелоОтключено(ИмяДела) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиОтправкиSMS = ОтправкаSMS.НастройкиОтправкиSMS();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТребуетсяНастройка = Не НастройкиОтправкиSMS.Свойство("СпособАвторизации") Или НастройкиОтправкиSMS.СпособАвторизации = "ПоЛогинуИПаролю";
	Если Не ТребуетсяНастройка Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоПроблем = 0;
	ПараметрыФормы = Новый Структура;
	
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.ОбщиеФормы.НастройкаОтправкиSMS.ПолноеИмя());
	Для Каждого Раздел Из Разделы Цикл
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИмяДела + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
		Дело.ЕстьДела       = Истина;
		Дело.Представление  = НСтр("ru = 'Требуется настройка отправки SMS'");
		Дело.Количество     = КоличествоПроблем;
		Дело.Форма          = "ОбщаяФорма.НастройкаОтправкиSMS";
		Дело.ПараметрыФормы = ПараметрыФормы;
		Дело.Важное         = Истина;
		Дело.Владелец       = Раздел;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
