#Область ПрограммныйИнтерфейс

#Область Локализация

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции);
	ДобавитьРеквизитТекстСостояниеИСМП(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	ДобавитьЭлементыПроверкиПодбораИСМП(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	ДобавитьЭлементыСоответствияТребованиямГИСМТ(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	
	ДобавитьЭлементыСверкиКодовИСМП(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	
КонецПроцедуры

Процедура МодификацияЭлементовФормы(Форма) Экспорт
	
	ПроверкаИПодборПродукцииИСМП.МодификацияЭлементовФормы(Форма);
	СверкаКодовМаркировкиИСМП.МодификацияЭлементовФормы(Форма);
	СоответствиеТребованиямГИСМТ.МодификацияЭлементовФормы(Форма);
	
	СобытияФормИС.ВстроитьСтрокуИнтеграцииВДокументОснованиеПоПараметрам(Форма, "ИСМП.ДокументОснование");
	
КонецПроцедуры

Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	СобытияФормИСМППереопределяемый.ЗаполнениеРеквизитовФормы(Форма);
	ПроверкаИПодборПродукцииИСМП.ЗаполнитьКешШтрихкодовУпаковок(Форма);
	ПроверкаИПодборПродукцииИСМП.ПрименитьКешШтрихкодовУпаковок(Форма);
	ПроверкаИПодборПродукцииИСМП.УправлениеВидимостьюЭлементовПроверкиИПодбора(Форма);
	
	ИмяРеквизитаФормыОбъект = Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП").ИмяРеквизитаФормыОбъект;
	
	Общие = Форма.ПараметрыИнтеграцииГосИС.Получить("ИС.ДокументОснование");
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП.ДокументОснование");
	Если ПараметрыИнтеграции <> Неопределено И ЗначениеЗаполнено(ПараметрыИнтеграции.ИмяРеквизитаФормы) Тогда
		Если ЗначениеЗаполнено(Форма[Общие.ИмяРеквизитаФормы]) Тогда
			Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы].Видимость = Ложь;
		Иначе
			ТекстНадписи = ИнтеграцияИСМПВызовСервера.ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Форма[ИмяРеквизитаФормыОбъект].Ссылка);
			Форма[ПараметрыИнтеграции.ИмяРеквизитаФормы] = ТекстНадписи;
			Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы].Видимость = ЗначениеЗаполнено(ТекстНадписи);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыИнтеграцииСверкиКодов = Форма.ПараметрыИнтеграцииГосИС.Получить("ФормаСверкиИСМП.СостояниеОбменаИСМП");
	ПараметрыИнтгерацииФормыСверкиИСМП = Форма.ПараметрыИнтеграцииГосИС.Получить("ФормаСверкиИСМП");
	ЕстьЭлектронныйДокумент = Ложь;
	Если ПараметрыИнтгерацииФормыСверкиИСМП <> Неопределено Тогда
		ЕстьЭлектронныйДокумент = ПараметрыИнтгерацииФормыСверкиИСМП.Свойство("ЕстьЭлектронныйДокумент") И ПараметрыИнтгерацииФормыСверкиИСМП.ЕстьЭлектронныйДокумент;
		
		Если ПараметрыИнтгерацииФормыСверкиИСМП.ДоступноСогласованиеРасхождений Тогда
			ИмяКомандыРасхожденияПоКодамМаркировки = ПараметрыИнтгерацииФормыСверкиИСМП.ИмяКомандыРасхожденияПоКодамМаркировки;
			КомандаФормыОткрытьФормуСверки = Форма.Команды.Найти(ИмяКомандыРасхожденияПоКодамМаркировки);
			Если КомандаФормыОткрытьФормуСверки <> Неопределено Тогда
				Если Форма[ПараметрыИнтгерацииФормыСверкиИСМП.ИмяРеквизитаФормыТребуетсяОбработкаКодовМаркировки] Тогда
					КомандаФормыОткрытьФормуСверки.Заголовок = ПараметрыИнтгерацииФормыСверкиИСМП.Заголовок + (" (Требуется обработать коды маркировки)");
				Иначе
					КомандаФормыОткрытьФормуСверки.Заголовок = ПараметрыИнтгерацииФормыСверкиИСМП.Заголовок;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	Если ЕстьЭлектронныйДокумент И ПараметрыИнтеграцииСверкиКодов <> Неопределено
		И ЗначениеЗаполнено(ПараметрыИнтеграцииСверкиКодов.ИмяРеквизитаФормы) Тогда
		ТекстНадписи = "";
		СверкаКодовМаркировкиИСМППереопределяемый.ПриОпределенииТекстаНадписиПоляРасхожденияПоРезультатамСверкиКодовМаркировкиИСМП(
			Форма[ИмяРеквизитаФормыОбъект].Ссылка,
			ТекстНадписи);
		ИмяКоманды = ИнтеграцияИСМПКлиентСервер.ИмяКомандыОткрытьФормуСверкиКодовМаркировки("ИСМП");
		ТекстНадписиПоДокументам = Новый ФорматированнаяСтрока(
			ТекстНадписи,
			,
			ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС,
			,
			ИмяКоманды);
		Форма[ПараметрыИнтеграцииСверкиКодов.ИмяРеквизитаФормы] = ТекстНадписиПоДокументам;
		Форма.Элементы[ПараметрыИнтеграцииСверкиКодов.ИмяЭлементаФормы].Видимость = ЗначениеЗаполнено(ТекстНадписиПоДокументам);
	КонецЕсли;
	
	СоответствиеТребованиямГИСМТ.УправлениеВидимостьюЭлеменовСоответствияТребованиямГИСМТ(Форма);
	
КонецПроцедуры

Процедура ОбновитьСтатусыОформления(Ссылка, ПараметрыИнтеграцииГосИС, РеквизитыФормыСтатусовОформления) Экспорт
	
	ПараметрыИнтеграции = ПараметрыИнтеграцииГосИС.Получить("ИСМП.ДокументОснование");
	Если ПараметрыИнтеграции <> Неопределено И ЗначениеЗаполнено(ПараметрыИнтеграции.ИмяРеквизитаФормы) Тогда
		ТекстНадписи = ИнтеграцияИСМПВызовСервера.ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Ссылка);
		РеквизитыФормыСтатусовОформления.Вставить(ПараметрыИнтеграции.ИмяРеквизитаФормы, ТекстНадписи);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	СобытияФормИСМППереопределяемый.ПослеЗаписиНаСервере(Форма);
	
	СоответствиеТребованиямГИСМТ.ПослеЗаписиНаСервере(Форма);
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФормИСМППереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормИСМППереопределяемый.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

// Обработчик команды формы, требующей контекстного вызова сервера.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой выполняется команда.
//   ПараметрыВызова - Структура - параметры вызова.
//   Источник - ТаблицаФормы, ДанныеФормыСтруктура - объект или список формы с полем "Ссылка".
//   Результат - Структура - результат выполнения команды.
//
Процедура ВыполнитьПереопределяемуюКоманду(Знач Форма, Знач ПараметрыВызова, Знач Источник, Результат) Экспорт
	
	СобытияФормИСМППереопределяемый.ВыполнитьПереопределяемуюКоманду(Форма, ПараметрыВызова, Источник, Результат);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормИСМППереопределяемый.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ФормыСписковДокументовИСМП

Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(Форма, Знач ЗначениеПрефиксы = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеПрефиксы = Неопределено Тогда
		Префиксы = Новый Массив;
		Префиксы.Добавить("Оформлено");
		Префиксы.Добавить("КОформлению");
	Иначе
		Если ТипЗнч(ЗначениеПрефиксы) = Тип("Строка") Тогда
			Префиксы = Новый Массив();
			Префиксы.Добавить(ЗначениеПрефиксы);
		Иначе
			Префиксы = ЗначениеПрефиксы;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Значение Из Префиксы Цикл
		Форма.Элементы[Значение + "Организация"].СписокВыбора.Очистить();
		Форма.Элементы[Значение + "Организации"].СписокВыбора.Очистить();
	КонецЦикла;
	
	ПараметрыОтбора = Новый Структура("КлючОбъекта", "ОбщаяФорма.ФормаВыбораСпискаОрганизацийИСМП");
	
	Выборка = ХранилищеНастроекДанныхФорм.Выбрать(ПараметрыОтбора);
	
	Пока Выборка.Следующий() Цикл
		
		Данные = Новый Массив;
		Значение = Выборка.Настройки.Получить("ТаблицаОрганизации");
		Если Значение <> Неопределено Тогда
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Выбрана", Истина);
			НайденныеСтроки = Значение.НайтиСтроки(ПараметрыОтбора);
			
			Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
				Данные.Добавить(СтрокаТЧ.Организация);
			КонецЦикла;
			
			Для Каждого Значение Из Префиксы Цикл
				ЭлементОтбораОрганизация = Форма.Элементы.Найти(Значение + "Организация");
				Если ЭлементОтбораОрганизация <> Неопределено Тогда
					ЭлементОтбораОрганизация.СписокВыбора.Добавить(Данные, СтрСоединить(Данные, "; "));
				КонецЕсли;
		
				ЭлементОтбораОрганизации = Форма.Элементы.Найти(Значение + "Организации");
				Если ЭлементОтбораОрганизации <> Неопределено Тогда
					ЭлементОтбораОрганизации.СписокВыбора.Добавить(Данные, СтрСоединить(Данные, "; "));
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Дорабатывает форму списка документов:
//   * Добавляет необходимые отборы
//   * Скрывает списки к оформлению при необходимости.
//
// Параметры:
//   Форма     - ФормаКлиентскогоПриложения - форма списка документов ИСМП.
//   Настройки - Структура        - (См. ИнтеграцияИС.НастройкиФормыСпискаДокументов).
//             - Неопределено     - будут использованы значения по умолчанию описанные здесь.
//
Процедура ПриСозданииНаСервереФормыСпискаДокументов(Форма, Настройки = Неопределено) Экспорт
	
	Если Настройки = Неопределено Тогда
		Настройки = ИнтеграцияИС.НастройкиФормыСпискаДокументов();
		Настройки.ТипыКОформлению = Метаданные.ОпределяемыеТипы.ДокументыИСМППоддерживающиеСтатусыОформления;
		Настройки.ТипыКОбмену     = Метаданные.ОпределяемыеТипы.ДокументыИСМП;
	КонецЕсли;
	ИнтеграцияИС.ПриСозданииНаСервереФормыСпискаДокументов(Форма, Настройки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции)
	
	ОбщиеНастройки = СобытияФормИС.ОбщиеПараметрыИнтеграции("СобытияФормИСМП");
	ОбщиеНастройки.Вставить("ВидыПродукции", Новый Массив);
	
	ВидыПродукцииИСМП = ИнтеграцияИСКлиентСервер.ВидыПродукцииИСМП(Истина);
	Для Каждого ВидПродукции Из ВидыПродукцииИСМП Цикл
		Если ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ВидПродукции) Тогда
			ОбщиеНастройки.ВидыПродукции.Добавить(ВидПродукции);
		КонецЕсли;
	КонецЦикла;

	ПараметрыИнтеграции.Вставить("ИСМП", ОбщиеНастройки);
	
