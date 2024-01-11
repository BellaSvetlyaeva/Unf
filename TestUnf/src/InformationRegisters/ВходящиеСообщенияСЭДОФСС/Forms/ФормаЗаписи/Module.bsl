#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект = РеквизитФормыВЗначение("Запись");
	Данные = Объект.Содержимое.Получить();
	
	Элементы.ОшибкаОбработкиСообщения.Видимость =
		НЕ ПустаяСтрока(Запись.ОшибкаОбработкиСообщения);
	
	Элементы.ФормаГруппаОткрытьСохранить.Видимость = СведенияОДокументе(Данные, Истина).Адрес <> Неопределено;
	
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	РезультатВыгрузки = СведенияОДокументе();
	
	Если РезультатВыгрузки.Адрес <> Неопределено Тогда
		ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(РезультатВыгрузки.Адрес, РезультатВыгрузки.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДокумент(Команда)
	
	РезультатВыгрузки = СведенияОДокументе();
	
	Если РезультатВыгрузки.Адрес <> Неопределено Тогда
		ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(РезультатВыгрузки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьССервера(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПолучитьССервераПослеПолучения", ЭтотОбъект);
	Идентификаторы = Новый Массив;
	Идентификаторы.Добавить(Запись.Идентификатор);
	ТипыВзаимодействий = Неопределено;
	Если ЗначениеЗаполнено(Запись.ТипВзаимодействия) Тогда
		ТипыВзаимодействий = Новый Массив;
		ТипыВзаимодействий.Добавить(Запись.ТипВзаимодействия);
	КонецЕсли;
	ЭлектронныйДокументооборотСФССКлиент.ПолучитьСообщенияСЭДО(
		Оповещение,
		Запись.Организация,
		Идентификаторы,,,
		ТипыВзаимодействий);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьССервераПослеПолучения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.БылиОшибки Тогда
		Ошибки = СтрСоединить(Результат.Ошибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибки);
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Сообщение было успешно получено с сервера СЭДО.'");
	ОбщегоНазначенияКлиент.
		СообщитьПользователю(ТекстСообщения);
	Прочитать();
	ПриСозданииНаСервере(Ложь, Ложь);
	
КонецПроцедуры

&НаСервере
Функция СведенияОДокументе(Данные = Неопределено, ВозвращатьBase64 = Ложь)
	
	Результат = Новый Структура;
	Результат.Вставить("Имя", 	"");
	Результат.Вставить("Адрес", Неопределено);
	
	Если Данные = Неопределено Тогда
		Объект = РеквизитФормыВЗначение("Запись");
		Данные = Объект.Содержимое.Получить();
	КонецЕсли;
	Если ТипЗнч(Данные) <> Тип("Строка") ИЛИ НЕ ЗначениеЗаполнено(Данные) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Данные);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	УзлыИмя = ДокументDOM.ПолучитьЭлементыПоИмени("name");
	Если УзлыИмя.Количество() <> 0 Тогда
		Результат.Имя = УзлыИмя[0].ТекстовоеСодержимое;
	КонецЕсли;
	
	УзлыСодержимое = ДокументDOM.ПолучитьЭлементыПоИмени("content");
	Если УзлыСодержимое.Количество() <> 0 Тогда
		Результат.Адрес = УзлыСодержимое[0].ТекстовоеСодержимое;
		
		Если ЗначениеЗаполнено(Результат.Адрес) Тогда
			Если НЕ ВозвращатьBase64 Тогда
				ДанныеДокумента = Base64Значение(Результат.Адрес);
				Результат.Адрес = ПоместитьВоВременноеХранилище(ДанныеДокумента, УникальныйИдентификатор);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Результат.Имя) Тогда
				Результат.Имя = НСтр("ru = 'Документ'") + ".docx";
			КонецЕсли;
			
		Иначе
			Результат.Адрес = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере(ТекущаяСтраница)
	
	Если ТекущаяСтраница = "Содержимое" Тогда
		Если НЕ СодержимоеЗагружено Тогда
			Если ТипЗнч(Данные) = Тип("Строка") Тогда
				Содержимое = Данные;
			Иначе
				Содержимое = ТипЗнч(Данные);
			КонецЕсли;
			СодержимоеЗагружено = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ГруппаСтраницыПриСменеСтраницыНаСервере(ТекущаяСтраница.Имя);
	
КонецПроцедуры

#КонецОбласти