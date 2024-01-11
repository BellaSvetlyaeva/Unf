
#Область ПрограммныйИнтерфейс

#Область ГрупповаяОтправка

Функция ЭтоФормаГрупповойОтправки(Значение = Неопределено, УчитыватьВыполнениеОтправкиИлиПроверки = Истина) Экспорт
	
	ЭтоГрупповаяОтправка = Ложь;
	
	ФормаГрупповойОтправки = ФормаГрупповойОтправки(Значение);
	Если ФормаГрупповойОтправки = Неопределено Тогда
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			ЭтоГрупповаяОтправка = Ложь;
		#Иначе
			ЭтоГрупповаяОтправка = ДлительнаяОтправкаКлиент.ФормаГрупповойОтправкиЕстьСредиОткрытых(УчитыватьВыполнениеОтправкиИлиПроверки);
		#КонецЕсли
	Иначе
		Если УчитыватьВыполнениеОтправкиИлиПроверки Тогда
			ЭтоГрупповаяОтправка = ФормаГрупповойОтправки.ВыполняетсяОтправкаИлиПроверка;
		Иначе
			ЭтоГрупповаяОтправка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЭтоГрупповаяОтправка;
		
КонецФункции

Функция ЭтоФормаГрупповойОтправкиПоФорме(Форма) Экспорт
	
	Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения")
		И ИмяФормыПоПолномуИмени(Форма.ИмяФормы) = "ГрупповаяОтправка" Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ФормаГрупповойОтправки(Значение) Экспорт
	
	Результат = Неопределено;
	ПолучитьФормуГрупповойОтправкиРекурсивно(Значение, Результат);
	Возврат Результат;
		
КонецФункции

Процедура ПолучитьФормуГрупповойОтправкиРекурсивно(Значение, Результат) Экспорт
	
	Если ЭтоФормаГрупповойОтправкиПоФорме(Значение) Тогда
		
 		Результат = Значение;
		Возврат;
		
	КонецЕсли;
		
	#Если НЕ (Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение) Тогда
	Если ТипЗнч(Значение) = Тип("ОписаниеОповещения") Тогда
		
		ПолучитьФормуГрупповойОтправкиРекурсивно(Значение.ДополнительныеПараметры, Результат);
		Возврат;
		
	КонецЕсли;
	#КонецЕсли
	
	Если ТипЗнч(Значение) = Тип("Структура") Тогда
		
		Для каждого ЭлементСтруктуры Из Значение Цикл
			
			Если ЭтоФормаГрупповойОтправкиПоФорме(ЭлементСтруктуры.Значение)
				ИЛИ ТипЗнч(ЭлементСтруктуры.Значение) = Тип("Структура") Тогда
			
				ПолучитьФормуГрупповойОтправкиРекурсивно(ЭлементСтруктуры.Значение, Результат);
				Возврат;
				
			КонецЕсли;
			
			#Если НЕ (Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение) Тогда
			Если ТипЗнч(ЭлементСтруктуры.Значение) = Тип("ОписаниеОповещения") Тогда
			
				ПолучитьФормуГрупповойОтправкиРекурсивно(ЭлементСтруктуры.Значение, Результат);
				Возврат;
				
			КонецЕсли;
			#КонецЕсли
		
		КонецЦикла; 
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяФормыПоПолномуИмени(ПолноеИмяФормы) Экспорт
	
	Подстроки = СтрРазделить(ПолноеИмяФормы, ".");
	Если Подстроки.Количество() > 0 Тогда
		Возврат Подстроки[Подстроки.Количество() - 1];
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция РазностьВремениВЧасахИМинутах(ВремяЗавершения, ВремяНачала) Экспорт
	
	Разность = ВремяЗавершения - ВремяНачала;
	
	Часов = Цел(Разность / 3600);
	Если Часов > 0 Тогда
		ЧасовСтрокой = Строка(Часов) + " ч.";
	Иначе
		ЧасовСтрокой = "";
	КонецЕсли;
	
	РазностьВСек = Разность - Часов * 3600;
	Если РазностьВСек = 0 Тогда
		СекундСтрокой = НСтр("ru = '1 сек.'");
	Иначе
		СекундСтрокой = Строка(РазностьВСек) + НСтр("ru = ' сек.'");
	КонецЕсли;
	
	Минут = Цел(РазностьВСек/60);
	Если Минут = 0 Тогда
		МинутСтрокой = "";
	Иначе
		МинутСтрокой = Строка(Минут) + " мин.";
	КонецЕсли;
	
	Результат = "";
	
	Если Часов = 0 Тогда
		Если Минут = 0 Тогда
			Результат = СекундСтрокой;
		Иначе
			Результат = МинутСтрокой;
		КонецЕсли;
	Иначе
		Результат = ЧасовСтрокой + " " + МинутСтрокой;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СообщениеПриПопыткеИзмененияСтатуса() Экспорт
	
	Возврат НСтр("ru = 'Изменение статуса из этой формы не предусмотрено.'")
	
КонецФункции

#Область ТекстыОшибок

Функция СообщениеНетУчетнойЗаписи() Экспорт
	
	Возврат НСтр("ru = 'У организации отсутствует учетная запись для обмена с гос. органами.'");
	
КонецФункции

Функция СообщениеНаправлениеНеПодключено() Экспорт
	
	Возврат НСтр("ru = 'Не подключено направление'");
	
КонецФункции

Функция Сообщение1СОтчетностьНеПодключено() Экспорт
	
	Возврат НСтр("ru = '1С-Отчетность не подключена'");
	
КонецФункции

