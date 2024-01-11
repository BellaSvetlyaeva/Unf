///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ПлатежнаяСсылка) Тогда
		
		ПлатежнаяСсылка = Параметры.ПлатежнаяСсылка;
		QRКод = СистемаБыстрыхПлатежей.ИзображениеQRКодаСБП(
			Параметры.ПлатежнаяСсылка,
			360,
			0);
		QRКодКартинкой = ПоместитьВоВременноеХранилище(QRКод, ЭтотОбъект);
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.ОснованиеПлатежа) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'Не корректные параметры формы.'");
	КонецЕсли;
	
	ДанныеПлатежнойСсылки = Новый Структура;
	ДанныеПлатежнойСсылки.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ДанныеПлатежнойСсылки.Вставить("QRКод", QRКод);
	ДанныеПлатежнойСсылки.Вставить("ОснованиеПлатежа", Параметры.ОснованиеПлатежа);
	
	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("Группа", Элементы.ГруппаКнопок);
	
	ИнтеграцияПодсистемБИП.ПриСозданииНаСервереФормыQRКода(
		ЭтотОбъект,
		НастройкиФормы,
		ДанныеПлатежнойСсылки);
	ПереводыСБПc2bПереопределяемый.ПриСозданииНаСервереФормыQRКода(
		ЭтотОбъект,
		НастройкиФормы,
		ДанныеПлатежнойСсылки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОповещениеПослеЗавершенияНастройкиФормы = Новый ОписаниеОповещения(
		"Подключаемый_ПослеЗавершенияНастройкиФормы",
		ЭтотОбъект,
		Новый Структура);
	
	ИнтеграцияПодсистемБИПКлиент.ПриОткрытииФормыQRКода(
		ЭтотОбъект,
		ДанныеПлатежнойСсылки,
		ОповещениеПослеЗавершенияНастройкиФормы);
	
	ПереводыСБПc2bКлиентПереопределяемый.ПриОткрытииФормыQRКода(
		ЭтотОбъект,
		ДанныеПлатежнойСсылки,
		ОповещениеПослеЗавершенияНастройкиФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ИнтеграцияПодсистемБИПКлиент.ПриЗакрытииФормыQRКода(ЭтотОбъект);
	ПереводыСБПc2bКлиентПереопределяемый.ПриЗакрытииФормыQRКода(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПриОбработкеНажатияКоманды(Команда)
	
	ИнтеграцияПодсистемБИПКлиент.ПриОбработкеНажатияКоманды(
		ЭтотОбъект,
		Команда,
		ДанныеПлатежнойСсылки);
	ПереводыСБПc2bКлиентПереопределяемый.ПриОбработкеНажатияКоманды(
		ЭтотОбъект,
		Команда,
		ДанныеПлатежнойСсылки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПослеЗавершенияНастройкиФормы(РезультатВыполнения, Параметры) Экспорт
	
	ИнтеграцияПодсистемБИПКлиент.ПриОтображенииQRКода(
		ДанныеПлатежнойСсылки,
		РезультатВыполнения);
	ПереводыСБПc2bКлиентПереопределяемый.ПриОтображенииQRКода(
		ДанныеПлатежнойСсылки,
		РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти
