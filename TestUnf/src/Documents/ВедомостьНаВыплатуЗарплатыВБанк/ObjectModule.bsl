#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Документы.ВедомостьНаВыплатуЗарплатыВБанк.ЭтоДанныеЗаполненияНезачисленнымиСтроками(ДанныеЗаполнения) Тогда
		ЗаполнитьНезачисленнымиСтроками(ДанныеЗаполнения)
	КонецЕсли
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Состав.СпособЗачисления");
		
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплаты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
	ОбменСБанкамиПоЗарплатнымПроектам.ВедомостьНаВыплатуЗарплатыВБанкПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектам.ВедомостьНаВыплатуЗарплатыВБанкПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	НомерРеестра = 0;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак изменения данных, влияющих на формирование электронного документа.
// 
Функция ИзменилисьКлючевыеРеквизитыЭлектронногоДокумента() Экспорт
	
	ИзменилисьКлючевыеРеквизиты = 
		ЭлектронноеВзаимодействиеБЗК.ИзменилисьРеквизитыОбъекта(ЭтотОбъект, "Дата, Номер, Организация, ЗарплатныйПроект, НомерРеестра, ПометкаУдаления")	
		Или ЭлектронноеВзаимодействиеБЗК.ИзмениласьТабличнаяЧастьОбъекта(ЭтотОбъект, "Зарплата", "Сотрудник, КВыплате, НомерЛицевогоСчета");
		
	Возврат ИзменилисьКлючевыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:299-выкл Используемость методов внутреннего API ведомостей не контролируется

#Область СценарииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.МожноЗаполнитьЗарплату(ЭтотОбъект);
КонецФункции

#КонецОбласти

#Область МестоВыплаты

Функция МестоВыплаты() Экспорт
	МестоВыплаты = ВедомостьНаВыплатуЗарплаты.МестоВыплаты();
	МестоВыплаты.Вид      = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект;
	МестоВыплаты.Значение = ЗарплатныйПроект;
	Возврат МестоВыплаты
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	ЗарплатныйПроект = Значение
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокумента

Процедура ОчиститьВыплаты() Экспорт
	ВедомостьНаВыплатуЗарплаты.ОчиститьВыплаты(ЭтотОбъект);
КонецПроцедуры	

Процедура ЗагрузитьВыплаты(Зарплата, НДФЛ) Экспорт
	ДополнитьТаблицуЗарплатСпособамиВыплаты(Зарплата);
	КолонкиДляЗачисления = Новый Массив;
	Для Каждого Реквизит Из РеквизитыПоСпособуЗачисления() Цикл
		КолонкиДляЗачисления.Добавить(Реквизит.Имя);
	КонецЦикла;
	КлючевыеПоляСостава = СтрСоединить(КолонкиДляЗачисления, ",");
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ, "ФизическоеЛицо," + КлючевыеПоляСостава);
	ВедомостьНаВыплатуЗарплаты.УстановитьВзыскания(ЭтотОбъект, Зарплата);
КонецПроцедуры

Процедура ДобавитьВыплаты(Зарплата, НДФЛ) Экспорт
	ДополнитьТаблицуЗарплатСпособамиВыплаты(Зарплата);
	КолонкиДляЗачисления = Новый Массив;
	Для Каждого Реквизит Из РеквизитыПоСпособуЗачисления() Цикл
		КолонкиДляЗачисления.Добавить(Реквизит.Имя);
	КонецЦикла;
	КлючевыеПоляСостава = СтрСоединить(КолонкиДляЗачисления, ",");
	ВедомостьНаВыплатуЗарплаты.ДобавитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ, "ФизическоеЛицо,"+КлючевыеПоляСостава);
	ВедомостьНаВыплатуЗарплаты.УстановитьВзыскания(ЭтотОбъект, Зарплата);
КонецПроцедуры

Процедура УстановитьНДФЛ(НДФЛ, Знач ФизическиеЛица = Неопределено) Экспорт
	ВедомостьНаВыплатуЗарплаты.УстановитьНДФЛ(ЭтотОбъект, НДФЛ, ФизическиеЛица)
КонецПроцедуры

#КонецОбласти

// АПК:299-вкл

// Заполняет документ на основании существующего,
// перенося в документ зарплату и налоги указанных физических лиц.
// 
// Параметры:
//	ДанныеЗаполнения - Структура - см. ВедомостьНаВыплатуЗарплатыВБанк.ДанныеЗаполненияНезачисленнымиСтроками().
//
Процедура ЗаполнитьНезачисленнымиСтроками(ДанныеЗаполнения)
	
	Реквизиты = Новый Массив;
	Для Каждого Реквизит Из ДанныеЗаполнения.Ведомость.Метаданные().Реквизиты Цикл
		Реквизиты.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Шапка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения.Ведомость, Реквизиты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка, , "НомерРеестра");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ведомость.Ссылка);
	Запрос.УстановитьПараметр("Физлица", ДанныеЗаполнения.Физлица);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьЗарплата.Сотрудник КАК Сотрудник,
	|	ВедомостьЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьЗарплата.Подразделение КАК Подразделение,
	|	ВедомостьЗарплата.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	ВедомостьЗарплата.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ВедомостьЗарплата.СтатьяРасходов КАК СтатьяРасходов,
	|	ВедомостьЗарплата.ДокументОснование КАК ДокументОснование,
	|	ВедомостьЗарплата.КВыплате КАК КВыплате,
	|	ВедомостьЗарплата.КомпенсацияЗаЗадержкуЗарплаты КАК КомпенсацияЗаЗадержкуЗарплаты,
	|	ВедомостьЗарплата.НомерЛицевогоСчета КАК НомерЛицевогоСчета
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьЗарплата
	|ГДЕ
	|	ВедомостьЗарплата.Ссылка = &Ссылка
	|	И ВедомостьЗарплата.ФизическоеЛицо В(&Физлица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВедомостьНДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьНДФЛ.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	ВедомостьНДФЛ.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ВедомостьНДФЛ.КодДохода КАК КодДохода,
	|	ВедомостьНДФЛ.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ВедомостьНДФЛ.Подразделение КАК Подразделение,
	|	ВедомостьНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль КАК ВключатьВДекларациюПоНалогуНаПрибыль,
	|	ВедомостьНДФЛ.ДокументОснование КАК ДокументОснование,
	|	ВедомостьНДФЛ.Сумма КАК Сумма,
	|	ВедомостьНДФЛ.КатегорияДохода КАК КатегорияДохода
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.НДФЛ КАК ВедомостьНДФЛ
	|ГДЕ
	|	ВедомостьНДФЛ.Ссылка = &Ссылка
	|	И ВедомостьНДФЛ.ФизическоеЛицо В(&Физлица)";
	
	Незачисленное = Запрос.ВыполнитьПакет(); 
	НезачисленнаяЗарплата = Незачисленное[0].Выгрузить();
	НеудержанныйНДФЛ      = Незачисленное[1].Выгрузить();
	
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(
		ЭтотОбъект, 
		НезачисленнаяЗарплата, 
		НеудержанныйНДФЛ, 
		"ФизическоеЛицо, НомерЛицевогоСчета");
	
КонецПроцедуры

Процедура ДополнитьТаблицуЗарплатСпособамиВыплаты(ЗарплатаКВыплате)
	
	МетаданныеРеквизитов = РеквизитыПоСпособуЗачисления();
	
	ЗначенияПоУмолчанию 			= ЗначенияРеквизитовСоставаВедомостиПоУмолчанию();
	СоответствиеСпособаЗачисления	= СоответствиеСпособаЗачисленияКолонкеВедомостиВБанк();
	
	Для Каждого МетаданныеРеквизита Из МетаданныеРеквизитов Цикл
		ЗарплатаКВыплате.Колонки.Добавить(МетаданныеРеквизита.Имя, МетаданныеРеквизита.Тип);
	КонецЦикла;
	
	Для Каждого Строка Из ЗарплатаКВыплате Цикл
		Для Каждого МетаданныеРеквизита Из МетаданныеРеквизитов Цикл
			Строка[МетаданныеРеквизита.Имя] = ЗначенияПоУмолчанию[МетаданныеРеквизита.Имя];
		КонецЦикла
	КонецЦикла;
	
	СпособыЗачисленияПоЗарплатномуПроекту = ОбменСБанкамиПоЗарплатнымПроектам.НовоеСоответствиеСпособовЗачисления();
	
	ОбменСБанкамиПоЗарплатнымПроектам.УстановитьДоступностьСпособовЗачисленияПоЗарплатномуПроекту(
		СпособыЗачисленияПоЗарплатномуПроекту, ЗарплатныйПроект);

	СпособВыплатыСотрудника = ОбменСБанкамиПоЗарплатнымПроектам.СпособыВыплатыСотрудников(ЗарплатаКВыплате.ВыгрузитьКолонку("Сотрудник"), Истина, Организация, ЗарплатныйПроект);
	
	СпособВыплатыСотрудника.Индексы.Добавить("Сотрудник"); 
	
	Для Каждого СтрокаЗарплаты Из ЗарплатаКВыплате Цикл
		СтрокаЛС = СпособВыплатыСотрудника.Найти(СтрокаЗарплаты.Сотрудник, "Сотрудник");
		
		Если СтрокаЛС = Неопределено Тогда
			СтрокаЛС = СпособВыплатыСотрудника.Добавить();
		КонецЕсли;
		
		Если СпособыЗачисленияПоЗарплатномуПроекту[СтрокаЛС.СпособЗачисления] = Неопределено Тогда
			СтрокаЛС.СпособЗачисления = Перечисления.СпособыЗачисленияВыплат.ПоЛицевомуСчету;
		КонецЕсли;
		
		Для Каждого РеквизитЗачисления Из СоответствиеСпособаЗачисления[СтрокаЛС.СпособЗачисления] Цикл
			Если СпособВыплатыСотрудника.Колонки.Найти(РеквизитЗачисления.Имя) = Неопределено Тогда
				ЗаполнитьРеквизитИзДанных(СтрокаЗарплаты, РеквизитЗачисления.Имя, СтрокаЛС);
			Иначе
				СтрокаЗарплаты[РеквизитЗачисления.Имя] = СтрокаЛС[РеквизитЗачисления.Имя];
			КонецЕсли;
		КонецЦикла;
		
		СтрокаЗарплаты.СпособЗачисления = СтрокаЛС.СпособЗачисления;
	КонецЦикла;
	
КонецПроцедуры

Функция РеквизитыПоСпособуЗачисления()
	
	МетаданныеРеквизитов = Новый Массив;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МетаданныеРеквизитов, РеквизитыВедомостиВБанкДляЗачисленияПоЛицевомуСчету());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МетаданныеРеквизитов, РеквизитыВедомостиВБанкДляЗачисленияПоСНИЛС());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МетаданныеРеквизитов, РеквизитыВедомостиВБанкДляЗачисленияПоНомеруТелефона());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МетаданныеРеквизитов, РеквизитыВедомостиВБанкДляЗачисленияПоНомеруКарты());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МетаданныеРеквизитов, РеквизитыВедомостиВБанкДляЗачисленияПоНомеруСчетаВБанк());
	МетаданныеРеквизитов.Добавить(Метаданные().ТабличныеЧасти.Состав.Реквизиты.СпособЗачисления);
	
	Возврат МетаданныеРеквизитов;
	
КонецФункции

Процедура ЗаполнитьРеквизитИзДанных(СтрокаДляЗаполнения, НаименованиеКолонки, СтрокаДанных)
	
	Если НаименованиеКолонки = Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерТелефона.Имя
		Или НаименованиеКолонки = Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерТелефонаПредставление.Имя Тогда
		КонтактнаяИнформация = Новый ТаблицаЗначений;
		Если ЗначениеЗаполнено(СтрокаДанных.Телефон) Тогда
			КонтактнаяИнформация = КонтактнаяИнформацияБЗК.КонтактнаяИнформацияОбъектов(
				СтрокаДанных.ФизическоеЛицо, 
				,
				СтрокаДанных.Телефон);
		КонецЕсли;
		Если КонтактнаяИнформация.Количество()> 0 Тогда
			СтрокаДляЗаполнения.НомерТелефонаПредставление = КонтактнаяИнформация[0].Представление;
			СтрокаДляЗаполнения.НомерТелефона = КонтактнаяИнформация[0].Значение
		КонецЕсли;
	ИначеЕсли НаименованиеКолонки = Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерБанковскойКарты.Имя Тогда
		СтрокаДляЗаполнения[НаименованиеКолонки] = БанковскиеКарты.МаскированныйНомерКарты(СтрокаДанных.БанковскаяКарта);
	ИначеЕсли НаименованиеКолонки = Метаданные().ТабличныеЧасти.Состав.Реквизиты.СНИЛС.Имя Тогда
		ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаДанных.ФизическоеЛицо);
		КадровыеДанные = "СтраховойНомерПФР";
		ТЗКадровыеДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, ФизическоеЛицо, КадровыеДанные);
		СтрокаДляЗаполнения.СНИЛС = ТЗКадровыеДанныеФизическогоЛица[0].СтраховойНомерПФР;
	ИначеЕсли НаименованиеКолонки = Метаданные().ТабличныеЧасти.Состав.Реквизиты.БИКБанкаСчета.Имя Тогда
		РеквизитыСчета = Неопределено;
		ВедомостьНаВыплатуЗарплаты.ПриИзмененииБанковскогоСчета(СтрокаДанных.БанковскийСчет, РеквизитыСчета);
		СтрокаДляЗаполнения.НомерЛицевогоСчета = РеквизитыСчета.НомерСчета;
		СтрокаДляЗаполнения.БИКБанкаСчета = РеквизитыСчета.БИК;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗначенияРеквизитовСоставаВедомостиПоУмолчанию()
	
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("НомерЛицевогоСчета", "");
	ЗначенияПоУмолчанию.Вставить("БанковскаяКарта", Справочники.БанковскиеКартыКонтрагентов.ПустаяСсылка());
	ЗначенияПоУмолчанию.Вставить("НомерБанковскойКарты", "");
	ЗначенияПоУмолчанию.Вставить("БИКБанкаСчета", "");
	ЗначенияПоУмолчанию.Вставить("БанковскийСчет", Неопределено);
	ЗначенияПоУмолчанию.Вставить("СНИЛС","");
	ЗначенияПоУмолчанию.Вставить("Телефон", Справочники.ВидыКонтактнойИнформации.ПустаяСсылка());
	ЗначенияПоУмолчанию.Вставить("НомерТелефонаПредставление", "");
	ЗначенияПоУмолчанию.Вставить("НомерТелефона", "");
	ЗначенияПоУмолчанию.Вставить("СпособЗачисления", Перечисления.СпособыЗачисленияВыплат.ПоЛицевомуСчету);
	
	Возврат ЗначенияПоУмолчанию;
	
