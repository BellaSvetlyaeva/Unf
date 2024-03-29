
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ВидыОпераций

// Возвращает значение текущего вида операции.
//
// Параметры:
//  ЭтоВозврат - Булево - признак того, что текущая операция - возврат.
//  ЭтоСкупка - Булево - признак того, что текущая операция - скупка.
//
// Возвращаемое значение:
//  ОпределяемыйТип.ВидОперацииРМК - вид операции для текущей операции.
//
Функция ВидТекущейОперации(ЭтоВозврат = Ложь, ЭтоСкупка = Ложь) Экспорт
	
	ПараметрыВидаОперации = ОбщегоНазначенияРМККлиентСервер.ПараметрыВидаОперации();
	Если ЭтоВозврат Тогда
		ПараметрыВидаОперации.ЭтоВозврат = Истина;
	КонецЕсли;
	Если ЭтоСкупка Тогда
		ПараметрыВидаОперации.ЭтоСкупка = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьВидОперацииЧекаККМ(ПараметрыВидаОперации);
	
	Возврат ПараметрыВидаОперации.ВидОперации;
	
КонецФункции

// Определяет является ли вид операции операцией продажи.
// Значение по умолчанию - истина.
//
// Параметры:
//  ВидОперации - ОпределяемыйТип.ВидОперацииРМК - текущий вид операции.
//
// Возвращаемое значение:
//  Булево - истина, если вид операции - продажа.
//
Функция ЭтоВидОперацииПродажа(ВидОперации) Экспорт
	
	ЭтоПродажа = Истина;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОперацииПродажа(ЭтоПродажа, ВидОперации);
	
	Возврат ЭтоПродажа;
	
КонецФункции

// Определяет является ли вид операции операцией возврат.
// Значение по умолчанию - ложь.
//
// Параметры:
//  ВидОперации - ОпределяемыйТип.ВидОперацииРМК - текущий вид операции.
//
// Возвращаемое значение:
//  Булево - истина, если вид операции - возврат.
//
Функция ЭтоВидОперацииВозврат(ВидОперации) Экспорт
	
	ЭтоВозврат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОперацииВозвратПродажи(ЭтоВозврат, ВидОперации);
	
	Возврат ЭтоВозврат;
	
КонецФункции

// Определяет является ли вид операции операцией скупка.
// Значение по умолчанию - ложь.
//
// Параметры:
//  ВидОперации - ОпределяемыйТип.ВидОперацииРМК - текущий вид операции.
//
// Возвращаемое значение:
//  Булево - истина, если вид операции - скупка.
//
Функция ЭтоВидОперацииСкупка(ВидОперации) Экспорт
	
	ЭтоСкупка = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОперацииСкупка(ЭтоСкупка, ВидОперации);
	
	Возврат ЭтоСкупка;
	
КонецФункции

// Определяет является ли вид операции операцией возврат скупки.
// Значение по умолчанию - ложь.
//
// Параметры:
//  ВидОперации - ОпределяемыйТип.ВидОперацииРМК - текущий вид операции.
//
// Возвращаемое значение:
//  Булево - истина, вид операции - возврат скупки.
//
Функция ЭтоВидОперацииВозвратСкупки(ВидОперации) Экспорт
	
	ЭтоВозвратСкупки = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОперацииВозвратСкупки(ЭтоВозвратСкупки, ВидОперации);
	
	Возврат ЭтоВозвратСкупки;
	
КонецФункции

#КонецОбласти

#Область ВидыОплат

// Проверяет является ли вид оплаты наличной формой оплаты.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является наличной формой оплаты.
//
Функция ЭтоОплатаНаличными(ВидОплаты) Экспорт
	
	ЭтоОплатаНаличными = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыНаличные(ЭтоОплатаНаличными, ВидОплаты);
	
	Возврат ЭтоОплатаНаличными;
	
КонецФункции

// Проверяет является ли вид оплаты - оплата платежной картой.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой платежной картой.
//
Функция ЭтоОплатаПлатежнойКартой(ВидОплаты) Экспорт
	
	ЭтоОплатаПлатежнойКартой = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыПлатежнаяКарта(ЭтоОплатаПлатежнойКартой, ВидОплаты);
	
	Возврат ЭтоОплатаПлатежнойКартой;
	
КонецФункции

// Проверяет является ли вид оплаты - оплата зачетом аванса.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является зачет аванса.
//
Функция ЭтоОплатаЗачетомАванса(ВидОплаты) Экспорт
	
	ЭтоОплатаЗачетАванса = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыЗачетАванса(ЭтоОплатаЗачетАванса, ВидОплаты);
	
	Возврат ЭтоОплатаЗачетАванса;
	
КонецФункции

// Проверяет является ли вид оплаты - безналичная оплата.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является безналичной оплатой.
//
Функция ЭтоОплатаБезналичными(ВидОплаты) Экспорт
	
	ЭтоОплатаБезналичными = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыБезналичные(ЭтоОплатаБезналичными, ВидОплаты);
	
	Возврат ЭтоОплатаБезналичными;
	
КонецФункции

