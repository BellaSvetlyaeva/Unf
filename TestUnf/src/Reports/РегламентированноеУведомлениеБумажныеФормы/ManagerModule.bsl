#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "ФормаУведомления";
	Стр.ОписаниеФормы = "Печатный бланк в соответствии с приказом Министерства финансов РФ от 26.12.2018 № 286н";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтУплатыНДС;
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "ОсвобождениеОтУплатыНДС_501";
	Стр.ОписаниеФормы = "Электронное представление в формате 5.01";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтУплатыНДС;
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "ФормаУведомления";
	Стр.ОписаниеФормы = "Печатный бланк в соответствии с приказом Министерства финансов РФ от 26.12.2018 № 286н";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтНДСПриЕСХН;
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "ОсвобождениеОтНДСПриЕСХН_501";
	Стр.ОписаниеФормы = "Электронное представление в формате 5.01";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтНДСПриЕСХН;
	
	Для Каждого Элт Из ВидыУведомленийДляТиповойФормы() Цикл 
		Стр = Результат.Добавить();
		Стр.ИмяФормы = "ФормаУведомления";
		Стр.ОписаниеФормы = "Утверждено";
		Стр.ВидУведомления = Элт;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ВидыУведомленийДляТиповойФормы()
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПриемДокументовФСС);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозвратСуммыНВОС);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗачетСуммыНВОС);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление1НачалоУплаты);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление2ОтказОтУплаты);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОбработкаПерсональныхДанных);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИзменениеСведенийОбработкаПерсональныхДанных);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрекращениеОбработкиПерсональныхДанных);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозмещениеПроизводственныхРасходов);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрибытиеГражданинаРФ);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УбытиеИностранца);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрибытиеИностранца);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗачетСФР);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозвратСФР);
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "ОсвобождениеОтНДСПриЕСХН_501" Тогда 
		Возврат ЭлектронноеПредставление_ОсвобождениеОтНДСПриЕСХН_501(Объект, УникальныйИдентификатор);
	ИначеЕсли ИмяФормы = "ОсвобождениеОтУплатыНДС_501" Или ИмяФормы = "ФормаОсвобождениеНДС" Тогда
		Возврат ЭлектронноеПредставление_ОсвобождениеОтУплатыНДС_501(Объект, УникальныйИдентификатор);
	Иначе
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении(
			"Для данного заявления выгрузка не предусмотрена", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
КонецФункции

Функция ПолучитьИмяПечатнойФормы(Объект)
	ВидУведомления = Объект.ВидУведомления;
	Если ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОбработкаПерсональныхДанных Тогда
		Данные = Объект.ДанныеУведомления.Получить();
		ИмяЭкраннойФормы = "";
		Данные.Свойство("ИмяЭкраннойФормы", ИмяЭкраннойФормы);
		Если ИмяЭкраннойФормы = "Форма_ОбработкаПерсональныхДанных_2023" Тогда 
			Возврат "Печать_MXL_Форма_ОбработкаПерсональныхДанных_2023";
		Иначе
			Возврат "Печать_MXL_Форма_ОбработкаПерсональныхДанных";
		КонецЕсли;
	Иначе
		Возврат СоответствиеПечатнойФормыПоВиду()[ВидУведомления];
	КонецЕсли;
КонецФункции

Функция СоответствиеПечатнойФормыПоВиду()
	Результат = Новый Соответствие;
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтУплатыНДС, "Печать_MXL_Форма_ОсвобождениеОтУплатыНДС");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗачетСуммыНВОС, "Печать_MXL_Форма_ЗачетСуммыНВОС");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозвратСуммыНВОС, "Печать_MXL_Форма_ВозвратСуммыНВОС");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПриемДокументовФСС, "Печать_MXL_Форма_ЗаявлениеНаПриемДокументовФСС");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление1НачалоУплаты, "Печать_MXL_Форма_Уведомление1НачалоУплаты");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление2ОтказОтУплаты, "Печать_MXL_Форма_Уведомление2ОтказОтУплаты");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОсвобождениеОтНДСПриЕСХН, "Печать_MXL_Форма_ОсвобождениеОтНДСПриЕСХН");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрибытиеГражданинаРФ, "Печать_MXL_ПрибытиеГражданинаРФ");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УбытиеИностранца, "Печать_MXL_УбытиеИностранца");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрибытиеИностранца, "Печать_MXL_ПрибытиеИностранца");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗачетСФР, "Печать_MXL_ЗачетСФР");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозвратСФР, "Печать_MXL_ВозвратСФР");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ИзменениеСведенийОбработкаПерсональныхДанных, "Печать_MXL_ИзменениеСведенийОбработкаПерсональныхДанных");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрекращениеОбработкиПерсональныхДанных, "Печать_MXL_ПрекращениеОбработкиПерсональныхДанных");
	Результат.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВозмещениеПроизводственныхРасходов, "Печать_MXL_ВозмещениеПроизводственныхРасходов");
	Возврат Результат;
