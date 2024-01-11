
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	СотрудникиПользователя.ЗагрузитьЗначения(РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя());
	
	Если ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		
			// Ограничение доступа:
			// Редактирование разрешено владельцу календаря 
			// Просмотр разрешен сотруднику, указанному в ТЧ "Доступ"
			
			ПравоРедактирования = СотрудникиПользователя.НайтиПоЗначению(Объект.ВладелецКалендаря) <> Неопределено;
			ПравоПросмотра = ПравоРедактирования;
			Отбор = Новый Структура("Сотрудник");
			Для Каждого КлючИЗначение Из СотрудникиПользователя Цикл
				Отбор.Сотрудник = КлючИЗначение.Значение;
				НайденныеСтроки = Объект.Доступ.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					ПравоПросмотра = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не ПравоПросмотра Тогда
				ВызватьИсключение НСтр("ru='Недостаточно прав для просмотра календаря.'");
			КонецЕсли;
			
			ТолькоПросмотр = Не ПравоРедактирования;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПроверкаСинхронизацииСВнешнимКалендарем();
	ПроигнорированоСообщениеОНовойСинхронизации = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.СинхронизироватьСGoogle = ?(ВнешнийСервисНовый = "Google" ИЛИ ВнешнийСервисПодключенный = "Google", СинхронизацияСВнешнимиКалендарем, Ложь);
	
	Если СинхронизацияСВнешнимиКалендарем И ВнешнийСервисНовый <> "" И Не ПроигнорированоСообщениеОНовойСинхронизации Тогда
		ПоказатьПредупреждениеОВключенииСинхронизации();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("СинхронизацияСВнешнимиКалендарем", СинхронизацияСВнешнимиКалендарем);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ВнешнийСервисНовый", ВнешнийСервисНовый);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ВнешнийСервисПодключенный", ВнешнийСервисПодключенный);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
		
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("Календарь", Объект.Ссылка);
	ПараметрОповещения.Вставить("Наименование", Объект.Наименование);
	ПараметрОповещения.Вставить("ВладелецКалендаря", Объект.ВладелецКалендаря);
	
	Оповестить("Запись_КалендарьСотрудника", ПараметрОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВладелецКалендаряПриИзменении(Элемент)
	
	Если СотрудникиПользователя.НайтиПоЗначению(Объект.ВладелецКалендаря) = Неопределено Тогда
		
		ЕстьДоступ = Ложь;
		Отбор = Новый Структура("Сотрудник");
		
		Для Каждого КлючИЗначение Из СотрудникиПользователя Цикл
			Отбор.Сотрудник = КлючИЗначение.Значение;
			Если Объект.Доступ.НайтиСтроки(Отбор).Количество() > 0 Тогда
				ЕстьДоступ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьДоступ Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеСотрудникаПредложено", ЭтотОбъект);
			
			ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
			ПараметрыВопроса.КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
			ПараметрыВопроса.Заголовок = НСтр("ru='Изменение доступа'");
			ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
			
			ТекстВопроса = СтрШаблон(НСтр("ru='Текущий сотрудник %1 не имеет доступа к календарю.
				|Разрешить доступ?'"), Строка(СотрудникиПользователя));
			
			СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, ПараметрыВопроса);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийСервисПодключенныйНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.УчетныеЗаписиВнешнихКалендарей.Форма.ОбменСКалендарями");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавлениеСотрудникаПредложено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатВопроса) = Тип("Структура")
		И РезультатВопроса.Свойство("Значение")
		И РезультатВопроса.Значение = КодВозвратаДиалога.Да Тогда
		
		Для Каждого КлючИЗначение Из СотрудникиПользователя Цикл
			НоваяСтрока = Объект.Доступ.Добавить();
			НоваяСтрока.Сотрудник = КлючИЗначение.Значение;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаСинхронизацииСВнешнимКалендарем()

	Если СотрудникиПользователя.НайтиПоЗначению(Объект.ВладелецКалендаря) <> Неопределено Тогда
		ВнешнийСервисПодключенный = "";
		
		Если Объект.id <> "" ИЛИ Объект.СинхронизироватьСGoogle Тогда // Ранее синхронизирован с Google
			ВнешнийСервисПодключенный = "Google";
			СинхронизацияСВнешнимиКалендарем = Объект.СинхронизироватьСGoogle;
		Иначе
			НастройкаСинхронизации = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.НайтиПоКалендарюСотрудника(Объект.Ссылка);
			Если НастройкаСинхронизации <> Неопределено Тогда // Ранее синхронизирован с внешним календарем calDAV
				СинхронизацияСВнешнимиКалендарем = НастройкаСинхронизации.Статус;
				ВнешнийСервисПодключенный = СтрШаблон("(%1) %2", НастройкаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря.Провайдер, НастройкаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря.Наименование);
			КонецЕсли;
		КонецЕсли;
		
		Если ВнешнийСервисПодключенный = "" Тогда // Календарь не синхронизирован ранее с календарями внешних сервисов
			СинхронизацияСВнешнимиКалендарем = Ложь;
			Элементы.ВнешнийСервисНовый.Видимость = Истина;
			Элементы.ВнешнийСервисПодключенный.Видимость = Ложь;
			ЗаполнитьСписокВыбораСинхронизаций();
			Если Элементы.ВнешнийСервисНовый.СписокВыбора.Количество() > 0 Тогда
				Элементы.ГруппаСинхронизацияСВнешнимиКалендарями.ТолькоПросмотр = Ложь;
				Элементы.ВнешнийСервисНовый.ТолькоПросмотр = Истина;
			Иначе
				Элементы.ГруппаСинхронизацияСВнешнимиКалендарями.ТолькоПросмотр = Истина;
			КонецЕсли;
		Иначе
			Элементы.ВнешнийСервисПодключенный.Видимость = Истина;
			Элементы.ВнешнийСервисНовый.Видимость = Ложь;
			Элементы.ГруппаСинхронизацияСВнешнимиКалендарями.ТолькоПросмотр = Ложь;
			Элементы.ВнешнийСервисНовый.ТолькоПросмотр = Истина;
		КонецЕсли;
	Иначе
		Элементы.ГруппаСинхронизацияСВнешнимиКалендарями.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСинхронизаций()
	
	// Получить список всех учетных записей
	// Выгружаются записи всех провайдеров кроме iCLoud, т.к. iCLoud не поддерживает создание новых календарей через протокол calDAV
	Элементы.ВнешнийСервисНовый.СписокВыбора.Очистить();
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УчетныеЗаписиВнешнихКалендарей.Код КАК Код,
	|	УчетныеЗаписиВнешнихКалендарей.Наименование КАК Наименование,
	|	УчетныеЗаписиВнешнихКалендарей.Провайдер КАК Провайдер
	|ИЗ
	|	Справочник.УчетныеЗаписиВнешнихКалендарей КАК УчетныеЗаписиВнешнихКалендарей
	|ГДЕ
	|	УчетныеЗаписиВнешнихКалендарей.Пользователь = &Пользователь
	|	И НЕ УчетныеЗаписиВнешнихКалендарей.Провайдер = ЗНАЧЕНИЕ(Перечисление.ТипыСинхронизацииКалендарей.iCloud)");
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		СписокУчетныхЗаписей = РезультатЗапроса.Выгрузить();
		Для каждого УчетнаяЗапись Из СписокУчетныхЗаписей Цикл
			Элементы.ВнешнийСервисНовый.СписокВыбора.Добавить(УчетнаяЗапись.Наименование, СтрШаблон("(%1) %2", УчетнаяЗапись.Провайдер, УчетнаяЗапись.Наименование));
		КонецЦикла;
	КонецЕсли;

	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	ОтключенныеОбластиДоступа = РегистрыСведений.СеансовыеДанныеGoogle.ОтключенныеОбластиДоступа(
		АвторизованныйПользователь);
		
	СеансовыеДанные = РегистрыСведений.СеансовыеДанныеGoogle.СеансовыеДанные(
		АвторизованныйПользователь, Перечисления.ОбластиДоступаGoogle.Календарь);
	ЗаполненТокенДоступа = Не ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(СеансовыеДанные);
	
	СинхронизацияКалендаряGoogle = ОтключенныеОбластиДоступа.Найти(
		Перечисления.ОбластиДоступаGoogle.Календарь) = Неопределено;
	
	ИдентификацияПриложенияGoogle = Константы.ИдентификацияПриложенияGoogle.Получить();
	
	Если СинхронизацияКалендаряGoogle И ЗаполненТокенДоступа Тогда
		Элементы.ВнешнийСервисНовый.СписокВыбора.Добавить("Google", "Google");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьСВнешнимиКалендаремПриИзменении(Элемент)

	Если ВнешнийСервисПодключенный = "" Тогда
		Элементы.ВнешнийСервисНовый.ТолькоПросмотр = Не СинхронизацияСВнешнимиКалендарем;
		Если Не СинхронизацияСВнешнимиКалендарем Тогда
			ВнешнийСервисНовый = "";
			Объект.СинхронизироватьСGoogle = Ложь;
		КонецЕсли;
	Иначе
		Если ВнешнийСервисПодключенный = "Google" Тогда
			Объект.СинхронизироватьСGoogle = СинхронизацияСВнешнимиКалендарем;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеОВключенииСинхронизации()
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыПредупреждениеВключенияСинхронизации", ЭтотОбъект);
	ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Включить синхронизацию с внешним сервисом %1?'"), ВнешнийСервисНовый);
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Включить'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
	
	ПоказатьВопрос(Оповещение, ТекстПредупреждения, СписокКнопок,,КодВозвратаДиалога.Отмена, НСтр("ru = 'Синхронизация с внешним календарем'"),);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыПредупреждениеВключенияСинхронизации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ПроигнорированоСообщениеОНовойСинхронизации = Истина;
	Записать();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
