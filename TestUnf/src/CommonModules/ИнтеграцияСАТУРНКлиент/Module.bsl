#Область ПрограммныйИнтерфейс

#Область ОбменДанными

// Выполняет подготовку к передаче в сервис САТУРН сообщения по документу и начинает процедуру обмена
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма
//  ПараметрыОбработкиДокументов - (См. ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПараметрыОбработкиДокументов)
//  ОповещениеПриЗавершении - ОписаниеОповещения - Оповещение при завершении операции
Процедура ПодготовитьКПередаче(Форма, ПараметрыОбработкиДокументов, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	ВходящиеДанные = Новый Массив;
	ВходящиеДанные.Добавить(ПараметрыОбработкиДокументов);
	
	РезультатОбмена = ИнтеграцияСАТУРНВызовСервера.ПодготовитьКПередаче(
		ВходящиеДанные,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма, Неопределено, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Выполняет отправку подготовленных сообщений, загрузку новых документов, обработку ответов из САТУРН.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - источник команды выполнения обмена
//  Организация - Неопределено, Массив, ОпределяемыйТип.Организация - Организация или несколько организаций,
//                                                                    по которым необходимо выполнить обмен.
//  ОповещениеПриЗавершении - ОписаниеОповещения - Оповещение при завершении операции.
Процедура ВыполнитьОбмен(Форма, Организация = Неопределено, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	ОрганизацииДляОбменаСАТУРН = Неопределено;
	Если Организация <> Неопределено 
		И Организация.Количество() Тогда
		ОрганизацииДляОбменаСАТУРН = Новый Массив;
		Для Каждого ЭлементКоллекции Из Организация Цикл
			ОрганизацииДляОбменаСАТУРН.Добавить(ЭлементКоллекции.Организация);
		КонецЦикла;
	КонецЕсли;
	
	РезультатОбмена = ИнтеграцияСАТУРНВызовСервера.ВыполнитьОбмен(
		ОрганизацииДляОбменаСАТУРН,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма,, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Отменяет последнюю операцию (например, если возникла ошибка передачи данных).
//
// Параметры:
//   ДокументСсылка - ДокументСсылка - документ, по которому требуется отменить операцию.
//
Процедура ОтменитьПоследнююОперацию(ДокументСсылка) Экспорт
	
	Изменения = ИнтеграцияСАТУРНВызовСервера.ОтменитьПоследнююОперацию(ДокументСсылка);
	
	Если Изменения <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Контекст",                ДокументСсылка);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", Неопределено);
		
		ИнтеграцияСАТУРНСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения,
			ДополнительныеПараметры);
		
	Иначе
		
		ИнтеграцияСАТУРНВызовСервера.ВосстановитьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Операция отмены не может быть выполнена для документа %1 по причине нарушения внутренней структуры хранения данных.
				           |Выполнена операция восстановления статуса по данным протокола обмена.'"),
				ДокументСсылка));
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет неотправленную операцию из очереди передачи данных в САТУРН.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - документ, по которому требуется отменить передачу данных.
//
Процедура ОтменитьПередачу(ДокументСсылка) Экспорт
	
	Изменения = ИнтеграцияСАТУРНВызовСервера.ОтменитьПередачу(ДокументСсылка);
	
	Если Изменения <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Контекст",                ДокументСсылка);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", Неопределено);
		
		ИнтеграцияСАТУРНСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения,
			ДополнительныеПараметры);
		
	Иначе
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Операция отмены не может быть выполнена для документа %1 по причине нарушения внутренней структуры хранения данных.
				           |Выполнена операция восстановления статуса по данным протокола обмена.'"),
				ДокументСсылка));
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОрганизацииДляОбмена(Форма) Экспорт
	
	Возврат ИнтеграцияСАТУРНКлиентСервер.СтруктураОтбораОрганизаций(Форма.ОрганизацииСАТУРН, Неопределено, Ложь).Организации;
	
КонецФункции

#КонецОбласти

#Область РаботаВСпискахДокументов

// Обработчик команд по выполнению требуемого дальнейшего действия в динамических списках.
//
// Параметры:
//  ДинамическийСписок - ТаблицаФормы - список в котором выполняется команда.
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюСАТУРН - действие, которое будет выполнено.
//  Префикс            - Строка - префикс реквизита Организация
Процедура ПодготовитьСообщенияКПередаче(ДинамическийСписок, ДальнейшееДействие, Префикс = "") Экспорт
	
	ОчиститьСообщения();
	
	ДополнительныеПараметры = Новый Структура("ИмяРеквизитаОрганизация", Префикс + "ОрганизацияСАТУРН");
	
	Контекст = ИнтеграцияИСКлиент.СтруктураПодготовкиСообщенийКПередаче(
		ДинамическийСписок, ДальнейшееДействие,
		Новый ОписаниеОповещения("ПодготовитьСообщенияКПередачеЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	
	ИменаКолонокДальнейшиеДействия = Новый Массив;
	ИменаКолонокДальнейшиеДействия.Добавить("ДальнейшееДействие1");
	ИменаКолонокДальнейшиеДействия.Добавить("ДальнейшееДействие2");
	ИменаКолонокДальнейшиеДействия.Добавить("ДальнейшееДействие3");
	ИнтеграцияИСКлиент.ОпределитьДоступностьДействий(
		Контекст, ИменаКолонокДальнейшиеДействия, Префикс + "ОрганизацияСАТУРН");
	
	ИнтеграцияИСКлиент.ПодготовитьСообщенияКПередаче(Контекст);
	
КонецПроцедуры

// Обработчик завершения процедуры ПодготовитьСообщенияКПередаче.
//
// Параметры:
//  Контекст - Структура - контекст выполнения обработчика:
//   * МассивДокументов - массив - список ссылок на обрабатываемые документы,
//   * НепроведенныеДокументы - массив - документы, исключенные из обработки,
//   * ДинамическийСписок - ТаблицаФормы - список в котором выполняется команда,
//   * ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюСАТУРН - действие, которое будет выполнено.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры
Процедура ПодготовитьСообщенияКПередачеЗавершение(Контекст, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	ИмяРеквизитаОрганизация = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ДополнительныеПараметры, "ИмяРеквизитаОрганизация", "ОрганизацияСАТУРН");
	ВходящиеДанные = Новый Массив;
	Для Каждого ДокументСсылка Из Контекст.МассивДокументов Цикл
		
		ПараметрыОбработкиДокументов = ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПараметрыОбработкиДокументов();
		ПараметрыОбработкиДокументов.Ссылка             = ДокументСсылка;
		ПараметрыОбработкиДокументов.ОрганизацияСАТУРН  = Контекст.РеквизитыДокументов[ДокументСсылка][ИмяРеквизитаОрганизация];
		ПараметрыОбработкиДокументов.ДальнейшееДействие = Контекст.ДальнейшееДействие;
		
		ВходящиеДанные.Добавить(ПараметрыОбработкиДокументов);
		
	КонецЦикла;
	
	Форма = Неопределено;
	Если ТипЗнч(Контекст) = Тип("Структура")
		И Контекст.Свойство("ДинамическийСписок")
		И ТипЗнч(Контекст.ДинамическийСписок) = Тип("ТаблицаФормы") Тогда
		Форма = ИнтеграцияИСКлиент.ПолучитьФормуПоЭлементуФормы(Контекст.ДинамическийСписок);
	КонецЕсли;
	
	РезультатОбмена = ИнтеграцияСАТУРНВызовСервера.ПодготовитьКПередаче(
		ВходящиеДанные,
		Форма.УникальныйИдентификатор);
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, Форма, Неопределено);
	
КонецПроцедуры

// Выполняет архивирование документов.
// 
// Параметры:
// 	Результат - КодВозвратаДиалога - Ответ на вопрос архивирования.
// 	ДополнительныеПараметры - Структура - Структура дополнительных параметров.
//
Процедура АрхивироватьДокументы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	Изменения = ИнтеграцияСАТУРНВызовСервера.АрхивироватьДокументы(
		ДополнительныеПараметры.ДокументыКАрхивированию);
	
	Если Изменения <> Неопределено Тогда
		
		ИнтеграцияСАТУРНСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет архивирование распоряжений к оформлению.
// 
// Параметры:
// 	Результат - КодВозвратаДиалога - Ответ на вопрос архивирования.
// 	ДополнительныеПараметры - Структура - Структура дополнительных параметров.
//
Процедура АрхивироватьРаспоряжения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	Изменения = ИнтеграцияСАТУРНВызовСервера.АрхивироватьРаспоряженияКОформлению(
		ДополнительныеПараметры.Распоряжения,
		ДополнительныеПараметры.ПустаяСсылка);
	
	Если Изменения <> Неопределено Тогда
		
		ИнтеграцияСАТУРНСлужебныйКлиент.ПослеЗавершенияОбмена(
			Изменения, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

//Выполняет команду создания документа, с предварительным выбором вида продукции или способа ввода в оборот.
//
Процедура ОткрытьФормуСозданияДокумента(ПолноеИмяДокумента, ДокументОснование = Неопределено, Владелец = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	ИнтеграцияИСКлиент.ОткрытьФормуСозданияДокумента(ПолноеИмяДокумента, ДокументОснование, Владелец, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаВФормахДокументов

#КонецОбласти

#Область ОтборПоОрганизации

Процедура ОткрытьФормуВыбораОрганизаций(Форма, Префикс = Неопределено, Префиксы = Неопределено,
	ОповещениеПриЗавершении = Неопределено,  ПрефиксыСписков = "", ВходящиеПараметры = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ОрганизацииСАТУРН", Форма.ОрганизацииСАТУРН);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",                   Форма);
	ДополнительныеПараметры.Вставить("Префикс",                 Префикс);
	ДополнительныеПараметры.Вставить("Префиксы",                Префиксы);
	ДополнительныеПараметры.Вставить("ПрефиксыСписков",         ПрефиксыСписков);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Если ВходящиеПараметры <> Неопределено Тогда
		Если ВходящиеПараметры.Свойство("РежимБезМестХранения") Тогда
			ПараметрыОткрытияФормы.Вставить("РежимБезМестХранения",  ВходящиеПараметры.РежимБезМестХранения);
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормаВыбораОрганизацийСАТУРН",
		ПараметрыОткрытияФормы,
		Форма,,,,
		Новый ОписаниеОповещения("ПослеЗавершенияВыбораОрганизаций", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

Процедура ПослеЗавершенияВыбораОрганизаций(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьВыборОрганизаций(
		ДополнительныеПараметры.Форма,
		Результат,
		ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено,
		ДополнительныеПараметры.Префикс,
		ДополнительныеПараметры.Префиксы,
		ДополнительныеПараметры.ПрефиксыСписков);
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьВыборОрганизаций(Форма, Результат, ПрименятьОтбор, Префикс = Неопределено, Префиксы = Неопределено, Знач ПрефиксыСписков = "") Экспорт
	
	ИнтеграцияСАТУРНКлиентСервер.НастроитьОтборПоОрганизации(Форма, Результат, Префикс, Префиксы);
	
	Если ПрименятьОтбор Тогда
		ИнтеграцияСАТУРНКлиентСервер.УстановитьОтборыДинамическогоСпискаПоОрганизацииСАТУРН(Форма, ПрефиксыСписков);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Упаковки

Функция ДоступныеТипыИзмеряемыхВеличин(ВходящиеДанные, КэшированныеЗначения = Неопределено) Экспорт
	
	ДоступныеТипыИзмеряемыхВеличин = Новый Массив;
	
	Если ЗначениеЗаполнено(ВходящиеДанные.Партия) Тогда
		РеквизитыПартии = ИнтеграцияСАТУРНВызовСервера.РеквизитыПартии(ВходящиеДанные.Партия, "ТипИзмеряемойВеличиныСАТУРН");
		Если ЗначениеЗаполнено(РеквизитыПартии.ТипИзмеряемойВеличиныСАТУРН) Тогда
			ДоступныеТипыИзмеряемыхВеличин.Добавить(РеквизитыПартии.ТипИзмеряемойВеличиныСАТУРН);
			Возврат ДоступныеТипыИзмеряемыхВеличин;
		КонецЕсли;
	КонецЕсли;
	
	ТипИзмеряемойВеличиныВес   = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Вес");
	ТипИзмеряемойВеличиныОбъем = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличинСАТУРН.Объем");
	
	Если ЗначениеЗаполнено(ВходящиеДанные.Номенклатура) Тогда
		ДанныеУпаковки = ИнтеграцияИСВызовСервера.КоэффициентВесОбъемУпаковки(
			ВходящиеДанные.Номенклатура, ВходящиеДанные.Упаковка, КэшированныеЗначения);
		Если ДанныеУпаковки.Вес > 0 Тогда
			ДоступныеТипыИзмеряемыхВеличин.Добавить(ТипИзмеряемойВеличиныВес);
		КонецЕсли;
		Если ДанныеУпаковки.Объем > 0 Тогда
			ДоступныеТипыИзмеряемыхВеличин.Добавить(ТипИзмеряемойВеличиныОбъем);
		КонецЕсли;
	КонецЕсли;

	Если ДоступныеТипыИзмеряемыхВеличин.Количество() = 0 Тогда
		ДоступныеТипыИзмеряемыхВеличин.Добавить(ТипИзмеряемойВеличиныВес);
		ДоступныеТипыИзмеряемыхВеличин.Добавить(ТипИзмеряемойВеличиныОбъем);
	КонецЕсли;
	
	Возврат ДоступныеТипыИзмеряемыхВеличин;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыФормыПодбораПартий() Экспорт
	
	Результат = Новый Структура;
	// Параметры формы
	Результат.Вставить("РежимВыбора", Истина);
	Результат.Вставить("ЗакрыватьПриВыборе", Ложь);
	// Параметр отбора
	Результат.Вставить("ОрганизацияСАТУРН", ПредопределенноеЗначение("Справочник.КлассификаторОрганизацийСАТУРН.ПустаяСсылка"));
	Результат.Вставить("МестоХранения", ПредопределенноеЗначение("Справочник.МестаХраненияСАТУРН.ПустаяСсылка"));
	// Для выбора партии в строке
	Результат.Вставить("Номенклатура");
	Результат.Вставить("Характеристика");
	Результат.Вставить("Серия");
	Результат.Вставить("Упаковка");
	Результат.Вставить("КоличествоВУпаковкеСАТУРН");
	Результат.Вставить("ТипИзмеряемойВеличины");
	Результат.Вставить("ПАТ");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснования(Форма, Объект,
			Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, СобытиеОбработано = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Форма",  Форма);
	Контекст.Вставить("Объект", Объект);
	Контекст.Вставить("ДокументОснование", Объект.Ссылка);
	Контекст.Вставить("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки);
	Контекст.Вставить("СобытиеОбработано", СобытиеОбработано);
	
	Если Форма.Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Контекст.ДокументОснование) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения(
			"ОбработкаНавигационнойСсылкиВФормеДокументаОснованияЗавершение",
			ЭтотОбъект,
			Контекст);
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ ""%1"" %2. Записать?'"),
			Контекст.ДокументОснование,
			?(НЕ ЗначениеЗаполнено(Контекст.ДокументОснование), НСтр("ru='не записан'"), НСтр("ru='был изменен'")));
		
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВыполнитьКомандуГиперссылкиВФормеДокументаОснования(
			Контекст.ДокументОснование,
			НавигационнаяСсылкаФорматированнойСтроки,
			Форма,
			СобытиеОбработано);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснованияЗавершение(РезультатВопроса, Контекст) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Контекст.Объект.Проведен Тогда
		Если Контекст.Форма.ПроверитьЗаполнение() Тогда
			Контекст.Форма.Записать();
		КонецЕсли;
	Иначе
		Контекст.Форма.Записать();
	КонецЕсли;
	
	Если НЕ Контекст.Форма.Модифицированность И ЗначениеЗаполнено(Контекст.ДокументОснование) Тогда
		
		ВыполнитьКомандуГиперссылкиВФормеДокументаОснования(
			Контекст.ДокументОснование,
			Контекст.НавигационнаяСсылкаФорматированнойСтроки,
			Контекст.Форма,
			Контекст.СобытиеОбработано);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКомандуГиперссылкиВФормеДокументаОснования(ДокументОснование, НавигационнаяСсылкаФорматированнойСтроки, Форма, СобытиеОбработано)
	
	ОписаниеКоманды = ИнтеграцияИСКлиентСервер.ПреобразоватьИмяКомандыНавигационнойСсылкиВоВнутреннийФормат(
		НавигационнаяСсылкаФорматированнойСтроки);
	
	// Открытие протокола обмена
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьПротоколОбмена(ОписаниеКоманды) Тогда
		
		ОткрытьПротоколОбмена(ДокументОснование, Форма);
		
		СобытиеОбработано = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Создание документа
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиСоздатьОбъект(ОписаниеКоманды) Тогда
		
		ПолноеИмяДокумента = ИнтеграцияИСКлиентСервер.ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(ОписаниеКоманды);
		
		ОткрытьФормуСозданияДокумента(ПолноеИмяДокумента, ДокументОснование, Форма);
		СобытиеОбработано = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Открытие документа
	Если ИнтеграцияИСКлиентСервер.ЭтоКомандаНавигационнойСсылкиОткрытьОбъект(ОписаниеКоманды) Тогда
		
		ПолноеИмяДокумента   = ИнтеграцияИСКлиентСервер.ИмяОбъектаДляОткрытияИзВнутреннегоФорматаКомандыНавигационнойСсылки(ОписаниеКоманды);
		ЧастиИмениОбъекта    = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмяДокумента, ".");
		ДокументыПоОснованию = ИнтеграцияСАТУРНВызовСервера.ДокументыСАТУРНПоДокументуОснованию(ДокументОснование);
		МассивДокументов     = ДокументыПоОснованию[ЧастиИмениОбъекта[1]];
		
		Если МассивДокументов.Количество() = 1 Тогда
			ПоказатьЗначение(, МассивДокументов[0].Ссылка);
			СобытиеОбработано = Истина;
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	// Открытие произвольной навигационной ссылки
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
	
	СобытиеОбработано = Истина;
	
КонецПроцедуры

Функция ПараметрыИнтерактивногоВыбораОтбораЗаполнения(ПолноеИмяДокумента, ДокументОснование)
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ИмяФильтра");
	ВозвращаемоеЗначение.Вставить("ОбъектыДляВыбора");
	
	ВозвращаемоеЗначение.ИмяФильтра       = "ЗаполнениеСВидомПродукции";
	ВозвращаемоеЗначение.ОбъектыДляВыбора = ИнтеграцияСАТУРНВызовСервера.ВидыПродукцииДанныхЗаполнения(
		ПолноеИмяДокумента, ДокументОснование);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ОткрытьПротоколОбмена(Документ, Владелец = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура("Документ", Документ);
	
	ОткрытьФорму(
		"Справочник.САТУРНПрисоединенныеФайлы.Форма.ФормаПротоколОбмена",
		ПараметрыФормы,
		Владелец,
		Новый УникальныйИдентификатор,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
