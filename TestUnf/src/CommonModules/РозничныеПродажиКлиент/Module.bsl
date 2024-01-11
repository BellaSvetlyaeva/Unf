#Область ПрограммныйИнтерфейс

// Добавить оплату
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - .
// 	ВидОплаты - Строка
// 	ЭтоФормаОплатыРМК - Булево - .
Процедура ДобавитьОплату(Форма, ВидОплаты, ЭтоФормаОплатыРМК = Ложь) Экспорт
	
	Объект = Форма.Объект;
	
	ДопПараметры = Новый Структура("ВидОплатыСтр", ВидОплаты);
	//@skip-warning
	Оповещение = Новый ОписаниеОповещения("ДобавитьОплатуЗавершение", Форма, ДопПараметры);
	СтруктураПараметров = Новый Структура();
	
	Если ЭтоФормаОплатыРМК Тогда
		СтруктураПараметров.Вставить("КОплате", Форма.СуммаДокумента
											- Форма.ПолученоНаличными
											- Форма.ВременнаяТаблицаКарт.Итог("Сумма"));
		СтруктураПараметров.Вставить("Сумма", СтруктураПараметров.КОплате);
	Иначе
		СтруктураПараметров.Вставить("КОплате", Объект.СуммаДокумента
											- Объект.ПолученоНаличными
											- Объект.БезналичнаяОплата.Итог("Сумма"));
	КонецЕсли;
	СтруктураПараметров.Вставить("КассаККМ", Объект.КассаККМ);
	СтруктураПараметров.Вставить("Документ", Объект);
	
	Если ВидОплаты = "Сертификат" Тогда
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаОплатыСертификатом", СтруктураПараметров, Форма, , , ,
			Оповещение);
		
	ИначеЕсли ВидОплаты = "Карта" Тогда
		ОткрытьФорму("Справочник.СпособыОплаты.Форма.ФормаОплатыКартой", СтруктураПараметров, Форма, , , ,
			Оповещение);
		
	ИначеЕсли ВидОплаты = "Бонусы" Тогда
		Если Не ЗначениеЗаполнено(Объект.ДисконтнаяКарта) Тогда
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Оповещение", Оповещение);
			ДополнительныеПараметры.Вставить("СтруктураПараметров", СтруктураПараметров);
			//@skip-warning
			ОповещениеКарты = Новый ОписаниеОповещения("СчитатьДисконтнуюКартуИДобавитьОплатуЗавершение", Форма,
				ДополнительныеПараметры);
			ОткрытьФорму("Справочник.ДисконтныеКарты.Форма.СчитываниеДисконтнойКарты", , Форма, , , , ОповещениеКарты,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ОткрытьФорму("Справочник.ДисконтныеКарты.Форма.ФормаОплатыБонусами", СтруктураПараметров, Форма, , , ,
				Оповещение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Напечатать товарный чек
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - .
// 	СсылкаНаЧек - Неопределено - .
// 	ИмяЭлементаСписок - Строка - .
Процедура НапечататьТоварныйЧек(Форма, СсылкаНаЧек = Неопределено, ИмяЭлементаСписок = "Список") Экспорт
	
	МассивЧековККМ = Новый Массив;
	МассивЧековККМНаВозврат = Новый Массив;
	ЕстьОтчетыОРозничныхПродажах = Ложь;
	
	Если СсылкаНаЧек = Неопределено Тогда
		Для Каждого СтрокаСписка Из Форма.Элементы[ИмяЭлементаСписок].ВыделенныеСтроки Цикл
			Если СтрокаСписка <> Неопределено Тогда
				Если ТипЗнч(СтрокаСписка) = Тип("ДокументСсылка.ЧекККМ") Тогда
					МассивЧековККМ.Добавить(СтрокаСписка);
				ИначеЕсли ТипЗнч(СтрокаСписка) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда
					МассивЧековККМНаВозврат.Добавить(СтрокаСписка);
				Иначе
					ЕстьОтчетыОРозничныхПродажах = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		МассивЧековККМ.Добавить(СсылкаНаЧек);
	КонецЕсли;
	
	Если ЕстьОтчетыОРозничныхПродажах Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Для отчетов о розничных продажах товарный чек не формируется.'");
		Сообщение.Поле = ИмяЭлементаСписок;
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если МассивЧековККМ.Количество() > 0 Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ЧекККМ", "ТоварныйЧек", МассивЧековККМ, Форма);
		
	КонецЕсли;
	
	Если МассивЧековККМНаВозврат.Количество() > 0 Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ЧекККМВозврат", "ТоварныйЧек", МассивЧековККМНаВозврат,
			Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик выбора дисконтной карты, начало.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - .
//  ДисконтнаяКарта - СправочникСсылка.ДисконтныеКарты - .
// Возвращаемое значение:
//  Булево - выбрана дисконтная карта
Функция ВыбранаДисконтнаяКарта(Форма, ДисконтнаяКарта) Экспорт
	
	БылИзмененКонтрагент = Ложь;
	ПоказатьСообщениеСчитанаДисконтнаяКарта = Истина;
	Если Не ЗначениеЗаполнено(ДисконтнаяКарта) Тогда
		ПоказатьСообщениеСчитанаДисконтнаяКарта = Ложь;
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Дисконтная карта в документе очищена'"),
			,
			НСтр("ru = 'Дисконтная карта не предъявлена'"),
			БиблиотекаКартинок.Информация32);
	ИначеЕсли Форма.ЕстьИменныеВидыДисконтныхКарт Тогда
		ВладелецДисконтнойКарты = УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(ДисконтнаяКарта,
			"ВладелецКарты");
		Если Форма.Объект.Контрагент.Пустая() И Не ВладелецДисконтнойКарты.Пустая() Тогда
			
			ПоказатьСообщениеСчитанаДисконтнаяКарта = Ложь;
			Форма.Объект.Контрагент = ВладелецДисконтнойКарты;
			БылИзмененКонтрагент = Истина;
			
			ПоказатьОповещениеПользователя(НСтр("ru = 'Заполнен контрагент и считана дисконтная карта'"),
				ПолучитьНавигационнуюСсылку(ДисконтнаяКарта), СтрШаблон(НСтр(
				"ru = 'В документе заполнен контрагент и считана дисконтная карта %1'"), ДисконтнаяКарта),
				БиблиотекаКартинок.Информация32);
				
		ИначеЕсли Форма.ЕстьИменныеВидыДисконтныхКарт
			И Форма.Объект.Контрагент <> ВладелецДисконтнойКарты
			И Не ВладелецДисконтнойКарты.Пустая() Тогда
			
			ПоказатьСообщениеСчитанаДисконтнаяКарта = Ложь;
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
				"ru = 'Дисконтная карта не считана. Владелец дисконтной карты не совпадает с контрагентом в документе.'"), ,
				"Контрагент", "Объект");
			
			Возврат БылИзмененКонтрагент;
		КонецЕсли;
	КонецЕсли;
	
	Если ПоказатьСообщениеСчитанаДисконтнаяКарта Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Считана дисконтная карта'"),
			ПолучитьНавигационнуюСсылку(ДисконтнаяКарта),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Считана дисконтная карта %1'"), ДисконтнаяКарта),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	Возврат БылИзмененКонтрагент;
	
КонецФункции

// Редактировать оплату
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - .
// 	ЭтоРМК_МК - Булево - .
Процедура РедактироватьОплату(Форма, ЭтоРМК_МК = Ложь) Экспорт
	
	//@skip-warning
	Оповещение = Новый ОписаниеОповещения("РедактироватьОплатуЗавершение", Форма);
	СтруктураПараметров = Новый Структура();
	Если ЭтоРМК_МК Тогда
		СтруктураПараметров.Вставить("КОплате", Форма.СуммаДокумента
											- Форма.ПолученоНаличными
											- Форма.ВременнаяТаблицаКарт.Итог("Сумма")
											+ Форма.Элементы.ВременнаяТаблицаКарт.ТекущиеДанные.Сумма
											+ Форма.Элементы.ВременнаяТаблицаКарт.ТекущиеДанные.СуммаБонусов);
	ИначеЕсли СтрНайти(Форма.ИмяФормы, "Возврат") >0 Тогда
		СтруктураПараметров.Вставить("ВозвратОплаты", Истина);
		СтруктураПараметров.Вставить("КОплате", Форма.Объект.СуммаДокумента
											- Форма.Объект.БезналичнаяОплата.Итог("Сумма")
											+ Форма.Элементы.БезналичнаяОплата.ТекущиеДанные.Сумма);
	Иначе
		СтруктураПараметров.Вставить("КОплате", Форма.Объект.СуммаДокумента
											- Форма.Объект.ПолученоНаличными
											- Форма.Объект.БезналичнаяОплата.Итог("Сумма")
											+ Форма.Элементы.БезналичнаяОплата.ТекущиеДанные.Сумма
											+ Форма.Элементы.БезналичнаяОплата.ТекущиеДанные.СуммаБонусов);
	КонецЕсли;
	СтруктураПараметров.Вставить("КассаККМ", Форма.Объект.КассаККМ);
	СтруктураПараметров.Вставить("ЭквайринговыйТерминал");
	СтруктураПараметров.Вставить("ВидПлатежнойКарты");
	СтруктураПараметров.Вставить("НомерПлатежнойКарты");
	СтруктураПараметров.Вставить("СсылочныйНомер");
	СтруктураПараметров.Вставить("НомерЧекаЭТ");
	СтруктураПараметров.Вставить("ПодарочныйСертификат");
	СтруктураПараметров.Вставить("НомерСертификата");
	СтруктураПараметров.Вставить("БонуснаяКарта");
	СтруктураПараметров.Вставить("Сумма");
	СтруктураПараметров.Вставить("СуммаБонусов");
	СтруктураПараметров.Вставить("Документ", Форма.Объект);
	СтруктураПараметров.Вставить("РедактироватьОплату", Истина);
	
	Если ЭтоРМК_МК Тогда
		ЭлементыБезналичнаяОплата = Форма.Элементы.ВременнаяТаблицаКарт;
	Иначе
		ЭлементыБезналичнаяОплата = Форма.Элементы.БезналичнаяОплата;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭлементыБезналичнаяОплата.ТекущиеДанные);
	
	Если ЭлементыБезналичнаяОплата.ТекущиеДанные.ВидОплаты = ПредопределенноеЗначение(
		"Перечисление.ВидыБезналичныхОплат.ПодарочныйСертификат") Тогда
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаОплатыСертификатом", СтруктураПараметров, Форма, , , ,
			Оповещение);
	ИначеЕсли ЭлементыБезналичнаяОплата.ТекущиеДанные.ВидОплаты = ПредопределенноеЗначение(
		"Перечисление.ВидыБезналичныхОплат.БанковскаяКарта") Тогда
		ОткрытьФорму("Справочник.СпособыОплаты.Форма.ФормаОплатыКартой", СтруктураПараметров, Форма, , , ,
			Оповещение);
	ИначеЕсли ЭлементыБезналичнаяОплата.ТекущиеДанные.ВидОплаты = ПредопределенноеЗначение(
		"Перечисление.ВидыБезналичныхОплат.Бонусы") Тогда
		Если НЕ ЭтоРМК_МК Тогда
			ОтборСтрок = Новый Структура("ВидОплаты", ПредопределенноеЗначение("Перечисление.ВидыБезналичныхОплат.Бонусы"));
			СтрокиБезОплатыБонусами = Форма.Объект.БезналичнаяОплата.НайтиСтроки(ОтборСтрок);
			ПредоплатаБезОплатыБонусами = Форма.Объект.Предоплата.Итог("СуммаРасчетов");
			Для Каждого СтрокаОплаты Из СтрокиБезОплатыБонусами Цикл
				ПредоплатаБезОплатыБонусами = ПредоплатаБезОплатыБонусами + СтрокаОплаты.Сумма; 
			КонецЦикла;
			СуммаОплатыБонусами = Форма.Объект.Запасы.Итог("СуммаСкидкиОплатыБонусом");
			ИтогВсего = Форма.Объект.Запасы.Итог("Всего");
			СтруктураПараметров.Вставить("КОплате", ИтогВсего + СуммаОплатыБонусами - ПредоплатаБезОплатыБонусами);
			СтруктураПараметров.Вставить("СуммаБонусов", СуммаОплатыБонусами);
		КонецЕсли;
		ОткрытьФорму("Справочник.ДисконтныеКарты.Форма.ФормаОплатыБонусами", СтруктураПараметров, Форма, , , ,
			Оповещение);
	ИначеЕсли ЭлементыБезналичнаяОплата.ТекущиеДанные.ВидОплаты = ПредопределенноеЗначение(
		"Перечисление.ВидыБезналичныхОплат.Кредит") Тогда
		ОткрытьФорму("Справочник.СпособыОплаты.Форма.ФормаОплатыКредитом", СтруктураПараметров, Форма, , , ,
			Оповещение);
	КонецЕсли;
	
КонецПроцедуры

// Проверить возможность удаления оплаты
// 
// Параметры:
// 	Элемент - ЭлементыФормы - .
// 	Отказ - Булево - .
Процедура ПроверитьВозможностьУдаленияОплаты(Элемент, Отказ) Экспорт
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.НомерЧекаЭТ) Тогда
		
		Отказ = Истина;
			
		СтрокаСообщения = НСтр("ru = 'Данные об оплате отправлены в банк.'") + Символы.ПС;
		СтрокаСообщения = СтрокаСообщения + НСтр("ru = 'Необходимо отменить операцию.'"); 
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрокаСообщения);
			
	ИначеЕсли ТекущиеДанные.ВидОплаты = ПредопределенноеЗначение("Перечисление.ВидыБезналичныхОплат.СБП")
			И ЗначениеЗаполнено(ТекущиеДанные.СсылочныйНомер) Тогда
		
		Отказ = Истина;
			
		СтрокаСообщения = НСтр("ru = 'Данные об оплате отправлены в платежную систему банка.'") + Символы.ПС;
		СтрокаСообщения = СтрокаСообщения + НСтр("ru = 'Необходимо отменить операцию.'"); 
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрокаСообщения);
			
	КонецЕсли;
	
КонецПроцедуры

// Рассчитывает сумму в строке табличной части
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - .
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура - .
//  ПараметрыРасчета - Структура - .
Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(Форма, СтрокаТабличнойЧасти = Неопределено,
	ПараметрыРасчета = Неопределено) Экспорт
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти = Форма.Элементы.Запасы.ТекущиеДанные;
	КонецЕсли;
	
	Если ПараметрыРасчета=Неопределено Тогда
		ПараметрыРасчета = Новый Структура("СброситьФлагСкидкиРассчитаны",Истина);
	КонецЕсли;	
	ПараметрыРасчета.Вставить("СуммаВключаетНДС", Форма.Объект.СуммаВключаетНДС);
	ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(СтрокаТабличнойЧасти, ПараметрыРасчета);
	
