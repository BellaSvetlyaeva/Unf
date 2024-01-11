#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция проверяет наличие в ИБ дисконтных карт с таким же кодом (штриховым или магнитным) как в переданных данных
//
// Параметры:
//  Данные - Структура - данные по дисконтной карте, для которой проверяется наличие дублей
//
Функция ПроверитьДублиСправочникаДисконтныеКартыПоКодам(Данные) Экспорт

	Дубли = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДисконтныеКарты.Ссылка КАК ДисконтнаяКарта,
		|	ДисконтныеКарты.Наименование,
		|	ДисконтныеКарты.КодКартыШтрихкод,
		|	ДисконтныеКарты.КодКартыМагнитный,
		|	ДисконтныеКарты.ВладелецКарты,
		|	ВЫБОР
		|		КОГДА ДисконтныеКарты.КодКартыШтрихкод = &КодКартыШтрихкод
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НайденПоШтрихКоду,
		|	ВЫБОР
		|		КОГДА ДисконтныеКарты.КодКартыМагнитный = &КодКартыМагнитный
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НайденПоМагнитномуКоду
		|ИЗ
		|	Справочник.ДисконтныеКарты КАК ДисконтныеКарты
		|ГДЕ
		|	ДисконтныеКарты.Владелец = &Владелец
		|	И (ДисконтныеКарты.КодКартыШтрихкод = &КодКартыШтрихкод
		|				И &ПроверятьШтрихкод
		|			ИЛИ ДисконтныеКарты.КодКартыМагнитный = &КодКартыМагнитный
		|				И &ПроверятьМагнитныйКод)
		|	И ДисконтныеКарты.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Владелец", Данные.Владелец);
	Запрос.УстановитьПараметр("КодКартыМагнитный", Данные.КодКартыМагнитный);
	Запрос.УстановитьПараметр("КодКартыШтрихкод", Данные.КодКартыШтрихкод);
	Запрос.УстановитьПараметр("Ссылка", Данные.Ссылка);
	Запрос.УстановитьПараметр("ПроверятьШтрихкод", (Данные.Владелец.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Данные.Владелец.ТипКарты = Перечисления.ТипыКарт.Смешанная) И 
	                                               ЗначениеЗаполнено(Данные.КодКартыШтрихкод));
	Запрос.УстановитьПараметр("ПроверятьМагнитныйКод", (Данные.Владелец.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Данные.Владелец.ТипКарты = Перечисления.ТипыКарт.Смешанная) И 
	                                               ЗначениеЗаполнено(Данные.КодКартыМагнитный));
	
	Результат = Запрос.Выполнить();
	ВыборкаДублей = Результат.Выбрать();
	Пока ВыборкаДублей.Следующий() Цикл
		Дубли.Добавить(ВыборкаДублей.ДисконтнаяКарта);
	КонецЦикла;
	
	Возврат Дубли;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ВладелецКарты)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом
// АПК:299-выкл используется в модуле обработки ПомощникЗагрузкиДанныхИзВнешнегоИсточника

// Сопоставляет данные из ДанныеФормыКоллекция
//
// Параметры:
//  ПараметрыСопоставления - Структура:
//    * ТаблицаСопоставленияДанных - ДанныеФормыКоллекция - таблица для обработки
//    * НастройкиЗагрузкиДанных - Структура - настройки загрузки
//  АдресРезультата - УникальныйИдентификатор - адрес, по которому будет помещен результат обработки
//  АдресДополнительногоРезультата - УникальныйИдентификатор - адрес по которому будет помещен
//                                                             дополнительный результат
//
Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(
		ПараметрыСопоставления, 
		АдресРезультата = "", 
		АдресДополнительногоРезультата = "") Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;	
	ОбновлятьДанные				= НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	ФиксированныйШаблон			= НастройкиЗагрузкиДанных.ФиксированныйШаблон;
	НастройкиПоиска				= НастройкиЗагрузкиДанных.НастройкиПоиска;
	ТаблицаДублирующихСтрок		= ПустаяТаблицаДублирующихСтрок();
	ИспользоватьХарактеристики	= НастройкиЗагрузкиДанных.ИспользоватьХарактеристики;
	ВидЦен						= НастройкиЗагрузкиДанных.ВидЦен;
	
	НастройкиПоиска.Вставить("ТаблицаДублирующихСтрок", ТаблицаДублирующихСтрок);
	
	СоответствиеИерархииКэш = Новый Соответствие;
	//ДеревоИерархии = Новый ДеревоЗначений;
	//ДеревоИерархии.Колонки.Добавить("Каталог", Новый ОписаниеТипов("Строка", ,
	//										   Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	//ДеревоИерархии.Колонки.Добавить("ГруппаСсылка", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	//ДеревоИерархии.Колонки.Добавить("УИД", Новый ОписаниеТипов("Строка", ,
	//										   Новый КвалификаторыСтроки(40, ДопустимаяДлина.Переменная)));
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		
		// ДисконтнаяКарта по ШтрихКоду, МагнитномуКоду
		ПроверитьИСопоставитьЭлементСправочникаПриЗагрузке(СтрокаТаблицыФормы, НастройкиПоиска); 
		
		ЭтаСтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.ДисконтнаяКарта);
		
		СопоставитьДанныеДисконтнойКарты(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных, 
			ОбновлятьДанные, ФиксированныйШаблон, ЭтаСтрокаСопоставлена);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.
			ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ТаблицаСопоставленияДанных.ЗагрузитьКолонку(ТаблицаДублирующихСтрок.ВыгрузитьКолонку("КлючСвязи"), "_КлючСвязи");
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
	//Если ДеревоИерархии.Строки.Количество() > 0 Тогда
	//	ПоместитьВоВременноеХранилище(ДеревоИерархии, АдресДополнительногоРезультата);
	//КонецЕсли;
	
КонецПроцедуры
#Область ЗагрузкаДанныхИзВнешнегоИсточникаСлужебные

Процедура УстановитьУИДНового(СтрокаТаблицы, ЭлементСправочника, НастройкиЗагрузкиДанных=Неопределено)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, "УИД_ВходящиеДанные") 
		И ЗначениеЗаполнено(СтрокаТаблицы.УИД_ВходящиеДанные) Тогда
		НовыйУИД = Новый УникальныйИдентификатор(СтрокаТаблицы.УИД_ВходящиеДанные);
		ЭлементСправочника.УстановитьСсылкуНового(Справочники.ДисконтныеКарты.ПолучитьСсылку(НовыйУИД));
	КонецЕсли;  
	
КонецПроцедуры

Функция ПустаяТаблицаДублирующихСтрок()
			
	Возврат ЗагрузкаДанныхИзВнешнегоИсточника.ПустаяТаблицаДублирующихСтрокДисконтныхКарт();
	
КонецФункции

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	СтрокаТаблицыФормы._СтрокаСопоставлена = ЗначениеЗаполнено(СтрокаТаблицыФормы.ДисконтнаяКарта);
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	КодЗаполнен = НЕ ПустаяСтрока(СтрокаТаблицыФормы.КодКартыШтрихкод) ИЛИ НЕ ПустаяСтрока(СтрокаТаблицыФормы.КодКартыМагнитный);
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля] = СтрокаТаблицыФормы._СтрокаСопоставлена
											ИЛИ (НЕ СтрокаТаблицыФормы._СтрокаСопоставлена И КодЗаполнен);
	
КонецПроцедуры

// Поля загрузки данных из внешнего источника.
// 
// Параметры:
//  ТаблицаПолейЗагрузки - см. ЗагрузкаДанныхИзВнешнегоИсточника.СоздатьТаблицуПолейОписанияЗагрузки
//  НастройкиЗагрузкиДанных - см. ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере
//
Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	ОписанияТиповПолей = ЗагрузкаДанныхИзВнешнегоИсточника.НовыйОписанияТиповПолейЗагрузки();
	
	ЭтоФиксированныйШаблон = НастройкиЗагрузкиДанных.Свойство("ФиксированныйШаблон") И НастройкиЗагрузкиДанных.ФиксированныйШаблон;
	//ЗначениеЗагружатьДопРеквизитыВХарактеристики = 2;
	
	ПроверитьИДобавитьКолонкиФиксированногоШаблона(ТаблицаПолейЗагрузки, ЭтоФиксированныйШаблон, 
		ОписанияТиповПолей.ОписаниеТиповСтрока50, ОписанияТиповПолей.ОписаниеТиповБулево); 
	
	ПредставлениеОсновнойШтрихкод = НСтр("ru = 'Штрихкод карты'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "КодКартыШтрихкод",
		ПредставлениеОсновнойШтрихкод, ОписанияТиповПолей.ОписаниеТиповСтрока200, ОписанияТиповПолей.ОписаниеТиповСтрока25);
	ПредставлениеОсновнойШтрихкод = НСтр("ru = 'Штрихкод карты'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "КодКартыШтрихкод",
		ПредставлениеОсновнойШтрихкод, ОписанияТиповПолей.ОписаниеТиповСтрока200, ОписанияТиповПолей.ОписаниеТиповСтрока25);
	
	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ПредставлениеПоставщикИНН = НСтр("ru = 'Владелец (покупатель)'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ВладелецКарты", 
		ПредставлениеПоставщикИНН, ОписанияТиповПолей.ОписаниеТиповСтрока100, ОписаниеТиповКолонка);
	
	ПредставлениеОписание = НСтр("ru = 'Описание'");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Комментарий", 
		ПредставлениеОписание, ОписанияТиповПолей.ОписаниеТиповСтрока0000, ОписанияТиповПолей.ОписаниеТиповСтрока0000);
	
	//ПроверитьИДобавитьКолонкиДополнительныхРеквизитов(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных, 
	//	ОписанияТиповПолей.ОписаниеТиповСтрока11, ОписанияТиповПолей.ОписаниеТиповСтрока150, ЗначениеЗагружатьДопРеквизитыВХарактеристики);
	//
	//ПредставлениеРеквизитыШаблона = НСтр("ru = 'ДопРеквизитыШаблона'");
	//ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ДопРеквизитыШаблона", 
	//	ПредставлениеРеквизитыШаблона, ОписанияТиповПолей.ОписаниеТиповСтрока0000, ОписанияТиповПолей.ОписаниеТиповСтрока0000, 
	//	, , , , Ложь);
		
КонецПроцедуры

Процедура ПроверитьИДобавитьКолонкиФиксированногоШаблона(ТаблицаПолейЗагрузки, 
	Знач ЭтоФиксированныйШаблон, ОписаниеТиповСтрока50, ОписаниеТиповБулево)
	Если ЭтоФиксированныйШаблон Тогда
		ПредставлениеУИД = НСтр("ru = 'УИД'");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "УИД", 
			ПредставлениеУИД, ОписаниеТиповСтрока50, ОписаниеТиповСтрока50);
		ПредставлениеЭтоУслуга = НСтр("ru = 'Это услуга'");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЭтоУслуга", 
			ПредставлениеЭтоУслуга, ОписаниеТиповБулево, ОписаниеТиповБулево);
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
// АПК:299-вкл

#КонецОбласти


Процедура СопоставитьДанныеДисконтнойКарты(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных, 
	ОбновлятьДанные, Знач ФиксированныйШаблон, ЭтаСтрокаСопоставлена)
	
	Перем ЗначениеПоУмолчанию;
	Перем ОрганизацияПоУмолчанию;
	Перем ВидСтавкиНДСПоУмолчанию;	
	
	// ЕдиницыИзмерения по Наименованию (так же рассмотреть возможность прикрутить пользовательские ЕИ)
	ЗначениеПоУмолчанию = Справочники.Контрагенты.ПустаяСсылка();
	ПриОпределенииЗначенияПоУмолчанию(СтрокаТаблицыФормы.ДисконтнаяКарта, "Владелец", 
		СтрокаТаблицыФормы.Владелец_ВходящиеДанные, 
		ЭтаСтрокаСопоставлена, ОбновлятьДанные, ЗначениеПоУмолчанию);
	ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.
		СопоставитьКонтрагента(СтрокаТаблицыФормы.ДисконтнаяКарта, СтрокаТаблицыФормы.Владелец, 
		СтрокаТаблицыФормы.Владелец_ВходящиеДанные, ЗначениеПоУмолчанию);
	
	// Дополнительные реквизиты
	ПроверитьИСопоставитьДополнительныеРеквизиты(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных);
КонецПроцедуры

Процедура ПроверитьИСопоставитьДополнительныеРеквизиты(СтрокаТаблицыФормы, НастройкиЗагрузкиДанных)
	Если НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты.Количество() > 0 Тогда
		
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьДополнительныеРеквизиты(СтрокаТаблицыФормы, 
			НастройкиЗагрузкиДанных.ВыбранныеДополнительныеРеквизиты);
		
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьИСопоставитьЭлементСправочникаПриЗагрузке(СтрокаТаблицыФормы, НастройкиПоиска)
		
	ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьДисконтнуюКарту(СтрокаТаблицыФормы, НастройкиПоиска);

КонецПроцедуры

Функция ПроверитьРеквизит(СтрокаТаблицыФормы, ИмяРеквизита)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, ИмяРеквизита) Тогда
	
		Возврат СтрокаТаблицыФормы[ИмяРеквизита];
		
	Иначе
		
		Возврат "";
		
	КонецЕсли; 
	
КонецФункции

Процедура ПриОпределенииЗначенияПоУмолчанию(СправочникСсылка, ИмяРеквизита, ВходящиеДанные, СтрокаСопоставлена, ОбновлятьДанные, ЗначениеПоУмолчанию)
	
	Если СтрокаСопоставлена 
		И НЕ ЗначениеЗаполнено(ВходящиеДанные) Тогда
		
		ЗначениеПоУмолчанию = СправочникСсылка[ИмяРеквизита];
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьПодготовленныеДанные(СтруктураДанных, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	     
	НастройкиОбновленияСвойств		= СтруктураДанных.НастройкиЗагрузкиДанных.НастройкиОбновленияСвойств;
	ОбновлятьСуществующие			= СтруктураДанных.НастройкиЗагрузкиДанных.ОбновлятьСуществующие;
	СоздаватьЕслиНеСопоставлено		= СтруктураДанных.НастройкиЗагрузкиДанных.СоздаватьЕслиНеСопоставлено;
	ФиксированныйШаблон				= СтруктураДанных.НастройкиЗагрузкиДанных.ФиксированныйШаблон;
	ТаблицаСопоставленияДанных		= СтруктураДанных.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных				= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных			= СтруктураДанных.НастройкиЗагрузкиДанных;
	КоличествоЗаписейТранзакции		= 0;
	ТранзакцияОткрыта				= Ложь;

	ВременныеДанныеЗагрузки = Новый Структура;

	Если ФиксированныйШаблон Тогда
		
		ВводНачальныхОстатков = Документы.ВводНачальныхОстатков.СоздатьДокумент();
		ВводНачальныхОстатков.Дата = НачалоДня(ТекущаяДатаСеанса());
		ВводНачальныхОстатков.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		ВводНачальныхОстатков.РазделУчета = Перечисления.РазделыУчета.СкидкиБонусы;
		
		ВременныеДанныеЗагрузки.Вставить("ВводНачальныхОстатков", ВводНачальныхОстатков);
		
	КонецЕсли;
	
	НастройкиОбновленияСвойств.ИменаПолейОбновляемые = ЗагрузкаДанныхИзВнешнегоИсточника.УдалитьНесуществующиеСвойства(
		СтрРазделить(НастройкиОбновленияСвойств.ИменаПолейОбновляемые, ", "), 
		Метаданные.Справочники.ДисконтныеКарты.Реквизиты);
	
	Попытка
		
		Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
			
			Если НЕ ТранзакцияОткрыта 
				И КоличествоЗаписейТранзакции = 0 Тогда
				
				НачатьТранзакцию();
				ТранзакцияОткрыта = Истина;
				
			КонецЕсли;
			
			ЗагрузкаВПриложениеВозможна = СтрокаТаблицы[ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна()];
			
			МожноЗагрузитьИлиОбновить = (СтрокаТаблицы._СтрокаСопоставлена И ОбновлятьСуществующие) 
				ИЛИ (НЕ СтрокаТаблицы._СтрокаСопоставлена И СоздаватьЕслиНеСопоставлено)
				ИЛИ ФиксированныйШаблон;
				
			Если ЗагрузкаВПриложениеВозможна И МожноЗагрузитьИлиОбновить Тогда
				
				КоличествоЗаписейТранзакции = КоличествоЗаписейТранзакции + 1;
				
				ЭлементСправочника = ЗагрузитьЭлемент(СтрокаТаблицы, СтруктураДанных, ВременныеДанныеЗагрузки);
				
			КонецЕсли;
			
			ИндексТекущейСтроки	= ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицы);
			ТекстПрогресса		= СтрШаблон(НСтр("ru ='Обработано %1 из %2 строк...'"), ИндексТекущейСтроки, РазмерТаблицыДанных);
			
			ДлительныеОперации.СообщитьПрогресс(, ТекстПрогресса);
			
			Если ТранзакцияОткрыта
				И КоличествоЗаписейТранзакции > ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.МаксимумЗаписейВОднойТранзакции() Тогда
				
				ЗафиксироватьТранзакцию();
				ТранзакцияОткрыта = Ложь;
				КоличествоЗаписейТранзакции = 0;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ФиксированныйШаблон 
			И (ВводНачальныхОстатков.БонусныеБаллы.Количество() > 0
				ИЛИ ВводНачальныхОстатков.НакопленныеПродажиПоДисконтнымКартам.Количество() > 0) Тогда
			ВводНачальныхОстатков.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли; 
		
		Если ТранзакцияОткрыта 
			И КоличествоЗаписейТранзакции > 0 Тогда
			
			ЗафиксироватьТранзакцию();
			ТранзакцияОткрыта = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = ОписаниеОшибки();
		НастройкиЗагрузкиДанных.Вставить("ТекстОшибки", ТекстОшибки);
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Загрузка данных'", "ru"), УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Номенклатура, , ТекстОшибки);
		ОтменитьТранзакцию();
		Возврат;
		
	КонецПопытки;
	
	Если ТранзакцияОткрыта Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ФоновоеЗаданиеАдресХранилища) Тогда
		СтруктураРезультата = Новый Структура("ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных", 
			ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных);
		ПоместитьВоВременноеХранилище(СтруктураРезультата, ФоновоеЗаданиеАдресХранилища);
	КонецЕсли;
	
КонецПроцедуры

Функция ЗагрузитьЭлемент(СтрокаТаблицы, СтруктураДанных, ВременныеДанныеЗагрузки)

	НастройкиОбновленияСвойств				= СтруктураДанных.НастройкиЗагрузкиДанных.НастройкиОбновленияСвойств;
	ФиксированныйШаблон						= СтруктураДанных.НастройкиЗагрузкиДанных.ФиксированныйШаблон;
	НастройкиЗагрузкиДанных					= СтруктураДанных.НастройкиЗагрузкиДанных;
	НастройкиПоиска							= НастройкиЗагрузкиДанных.НастройкиПоиска;
	ЭтоЗагрузкаТабличнойЧасти				= СтруктураДанных.НастройкиЗагрузкиДанных.ЭтоЗагрузкаТабличнойЧасти;
	ТребуетсяЗаписать 						= Истина;
	
	Если СтрокаТаблицы._КлючСвязи <> -1 Тогда
		РанееЗаполненнаяСтрока = СтруктураДанных.ТаблицаСопоставленияДанных[СтрокаТаблицы._КлючСвязи];
		СтрокаТаблицы.ДисконтнаяКарта = РанееЗаполненнаяСтрока.ДисконтнаяКарта;
		СтрокаТаблицы._СтрокаСопоставлена = Истина;
		ТребуетсяЗаписать = Ложь;
	КонецЕсли;

	ВидКарты = Неопределено;
	ВидКартыНаименование = ПроверитьРеквизит(СтрокаТаблицы, "Владелец");
	ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьВидДисконтнойКарты(ВидКарты, ВидКартыНаименование, Неопределено);

	ВладелецНаименованиеИлиИННКПП = ПроверитьРеквизит(СтрокаТаблицы, "ВладелецКарты");
	ВладелецКарты = Неопределено;
	ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКонтрагента(ВладелецКарты, ВладелецНаименованиеИлиИННКПП, ВладелецНаименованиеИлиИННКПП, "");

	Если СтрокаТаблицы._СтрокаСопоставлена Тогда
		
		МассивСвойств = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
			НастройкиОбновленияСвойств.ИменаПолейОбновляемые);
		Если МассивСвойств.Количество() = 0 И ТребуетсяЗаписать Тогда
			ТребуетсяЗаписать = Ложь;
		ИначеЕсли ТребуетсяЗаписать Тогда
			ЭлементСправочника = СтрокаТаблицы.ДисконтнаяКарта.ПолучитьОбъект();
			ТребуетсяЗаписать = Ложь;
			Для Каждого Свойство Из МассивСвойств Цикл
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭлементСправочника, Свойство) Тогда
					Если Свойство = "Владелец" Тогда
						Если Не ЭлементСправочника.Владелец = ВидКарты Тогда
							ТребуетсяЗаписать = Истина;
							ЭлементСправочника.Владелец = ВидКарты;
						КонецЕсли;
					ИначеЕсли Свойство = "ВладелецКарты" Тогда
						Если Не ЭлементСправочника.ВладелецКарты = ВладелецКарты Тогда
							ТребуетсяЗаписать = Истина;
							ЭлементСправочника.ВладелецКарты = ВладелецКарты;
						КонецЕсли;
					Иначе
						Если Не ЭлементСправочника[Свойство] = СтрокаТаблицы[Свойство] Тогда 
							ТребуетсяЗаписать = Истина;
							ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы, Свойство);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		ЭлементСправочника = Справочники.ДисконтныеКарты.СоздатьЭлемент();

		УстановитьУИДНового(СтрокаТаблицы, ЭлементСправочника, НастройкиЗагрузкиДанных);

		ИменаПолейНеподлежащихОбновлению = ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СтандартныеИменаПолейНеподлежащихОбновлению(
			НастройкиЗагрузкиДанных);
			
		ЗаполнитьЗначенияСвойств(ЭлементСправочника, СтрокаТаблицы, , ИменаПолейНеподлежащихОбновлению);
		
		ЭлементСправочника.Владелец = ВидКарты;		
		ЭлементСправочника.ВладелецКарты = ВладелецКарты;
	КонецЕсли;						
	
	Если ТребуетсяЗаписать Тогда
		ЭлементСправочника.Заполнить(Неопределено);
		ЭлементСправочника.Записать();

		СтрокаТаблицы.ДисконтнаяКарта = ЭлементСправочника.Ссылка;
	КонецЕсли;
	
	Возврат ЭлементСправочника.Ссылка;

КонецФункции
#КонецОбласти  


#КонецЕсли