Функция СообщениеНетИнтернета() Экспорт
	
	Возврат НСтр("ru = 'Ошибка доступа в Интернет'");
	
КонецФункции

Функция Сообщение1СОтчетностьНеПодключеноНоЕстьЗаявление() Экспорт
	
	Возврат НСтр("ru = '1С-Отчетность не подключена, но есть отправленное заявление'");
	
КонецФункции

Функция Сообщение1СОтчетностьНеПодключеноНоЕстьНенастроенноеЗаявление() Экспорт
	
	Возврат НСтр("ru = '1С-Отчетность не подключена, но есть ненастроенное заявление на подключение'");
	
КонецФункции

Функция Сообщение1СОтчетностьНеПодключеноЗаявлениеОтклонено() Экспорт
	
	Возврат НСтр("ru = '1С-Отчетность не подключена, заявление на подключение отклонено'");
	
КонецФункции

Функция СообщениеИстеклаЛицензия() Экспорт
	 Возврат НСтр("ru = 'Истек срок действия лицензии по 1С-Отчетности'");
КонецФункции
 
Функция СообщениеИстекСертификатИЛицензия() Экспорт
	 Возврат НСтр("ru = 'Истек срок действия сертификата и лицензии по 1С-Отчетности'");
КонецФункции
 
Функция СообщениеИстекСертификат() Экспорт
	 Возврат НСтр("ru = 'Истек срок действия сертификата по 1С-Отчетности'");
КонецФункции

Функция СообщениеНеПодключенаКЭДОПФР() Экспорт
	
	Возврат НСтр("ru = 'Организация не подключена к ЭДО СФР (бывш. ПФР). Нужно отправить заявление на подключение ЭДО СФР'");
	
КонецФункции

Функция ОповещениеНеуспешнаяПроверкаВИнтернете() Экспорт
	
	Возврат "Неуспешный результат проверки в Интернете";
	
КонецФункции

Функция ОповещениеУспешнаяПроверкаВИнтернете() Экспорт
	
	Возврат "Успешый результат проверки в Интернете";
	
КонецФункции

Функция СообщениеОшибокНеОбнаружено() Экспорт
	
	Возврат НСтр("ru = 'Ошибок не обнаружено'");
	
КонецФункции

Функция СообщениеОбнаруженыОшибки() Экспорт
	
	Возврат НСтр("ru = 'Обнаружены ошибки'");
	
КонецФункции

Функция СообщениеИстекСрокДействияКлюча() Экспорт
	 Возврат НСтр("ru = 'Истек срок действия ключа мобильного приложения для подтверждения операций в сервисе подписи'");
 КонецФункции
 
#КонецОбласти

#КонецОбласти

Функция ФормаДлительнойОтправкиОткрыта() Экспорт
	
	ПараметрыДлительнойОтправки = ЗначенияПараметровДлительнойОтправки();
	ИдентификаторПолучателя 	= ПараметрыДлительнойОтправки["ИдентификаторПолучателя"];
	
	ФормаОткрыта = ЗначениеЗаполнено(ИдентификаторПолучателя);
	
	Возврат ФормаОткрыта;
	
КонецФункции

// Вывод ошибок. Если открыта форма длительной операции - все ошибки будут в ней накапливаться и затем показаны в отдельном окне ошибок.
// Если форма не открыта, но указан идентификатор формы-получателя сообщений, то сообщения выводятся в эту форму.
// В противном случае текст выводится обычным способом в нижнюю часть активной формы.
//
// Параметры:
//  ТекстСообщения	 - Строка - Текст выводимого сообщения.
//
Процедура ВывестиОшибку(
	Знач ТекстСообщения,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь,
	ОбъектОснование = Неопределено
	) Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с контролирующими органами. Длительная операция'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстСообщения);
	#Иначе
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с контролирующими органами. Длительная операция'"),
			"Ошибка",
			Строка(ТекстСообщения),,
			Истина);
	#КонецЕсли
	
	Если ФормаДлительнойОтправкиОткрыта()
		ИЛИ ДлительнаяОтправкаКлиентСервер.ЭтоФормаГрупповойОтправки(Неопределено) Тогда
		
		// Добавляем сообщение к уже имеющимся.
		НоваяОшибка = ДлительнаяОтправкаКлиентСервер.НоваяОшибка(ТекстСообщения, ОбъектОснование);
		ИзменитьПараметрыДлительнойОтправки("Ошибки", НоваяОшибка);
		
	Иначе
		Если ЗначениеЗаполнено(КлючДанных)
			ИЛИ ЗначениеЗаполнено(Поле) 
			ИЛИ ЗначениеЗаполнено(ПутьКДанным)
			ИЛИ Отказ <> Ложь Тогда
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
			#Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
			#КонецЕсли
		Иначе
			ДокументооборотСКОКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиПредупреждение(
	Знач ТекстСообщения,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь
	) Экспорт
	
	Если ФормаДлительнойОтправкиОткрыта()
		ИЛИ ДлительнаяОтправкаКлиентСервер.ЭтоФормаГрупповойОтправки(Неопределено) Тогда
		// Предупреждения не показываем при открытой форме ошибок.
	Иначе
		Если ЗначениеЗаполнено(КлючДанных)
			ИЛИ ЗначениеЗаполнено(Поле) 
			ИЛИ ЗначениеЗаполнено(ПутьКДанным)
			ИЛИ Отказ <> Ложь Тогда
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
			#Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
			#КонецЕсли
		Иначе
			ДокументооборотСКОКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СерверныйКлюч() Экспорт
	Возврат "СостояниеДлительнойОтправки";
КонецФункции

Функция КлиентскийКлюч() Экспорт
	Возврат "БРО.СостояниеДлительнойОтправки";
КонецФункции

Процедура ОчиститьПараметрыДлительнойОтправки() Экспорт
	
	СоздатьПараметрыДлительнойОтправкиПриНеобходимости();
	ТекущееЗначениеПараметров 	= ЗначенияПараметровПоУмолчанию(); 
	НовоеЗначениеПараметров 	= Новый ФиксированноеСоответствие(ТекущееЗначениеПараметров);
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ПараметрыСеанса[СерверныйКлюч()] = НовоеЗначениеПараметров;
	#Иначе
		ПараметрыПриложения[КлиентскийКлюч()] = НовоеЗначениеПараметров;
	#КонецЕсли
	
КонецПроцедуры

// Запоминаем параметры бублика в ПараметрыПриложения
// чтобы потом их можно было использовать не только из ЭДО,
// но и из модулей рег. отчетности.
// Список ключей - в процедуре ЗначенияПараметровПоУмолчанию.
Процедура ИзменитьПараметрыДлительнойОтправки(КлючПараметра, НовоеЗначение) Экспорт
		
	ТекущееЗначениеПараметров = ЗначенияПараметровДлительнойОтправки();
	ТекущееЗначениеПараметров = Новый Соответствие(ТекущееЗначениеПараметров);
	
	Если КлючПараметра = "Ошибки" Тогда
		ТекущееЗначениеПараметров["Ошибки"] = ДобавитьОшибку(ТекущееЗначениеПараметров["Ошибки"], НовоеЗначение);
	Иначе
		ТекущееЗначениеПараметров[КлючПараметра] = НовоеЗначение;
	КонецЕсли; 
	
	Попытка
		
		НовоеЗначениеПараметров = Новый ФиксированноеСоответствие(ТекущееЗначениеПараметров);
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			ПараметрыСеанса[СерверныйКлюч()] = НовоеЗначениеПараметров;
		#Иначе
			ПараметрыПриложения[КлиентскийКлюч()] = НовоеЗначениеПараметров;
		#КонецЕсли
		
	Исключение
		
		Ошибка = НСтр("ru = 'Электронный документооборот с контролирующими органами. Ошибка длительной операции. КлючПараметра = %1, НовоеЗначение = %2'");
		Ошибка = СтрШаблон(Ошибка, КлючПараметра, Строка(НовоеЗначение));

		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			ЗаписьЖурналаРегистрации(
				Ошибка,
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		#Иначе
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				НСтр("ru = 'Электронный документооборот с контролирующими органами'"),
				"Ошибка",
				Ошибка,,
				Истина);
		#КонецЕсли
	
	КонецПопытки;
	
КонецПроцедуры

