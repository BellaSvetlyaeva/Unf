#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область БлокФункцийПервоначальногоЗаполненияИОбновленияИБ

// Процедура заполняет план видов расчета т.н. псевдопредопределенными элементами, 
// идентифицируемыми из кода.
//
Процедура СоздатьНачисленияПоНастройкам() Экспорт
	
	КодДоходаНДФЛ_2012 = ВидыДоходовНДФЛПоКоду("2012");
	КодДоходаНДФЛ_2300 = ВидыДоходовНДФЛПоКоду("2300");
	
	// Безусловно создаем оклад
	Описание = ОписаниеНачисления();
	Описание.Код 							= НСтр("ru = 'ОКЛ'");
	Описание.Наименование 					= НСтр("ru = 'Оплата по окладу'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда;
	Описание.ВидНачисленияДляНУ 			= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп1ст255;
	Описание.КодДоходаНДФЛ 					= Справочники.ВидыДоходовНДФЛ.КодДоходаПоУмолчанию;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы	 	= Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.КодДоходаСтраховыеВзносы2017 	= Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.ВходитВБазуРКИСН 				= Истина;
	ЗаписатьНачисление(Описание);
	
	// Отпуск по беременности и родам.
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'ОТБРР'");
	Описание.Наименование					= НСтр("ru = 'Отпуск по беременности и родам'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам;
	Описание.ВидНачисленияДляНУ				= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.ПустаяСсылка();
	Описание.КодДоходаНДФЛ 					= Справочники.ВидыДоходовНДФЛ.ПустаяСсылка();
	Описание.КодДоходаСтраховыеВзносы 		= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС;
	Описание.КодДоходаСтраховыеВзносы2017	= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС;
	ЗаписатьНачисление(Описание);
	
	// Больничный при травме на производстве.
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'БЛТП'");
	Описание.Наименование					= НСтр("ru = 'Больничный при травме на производстве'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве;
	Описание.ВидНачисленияДляНУ				= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.ПустаяСсылка();
	Описание.КодДоходаНДФЛ 					= КодДоходаНДФЛ_2300;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы 		= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС_НС;
	Описание.КодДоходаСтраховыеВзносы2017 	= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС_НС;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС;
	ЗаписатьНачисление(Описание);
	
	// Больничный при профзаболевании.
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'БЛПЗ'");
	Описание.Наименование					= НСтр("ru = 'Больничный при профзаболевании'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоПрофзаболевание;
	Описание.ВидНачисленияДляНУ 			= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.ПустаяСсылка();
	Описание.КодДоходаНДФЛ 					= КодДоходаНДФЛ_2300;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы	 	= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС_НС;
	Описание.КодДоходаСтраховыеВзносы2017 	= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС_НС;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС;
	ЗаписатьНачисление(Описание);
	
	// Больничный
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'БЛН'");
	Описание.Наименование					= НСтр("ru = 'Больничный'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста;
	Описание.ВидНачисленияДляНУ 			= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.ПустаяСсылка();
	Описание.КодДоходаНДФЛ 					= КодДоходаНДФЛ_2300;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы 		= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС;
	Описание.КодДоходаСтраховыеВзносы2017	= Справочники.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС;
	ЗаписатьНачисление(Описание);
	
	// Оплата больничных листов за счет работодателя.
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'БЛРДТ'");
	Описание.Наименование					= НСтр("ru = 'Больничный за счет работодателя'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя;
	Описание.ВидНачисленияДляНУ 			= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп48ст266;
	Описание.КодДоходаНДФЛ 					= КодДоходаНДФЛ_2300;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы 		= Справочники.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликом;
	Описание.КодДоходаСтраховыеВзносы2017	= Справочники.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликом;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюРаботодатель;
	ЗаписатьНачисление(Описание);
	
	// Оплата отпуска
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'ОТ'");
	Описание.Наименование					= НСтр("ru = 'Отпуск основной'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска;
	Описание.ВидНачисленияДляНУ 			= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп7ст255;
	Описание.КодДоходаНДФЛ 					= КодДоходаНДФЛ_2012;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы	 	= Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.КодДоходаСтраховыеВзносы2017 	= Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпуск;
	ЗаписатьНачисление(Описание);
	
	// Отсутствие по болезни
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'ОБ'");
	Описание.Наименование					= НСтр("ru = 'Отсутствие по болезни'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.БолезньБезОплаты;
	Описание.ВидНачисленияДляНУ				= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.ПустаяСсылка();
	Описание.КодДоходаНДФЛ					= Неопределено;
	Описание.КодДоходаСтраховыеВзносы		= Неопределено;
	Описание.КодДоходаСтраховыеВзносы2017	= Неопределено;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	ЗаписатьНачисление(Описание);
	
	СоздатьНачислениеОтпускБезОплаты();

	// Если используется РК и/или СН - создаем соответствующие виды начислений.
	СоздатьНачисленияРКиСН();
	
	// Премия годовая
	СоздатьГодовуюПремию();
	
КонецПроцедуры

Процедура СоздатьНачислениеОтпускБезОплаты() Экспорт
	
	// Оплата отпуска
	Описание = ОписаниеНачисления();
	Описание.Код          = НСтр("ru = 'ОТПОЗ'");
	Описание.Наименование = НСтр("ru = 'Отпуск без оплаты согласно ТК РФ'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускБезОплаты;
	
	НачисленияПоОписанию = НачисленияПоКатегории(Описание.КатегорияНачисленияИлиНеоплаченногоВремени);
	Если НачисленияПоОписанию.Количество() = 0 Тогда
		
		НачислениеОбъект = ПланыВидовРасчета.Начисления.СоздатьВидРасчета();
		ЗаполнитьЗначенияСвойств(НачислениеОбъект, Описание);
		НачислениеОбъект.КраткоеНаименование = НСтр("ru='Отп. без опл.'");
		НачислениеОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьНачисленияРКиСН() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВостребованностьРКиСН = РасчетЗарплаты.ВостребованностьРКиСН();
	
	// Районный коэффициент
	Описание = ОписаниеНачисления();
	Описание.Код = НСтр("ru = 'РК'");
	Описание.Наименование = НСтр("ru = 'Районный коэффициент'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.РайонныйКоэффициент;
	Описание.ВидНачисленияДляНУ = Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп11ст255;
	Описание.КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.КодДоходаПоУмолчанию;
	Описание.КатегорияДохода = УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы = Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.КодДоходаСтраховыеВзносы2017 = Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	
	Если ВостребованностьРКиСН.РайонныйКоэффициент Тогда
		ЗаписатьНачисление(Описание);
	Иначе
		ОтключитьИспользованиеНачисленийПоОписанию(Описание);
	КонецЕсли;
	
	// Северная надбавка
	Описание = ОписаниеНачисления();
	Описание.Код = НСтр("ru = 'СН'");
	Описание.Наименование = НСтр("ru = 'Северная надбавка'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СевернаяНадбавка;
	Описание.ВидНачисленияДляНУ = Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп12ст255;
	Описание.КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.КодДоходаПоУмолчанию;
	Описание.КатегорияДохода = УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы = Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.КодДоходаСтраховыеВзносы2017 = Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	
	Если ВостребованностьРКиСН.СевернаяНадбавка Тогда
		ЗаписатьНачисление(Описание);
	Иначе
		ОтключитьИспользованиеНачисленийПоОписанию(Описание);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьВидДоходаИсполнительногоПроизводства() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустаяСсылка", Перечисления.ВидыДоходовИсполнительногоПроизводства.ПустаяСсылка());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Начисления.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ВидДоходаИсполнительногоПроизводства = &ПустаяСсылка";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат
	КонецЕсли;	
	
	Начисления = РезультатЗапроса.Выбрать();
	Пока Начисления.Следующий() Цикл
		Начисление = Начисления.Ссылка.ПолучитьОбъект();
		Начисление.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Начисление);
	КонецЦикла	
	
КонецПроцедуры

Процедура СоздатьГодовуюПремию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КодДоходаНДФЛ_2002 = ВидыДоходовНДФЛПоКоду("2002");
	
	Описание = ОписаниеНачисления();
	Описание.Код							= НСтр("ru = 'ПРГП'");
	Описание.Наименование					= НСтр("ru = 'Премия за год'");
	Описание.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Прочее;
	Описание.ВидНачисленияДляНУ 			= Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп2ст255;
	Описание.КодДоходаНДФЛ 					= КодДоходаНДФЛ_2002;
	Описание.КатегорияДохода				= УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(Описание.КодДоходаНДФЛ);
	Описание.КодДоходаСтраховыеВзносы	 	= Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.КодДоходаСтраховыеВзносы2017 	= Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
	Описание.ВходитВБазуРКИСН 				= Ложь;
	Описание.ВидОперацииПоЗарплате 			= Перечисления.ВидыОперацийПоЗарплате.НачисленоДоход;
	Описание.КлючевыеСвойства				= "Код, Наименование, КодДоходаНДФЛ";
	ЗаписатьНачисление(Описание);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьВидДоходаИсполнительногоПроизводства2022() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустаяСсылка", Перечисления.ВидыДоходовИсполнительногоПроизводства.ПустаяСсылка());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Начисления.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ВидДоходаИсполнительногоПроизводства2022 = &ПустаяСсылка";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат
	КонецЕсли;	
	
	Начисления = РезультатЗапроса.Выбрать();
	Пока Начисления.Следующий() Цикл
		Начисление = Начисления.Ссылка.ПолучитьОбъект();
		ВидДохода = Начисление.ВидДоходаИсполнительногоПроизводства;
		Если Начисление.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемые Тогда
			ВидДохода = Перечисления.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемыеПериодические;
		ИначеЕсли Начисление.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемые Тогда
			ВидДохода = Перечисления.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемыеПериодические;
		КонецЕсли;
		Начисление.ВидДоходаИсполнительногоПроизводства2022 = ВидДохода;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Начисление);
	КонецЦикла	
	
КонецПроцедуры

Процедура УточнитьКодДоходаНДФЛОтпускаАУСН() Экспорт
	
	КодДохода2000 = Справочники.ВидыДоходовНДФЛ.КодДоходаПоУмолчанию;
	
	КодыНачислений = Новый Массив;
	КодыНачислений.Добавить("ОТ");
	КодыНачислений.Добавить("КОТ");
	
	КодыДоходовНДФЛ = Новый Массив;
	КодыДоходовНДФЛ.Добавить(ВидыДоходовНДФЛПоКоду("2012"));
	КодыДоходовНДФЛ.Добавить(ВидыДоходовНДФЛПоКоду("2013"));
	
	КатегорииНачислений = Новый Массив;
	КатегорииНачислений.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска);
	КатегорииНачислений.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Прочее);
	
	ВидыОперацийПоЗарплате = Новый Массив;
	ВидыОперацийПоЗарплате.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпуск);
	ВидыОперацийПоЗарплате.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпуска);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодыНачислений",         КодыНачислений);
	Запрос.УстановитьПараметр("КодыДоходовНДФЛ",        КодыДоходовНДФЛ);
	Запрос.УстановитьПараметр("КатегорииНачислений",    КатегорииНачислений);
	Запрос.УстановитьПараметр("ВидыОперацийПоЗарплате", ВидыОперацийПоЗарплате);
	Запрос.УстановитьПараметр("КодДоходаНДФЛАУСН",      КодДохода2000);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачисленияАУСН.НачислениеАУСН КАК Ссылка
	|ИЗ
	|	РегистрСведений.НачисленияАУСН КАК НачисленияАУСН
	|ГДЕ
	|	НачисленияАУСН.НачислениеАУСН.Код В(&КодыНачислений)
	|	И НачисленияАУСН.НачислениеАУСН.КодДоходаНДФЛ В(&КодыДоходовНДФЛ)
	|	И НачисленияАУСН.НачислениеАУСН.КатегорияНачисленияИлиНеоплаченногоВремени В(&КатегорииНачислений)
	|	И НачисленияАУСН.НачислениеАУСН.ВидОперацииПоЗарплате В(&ВидыОперацийПоЗарплате)
	|	И НачисленияАУСН.НачислениеАУСН.КодДоходаНДФЛ <> &КодДоходаНДФЛАУСН";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачислениеОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НачислениеОбъект.КодДоходаНДФЛ   = КодДохода2000;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НачислениеОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеНачислений

// Возвращает начисление районного коэффициента. Уникальность начисления этой категории контролируется при создании.
Функция НачислениеРайонныйКоэффициент() Экспорт
	
	Отбор = Новый Структура("КатегорияНачисленияИлиНеоплаченногоВремени", Перечисления.КатегорииНачисленийИНеоплаченногоВремени.РайонныйКоэффициент);
	Возврат НачислениеПоУмолчанию(Отбор);
	
КонецФункции

// Возвращает начисление северной надбавки. Уникальность начисления этой категории контролируется при создании.
Функция НачислениеСевернаяНадбавка() Экспорт
	
	Отбор = Новый Структура("КатегорияНачисленияИлиНеоплаченногоВремени", Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СевернаяНадбавка);
	Возврат НачислениеПоУмолчанию(Отбор);
	
КонецФункции

// Получает начисление по умолчанию по отбору.
//
// Параметры:
//   Отбор - Структура - Отбор по начислениям.
//       В отбор безусловно добавляются отборы "ПометкаУдаления = Ложь" и "ВАрхиве = Ложь".
//   Обязательное - Булево - Необязательный. По умолчанию Ложь. Если передать значение Истина, 
//       то в случае отсутствия начисления будет поднято исключение с текстом "В программе отсутствует начисление".
//   Количество - Число - Используется и как входящий и как исходящий параметр.
//       На входе определяет количество выбираемых начислений.
//       На выходе определяет количество фактически выбранных начислений.
//
// Возвращаемое значение:
//   ПланВидовРасчетаСсылка.Начисления - Начисление по умолчанию, соответствующее отбору.
//   Неопределено - Если начисление не выбрано и в параметре Обязательное не указано значение Истина.
//
Функция НачислениеПоУмолчанию(Отбор, Обязательное = Ложь, Количество = 1) Экспорт
	Отбор.Вставить("ПометкаУдаления", Ложь);
	Запрос = ЗапросПоНачислениям(Отбор, "РеквизитДопУпорядочивания", Количество);
	Выборка = Запрос.Выполнить().Выбрать();
	Количество = Выборка.Количество();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	ИначеЕсли Обязательное Тогда
		Текст = СтрШаблон(
			НСтр("ru = 'В программе отсутствует начисление с параметрами (%1).
				|Настройте список начислений, дополнив его одним или несколькими начислениями указанного назначения.'"),
			ПредставлениеОтбораНачислений(Отбор));
		ВызватьИсключение Текст;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Возвращает массив начислений, соответствующих отбору.
//
// Параметры:
//   Отбор - Структура - Отбор по начислениям.
//       * Ключ - Строка - Имя одного из реквизитов ПланаВидовРасчета.Начисления.
//       * Значение - Произвольный - Значение отбора по реквизиту.
//       Кроме того, предусмотрена обработка предопределенных ключей:
//       По ключу "ОпределяющиеПоказатели" выполняется поиск начислений, по наличию показателей в списке определяющих.
//   ПоляУпорядочивания - Строка - Имена реквизитов, по которым следует упорядочить выбираемые записи.
//
// Возвращаемое значение:
//   Массив - Начисления, соответствующие отбору.
//
Функция НачисленияПоОтбору(Отбор, ПоляУпорядочивания = "Ссылка") Экспорт
	Запрос = ЗапросПоНачислениям(Отбор, ПоляУпорядочивания, 0);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

// Возвращает массив начислений, соответствующие параметрам.
//
// Параметры:
//   КатегорияНачисления - ПеречислениеСсылка.КатегорииНачисленийИНеоплаченногоВремени - Категория начисления.
//   Отбор - Структура - Отбор по начислениям. См. описание параметра "Отбор" функции НачисленияПоОтбору.
//
// Возвращаемое значение:
//   Массив - Начисления, соответствующие отбору.
//
Функция НачисленияПоКатегории(КатегорияНачисления, Отбор = Неопределено) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = Новый Структура;
	КонецЕсли;
	Отбор.Вставить("КатегорияНачисленияИлиНеоплаченногоВремени", КатегорияНачисления);
	Отбор.Вставить("ПометкаУдаления", Ложь);
	
	Возврат НачисленияПоОтбору(Отбор, "РеквизитДопУпорядочивания");
	
КонецФункции

// Заполняет реквизит типа "ПланВидовРасчетаСсылка.Начисления" начислением по умолчанию в форме документа.
//   Если начисление не найдено, то устанавливается пустая ссылка.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма, в которой необходимо заполнить реквизит.
//   ИмяПоляВвода - Строка - Имя элемента формы вида "ПолеВвода", связанного с заполняемым реквизитом.
//   ДополнительныеПараметрыВыбора - Структура - Дополнительные параметры выбора начислений,
//       добавляемые к параметрам выбора и связям параметров выбора.
//   УстановитьЗначение - Булево - По умолчанию Истина. Если передать значение Ложь,
//       то будут заполнены только параметры выбора поля ввода, а само значение реквизита заполнено не будет.
//   ПутьКРеквизиту - Строка - Путь к реквизиту формы. Пример: "Объект.ВидРасчета".
//       Параметр является обязательным в случае, если путь к реквизиту отличается от стандартного "Объект.<ИмяПоляВвода>".
//   Обязательное - Булево - По умолчанию Ложь. Если передать значение Истина,
//       то в случае отсутствия начисления будет поднято исключение с текстом "В программе отсутствует начисление".
//   УстановитьВидимость - Булево - Признак управления видимостью в зависимости от количества начислений в ИБ.
//       По умолчанию Ложь. Если передать значение Истина,
//         то в случае, если в ИБ всего одно начисление, соответствующее текущим параметрам выбора,
//         поле ввода будет скрыто.
//       Из соображений скорости открытия форм документов,
//         видимостью полей начислений рекомендуется управлять при помощи функциональных опций.
//         Примеры см. среди функциональных опций с именами, начинающимися с "ВыбиратьВидНачисления".
//       Поскольку видимостью полей рекомендуется управлять только в ПриСозданииНаСервере,
//         то данный параметр не рекомендуется использовать для полей ввода
//         со связями параметров выбора или дополнительными параметрами выбора.
//
// Возвращаемое значение:
//   Булево - Истина, если удалось найти хоть одно начисление и значение отличается от прежнего.
//
Функция УстановитьНачислениеПоУмолчаниюВФорме(Форма, ИмяПоляВвода, ДополнительныеПараметрыВыбора = Неопределено, УстановитьЗначение = Истина, ПутьКРеквизиту = Неопределено, Обязательное = Ложь, УстановитьВидимость = Ложь) Экспорт
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
		Возврат Ложь; // ПланыВидовРасчета.Начисления недоступен по ФО.
	КонецЕсли;
	
	ПолеВвода = Форма.Элементы.Найти(ИмяПоляВвода);
	
	// Элемент может отсутствовать в форме: не выведен на форму, недоступен по ФО или по правам.
	Если ПолеВвода = Неопределено Тогда
		
		// Если элемент отсутствует, то обновляется только значение реквизита объекта.
		Если УстановитьЗначение Тогда
			Если ПутьКРеквизиту = Неопределено Тогда
				Объект = Форма.Объект;
				ПутьКРеквизитуОбъекта = ИмяПоляВвода;
			Иначе
				МассивСтрок = СтрРазделить(ПутьКРеквизиту, ".", Ложь);
				Объект = Форма[МассивСтрок[0]];
				МассивСтрок.Удалить(0);
				ПутьКРеквизитуОбъекта = СтрСоединить(МассивСтрок, ".");
			КонецЕсли;
			Возврат УстановитьНачислениеПоУмолчаниюВОбъекте(Объект, ПутьКРеквизитуОбъекта, ДополнительныеПараметрыВыбора, Обязательное);
		КонецЕсли;
		
	Иначе
		
		// Если элемент присутствует, то сперва обновляются параметры выбора элемента формы.
		ПараметрыВыбораИзменились = ОбщегоНазначенияБЗК.УстановитьПараметрыВыбора(ПолеВвода, ДополнительныеПараметрыВыбора);
		
		// А затем обновляется значение реквизита объекта.
		Если УстановитьЗначение Или УстановитьВидимость Тогда
			Если ПутьКРеквизиту = Неопределено Тогда
				ПутьКРеквизиту = ПолеВвода.ПутьКДанным;
			КонецЕсли;
			СтароеЗначение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКРеквизиту);
			Если УстановитьВидимость Или ПараметрыВыбораИзменились Или Не ЗначениеЗаполнено(СтароеЗначение) Тогда
				Параметры = ОбщегоНазначенияБЗК.ПараметрыВыбораВСтруктуру(Форма, ПолеВвода);
				Количество = ?(УстановитьВидимость, 2, 1);
				НовоеЗначение = НачислениеПоУмолчанию(Параметры.Отбор, Обязательное, Количество);
				Если УстановитьВидимость Тогда
					ПолеВвода.Видимость = (Количество <> 1);
				КонецЕсли;
				Если УстановитьЗначение Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ПутьКРеквизиту, НовоеЗначение);
					Возврат ЗначениеЗаполнено(НовоеЗначение) И НовоеЗначение <> СтароеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

// Заполняет реквизит типа "ПланВидовРасчетаСсылка.Начисления" начислением по умолчанию в документе.
//   Если начисление не найдено, то устанавливается пустая ссылка.
//
// Параметры:
//   ДокументОбъект - ДанныеФормыСтруктура, ДокументОбъект.<ИмяДокумента> - Документ, в котором необходимо заполнить реквизит.
//   ИмяРеквизита   - Строка - Имя реквизита документа. Например: "ВидРасчета".
//   ДополнительныеПараметрыВыбора - Структура - Дополнительные параметры выбора начислений,
//       добавляемые к параметрам выбора и связям параметров выбора.
//   Обязательное - Булево - Необязательный. По умолчанию Ложь. Если передать значение Истина,
//       то в случае отсутствия начисления будет поднято исключение с текстом "В программе отсутствует начисление".
//
// Возвращаемое значение:
//   Булево - Истина, если удалось найти хоть одно начисление и значение отличается от прежнего.
//
Функция УстановитьНачислениеПоУмолчаниюВОбъекте(ДокументОбъект, ИмяРеквизита, ДополнительныеПараметрыВыбора = Неопределено, Обязательное = Ложь) Экспорт
	МетаданныеРеквизита = ДокументОбъект.Ссылка.Метаданные().Реквизиты.Найти(ИмяРеквизита);
	Параметры = ОбщегоНазначенияБЗК.ПараметрыВыбораВСтруктуру(ДокументОбъект, МетаданныеРеквизита, ДополнительныеПараметрыВыбора);
	Значение = НачислениеПоУмолчанию(Параметры.Отбор, Обязательное);
	СтароеЗначение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ДокументОбъект, ИмяРеквизита);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ДокументОбъект, ИмяРеквизита, Значение);
	Возврат ЗначениеЗаполнено(Значение) И Значение <> СтароеЗначение;
КонецФункции

// Компонует представление отбора по начислениям.
Функция ПредставлениеОтбораНачислений(Знач Отбор)
	Если Отбор.Количество() = 0 Тогда
		Возврат "";
	Иначе
		СписокПредставлений = Новый СписокЗначений;
		Для Каждого КлючИЗначение Из Отбор Цикл
			Если КлючИЗначение.Ключ = "ВидДокументаНачисления"
				Или КлючИЗначение.Ключ = "КатегорияНачисленияИлиНеоплаченногоВремени" Тогда
				Приоритет = "1.";
			ИначеЕсли КлючИЗначение.Ключ = "ВАрхиве"
				Или КлючИЗначение.Ключ = "ПометкаУдаления" Тогда
				Приоритет = "3.";
			Иначе
				Приоритет = "2.";
			КонецЕсли;
			Представление = КлючИЗначение.Ключ + " (" + Строка(КлючИЗначение.Значение) + ")";
			СписокПредставлений.Добавить(Представление, Приоритет + Представление);
		КонецЦикла;
		СписокПредставлений.СортироватьПоПредставлению();
		Возврат СтрСоединить(СписокПредставлений.ВыгрузитьЗначения(), ", ");
	КонецЕсли;
КонецФункции

// Возвращает запрос по начислениям по указанному отборы и параметрам.
Функция ЗапросПоНачислениям(Отбор, ПоляУпорядочивания, КоличествоПервых)
	Запрос = Новый Запрос;
	
	Если КоличествоПервых = 0 Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Начисления.Ссылка
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК Начисления";
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ "+ Формат(КоличествоПервых, "ЧГ=") +"
		|	Начисления.Ссылка
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК Начисления";
	КонецЕсли;
	
	// Отборы.
	ФрагментыУсловий = Новый Массив;
	Для Каждого КлючИЗначение Из Отбор Цикл
		ИмяОтбора = КлючИЗначение.Ключ;
		ЗначениеОтбора = КлючИЗначение.Значение;
		// Фиксированный массив преобразуем в обычный.
		Если ТипЗнч(ЗначениеОтбора) = Тип("ФиксированныйМассив") Тогда
			ЗначениеОтбора = Новый Массив(ЗначениеОтбора);
		КонецЕсли;
		Запрос.УстановитьПараметр(ИмяОтбора, ЗначениеОтбора);
		Если ИмяОтбора = "ОпределяющиеПоказатели" Тогда
			// Предопределенный фильтр по определяющим показателям.
			ФрагментыУсловий.Добавить("
				|	ИСТИНА В
				|			(ВЫБРАТЬ ПЕРВЫЕ 1
				|				ИСТИНА
				|			ИЗ
				|				ПланВидовРасчета.Начисления.Показатели КАК ПоказателиНачислений
				|			ГДЕ
				|				ПоказателиНачислений.Ссылка = Начисления.Ссылка
				|				И ПоказателиНачислений.ОпределяющийПоказатель = ИСТИНА
				|				И ПоказателиНачислений.Показатель.ИмяПредопределенныхДанных В (&ОпределяющиеПоказатели))");
		ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
			ФрагментыУсловий.Добавить(СтрШаблон("Начисления.%1 В (&%1)", ИмяОтбора))
		Иначе
			ФрагментыУсловий.Добавить(СтрШаблон("Начисления.%1 = &%1", ИмяОтбора))
		КонецЕсли;
	КонецЦикла;
	Если ФрагментыУсловий.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + "
		|ГДЕ
		|	" + СтрСоединить(ФрагментыУсловий, " И ");
	КонецЕсли;
	
	// Порядок.
	Если ЗначениеЗаполнено(ПоляУпорядочивания) Тогда
		Запрос.Текст = Запрос.Текст + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	" + ПоляУпорядочивания;
	КонецЕсли;
	
	Возврат Запрос;
КонецФункции

#КонецОбласти

// Возвращает виды доходов исполнительного производства начислений
//
// Возвращаемое значение:
// 	Соответствие:
// 	 	* Ключ     - ПеречислениеСсылка.ВидыОсобыхНачисленийИУдержаний
// 	 	* Значение - ПеречислениеСсылка.ВидыДоходовИсполнительногоПроизводства
// 
Функция ВидыДоходовИсполнительногоПроизводства(Период) Экспорт
	 ИмяРеквизита = ?(ВидыДоходовИсполнительногоПроизводствавызовСервера.ВступилиВСилуИзменения353ФЗ(Период),
	 	"ВидДоходаИсполнительногоПроизводства2022",
	 	"ВидДоходаИсполнительногоПроизводства");
	
	Возврат УчетНачисленнойЗарплаты.ВидыДоходовИсполнительногоПроизводстваОбъектов(
		Метаданные.ПланыВидовРасчета.Начисления, ИмяРеквизита);
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ОписаниеНачисления() Экспорт
	
	Описание = Новый Структура(
	"Код,
	|Наименование,
	|КатегорияНачисленияИлиНеоплаченногоВремени,
	|ВидНачисленияДляНУ,
	|КодДоходаНДФЛ,
	|КатегорияДохода,
	|КодДоходаСтраховыеВзносы,
	|КодДоходаСтраховыеВзносы2017,
	|ОтношениеКЕНВД,
	|КлючевыеСвойства,
	|СвойстваПоКатегории,
	|ВходитВБазуРКИСН,
	|ВидОперацииПоЗарплате,
	|ВидДоходаИсполнительногоПроизводства");
	
	Описание.КлючевыеСвойства = "";
	Описание.ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.НачисленоДоход;
	Описание.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения;
	
	Возврат Описание;
	
КонецФункции

Функция ЗаписатьНачисление(Описание, ПроверятьНаличиеНачислений = Истина)
	
	Если ПроверятьНаличиеНачислений Тогда
		НачисленияПоОписанию = НачисленияПоОписанию(Описание);
		Если НачисленияПоОписанию.Количество() > 0 Тогда
			// Если начисления по такому описанию уже существуют, 
			// надо проверить все ли они используются, если нет - нужно их «включить».
			УстановитьИспользованиеНачислений(НачисленияПоОписанию, Истина);
			Возврат НачисленияПоОписанию;
		КонецЕсли;
	КонецЕсли;
	
	СвойстваПоКатегории = Описание.СвойстваПоКатегории;
	
	НачислениеОбъект = ПланыВидовРасчета.Начисления.СоздатьВидРасчета();
		
	ЗаполнитьЗначенияСвойств(НачислениеОбъект, Описание);
	
	НачислениеОбъект.Записать();
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НачислениеОбъект.Ссылка);
	
КонецФункции

Процедура ОтключитьИспользованиеНачисленийПоОписанию(Описание)
	
	УстановитьИспользованиеНачислений(НачисленияПоОписанию(Описание), Ложь);

КонецПроцедуры

Функция НачисленияПоОписанию(Описание)
	
	Отбор = Новый Структура;
	
	// Если указаны, ключевые свойства используются для уточнения критериев отбора искомого начисления.
	Если ЗначениеЗаполнено(Описание.КлючевыеСвойства) Тогда
		Отбор = Новый Структура(Описание.КлючевыеСвойства);
		ЗаполнитьЗначенияСвойств(Отбор, Описание);
	КонецЕсли;
	
	Отбор.Вставить("КатегорияНачисленияИлиНеоплаченногоВремени", Описание.КатегорияНачисленияИлиНеоплаченногоВремени);
	
	Возврат НачисленияПоОтбору(Отбор);
	
КонецФункции

Процедура УстановитьИспользованиеНачислений(Начисления, Использование)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Начисления.Ссылка
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Ссылка В(&Начисления)
	|	И Начисления.ПометкаУдаления <> &ПометкаУдаления";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Начисления", Начисления);
	Запрос.УстановитьПараметр("ПометкаУдаления", Не Использование);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачислениеОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НачислениеОбъект.ПометкаУдаления = Не Использование;
		НачислениеОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ВидыДоходовНДФЛПоКоду(КодДохода)
	
	КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.НайтиПоКоду(КодДохода);
	Если НЕ ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
		 
		Справочники.ВидыДоходовНДФЛ.СоздатьКодыДоходовНДФЛ();
		КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.НайтиПоКоду(КодДохода);
		
	КонецЕсли; 
	
	Возврат КодДоходаНДФЛ;
	
КонецФункции

#КонецОбласти

#КонецЕсли