КонецФункции

Функция ПолучитьНазваниеОргана(Объект) Экспорт
	Если Объект.ИмяФормы = "ФормаУведомления" Тогда
		СтруктураПараметров = Объект.ДанныеУведомления.Получить();
		Титульный = СтруктураПараметров.Титульный[0];
		Возврат Титульный.Орган;
	КонецЕсли;
	Возврат "";
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "ФормаУведомления" Тогда
		Возврат СформироватьСписокЛистовФормаУведомления(Объект);
	ИначеЕсли Объект.ИмяФормы = "ФормаОсвобождениеНДС" Тогда
		Возврат СформироватьСписокЛистовФормаУведомленияОсвобождениеОтНДССДопСтраницами(Объект);
	ИначеЕсли Объект.ИмяФормы = "ОсвобождениеОтНДСПриЕСХН_501" Тогда
		Возврат СформироватьСписокЛистовФормаУведомленияОсвобождениеОтНДС_ЕСХН501(Объект);
	Иначе
		Возврат УведомлениеОСпецрежимахНалогообложения.ПечатьВСледующихВерсиях(Объект);
	КонецЕсли;
КонецФункции

Функция ПолучитьОриентациюСтраницы(ВидУведомления, НомерСтраницы)
	Возврат ОриентацияСтраницы.Портрет;
КонецФункции

Процедура ДополнитьПараметры_Уведомление1НачалоУплаты(Титульный)
	Для Каждого Стр Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ИНН,КПП,КодСубъекта,КПП1,КПП2,КПП3", ",") Цикл
		Если Титульный.Свойство(Стр) Тогда 
			Для Инд = 1 По СтрДлина(Титульный[Стр]) Цикл 
				Титульный.Вставить(Стр + "__" + Инд, Сред(Титульный[Стр], Инд, 1));
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ДополнитьПараметры_Уведомление2ОтказОтУплаты(Титульный)
	Для Каждого Стр Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ИНН,КПП,КодСубъекта,КПП1,КПП2", ",") Цикл
		Если Титульный.Свойство(Стр) Тогда 
			Для Инд = 1 По СтрДлина(Титульный[Стр]) Цикл 
				Титульный.Вставить(Стр + "__" + Инд, Сред(Титульный[Стр], Инд, 1));
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ДополнитьПараметры_ПрибытиеГражданинаРФ(Титульный)
	ДлПок19 = 70;
	Если СтрДлина(Титульный.ОсновныеСведения19) > ДлПок19 Тогда
		Инд = СтрНайти(Титульный.ОсновныеСведения19, " ", НаправлениеПоиска.СНачала, ДлПок19);
		Инд = ?(Инд = 0, ДлПок19, Инд);
		Титульный.Вставить("ОсновныеСведения19ч1", Лев(Титульный.ОсновныеСведения19, Инд));
		Титульный.Вставить("ОсновныеСведения19ч2", Сред(Титульный.ОсновныеСведения19, Инд + 1));
	Иначе
		Титульный.Вставить("ОсновныеСведения19ч1", Титульный.ОсновныеСведения19);
	КонецЕсли;
	
	ДлПок21 = 65;
	Если СтрДлина(Титульный.ОсновныеСведения21) > ДлПок21 Тогда
		Инд = СтрНайти(Титульный.ОсновныеСведения21, " ", НаправлениеПоиска.СНачала, ДлПок21);
		Инд = ?(Инд = 0, ДлПок21, Инд);
		Титульный.Вставить("ОсновныеСведения21ч1", Лев(Титульный.ОсновныеСведения21, Инд));
		Титульный.Вставить("ОсновныеСведения21ч2", Сред(Титульный.ОсновныеСведения21, Инд + 1));
	Иначе
		Титульный.Вставить("ОсновныеСведения21ч1", Титульный.ОсновныеСведения21);
	КонецЕсли;
