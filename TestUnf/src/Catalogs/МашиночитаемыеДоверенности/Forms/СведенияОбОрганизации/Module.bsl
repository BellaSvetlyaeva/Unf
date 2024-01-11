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
	
	Ссылка = Параметры.Ссылка;
	УникальныйИдентификаторВладельца = Параметры.УникальныйИдентификаторВладельца;
	
	ЗаполнитьСведенияОбОрганизации(ЭтотОбъект, Параметры.Реквизиты);
	
	Если Параметры.РедактированиеТаблицы Тогда
		
		ПредставительНесколько = Параметры.Представители.Количество() > 1;
		
		Для Каждого Строка Из Параметры.Представители Цикл
			НоваяСтрока = ТаблицаПредставительНесколько.Добавить();
			НоваяСтрока.Представитель = Строка.Представитель;
			НоваяСтрока.ПредставительИдентификатор = Строка.Идентификатор;
			НоваяСтрока.ПредставительСтрока = МашиночитаемыеДоверенностиФНССлужебный.ЗаголовокДекорации(
				ПолучитьИзВременногоХранилища(Строка.АдресРеквизитов), "Представитель", Ложь, Ложь);
			НоваяСтрока.АдресРеквизитов = Строка.АдресРеквизитов;
		КонецЦикла;
		
		ТипСсылкиСтрока = ?(ЭтоКонтрагент, "Контрагент", "Организация");
		
		МашиночитаемыеДоверенностиФНССлужебный.ЗаполнитьТипыЗначения(ТипСсылкиСтрока,
			ТипСсылки, Элементы.Ссылка1);
		Если ТипСсылки <> Неопределено Тогда 
			ТипСсылкиМассив = ТипСсылки.ВыгрузитьЗначения();
			Элементы.Ссылка1.ОграничениеТипа = Новый ОписаниеТипов(ТипСсылкиМассив);
			Элементы.Ссылка1.Видимость = Истина;
		Иначе
			Элементы.Ссылка1.Видимость = Ложь;
		КонецЕсли; 
		
		МашиночитаемыеДоверенностиФНССлужебный.ЗаполнитьТипыЗначения("ФизическоеЛицо",
			ТипСсылкиПредставитель, Элементы.Представитель);
		Если ТипСсылкиПредставитель <> Неопределено Тогда 
			ТипСсылкиМассив = ТипСсылкиПредставитель.ВыгрузитьЗначения();
			Элементы.Представитель.ОграничениеТипа = Новый ОписаниеТипов(ТипСсылкиМассив);
			Элементы.Представитель.Видимость = Истина;
		Иначе
			Элементы.Представитель.Видимость = Ложь;
		КонецЕсли;

		Элементы.Ссылка.Видимость = Ложь;
		Элементы.ГруппаПредставитель.Видимость = Параметры.Представители.Количество() > 0;
		
		СведенияОбОрганизации.Вставить("СсылкаТип", ТипСсылки);
		
	Иначе
		Элементы.Ссылка1.Видимость = Ложь;
		Элементы.Ссылка.Видимость = ЗначениеЗаполнено(Ссылка);
		Элементы.ГруппаПредставитель.Видимость = Ложь;
	КонецЕсли;
		
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		ВидКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Адрес);
			
		ВидКонтактнойИнформации.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
		
		ВидКонтактнойИнформацииТелефон = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Телефон);
			
		ВидКонтактнойИнформацииИностранныйАдрес = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Адрес);
		ВидКонтактнойИнформацииИностранныйАдрес.НастройкиПроверки.ТолькоНациональныйАдрес = Ложь;
		ВидКонтактнойИнформацииИностранныйАдрес.НастройкиПроверки.ВключатьСтрануВПредставление = Истина;
		ВидКонтактнойИнформацииИностранныйАдрес.МеждународныйФорматАдреса = Истина;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Поле) Тогда
		Элементы[Параметры.Поле].АктивизироватьПоУмолчанию = Истина;
	КонецЕсли;
	
	МашиночитаемыеДоверенностиФНССлужебный.УстановитьУсловноеОформление(ЭтотОбъект);
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СтандартнаяОбработка = Ложь;
	ЗадатьВопросПередЗакрытием();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "ИзменениеОрганизацииВЗаявленииНаВыпускСертификата" Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ЗаполнитьСведенияОбОрганизации(ЭтотОбъект, Параметр);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ЭтотОбъект[Элемент.Имя] = СокрЛП(ЭтотОбъект[Элемент.Имя]);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоИндивидуальныйПредпринимательПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ИндивидуальныйПредпринимательПриИзменении(ЭтотОбъект);
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоИностраннаяОрганизацияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если ЭтоИностраннаяОрганизация Тогда
		ОГРН = Неопределено;
		ЭтоФилиал = Ложь;
		ЮридическийАдрес = Неопределено;
		ЮридическийАдресЗначение = Неопределено;
		НаименованиеУчредительногоДокумента = Неопределено;
		РегистрационныйНомерФилиала = Неопределено;
	КонецЕсли;
	
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоФилиалПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ФилиалПриИзменении(ЭтотОбъект);
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ЮридическийАдрес", НСтр("ru = 'Адрес регистрации организации'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставлениеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ЮридическийАдрес");
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ЮридическийАдрес");
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресВСтранеРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ЮридическийАдресВСтранеРегистрации", НСтр("ru = 'Адрес организации в стране регистрации'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресВСтранеРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставлениеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ЮридическийАдресВСтранеРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресВСтранеРегистрацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ЮридическийАдресВСтранеРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ФактическийАдрес", НСтр("ru = 'Адрес организации фактический'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставлениеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ФактическийАдрес");

КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ФактическийАдрес");
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеТелефонаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"Телефон", НСтр("ru = 'Телефон организации'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОчистка(Элемент, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеТелефонаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "Телефон");
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеТелефонаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "Телефон");
	
КонецПроцедуры

&НаКлиенте
Процедура Ссылка1ПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыОрганизации(ТипСсылкиСтрока, Ссылка);
	УправлениеВидимостью(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Массив = СтрРазделить(НавигационнаяСсылкаФорматированнойСтроки, ":");
	
	Если ПустаяСтрока(ТаблицаПредставительНесколько[0].АдресРеквизитов) Тогда
		Реквизиты = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыУчастника(
			"ФизическоеЛицо", Неопределено, "ДолжностноеЛицо", Истина);
	Иначе
		Реквизиты = ПолучитьИзВременногоХранилища(ТаблицаПредставительНесколько[0].АдресРеквизитов);
	КонецЕсли;
	
	ПараметрыФормы = МашиночитаемыеДоверенностиФНССлужебныйКлиент.ПараметрыФормыВводаРеквизитов(
		ТаблицаПредставительНесколько[0].Представитель, Реквизиты, ТолькоПросмотр);
	ПараметрыФормы.Поле = Массив[1];
	
	МашиночитаемыеДоверенностиФНССлужебныйКлиент.ОткрытьФормуВводаРеквизитов(ЭтотОбъект,
		ПараметрыФормы, Новый ОписаниеОповещения("ДобавлениеВТаблицу", ЭтотОбъект, ТаблицаПредставительНесколько[0].Идентификатор));
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьИзмененияИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗадатьВопросПередЗакрытием();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПредставителя(Команда)
	
	Если ПустаяСтрока(ТаблицаПредставительНесколько[0].АдресРеквизитов) Тогда
		Реквизиты = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыУчастника(
			"ФизическоеЛицо", Неопределено, "ДолжностноеЛицо", Истина);
	Иначе
		Реквизиты = ПолучитьИзВременногоХранилища(ТаблицаПредставительНесколько[0].АдресРеквизитов);
	КонецЕсли;
	
	ПараметрыФормы = МашиночитаемыеДоверенностиФНССлужебныйКлиент.ПараметрыФормыВводаРеквизитов(
		ТаблицаПредставительНесколько[0].Представитель, Реквизиты, ТолькоПросмотр);
	
	МашиночитаемыеДоверенностиФНССлужебныйКлиент.ОткрытьФормуВводаРеквизитов(ЭтотОбъект,
		ПараметрыФормы, Новый ОписаниеОповещения("ДобавлениеВТаблицу", ЭтотОбъект, ТаблицаПредставительНесколько[0].Идентификатор));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавлениеВТаблицу(Результат, Идентификатор) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка = ТаблицаПредставительНесколько.НайтиСтроки(Новый Структура("ПредставительИдентификатор", Идентификатор))[0];
	
	Если ПустаяСтрока(Строка.АдресРеквизитов) Тогда
		Строка.АдресРеквизитов = ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификаторВладельца);
	Иначе
		ПоместитьВоВременноеХранилище(Результат, Строка.АдресРеквизитов);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСведенияОбОрганизации(Форма, СведенияОбОрганизации)
	
	Если СведенияОбОрганизации <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Форма, СведенияОбОрганизации);
		Форма.СведенияОбОрганизации = СведенияОбОрганизации;
	Иначе
		Форма.СведенияОбОрганизации = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыОрганизации(Истина, Неопределено);
		ЗаполнитьЗначенияСвойств(Форма, Форма.СведенияОбОрганизации);
	КонецЕсли;
	УправлениеВидимостью(Форма);
	Форма.Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросПередЗакрытием()
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗакрытиеПослеОтветаНаВопрос", ЭтотОбъект),
		НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеПослеОтветаНаВопрос(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьИзмененияИЗакрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзмененияИЗакрыть()
	
	Если ТолькоПросмотр Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();
	
	Если Не ПроверитьСведенияОбОрганизации() Тогда
		Если Не Элементы.ТипСсылкиСтрока.ТолькоПросмотр Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("СохранениеПослеОтветаНаВопрос", ЭтотОбъект),
				НСтр("ru = 'Есть ошибки. Все равно сохранить изменения?'"),
				РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;
	
	СохранениеПослеОтветаНаВопрос(КодВозвратаДиалога.Да, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранениеПослеОтветаНаВопрос(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыУчастникаДляХранения = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыУчастникаДляХранения(ЭтотОбъект);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СведенияОбОрганизации, РеквизитыУчастникаДляХранения, Ложь);
	ЗаполнитьЗначенияСвойств(СведенияОбОрганизации, ЭтотОбъект);
	
	Если Параметры.РедактированиеТаблицы Тогда
				
		Если ТаблицаПредставительНесколько.Количество() > 0 Тогда
			Структура = Новый Структура("Представитель, Идентификатор, АдресРеквизитов");
			Представители = Новый Массив;
			Для Каждого Строка Из ТаблицаПредставительНесколько Цикл
				ЗаполнитьЗначенияСвойств(Структура, Строка);
				Представители.Добавить(Структура);
			КонецЦикла;
			СведенияОбОрганизации.Вставить("Представители", Представители);
		Иначе
			СведенияОбОрганизации.Вставить("Представители", Неопределено);
		КонецЕсли;
		
		СведенияОбОрганизации.Вставить("Ссылка", Ссылка);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть(СведенияОбОрганизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ИмяРеквизита, ЗаголовокФормы)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"УправлениеКонтактнойИнформациейКлиент");
	
	Если ИмяРеквизита = "ЮридическийАдресВСтранеРегистрации" Тогда
		УстановитьНаименованиеКонтактнойИнформации(ВидКонтактнойИнформацииИностранныйАдрес, ЗаголовокФормы);
		ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
			ВидКонтактнойИнформацииИностранныйАдрес, ЭтотОбъект[ИмяРеквизита + "Значение"], ЭтотОбъект[ИмяРеквизита]);
		ПараметрыФормы.Вставить("Страна", СтранаРегистрацииКод);
	Иначе
		УстановитьНаименованиеКонтактнойИнформации(ВидКонтактнойИнформации, ЗаголовокФормы);
		ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
			ВидКонтактнойИнформации, ЭтотОбъект[ИмяРеквизита + "Значение"], ЭтотОбъект[ИмяРеквизита]);
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Параметры:
//  ВидКИ - см. УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации
//  ЗаголовокФормы - Строка
//
&НаКлиенте
Процедура УстановитьНаименованиеКонтактнойИнформации(ВидКИ, ЗаголовокФормы)
	ВидКИ.Наименование = ЗаголовокФормы;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Форма, Элемент, СтандартнаяОбработка, ИмяРеквизита)
	
	Форма[ИмяРеквизита + "Значение"] = "";
	Форма[ИмяРеквизита] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ИмяРеквизита)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяРеквизита = "ЮридическийАдресВСтранеРегистрации" Тогда
		СтранаАдресаКонтактнойИнформации = СтранаАдресаКонтактнойИнформации(ВыбранноеЗначение.КонтактнаяИнформация);
		СтранаРегистрации = СтранаАдресаКонтактнойИнформации.Ссылка;
		СтранаРегистрацииКод = СтранаАдресаКонтактнойИнформации.Код;
	КонецЕсли;
	
	Форма[ИмяРеквизита + "Значение"] = ВыбранноеЗначение.КонтактнаяИнформация;
	Форма[ИмяРеквизита] = ВыбранноеЗначение.Представление;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтранаАдресаКонтактнойИнформации(ВыбранноеЗначение)
	
	Возврат УправлениеКонтактнойИнформацией.СтранаАдресаКонтактнойИнформации(ВыбранноеЗначение);
	
