// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Правило = ТекущийОбъект.Ссылка;
	Справочники.ПравилаПроверкиПолномочийМЧД.ПриЧтенииНастроек(ТекущийОбъект, ЭтотОбъект);
	Доверенность = РегистрыСведений.ПравилаПроверкиПолномочийПоМЧД.Доверенность(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ПравилоНастроено = МашиночитаемыеДоверенностиКлиентСервер.ПравилоНастроено(ЭтотОбъект);
	Справочники.ПравилаПроверкиПолномочийМЧД.ЗаполнитьПравило(ТекущийОбъект, ЭтотОбъект, ПравилоНастроено);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Варианты = МашиночитаемыеДоверенностиКлиентСервер.ВариантыПроверки();
	
	Если ВариантПроверки = Варианты.Настройка
		И Настройки.НайтиСтроки(Новый Структура("Используется", Истина)).Количество() > 0 Тогда
		
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Не выбрано ни одной активной настройки.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Настройки");
		НепроверяемыеРеквизиты.Добавить("Настройки");
		
	ИначеЕсли ВариантПроверки = Варианты.Скрипт И НЕ ЗначениеЗаполнено(Объект.Скрипт) Тогда
		
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Не введен текст скрипта.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "НастройкиОтбор");
		НепроверяемыеРеквизиты.Добавить("Объект.Скрипт");
		
	КонецЕсли;

	Если НепроверяемыеРеквизиты.Количество() > 0 Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	МашиночитаемыеДоверенностиКлиент.СформироватьЗаголовокВкладкиПолномочия(ЭтотОбъект);
	МашиночитаемыеДоверенностиКлиент.ОтобразитьВариантПроверки(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Справочники.ПравилаПроверкиПолномочийМЧД.ПриСозданииНаСервереФормыНастроек(ЭтотОбъект);
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Справочники.ПравилаПроверкиПолномочийМЧД.ПриЧтенииНастроек(Объект, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстСкриптаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВариантПроверкиПриИзменении(Элемент)
	МашиночитаемыеДоверенностиКлиент.ОтобразитьВариантПроверки(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтбора

&НаКлиенте
Процедура ДеревоОтбораПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередНачаломДобавления(Элемент, Отказ, Элементы.ДеревоОтбораДанные);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элементы.ДеревоОтбора.ТекущиеДанные.Картинка = МашиночитаемыеДоверенностиКлиентСервер.НаборКартинок().Реквизит;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПередНачаломИзменения(Элемент, Отказ)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура("ДанныеСтроки", ДанныеСтроки);
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЗначения", ЭтотОбъект, ДополнительныеПараметры);
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередНачаломИзменения(
		ДанныеСтроки, Отказ, Элементы.ДеревоОтбораДанные, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПередУдалением(Элемент, Отказ)
	
	ДанныеСтроки = Элементы.ДеревоОтбора.ТекущиеДанные;
	ИдентификаторСтроки = 0;
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПередУдалением(
		ДанныеСтроки, Отказ, ИдентификаторСтроки, Модифицированность);
	СформироватьПредставлениеДанныхПоСтрокеДерева(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораДанныеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ДанныеСтроки = Элементы.ДеревоОтбора.ТекущиеДанные;
	СформироватьПредставлениеДанныхПоСтрокеДерева(ДанныеСтроки.ПолучитьРодителя().ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПослеУдаления(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОтбораПриАктивизацииСтроки(Элемент)
	МашиночитаемыеДоверенностиКлиент.ДеревоОтбораПриАктивизацииСтроки(Элемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВводаЗначения(Значение, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ДополнительныеПараметры.ДанныеСтроки.НачальноеЗначение = Значение.НачальноеЗначение;
	ДополнительныеПараметры.ДанныеСтроки.КонечноеЗначение = Значение.КонечноеЗначение;
	СформироватьПредставлениеДанныхПоСтрокеДерева(ДополнительныеПараметры.ДанныеСтроки.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеДанныхПоСтрокеДерева(ИдентификаторЭлемента)
	
	СтрокаДерева = ДеревоОтбора.НайтиПоИдентификатору(ИдентификаторЭлемента);
	СтрокаДерева.Данные = Справочники.ПравилаПроверкиПолномочийМЧД.ПредставлениеДанных(СтрокаДерева);
	
КонецПроцедуры

#КонецОбласти