КонецПроцедуры

Процедура ДополнитьПараметры_ПрибытиеИностранца(Титульный)
	СтрПарам = "Фамилия,Имя,Отчество,Гражданство,ДатаРождения,ПолМ,ПолЖ,МестоРождения,ВидДок,СерияДок,НомерДок"
		+ ",ДатаВыдачиДок,СрокДействияДок,Область,Район,Город,Улица,Дом,Корпус,Строение,Квартира";
	Если ЗначениеЗаполнено(Титульный.Флаг) Тогда 
		СтрПарам = СтрПарам + ",ФамилияПрин,ИмяПрин,ОтчествоПрин,НаимОрг,ИНН";
	КонецЕсли;
	Для Каждого Элт Из СтрРазделить(СтрПарам, ",") Цикл 
		Титульный.Вставить(Элт + "2", Титульный[Элт]);
	КонецЦикла;
КонецПроцедуры

Процедура ДополнитьПараметры(Титульный, ВидУведомления)
	Если ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление1НачалоУплаты Тогда
		ДополнитьПараметры_Уведомление1НачалоУплаты(Титульный);
	ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Уведомление2ОтказОтУплаты Тогда 
		ДополнитьПараметры_Уведомление2ОтказОтУплаты(Титульный);
	ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрибытиеГражданинаРФ Тогда 
		ДополнитьПараметры_ПрибытиеГражданинаРФ(Титульный);
	ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПрибытиеИностранца Тогда 
		ДополнитьПараметры_ПрибытиеИностранца(Титульный);
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФормаУведомления(Объект) Экспорт
	Листы = Новый СписокЗначений;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ПолучитьИмяПечатнойФормы(Объект));
	Титульный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить().Титульный;
	ДополнитьПараметры(Титульный, Объект.ВидУведомления);
	Инд = 0;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.ОриентацияСтраницы = ПолучитьОриентациюСтраницы(Объект.ВидУведомления, Инд);
	НомСтр = 1;
	Пока Истина Цикл 
		Инд = Инд + 1;
		Если МакетУведомления.Области.Найти("Часть" + Формат(Инд, "ЧГ=")) = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		ОбластьЧасть = МакетУведомления.ПолучитьОбласть("Часть" + Формат(Инд, "ЧГ="));
		ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, Титульный);
		
		Для Каждого КЗ Из Титульный Цикл
			Если ОбластьЧасть.Области.Найти(КЗ.Ключ + "_1") = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			Если ТипЗнч(КЗ.Значение) = Тип("Число") Тогда
				УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоНаПечать(КЗ.Значение, КЗ.Ключ, ОбластьЧасть.Области);
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
				УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, ОбластьЧасть.Области, " ");
			Иначе
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, ОбластьЧасть.Области);
			КонецЕсли;
		КонецЦикла;
		
		Если Не ПечатнаяФорма.ПроверитьВывод(ОбластьЧасть) И ПечатнаяФорма.ВысотаТаблицы > 0 Тогда 
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			НомСтр = НомСтр + 1;
			ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
			ПечатнаяФорма.ОриентацияСтраницы = ПолучитьОриентациюСтраницы(Объект.ВидУведомления, Инд);
		КонецЕсли;
		ПечатнаяФорма.Вывести(ОбластьЧасть);
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	Возврат Листы;
КонецФункции

Функция СформироватьСписокЛистовФормаУведомленияОсвобождениеОтНДССДопСтраницами(Объект) Экспорт
	Листы = Новый СписокЗначений;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма_ДополнительныеВыпискиНДС");
	СохраненныеДанные = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
	ДанныеУведомления = СохраненныеДанные.ДанныеУведомления;
	
	Титульный = ДанныеУведомления.Титульная;
	Инд = 0;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	НомСтр = 1;
	Пока Истина Цикл 
		Инд = Инд + 1;
		Если МакетУведомления.Области.Найти("Часть" + Формат(Инд, "ЧГ=")) = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		ОбластьЧасть = МакетУведомления.ПолучитьОбласть("Часть" + Формат(Инд, "ЧГ="));
		ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, Титульный);
		Если Не ПечатнаяФорма.ПроверитьВывод(ОбластьЧасть) Тогда 
			ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, "Лист " + НомСтр  + ". Уведомление");
			НомСтр = НомСтр + 1;
			ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
		КонецЕсли;
		ПечатнаяФорма.Вывести(ОбластьЧасть);
	КонецЦикла;
	ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, "Лист " + НомСтр  + ". Уведомление");
	
	ЛистДанные = Неопределено;
	Если ДанныеУведомления.Свойство("Лист2", ЛистДанные) Тогда 
		НомСтр = НомСтр + 1;
		ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
		ПечатнаяФорма.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
		
		Для Каждого Обл Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ШапкаКнигаПродаж,ЗаголовокЛист2,ОписаниеВыручкаКнигаПродаж,КнигаПродаж,ПодвалКнигаПродаж", ",") Цикл 
			ОбластьЧасть = МакетУведомления.ПолучитьОбласть(Обл);
			ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, ЛистДанные);
			Если Обл = "КнигаПродаж" Тогда 
				Для Каждого КЗ Из ЛистДанные Цикл 
					О = ОбластьЧасть.Области.Найти(КЗ.Ключ);
					Если О <> Неопределено 
						И О.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
						И О.СодержитЗначение = Истина Тогда 
						
						О.Значение = КЗ.Значение;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			ПечатнаяФорма.Вывести(ОбластьЧасть);
		КонецЦикла;
		
		Нумератор = 0;
		Для УО = 1 По 12 Цикл 
			Заполнено = Ложь;
			УОСтр = Формат(УО, "ЧЦ=2; ЧВН=");
			Для Гр = 3 По 12 Цикл 
				Заполнено = Заполнено Или ЗначениеЗаполнено(ЛистДанные["КнигаПродаж" + Формат(Гр, "ЧЦ=2; ЧВН=") + УОСтр]);
			КонецЦикла;
			
			Если Заполнено Тогда 
				Нумератор = Нумератор + 1;
				ПечатнаяФорма.Область("КнигаПродаж02" + УОСтр).Значение = Нумератор;
			Иначе
				Верх = ПечатнаяФорма.Область("КнигаПродаж03" + УОСтр).Верх;
				ПечатнаяФорма.УдалитьОбласть(ПечатнаяФорма.Область(Верх,,Верх), ТипСмещенияТабличногоДокумента.ПоВертикали);
			КонецЕсли;
		КонецЦикла;
		
		Верх = МакетУведомления.Область("ЗаголовокЛист2").Верх;
		ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, "Лист " + НомСтр  + ". " + МакетУведомления.Область(Верх, 2, Верх, 2).Текст);
	КонецЕсли;
	
	Для Инд = 3 По 5 Цикл
		Если Не ДанныеУведомления.Свойство("Лист" + Инд, ЛистДанные) Тогда 
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
		НомСтр = НомСтр + 1;
		Для Каждого Обл Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Шапка,ЗаголовокЛист" + Инд + ",ОписаниеВыручка,Выручка,Подвал", ",") Цикл 
			ОбластьЧасть = МакетУведомления.ПолучитьОбласть(Обл);
			ЗаполнитьЗначенияСвойств(ОбластьЧасть.Параметры, ЛистДанные);
			ПечатнаяФорма.Вывести(ОбластьЧасть);
		КонецЦикла;
		
		Для УО = 1 По 12 Цикл 
			Если Не ЗначениеЗаполнено(ПечатнаяФорма.Область("Период" + УО).Значение)
				И Не ЗначениеЗаполнено(ПечатнаяФорма.Область("Выручка" + УО).Значение) Тогда 
				
				Верх = ПечатнаяФорма.Область("Период" + УО).Верх;
				ПечатнаяФорма.УдалитьОбласть(ПечатнаяФорма.Область(Верх,,Верх+1), ТипСмещенияТабличногоДокумента.ПоВертикали);
			КонецЕсли;
		КонецЦикла;
		
		Верх = МакетУведомления.Область("ЗаголовокЛист" + Инд).Верх;
		ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, "Лист " + НомСтр  + ". " + МакетУведомления.Область(Верх, 2, Верх, 2).Текст);
	КонецЦикла;
	Возврат Листы;
КонецФункции

Функция СформироватьСписокЛистовФормаУведомленияОсвобождениеОтНДС_ЕСХН501(Объект) Экспорт
	Листы = Новый СписокЗначений;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма_ОсвобождениеОтНДСПриЕСХН");
	СохраненныеДанные = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
	Титульная = СохраненныеДанные.ДанныеУведомления.Титульная;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ОбластьЧасть1 = МакетУведомления.ПолучитьОбласть("Часть1");
	ОбластьЧасть1.Параметры.ИННКПП = Титульная.ИНН + ?(ЗначениеЗаполнено(Титульная.КПП), " / " + Титульная.КПП, "");
	ОбластьЧасть1.Параметры.НПЛ = Титульная.Наименование;
	ОбластьЧасть1.Параметры.НаименованиеНПЛ = Титульная.Наименование;
	ОбластьЧасть1.Параметры.НаименованиеНО = "ИФНС " + Титульная.КодНО;
	ОбластьЧасть1.Параметры.АддрТел1 = Титульная.Тлф;
	ОбластьЧасть1.Параметры.ДатаНачало = Титульная.ДатаНачИспОсв;
	ПечатнаяФорма.Вывести(ОбластьЧасть1);
	
	ОбластьЧасть2 = МакетУведомления.ПолучитьОбласть("Часть2");
	ОбластьЧасть2.Параметры.ВыручкаОтРеализации = Титульная.Сумма;
	ПечатнаяФорма.Вывести(ОбластьЧасть2);
	
	ОбластьЧасть3 = МакетУведомления.ПолучитьОбласть("Часть3");
	ОбластьЧасть3.Параметры.ДатаОт = Титульная.ДАТА_ПОДПИСИ;
	ПечатнаяФорма.Вывести(ОбластьЧасть3);
	
	ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, 1, "Уведомление");
	Возврат Листы;
КонецФункции

Процедура ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Название) Экспорт 
	Лист = Новый Массив;
	Лист.Добавить(ПоместитьВоВременноеХранилище(ПечатнаяФорма));
	Лист.Добавить(Новый УникальныйИдентификатор);
	Лист.Добавить(Название);
	Листы.Добавить(Лист, Название);
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "ОсвобождениеОтНДСПриЕСХН_501" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_ОсвобождениеОтНДСПриЕСХН_501(УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	ИначеЕсли ИмяФормы = "ОсвобождениеОтУплатыНДС_501" Или ИмяФормы = "ФормаОсвобождениеНДС" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_ОсвобождениеОтУплатыНДС_501(УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_ОсвобождениеОтНДСПриЕСХН_501(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаКодаНО(Титульная.КодНО, ТаблицаОшибок, "Титульная");
	
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан признак подписанта на титульной странице", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДатаНачИспОсв) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата начала использования права на освобождение", "Титульная", "ДатаНачИспОсв"));
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация)
		Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
			
		УведомлениеОСпецрежимахНалогообложения.ПроверкаПодписантаНалоговойОтчетности(Данные, ТаблицаОшибок, "Титульная", Истина);
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложения.ПроверкаИННКПП(
		РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация), Титульная, ТаблицаОшибок);
	
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	УведомлениеОСпецрежимахНалогообложения.ПолнаяПроверкаЗаполненныхПоказателейНаСоотвествиеСписку(
		"СпискиВыбора2020_Подписант", "СхемаВыгрузки_ОсвобождениеОтНДСПриЕСХН",
		Данные.Объект.ИмяОтчета, ТаблицаОшибок, Данные);
	Возврат ТаблицаОшибок;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_ОсвобождениеОтУплатыНДС_501(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		?(Данные.Объект.ИмяФормы = "ФормаОсвобождениеНДС", "ОсвобождениеОтУплатыНДС_501", Данные.Объект.ИмяФормы),
		ТаблицаОшибок, ПолучитьТаблицуФорм());
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаКодаНО(Титульная.КодНО, ТаблицаОшибок, "Титульная");
	
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан признак подписанта на титульной странице", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДатаНачИспОсв) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата начала использования права на освобождение", "Титульная", "ДатаНачИспОсв"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Дата1) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан год / месяц", "Титульная", "Дата1"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Дата2) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан год / месяц", "Титульная", "Дата2"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Дата3) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан год / месяц", "Титульная", "Дата3"));
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация)
		Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
			
		УведомлениеОСпецрежимахНалогообложения.ПроверкаПодписантаНалоговойОтчетности(Данные, ТаблицаОшибок, "Титульная", Истина);
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложения.ПроверкаИННКПП(
		РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация), Титульная, ТаблицаОшибок);
	
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	УведомлениеОСпецрежимахНалогообложения.ПолнаяПроверкаЗаполненныхПоказателейНаСоотвествиеСписку(
		"СпискиВыбора2020_Подписант", "СхемаВыгрузки_ОсвобождениеОтУплатыНДС",
		Данные.Объект.ИмяОтчета, ТаблицаОшибок, Данные);
	Возврат ТаблицаОшибок;
КонецФункции

Функция ЭлектронноеПредставление_ОсвобождениеОтНДСПриЕСХН_501(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_ОсвобождениеОтНДСПриЕСХН_501(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	ОсновныеСведения.Вставить("ИдФайл", 
		Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления("SR_PRAVOSVNDSESN", ОсновныеСведения));
	
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(
		Объект.ИмяОтчета, "СхемаВыгрузки_ОсвобождениеОтНДСПриЕСХН");
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Функция ЭлектронноеПредставление_ОсвобождениеОтУплатыНДС_501(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_ОсвобождениеОтУплатыНДС_501(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	ОсновныеСведения.Вставить("ИдФайл", 
		Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления("SR_PRAVOSVNDS", ОсновныеСведения));
	
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(
		Объект.ИмяОтчета, "СхемаВыгрузки_ОсвобождениеОтУплатыНДС");
	Титульная = ДанныеУведомления.ДанныеУведомления.Титульная;
	Титульная.Вставить("Месяц1", Формат(Титульная.Дата1, "ДФ=MM"));
	Титульная.Вставить("Год1", Формат(Титульная.Дата1, "ДФ=yyyy"));
	Титульная.Вставить("Месяц2", Формат(Титульная.Дата2, "ДФ=MM"));
	Титульная.Вставить("Год2", Формат(Титульная.Дата2, "ДФ=yyyy"));
	Титульная.Вставить("Месяц3", Формат(Титульная.Дата3, "ДФ=MM"));
	Титульная.Вставить("Год3", Формат(Титульная.Дата3, "ДФ=yyyy"));
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

#КонецОбласти
#КонецЕсли