КонецФункции

&НаКлиенте
Процедура ПредставлениеТелефонаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ИмяРеквизита, ЗаголовокФормы)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"УправлениеКонтактнойИнформациейКлиент");
	
	ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформацииТелефон, ЭтотОбъект[ИмяРеквизита + "Значение"], ЭтотОбъект[ИмяРеквизита]);
	
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	
	МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаОчистка(Форма, Элемент, СтандартнаяОбработка, ИмяРеквизита)
	
	Форма[ИмяРеквизита + "Значение"] = "";
	Форма[ИмяРеквизита] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ИмяРеквизита)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		// Данные не изменены.
		Возврат;
	КонецЕсли;
	
	Форма[ИмяРеквизита + "Значение"] = ВыбранноеЗначение.КонтактнаяИнформация;
	Форма[ИмяРеквизита] = ВыбранноеЗначение.Представление;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьСведенияОбОрганизации()
	
	Возврат МашиночитаемыеДоверенностиФНССлужебный.ПроверитьСведенияОбОрганизации(ЭтотОбъект, СведенияОбОрганизации);
	
КонецФункции

&НаКлиенте
Процедура СтранаРегистрацииПриИзменении(Элемент)
	СтранаРегистрацииПриИзмененииНаСервере();
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура СтранаРегистрацииПриИзмененииНаСервере()
	
	СтранаРегистрацииКод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтранаРегистрации, "Код");
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаРегистрацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)
	
	СписокРеквизитов = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыОрганизацииСписок(Ложь,
		МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.ОпределитьВидУчастника(Форма));
		
	Для Каждого Элемент Из Форма.Элементы Цикл
			
		Если ТипЗнч(Элемент) = Тип("ТаблицаФормы") Или Элемент.Вид <> ВидПоляФормы.ПолеВвода Тогда
			Продолжить;
		КонецЕсли;
		
		Если Элемент.Имя = "Ссылка1" Или Элемент.Имя = "Представитель" Тогда
			Продолжить;
		КонецЕсли;

		Реквизит = СписокРеквизитов.НайтиПоЗначению(Элемент.Имя);
		Если Реквизит <> Неопределено Тогда
			Форма.Элементы[Элемент.Имя].АвтоОтметкаНезаполненного = Не Реквизит.Пометка;
			Форма.Элементы[Элемент.Имя].Видимость = Истина;
		Иначе
			Форма.Элементы[Элемент.Имя].Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Форма.Элементы.ЭтоФилиал.Видимость = Не Форма.ЭтоИндивидуальныйПредприниматель И Не Форма.ЭтоИностраннаяОрганизация;
	Форма.Элементы.ЭтоИностраннаяОрганизация.Видимость = Не Форма.ЭтоИндивидуальныйПредприниматель;
	Форма.Элементы.ГруппаНесколькоПредставителей.Видимость = Форма.ПредставительНесколько;
	Форма.Элементы.ГруппаПредставитель.ОтображатьЗаголовок = Не Форма.ЭтоИндивидуальныйПредприниматель;
	Форма.Элементы.ГруппаПредставитель.Видимость = Форма.ЭтоФилиал Или Форма.ЭтоИндивидуальныйПредприниматель;
	Форма.Элементы.Представитель.Заголовок = ?(Форма.ЭтоИндивидуальныйПредприниматель, НСтр("ru='Физическое лицо'"), НСтр("ru='Представитель'"));
	Если Форма.ТаблицаПредставительНесколько.Количество() > 0 Тогда
		Если Форма.ТаблицаПредставительНесколько.Количество() = 1 Тогда
			Форма.Элементы.ПредставительДекорация.Заголовок = Форма.ТаблицаПредставительНесколько[0].ПредставительСтрока;
			Форма.Элементы.ГруппаОдинПредставитель.Видимость = Истина;
			Форма.Элементы.ГруппаНесколькоПредставителей.Видимость = Ложь
		Иначе
			Форма.Элементы.ГруппаОдинПредставитель.Видимость = Ложь;
			Форма.Элементы.ГруппаНесколькоПредставителей.Видимость = Истина;
		КонецЕсли;
	Иначе
		Форма.Элементы.ГруппаПредставитель.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредставительПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыОрганизации("ФизическоеЛицо", ТаблицаПредставительНесколько[0].Представитель);
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыОрганизации(ОрганизацияТипСтрока, ОрганизацияСсылка, Реквизиты = Неопределено)
	
	Если ОрганизацияТипСтрока <> "ФизическоеЛицо" Тогда
		
		Если Реквизиты = Неопределено И ЗначениеЗаполнено(ОрганизацияСсылка) Тогда
			Реквизиты = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыУчастника(
				ОрганизацияТипСтрока, ОрганизацияСсылка);
			
			Реквизиты.Вставить("ТипСсылки", ТипСсылки);
			МашиночитаемыеДоверенностиФНССлужебный.ПриЗаполненииРеквизитовОрганизации(Реквизиты);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
		КонецЕсли;
		
		Если ЭтоИндивидуальныйПредприниматель Тогда
			ИндивидуальныйПредпринимательПриИзменении(ЭтотОбъект);
		Иначе
			ФилиалПриИзменении(ЭтотОбъект);
		КонецЕсли;
		
		Если ЭтоИндивидуальныйПредприниматель
			Или ЭтоФилиал Тогда
		
			ЗаполнитьРеквизитыОрганизации("ФизическоеЛицо", Реквизиты.ЛицоБезДоверенности, Реквизиты.РеквизитыЛицаБезДоверенности);
		
		КонецЕсли;
	Иначе
		ТаблицаПредставительНесколько[0].Представитель = ОрганизацияСсылка;
		
		Если Реквизиты = Неопределено И ЗначениеЗаполнено(ОрганизацияСсылка) Тогда
			Реквизиты = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РеквизитыУчастника(
				ОрганизацияТипСтрока, ОрганизацияСсылка);
			
			Реквизиты.Вставить("ТипСсылки", ТипСсылкиПредставитель);
			МашиночитаемыеДоверенностиФНССлужебный.ПриЗаполненииРеквизитовОрганизации(Реквизиты);
		КонецЕсли;
		
		ЗаголовокДекорации = МашиночитаемыеДоверенностиФНССлужебный.ЗаголовокДекорации(
			Реквизиты, "Представитель", Ложь, Ложь); // ФорматированнаяСтрока
		
		ТаблицаПредставительНесколько[0].ПредставительСтрока = ЗаголовокДекорации;
		Реквизиты.ЭтоДолжностноеЛицо = Не ЭтоИндивидуальныйПредприниматель;
		Реквизиты.ЭтоИндивидуальныйПредприниматель = ЭтоИндивидуальныйПредприниматель;
		ТаблицаПредставительНесколько[0].АдресРеквизитов = ПоместитьВоВременноеХранилище(Реквизиты, УникальныйИдентификаторВладельца);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИндивидуальныйПредпринимательПриИзменении(Форма)
	
	Форма.ТаблицаПредставительНесколько.Очистить();
	Если Форма.ЭтоИндивидуальныйПредприниматель Тогда
		Форма.КПП = Неопределено;
		Форма.ЭтоИностраннаяОрганизация = Ложь;
		Форма.ЭтоФилиал = Ложь;
		Форма.ТаблицаПредставительНесколько.Добавить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФилиалПриИзменении(Форма)
	
	Форма.ТаблицаПредставительНесколько.Очистить();
	Если Форма.ЭтоФилиал Тогда
		Форма.ТаблицаПредставительНесколько.Добавить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти