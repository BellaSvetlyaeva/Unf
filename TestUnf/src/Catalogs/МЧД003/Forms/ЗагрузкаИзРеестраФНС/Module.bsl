// @strict-types

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	СписокКоманд.Очистить();
	ШаблонПредставленияКоманды = НСтр("ru='Выбрать %1';");
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.Организация.Тип.Типы() Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		Если МетаданныеОбъекта = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СвойстваМетаданных = Новый Структура("ПредставлениеОбъекта, Синоним", "", "");
		ЗаполнитьЗначенияСвойств(СвойстваМетаданных, МетаданныеОбъекта);
		ВыбранноеИмя = ?(ЗначениеЗаполнено(СвойстваМетаданных.ПредставлениеОбъекта),
			СвойстваМетаданных.ПредставлениеОбъекта, СвойстваМетаданных.Синоним);
		Представление = СтрШаблон(ШаблонПредставленияКоманды, ПолучитьСклоненияСтроки(НРег(ВыбранноеИмя), ,
			"ПД=Винительный;")[0]);
		СписокКоманд.Добавить(Тип, Представление);
	КонецЦикла;
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип.Типы() Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		Если МетаданныеОбъекта = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СвойстваМетаданных = Новый Структура("ПредставлениеОбъекта, Синоним", "", "");
		ЗаполнитьЗначенияСвойств(СвойстваМетаданных, МетаданныеОбъекта);
		ВыбранноеИмя = ?(ЗначениеЗаполнено(СвойстваМетаданных.ПредставлениеОбъекта),
			СвойстваМетаданных.ПредставлениеОбъекта, СвойстваМетаданных.Синоним);
		Представление = СтрШаблон(ШаблонПредставленияКоманды, ПолучитьСклоненияСтроки(НРег(ВыбранноеИмя), ,
			"ПД=Винительный;")[0]);
		СписокКоманд.Добавить(Тип, Представление);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИНННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработчикКоманды = Новый ОписаниеОповещения("Подключаемый_ВыполнитьКомандуВыбора", ЭтотОбъект);
	ПоказатьВыборИзМеню(ОбработчикКоманды, СписокКоманд);
КонецПроцедуры

&НаКлиенте
Процедура ИННАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Ожидание > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = Подбор(Текст, СписокКоманд);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИННОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ВыбранноеЗначение = ПолучитьИНН(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	Если ПроверитьЗаполнение() Тогда
		Закрыть(Новый Структура("ИННДоверителя, НомерДоверенности", ИНН, НомерДоверенности));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция Подбор(Знач СтрокаПоиска, Знач СписокТипов)
	Лимит = 10;
	ПараметрыПодбора = Новый Структура("СтрокаПоиска, СпособПоискаСтроки", СтрокаПоиска,
		СпособПоискаСтрокиПриВводеПоСтроке.ЛюбаяЧасть);
	ИтоговыйСписок = Новый СписокЗначений;
	Индекс = 1;
	Для Каждого ЭлементСписка Из СписокТипов Цикл
		ТекущийТип = ЭлементСписка.Значение;
		МетаданныеИсточника = Метаданные.НайтиПоТипу(ТекущийТип);
		Если ТипЗнч(МетаданныеИсточника) <> Тип("Неопределено") И Метаданные.Справочники.Содержит(МетаданныеИсточника) Тогда
			ИмяСправочника = МетаданныеИсточника.Синоним;
			Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеИсточника.ПолноеИмя());
			ДанныеВыбора = Менеджер.ПолучитьДанныеВыбора(ПараметрыПодбора);			
			Для Каждого ЭлементВыбора Из ДанныеВыбора Цикл
				ЧастиПредставления = Новый Массив(2);
				ЧастиПредставления[0] = ЭлементВыбора.Представление;
				ЧастиПредставления[1] = Новый ФорматированнаяСтрока(СтрШаблон(" [%1]", ИмяСправочника), , ЦветаСтиля.НедоступныйДляВыбораЭлементБЭД);
				ИтоговыйСписок.Добавить(ЭлементВыбора.Значение, Новый ФорматированнаяСтрока(ЧастиПредставления));
				Если Индекс >= Лимит Тогда
					Возврат ИтоговыйСписок;
				КонецЕсли;
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Возврат ИтоговыйСписок;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИНН(Знач Ссылка)
	ИмяРеквизитаИНН = "";
	Если ИнтеграцияЭДО.ЭтоОрганизация(Ссылка) Тогда
		ИмяРеквизитаИНН = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации");
	ИначеЕсли ИнтеграцияЭДО.ЭтоКонтрагент(Ссылка) Тогда
		ИмяРеквизитаИНН = ЭлектронноеВзаимодействие.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
	КонецЕсли;
	Если ЗначениеЗаполнено(ИмяРеквизитаИНН) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизитаИНН);
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуВыбора(ВыбранноеЗначение, ДополнительныеПараметры = Неопределено) Экспорт
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ЭлементСпискаЗначений") Тогда
		ОбработчикЗавершенияВыбора = Новый ОписаниеОповещения("Подключаемый_ВыборУчастникаЗавершение", ЭтотОбъект);
		ПоказатьВводЗначения(ОбработчикЗавершенияВыбора, Неопределено, "", ВыбранноеЗначение.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборУчастникаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры = Неопределено) Экспорт
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ИНН = ПолучитьИНН(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
