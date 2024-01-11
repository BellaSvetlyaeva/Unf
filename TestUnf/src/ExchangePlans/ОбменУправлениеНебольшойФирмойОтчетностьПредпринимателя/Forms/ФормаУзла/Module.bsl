// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
		Элементы.Служебные.Видимость 			 = Ложь;
		Элементы.Служебные.Доступность			 = Ложь;
		
	КонецЕсли;
	
	РежимСинхронизацииОрганизаций =
		?(Объект.ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям")
	;
	
	Организации.Загрузить(ВсеОрганизацииПриложения());
	
	ОтметитьВыбранныеЭлементыТаблицы("Организации", "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ИспользоватьОтборПоОрганизациям =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
	Если ТекущийОбъект.ИспользоватьОтборПоОрганизациям Тогда
		
		ТекущийОбъект.Организации.Загрузить(Организации.Выгрузить(Новый Структура("Использовать", Истина), "Организация"));
		
	Иначе
		
		ТекущийОбъект.Организации.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаУзлаПланаОбмена");
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Организации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтаФорма[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВсеОрганизацииПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Процедура ОтметитьВыбранныеЭлементыТаблицы(ИмяТаблицы, ИмяРеквизита)
	
	Для Каждого СтрокаТаблицы Из Объект[ИмяТаблицы] Цикл
		
		Строки = ЭтаФорма[ИмяТаблицы].НайтиСтроки(Новый Структура(ИмяРеквизита, СтрокаТаблицы[ИмяРеквизита]));
		
		Если Строки.Количество() > 0 Тогда
			
			Строки[0].Использовать = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзмененииЗначения()
	
	Элементы.Организации.Доступность =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
КонецПроцедуры

#КонецОбласти
