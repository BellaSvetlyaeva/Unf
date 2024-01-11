
#Область СлужебныйПрограммныйИнтерфейс

// Формирует движения по регистрам подсистемы.
//      	 
// Параметры:
//		Движения - коллекция движений регистратора.
//		Отказ - булево - признак отказа от заполнения движений.
//		Организация - СправочникСсылка.Организации -
//		Регистратор - ДокументСсылка - 
//		ТаблицаВыплат - ТаблицаЗначений - 
//		Записывать - булево - признак того, надо ли записывать движения сразу, или они будут записаны позже.
//
Процедура СформироватьДокументыОплаченныеБезУдержанияНДФЛ(Движения, Отказ, Организация, Регистратор, ТаблицаВыплат, Записывать = Ложь) Экспорт
	
	
КонецПроцедуры

// Формирует движения по регистрам подсистемы.
// Параметры:
//		Движения - коллекция движений регистратора.
//		Отказ - булево - признак отказа от заполнения движений.
//		Организация
//		ДатаОперации - дата - дата, которой будет зарегистрировано движение
//		МесяцНачисления.
//		Удержания - таблица значений с колонками
//				ФизическоеЛицо: должно быть непустым.
//				КатегорияУдержания - тип ПеречислениеСсылка.КатегорииУдержаний.
//				Удержание - тип ПланВидовРасчетаСсылка.Удержания.
//				Сумма
//		Записывать - булево - признак того, надо ли записывать движения сразу, или они будут записаны позже.
//		ОкончательныйРасчет - булево - признак того, надо ли помечать движения как предназначенные для межрасчетного
//		                               исчисления налога.
//
Процедура СформироватьСоциальныеВычетыПоУдержаниям(Регистратор, Движения, Отказ, Организация, ДатаОперации, МесяцНачисления, Удержания, Записывать = Ложь, ОкончательныйРасчет = Истина) Экспорт 

	Если Удержания.Количество() = 0 Тогда // данных не оказалось
		Возврат	
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("КатегорияУдержания");
	СтруктураПоиска.КатегорияУдержания = Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ;
	Вычеты = Удержания.Скопировать(СтруктураПоиска);
	СтруктураПоиска.КатегорияУдержания = Перечисления.КатегорииУдержаний.ДСВ;
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Удержания.Скопировать(СтруктураПоиска), Вычеты);

	Если Вычеты.Количество() = 0 Тогда
		Возврат	
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Удержания", Вычеты);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Удержания.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Удержания.Удержание КАК Удержание,
	|	Удержания.Сумма КАК Сумма
	|ПОМЕСТИТЬ ВТУдержания
	|ИЗ
	|	&Удержания КАК Удержания
	|";
	Запрос.Выполнить();
	
	УчетНДФЛ.СформироватьСоциальныеВычетыПоВременнойТаблице(Регистратор, Движения, Отказ, Организация, ДатаОперации, МесяцНачисления, Запрос.МенеджерВременныхТаблиц, Записывать, ОкончательныйРасчет);
	
КонецПроцедуры

// Формирует движения по НДФЛ: регистрирует доходы, вычеты и исчисленный налог (как в учете НДФЛ, так и в учете
// начисленной зарплаты).
//
// Параметры:
//		Регистратор - ДокументСсылка -
//		Движения - коллекция движений регистратора.
//		Отказ - булево - признак отказа от заполнения движений.
//		Организация - СправочникСсылка.Организации -
//		Дата, ПериодРегистрации - реквизиты регистратора.
//		ПорядокВыплаты - ПеречислениеСсылка.ХарактерВыплатыЗарплаты - Межрасчет / Зарплата / Аванс
//		ПланируемаяДатаВыплаты - дата -
//		ДанныеДляПроведения - структура - структура данных, используемая при проведении документов
//				обязательные поля
//					МенеджерВременныхТаблиц с вр.таблицами ВТНачисления, ВТФизическиеЛица.
//					НДФЛ - таблица значений с данными об исчисленном НДФЛ и предоставленных вычетах.
//					УдержанияПоСотрудникам - таблица значений с данными о суммах удержаний.
//		Записывать - булево - признак того, надо ли записывать движения сразу, или они будут записаны позже.
//		РегистрироватьСуммыНалога - булево - признак того, надо ли писать движения по исчисленным налогам,
//					если не указан будет определяться по значению параметра ПорядокВыплаты: истине соответствует Межрасчет.
//		ДоходПолученНаТерриторииРФ - булево - признак того, надо ли регистрировать доход как полученный за пределами РФ: 
//		                               если ДоходПолученНаТерриторииРФ = Истина, весь доход регистрируется как полученный из источников на территории РФ.
//		ПеречислитьНалогПриВыплатеЗарплаты - булево - признак того, надо ли регистрировать исчисленный НДФЛ как удерживаемый при выплате з/пл.
//      ИмяТаблицыФизлиц - строка - используется при регистрации документа-регистратора как посчитавшего свой налог
//
Процедура ЗарегистрироватьДоходыИСуммыНДФЛПриНачисленииАванса(Регистратор, Движения, Отказ, Организация, Дата, ПериодРегистрации, ПланируемаяДатаВыплаты, ДанныеДляПроведения, Записывать, ИмяТаблицыФизлиц, ИмяВТНачисления) Экспорт 
	
	ДатаОперацииПоНалогам = УчетНДФЛ.ДатаОперацииПоДокументу(Дата, ПериодРегистрации);
	
	// регистрация доходов
	УчетНДФЛ.СформироватьДоходыНДФЛПоНачислениям(Движения, Отказ, Организация, ДатаОперацииПоНалогам, ПланируемаяДатаВыплаты, ДанныеДляПроведения.МенеджерВременныхТаблиц, ПериодРегистрации, , Ложь, ИмяВТНачисления, Регистратор);
	
	// Дополняем доходы НДФЛ сведениями о распределении по статьям финансирования и/или статьям расходов.
	ОтражениеЗарплатыВУчетеБазовый.ДополнитьСведенияОДоходахНДФЛСведениямиОРаспределенииПоСтатьям(Движения, Истина);
	
	// Регистрация исчисленного налога.
	УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, Организация, ДатаОперацииПоНалогам, ДанныеДляПроведения.НДФЛ, , Ложь, ПланируемаяДатаВыплаты);
	УчетНДФЛ.СформироватьСоциальныеВычетыПоУдержаниям(Регистратор, Движения, Отказ, Организация, ДатаОперацииПоНалогам, ?(УчетНДФЛ.ДоходыУчитываютсяТолькоПоДатеВыплаты(ПериодРегистрации, -1), ПланируемаяДатаВыплаты, ПериодРегистрации), ДанныеДляПроведения.УдержанияПоСотрудникам, , Ложь);
	УчетНДФЛ.СформироватьДокументыУчтенныеПриРасчетеДляМежрасчетногоДокументаПоВременнойТаблице(Движения, Отказ, Организация, ДанныеДляПроведения.МенеджерВременныхТаблиц, Регистратор, ИмяТаблицыФизлиц); 	
	
	// Пометим особым образом строки только что сформированных движений.
	ПереченьРегистров = Новый Массив;
	ПереченьРегистров.Добавить("СведенияОДоходахНДФЛ");
	ПереченьРегистров.Добавить("РасчетыНалогоплательщиковСБюджетомПоНДФЛ");
	ПереченьРегистров.Добавить("ПредоставленныеСтандартныеИСоциальныеВычетыНДФЛ");
	ПереченьРегистров.Добавить("ИмущественныеВычетыНДФЛ");
	ПереченьРегистров.Добавить("АвансовыеПлатежиИностранцевПоНДФЛ");
	Для каждого ИмяРегистра Из ПереченьРегистров Цикл
		Если ПроведениеСервер.ЕстьДвижения(Движения, ИмяРегистра) Тогда
			НаборЗаписей = Движения[ИмяРегистра];
			Для каждого СтрокаНабора Из НаборЗаписей Цикл
				СтрокаНабора.ЗарегистрированоПриНачисленииАванса = ПериодРегистрации;
				Если ИмяРегистра = "СведенияОДоходахНДФЛ" Тогда
					СтрокаНабора.ДоходМежрасчетногоПериода = Ложь
				ИначеЕсли ИмяРегистра = "РасчетыНалогоплательщиковСБюджетомПоНДФЛ" Тогда
					СтрокаНабора.РасчетМежрасчетногоПериода = Ложь
				ИначеЕсли ИмяРегистра = "ПредоставленныеСтандартныеИСоциальныеВычетыНДФЛ" Тогда
					СтрокаНабора.ВычетМежрасчетногоПериода = Ложь
				ИначеЕсли ИмяРегистра = "ИмущественныеВычетыНДФЛ" Тогда
					СтрокаНабора.ВычетМежрасчетногоПериода = Ложь
				Иначе
				КонецЕсли;
			КонецЦикла;
			Если Записывать Тогда
				НаборЗаписей.Записать();
				НаборЗаписей.Записывать = Ложь;
			Иначе
				НаборЗаписей.Записывать = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Дополняет перечень оплачиваемых платежным документом начислятелей оплаченными ранее документами, по которым по
// желанию пользователя не был удержан налог.
//      	 
// Параметры:
//      Регистратор - ДокументСсылка - ссылка на документ-регистратор.
//		Организация - СправочникСсылка.Организации -
//		ДатаОперации - дата - дата, которой будет зарегистрировано движение.
//		ПериодРегистрации - дата - 
//      МенеджерВременныхТаблиц - МенеджерВременныхТаблиц, содержит вр. таблицу 
//      	ВТСписокСотрудников с полями 
//				ФизическоеЛицо: должно быть непустым
//          	СуммаВыплаты,
//          	ДокументОснование,
//          	СуммаНачисленная,
//          	СуммаВыплаченная
//		ТаблицаВыплат - таблица значений - выплачиваемые документом-регистратором суммы с колонками
//		ИмяТаблицыСписокСотрудников - Строка - 
//      	 
Процедура ДописатьДокументыОплаченныеБезУдержанияНДФЛ(Регистратор, Организация, ДатаОперации, ПериодРегистрации, МенеджерВременныхТаблиц, ТаблицаВыплат, ИмяТаблицыСписокСотрудников) Экспорт 

КонецПроцедуры

Функция УдерживатьНалогПриВыплатеАванса(Организация) Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция УдерживатьНДФЛСНатуральногоДоходаПриБлижайшейВыплате(Организация) Экспорт

	Возврат Ложь;

КонецФункции

Функция ПланируемаяДатаВыплатыЗарплаты(Организация, МесяцНачисления) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ЗарплатаКадрыДляНебольшихОрганизаций.РасчетЗарплаты") Тогда
		МодульРасчетЗарплатыДляНебольшихОрганизацийПовтИсп = ОбщегоНазначения.ОбщийМодуль("РасчетЗарплатыДляНебольшихОрганизацийПовтИсп");
		Возврат МодульРасчетЗарплатыДляНебольшихОрганизацийПовтИсп.ДатыВыплатыОрганизации(Организация, МесяцНачисления).Зарплата	
	Иначе
		Возврат КонецМесяца(МесяцНачисления)	
	КонецЕсли;

КонецФункции

#КонецОбласти

