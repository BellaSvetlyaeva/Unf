
#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает описание типов метаданных для которых необходимо извлекать адреса электронной почты
//
Функция ПолучитьТипыМетаданныхСодержащиеПартнерскиеEmail() Экспорт
	
	СписокТиповМетаданныхСодержащиеEmail = Новый СписокЗначений;
	
	СписокТиповМетаданныхСодержащиеEmail.Добавить(Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	СписокТиповМетаданныхСодержащиеEmail.Добавить(Новый ОписаниеТипов("СправочникСсылка.КонтактныеЛица"));
	
	Возврат СписокТиповМетаданныхСодержащиеEmail;
	
КонецФункции // ПолучитьТипыМетаданныхСодержащиеПартнерскиеEmail()

// Функция формирует получателей с адресами электронной почты для отправки электронного письма.
//
// Параметры:
//  Получатели			 - Список значений	 - допустимые типы элементов СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица
//  ВключаяПодчиненные	 - Булево	 - признак включения в результат контактных лиц для контрагентов
// Возвращаемое значение:
//  Массив - Массив структур с ключами:
//   * Представление - СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица
//   * Адрес - Строка
//   * ВидПочтовогоАдреса - не используется
Функция ПодготовитьЭлектронныеАдресаПолучателей(знач Получатели, ВключаяПодчиненные = Истина) Экспорт
	
	ЭлектронныеАдресаПолучателей = Новый Массив;
	Если Получатели.Количество() = 0 Тогда
		Возврат ЭлектронныеАдресаПолучателей;
	КонецЕсли;
	АдресЭлектроннойПочты = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	
	МассивПолучателей = Получатели.ВыгрузитьЗначения();
	ТаблицаEmail = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивПолучателей, 
		АдресЭлектроннойПочты, , ТекущаяДатаСеанса());
	
	Для каждого Получатель Из Получатели Цикл
		
		ЗначениеЭлементаСпискаЗначений = Получатель.Значение;
		
		АдресаЭП = "";
		МассивНайденныхСтрок = ТаблицаEmail.НайтиСтроки(Новый Структура("Объект", ЗначениеЭлементаСпискаЗначений));
		Для Каждого СтрокаКИ Из МассивНайденныхСтрок Цикл
			АдресаЭП = АдресаЭП + ?(АдресаЭП = "", "", "; ") + СтрокаКИ.Представление;
		КонецЦикла;
		
		СтруктураПолучателя = Новый Структура("
			|Представление,
			|Адрес,
			|ИсточникКонтактнойИнформации,
			|ВидПочтовогоАдреса"); // Необходим для чтения подсистемой БСП - ОбщаяФорма.ПодготовкаНовогоПисьма
		СтруктураПолучателя.Представление = ЗначениеЭлементаСпискаЗначений;
		СтруктураПолучателя.Адрес = АдресаЭП;
		СтруктураПолучателя.ИсточникКонтактнойИнформации = ЗначениеЭлементаСпискаЗначений;
		
		ЭлектронныеАдресаПолучателей.Добавить(СтруктураПолучателя);
		
		// Получим E-mail контактных лиц при помощи рекурсии
		Если ВключаяПодчиненные 
			И ТипЗнч(ЗначениеЭлементаСпискаЗначений) = Тип("СправочникСсылка.Контрагенты") Тогда
			
			СписокКонтактов = Новый СписокЗначений;
			МассивКонтактов = Справочники.Контрагенты.СвязанныеКонтакты(ЗначениеЭлементаСпискаЗначений);
			
			Для Каждого Контакт Из МассивКонтактов Цикл
				СписокКонтактов.Добавить(Контакт);
			КонецЦикла;
			
			ЭлектронныеАдресаКонтактныхЛиц = ПодготовитьЭлектронныеАдресаПолучателей(
				СписокКонтактов,
				Ложь);
			
			Для каждого ЭлементАдреса Из ЭлектронныеАдресаКонтактныхЛиц Цикл
				
				ЭлектронныеАдресаПолучателей.Добавить(ЭлементАдреса);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЭлектронныеАдресаПолучателей;
	
КонецФункции

// Функция формирует получателей с номерами телефонов для отправки SMS.
//
// Параметры:
//  Получатели			 - Список значений	 - допустимые типы элементов СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица
//  ВключаяПодчиненные	 - Булево	 - признак включения в результат контактных лиц для контрагентов
// Возвращаемое значение:
//  Массив - Массив структур с ключами:
//   * Представление - СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица
//   * НомерТелефона - Строка
Функция ПодготовитьНомераТелефоновПолучателей(знач Получатели, ВключаяПодчиненные = Истина) Экспорт
	
	НомераТелефоновПолучателей = Новый Массив;
	Если Получатели.Количество() = 0 Тогда
		Возврат НомераТелефоновПолучателей;
	КонецЕсли;
	НомерТелефона = Перечисления.ТипыКонтактнойИнформации.Телефон;
	
	МассивПолучателей = Получатели.ВыгрузитьЗначения();
	ТаблицаНомеров = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивПолучателей, 
		НомерТелефона, , ТекущаяДатаСеанса());
	
	Для каждого Получатель Из Получатели Цикл
		
		ЗначениеЭлементаСпискаЗначений = Получатель.Значение;
		
		НомераТелефонов = "";
		МассивНайденныхСтрок = ТаблицаНомеров.НайтиСтроки(Новый Структура("Объект", ЗначениеЭлементаСпискаЗначений));
		Для Каждого СтрокаКИ Из МассивНайденныхСтрок Цикл
			НомераТелефонов = НомераТелефонов + ?(НомераТелефонов = "", "", "; ") + СтрокаКИ.Представление;
		КонецЦикла;
		
		СтруктураПолучателя = Новый Структура("
			|Представление,
			|Телефон,
			|ИсточникКонтактнойИнформации");
		
		СтруктураПолучателя.Представление = ЗначениеЭлементаСпискаЗначений;
		СтруктураПолучателя.Телефон = НомераТелефонов;
		СтруктураПолучателя.ИсточникКонтактнойИнформации = ЗначениеЭлементаСпискаЗначений;
		
		НомераТелефоновПолучателей.Добавить(СтруктураПолучателя);
		
		// Получим НомераТелефонов контактных лиц при помощи рекурсии
		Если ВключаяПодчиненные 
			И ТипЗнч(ЗначениеЭлементаСпискаЗначений) = Тип("СправочникСсылка.Контрагенты") Тогда
			
			СписокКонтактов = Новый СписокЗначений;
			МассивКонтактов = Справочники.Контрагенты.СвязанныеКонтакты(ЗначениеЭлементаСпискаЗначений);
			
			Для Каждого Контакт Из МассивКонтактов Цикл
				СписокКонтактов.Добавить(Контакт);
			КонецЦикла;
			
			НомераТелефоновКонтактныхЛиц = ПодготовитьНомераТелефоновПолучателей(
				СписокКонтактов,
				Ложь);
			
			Для каждого ЭлементТелефона Из НомераТелефоновКонтактныхЛиц Цикл
				
				НомераТелефоновПолучателей.Добавить(ЭлементТелефона);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НомераТелефоновПолучателей;
	
КонецФункции

#КонецОбласти