КонецФункции

Функция СоответствиеСпособаЗачисленияКолонкеВедомостиВБанк()
	
	СоответствиеСпособаЗачисления = Новый Соответствие;

	СоответствиеСпособаЗачисления.Вставить(
		Перечисления.СпособыЗачисленияВыплат.ПоЛицевомуСчету, 
		РеквизитыВедомостиВБанкДляЗачисленияПоЛицевомуСчету());
		
	СоответствиеСпособаЗачисления.Вставить(
		Перечисления.СпособыЗачисленияВыплат.ПустаяСсылка(),
		РеквизитыВедомостиВБанкДляЗачисленияПоЛицевомуСчету());
		
	СоответствиеСпособаЗачисления.Вставить(
		Неопределено,
		РеквизитыВедомостиВБанкДляЗачисленияПоЛицевомуСчету());
	
	СоответствиеСпособаЗачисления.Вставить(
		Перечисления.СпособыЗачисленияВыплат.ПоСНИЛС, 
		РеквизитыВедомостиВБанкДляЗачисленияПоСНИЛС());
		
	СоответствиеСпособаЗачисления.Вставить(
		Перечисления.СпособыЗачисленияВыплат.ПоНомеруТелефона, 
		РеквизитыВедомостиВБанкДляЗачисленияПоНомеруТелефона());
		
	СоответствиеСпособаЗачисления.Вставить(
		Перечисления.СпособыЗачисленияВыплат.ПоНомеруКарты, 
		РеквизитыВедомостиВБанкДляЗачисленияПоНомеруКарты());
		
	СоответствиеСпособаЗачисления.Вставить(
		Перечисления.СпособыЗачисленияВыплат.ПоНомеруСчетаВБанк, 
		РеквизитыВедомостиВБанкДляЗачисленияПоНомеруСчетаВБанк());
		
	Возврат СоответствиеСпособаЗачисления;
	
КонецФункции

Функция РеквизитыВедомостиВБанкДляЗачисленияПоЛицевомуСчету()
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерЛицевогоСчета);
	
КонецФункции

Функция РеквизитыВедомостиВБанкДляЗачисленияПоСНИЛС()

	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Метаданные().ТабличныеЧасти.Состав.Реквизиты.СНИЛС);
	
КонецФункции

Функция РеквизитыВедомостиВБанкДляЗачисленияПоНомеруКарты()

	Возврат ОбщегоНазначенияКлиентСервер.МассивЗначений(Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерБанковскойКарты,
														Метаданные().ТабличныеЧасти.Состав.Реквизиты.БанковскаяКарта);
	
КонецФункции

Функция РеквизитыВедомостиВБанкДляЗачисленияПоНомеруСчетаВБанк()

	Возврат ОбщегоНазначенияКлиентСервер.МассивЗначений(Метаданные().ТабличныеЧасти.Состав.Реквизиты.БанковскийСчет,
														Метаданные().ТабличныеЧасти.Состав.Реквизиты.БИКБанкаСчета);
	
КонецФункции

Функция РеквизитыВедомостиВБанкДляЗачисленияПоНомеруТелефона()

	Возврат ОбщегоНазначенияКлиентСервер.МассивЗначений(Метаданные().ТабличныеЧасти.Состав.Реквизиты.Телефон,
														Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерТелефона,
														Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерТелефонаПредставление);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли