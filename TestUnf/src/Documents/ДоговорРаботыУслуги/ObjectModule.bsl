#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыДляНебольшихОрганизацийСобытия.ДокументыПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Дата начала'"), , , Ложь);
	Если ЗначениеЗаполнено(ДатаОкончания) И ДатаОкончания < ДатаНачала Тогда 
		ТекстСообщения = НСтр("ru = 'Дата окончания периода не может быть меньше даты начала'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончания", , Отказ);
	КонецЕсли;
	Если Не ОтразитьТрудовуюДеятельность Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("КодПоОКЗ"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина)
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	ДанныеОПлановыхНачислениях = ДанныеДляПроведения.ПлановыеНачисленияПоДоговорам;
	
	Для Каждого Строка Из ДанныеОПлановыхНачислениях Цикл
		
		Если СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами Тогда
			Движения.УсловияДоговораГПХ.Записывать = Истина;
		    НоваяСтрока = Движения.УсловияДоговораГПХ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.Период = ДатаНачала;
		Иначе
			Движения.ПлановыеНачисленияПоДоговорам.Записывать = Истина;
		    НоваяСтрока = Движения.ПлановыеНачисленияПоДоговорам.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	КадровыйУчет.СформироватьДвиженияДоговоровГПХ(Движения, ДанныеДляПроведения.ПериодыДействияДоговоровГражданскоПравовогоХарактера);
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
	ЭлектронныеТрудовыеКнижки.СформироватьДвиженияМероприятийТрудовойДеятельности(
		Движения.МероприятияТрудовойДеятельности,
		ДанныеДляПроведения.МероприятияТрудовойДеятельности);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает таблицу значений - данные, необходимые для формирования плановых начислений по договорам.
//
Функция ДанныеДляПроведения()
	
	КодДоходаСтраховыеВзносы = УчетСтраховыхВзносов.ВидДоходаДляДоговораНаВыполнениеРабот(ОблагаетсяФСС_НС);
	
	НДФЛДоговорыРаботыУслуги = УчетНДФЛ.ДоходыНДФЛПоВидуОсобыхНачислений(Перечисления.ВидыОсобыхНачисленийИУдержаний.ДоговорРаботыУслуги);
	КодДохода = НДФЛДоговорыРаботыУслуги[0];
	
	ВычетыКДоходам = УчетНДФЛ.ВычетыКДоходам(Год(Дата));
	КодВычета = ВычетыКДоходам[КодДохода][0];
	
	ОписаниеСтатейРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	РасчетыСКонтрагентами = ОписаниеСтатейРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("КодДоходаСтраховыеВзносы", КодДоходаСтраховыеВзносы);
	Запрос.УстановитьПараметр("КодДохода", КодДохода);
	Запрос.УстановитьПараметр("КодВычета", КодВычета);
	Запрос.УстановитьПараметр("РасчетыСКонтрагентами", РасчетыСКонтрагентами);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорРаботыУслуги.Сотрудник КАК Сотрудник,
	|	ДоговорРаботыУслуги.Организация КАК Организация,
	|	ДоговорРаботыУслуги.Ссылка КАК Договор,
	|	&КодДохода КАК КодДохода,
	|	&КодВычета КАК КодВычета,
	|	&КодДоходаСтраховыеВзносы КАК КодДоходаСтраховыеВзносы,
	|	ДоговорРаботыУслуги.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ДоговорРаботыУслуги.ОтношениеКЕНВД КАК ОтношениеКЕНВД,
	|	ДоговорРаботыУслуги.Подразделение КАК Подразделение,
	|	ДоговорРаботыУслуги.Сумма КАК Сумма,
	|	0 КАК СуммаВычета,
	|	ДоговорРаботыУслуги.СуммаЕНВД КАК СуммаЕНВД,
	|	НАЧАЛОПЕРИОДА(ДоговорРаботыУслуги.ДатаОкончания, МЕСЯЦ) КАК МесяцНачисления,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами)
	|			ТОГДА ДоговорРаботыУслуги.ДатаНачала
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДоговорРаботыУслуги.ДатаНачала <= НАЧАЛОПЕРИОДА(ДоговорРаботыУслуги.ДатаОкончания, МЕСЯЦ)
	|					ТОГДА НАЧАЛОПЕРИОДА(ДоговорРаботыУслуги.ДатаОкончания, МЕСЯЦ)
	|				ИНАЧЕ ДоговорРаботыУслуги.ДатаНачала
	|			КОНЕЦ
	|	КОНЕЦ КАК ДатаНачала,
	|	ДоговорРаботыУслуги.ДатаОкончания КАК ДатаОкончания,
	|	&РасчетыСКонтрагентами КАК СтатьяРасходов,
	|	ДоговорРаботыУслуги.Ссылка КАК ДоговорАкт,
	|	ДоговорРаботыУслуги.ДатаОкончания КАК ПланируемаяДатаВыплаты,
	|	ДоговорРаботыУслуги.РазмерПлатежа КАК РазмерЕжемесячногоАвансовогоПлатежа,
	|	ДоговорРаботыУслуги.Дата КАК Период,
	|	ДоговорРаботыУслуги.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.ДоговорРаботыУслуги КАК ДоговорРаботыУслуги
	|ГДЕ
	|	ДоговорРаботыУслуги.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура("ПлановыеНачисленияПоДоговорам,ПериодыДействияДоговоровГражданскоПравовогоХарактера");
	ДанныеДляПроведения.Вставить("ПлановыеНачисленияПоДоговорам", РезультатыЗапроса.Выгрузить());
	
	ПериодыДействияДоговоровГражданскоПравовогоХарактера = Новый Структура;
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Организация", Организация);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Филиал", Организация);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Сотрудник", Сотрудник);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("ДатаНачала", ДатаНачала);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("ДатаОкончания", ДатаОкончания);
	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Вставить("Подразделение", Подразделение);
	
	ДанныеДляПроведения.Вставить("ПериодыДействияДоговоровГражданскоПравовогоХарактера",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПериодыДействияДоговоровГражданскоПравовогоХарактера));
	
	ДанныеДляПроведения.Вставить("МероприятияТрудовойДеятельности",
		Документы.ДоговорРаботыУслуги.ДанныеДляПроведенияМероприятияТрудовойДеятельности(Ссылка).Получить(Ссылка));
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрации = Документы.ДоговорРаботыУслуги.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрации[Ссылка];
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
