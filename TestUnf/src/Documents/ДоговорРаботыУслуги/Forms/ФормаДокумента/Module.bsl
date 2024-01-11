
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимОткрытияОкна") 
		И ЗначениеЗаполнено(Параметры.РежимОткрытияОкна) Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли; 
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Объект.СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ОднократноВКонцеСрока;
		
		ЗначенияДляЗаполнения = 
			Новый Структура(
				"Организация, 
				|Ответственный, 
				|Подразделение", 
				"Объект.Организация", 
				"Объект.Ответственный", 
				"Объект.Подразделение");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
		УстановитьФункциональныеОпцииФормы();
		
		// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
		ЭлектронныеТрудовыеКнижки.ЗаполнитьНаименованиеДокумента(Объект, "ДоговорРаботыУслуги", НСтр("ru = 'Договор'"));
		// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
		УстановитьОтображениеПолейВводаДанныхОТрудовойДеятельности(ЭтотОбъект);
	
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Распределяется = Объект.ОтношениеКЕНВД = Перечисления.ОтношениеКЕНВДЗатратНаЗарплату.ОпределяетсяЕжемесячноПроцентом;
	Если Распределяется Тогда
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВД;
	Иначе
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВДПустая;
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка, Объект);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьДоступностьЭлементаРазмерПлатежа();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьФункциональныеОпцииФормы();
	УстановитьОтображениеПолейВводаДанныхОТрудовойДеятельности(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриЧтенииНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриЧтенииНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, Объект);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
			ЭтотОбъект,
			ТекущийОбъект,
			ПараметрыЗаписи);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Объект);
	// Конец КадровыйЭДО
	
	УстановитьОтображениеПолейВводаДанныхОТрудовойДеятельности(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбработатьИзменениеОрганизацииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ОбработатьИзменениеДатыДокументаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	ЭлектронныеТрудовыеКнижкиКлиентСервер.УстановитьОтображениеНомеровДокумента(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижк
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	Если СотрудникПрежний <> Объект.Сотрудник Тогда
		СотрудникПрежний = Объект.Сотрудник;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтношениеКЕНВДПриИзменении(Элемент)
	ОбработатьИзменениеОтношениеКЕНВД();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеОтношениеКЕНВД()
	Если Не ПолучитьФункциональнуюОпциюФормы("ПлательщикЕНВДЗарплатаКадры") Тогда
		Возврат;
	КонецЕсли;
	
	Распределяется = Объект.ОтношениеКЕНВД = ПредопределенноеЗначение("Перечисление.ОтношениеКЕНВДЗатратНаЗарплату.ОпределяетсяЕжемесячноПроцентом");
	Если Объект.СуммаЕНВД <> 0 И Не Распределяется Тогда
		Объект.СуммаЕНВД = 0;
	КонецЕсли;
	Если Распределяется Тогда
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВД;
	Иначе
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВДПустая;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СуммаЕНВДПриИзменении(Элемент)
	ПроверитьСуммуЕНВД();
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	ПроверитьСуммуЕНВД();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСуммуЕНВД()
	Если Объект.СуммаЕНВД > Объект.Сумма Тогда
		ТекстПредупреждения = НСтр("ru = 'Сумма ЕНВД не может превышать общей суммы вознаграждения по договору.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Объект.СуммаЕНВД = 0;
	КонецЕсли;
КонецПроцедуры

// БлокировкаИзмененияОбъектов
&НаКлиенте
Процедура Подключаемый_РазблокироватьФормуОбъекта(Команда)
	
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьФормуОбъекта(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры
// Конец БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	УстановитьОтображениеПолейВводаДанныхОТрудовойДеятельности(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьТрудовуюДеятельностьПриИзменении(Элемент)
	
	УстановитьОтображениеПолейВводаДанныхОТрудовойДеятельности(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаПриИзменении(Элемент)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаПриИзменении(Объект.Организация, "ДоговорРаботыУслуги", Объект.НаименованиеДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаОбработкаВыбора(
		Объект.НаименованиеДокумента, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
			Команда,
			ЭтотОбъект,
			Объект);
	КонецЕсли;
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ОбновитьПодключаемыеКоманды(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// ЗарплатаКадрыПодсистемы.ПодписиДокументов
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент)
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент)
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

&НаКлиенте
Процедура ВариантОплатыПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементаРазмерПлатежа();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизацииНаСервере()
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеДатыДокументаНаСервере()
	УстановитьФункциональныеОпцииФормы();
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.Дата));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементаРазмерПлатежа()
	Элементы.РазмерПлатежа.Доступность = Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами");
КонецПроцедуры

// КадровыйЭДО
&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодключаемыеКоманды(УправляемаяФорма)
	
	КадровыйЭДОКлиентСервер.ОбновитьКоманды(УправляемаяФорма, УправляемаяФорма.Объект, Истина);
	
КонецПроцедуры
// Конец КадровыйЭДО

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеПолейВводаДанныхОТрудовойДеятельности(УправляемаяФорма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ОтражениеТрудовойДеятельностиГруппа",
		"Видимость",
		Не ЗначениеЗаполнено(УправляемаяФорма.Объект.ДатаОкончания)
			Или УправляемаяФорма.Объект.ДатаОкончания >= ЗарплатаКадрыВызовСервера.ДатаВступленияВСилуНА("ДатаНачалаПриемаЕФС1"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ОтражениеТрудовойДеятельностиДеталиГруппа",
		"Доступность",
		УправляемаяФорма.Объект.ОтразитьТрудовуюДеятельность);
		
	// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	ЭлектронныеТрудовыеКнижкиКлиентСервер.УстановитьОтображениеНомеровДокумента(УправляемаяФорма);
	// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки

КонецПроцедуры

#КонецОбласти

