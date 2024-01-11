
#Область СлужебныеПроцедурыИФункции

Функция РеквизитыОрганизацииДляРегистрационногоПакета(Организация) Экспорт
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("КодНалоговогоОргана", "");
	Реквизиты.Вставить("АдресОрганизации", "");
	Реквизиты.Вставить("ЗначениеПолейАдреса", "");
	
	Реквизиты.КодНалоговогоОргана = РегистрационныеДанныеОрганизации(Организация).КодИМНС;
	
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация,
							Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, ТекущаяДатаСеанса(), Ложь);
							
	НайденныеСтроки      = КонтактнаяИнформация.НайтиСтроки(Новый Структура(
		"Вид", Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Реквизиты.АдресОрганизации    = НайденныеСтроки[0].Представление;
		Реквизиты.ЗначениеПолейАдреса = НайденныеСтроки[0].Значение;
	КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

Функция СравнитьРеквизиты(Организация, Сертификат) Экспорт
	
	Результат = Новый Структура;
	
	СвойстваСубъекта = КриптографияБЭД.СвойстваСубъектаСертификатаПоСсылке(Сертификат);
	СвойстваСубъекта.Вставить("ИНН", 
		СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СвойстваСубъекта.ИНН, 12, "0"));
	
	РеквизитИНН = ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации");
	СвойстваОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, РеквизитИНН);
	СвойстваОрганизации.Вставить(РеквизитИНН, 
		СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СвойстваОрганизации[РеквизитИНН], 12, "0"));
	
	Результат.Вставить("ИННОтличается", СвойстваСубъекта.Свойство("ИНН") И СвойстваСубъекта.ИНН <> СвойстваОрганизации[РеквизитИНН]);
	
	Возврат Результат;

КонецФункции

Функция ПроверитьСертификат(Сертификат) Экспорт
	
	РеквизитыСертификатов = КриптографияБЭД.СвойстваСертификатов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сертификат));
	РеквизитыСертификата = РеквизитыСертификатов[Сертификат];
	СертификатКриптографии = Новый СертификатКриптографии(РеквизитыСертификата.ДанныеСертификата);
	СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(СертификатКриптографии);
	
	СертификатДействующий = СвойстваСертификата.ДатаОкончания > ТекущаяДатаСеанса();
	
	Если Не СертификатДействующий Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Срок действия выбранного сертификата истек, выберите другой сертификат'"),, "СертификатКриптографии");
	КонецЕсли;
	
	ПользователюДоступенСертификат = КриптографияБЭД.ПользователюДоступенСертификат(Сертификат);
	Если Не ПользователюДоступенСертификат Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Сертификат недоступен текущему пользователю, выберите другой сертификат'"),, "СертификатКриптографии");
	КонецЕсли;
	
	Возврат СертификатДействующий И ПользователюДоступенСертификат;
	
КонецФункции