Функция ЗначенияПараметровПоУмолчанию() Экспорт
	
	СостояниеДлительнойОтправки = Новый Соответствие;
	// Идентификатор формы, в которую будут выводиться сообщения, чтобы они 
	// не наезжали на бублик и не загораживали его.
	СостояниеДлительнойОтправки.Вставить("ИдентификаторПолучателя", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	СостояниеДлительнойОтправки.Вставить("Ошибки", 					Новый ФиксированныйМассив(Новый Массив));
	СостояниеДлительнойОтправки.Вставить("ТекущаяОрганизация", 		Неопределено);
	
	Возврат СостояниеДлительнойОтправки;
	
КонецФункции

Функция ЗначенияПараметровДлительнойОтправки() Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ПараметрыДлительнойОтправки = ПараметрыСеанса[СерверныйКлюч()];
		
		// Здесь никогда не может оказаться пустого параметра сеанса, потому что 
		// он обязательно инициализируется при запуске программы процедурами БСП. 
		
	#Иначе
		
		ПараметрыДлительнойОтправки = ПараметрыПриложения[КлиентскийКлюч()];
		
		Если ПараметрыДлительнойОтправки = Неопределено Тогда
			ЗначенияПоУмолчанию = ЗначенияПараметровПоУмолчанию();
			ПараметрыПриложения.Вставить(КлиентскийКлюч(), Новый ФиксированноеСоответствие(ЗначенияПоУмолчанию));
			ПараметрыДлительнойОтправки = ПараметрыПриложения[КлиентскийКлюч()];
		КонецЕсли;
		
	#КонецЕсли
	
	Возврат ПараметрыДлительнойОтправки;
	
КонецФункции

Функция ЗначениеПараметраДлительнойОтправки(КлючПараметра) Экспорт
	
	ТекущееЗначениеПараметров = ЗначенияПараметровДлительнойОтправки();
	ЗначениеПараметра = ТекущееЗначениеПараметров[КлючПараметра];
	
	Возврат ЗначениеПараметра;
	
КонецФункции

Функция ДобавитьОшибку(Знач Ошибки, Знач НоваяОшибка) Экспорт
	
	// Не добавляем дублирующуюся ошибку, но обновляем контекст при необходимости
	Если ТакаяОшибкаУжеЕсть(Ошибки, НоваяОшибка) Тогда
		Возврат Ошибки;
	Иначе
		// Ошибки - это фиксированный массив,
		// его можно менять только преобразовав в обычный массив.
		ОшибкиПослеДобавления = Новый Массив(Ошибки);
		ОшибкиПослеДобавления.Добавить(НоваяОшибка);
		
		Возврат Новый ФиксированныйМассив(ОшибкиПослеДобавления);
	
	КонецЕсли;
	
КонецФункции

// Не только проверяет наличие ошибки. При нахождении повторной ошибки дополняет новым контекстом
Функция ТакаяОшибкаУжеЕсть(Ошибки, Знач НоваяОшибка) Экспорт
	Перем ВхКонтекстыПриРасшифровке, КонтекстыПриРасшифровке, ВхКонтекстыПриОбработке, КонтекстыПриОбработке;
	Перем ВхКонтекстыПриИзвлеченииАрхива, КонтекстыПриИзвлеченииАрхива;
	
	НужныИзмененияАрхива = Ложь;
	НужныИзменения = Ложь;
	НужныИзмененияПриОбработке = Ложь;
	НомерСтроки = 0;
	Для каждого Ошибка Из Ошибки Цикл
		Если Ошибка["ОписаниеОшибки"] = НоваяОшибка["ОписаниеОшибки"]
			И Ошибка["Организация"] = НоваяОшибка["Организация"] Тогда
			
			Если НоваяОшибка.Свойство("ПриРасшифровке") Тогда 
				Если НЕ Ошибка.Свойство("ПриРасшифровке", ВхКонтекстыПриРасшифровке) Тогда 
					ВхКонтекстыПриРасшифровке = Новый Массив;
				КонецЕсли;
				Если НЕ НоваяОшибка.Свойство("ПриРасшифровке", КонтекстыПриРасшифровке) Тогда 
					КонтекстыПриРасшифровке = Новый Массив;
				КонецЕсли;
				Для Каждого Контекст Из КонтекстыПриРасшифровке Цикл 
					Если ВхКонтекстыПриРасшифровке.Найти(Контекст) = Неопределено Тогда 
						НужныИзменения = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли НоваяОшибка.Свойство("ПриОбработке") Тогда
				Если НЕ Ошибка.Свойство("ПриОбработке", ВхКонтекстыПриОбработке) Тогда
					ВхКонтекстыПриОбработке = Новый Массив;
				КонецЕсли;
				Если НЕ НоваяОшибка.Свойство("ПриОбработке", КонтекстыПриОбработке) Тогда
					КонтекстыПриОбработке = Новый Массив;
				КонецЕсли;
				Для Каждого Контекст Из КонтекстыПриОбработке Цикл
					Если ВхКонтекстыПриОбработке.Найти(Контекст) = Неопределено Тогда
						НужныИзмененияПриОбработке = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли НоваяОшибка.Свойство("ПриИзвлеченииАрхива") Тогда
				Если НЕ Ошибка.Свойство("ПриИзвлеченииАрхива", ВхКонтекстыПриИзвлеченииАрхива) Тогда
					ВхКонтекстыПриИзвлеченииАрхива = Новый Массив;
				КонецЕсли;
				Если НЕ НоваяОшибка.Свойство("ПриИзвлеченииАрхива", КонтекстыПриИзвлеченииАрхива) Тогда
					НужныИзмененияАрхива = Новый Массив;
				КонецЕсли;
				Для Каждого Контекст Из КонтекстыПриИзвлеченииАрхива Цикл
					Если ВхКонтекстыПриИзвлеченииАрхива.Найти(Контекст) = Неопределено Тогда
						НужныИзмененияАрхива = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
			Если НЕ НужныИзменения И НЕ НужныИзмененияПриОбработке Тогда
				Возврат Истина;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЕсли;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Если НужныИзменения Тогда 
		Ошибки = Новый Массив(Ошибки);		
		Ошибки[НомерСтроки] = Новый Структура(Ошибки[НомерСтроки]);
		Ошибки[НомерСтроки].Счетчик = Ошибки[НомерСтроки].Счетчик + НоваяОшибка.Счетчик;
		
		Если Ошибки[НомерСтроки].Свойство("ПриРасшифровке", ВхКонтекстыПриРасшифровке) Тогда 
			ВхКонтекстыПриРасшифровке = Новый Массив(ВхКонтекстыПриРасшифровке);
		Иначе
			Ошибки[НомерСтроки].Вставить("ПриРасшифровке");
			ВхКонтекстыПриРасшифровке = Новый Массив;
		КонецЕсли;
		Если НоваяОшибка.Свойство("ПриРасшифровке", КонтекстыПриРасшифровке) Тогда 
			КонтекстыПриРасшифровке = Новый Массив(КонтекстыПриРасшифровке);
		Иначе
			КонтекстыПриРасшифровке = Новый Массив;
		КонецЕсли;
		Для Каждого Контекст Из КонтекстыПриРасшифровке Цикл 
			Если ВхКонтекстыПриРасшифровке.Найти(Контекст) = Неопределено Тогда 
				ВхКонтекстыПриРасшифровке.Добавить(Контекст);
			КонецЕсли;
		КонецЦикла;
			
		Ошибки[НомерСтроки].ПриРасшифровке = Новый ФиксированныйМассив(ВхКонтекстыПриРасшифровке);
		Ошибки[НомерСтроки] = Новый ФиксированнаяСтруктура(Ошибки[НомерСтроки]);			
		Ошибки = Новый ФиксированныйМассив(Ошибки);
		
		Возврат Истина;
		
	ИначеЕсли НужныИзмененияПриОбработке Тогда
		Ошибки = Новый Массив(Ошибки);
		Ошибки[НомерСтроки] = Новый Структура(Ошибки[НомерСтроки]);
		Ошибки[НомерСтроки].Счетчик = Ошибки[НомерСтроки].Счетчик + НоваяОшибка.Счетчик;
		
		Если Ошибки[НомерСтроки].Свойство("ПриОбработке", ВхКонтекстыПриОбработке) Тогда
			ВхКонтекстыПриОбработке = Новый Массив(ВхКонтекстыПриОбработке);
		Иначе
			Ошибки[НомерСтроки].Вставить("ПриОбработке");
			ВхКонтекстыПриОбработке = Новый Массив;
		КонецЕсли;
		Если НоваяОшибка.Свойство("ПриОбработке", КонтекстыПриОбработке) Тогда
			КонтекстыПриОбработке = Новый Массив(КонтекстыПриОбработке);
		Иначе
			КонтекстыПриОбработке = Новый Массив;
		КонецЕсли;
		Для Каждого Контекст Из КонтекстыПриОбработке Цикл
			Если ВхКонтекстыПриОбработке.Найти(Контекст) = Неопределено Тогда
				ВхКонтекстыПриОбработке.Добавить(Контекст);
			КонецЕсли;
		КонецЦикла;
		
		Ошибки[НомерСтроки].ПриОбработке = Новый ФиксированныйМассив(ВхКонтекстыПриОбработке);
		Ошибки[НомерСтроки] = Новый ФиксированнаяСтруктура(Ошибки[НомерСтроки]);
		Ошибки = Новый ФиксированныйМассив(Ошибки);
		
		Возврат Истина;
		
	ИначеЕсли НужныИзмененияАрхива Тогда 
		Ошибки = Новый Массив(Ошибки);
		Ошибки[НомерСтроки] = Новый Структура(Ошибки[НомерСтроки]);
		Ошибки[НомерСтроки].Счетчик = Ошибки[НомерСтроки].Счетчик + НоваяОшибка.Счетчик;
		
		Если Ошибки[НомерСтроки].Свойство("ПриИзвлеченииАрхива", ВхКонтекстыПриИзвлеченииАрхива) Тогда 
			ВхКонтекстыПриРасшифровке = Новый Массив(ВхКонтекстыПриИзвлеченииАрхива);
		Иначе
			Ошибки[НомерСтроки].Вставить("ПриИзвлеченииАрхива");
			ВхКонтекстыПриРасшифровке = Новый Массив;
		КонецЕсли;
		Если НоваяОшибка.Свойство("ПриРасшифровке", КонтекстыПриИзвлеченииАрхива) Тогда 
			КонтекстыПриИзвлеченииАрхива = Новый Массив(КонтекстыПриИзвлеченииАрхива);
		Иначе
			КонтекстыПриИзвлеченииАрхива = Новый Массив;
		КонецЕсли;
		Для Каждого Контекст Из КонтекстыПриИзвлеченииАрхива Цикл 
			Если ВхКонтекстыПриИзвлеченииАрхива.Найти(Контекст) = Неопределено Тогда 
				ВхКонтекстыПриИзвлеченииАрхива.Добавить(Контекст);
			КонецЕсли;
		КонецЦикла;
			
		Ошибки[НомерСтроки].ПриИзвлеченииАрхива = Новый ФиксированныйМассив(ВхКонтекстыПриИзвлеченииАрхива);
		Ошибки[НомерСтроки] = Новый ФиксированнаяСтруктура(Ошибки[НомерСтроки]);			
		Ошибки = Новый ФиксированныйМассив(Ошибки);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция НоваяОшибка(Знач ОписаниеОшибки, Знач ОбъектОснование = Неопределено) Экспорт
	
	// Текст ошибки.
	НоваяОшибка = Новый Структура;
	НоваяОшибка.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	
	// Организация.
	ТекущаяОрганизация = ЗначениеПараметраДлительнойОтправки("ТекущаяОрганизация");
	Если ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		Организация = ТекущаяОрганизация;
	КонецЕсли;
	НоваяОшибка.Вставить("Организация", Организация);
	
	НоваяОшибка.Вставить("Счетчик", 1);
	Если ОбъектОснование <> Неопределено
		И (ТипЗнч(ОбъектОснование) = Тип("ФиксированнаяСтруктура") или ТипЗнч(ОбъектОснование) = Тип("Структура")) Тогда
		КонтекстСообщение = Неопределено;
		Если ОбъектОснование.Свойство("ПриРасшифровке", КонтекстСообщение) Тогда
			НоваяОшибка.Вставить("ПриРасшифровке", Новый Массив);
			НоваяОшибка.ПриРасшифровке.Добавить(КонтекстСообщение);
			НоваяОшибка.ПриРасшифровке = Новый ФиксированныйМассив(НоваяОшибка.ПриРасшифровке);
			Если ОбъектОснование.Свойство("ПараметрыПоказа") Тогда
				НоваяОшибка.Вставить("ПараметрыПоказа", ОбъектОснование.ПараметрыПоказа);
				НоваяОшибка.ПараметрыПоказа = Новый ФиксированнаяСтруктура(НоваяОшибка.ПараметрыПоказа);
			КонецЕсли;
			
		ИначеЕсли ОбъектОснование.Свойство("ПриОбработке", КонтекстСообщение) Тогда
			НоваяОшибка.Вставить("ПриОбработке", Новый Массив);
			НоваяОшибка.ПриОбработке.Добавить(КонтекстСообщение);
			НоваяОшибка.ПриОбработке = Новый ФиксированныйМассив(НоваяОшибка.ПриОбработке);
			
		ИначеЕсли ОбъектОснование.Свойство("ПриИзвлеченииАрхива", КонтекстСообщение) Тогда
			НоваяОшибка.Вставить("ПриИзвлеченииАрхива", Новый Массив);
			НоваяОшибка.ПриИзвлеченииАрхива.Добавить(КонтекстСообщение);
			НоваяОшибка.ПриИзвлеченииАрхива = Новый ФиксированныйМассив(НоваяОшибка.ПриИзвлеченииАрхива);
			
		КонецЕсли;
	КонецЕсли;
	НоваяОшибка = Новый ФиксированнаяСтруктура(НоваяОшибка);
	
	Возврат НоваяОшибка;
	
КонецФункции

Функция ВидОбъекта(СсылкаНаОбъект) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоОтчет", 												Ложь);
	ДополнительныеПараметры.Вставить("ЭтоПисьмо", 												Ложь);
	ДополнительныеПараметры.Вставить("ЭтоОтветНаТребование", 									Ложь);
	ДополнительныеПараметры.Вставить("ЭтоПакетСДопДокументами", 								Ложь);
	ДополнительныеПараметры.Вставить("ЭтоСверка", 												Ложь);
	ДополнительныеПараметры.Вставить("ЭтоЕГРЮЛ", 												Ложь);
	ДополнительныеПараметры.Вставить("ЭтоМакетПФР", 											Ложь);
	ДополнительныеПараметры.Вставить("ЭтоЗаявлениеОПенсии", 									Ложь);
	ДополнительныеПараметры.Вставить("ЭтоЗаявлениеВПФР", 										Ложь);
	ДополнительныеПараметры.Вставить("ЭтоДокумент", 											Ложь);
	ДополнительныеПараметры.Вставить("ЭтоТранспортноеСообщение", 								Ложь);
	ДополнительныеПараметры.Вставить("ЭтоМашиночитаемаяДоверенностьФНС", 						Ложь);
	ДополнительныеПараметры.Вставить("ЭтоМашиночитаемаяДоверенностьРаспределенныйРеестр", 		Ложь);
	ДополнительныеПараметры.Вставить("ЭтоУведомлениеОПредоставленииПолномочийПредставителю", 	Ложь);
	ДополнительныеПараметры.Вставить("ЭтоУведомлениеОПрекращенииПолномочийПредставителя", 		Ложь);
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		
		ТипОбъекта = ТипЗнч(СсылкаНаОбъект);
		
		Если ТипОбъекта = Тип("СправочникСсылка.ДокументыРеализацииПолномочийНалоговыхОрганов")
			ИЛИ ТипОбъекта = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы")
			ИЛИ ТипОбъекта = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС") Тогда
			
			Если ТипОбъекта = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы") Тогда
				
				Если ДокументооборотСКОВызовСервера.ЭтоПакетСДопДокументами(СсылкаНаОбъект) Тогда
					ДополнительныеПараметры.ЭтоПакетСДопДокументами = Истина;
				Иначе
					ДополнительныеПараметры.ЭтоОтветНаТребование = Истина;
				КонецЕсли;
				
			Иначе
				ДополнительныеПараметры.ЭтоОтветНаТребование = Истина;
			КонецЕсли;
			
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами") Тогда
			ДополнительныеПараметры.ЭтоПисьмо = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ЗапросНаИнформационноеОбслуживаниеНалогоплательщика")
			ИЛИ ТипОбъекта = Тип("ДокументСсылка.ЗапросНаИнформационноеОбслуживаниеСтрахователя") Тогда
			ДополнительныеПараметры.ЭтоСверка = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ЗапросНаВыпискуИзЕГРЮЛ_ЕГРИП") Тогда
			ДополнительныеПараметры.ЭтоЕГРЮЛ = Истина;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.МакетыПенсионныхДел") Тогда
			ДополнительныеПараметры.ЭтоМакетПФР = Истина;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ЗаявлениеОНазначенииПенсии") Тогда
			ДополнительныеПараметры.ЭтоЗаявлениеОПенсии = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ЗаявленияПоЭлДокументооборотуСПФР") Тогда
			ДополнительныеПараметры.ЭтоЗаявлениеВПФР = Истина;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.МашиночитаемыеДоверенностиФНС") Тогда
			ДополнительныеПараметры.ЭтоМашиночитаемаяДоверенностьФНС = Истина;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.МашиночитаемыеДоверенностиРаспределенныйРеестр") Тогда
			ДополнительныеПараметры.ЭтоМашиночитаемаяДоверенностьРаспределенныйРеестр = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.УведомлениеОПредоставленииПолномочийПредставителю") Тогда
			ДополнительныеПараметры.ЭтоУведомлениеОПредоставленииПолномочийПредставителю = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.УведомлениеОПрекращенииПолномочийПредставителя") Тогда
			ДополнительныеПараметры.ЭтоУведомлениеОПрекращенииПолномочийПредставителя = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ТранспортноеСообщение") Тогда
			ДополнительныеПараметры.ЭтоТранспортноеСообщение = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ЗаявлениеНаФормированиеСправкиОРасчетах") Тогда
			ДополнительныеПараметры.ЭтоДокумент = Истина;
		Иначе
			ДополнительныеПараметры.ЭтоОтчет = Истина;
		КонецЕсли;
		
	Иначе
		
		ДополнительныеПараметры.ЭтоДокумент = Истина;
			
	КонецЕсли;
		
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция НазваниеОбъектаВИменительномПадеже(СсылкаНаОбъект, ПерваяБукваЗаглавная = Ложь) Экспорт
	
	ВидОбъекта = ВидОбъекта(СсылкаНаОбъект);
	
	Если ВидОбъекта.ЭтоДокумент Тогда
		Название = НСтр("ru = 'документ'");
	ИначеЕсли ВидОбъекта.ЭтоПисьмо Тогда
		Название = НСтр("ru = 'письмо'");
	ИначеЕсли ВидОбъекта.ЭтоОтветНаТребование Тогда
		Название = НСтр("ru = 'ответ на требование'");
	ИначеЕсли ВидОбъекта.ЭтоПакетСДопДокументами Тогда
		Название = ДокументооборотСКОКлиентСервер.ПредставлениеПакетаСДопДокументами(Истина);
	ИначеЕсли ВидОбъекта.ЭтоСверка Тогда
		Название = НСтр("ru = 'запрос на сверку'");
	ИначеЕсли ВидОбъекта.ЭтоЕГРЮЛ Тогда
		Название = НСтр("ru = 'запрос на выписку из ЕГРЮЛ/ЕГРИП'");
	ИначеЕсли ВидОбъекта.ЭтоМакетПФР Тогда
		Название = НСтр("ru = 'макет пенсионных дел'");
	ИначеЕсли ВидОбъекта.ЭтоЗаявлениеОПенсии Тогда
		Название = НСтр("ru = 'заявление'");
	ИначеЕсли ВидОбъекта.ЭтоЗаявлениеВПФР Тогда
		Название = Строка(ДокументооборотСКОВызовСервера.ВидЗаявленияВПФР(СсылкаНаОбъект));
	ИначеЕсли ВидОбъекта.ЭтоТранспортноеСообщение Тогда
		Название = НСтр("ru = 'извещение'");
	ИначеЕсли ВидОбъекта.ЭтоУведомлениеОПредоставленииПолномочийПредставителю
		ИЛИ ВидОбъекта.ЭтоУведомлениеОПрекращенииПолномочийПредставителя Тогда
		Название = НСтр("ru = 'документ'");
	Иначе
		Название = НСтр("ru = 'отчет'");
	КонецЕсли;
	
	Если ПерваяБукваЗаглавная Тогда
		Название = ВРег(Лев(Название,1)) + Сред(Название, 2);
	КонецЕсли;
		
	Возврат Название;
	
КонецФункции

Функция НазваниеОбъектаВРодительномПадеже(СсылкаНаОбъект) Экспорт
	
	ВидОбъекта = ВидОбъекта(СсылкаНаОбъект);
	
	Если ВидОбъекта.ЭтоДокумент Тогда
		Название = НСтр("ru = 'документа'");
	ИначеЕсли ВидОбъекта.ЭтоПисьмо Тогда
		Название = НСтр("ru = 'письма'");
	ИначеЕсли ВидОбъекта.ЭтоОтветНаТребование Тогда
		Название = НСтр("ru = 'ответа на требование'");
	ИначеЕсли ВидОбъекта.ЭтоПакетСДопДокументами Тогда
		Название = ДокументооборотСКОКлиентСервер.ПредставлениеПакетаСДопДокументамиВРодительномПадеже(Истина);
	ИначеЕсли ВидОбъекта.ЭтоСверка Тогда
		Название = НСтр("ru = 'запроса на сверку'");
	ИначеЕсли ВидОбъекта.ЭтоЕГРЮЛ Тогда
		Название = НСтр("ru = 'запроса на выписку из ЕГРЮЛ/ЕГРИП'");
	ИначеЕсли ВидОбъекта.ЭтоМакетПФР Тогда
		Название = НСтр("ru = 'макета пенсионных дел'");
	ИначеЕсли ВидОбъекта.ЭтоЗаявлениеОПенсии Тогда
		Название = НСтр("ru = 'заявления'");
	ИначеЕсли ВидОбъекта.ЭтоЗаявлениеВПФР Тогда
		Вид = ДокументооборотСКОВызовСервера.ВидЗаявленияВПФР(СсылкаНаОбъект);
		Если Вид = ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаПодключение") Тогда
			Название = НСтр("ru = 'заявления на подключение к ЭДО СФР (бывш. ПФР)'");
		ИначеЕсли Вид = ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаОтключение") Тогда
			Название = НСтр("ru = 'заявления на отключение от ЭДО СФР (бывш. ПФР)'");
		Иначе
			Название = НСтр("ru = 'заявления'");
		КонецЕсли;
	ИначеЕсли ВидОбъекта.ЭтоТранспортноеСообщение Тогда
		Название = НСтр("ru = 'извещения'");
	Иначе
		Название = НСтр("ru = 'отчета'");
	КонецЕсли;
		
	Возврат Название;
	
КонецФункции

Функция КоличествоОшибокОтменыДействия(Ошибки) Экспорт
	
	ОшибкиОтменыДействия = Новый Массив;
	// КриптоПро
	ОшибкиОтменыДействия.Добавить("The operation was canceled by the user");
	ОшибкиОтменыДействия.Добавить("Действие было отменено пользователем");
	// VipNet
	ОшибкиОтменыДействия.Добавить("Операция была отменена пользователем");
	// ЭП в облаке
	ОшибкиОтменыДействия.Добавить("Пользователь отказался от ввода пароля");
	
	КоличествоОшибокОтменыДействия = 0;
	
	Для каждого ОшибкаИзФиксированногоМассива Из Ошибки Цикл
		
		Для каждого ОшибкаОтменыДействия Из ОшибкиОтменыДействия Цикл
			Если Найти(ОшибкаИзФиксированногоМассива.ОписаниеОшибки, ОшибкаОтменыДействия) > 0 Тогда
				КоличествоОшибокОтменыДействия = КоличествоОшибокОтменыДействия + 1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат КоличествоОшибокОтменыДействия;
	
КонецФункции

Функция НовыеПараметрыСохранения(ЭтоАвтозапрос) Экспорт

	Результат = Новый Структура();
	Результат.Вставить("Ошибки", 								Новый ФиксированныйМассив(Новый Массив));
	Результат.Вставить("ОтчетСсылка", 							Неопределено);
	Результат.Вставить("ЕстьОшибки", 							Ложь);
	Результат.Вставить("ЕстьНовые", 							Ложь);
	Результат.Вставить("ЭтоОбмен", 								Ложь);
	Результат.Вставить("ЭтоОтправка", 							Ложь);
	Результат.Вставить("ЭтоРасшифровка", 						Ложь);
	Результат.Вставить("ЭтоОбменИзОтчета", 						Ложь);
	Результат.Вставить("ЭтоОбменИзЭтаповОтправки", 				Ложь);
	Результат.Вставить("ЭтоАвтозапрос",           				ЭтоАвтозапрос);
	Результат.Вставить("ЭтоОбменИзФормы1СОтчетность", 			Ложь);
	Результат.Вставить("ЭтоОбновлениеМодуля", 					Ложь);
	Результат.Вставить("ЭтоОтправкаЗаявления", 					Ложь);
	Результат.Вставить("ВидКонтролирующегоОргана",				ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПустаяСсылка"));
	Результат.Вставить("НаименованиеКонтролирующегоОргана",		"");
	Результат.Вставить("Заголовок", 							"");
	Результат.Вставить("ЗакрытьБезДальнейшихДействий", 			Ложь);
	Результат.Вставить("ПутьКОбъекту", 							"");
	Результат.Вставить("ТекстРезультатаОбменаПоОрганизации", 	"");
	Результат.Вставить("КартинкаРезультатаОбменаПоОрганизации", Неопределено);
	
	Если ЭтоАвтозапрос Тогда
		Результат.Вставить("ОтправкаСсылка",    Неопределено);
		Результат.Вставить("ПротоколЗаполнен",  Ложь);
	Иначе
		
		// Для отправок.
		Результат.Вставить("ВыполняемоеОповещение", 	Неопределено);
		Результат.Вставить("РезультатОтправки", 		Неопределено);
		
		// Для обменов.
		Результат.Вставить("ИгнорироватьФорму1СОтчетности", Истина);
		Результат.Вставить("АдресДереваНовых", 				"");
		Результат.Вставить("ЕстьНовые",  		 			Ложь);
		Результат.Вставить("ПротоколНесданогоОтчета", 		Неопределено);
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#Область ВспомогательныеПроцедурыИФункции

Функция ДобавитьСтроку(ПредыдущиеЗначения, НовоеСообщение, Разделитель = Неопределено) Экспорт
	
	Если Разделитель = Неопределено Тогда
		Разделитель = РазделительСтрок();
	КонецЕсли;
	
	// Не добавляем дублирующиеся сообщения.
	Если Найти(ПредыдущиеЗначения, НовоеСообщение) = 0 Тогда
		// Вместо символа ПС используем другой разделитель ошибок, поскольку внутри одного сообщения
		// текст уже может быть разделен символом ПС и тогда одно сообщение будет разбито на два.
		Если ЗначениеЗаполнено(ПредыдущиеЗначения) Тогда
			Возврат СокрЛП(СокрЛП(ПредыдущиеЗначения) + Разделитель + НовоеСообщение);
		Иначе
			Возврат СокрЛП(НовоеСообщение);
		КонецЕсли;
	Иначе
		Возврат СокрЛП(ПредыдущиеЗначения);
	КонецЕсли;
	
КонецФункции

Функция ЧислоИПредметИсчисления(
		Число,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род) Экспорт
	
	ПредметИсчисленияБезЧисла = ПредметИсчисленияБезЧисла(
		Число,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род);
		
	ЧислоЦифройИПредметИсчисления = Строка(Число) + " " + ПредметИсчисленияБезЧисла;
	
	Возврат ЧислоЦифройИПредметИсчисления;
	
КонецФункции

Функция ПредметИсчисленияБезЧисла(
		Число,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род) Экспорт
	
	ФорматнаяСтрока = "Л = ru_RU";
	
	ПараметрыПредметаИсчисления = "%1,%2,%3,%4,,,,,0";
	ПараметрыПредметаИсчисления = СтрШаблон(
		ПараметрыПредметаИсчисления,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род);
		
	ЧислоСтрокойИПредметИсчисления = НРег(ЧислоПрописью(Число, ФорматнаяСтрока, ПараметрыПредметаИсчисления));
	
	ЧислоПрописью = ЧислоСтрокойИПредметИсчисления;
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления3, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления2, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления1, "");
	
	ПредметИсчисленияБезЧисла = СтрЗаменить(ЧислоСтрокойИПредметИсчисления, ЧислоПрописью, "");
	
	Возврат ПредметИсчисленияБезЧисла;
	
КонецФункции

Функция ЗаменитьПоследнююЗапятуюНаИ(ИсходнаяСтрока, Разделитель = ", ") Экспорт
	
	ДлинаРазделителя = СтрДлина(Разделитель);
	
	ПозицияРазделителя = СтрНайти(ИсходнаяСтрока, Разделитель, НаправлениеПоиска.СКонца);
	Если ПозицияРазделителя <> 0 Тогда
		
		ПодстрокаДоРазделителя 		= Лев(ИсходнаяСтрока, ПозицияРазделителя - 1);
		ПодстрокаПослеРазделителя 	= Сред(ИсходнаяСтрока, ПозицияРазделителя + ДлинаРазделителя);
		
		ИсходнаяСтрока = ПодстрокаДоРазделителя + " и " + ПодстрокаПослеРазделителя;
		
	КонецЕсли;
	
	Возврат ИсходнаяСтрока;
	
КонецФункции

Функция РазделительСтрок() Экспорт

	Возврат Символы.Таб;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьПараметрыДлительнойОтправкиПриНеобходимости()

	 ЗначенияПараметровДлительнойОтправки();

КонецПроцедуры


#КонецОбласти