// Проверяет является ли вид оплаты - оплатой в рассрочку.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой в рассрочку.
//
Функция ЭтоОплатаВРассрочку(ВидОплаты) Экспорт
	
	ЭтоОплатаВРассрочку = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыВРассрочку(ЭтоОплатаВРассрочку, ВидОплаты);
	
	Возврат ЭтоОплатаВРассрочку;
	
КонецФункции

// Проверяет является ли вид оплаты - оплатой встречным предоставлением.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой встречным предоставлением.
//
Функция ЭтоОплатаВстречнымПредоставлением(ВидОплаты) Экспорт
	
	ЭтоОплатаВстречнымПредоставлением = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыВстречнымПредоставлением(ЭтоОплатаВстречнымПредоставлением,
		ВидОплаты);
	
	Возврат ЭтоОплатаВстречнымПредоставлением;
	
КонецФункции

// Возвращает вид оплаты "Платежная карта" с привязкой к платежной системе "Сертификат НСПК".
//
// Возвращаемое значение:
//  ОпределяемыйТип.ВидОплатыРМК - вид оплаты платежная карта для НСПК.
//
Функция ВидОплатыПлатежнаяКартаНСПК() Экспорт
	
	ВидОплатыПлатежнаяКартаНСПК = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыПлатежнаяКартаНСПК(ВидОплатыПлатежнаяКартаНСПК);
	
	Возврат ВидОплатыПлатежнаяКартаНСПК;
	
КонецФункции

// Проверяет является ли вид оплаты - оплатой кредитом.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой кредитом.
//
Функция ЭтоОплатаКредитом(ВидОплаты) Экспорт
	
	ЭтоОплатаКредитом = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыКредитом(ЭтоОплатаКредитом,
		ВидОплаты);
	
	Возврат ЭтоОплатаКредитом;
	
КонецФункции

// Проверяет является ли вид оплаты - оплатой подарочным сертификатом.
//
// Параметры:
//  ВидОплаты - ОпределяемыйТип.ВидОплатыРМК - вид оплаты.
//
// Возвращаемое значение:
//  Булево - Истина, если переданный вид оплаты является оплатой подарочным сертификатом.
//
Функция ЭтоОплатаПодарочнымСертификатом(ВидОплаты) Экспорт
	
	ЭтоОплатаПодарочнымСертификатом = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьВидОплатыПодарочнымСертификатом(ЭтоОплатаПодарочнымСертификатом,
		ВидОплаты);
	
	Возврат ЭтоОплатаПодарочнымСертификатом;
	
КонецФункции

#КонецОбласти

#Область Запреты_продаж_ПрограммныйИнтерфейс

// Проверяет наличие актуальных запретов продажи по данным кэша запретов 
//
// Параметры:
//  ВидНоменклатуры - ОпределяемыйТип.ВидНоменклатурыРМК - вид номенклатуры, по  которому
//    проверяется наличие запрета продаж на текущий момент.
//  ОсобенностьУчетаНоменклатуры - ОпределяемыйТип.ОсобенностьУчетаРМК - особенность учета, по которой
//    проверяется наличие запрета продаж на текущий момент.
//  КэшЗапретовПродаж - ДанныеФормыКоллекция - перечень действующих запретов продаж на текущий момент.
//
// Возвращаемое значение:
//  Результат - Структура, либо пустая, либо содержащая запреты продаж:
//		*ВремяНачалаЗапрета - Число - секунды, прошедшие с начала даты начала запрета
//		*ВремяОкончанияЗапрета - Число  - секунды, прошедшие с начала даты окончания запрета
//		*ВидНоменклатуры - ОпределяемыйТип.ВидНоменклатурыРМК - категория, к которой относится запрет.
//
Функция НаличиеЗапретовПродажи(ВидНоменклатуры, ОсобенностьУчетаНоменклатуры, КэшЗапретовПродаж) Экспорт
	
	Возврат ОбщегоНазначенияРМККлиентСервер.НаличиеЗапретовПродажи(ВидНоменклатуры,
		ОсобенностьУчетаНоменклатуры,
		КэшЗапретовПродаж);
	
КонецФункции