// Создает учетную запись для обмена электронными документами.
// 
// Параметры:
// 	ОписаниеУчетнойЗаписи - см. УчетныеЗаписиЭДОКлиентСервер.НовоеОписаниеУчетнойЗаписи
// 	АдресИзменен - Булево
// Возвращаемое значение:
// 	Булево - учетная запись создана
Функция СоздатьУчетнуюЗапись(ОписаниеУчетнойЗаписи, АдресИзменен) Экспорт
	
	ДанныеСохранены = Ложь;
	
	Отбор = УчетныеЗаписиЭДО.НовыйОтборУчетныхЗаписей();
	Отбор.УчетныеЗаписи = "&Идентификатор";
	Отбор.Организация = "&Организация";
	ЗапросУчетныхЗаписей = УчетныеЗаписиЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", Отбор);
	
	Запросы = Новый Массив;
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
	|ИЗ
	|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("Идентификатор", ОписаниеУчетнойЗаписи.Идентификатор);
	ИтоговыйЗапрос.УстановитьПараметр("Организация", ОписаниеУчетнойЗаписи.Организация);

	Если Не ИтоговыйЗапрос.Выполнить().Пустой() Тогда
		Шаблон = НСтр("ru = 'Учетная запись организации %2 с идентификатором %1 уже существует'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			ОписаниеУчетнойЗаписи.Идентификатор, ОписаниеУчетнойЗаписи.Организация);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат ДанныеСохранены;
	ИначеЕсли Не ЗначениеЗаполнено(ОписаниеУчетнойЗаписи.Идентификатор) Или Не ЗначениеЗаполнено(
		ОписаниеУчетнойЗаписи.Организация) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнены обязательные реквизиты учетной записи.'"));
		
		Возврат ДанныеСохранены;
		
	КонецЕсли;

	НачатьТранзакцию();
	Попытка
		Запись = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
		ЗаполнитьДанныеУчетнойЗаписи(Запись, ОписаниеУчетнойЗаписи);
		Запись.Записать();
			
		Если НастройкиБЭД.ИспользоватьЭлектронныеПодписи() Тогда
			Доверенности = Новый Соответствие;
			Доверенности.Вставить(ОписаниеУчетнойЗаписи.Сертификат, ОписаниеУчетнойЗаписи.Доверенность);
			ЗаписатьСертификатыУчетнойЗаписи(ОписаниеУчетнойЗаписи.Идентификатор, ОписаниеУчетнойЗаписи.Сертификат,
				, Доверенности);
		КонецЕсли;
		
		СинхронизацияЭДО.ИзменитьСостояниеОбмена(ОписаниеУчетнойЗаписи.Идентификатор, "ДатаПолученияДокументов",
			ОбщегоНазначенияБЭД.УниверсальнаяДатаВМиллисекундахИзДаты(НачалоДня(ТекущаяДатаСеанса())));
		
		Если АдресИзменен Тогда
			УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(ОписаниеУчетнойЗаписи.Организация,
				ОписаниеУчетнойЗаписи.АдресОрганизации, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
				ТекущаяДатаСеанса(), Истина);
		КонецЕсли;
		ДанныеСохранены = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ВидОперации = НСтр("ru = 'Создание учетной записи электронного документооборота'");
		ПодробныйТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КраткийТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, КраткийТекстОшибки,
			"ОбменСКонтрагентами");
			
	КонецПопытки;
	
	ОбновитьПовторноИспользуемыеЗначения();

	Возврат ДанныеСохранены;

КонецФункции

Процедура ЗаполнитьДанныеУчетнойЗаписи(НоваяУчетнаяЗапись, ОписаниеУчетнойЗаписи)
	
	НоваяУчетнаяЗапись.НаименованиеУчетнойЗаписи = ОписаниеУчетнойЗаписи.Наименование;

	НоваяУчетнаяЗапись.Организация              = ОписаниеУчетнойЗаписи.Организация;
	НоваяУчетнаяЗапись.АдресОрганизации         = ОписаниеУчетнойЗаписи.АдресОрганизации;
	НоваяУчетнаяЗапись.АдресОрганизацииЗначение = ОписаниеУчетнойЗаписи.АдресОрганизацииЗначение;
	НоваяУчетнаяЗапись.СпособОбменаЭД           = ОписаниеУчетнойЗаписи.СпособОбмена;

	НоваяУчетнаяЗапись.ИдентификаторЭДО = ОписаниеУчетнойЗаписи.Идентификатор;

	ПараметрыУведомлений = ОписаниеУчетнойЗаписи.ПараметрыУведомлений;

	НоваяУчетнаяЗапись.КодНалоговогоОргана = ОписаниеУчетнойЗаписи.КодНалоговогоОргана;
	НоваяУчетнаяЗапись.ОператорЭДО     = ОписаниеУчетнойЗаписи.Оператор;

	НоваяУчетнаяЗапись.ЭлектроннаяПочтаДляУведомлений = ПараметрыУведомлений.АдресУведомлений;
	НоваяУчетнаяЗапись.УведомлятьОНовыхПриглашениях = ПараметрыУведомлений.УведомлятьОНовыхПриглашениях;
	НоваяУчетнаяЗапись.УведомлятьОбОтветахНаПриглашения = ПараметрыУведомлений.УведомлятьОбОтветахНаПриглашения;
	НоваяУчетнаяЗапись.УведомлятьОНовыхДокументах = ПараметрыУведомлений.УведомлятьОНовыхДокументах;
	НоваяУчетнаяЗапись.УведомлятьОНеОбработанныхДокументах = ПараметрыУведомлений.УведомлятьОНеобработанныхДокументах;
	НоваяУчетнаяЗапись.УведомлятьОбОкончанииСрокаДействияСертификата = ПараметрыУведомлений.УведомлятьОбОкончанииСрокаДействияСертификата;

	НоваяУчетнаяЗапись.НазначениеУчетнойЗаписи = ОписаниеУчетнойЗаписи.Назначение;
	НоваяУчетнаяЗапись.ПодробноеОписаниеУчетнойЗаписи = ОписаниеУчетнойЗаписи.ПодробноеОписание;
	НоваяУчетнаяЗапись.ПринятыУсловияИспользования = ОписаниеУчетнойЗаписи.ПринятыУсловияИспользования;
		
КонецПроцедуры

// Возвращает данные организации для заполнения заявки на получение уникального
// идентификатора абонента, добавления сертификата абонента.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, данные которой требуется получить.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - данные об организации:
//    * Индекс - Строка - почтовый индекс организации.
//    * Регион - Строка - регион организации.
//    * КодРегиона - Строка - код региона организации.
//    * Район - Строка - Район.
//    * Город - Строка - Город.
//    * НаселенныйПункт - Строка - населенный пункт расположения организации.
//    * Улица - Строка - Улица.
//    * Дом - Строка - Дом.
//    * Корпус - Строка - Корпус.
//    * Квартира - Строка - Квартира.
//    * Телефон - Строка - телефон организации.
//    * Наименование - Строка - наименование организации.
//    * ИНН - Строка - ИНН организации.
//    * КПП - Строка - КПП организации.
//    * ОГРН - Строка - ОГРН организации.
//    * КодИМНС - Строка - код ИМНС организации.
//    * ЮрФизЛицо - Строка - вид лица, возможные значения: "ЮрЛицо" или "ФизЛицо".
//    * Фамилия - Строка - фамилия руководителя.
//    * Имя - Строка - имя руководителя.
//    * Отчество - Строка - отчество руководителя.
//    * Должность - Строка - должность руководителя.
//
Функция РегистрационныеДанныеОрганизации(Знач Организация) Экспорт
	
	ДанныеДляЗаполнения = ИнтеграцияЭДО.РегистрационныеДанныеОрганизации(Организация);
	
	ДанныеДляВозврата = НовыеРегистрационныеДанныеОрганизации();
	ЗаполнитьЗначенияСвойств(ДанныеДляВозврата, ДанныеДляЗаполнения);
	
	Возврат Новый ФиксированнаяСтруктура(ДанныеДляВозврата);
	
КонецФункции

Функция НовыеРегистрационныеДанныеОрганизации()
	
	Данные = Новый Структура;
	Данные.Вставить("Индекс", "");
	Данные.Вставить("КодРегиона", "");
	Данные.Вставить("Регион", "");
	Данные.Вставить("Район", "");
	Данные.Вставить("Город", "");
	Данные.Вставить("НаселенныйПункт", "");
	Данные.Вставить("Улица", "");
	Данные.Вставить("Дом", "");
	Данные.Вставить("Корпус", "");
	Данные.Вставить("Квартира", "");
	Данные.Вставить("Телефон", "");
	Данные.Вставить("Наименование", "");
	Данные.Вставить("ИНН", "");
	Данные.Вставить("КПП", "");
	Данные.Вставить("ОГРН", "");
	Данные.Вставить("КодИМНС", "");
	Данные.Вставить("ЮрФизЛицо", "");
	Данные.Вставить("Фамилия", "");
	Данные.Вставить("Имя", "");
	Данные.Вставить("Отчество", "");
	Данные.Вставить("Должность", "");
	
	Возврат Данные;
	
КонецФункции

// Проверяет сертификат для учетной записи
// 
// Параметры:
// 	Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 	Организация - СправочникСсылка.Организации
// 	СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// 	ИдентификаторОператора - Строка
// Возвращаемое значение:
// 	Структура:
//    * Статус - Булево - Истина, если проверка пройдена без ошибок
//    * Ошибки - Массив - массив из структур с описанием ошибки
Функция ПроверитьСертификатДляУчетнойЗаписи(Сертификат, Организация, СпособОбмена, ИдентификаторОператора=Неопределено) Экспорт
	
	Результат = Новый Структура("Статус", Истина);
	Ошибки = Новый Массив;
	
	// Проверяем для облачных сертификатов, что их можно использовать.
	СообщениеОбОшибке = "";
	Если Не КриптографияБЭД.ПроверитьПравомерностьИспользованияСертификата(Сертификат, СообщениеОбОшибке) Тогда
		ОписаниеОшибки = Новый Структура("Тип, Текст");
		ОписаниеОшибки.Тип = "Ошибка";
		ОписаниеОшибки.Текст = СообщениеОбОшибке;
		Ошибки.Добавить(ОписаниеОшибки);
	КонецЕсли;
	
	СвойстваСубъекта = КриптографияБЭД.СвойстваСубъектаСертификатаПоСсылке(Сертификат);
	
	Если Не ТребуетсяДоверенность(Организация, Сертификат, СпособОбмена, ИдентификаторОператора) Тогда
		// Проверяем равенство ИНН и КПП в сертификате и организации.
		СвойстваСубъекта = КриптографияБЭД.СвойстваСубъектаСертификатаПоСсылке(Сертификат);
		СвойстваСубъекта.Вставить("ИНН", 
			СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СвойстваСубъекта.ИНН, 12, "0"));
		
		ИменаРеквизитов = Новый Структура("ИНН, КПП",
			ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации"),
			ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППОрганизации"));
		
		СвойстваОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, ИменаРеквизитов);
		СвойстваОрганизации.ИНН = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СвойстваОрганизации.ИНН, 12, "0");
		
		ИННОтличается = СвойстваСубъекта.Свойство("ИНН") И СвойстваСубъекта.ИНН <> СвойстваОрганизации.ИНН;
		КППОтличается = СвойстваСубъекта.Свойство("КПП") И СвойстваСубъекта.КПП <> СвойстваОрганизации.КПП;
		
		ТекстОшибки = Неопределено;
		
		Если ИННОтличается И КППОтличается Тогда
			ТекстОшибки = НСтр("ru = 'ИНН/КПП по данным выбранного сертификата не совпадают с ИНН/КПП организации.'");
		ИначеЕсли ИННОтличается Тогда
			ТекстОшибки = НСтр("ru = 'ИНН по данным выбранного сертификата не совпадает с ИНН организации.'");
		ИначеЕсли КППОтличается Тогда
			ТекстОшибки = НСтр("ru = 'КПП по данным выбранного сертификата не совпадает с КПП организации.'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТекстОшибки <> Неопределено Тогда
		ОписаниеОшибки = Новый Структура("Тип, Текст");
		ОписаниеОшибки.Тип = "Предупреждение";
		ОписаниеОшибки.Текст = ТекстОшибки;
		Ошибки.Добавить(ОписаниеОшибки);
	КонецЕсли;
	
	Если Ошибки.Количество() Тогда
		Результат.Статус = Ложь;
		Результат.Вставить("Ошибки", Ошибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НеСохраненныеРеквизитыУчетнойЗаписи(ИдентификаторУчетнойЗаписи, ИзмененыПараметрыУчетнойЗаписи,
	ИзмененыНастройкиУведомлений) Экспорт
	
	Результат = Новый Структура;
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить("ВЫБРАТЬ" + Символы.ПС);
	
	Если ИзмененыНастройкиУведомлений Тогда
		МассивСтрок.Добавить("УчетныеЗаписиЭДО.УведомлятьОНовыхПриглашениях КАК УведомлятьОНовыхПриглашениях,
		|	УчетныеЗаписиЭДО.УведомлятьОбОтветахНаПриглашения КАК УведомлятьОбОтветахНаПриглашения,
		|	УчетныеЗаписиЭДО.УведомлятьОНовыхДокументах КАК УведомлятьОНовыхДокументах,
		|	УчетныеЗаписиЭДО.ЭлектроннаяПочтаДляУведомлений КАК ЭлектроннаяПочтаДляУведомлений,
		|	УчетныеЗаписиЭДО.УведомлятьОНеОбработанныхДокументах КАК УведомлятьОНеОбработанныхДокументах,
		|	УчетныеЗаписиЭДО.УведомлятьОбОкончанииСрокаДействияСертификата КАК УведомлятьОбОкончанииСрокаДействияСертификата");
		Если ИзмененыПараметрыУчетнойЗаписи Тогда
			МассивСтрок.Добавить("," + Символы.ПС);
		КонецЕсли;
	КонецЕсли;
	
	Если ИзмененыПараметрыУчетнойЗаписи Тогда
		МассивСтрок.Добавить("	УчетныеЗаписиЭДО.НазначениеУчетнойЗаписи КАК НазначениеУчетнойЗаписи,
		|	УчетныеЗаписиЭДО.ПодробноеОписаниеУчетнойЗаписи КАК ПодробноеОписаниеУчетнойЗаписи");
	КонецЕсли;
	
	МассивСтрок.Добавить(Символы.ПС);
	
	МассивСтрок.Добавить("ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО = &ИдентификаторЭДО");
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(МассивСтрок, "");
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	
	РезультатЗапроса = Запрос.Выполнить();
	Таблица = РезультатЗапроса.Выгрузить();
	Если ЗначениеЗаполнено(Таблица) Тогда
		Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Таблица[0]);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьСертификатыУчетнойЗаписи(ИдентификаторУчетнойЗаписи, Знач Сертификаты,
	Замещать = Истина, Доверенности = Неопределено) Экспорт
	
	Если ТипЗнч(Сертификаты) <> Тип("Массив") Тогда
		Сертификаты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сертификаты);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СертификатыУчетныхЗаписейЭДО");
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.СертификатыУчетныхЗаписейЭДО.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторУчетнойЗаписи);
		
		Если Не Замещать Тогда 
			НаборЗаписей.Прочитать();
		КонецЕсли;
		
		СертификатыДействителенДо = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сертификаты, "ДействителенДо");
		ТаблицаЗаписей = НаборЗаписей.Выгрузить();
		
		Для Каждого Сертификат Из Сертификаты Цикл 
			
			НоваяЗапись = ТаблицаЗаписей.Добавить();
			НоваяЗапись.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;
			НоваяЗапись.Сертификат = Сертификат;
			НоваяЗапись.ДействителенДо = СертификатыДействителенДо.Получить(Сертификат);
			Если Доверенности <> Неопределено Тогда
				НоваяЗапись.Доверенность = Доверенности[Сертификат];
			КонецЕсли;
		КонецЦикла;
		
		ТаблицаЗаписей.Свернуть("ИдентификаторЭДО, Сертификат, Доверенность, ДействителенДо");
		
		НаборЗаписей.Загрузить(ТаблицаЗаписей);
		НаборЗаписей.Записать(Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Обновление сертификатов учетной записи'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(Информация),
			СтрШаблон(НСтр("ru = 'Не удалось обновить сертификаты по ученой записи: %1'"), ИдентификаторУчетнойЗаписи));
			
	КонецПопытки;
	