КонецПроцедуры

// Встраивает реквизит - форматированную строку перехода к ИСМП в прикладные формы
// 
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения - форма в которую происходит встраивание
//   ПараметрыИнтеграции  - Структура        - (См. ПараметрыИнтеграцииИСМП)
//   ДобавляемыеРеквизиты - Массив Из РеквизитФормы - массив реквизитов формы к добавлению
Процедура ДобавитьРеквизитТекстСостояниеИСМП(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	ПараметрыИнтеграцииИСМП = ПараметрыИнтеграцииГиперссылкиИСМП(Форма);
	
	Если ЗначениеЗаполнено(ПараметрыИнтеграцииИСМП.ИмяРеквизитаФормы) Тогда
		ПараметрыИнтеграции.Вставить("ИСМП.ДокументОснование", ПараметрыИнтеграцииИСМП);
		Реквизит = Новый РеквизитФормы(
			ПараметрыИнтеграцииИСМП.ИмяРеквизитаФормы,
			Новый ОписаниеТипов("ФорматированнаяСтрока"),,
			ПараметрыИнтеграцииИСМП.Заголовок);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЭлементыПроверкиПодбораИСМП(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	СтандартнаяОбработка = Истина;
	СобытияФормИСМППереопределяемый.ПриОпределенииПараметровИнтеграции(Форма, СтандартнаяОбработка, ПараметрыИнтеграции);
	Если СтандартнаяОбработка Тогда
		Для Каждого ВидПродукции Из ПараметрыИнтеграции.Получить("ИСМП").ВидыПродукции Цикл
			Если ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции)
				И ПравоДоступа("Использование", Метаданные.Обработки.ПроверкаИПодборТабачнойПродукцииМОТП) Тогда
				ПроверкаИПодборПродукцииИСМП.МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты, ВидПродукции);
			ИначеЕсли ПравоДоступа("Использование", Метаданные.Обработки.ПроверкаИПодборПродукцииИСМП) Тогда
				ПроверкаИПодборПродукцииИСМП.МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты, ВидПродукции);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЭлементыСверкиКодовИСМП(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	СтандартнаяОбработка = Ложь;
	СобытияФормИСМППереопределяемый.ПриОпределенииДоступностиИнтеграцииФормыСверкиКодовМаркировки(Форма, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		Если ПравоДоступа("Использование", Метаданные.Обработки.РезультатыСверкиКодовМаркировкиТОРГ2) Тогда
			СверкаКодовМаркировкиИСМП.МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЭлементыСоответствияТребованиямГИСМТ(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	ВстроитьГиперссылку = Ложь;
	СоответствиеТребованиямГИСМТПереопределяемый.ПередОпределениемПараметровИнтеграции(Форма, ВстроитьГиперссылку);
	
	Если ВстроитьГиперссылку Тогда
		СоответствиеТребованиямГИСМТ.МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции реквизитов ИС МП
//   в прикладные формы конфигураци - потребителя библиотеки ГосИС. Если передана форма - сразу заполняет ее
//   специфику в переопределяемом модуле.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - форма для которой возвращаются параметры интеграции
//
// ВозвращаемоеЗначение:
//   Структура - (См. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования).
//
Функция ПараметрыИнтеграцииГиперссылкиИСМП(Форма = Неопределено)
	
	ПараметрыНадписи = СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования();
	ПараметрыНадписи.Вставить("Ключ",             "ЗаполнениеТекстаДокументаИСМП");
	
	Если Не (Форма = Неопределено) Тогда
		СобытияФормИСМППереопределяемый.ПриОпределенииПараметровИнтеграцииГиперссылкиИСМП(Форма, ПараметрыНадписи);
	КонецЕсли;
	
	Возврат ПараметрыНадписи;
	
КонецФункции

Процедура НастроитьВидПродукцииПриСозданииНаСервере(Форма, ДоступныеВидыПродукции) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, "ВидПродукции") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВидПродукции Из ДоступныеВидыПродукции Цикл
		
		Если ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции, Истина)
			И ИнтеграцияИСМПКлиентСерверПовтИсп.ВестиУчетМаркируемойПродукции(ВидПродукции) Тогда
			Форма.Элементы.ВидПродукции.СписокВыбора.Добавить(ВидПродукции, Строка(ВидПродукции));
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "ВидПродукции")
		И ЗначениеЗаполнено(Форма.Объект.ВидПродукции)
		И Форма.Элементы.ВидПродукции.СписокВыбора.НайтиПоЗначению(Форма.Объект.ВидПродукции) = Неопределено Тогда
		Форма.Элементы.ВидПродукции.СписокВыбора.Добавить(Форма.Объект.ВидПродукции, Строка(Форма.Объект.ВидПродукции));
	КонецЕсли;
	
	Если Форма.Элементы.ВидПродукции.СписокВыбора.Количество() = 1 Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "ВидПродукции") Тогда
			Форма.Объект.ВидПродукции = Форма.Элементы.ВидПродукции.СписокВыбора[0].Значение;
		Иначе
			Форма.ВидПродукции = Форма.Элементы.ВидПродукции.СписокВыбора[0].Значение;
		КонецЕсли;
		Форма.Элементы.ВидПродукции.Видимость = Ложь;
	КонецЕсли;
	
	Форма.Элементы.ВидПродукции.СписокВыбора.СортироватьПоПредставлению();
	
КонецПроцедуры

#КонецОбласти