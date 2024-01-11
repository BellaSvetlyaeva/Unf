////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки РегламентированнаяОтчетность (БРО).
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Объявление библиотеки.

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "РегламентированнаяОтчетность";
	Описание.Версия = "1.2.1.201";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий обновления информационной базы.

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ВыполнитьОбновлениеИнформационнойБазы";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ОтключитьВнешнийМодульДокументооборотаСФНС";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.УправлениеОбработчиками = Истина;
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБРО.ЗаполнитьОбработчикиРазделенныхДанных";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ОчиститьВнешниеРеглОтчеты";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПредставлениеПериодаИВидаРеглОтчета";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.ДобавитьСкрытыеОтчетыВРегистрСведений";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиРазделенныйСпрУдалитьРеглОтчетыНаНеРазделенныйСпрРеглОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ОбработкаОбновленияПриПереходеС82";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "РегистрыСведений.СправочникиШаблоновОтчетовСтатистики.ОчиститьСправочникиШаблонов";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("0e41f0bb-ee46-46c8-817c-19e8021171e2");
	Обработчик.Комментарий = НСтр("ru = 'Выполняет очистку справочников статистических отчетов.
		|До завершения выполнения работа со справочниками может быть затруднена.'");
	
	// Конвертация статусов регламентированных отчетов после перехода с 2.0.
	//
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьСтатусыНеОтправлявшихсяРеглОтчетов";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.29";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиНаРегламентированныеОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.1.41";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.ДобавитьСкрытыеОтчетыВРегистрСведений";
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.48";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиРазделенныйСпрУдалитьРеглОтчетыНаНеРазделенныйСпрРеглОтчеты";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.1.52";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УдалитьПовторяющиесяГруппыИЭлементыВСправочникеРеглОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.58";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПредставлениеПериодаИВидаРеглОтчета";
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.60";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.УдалитьСкрытыеОтчетыИзРегистраСведений";
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.2";
	Обработчик.Процедура = "РегламентированнаяОтчетностьВызовСервера.ЗаполнитьРегистрЖурналОчетовСтатусы";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление информации в форме 1С-Отчетность в разделе Отчеты. До завершения выполнения данные в форме 1С-Отчетность могут отображаться некорректно'");
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.3";
	Обработчик.Процедура = "ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВключитьМеханизмОнлайнСервисовРО";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.12";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияБухгалтерскихРеглОтчетов";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований бухгалтерских регламентированных отчетов.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.12";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьПредставлениеПериода";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение представлений отчетного периода.'");
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.12";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьПредставлениеФинансовогоПериода";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение представлений отчетного периода.'");
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.5";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьВидыОтправляемыхДокументовСЗВ_МДоходыОтОбрМедДеятельностиНДФЛ";
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.1.9.11";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УдалитьПовторяющиесяГруппыИЭлементыВСправочникеРеглОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.12";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьВидыОтправляемыхДокументовОбъемВинограда";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияДекларацийПоАлкоголю";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияДекларацийПоАлкоголю";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияРеестровПоНДС";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований реестров по НДС.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияРеестровПоНДС";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований реестров по НДС.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.14";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьОписаниеДекларацийПоАлкоголюРеестровПоНДС";
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.19";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ЗаполнитьИндексКартинкиРеглОтчетов";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет заполнение индекса картинки регламентированных отчетов.'");
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.22";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИсправитьРеквизитыОтправкиСправокОРублевыхИВалютныхСчетах";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение реквизитов отправки справок о рублевых и валютных счетах.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.11";
	Обработчик.Процедура = "ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВключитьМеханизмОнлайнСервисовРО";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.6";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ПереименоватьРасчетПлатыВДекларациюНВОС";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.9";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьСтатусыНеОтправлявшихсяРеглОтчетов";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.9";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтправокВКонтролирующиеОрганы.ИзменитьСтатусыНеОтправлявшихсяУведомлений";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьПоАлкогольнойПродукции") Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.11.12";
		Обработчик.Процедура = "РегламентированнаяОтчетностьАЛКО.ПриОбновленииИБЗаполнитьИзмерениеОрганизацияАлко";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7777-a06b-c1980bebebbf");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Выполняет заполнение измерения Организация в регистрах сведений алкогольной отчетности.'");
	КонецЕсли;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.18";
	Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ИзменениеИменМакетовПФ";
	Обработчик.ОбщиеДанные = Ложь;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.36";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьВидыОтправляемыхДокументовСЗВК";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.37";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияДекларацийПоКосвеннымНалогам";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.37";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияДекларацийПоКосвеннымНалогам";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.11.37";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИзменитьОписаниеДекларацийПоКосвеннымНалогам";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.12.19";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьВидИКодКонтролирующегоОрганаПодтвержденийВидаДеятельности";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.12.19";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьВидКонтролирующегоОрганаСоответствийУсловийТруда";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.13.5";
	Обработчик.Процедура = "ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВключитьМеханизмОнлайнСервисовРО";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.13.5";
	Обработчик.Процедура = "РегистрыСведений.РесурсыМеханизмаОнлайнСервисовРО.ПеренестиДанныеИзРазделенногоРегистра";
	Обработчик.ОбщиеДанные = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.13.5";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияДекларацийПоФармАлкоголю";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7778-a06b-c1980bebebbf");
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по фармакопейному алкоголю.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.13.5";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияДекларацийПоФармАлкоголю";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7779-a06b-c1980bebebbf");
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по фармакопейному алкоголю.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.13.5";
	Обработчик.Процедура = "Документы.ВыгрузкаРегламентированныхОтчетов.УдалитьПояснительныеЗапискиЕНВД";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьВМинистерствоОбороны") Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия    = "1.1.13.5";
		Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УдалитьРеглОтчетИсполнениеКонтрактовГОЗИзГруппыОтчетностьПрочая";
		Обработчик.ОбщиеДанные = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьПоАлкогольнойПродукции") Тогда
			
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.11";
		Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияДекларацийПоАлкоголю4кв2019";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7780-a06b-c1980bebebbf");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.11";
		Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияДекларацийПоАлкоголю4кв2019";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7781-a06b-c1980bebebbf");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
				
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьВБанки") Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.26";
		Обработчик.Процедура = "РегистрыСведений.НастройкиОтправкиОтчетностиВБанк.ИзменитьРасписаниеОтправкиНаЕжедневное";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("15d1146a-c3a0-4714-98ab-333e56595a5d");
		Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение расписания автоматической отправки финансовой отчетности в Сбербанк'");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ОтчетностьПоАлкогольнойПродукции") Тогда
			
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.76";
		Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИзменитьОписаниеДекларацийПоФСРАР2021кв1";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7783-a06b-c1980bebebbf");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
			
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.76";
		Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияДекларацийПоФСРАР2021кв1";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7784-a06b-c1980bebebbf");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.76";
		Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияДекларацийПоФСРАР2021кв1";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("559a5d02-e3cd-7785-a06b-c1980bebebbf");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
				
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.СообщенияВКонтролирующиеОрганы") Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.1.150";
		Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнениеТребованийОснований";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("1cf7efc7-61c0-4908-b160-14f5b4b97dde");
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Комментарий = НСтр("ru = 'Заполняет требования-основания уведомлений.'");
	КонецЕсли;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ПриДобавленииОбработчиковОбновления(Обработчики);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.СообщенияВКонтролирующиеОрганы") Тогда
		МодульЕдиныйНалоговыйСчетИнтеграция = ОбщегоНазначения.ОбщийМодуль("ЕдиныйНалоговыйСчетИнтеграция");
		МодульЕдиныйНалоговыйСчетИнтеграция.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	
КонецПроцедуры

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	// Не используется в БРО.
	
КонецПроцедуры

// Заполняет обработчик разделенных данных, зависимый от изменения неразделенных данных (Обработчик.Версия = "*" поддерживается).
//
// Параметры:
//   Параметры - ТаблицаЗначений, Неопределено - см. описание 
//    функции НоваяТаблицаОбработчиковОбновления общего модуля 
//    ОбновлениеИнформационнойБазы.
//    В случае прямого вызова (не через механизм обновления 
//    версии ИБ) передается Неопределено.
// 
Процедура ЗаполнитьОбработчикиРазделенныхДанных(Параметры = Неопределено) Экспорт
	
	Если Параметры <> Неопределено Тогда
		Обработчики = Параметры.РазделенныеОбработчики;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.Процедура = "РегламентированнаяОтчетность.ВыполнитьОбновлениеИнформационнойБазы";
		
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ДобавитьОбработчикиОбновленияОблачнойПодписи(Обработчики, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