КонецПроцедуры

Функция ЕстьСертификатыУчетнойЗаписи(ИдентификаторУчетнойЗаписи) Экспорт
	
	БлокировкаДанных = Новый БлокировкаДанных;
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СертификатыУчетныхЗаписейЭДО");
	ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
	БлокировкаДанных.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК Выбран
		|ИЗ
		|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
		|ГДЕ
		|	СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

Функция УдалитьУчетнуюЗапись(ИдентификаторУчетнойЗаписи) Экспорт
	
	Результат = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
		|	УчетныеЗаписиЭДО.СпособОбменаЭД КАК СпособОбменаЭД
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	
	НачатьТранзакцию();
	Попытка
		Поля = Новый Структура;
		Поля.Вставить("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку("РегистрСведений.УчетныеЗаписиЭДО",
			Поля);
		// Удаляем все под текущими правами пользователя.
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаУчетныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаУчетныеЗаписи.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторУчетнойЗаписи);
			НаборЗаписей.Записать();
			
			Если ВыборкаУчетныеЗаписи.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
				УстановитьПривилегированныйРежим(Истина);
				ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ИдентификаторУчетнойЗаписи);
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.СертификатыУчетныхЗаписейЭДО.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторУчетнойЗаписи);
		НаборЗаписей.Записать();
		
		СинхронизацияЭДОСобытия.ПриУдаленииУчетнойЗаписи(ИдентификаторУчетнойЗаписи);
		Результат = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Информация = ИнформацияОбОшибке();
		
		Результат = Ложь;
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление учетной записи электронного документооборота'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(Информация));
			
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция СвойстваУчетныхЗаписей(ИдентификаторыУчетныхЗаписей) Экспорт
	
	Результат = Новый Соответствие;
	
	Отбор = УчетныеЗаписиЭДО.НовыйОтборУчетныхЗаписей();
	Отбор.УчетныеЗаписи = "&Идентификаторы";
	
	ЗапросУчетныхЗаписей = УчетныеЗаписиЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", Отбор);
	
	Запросы = Новый Массив;
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
		|	УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи КАК НаименованиеУчетнойЗаписи,
		|	УчетныеЗаписиЭДО.НазначениеУчетнойЗаписи КАК НазначениеУчетнойЗаписи,
		|	УчетныеЗаписиЭДО.ПодробноеОписаниеУчетнойЗаписи КАК ПодробноеОписаниеУчетнойЗаписи
		|ИЗ
		|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО";
		
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("Идентификаторы", ИдентификаторыУчетныхЗаписей);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = ИтоговыйЗапрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗначенияСвойств = Новый Структура;
		ЗначенияСвойств.Вставить("ИдентификаторЭДО");
		ЗначенияСвойств.Вставить("НаименованиеУчетнойЗаписи");
		ЗначенияСвойств.Вставить("НазначениеУчетнойЗаписи");
		ЗначенияСвойств.Вставить("ПодробноеОписаниеУчетнойЗаписи");
		ЗаполнитьЗначенияСвойств(ЗначенияСвойств, Выборка);
		Результат.Вставить(Выборка.ИдентификаторЭДО, ЗначенияСвойств);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Изменяет данные учетной записи.
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// 	Данные - Структура:
//    * Назначение - Строка
//    * ПодробноеОписание - Строка
Процедура ИзменитьДанныеУчетнойЗаписи(ИдентификаторУчетнойЗаписи, Данные) Экспорт

	ПоляБлокировки = Новый Структура("ИдентификаторЭДО");
	ПоляБлокировки.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;

	НачатьТранзакцию();
	Попытка
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку(
				"РегистрСведений.УчетныеЗаписиЭДО", ПоляБлокировки);

		Запись = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
		Запись.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;
		Запись.Прочитать();
		Если Запись.Выбран() Тогда
			Запись.ПринятыУсловияИспользования = Истина;
			Запись.НазначениеУчетнойЗаписи = Данные.Назначение;
			Запись.ПодробноеОписаниеУчетнойЗаписи = Данные.ПодробноеОписание;

			УстановитьПривилегированныйРежим(Истина);
			Запись.Записать();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

// Возвращает сертификаты и доверенности по идентификатору учетной записи
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//      * Ключ     - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//      * Значение - ОпределяемыйТип.МашиночитаемаяДоверенность
// 
Функция СертификатыИДоверенностиУчетнойЗаписи(ИдентификаторУчетнойЗаписи) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СертификатыУчетныхЗаписейЭДО.Сертификат КАК Сертификат,
		|	СертификатыУчетныхЗаписейЭДО.Доверенность Как Доверенность
		|ИЗ
		|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
		|ГДЕ
		|	СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат = Новый Соответствие();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Результат.Вставить(Выборка.Сертификат, Выборка.Доверенность);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СертификатЗарегистрированВУчетнойЗаписи(Сертификат, ИдентификаторУчетнойЗаписи) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СертификатыУчетныхЗаписейЭДО.Сертификат КАК Сертификат
		|ИЗ
		|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
		|ГДЕ
		|	СертификатыУчетныхЗаписейЭДО.Сертификат = &Сертификат
		|	И СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("Сертификат"      , Сертификат);
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

// Проверяет необходимость доверенности к сертификату
// 
// Параметры:
//	Организация - СправочникСсылка.Организации
// 	Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 	СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// 	ИдентификаторОператора - Строка
// Возвращаемое значение:
// 	Булево - Истина, если требуется доверенность
Функция ТребуетсяДоверенность(Организация, Сертификат, СпособОбмена, ИдентификаторОператора=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(Сертификат) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СвойстваСубъектаСертификата = КриптографияБЭД.СвойстваСубъектаСертификатаПоСсылке(Сертификат);
	ЭтоСертификатИП = СвойстваСубъектаСертификата.ОГРНИП <> Неопределено;
	ТребуетсяДоверенность = СпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО
		И Не ИдентификаторОператора = "2AL" // ООО «Такском»
		И Не ЭтоСертификатИП
		И ЭлектронныеДокументыЭДО.ТребуетсяМашиночитаемаяДоверенность(Организация, Сертификат);
	
	Возврат ТребуетсяДоверенность;
	
КонецФункции

Процедура ЗаполнитьСписокВыбораДоверенностей(Организация, Сертификат, ЭлементФормы) Экспорт
	
	Отбор = МашиночитаемыеДоверенности.НовыйОтборМЧД();
	Отбор.Доверитель = Организация;
	Отбор.Сертификат = Сертификат;
	Доверенности = МашиночитаемыеДоверенности.ПолучитьДоверенностиОрганизации(Отбор);
	Справочники.МЧД003.ДополнитьСписокДоверенностейПоОтбору(Отбор, Доверенности);
	
	ЭлементФормы.СписокВыбора.Очистить();
	ЭлементФормы.СписокВыбора.ЗагрузитьЗначения(Доверенности);
	
КонецПроцедуры

#Область НапоминанияОбОтсутствииСертификатов

Функция НапоминанияОбОтсутствииСертификатов() Экспорт
	
	Возврат ХранилищеСистемныхНастроек.Загрузить(
		"РегистрСведений.СертификатыУчетныхЗаписейЭДО.Форма.ПомощникРегистрацииСертификатов", "ОтложенныеНапоминания");
	
КонецФункции

Процедура СохранитьНапоминанияОбОтсутствииСертификатов(Напоминания) Экспорт
	
	ХранилищеСистемныхНастроек.Сохранить(
		"РегистрСведений.СертификатыУчетныхЗаписейЭДО.Форма.ПомощникРегистрацииСертификатов",
		"ОтложенныеНапоминания", Напоминания);
	
КонецПроцедуры

Функция ХешСертификатовУчетныхЗаписей(ИдентификаторыУчетныхЗаписей) Экспорт
	
	ХешиОтпечатков = Новый Соответствие;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК УчетнаяЗапись,
	|	ЕСТЬNULL(СертификатыПрофиля.Сертификат.Отпечаток, """") КАК Отпечаток
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыПрофиля
	|		ПО УчетныеЗаписиЭДО.ИдентификаторЭДО = СертификатыПрофиля.ИдентификаторЭДО
	|ГДЕ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО В(&ИдентификаторыУчетныхЗаписей)
	|ИТОГИ ПО
	|	УчетнаяЗапись");
	
	Запрос.УстановитьПараметр("ИдентификаторыУчетныхЗаписей", ИдентификаторыУчетныхЗаписей);
	
	УстановитьПривилегированныйРежим(Истина);
	ВыборкаУчетнаяЗапись = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	УстановитьПривилегированныйРежим(Ложь);
	Пока ВыборкаУчетнаяЗапись.Следующий() Цикл
		
		Отпечатки = "";
		
		ВыборкаДетали = ВыборкаУчетнаяЗапись.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			Отпечатки = Отпечатки + ВыборкаДетали.Отпечаток;
		КонецЦикла;
		
		ХешОтпечатков = "";
		
		Если ЗначениеЗаполнено(Отпечатки) Тогда
			Хеширование = Новый ХешированиеДанных(ХешФункция.MD5);
			Хеширование.Добавить(Отпечатки);
			ХешОтпечатков = Строка(Хеширование.ХешСумма);
		КонецЕсли;
		
		ХешиОтпечатков.Вставить(ВыборкаУчетнаяЗапись.УчетнаяЗапись, ХешОтпечатков);
		
	КонецЦикла;
	
	Возврат ХешиОтпечатков;

КонецФункции

Процедура ПрименитьНастройкиНапоминанийОбОтсутствииСертификатов(ОтложенныеНапоминания, ТаблицаДанных) Экспорт
	
	Если ОтложенныеНапоминания.Количество() Тогда
		
		СтрокиКУдалению  = Новый Массив;
		ТекущаяДата      = ТекущаяДатаСеанса();
		Срок             = 3600 * 24 * 7; // семь дней
		ХешиСертификатов = ХешСертификатовУчетныхЗаписей(ТаблицаДанных.ВыгрузитьКолонку("ИдентификаторЭДО"));
		
		Для Каждого Строка Из ТаблицаДанных Цикл
			
			СтрокиНастроек = ОтложенныеНапоминания.НайтиСтроки(
				Новый Структура("ПрофильНастроек", Строка.ИдентификаторЭДО));
			Если СтрокиНастроек.Количество() Тогда
				
				СтрокаНастроек = СтрокиНастроек[0];
				
				ПредыдущийХешСертификатов = СтрокаНастроек.ХешСертификатов;
				ТекущийХешСертификатов    = ХешиСертификатов[Строка.ИдентификаторЭДО];
				
				Если ПредыдущийХешСертификатов = ТекущийХешСертификатов Тогда
					
					Если ТекущаяДата - СтрокаНастроек.ДатаОтсчета < Срок Тогда
						// Срок еще не прошел, не показываем профиль.
						СтрокиКУдалению.Добавить(Строка);
					Иначе
						// Срок прошел, удаляем профиль из настроек напоминаний,
						// чтобы он снова появился в помощнике.
						ОтложенныеНапоминания.Удалить(СтрокаНастроек);
					КонецЕсли;
					
				Иначе
					// Состав сертификатов изменился, удаляем профиль из настроек напоминаний,
					// чтобы он снова появился в помощнике.
					ОтложенныеНапоминания.Удалить(СтрокаНастроек);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если СтрокиКУдалению.Количество() Тогда
			Для Каждого Строка Из СтрокиКУдалению Цикл
				ТаблицаДанных.Удалить(Строка);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти