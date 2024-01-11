#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимОткрытияОкна") 
		И ЗначениеЗаполнено(Параметры.РежимОткрытияОкна) Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли; 
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			Объект.Сотрудник	= Параметры.Сотрудник;
		КонецЕсли;
		
		// Заполнение нового документа.
		ЗначенияДляЗаполнения = 
			Новый Структура(
				"Организация, 
				|Ответственный, 
				|Месяц",
				"Объект.Организация",
				"Объект.Ответственный",
				"Объект.ПериодРегистрации");
			
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
		
		ПриПолученииДанныхНаСервере();
		
		УстановитьДатуНачалаСобытия();
				
	КонецЕсли;

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка, Объект);
	// Конец КадровыйЭДО
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыРезультатыРасчетаНДФЛ" И Источник.ВладелецФормы = ЭтотОбъект Тогда
		ОбновитьДанныеНДФЛНаСервере(Параметр);
	КонецЕсли;
	
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
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Отпуск", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("ЗаявкиСотрудниковЗаписанДокумент", Объект.Ссылка, ВладелецФормы);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Объект);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
	
	ЗаполнитьДанныеФормыПоОрганизации();
	РассчитатьНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияОсновногоОтпускаПриИзменении(Элемент)
	
	ПриИзмененииПериодаОтпуска();
	ОбновитьКоличествоДнейОсновногоОтпуска(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	ПриИзмененииМесяцаНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцНачисленияПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СреднийЗаработокПриИзменении(Элемент)
	
	РассчитатьНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланируемаяДатаВыплатыПриИзменении(Элемент)
	
	ПересчитатьНДФЛ();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	НачисленияПриОкончанииРедактированияНаСервере();
	
КонецПроцедуры

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

#КонецОбласти


#Область ОбработчикиКомандФормы

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
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура ОткрытьСреднийЗаработок(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьСреднийЗаработокЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Сотрудник", 		Объект.Сотрудник);
	ПараметрыОткрытия.Вставить("Организация", 		Объект.Организация);
	ПараметрыОткрытия.Вставить("ДатаНачалаСобытия", Объект.ДатаНачалаСобытия);
	ПараметрыОткрытия.Вставить("ДокументСсылка", 	Объект.Ссылка);
	ПараметрыОткрытия.Вставить("Сотрудник", 		Объект.Сотрудник);
	
	ДанныеДляРасчетаСреднегоЗаработка = ДанныеДляРасчетаСреднегоЗаработка();
	ПараметрыОткрытия.Вставить("ДанныеОНачислениях", 	ДанныеДляРасчетаСреднегоЗаработка.ДанныеОНачислениях);
	ПараметрыОткрытия.Вставить("ДанныеОВремени", 		ДанныеДляРасчетаСреднегоЗаработка.ДанныеОВремени);
	
	ОткрытьФорму("ОбщаяФорма.ВводДанныхДляРасчетаСреднегоЗаработкаОбщий", ПараметрыОткрытия, ЭтотОбъект, , , ,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодробнееОРасчетеНДФЛ(Команда)
	
	УчетНДФЛКлиент.ОткрытьФормуПодробнееОРасчетеНДФЛ(Объект.Организация, ЭтотОбъект, Объект.ПериодРегистрации, Объект.Сотрудник);
	
КонецПроцедуры

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьФормуОбъекта(Команда)
	
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьФормуОбъекта(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

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

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриИзмененииПериодаОтпуска()
	
	УстановитьДатуНачалаСобытия();
	Если Объект.ДатаНачалаОсновногоОтпуска > Объект.ДатаОкончанияОсновногоОтпуска
		И ЗначениеЗаполнено(Объект.ДатаОкончанияОсновногоОтпуска) Тогда
		
		Объект.ДатаОкончанияОсновногоОтпуска = Объект.ДатаНачалаОсновногоОтпуска;
		
	КонецЕсли; 
	
	УстановитьКоличествоДнейОсновногоОтпуска();
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	Отбор = Новый Структура("КатегорияНачисленияИлиНеоплаченногоВремени", Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска);
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ЗарплатаКадрыДляНебольшихОрганизаций.РасчетЗарплаты") Тогда
		МодульРасчетЗарплатыДляНебольшихОрганизаций = ОбщегоНазначения.ОбщийМодуль("РасчетЗарплатыДляНебольшихОрганизаций");
		МодульРасчетЗарплатыДляНебольшихОрганизаций.ДополнитьОтборНачислений(Отбор, Объект.Организация, Объект.ПериодРегистрации);
	КонецЕсли;
	НачислениеОтпуск = ПланыВидовРасчета.Начисления.НачислениеПоУмолчанию(Отбор);
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "ДатаПриема,Подразделение", Объект.ДатаНачалаОсновногоОтпуска);
	Если КадровыеДанные.Количество() = 0 Тогда
		Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	Иначе
		Подразделение = КадровыеДанные[0].Подразделение;
		ДатаПриемаНаРаботу = КадровыеДанные[0].ДатаПриема;
	КонецЕсли;
			
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	ОбновитьКоличествоДнейОсновногоОтпуска(ЭтотОбъект);
	
	НДФЛ = Объект.НДФЛ.Итог("Налог") + Объект.НДФЛ.Итог("НалогСПревышения");
	
	МесяцСобытия = НачалоМесяца(Объект.ДатаНачалаСобытия);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДатуНачалаСобытия()
	
	Объект.ДатаНачалаСобытия = '00010101';
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаОсновногоОтпуска) Тогда
		Объект.ДатаНачалаСобытия = Объект.ДатаНачалаОсновногоОтпуска;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачалаСобытия) Тогда
		Объект.ДатаНачалаСобытия = Объект.ПериодРегистрации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаНачисления()
	
	УстановитьДатуНачалаСобытия();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКоличествоДнейОсновногоОтпуска()
	
	КоличествоДнейОсновногоОтпуска = РасчетЗарплатыДляНебольшихОрганизаций.КоличествоДнейОтпуска(
		Объект.ДатаНачалаОсновногоОтпуска, Объект.ДатаОкончанияОсновногоОтпуска, Объект.Организация);
	
	Если Объект.КоличествоДнейОсновногоОтпуска <> КоличествоДнейОсновногоОтпуска Тогда
		Объект.КоличествоДнейОсновногоОтпуска = КоличествоДнейОсновногоОтпуска;
		РассчитатьСреднийЗаработокИНачисления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКоличествоДнейОсновногоОтпуска(Форма)
	
	Если ЗначениеЗаполнено(Форма.Объект.КоличествоДнейОсновногоОтпуска) Тогда
		Форма.НадписьДней = НСтр("ru='дн.'");	
	Иначе
		Форма.НадписьДней = "";	
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработчикОжиданияМесяцНачисленияПриИзменении()
	
	УстановитьДатуНачалаСобытия();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "ДатаПриема,Подразделение,ФизическоеЛицо", Объект.ДатаНачалаСобытия);
		Если КадровыеДанные.Количество() > 0 Тогда
			Подразделение = КадровыеДанные[0].Подразделение;
			ФизическоеЛицо = КадровыеДанные[0].ФизическоеЛицо;
			ДатаПриемаНаРаботу = КадровыеДанные[0].ДатаПриема;
		КонецЕсли; 
	
	КонецЕсли;
	
	Объект.ФизическоеЛицо = ФизическоеЛицо;
	МесяцСобытия = '00010101';
	РассчитатьСреднийЗаработокИНачисления();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьНачисления()
	
	Объект.Начисления.Очистить();
	
	ДатаНачала = Объект.ДатаНачалаОсновногоОтпуска;
	ДатаОкончания = Объект.ДатаОкончанияОсновногоОтпуска;
	
	Пока ЗначениеЗаполнено(ДатаНачала) И ДатаНачала <= ДатаОкончания Цикл
		
		СтрокаНачислений = Объект.Начисления.Добавить();
		
		СтрокаНачислений.Начисление = НачислениеОтпуск;
		СтрокаНачислений.Сотрудник = Объект.Сотрудник;
		СтрокаНачислений.Подразделение = Подразделение;
		
		СтрокаНачислений.ДатаНачала = ДатаНачала;
		
		Если КонецМесяца(ДатаНачала) >= ДатаОкончания Тогда
			СтрокаНачислений.ДатаОкончания = ДатаОкончания;
		Иначе
			СтрокаНачислений.ДатаОкончания = КонецМесяца(ДатаНачала);
		КонецЕсли;
		
		СтрокаНачислений.ОплаченоДней = РасчетЗарплатыДляНебольшихОрганизаций.КоличествоДнейОтпуска(
			СтрокаНачислений.ДатаНачала, СтрокаНачислений.ДатаОкончания, Объект.Организация);
		
		СтрокаНачислений.Результат = Объект.СреднийЗаработок * СтрокаНачислений.ОплаченоДней;
		
		РабочихДнейЧасов = РасчетЗарплатыДляНебольшихОрганизаций.РабочихДнейЧасовВПериодеОрганизации(СтрокаНачислений.ДатаНачала, СтрокаНачислений.ДатаОкончания, Объект.Организация);
		Если РабочихДнейЧасов = Неопределено Тогда
			
			СтрокаНачислений.ОтработаноДней = 0;
			СтрокаНачислений.ОтработаноЧасов = 0;
			
		Иначе
			
			СтрокаНачислений.ОтработаноДней = РабочихДнейЧасов.Дней;
			СтрокаНачислений.ОтработаноЧасов = РабочихДнейЧасов.Часов;
			
		КонецЕсли;
		
		ДатаНачала = КонецМесяца(ДатаНачала) + 1;
		
	КонецЦикла;
	
	ПересчитатьНДФЛ();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьНДФЛ()
	
	Объект.НДФЛ.Очистить();
	Объект.ПримененныеВычетыНаДетейИИмущественные.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	
	ОбъектФормы = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект = ОбъектФормы.Скопировать();
	ДокументОбъект.ОбменДанными.Загрузка = Истина;
	ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	
	ДокументОбъект.СформироватьДоходыНДФЛ();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Отпуск.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|ГДЕ
		|	Отпуск.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Запрос.Выполнить();
	
	РезультатРасчетаНДФЛ = УчетНДФЛ.РезультатРасчетаНДФЛ(
		Запрос.МенеджерВременныхТаблиц, Объект.Ссылка, Объект.Организация, Объект.ПериодРегистрации, Ложь, Объект.ПланируемаяДатаВыплаты, ДокументОбъект.Движения);
	
	ОтменитьТранзакцию();
	УстановитьПривилегированныйРежим(Ложь);
	
	Для каждого ДанныеНДФЛ Из РезультатРасчетаНДФЛ.НДФЛ Цикл
		ЗаполнитьЗначенияСвойств(Объект.НДФЛ.Добавить(), ДанныеНДФЛ);
	КонецЦикла;
	
	Для каждого ДанныеВычетов Из РезультатРасчетаНДФЛ.ПримененныеВычетыНаДетейИИмущественные Цикл
		ЗаполнитьЗначенияСвойств(Объект.ПримененныеВычетыНаДетейИИмущественные.Добавить(), ДанныеВычетов);
	КонецЦикла;
	
	НДФЛ = Объект.НДФЛ.Итог("Налог") + Объект.НДФЛ.Итог("НалогСПревышения");
	
	РасчетЗарплатыБазовый.ЗаполнитьКорректировкиВыплаты(Объект, "ПериодРегистрации");
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСреднийЗаработокИНачисления()
	
	Если МесяцСобытия <> НачалоМесяца(Объект.ДатаНачалаСобытия) Тогда
		
		Объект.ОтработанноеВремяДляСреднегоОбщий.Очистить();
		Объект.СреднийЗаработокОбщий.Очистить();
		
		НачалоПериода = ДобавитьМесяц(НачалоМесяца(Объект.ДатаНачалаСобытия), -12);
		НачалоПериода = Макс(НачалоПериода, НачалоМесяца(ДатаПриемаНаРаботу));
		
		ОкончаниеПериода = Макс(НачалоМесяца(Объект.ДатаНачалаСобытия) - 1, НачалоПериода);
		
		ДанныеДляРасчета = РасчетЗарплатыДляНебольшихОрганизаций.ДанныеДляРасчетаОбщегоСреднегоЗаработкаСотрудника(
			Объект.Сотрудник, Объект.Организация, НачалоПериода, ОкончаниеПериода);
		
		Для каждого ДанныеОВремени Из ДанныеДляРасчета.ДанныеОВремени Цикл
			СтрокаДанныхОВремени = Объект.ОтработанноеВремяДляСреднегоОбщий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДанныхОВремени, ДанныеОВремени);
			СтрокаДанныхОВремени.Сотрудник = Объект.Сотрудник;
		КонецЦикла;
		
		Для каждого ДанныеОНачислениях Из ДанныеДляРасчета.ДанныеОНачислениях Цикл
			СтрокаДанныеОНачислениях = Объект.СреднийЗаработокОбщий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДанныеОНачислениях, ДанныеОНачислениях);
			СтрокаДанныеОНачислениях.Сотрудник = Объект.Сотрудник;
		КонецЦикла;
		
		ТаблицыПоСотруднику = Новый Структура;
		ТаблицыПоСотруднику.Вставить("ДанныеОНачислениях", Объект.СреднийЗаработокОбщий);
		ТаблицыПоСотруднику.Вставить("ДанныеОВремени", Объект.ОтработанноеВремяДляСреднегоОбщий);
		
		ПараметрыПолученияДанныхСреднего = РасчетЗарплатыДляНебольшихОрганизаций.ПараметрыПолученияДанныхСреднегоОбщего();
		ПараметрыПолученияДанныхСреднего.Вставить("ТаблицыПоСотруднику", 	ТаблицыПоСотруднику); 
		ПараметрыПолученияДанныхСреднего.Вставить("ДатаНачалаПериода",  	НачалоПериода); 
		ПараметрыПолученияДанныхСреднего.Вставить("ДатаОкончанияПериода",	ОкончаниеПериода); 
		ПараметрыПолученияДанныхСреднего.Вставить("ДатаНачалаСобытия", 		Объект.ДатаНачалаСобытия);
		
		ДанныеРасчетаСреднегоЗаработка = РасчетЗарплатыДляНебольшихОрганизаций.ДанныеРасчетаСреднегоЗаработкаОбщего(ПараметрыПолученияДанныхСреднего);
		
		Объект.СреднийЗаработок = ДанныеРасчетаСреднегоЗаработка.Итоги.СреднедневнойЗаработок;
		
		МесяцСобытия = НачалоМесяца(Объект.ДатаНачалаСобытия);
		
	КонецЕсли; 
	
	РассчитатьНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСреднийЗаработокЗавершение(Знач РезультатРедактирования, Знач ДополнительныеПараметры) Экспорт
	
	Если РезультатРедактирования <> Неопределено Тогда
		ПеренестиДанныеУчетаСреднегоЗаработкаВДокумент(РезультатРедактирования);
		РассчитатьНачисления();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеДляРасчетаСреднегоЗаработка()
	
	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("ДанныеОНачислениях", ПоместитьВоВременноеХранилище(Объект.СреднийЗаработокОбщий.Выгрузить(), УникальныйИдентификатор));
	СтруктураВозврата.Вставить("ДанныеОВремени", ПоместитьВоВременноеХранилище(Объект.ОтработанноеВремяДляСреднегоОбщий.Выгрузить(), УникальныйИдентификатор));
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура ПеренестиДанныеУчетаСреднегоЗаработкаВДокумент(АдресДанныхВХранилище)
	
	ДанныеУчетаСреднегоЗаработка = ПолучитьИзВременногоХранилища(АдресДанныхВХранилище);
	
	Объект.СреднийЗаработок = ДанныеУчетаСреднегоЗаработка.СреднийЗаработок;
	
	Объект.ОтработанноеВремяДляСреднегоОбщий.Очистить();
	ДанныеОВремени = ПолучитьИзВременногоХранилища(ДанныеУчетаСреднегоЗаработка.ДанныеОВремени);
	Если ЗначениеЗаполнено(ДанныеОВремени) Тогда
		
		Для каждого СведенияОВремени Из ДанныеОВремени Цикл
			ЗаполнитьЗначенияСвойств(Объект.ОтработанноеВремяДляСреднегоОбщий.Добавить(), СведенияОВремени);
		КонецЦикла;
		
	КонецЕсли; 
	
	Объект.СреднийЗаработокОбщий.Очистить();
	ДанныеОНачислениях = ПолучитьИзВременногоХранилища(ДанныеУчетаСреднегоЗаработка.ДанныеОНачислениях);
	Если ЗначениеЗаполнено(ДанныеОНачислениях) Тогда
		
		Для каждого СведенияОНачислениях Из ДанныеОНачислениях Цикл
			ЗаполнитьЗначенияСвойств(Объект.СреднийЗаработокОбщий.Добавить(), СведенияОНачислениях);
		КонецЦикла;
		
	КонецЕсли; 
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция СведенияОбНДФЛ(ФизическоеЛицо = Неопределено) Экспорт
	
	ДополнительныеСведения = УчетНДФЛФормы.ДополнительныеДанныеДляПолученияСведенийОДоходахНДФЛДокумента();
	ДополнительныеСведения.МесяцНачисления = Объект.ПериодРегистрации;
	ДополнительныеСведения.ПланируемаяДатаВыплаты = Объект.ПланируемаяДатаВыплаты;
	
	СведенияОДоходахНДФЛ = УчетНДФЛФормы.СведенияОДоходахНДФЛДокумента(Объект, "Начисления", ДополнительныеСведения);	
	АдресСведенийОбНДФЛ = УчетНДФЛФормы.СведенияОбНДФЛ(ЭтотОбъект);
	
	ДанныеОбНДФЛ = ПолучитьИзВременногоХранилища(АдресСведенийОбНДФЛ);
	ДанныеОбНДФЛ.Вставить("СведенияОДоходах", СведенияОДоходахНДФЛ.СведенияОДоходах);
	ДанныеОбНДФЛ.Вставить("ВычетыКДоходам", СведенияОДоходахНДФЛ.ВычетыКДоходам);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбНДФЛ, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция НДФЛПодробнееНаСервере(ФизическиеЛица) Экспорт
	
	Если ТипЗнч(ФизическиеЛица) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическиеЛица);
	Иначе
		СписокФизическихЛиц = ФизическиеЛица;
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	НДФЛПодробнее = Новый Массив;
	НДФЛПодробнее.Добавить(ДокументОбъект.Ссылка);
	НДФЛПодробнее.Добавить(УчетНДФЛФормы.РегистрНалоговогоУчетаПоНДФЛ(ДокументОбъект, Модифицированность, СписокФизическихЛиц, Объект.ПериодРегистрации));
	
	Возврат НДФЛПодробнее;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеНДФЛНаСервере(АдресВременногоХранилища)
	
	Параметр = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Объект.НДФЛ.Загрузить(Параметр.НДФЛ);
	Объект.ПримененныеВычетыНаДетейИИмущественные.Загрузить(Параметр.ПримененныеВычетыНаДетейИИмущественные);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ПриИзмененииПериодаОтпуска();
	ОбновитьКоличествоДнейОсновногоОтпуска(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаСобытия) Тогда
		Объект.ПланируемаяДатаВыплаты = Документы.Отпуск.ПланируемаяДатыВыплатыОтпуска(Объект.ДатаНачалаСобытия, Объект.Организация);
		ПересчитатьНДФЛ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачисленияПриОкончанииРедактированияНаСервере()
	
	ПересчитатьНДФЛ();
	
КонецПроцедуры

// КадровыйЭДО

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодключаемыеКоманды(УправляемаяФорма)
	КадровыйЭДОКлиентСервер.ОбновитьКоманды(УправляемаяФорма, УправляемаяФорма.Объект, Истина);
КонецПроцедуры

// Конец КадровыйЭДО

#КонецОбласти
