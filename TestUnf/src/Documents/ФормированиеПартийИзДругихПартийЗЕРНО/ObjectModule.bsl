#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Массив")
		И ДанныеЗаполнения.Количество() <> 0
		И ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.РеестрПартийЗЕРНО") Тогда
		
		ЗаполнитьНаОснованииПартий(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнтеграцияЗЕРНОПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товаропроизводитель");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаИзготовления");
		Если Не ПоставитьПартиюНаХранение
			Или ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(ВладелецПартии) = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ВладелецПартии");
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ГодУрожая");
		МассивНепроверяемыхРеквизитов.Добавить("ВладелецПартии");
		Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Товаропроизводитель) = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товаропроизводитель");
		КонецЕсли;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииНаОсновеБумажногоСДИЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МестоположениеКлючАдреса");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("МестоположениеСтрокой");
		МассивНепроверяемыхРеквизитов.Добавить("Партии.НомерПартии");
	КонецЕсли;
	
	Если НазначениеПартии <> ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииВывозСТерриторииРФ") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтранаНазначения");
	КонецЕсли;
	
	Если Не ИнтеграцияЗЕРНОКлиентСервер.ТребуетсяЗаполнениеКодаТНВЭД(НазначениеПартии) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КодТНВЭД");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Количество");
	КонецЕсли;
	
	ВыполнятьПроверкуПотребительскихСвойств = Истина;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ТекущееСостояние = РегистрыСведений.СтатусыОбъектовСинхронизацииЗЕРНО.ТекущееСостояние(Ссылка);
		КонечныеСтатусы = Документы.ФормированиеПартийИзДругихПартийЗЕРНО.КонечныеСтатусы(Ложь);
		Если КонечныеСтатусы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
			ВыполнятьПроверкуПотребительскихСвойств = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьПроверкуПотребительскихСвойств Тогда
		
		ТаблицаОшибок = ПустыеПотребительскиеСвойстваПродукцииПоДокументу();
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке %1 значение потребительского свойства %2 вне допустимого диапазона.'"),
				СтрокаТаблицы.НомерСтроки,
				СтрокаТаблицы.ПотребительскоеСвойство);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"ПотребительскиеСвойства", СтрокаТаблицы.НомерСтроки, "Значение"),, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИнтеграцияЗЕРНОПереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(ВладелецПартии) = 1 Тогда
		ПодразделениеВладельцаПартии = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение");
	КонецЕсли;
	
	Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Товаропроизводитель) = 1 Тогда
		ПодразделениеТоваропроизводителя = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение");
	КонецЕсли;
	
	ИнтеграцияЗЕРНО.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, "Шапка");
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ИнтеграцияЗЕРНО.ЗаписатьСтатусДокументаЗЕРНОПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Партия = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ФормированиеПартийИзДругихПартийЗЕРНО.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиПартийЗЕРНО.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеЗЕРНО.ДанныеЗаполненияФормированиеПартийИзДругихПартийЗЕРНО(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеЗЕРНО.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПартий(ДанныеЗаполнения)

	Если ДанныеЗаполнения.Количество() = 0 Тогда
		
		ТекстОшибки = НСтр("ru = 'Для объединения партий необходимо выбрать партии'");
			
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Количество() > 1 Тогда
		
		Выборка = Документы.ФормированиеПартийИзДругихПартийЗЕРНО.ПартииКоторыеНельзяОбъединить(ДанныеЗаполнения);
		
		Если Выборка.Количество() <> 0 Тогда
			
			Если (ДанныеЗаполнения.Количество() - Выборка.Количество()) < 2  Тогда
				
				ТекстОшибки = Документы.ФормированиеПартийИзДругихПартийЗЕРНО.ПричиныПоКоторымНельзяОбъединитьПартии(Выборка);
				
				ВызватьИсключение ТекстОшибки;
				
			Иначе
				
				ЗаголовокПричин = НСтр("ru = 'Некоторые партии не были добавлены в документ по причинам:'");
				ТекстСообщения = Документы.ФормированиеПартийИзДругихПартийЗЕРНО.ПричиныПоКоторымНельзяОбъединитьПартии(Выборка, ЗаголовокПричин);
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект); 
				
			КонецЕсли; 
			
		КонецЕсли; 
		
		Пока Выборка.Следующий() Цикл
			
			ДанныеЗаполнения.Удалить(ДанныеЗаполнения.Найти(Выборка.Ссылка));
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТекстЗапроса =
	"///////////////////////////////////////////////////////////0
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РеестрПартийЗЕРНО.Ссылка КАК Партия
	|ПОМЕСТИТЬ Партии
	|ИЗ
	|	Справочник.РеестрПартийЗЕРНО КАК РеестрПартийЗЕРНО
	|		
	|ГДЕ
	|	РеестрПартийЗЕРНО.Ссылка В (&Партии)
	|;
	|
	|///////////////////////////////////////////////////////////1
	|ВЫБРАТЬ 
	|	Партии.Партия               КАК Партия,
	|	Партии.Партия.Идентификатор КАК НомерПартии,
	|	ЕСТЬNULL(ОстаткиПартийЗЕРНО.КоличествоЗЕРНООстаток - ОстаткиПартийЗЕРНО.ВОбработкеЗЕРНООстаток, 0) КАК КоличествоЗЕРНО
	|ИЗ
	|	Партии КАК Партии
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиПартийЗЕРНО.Остатки(,Партия В (&Партии)) КАК ОстаткиПартийЗЕРНО
	|		ПО (ОстаткиПартийЗЕРНО.Партия = Партии.Партия)
	|;
	|
	|///////////////////////////////////////////////////////////2
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.Элеватор       КАК Элеватор,
	|	Партии.Партия.ВладелецПартии КАК ВладелецПартии
	|ИЗ
	|	Партии КАК Партии
	|;
	|
	|///////////////////////////////////////////////////////////3
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.ОКПД2                                КАК ОКПД2,
	|	ЕСТЬNULL(КлассификаторНСИЗЕРНО.ВидПродукции, """") КАК ВидПродукции
	|ИЗ
	|	Партии КАК Партии
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторНСИЗЕРНО КАК КлассификаторНСИЗЕРНО
	|		ПО (КлассификаторНСИЗЕРНО.ВидКлассификатора = ЗНАЧЕНИЕ(Перечисление.ВидыКлассификаторовЗЕРНО.ОКПД2))
	|			И Партии.Партия.ОКПД2 = КлассификаторНСИЗЕРНО.Идентификатор
	|;
	|
	|///////////////////////////////////////////////////////////4
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.КодТНВЭД КАК КодТНВЭД
	|ИЗ
	|	Партии КАК Партии
	|;
	|
	|///////////////////////////////////////////////////////////5
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.ГодУрожая КАК ГодУрожая
	|ИЗ
	|	Партии КАК Партии
	|;
	|
	|///////////////////////////////////////////////////////////6
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.НазначениеПартии КАК НазначениеПартии
	|ИЗ
	|	Партии КАК Партии
	|;
	|
	|///////////////////////////////////////////////////////////7
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.ЦельИспользования КАК ЦельИспользования
	|ИЗ
	|	Партии КАК Партии
	|;
	|
	|///////////////////////////////////////////////////////////8
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.Местоположение КАК МестоположениеКлючАдреса
	|ИЗ
	|	Партии КАК Партии
	|;
	|
	|///////////////////////////////////////////////////////////9
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОператорыАдреса.СкладКонтрагент КАК СкладКонтрагент
	|ИЗ
	|	Партии КАК Партии
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РеестрПартийЗЕРНО КАК РеестрПартийЗЕРНО
	|		ПО Партии.Партия = РеестрПартийЗЕРНО.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАдресовЗЕРНО.ОператорыАдреса КАК ОператорыАдреса
	|		ПО ОператорыАдреса.Ссылка = РеестрПартийЗЕРНО.Местоположение
	|;
	|
	|///////////////////////////////////////////////////////////10
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеПартийЗЕРНО.Номенклатура   КАК Номенклатура,
	|	СоответствиеПартийЗЕРНО.Характеристика КАК Характеристика,
	|	СоответствиеПартийЗЕРНО.Серия          КАК Серия
	|ИЗ
	|	Партии КАК Партии
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеПартийЗЕРНО КАК СоответствиеПартийЗЕРНО
	|		ПО СоответствиеПартийЗЕРНО.Партия = Партии.Партия
	|;
	|
	|///////////////////////////////////////////////////////////11
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Партии.Партия.СтранаНазначения КАК СтранаНазначения
	|ИЗ
	|	Партии КАК Партии
	|;";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Партии", ДанныеЗаполнения);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Партии.Добавить();
		
		НоваяСтрока.Партия          = Выборка.Партия;
		НоваяСтрока.НомерПартии     = Выборка.НомерПартии;
		НоваяСтрока.КоличествоЗЕРНО = Выборка.КоличествоЗЕРНО;
		
		КоличествоЗЕРНО = КоличествоЗЕРНО + Выборка.КоличествоЗЕРНО;
		
	КонецЦикла;
	
	Выборка = Результат[2].Выбрать();
	Если Выборка.Следующий()
		И Выборка.Количество() = 1 Тогда
		
		ЗначенияКлючейРеквизитовОрганизаций = Новый Массив;
		Если ЗначениеЗаполнено(Выборка.ВладелецПартии) Тогда
			ЗначенияКлючейРеквизитовОрганизаций.Добавить(Выборка.ВладелецПартии);
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.Элеватор) Тогда
			ЗначенияКлючейРеквизитовОрганизаций.Добавить(Выборка.Элеватор);
		КонецЕсли;
		
		Если ЗначенияКлючейРеквизитовОрганизаций.Количество() Тогда
			
			ЗначенияСопоставлений = Справочники.КлючиРеквизитовОрганизацийЗЕРНО.ОрганизацииКонтрагентыПоКлючам(
				ЗначенияКлючейРеквизитовОрганизаций);
			
			Если ЗначениеЗаполнено(Выборка.Элеватор) Тогда
				
				Если ЗначенияСопоставлений[Выборка.Элеватор] <> Неопределено Тогда
					Организация   = ЗначенияСопоставлений[Выборка.Элеватор].Организация;
					Подразделение = ЗначенияСопоставлений[Выборка.Элеватор].Подразделение;
				КонецЕсли;
				
				ПоставитьПартиюНаХранение = Истина;
				
				Если ЗначенияСопоставлений[Выборка.ВладелецПартии] <> Неопределено Тогда
					Если ЗначениеЗаполнено(ЗначенияСопоставлений[Выборка.ВладелецПартии].Организация) Тогда
						ВладелецПартии = ЗначенияСопоставлений[Выборка.ВладелецПартии].Организация;
						Подразделение  = ЗначенияСопоставлений[Выборка.ВладелецПартии].Подразделение;
					ИначеЕсли ЗначениеЗаполнено(ЗначенияСопоставлений[Выборка.ВладелецПартии].Контрагент) Тогда
						ВладелецПартии = ЗначенияСопоставлений[Выборка.ВладелецПартии].Контрагент;
					КонецЕсли;
				КонецЕсли;
				
			ИначеЕсли ЗначенияСопоставлений[Выборка.ВладелецПартии] <> Неопределено Тогда
				
				Организация   = ЗначенияСопоставлений[Выборка.ВладелецПартии].Организация;
				Подразделение = ЗначенияСопоставлений[Выборка.ВладелецПартии].Подразделение;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для НомерТаблицы = 3 По Результат.ВГраница() Цикл
		
		Выборка = Результат[НомерТаблицы].Выбрать();
		Если Выборка.Следующий()
			И Выборка.Количество() = 1 Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
		
	КонецЦикла;
	
	ПотребительскиеСвойстваПоОКПД2 = ИнтеграцияЗЕРНО.ПотребительскиеСвойстваПродукцииПоДаннымОКПД2(
		ОКПД2, НазначениеПартии);
	Для Каждого ЭлементДанных Из ПотребительскиеСвойстваПоОКПД2 Цикл
		СтрокаТЧ = ПотребительскиеСвойства.Добавить();
		СтрокаТЧ.ПотребительскоеСвойство = ЭлементДанных.ПотребительскоеСвойство;
	КонецЦикла;
	
	ИнтеграцияЗЕРНО.СкопироватьПотребительскиеСвойстваПартии(
		Партии[0].Партия, ПотребительскиеСвойства, ПотребительскиеСвойстваПоОКПД2);
	
	Если ЗначениеЗаполнено(Номенклатура) И КоличествоЗЕРНО > 0 Тогда
		ИнтеграцияЗЕРНОПереопределяемый.ЗаполнитьКоличествоПоКоличествуЗЕРНО(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция ПустыеПотребительскиеСвойстваПродукцииПоДокументу()
	
	ТаблицаПотребительскиеСвойства = ПотребительскиеСвойства.Выгрузить(, "НомерСтроки, ПотребительскоеСвойство, Значение");
	
	НазначениеПотребительскогоСвойства = ИнтеграцияЗЕРНО.НазначениеПотребительскогоСвойстваДаннымПартии(НазначениеПартии);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПотребительскиеСвойства.НомерСтроки             КАК НомерСтроки,
	|	ПотребительскиеСвойства.ПотребительскоеСвойство КАК ПотребительскоеСвойство,
	|	ПотребительскиеСвойства.Значение                КАК Значение
	|ПОМЕСТИТЬ ВТ_ПотребительскиеСвойства
	|ИЗ
	|	&ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|;
	|/////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПотребительскиеСвойства.НомерСтроки                            КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(ПотребительскиеСвойства.ПотребительскоеСвойство) КАК ПотребительскоеСвойство
	|ИЗ
	|	ВТ_ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДопустимыеЗначенияПотребительскихСвойствЗЕРНО КАК ДопустимыеЗначенияПотребительскихСвойствЗЕРНО
	|		ПО (ПотребительскиеСвойства.ПотребительскоеСвойство = ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ПотребительскоеСвойство)
	|		И ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ОКПД2 = &ОКПД2
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.Назначение = &Назначение)
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДействуетПо >= &Дата
	|		ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1))
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.КодСтраны = &КодСтраны)
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ТипЗначения = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенияПотребительскогоСвойстваЗЕРНО.Число)
	|			И (ПотребительскиеСвойства.Значение < ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонС
	|				ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонПо > 0
	|				И ПотребительскиеСвойства.Значение > ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонПо)
	|			ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ТипЗначения = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенияПотребительскогоСвойстваЗЕРНО.Перечисление)
	|				И ПотребительскиеСвойства.Значение = """"
	|				И ВЫРАЗИТЬ(ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДопустимыеЗначения КАК СТРОКА(1)) <> """")";
	
	Запрос.УстановитьПараметр("ОКПД2",                   ОКПД2);
	Запрос.УстановитьПараметр("ПотребительскиеСвойства", ТаблицаПотребительскиеСвойства);
	
	Запрос.УстановитьПараметр("Назначение", НазначениеПотребительскогоСвойства);
	Запрос.УстановитьПараметр("Дата",       ТекущаяУниверсальнаяДата());
	Запрос.УстановитьПараметр("КодСтраны", "RU");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