КонецПроцедуры

Процедура ПроверитьКодМаркировкиСредствамиККТ(ПараметрыЧекаККТ, ФормаВладелец, ЗаголовокКнопкиИгнорировать = Неопределено, ОповещениеОЗавершении, ФормаПросмотра = Неопределено) Экспорт
	
	ПозицииЧека = ПараметрыЧекаККТ.ПозицииЧека;
	КассаККМ = ПараметрыЧекаККТ.КассаККМ;
	
	ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(ФормаВладелец);
	
	Если ФормаПросмотра <> Неопределено
		И МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ФормаПросмотра.ОборудованиеККТ) Тогда
		ПараметрыСканирования.Вставить("ТребуетсяПроверкаСредствамиККТ", Истина);
		ПараметрыСканирования.Вставить("ККТФФД12ИСМП"                  , ФормаПросмотра.ОборудованиеККТ);
	КонецЕсли;
	
	ИдентификаторУстройства = Неопределено;
	ПараметрыСканирования.Свойство("ИдентификаторУстройства", ИдентификаторУстройства);
	Если НЕ ЗначениеЗаполнено(ИдентификаторУстройства) И ПараметрыСканирования.Свойство("ТребуетсяПроверкаСредствамиККТ") Тогда
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
		ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
		
		Если МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства) Тогда
			ПараметрыСканирования.ТребуетсяПроверкаСредствамиККТ = Истина;
			ПараметрыСканирования.ККТФФД12ИСМП                   = ИдентификаторУстройства;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеДляПроверки = Новый Массив;
	РезультатРаспределенияШтрихкодов = Неопределено;
	Для Каждого ПозицияЧека Из ПозицииЧека Цикл
		ПозицияЧека.Свойство("РезультатРаспределенияШтрихкодов", РезультатРаспределенияШтрихкодов);
		Если РезультатРаспределенияШтрихкодов = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементДанныхДляПроверки = ШтрихкодированиеИСМПКлиент.НовыйЭлементПроверкиСредствамиККТПоДаннымРаспределения(
			РезультатРаспределенияШтрихкодов);
		
		ДанныеДляПроверки.Добавить(ЭлементДанныхДляПроверки);
		
	КонецЦикла;
	
	ПараметрыПроверкиКМСредствамиККТ = ШтрихкодированиеИСМПКлиент.ПараметрыНачалаПроверкиКодовМаркировкиСредствамиККТ();
	ПараметрыПроверкиКМСредствамиККТ.ОповещениеОЗавершении       = ОповещениеОЗавершении;
	ПараметрыПроверкиКМСредствамиККТ.ДанныеДляПроверки           = ДанныеДляПроверки;
	ПараметрыПроверкиКМСредствамиККТ.ПараметрыСканирования       = ПараметрыСканирования;
	ПараметрыПроверкиКМСредствамиККТ.ФормаОсновногоОбъекта       = ФормаВладелец;
	ПараметрыПроверкиКМСредствамиККТ.ФормаВспомогательная        = ФормаПросмотра;
	ПараметрыПроверкиКМСредствамиККТ.ЗаголовокКнопкиИгнорировать = ЗаголовокКнопкиИгнорировать;
	
	ДокументСсылка = ФормаВладелец.Объект.Ссылка;
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПоступлениеВКассу")
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РасходИзКассы")
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПоступлениеНаСчет")
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РасходСоСчета")
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОперацияПоПлатежнымКартам") Тогда
		
		ПараметрыПроверкиКМСредствамиККТ.ЭтоДокументОплаты = Истина;
	КонецЕсли;
	
	ШтрихкодированиеИСМПКлиент.НачатьПроверкуКодовМаркировкиСредствамиККТ(ПараметрыПроверкиКМСредствамиККТ);
	
КонецПроцедуры

#КонецОбласти