// Служит для отражения опосредованного влияния на значение признака использования запретов продаж
// средствами сервера лояльности
//
// Параметры:
//  НовоеЗначениеПризнака - Булево - измененное значение признака;
//  ДополнительныеПараметры - Структура - параметры оповещения
//
Процедура ОповеститьОбИзмененииПризнакаИспользованияПоставляемыхОграниченийПродаж(НовоеЗначениеПризнака,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОповещения = Новый Структура();
	ПараметрыОповещения.Вставить("ИспользоватьОграниченияПродаж", НовоеЗначениеПризнака);
	ПараметрыОповещения.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	Оповестить("ИзмененПризнакИспользованияПоставляемыйОграниченийПродаж", ПараметрыОповещения);
	
КонецПроцедуры
	
#КонецОбласти

#Область ТипыЗначений

// Возвращает значение типа номенклатуры "Товар".
//
// Возвращаемое значение:
//  ОпределяемыйТип.ТипыНоменклатурыРМК, Неопределено - значение типа номенклатуры.
//
Функция ТипНоменклатурыТовар() Экспорт
	
	ТипНоменклатуры = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьТипНоменклатурыТовар(ТипНоменклатуры);
	
	Возврат ТипНоменклатуры;
	
КонецФункции

// Возвращает значение типа номенклатуры "Подарочный сертификат".
//
// Возвращаемое значение:
//  ОпределяемыйТип.ТипыНоменклатурыРМК, Неопределено - значение типа номенклатуры.
//
Функция ТипНоменклатурыПодарочныйСертификат() Экспорт
	
	ТипНоменклатуры = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьТипНоменклатурыПодарочныйСертификат(ТипНоменклатуры);
	
	Возврат ТипНоменклатуры;
	
КонецФункции

// Возвращает значение особенности учета номенклатуры "Алкоголь".
//
// Возвращаемое значение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК, Неопределено - значение особенности учета номенклатуры.
//
Функция ОсобенностьУчетаАлкоголь() Экспорт
	
	ОсобенностьУчета = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьОсобенностьУчетаАлкоголь(ОсобенностьУчета);
	
	Возврат ОсобенностьУчета;
	
КонецФункции

// Возвращает значение особенности учета номенклатуры "ГИСМ".
//
// Возвращаемое значение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК, Неопределено - значение особенности учета номенклатуры.
//
Функция ОсобенностьУчетаГИСМ() Экспорт
	
	ОсобенностьУчета = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьОсобенностьУчетаГИСМ(ОсобенностьУчета);
	
	Возврат ОсобенностьУчета;
	
КонецФункции

// Возвращает значение особенности учета номенклатуры "Табак".
//
// Возвращаемое значение:
//  ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК, Неопределено - значение особенности учета номенклатуры.
//
Функция ОсобенностьУчетаТабак() Экспорт
	
	ОсобенностьУчета = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ОпределитьОсобенностьУчетаТабак(ОсобенностьУчета);
	
	Возврат ОсобенностьУчета;
	
КонецФункции

#КонецОбласти

#Область Пакетная_фискализация_ПрограммныйИнтерфейс

// Расширение возможности проверки условия выполнения пакетной фискализации
//
// Параметры:
//  ВозможнаВыдачаНаличных - Булево - исходное значение признака.
//  КонтекстПроверки - Структура:
//    * ДанныеТерминала - ДанныеФормыЭлементКоллекции (см. ФормаРМК.ТаблицаТерминалы).
//    * КонтекстФормы - ФормаКлиентскогоПриложения.
//
Процедура ПроверитьДополнительныеУсловияВыполненияВыдачиНаличных(ВозможнаВыдачаНаличных, КонтекстПроверки) Экспорт
	ОбщегоНазначенияРМККлиентПереопределяемый.
		ПроверитьДополнительныеУсловияВыполненияВыдачиНаличных(ВозможнаВыдачаНаличных, КонтекстПроверки);
КонецПроцедуры

#КонецОбласти

#Область Печать_заявления_на_возврат_ПрограммныйИнтерфейс

// Структура строки для формирования печатной формы заявления на возврат
// Возвращаемое значение:
//  Результат - Структура:
//   *Номер - Строка.
//   *Номенклатура - Строка.
//   *Количество - Число.
//   *ПредставлениеЕдиницыИзмерения - Строка.
//   *Сумма - Число.
//
Функция СтрокаЗаявленияНаВозврат() Экспорт

	Результат = Новый Структура();
	Результат.Вставить("Номер", НСтр("ru = ''") );
	Результат.Вставить("Номенклатура", НСтр("ru = ''"));
	Результат.Вставить("Количество", 0);
	Результат.Вставить("ПредставлениеЕдиницыИзмерения", НСтр("ru = ''"));
	Результат.Вставить("Сумма", 0);

	Возврат Результат;
	
КонецФункции

// Структура заявления на возврат для формирования печатной формы 
//
// Возвращаемое значение:
//  Результат - Структура:
//   * Товары - Массив.
//   * ФИОПокупателя - Строка.
//   * ДатаРождения - Дата.
//   * УдостоверениеЛичности - Строка.
//   * СуммаДокумента - Число.
//   * ЧекПродажи - ОпределяемыйТип.ЧекККМРМК, Неопределено.
//   * Магазин - ОпределяемыйТип.ТорговыйОбъектРМК, Неопределено.
//   * ЧекНомер - Число.
//   * ЧекДата - Дата.
//   * Кому - Строка.
//   * ФИОРуководителя - Строка.
//   * ОтКого - Строка.
//   * Дата - Дата.
//
Функция СтруктураЗаявленияНаВозврат() Экспорт

	Результат = Новый Структура;
	
	Результат.Вставить("Товары", Новый Массив());
	Результат.Вставить("ФИОПокупателя", НСтр("ru = ''") );
	Результат.Вставить("ДатаРождения", Дата(1,1,1));
	Результат.Вставить("УдостоверениеЛичности", НСтр("ru = ''"));
	Результат.Вставить("СуммаДокумента", 0);
	Результат.Вставить("ЧекПродажи", Неопределено);
	Результат.Вставить("Магазин", Неопределено);
	Результат.Вставить("ЧекНомер", 0);
	Результат.Вставить("ЧекДата", Дата(1,1,1));
	Результат.Вставить("Кому", НСтр("ru = ''"));
	Результат.Вставить("ФИОРуководителя", НСтр("ru = ''"));
	Результат.Вставить("ОтКого", НСтр("ru = ''"));
	Результат.Вставить("Дата", Дата(1, 1, 1));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Печать_товарного_чека_ПрограммныйИнтерфейс

// Устарела. Следует использовать ОбщегоНазначенияРМККлиентПереопределяемый.СформироватьПечатнуюФормуТоварногоЧека.
// Возвращает параметры для передачи в ОбщаяФорма.ПечатьДокументов
//
// Параметры:
//  ЧекККМ - ОпределяемыйТип.ЧекККМРМК
//
// Возвращаемое значение:
//  ПараметрыОткрытия - Структура:
//		* ИмяМенеджераПечати - Строка.
//		* ИменаМакетов - Строка.
//		* ПараметрКоманды - Массив из ОпределяемыйТип.ЧекККМРМК.
//		* ПараметрыПечати - Строка.
//
Функция ПараметрыОткрытияФормыПечатиДокументовДляТоварногоЧека(ЧекККМ) Экспорт

	СтандартнаяОбработка = Истина;
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПараметрыОткрытияФормыПечатиДокументовДляТоварногоЧека(ЧекККМ,
		ПараметрыОткрытия, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		МассивЧековККМ = Новый Массив;
		МассивЧековККМ.Добавить(ЧекККМ);
		
		ПараметрыОткрытия.ИмяМенеджераПечати = "Документ.ЧекККМ";
		ПараметрыОткрытия.ИменаМакетов = "ТоварныйЧек";
		ПараметрыОткрытия.ПараметрКоманды = МассивЧековККМ;
		ПараметрыОткрытия.ПараметрыПечати = Неопределено;
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

// Устарела. Следует использовать ОбщегоНазначенияРМККлиентПереопределяемый.СформироватьПечатнуюФормуЗаказаПокупателя.
// Возвращает параметры для передачи в ОбщаяФорма.ПечатьДокументов
//
// Параметры:
//  ЧекККМ - ОпределяемыйТип.ЧекККМРМК
//
// Возвращаемое значение:
//  ПараметрыОткрытия - Структура:
//		* ИмяМенеджераПечати - Строка.
//		* ИменаМакетов - Строка.
//		* ПараметрКоманды - Массив из ОпределяемыйТип.ЧекККМРМК.
//		* ПараметрыПечати - Строка.
//
Функция ПараметрыОткрытияФормыПечатиДокументовДляЗаказа(Заказ) Экспорт

	СтандартнаяОбработка = Истина;
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	
	Если СтандартнаяОбработка Тогда
		
		МассивЧековККМ = Новый Массив;
		МассивЧековККМ.Добавить(Заказ);
		
		ПараметрыОткрытия.ИмяМенеджераПечати = "Документ.ЗаказПокупателя";
		ПараметрыОткрытия.ИменаМакетов = "Заказ";
		ПараметрыОткрытия.ПараметрКоманды = МассивЧековККМ;
		ПараметрыОткрытия.ПараметрыПечати = Неопределено;
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти

#Область Печать_РасшифровокОтчетов

// Выводит на экран расшифровку отчета за смену.
//
// Параметры:
//  ДанныеРасшифровки - Структура.
//  	*ИмяРаздела - Строка. Имя раздела ошибок чеков,
//      *МассивЧеков - Массив. Массив структур с ошибочными чеками и текстом ошибки.
//  Форма - ФормаКлиентскогоПриложения - родительская форма печати документов. 
//
Процедура ВывестиРасшифровкуОтчетаЗаСмену(ДанныеРасшифровки, Форма) Экспорт
	
	ТабличныйДокументРасшифровка = ОбщегоНазначенияРМКВызовСервера.СформироватьРасшифровкуОтчетаЗаСмену(ДанныеРасшифровки);
	ПредставлениеОтчета = НСтр("ru='Расшифровка ошибочных чеков'");
	ПараметрыОткрытия = Новый Структура("ПереданныйТабличныйДокумент,ПредставлениеОтчета", ТабличныйДокументРасшифровка, ПредставлениеОтчета);
	ОткрытьФорму("Обработка.РабочееМестоКассира.Форма.ФормаПечатногоДокумента", ПараметрыОткрытия, Форма, Форма.УникальныйИдентификатор);
	
КонецПроцедуры	

#КонецОбласти	

#Область Локализация

// Возвращает представление валюты.
//
// Возвращаемое значение:
//  Строка - представление валюты.
//
Функция ПредставлениеВалюты() Экспорт
	
	ПредставлениеВалюты = НСтр("ru = 'руб.'");
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПредставлениеВалюты(ПредставлениеВалюты);
	
	Возврат ПредставлениеВалюты;
	
КонецФункции

#КонецОбласти

#Область ПлиточныйИнтерфейсПодбораТоваров

// Вызывает интерфейс для подбора номенклатуры
//
// Параметры:
//  ЭтотОбъект - ФормаКлиентскогоПриложения - форма элемента структуры плиточного интерфейса.
//  Параметры - Структура - параметры открытия формы.
//  ОповещениеОВыборе - ОписаниеОповещения - описание оповещения о завершении подбора.
//
Процедура ОткрытьИнтерфейсПодбораНоменклатуры(ЭтотОбъект, Параметры, ОповещениеОВыборе) Экспорт
	ОбщегоНазначенияРМККлиентПереопределяемый.ОткрытьИнтерфейсПодбораНоменклатуры(ЭтотОбъект, Параметры,
		ОповещениеОВыборе);
КонецПроцедуры

// Переопределяет заполнение параметров открытия формы подбора товаров в состав палитры.
//
// Параметры:
//  Параметры - Структура - параметры открытия формы.
//
Процедура ЗаполнитьПараметрыОткрытияФормыПодбораВСоставПалитрыТоваров(Параметры) Экспорт
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПараметрыОткрытияФормыПодбораВСоставПалитрыТоваров(Параметры);
КонецПроцедуры

// Формирует имя элемента в строке состава палитры
//
// Параметры:
//  СтрокаСостава - ДанныеФормыЭлементДерева - Строка состава палитры.
//
Процедура ЗаполнитьИмяЭлементаВСтрокеСоставаПалитры(СтрокаСостава) Экспорт
	
	Если Не СтрокаСостава = Неопределено Тогда
		ИмяЭлемента = СтрШаблон(НСтр("ru = '%1 %2 %3'"),
			СтрокаСостава.Номенклатура, СтрокаСостава.Характеристика, СтрокаСостава.Упаковка);
		СтрокаСостава.ИмяЭлемента = СокрЛП(ИмяЭлемента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
//
Процедура ПередНачаломРаботыСистемы() Экспорт
	
	ИсходныеПараметры = Новый Структура;
	ИсходныеПараметры.Вставить("ПараметрЗапуска", ПараметрЗапуска);
	ПараметрыРаботыКлиента = ОбщегоНазначенияРМКВызовСервера.ЗаполнитьПараметрыПриЗапускеКлиента(ИсходныеПараметры);
	
	Если ПараметрыРаботыКлиента.Свойство("ЗапуститьНовыйРМК") И ПараметрыРаботыКлиента.ЗапуститьНовыйРМК Тогда
		КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимОсновногоОкнаКлиентскогоПриложения.РабочееМесто);
		КлиентскоеПриложение.УстановитьОтображениеЗаголовкаОС(Ложь);
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("РежимКассыСамообслуживания")
		И ПараметрыРаботыКлиента.РежимКассыСамообслуживания Тогда
		КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимОсновногоОкнаКлиентскогоПриложения.Киоск);
		КлиентскоеПриложение.УстановитьОтображениеЗаголовкаОС(Ложь);
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("НеобходимоОбновитьИнтерфейс")
		И ПараметрыРаботыКлиента.НеобходимоОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

// Открывает настройки синхронизации данных.
//
Процедура ОткрытьНастройкиСинхронизацииДанных() Экспорт
	ОткрытьФорму("ОбщаяФорма.НастройкиСинхронизацииДанных");
КонецПроцедуры

// Процедура открывает рабочее место кассира.
//
Процедура ОткрытьРабочееМестоКассира() Экспорт
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьРабочееМестоКассира", ЭтотОбъект);
	ОткрытьФорму("Обработка.РабочееМестоКассира.Форма.ФормаРМК", , , , , , ОбработчикОповещения);
	
КонецПроцедуры

// Возвращает данные текущего эквайрингового терминала.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма рабочего места кассира.
//
// Возвращаемое значение:
//  Массив - данные эквайрингового терминала.
//
Функция ДанныеТекущегоЭквайринговогоТерминала(Форма) Экспорт
	
	ДанныеЭТ = Неопределено;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьДанныеТекущегоЭквайринговогоТерминала(Форма, ДанныеЭТ);
	
	Возврат ДанныеЭТ;
	
КонецФункции

// Проверяет наличие ошибок при заполнении данных карты лояльности на форме РМК.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма рабочего места кассира.
//  ЕстьОшибки - Булево - признак наличия ошибок.
//
Процедура ПроверитьОшибкиЗаполненияКартыЛояльности(Форма, ЕстьОшибки) Экспорт
	
	СтандартнаяОбработка = Истина;
	ОбщегоНазначенияРМККлиентПереопределяемый.ПроверитьОшибкиЗаполненияКартыЛояльности(Форма,
		ЕстьОшибки,
		СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПояснения = "";
	ИменаНезаполненныхПолей = НСтр("ru = ''");
	
	Если НЕ ЗначениеЗаполнено(Форма.НоваяКартаНомер) Тогда
		
		ТекстШаблон = НСтр("ru = '%1""Номер карты"" %2'");
		ИменаНезаполненныхПолей = СтрШаблон(ТекстШаблон, ИменаНезаполненныхПолей, Символы.ПС);
		
	Иначе
		
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(Форма.НоваяКартаНомер, Ложь, "1234567890") Тогда
			ТекстПояснения = ТекстПояснения
				+ НСтр("ru = 'Доступные символы поля ""Номер карты"" - цифры и латинские буквы'") + Символы.ПС;
		КонецЕсли;
			
	КонецЕсли;
	
	ЭтоИменнаяКарта = Истина;
	Если ЗначениеЗаполнено(Форма.НоваяКартаВидКарты) Тогда
		ДанныеВидаКарты = Форма.ДанныеВидаКарты(Форма.НоваяКартаВидКарты); 
		Если ЗначениеЗаполнено(ДанныеВидаКарты.Идентификатор) Тогда
			ЭтоИменнаяКарта = ДанныеВидаКарты.ЭтоИменнаяКарта;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Форма.НоваяКартаТелефон) И (ЭтоИменнаяКарта ИЛИ Форма.ОтправлятьSMSКодПриЗаведенииКарты) Тогда
		
		ТекстШаблон = НСтр("ru = '%1""Телефон"" %2'");
		ИменаНезаполненныхПолей = СтрШаблон(ТекстШаблон, ИменаНезаполненныхПолей, Символы.ПС);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Форма.НоваяКартаФИО) И ЭтоИменнаяКарта Тогда
		
		ТекстШаблон = НСтр("ru = '%1""Имя и фамилия"" %2'");
		ИменаНезаполненныхПолей = СтрШаблон(ТекстШаблон, ИменаНезаполненныхПолей, Символы.ПС);
		
	КонецЕсли;
	
	МассивЦифрДаты = ИнтерфейсРМКСлужебныйКлиентСервер.СформироватьМассивЦифрДаты(Форма.НоваяКартаДатаРождения);
	Если Не (ИнтерфейсРМКСлужебныйКлиентСервер.МассивЦифрПустой(МассивЦифрДаты)
		Или ИнтерфейсРМКСлужебныйКлиентСервер.МассивЦифрЗаполненПолностью(МассивЦифрДаты)) Тогда
			ТекстПояснения = ТекстПояснения
				+ НСтр("ru = 'Неверно указана дата рождения клиента. Пожалуйста, введите корректные данные.'") + Символы.ПС;
	КонецЕсли;
	
	Если НЕ (ПустаяСтрока(ТекстПояснения) И ПустаяСтрока(ИменаНезаполненныхПолей)) Тогда
		
		Если НЕ ПустаяСтрока(ИменаНезаполненныхПолей) Тогда
			
			ТекстШаблон = НСтр("ru = 'Пожалуйста, заполните следующие поля: %1%2'");
			ТекстПояснения = СтрШаблон(ТекстШаблон, Символы.ПС, ИменаНезаполненныхПолей);
			
		КонецЕсли;
		ИнтерфейсРМКСлужебныйКлиент.УстановитьТекстДекорацииОПерсональныхДанных(Форма.Элементы.ДекорацияТекстОПерсональныхДанных, ТекстПояснения);
		ЕстьОшибки = Истина;
		
	КонецЕсли;
	
	Если Не ЕстьОшибки Тогда
		
		НомерТелефонаНовогоКлиента = ОбщегоНазначенияРМККлиентСервер.ПодготовитьНомерТелефона(Форма.НоваяКартаТелефон);
		
		НомерТелефонаВведенКорректно = ЗначениеЗаполнено(НомерТелефонаНовогоКлиента) ИЛИ НЕ ЭтоИменнаяКарта;
		
		ПроверятьАдресЭлектроннойПочты = ЗначениеЗаполнено(Форма.НоваяКартаПочта);
		АдресЭлектроннойПочтыВведенКорректно = Истина;
		
		Если ПроверятьАдресЭлектроннойПочты Тогда
			
			АдресЭлектроннойПочтыВведенКорректно =
				ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Форма.НоваяКартаПочта);
			
			Если НЕ АдресЭлектроннойПочтыВведенКорректно Тогда
				Форма.НоваяКартаПочта = НСтр("ru = ''");
			КонецЕсли;
			
		КонецЕсли;
		
		АдресЭлектроннойПочтыВведенКорректно = Не ПроверятьАдресЭлектроннойПочты ИЛИ АдресЭлектроннойПочтыВведенКорректно;
		
		ПредставлениеНоваяКартаТелефон = НСтр("ru = ''");
		Если НомерТелефонаВведенКорректно Тогда
			
			ТекстШаблон = НСтр("ru = '+%1'");
			ПредставлениеНоваяКартаТелефон = СтрШаблон(ТекстШаблон, НомерТелефонаНовогоКлиента);
			
		КонецЕсли;
		
		Если НЕ (НомерТелефонаВведенКорректно И АдресЭлектроннойПочтыВведенКорректно) Тогда
			
			ТекстПредупреждения =
				НСтр("ru = 'Неверно указан номер телефона и/или email в данных клиента. Пожалуйста, введите корректные данные.'");
			ИнтерфейсРМКСлужебныйКлиент.УстановитьТекстДекорацииОПерсональныхДанных(Форма.Элементы.ДекорацияТекстОПерсональныхДанных, ТекстПредупреждения);
			ЕстьОшибки = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак необходимости заполнения контрагента при операциях предоплаты и зачете авансов.
//
// Возвращаемое значение:
//  Булево - Истина, если необходимо запретить операции без контрагента.
//
Функция ЗапрещенаПредоплатаБезКонтрагента() Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ПроверитьНеобходимостьЗаполненияКонтрагента(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак использования в конфигурации внешнего события при получении данных с торгового оборудования.
//
// Возвращаемое значение:
//  Булево - Истина, если будет использоваться внешнее событие.
//
Функция ИспользоватьВнешнееСобытие() Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПризнакИспользованияВнешнегоСобытия(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак будет ли использоваться стандартный интерфейс внесения ДС.
//
// Возвращаемое значение:
//  Булево - Истина, если будет использоваться стандартный интерфейс внесения ДС.
//
Функция ИспользоватьСтандартныйИнтерфейсВнесения() Экспорт
	
	Результат = Истина;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПризнакСтандартныйИнтерфейсВнесения(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак будет ли использоваться запрос бонусов локально (без использования сервера лояльности).
//
// Возвращаемое значение:
//  Булево - Ложь, если будет использоваться запрос бонусов используя сервер лояльности.
//
Функция ИспользоватьЗапросБонусовЛокально() Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПризнакИспользоватьЗапросБонусовЛокально(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак будет ли использоваться поиск подарочного
// Сертификата локально (без использования сервера лояльности).
//
// Возвращаемое значение:
//  Булево - Ложь, если будет использоваться запрос сертификата используя сервер лояльности.
//
Функция ИспользоватьПоискСертификатаЛокально() Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПризнакИспользоватьПоискСертификатаЛокально(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак будет ли использоваться поиск промокода
// Локально (без использования сервера лояльности).
//
// Возвращаемое значение:
//  Булево - Ложь, если будет использоваться запрос промокода используя сервер лояльности.
//
Функция ИспользоватьПоискПромокодаЛокально() Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПризнакИспользоватьПоискПромокодаЛокально(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак, от которого зависит где будет создаваться карта лояльности.
// Значение по умолчанию - Ложь, карта лояльности будет создана в сервисе лояльности.
//
// Возвращаемое значение:
//  Булево - Истина, если используется локальное создание карт лояльности.
//
Функция СоздаватьЛокальноКартуЛояльности() Экспорт
	
	Результат = Ложь;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьПризнакСоздаватьЛокальноКартуЛояльности(Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные текущих эквайринговых терминалов.
// Поиск терминалов происходит в реквизите "ТаблицаТерминалы" формы рабочего места кассира.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма рабочего места кассира.
//
// Возвращаемое значение:
//  Массив - данные текущих эквайринговых терминалов.
//
Функция ДанныеТекущихЭквайринговыхТерминалов(Форма) Экспорт
	
	Результат = Новый Массив;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьДанныеТекущихЭквайринговыхТерминалов(Форма, Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные текущих эквайринговых терминалов с отбором по организации.
// Поиск терминалов происходит в реквизите "ТаблицаТерминалы" формы рабочего места кассира.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма рабочего места кассира.
//  Организация - ОпределяемыйТип.ОрганизацияРМК - организация отбора.
//
// Возвращаемое значение:
//  Массив - данные текущих эквайринговых терминалов.
//
Функция ДанныеТекущихЭквайринговыхТерминаловПоОрганизации(Форма, Организация) Экспорт
	
	Результат = Новый Массив;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьДанныеТекущихЭквайринговыхТерминаловПоОрганизации(Форма, Организация, Результат);
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные оплат картой по отложенному чеку.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма рабочего места кассира.
//
// Возвращаемое значение:
//  Массив - данные текущих эквайринговых терминалов.
//
Функция ДанныеОплатКартойПоЧеку(Форма) Экспорт
	
	Результат = Новый Массив;
	ОбщегоНазначенияРМККлиентПереопределяемый.ЗаполнитьДанныеОплатКартойПоЧеку(Форма, Результат);
	
	Возврат Результат;
	
КонецФункции

// Открывает форму вновь созданного эквайрингового терминала
// в интерфейсе помощника настройки рабочего места кассира.
// Когда СтандартнаяОбработка = Ложь, в клиентском коде следует обработать оповещение
// "ОповещениеОткрытьФормуСозданияЭквайринговогоТерминала" в форме помощника настройки кассового места.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма помощника настройки рабочего места кассира.
//  СтандартнаяОбработка - Булево - признак использования стандартной обработки.
//
Процедура ОткрытьФормуНовогоТерминалаВИнтерфейсеПомощникаНастройки(Форма, СтандартнаяОбработка) Экспорт
	ОбщегоНазначенияРМККлиентПереопределяемый.ОткрытьФормуНовогоТерминалаВИнтерфейсеПомощникаНастройки(Форма,
		СтандартнаяОбработка);
КонецПроцедуры

// Переопределяет стандартное открытие вопроса для подтверждения операции автономной кассы.
// Если стандартнаяОбработка = Ложь, то будет использован стандартный механизм БПО.
//
// Параметры:
//  Отказ - Булево - признак отказа.
//  СтандартнаяОбработка - Булево - выполнение стандартной обработки.
//  ПараметрыОперации - Структура - структура параметров операции.
//  ДополнительныеПараметры - Структура - структура дополнительных параметров.
// 
Процедура ОткрытьСтандартныйВопросОбработкиАвтономнойККТ(Отказ, СтандартнаяОбработка, ПараметрыОперации, ДополнительныеПараметры) Экспорт
	
	Если ПараметрыОперации.Команда = "CheckFiscalization" Тогда 
		
		ПараметрыОперации.Форма.Доступность = Истина;
		Если ИнтерфейсРМКСлужебныйКлиентСервер.ИспользоватьСлои(ПараметрыОперации.Форма) Тогда
			ИнтерфейсРМКСлужебныйКлиентСервер.УстановитьТекущийСлойГруппы(ПараметрыОперации.Форма.Элементы.ПанельУправленияЧеком);
			ИнтерфейсРМКСлужебныйКлиентСервер.АктивизироватьСлойГруппы(ПараметрыОперации.Форма,
				ПараметрыОперации.Форма.Элементы.ГруппаВопросАвтономнаяКасса);
			ПараметрыОперации.Форма.Элементы.ПробитьЧек.Доступность = Ложь;
		Иначе
			ОбщегоНазначенияРМККлиентСервер.УстановитьТекущуюСтраницу(ПараметрыОперации.Форма.Элементы.СтраницаПравоОбщая);
			ОбщегоНазначенияРМККлиентСервер.УстановитьТекущуюСтраницу(ПараметрыОперации.Форма.Элементы.СтраницаВопросАвтономнаяКасса);
		КонецЕсли;
		
		ПараметрыОперации.Форма.Элементы.ДекорацияНадписьАвтономнаяКасса.Заголовок = НСтр("ru='Чек пробит на устройстве?'");
		ПараметрыОперации.Форма.Элементы.ОтветДаАвтономнаяКасса.Заголовок = НСтр("ru='Пробить'");
		ПараметрыОперации.Форма.Элементы.ОтветНетАвтономнаяКасса.Заголовок = НСтр("ru='Отменить'");
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("Команда", ПараметрыОперации.Команда);
		ПараметрыОповещения.Вставить("ОбщиеПараметры", ДополнительныеПараметры.ПараметрыОперации);
		ПараметрыОперации.Форма.ОповещениеАвтономнойКассы = ПараметрыОповещения;
		СтандартнаяОбработка = Ложь;
		
	ИначеЕсли ПараметрыОперации.Команда = "Encash" Тогда
		
		Если ДополнительныеПараметры.ПараметрыОперации.ТипИнкассации = 1 Тогда
			ОбщегоНазначенияРМККлиентСервер.УстановитьТекущуюСтраницу(ПараметрыОперации.Форма.Элементы.СтраницаВнесениеПодтверждениеОперации);
		Иначе
			ОбщегоНазначенияРМККлиентСервер.УстановитьТекущуюСтраницу(ПараметрыОперации.Форма.Элементы.СтраницаВыемкаПодтверждениеОперации);
		КонецЕсли;
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("Команда", ПараметрыОперации.Команда);
		ПараметрыОповещения.Вставить("ОбщиеПараметры", ДополнительныеПараметры.ПараметрыОперации);
		ПараметрыОперации.Форма.ОповещениеАвтономнойКассы = ПараметрыОповещения;
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;

КонецПроцедуры

// Запускает на главном окне форму рабочего места кассира.
//
Процедура ЗапуститьРабочийСтолРМКНаГлавномОкне() Экспорт
	
	ОбщегоНазначенияРМКВызовСервера.ПереключитьРабочийСтолНаРМК();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

// Запускает длительную операцию сверки данных с ОФД
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма владелец
//  ОповещениеОЗавершении - ОписаниеОповещения - Оповещение о завершении операции
//  ПредлагатьОткрытьСмену - Строка - уникальный идентификатор формы владельца
//  КассаККМ - СправочникСсылка.КассаККМ - Касса ккм для сверки
// Возвращаемое значение:
Процедура СверитьСДаннымиОФД(Форма, ОповещениеОЗавершении, ПредлагатьОткрытьСмену, КассаККМ) Экспорт
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	РезультатВыполнения = ОбщегоНазначенияРМКВызовСервера.СверитьСДаннымиОФД(Форма.УникальныйИдентификатор, КассаККМ); 
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	ДополнительныеПараметры.Вставить("ПредлагатьОткрытьСмену", ПредлагатьОткрытьСмену);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"СверитьСДаннымиОФДЗавершение", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
	
	Если РезультатВыполнения.Статус <> "Выполняется" Тогда
		СверитьСДаннымиОФДЗавершение(РезультатВыполнения, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОповещениеОткрытьРабочееМестоКассира(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	Если РезультатОткрытияФормы = "ЗавершитьРаботуСистемы" Тогда
		ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьРежимРМК() Экспорт
	
	Если ПараметрыПриложения <> Неопределено Тогда
		ПараметрыПриложения.Вставить("ЭтоРежимРМК", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура СброситьРежимРМК() Экспорт
	
	Если ПараметрыПриложения <> Неопределено Тогда
		ПараметрыПриложения.Вставить("ЭтоРежимРМК", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура СверитьСДаннымиОФДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПредлагатьОткрытьСмену", ДополнительныеПараметры.ПредлагатьОткрытьСмену);
	Результат.Вставить("ДанныеСверки", Новый Структура);
	Результат.Вставить("ЕстьРасхожденияВСверке", Ложь); 
	Результат.Вставить("Результат", Истина);
	Результат.Вставить("ТекстОшибки", "");
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
		
		Если ТипЗнч(РезультатОперации) = Тип("Структура") Тогда
			Результат.ДанныеСверки = РезультатОперации;
			Результат.ЕстьРасхожденияВСверке = Истина;
		КонецЕсли;
		
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		
		Результат.Результат = Ложь;
		Результат.ЕстьРасхожденияВСверке = Ложь;
		Результат.ТекстОшибки = РезультатВыполнения.КраткоеПредставлениеОшибки;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти
