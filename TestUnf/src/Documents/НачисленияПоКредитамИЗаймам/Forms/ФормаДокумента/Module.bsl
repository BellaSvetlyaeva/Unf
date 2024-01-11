
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидОперацииПриИзмененииНаСервере();
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Компания = Константы.УчетПоКомпании.Компания(Объект.Организация);
	ВидОперацииНачисленияПоКредитам = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиУНФ.ЗаполнитьДополнительныеПараметры(Объект,
		"ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	НаборСвойств_Документ_НачисленияПоКредитамИЗаймам = УправлениеСвойствами.НаборСвойствПоИмени(
		"Документ_НачисленияПоКредитамИЗаймам");
	// Конец СтандартныеПодсистемы.Свойства
	
	// МобильныйКлиент
	МобильныйКлиентУНФ.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	// Конец МобильныйКлиент
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВидОперации = Объект.ВидОперации;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВыбранноеЗначение.Свойство("АдресНачисленийВХранилище") Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьНачисленияИзХранилища(ВыбранноеЗначение.АдресНачисленийВХранилище);
	Модифицированность = Истина;
	
	Если Объект.Начисления.Количество() = 0 Тогда
		СтрокаДляВидаОперации = ?(Объект.ВидОперации = ВидОперацииНачисленияПоКредитам, "кредитам", "займам");
		ТекстПредупреждения = СтрШаблон(НСтр("ru = 'За указанный период выполнять начисления по %1 не требуется'"),
			СтрокаДляВидаОперации);
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ВидОперации.
//
&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если ВидОперации <> Объект.ВидОперации Тогда
		ВидОперации = Объект.ВидОперации;
		
		Объект.Начисления.Очистить();
		
		ВидОперацииПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Номер = "";
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВидОперации. Серверная часть.
//
&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	ВидОперации = Объект.ВидОперации;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам") Тогда
		Элементы.НачисленияКонтрагент.Видимость = Истина;
		Элементы.НачисленияСотрудник.Видимость = Ложь;
	Иначе
		Элементы.НачисленияКонтрагент.Видимость = Ложь;
		Элементы.НачисленияСотрудник.Видимость = Истина;
	КонецЕсли;
	
	НовыйМассив = Новый Массив();
	Если Объект.ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный);
	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидДоговора", Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику);
	КонецЕсли;
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.НачисленияДоговорКредитаИЗайма.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаНачала.
//
&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

// Процедура - обработчик события ПриИзменении реквизита ДоговорКредитаИЗайма табличной части Начисления.
//
&НаКлиенте
Процедура НачисленияДоговорКредитаИЗаймаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		СтруктураРеквизитов = НачисленияДоговорКредитаИЗаймаПриИзмененииНаСервере(ТекущиеДанные.ДоговорКредитаЗайма, Объект.ВидОперации);
		ТекущиеДанные.ВалютаРасчетов = СтруктураРеквизитов.ВалютаРасчетов;
		Если СтруктураРеквизитов.Свойство("Контрагент") И ТекущиеДанные.Контрагент.Пустая() Тогда
			ТекущиеДанные.Контрагент = СтруктураРеквизитов.Контрагент;
		КонецЕсли;
		Если СтруктураРеквизитов.Свойство("Сотрудник") И ТекущиеДанные.Сотрудник.Пустая() Тогда
			ТекущиеДанные.Сотрудник = СтруктураРеквизитов.Сотрудник;
		КонецЕсли;
		ТекущиеДанные.Проект = ПолучитьПроектИзДоговора(ТекущиеДанные.ДоговорКредитаЗайма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НачисленияДоговорКредитаИЗаймаПриИзмененииНаСервере(ДоговорКредитаЗайма, ВидОперации)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ВалютаРасчетов", ДоговорКредитаЗайма.ВалютаРасчетов);
	Если ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоКредитам И
		ДоговорКредитаЗайма.ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.КредитПолученный Тогда
		
		СтруктураРеквизитов.Вставить("Контрагент", ДоговорКредитаЗайма.Контрагент);
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийНачисленияПоКредитамИЗаймам.НачисленияПоЗаймамСотрудникам И
		ДоговорКредитаЗайма.ВидДоговора = Перечисления.ВидыДоговоровКредитаИЗайма.ДоговорЗаймаСотруднику Тогда
		
		СтруктураРеквизитов.Вставить("Сотрудник", ДоговорКредитаЗайма.Сотрудник);
		
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьНачисления(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указана операция.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указана организация.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указано начало периода начислений.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не указан конец периода начислений.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.ДатаОкончания > Объект.ДатаНачала Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Указан неверный период. Дата начала > Даты окончания.'"));
		Возврат;
	КонецЕсли;
	
	АдресНачисленийВХранилище = ПоместитьНачисленияВХранилище();
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("АдресНачисленийВХранилище", АдресНачисленийВХранилище);
	ПараметрыОтбора.Вставить("Организация", Объект.Организация);
	ПараметрыОтбора.Вставить("Регистратор", Объект.Ссылка);
	ПараметрыОтбора.Вставить("ВидОперации", Объект.ВидОперации);
	ПараметрыОтбора.Вставить("ДатаНачала", Объект.ДатаНачала);
	ПараметрыОтбора.Вставить("ДатаОкончания", Объект.ДатаОкончания);
	
	ОткрытьФорму("Документ.НачисленияПоКредитамИЗаймам.Форма.ФормаЗаполнения", ПараметрыОтбора, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", НаборСвойств_Документ_НачисленияПоКредитамИЗаймам);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьНачисленияВХранилище()

	АдресВХранилище = ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(), УникальныйИдентификатор);
	Возврат АдресВХранилище;

КонецФункции

&НаСервере
Процедура ПолучитьНачисленияИзХранилища(АдресНачисленийВХранилище)

	Объект.Начисления.Загрузить(ПолучитьИзВременногоХранилища(АдресНачисленийВХранилище));

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПроектИзДоговора(Договор)

	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорКредитаИЗайма.Проект КАК Проект
	|ИЗ
	|	Документ.ДоговорКредитаИЗайма КАК ДоговорКредитаИЗайма
	|ГДЕ
	|	ДоговорКредитаИЗайма.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Договор);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Проект = РезультатЗапроса.ВыгрузитьКолонку("Проект");
	
	Если Проект.Количество() > 0 Тогда
		Возврат Проект[0];
	КонецЕсли;
	
	Возврат Справочники.Проекты.ПустаяСсылка();
	
КонецФункции // ПолучитьПроектИзДоговора()


#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#КонецОбласти
