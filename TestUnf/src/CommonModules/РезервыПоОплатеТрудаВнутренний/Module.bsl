#Область СлужебныйПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ПриПолученииПредопределенныхНаборовСвойств(Наборы);
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
// Описание см. ЗарплатаКадрыВариантыОтчетов.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	РезервыПоОплатеТрудаБазовый.НастроитьВариантыОтчетов(Настройки);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	
КонецПроцедуры

Процедура СоздатьНовуюНастройкуУчетаРезервовОтпусков() Экспорт
	
	РезервыПоОплатеТрудаБазовый.СоздатьНовуюНастройкуУчетаРезервовОтпусков();
	
КонецПроцедуры

#КонецОбласти

Функция НовыйСодержимоеДокументаРасчетаРезервов() Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.НовыйСодержимоеДокументаРасчетаРезервов();
	
КонецФункции

Функция ТаблицаНачисления() Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ТаблицаНачисления();
	
КонецФункции

Функция ДополнительныеПараметрыЗаполненияТаблицДокумента() Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ДополнительныеПараметрыЗаполненияТаблицДокумента();
	
КонецФункции

Процедура СортироватьДанныеДляЗаполнения(ДанныеЗаполнения, Организация, МесяцНачисления, ИспользоватьСортировкуПоУмолчанию = Истина) Экспорт
	РезервыПоОплатеТрудаБазовый.СортироватьДанныеДляЗаполнения(ДанныеЗаполнения, Организация, МесяцНачисления, ИспользоватьСортировкуПоУмолчанию);
КонецПроцедуры

Процедура ДополнитьТаблицуСведениямиОбОсобенностяхОтпусков(НачисленнаяЗарплатаИВзносы) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ДополнитьТаблицуСведениямиОбОсобенностяхОтпусков(НачисленнаяЗарплатаИВзносы);
	
КонецПроцедуры

Функция СостоянияСотрудниковДляРасчетаОценочныхОбязательств(Организация, Сотрудники, Период) Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.СостоянияСотрудниковДляРасчетаОценочныхОбязательств(Организация, Сотрудники, Период);
	
КонецФункции

Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	РезервыПоОплатеТрудаБазовый.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

Процедура ЗапросДанныеПечатиДокументов(Запрос) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ЗапросДанныеПечатиДокументов(Запрос);
	
КонецПроцедуры

#Область ВидыРасчетовРезервовПоОплатеТруда

Функция ВидыРасчетовРезервовПоОплатеТрудаЭлементПоОписанию(ОписаниеЭлемента) Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ВидыРасчетовРезервовПоОплатеТрудаЭлементПоОписанию(ОписаниеЭлемента);
	
КонецФункции

Процедура ВидыРасчетовРезервовПоОплатеТрудаОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
КонецПроцедуры

Процедура ВидыРасчетовРезервовПоОплатеТрудаПередЗаписью(Объект, Отказ) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиРасчетаРезервовПоОплатеТруда

Процедура НастройкиРасчетаРезервовПоОплатеТрудаОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	РезервыПоОплатеТрудаБазовый.НастройкиРасчетаРезервовПоОплатеТрудаОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты)
	
КонецПроцедуры

Функция ПлановыеНачисленияРезервов(Организация, Резерв, Период) Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ПлановыеНачисленияРезервов(Организация, Резерв, Период);
	
КонецФункции

Функция ТекстЗапросаНастройкаРезервов() Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ТекстЗапросаНастройкаРезервов();
	
КонецФункции

Функция ОписаниеНастройкиДействующихРезервов() Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ОписаниеНастройкиДействующихРезервов();
	
КонецФункции

Функция НастройкиДействующихРезервов(Организация, Период) Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.НастройкиДействующихРезервов(Организация, Период);
	
КонецФункции

Функция БазовыеНачисленияРезерваПоОплатеТруда(Организация, Резерв, Период) Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.БазовыеНачисленияРезерваПоОплатеТруда(Организация, Резерв, Период);
	
КонецФункции

Функция ИсключенияИзРасчетнойБазы() Экспорт
	
	Возврат РезервыПоОплатеТрудаБазовый.ИсключенияИзРасчетнойБазы();
	
КонецФункции

#КонецОбласти

Процедура ПроверитьИспользованиеОбмена(ОбменИспользуется, Организация) Экспорт
	
	РезервыПоОплатеТрудаБазовый.ПроверитьИспользованиеОбмена(ОбменИспользуется, Организация);
	
Конецпроцедуры

#КонецОбласти
