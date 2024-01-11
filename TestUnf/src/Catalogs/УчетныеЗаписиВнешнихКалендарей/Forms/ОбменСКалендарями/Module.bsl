#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСписокПодключений();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НетПодключений Тогда
		ПодключитьОбработчикОжидания("ДобавитьНовоеПодключениеПриОткрытии", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбменСКалендарями_ОбновитьСписокПодключенийВнешнихКалендарей" Тогда
		ОбновитьСписокПодключений();
		Если СписокПодключений.Количество() = 0 Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПодключенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗаписьВнешнегоКалендаря", Элементы.СписокПодключений.ТекущиеДанные.Ссылка);
	ПараметрыФормы.Вставить("ВнешнийСервис", Элементы.СписокПодключений.ТекущиеДанные.Провайдер);
	ОткрытьФорму("Справочник.УчетныеЗаписиВнешнихКалендарей.Форма.ДобавитьНовоеПодключение", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьНовоеПодключение(Команда)
	ОткрытьФорму("Справочник.УчетныеЗаписиВнешнихКалендарей.Форма.ДобавитьНовоеПодключение");
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПодключение(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗаписьВнешнегоКалендаря", Элементы.СписокПодключений.ТекущиеДанные.Ссылка);
	ПараметрыФормы.Вставить("ВнешнийСервис", Элементы.СписокПодключений.ТекущиеДанные.Провайдер);
	ОткрытьФорму("Справочник.УчетныеЗаписиВнешнихКалендарей.Форма.ДобавитьНовоеПодключение", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	ОбновитьСписокПодключений();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройки()
	
	Если СписокПодключений.Количество() > 0 Тогда
		Для каждого Подключение Из СписокПодключений Цикл
			ДанныеАвторизацииСсылка = Справочники.УчетныеЗаписиВнешнихКалендарей.НайтиПоКлючевымПолям(Подключение.Логин, Подключение.Провайдер);
			Если Не ДанныеАвторизацииСсылка.Пустая() Тогда
				ДанныеАвторизацииОбъект = ДанныеАвторизацииСсылка.ПолучитьОбъект();
				Если Не ДанныеАвторизацииОбъект.Статус = Подключение.Статус Тогда
					ДанныеАвторизацииОбъект.Заблокировать();
					ДанныеАвторизацииОбъект.Статус = Подключение.Статус;
					ДанныеАвторизацииОбъект.Записать();
					ДанныеАвторизацииОбъект.Разблокировать();
				КонецЕсли;
			КонецЕсли;
			Если Подключение.Провайдер = Перечисления.ТипыСинхронизацииКалендарей.Google Тогда
				ОбновитьИспользованиеОбластиДоступаПриложениеGoogle(Подключение.Статус);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНовоеПодключениеПриОткрытии()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПервоеПодключение", Ложь);
	ОткрытьФорму("Справочник.УчетныеЗаписиВнешнихКалендарей.Форма.ДобавитьНовоеПодключение", ПараметрыФормы,ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПодключенийСтатусПриИзменении(Элемент)
	
	Если Элементы.СписокПодключений.ТекущиеДанные.Провайдер = ПредопределенноеЗначение("Перечисление.ТипыСинхронизацииКалендарей.Google")
		И НЕ НаличиеСеансовыхДанныхGoogle() Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УчетнаяЗаписьВнешнегоКалендаря", Элементы.СписокПодключений.ТекущиеДанные.Ссылка);
		ПараметрыФормы.Вставить("ВнешнийСервис", Элементы.СписокПодключений.ТекущиеДанные.Провайдер);
		ОткрытьФорму("Справочник.УчетныеЗаписиВнешнихКалендарей.Форма.ДобавитьНовоеПодключение", ПараметрыФормы);
		
	Иначе
		
		СохранитьСтатусСинхронизации(
			Элементы.СписокПодключений.ТекущиеДанные.Провайдер,
			Элементы.СписокПодключений.ТекущиеДанные.Логин,
			Элементы.СписокПодключений.ТекущиеДанные.Статус);
		Оповестить("Календарь_ОбновитьСписокДоступныхКалендарей");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодключений()
	
	ОбновитьСписокПодключенийНаСервере();
	Если СписокПодключений.Количество() = 0 Тогда
		Элементы.ГруппаСписокПодключенийDAV.Видимость = Ложь;
		ЭтаФорма.КоманднаяПанель.Видимость = Ложь;
		НетПодключений = Истина;
	Иначе
		Элементы.ГруппаСписокПодключенийDAV.Видимость = Истина;
		ЭтаФорма.КоманднаяПанель.Видимость = Истина;
		НетПодключений = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодключенийНаСервере()
	
	СписокПодключений.Очистить();
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УчетныеЗаписиВнешнихКалендарей.Ссылка КАК Ссылка,
	|	УчетныеЗаписиВнешнихКалендарей.ВерсияДанных КАК ВерсияДанных,
	|	УчетныеЗаписиВнешнихКалендарей.ПометкаУдаления КАК ПометкаУдаления,
	|	УчетныеЗаписиВнешнихКалендарей.Код КАК Код,
	|	УчетныеЗаписиВнешнихКалендарей.Наименование КАК Наименование,
	|	УчетныеЗаписиВнешнихКалендарей.Провайдер КАК Провайдер,
	|	УчетныеЗаписиВнешнихКалендарей.Сервер КАК Сервер,
	|	УчетныеЗаписиВнешнихКалендарей.КаталогКалендарей КАК КаталогКалендарей,
	|	УчетныеЗаписиВнешнихКалендарей.ПометкаУдаления КАК Статус,
	|	УчетныеЗаписиВнешнихКалендарей.Пользователь КАК Пользователь,
	|	УчетныеЗаписиВнешнихКалендарей.Предопределенный КАК Предопределенный,
	|	УчетныеЗаписиВнешнихКалендарей.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
	|	УчетныеЗаписиВнешнихКалендарей.ДатаСинхронизации КАК ДатаСинхронизации
	|ИЗ
	|	Справочник.УчетныеЗаписиВнешнихКалендарей КАК УчетныеЗаписиВнешнихКалендарей
	|ГДЕ
	|	УчетныеЗаписиВнешнихКалендарей.Пользователь = &Пользователь");
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СписокПодключений.Добавить();
		НоваяСтрока.Код = Выборка.Код;
		НоваяСтрока.Наименование = СтрШаблон("%1 (%2)", Выборка.Провайдер, Выборка.Наименование);
		НоваяСтрока.Логин = Выборка.Наименование;
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Сервер = Выборка.Сервер;
		НоваяСтрока.Провайдер = Выборка.Провайдер;
		НоваяСтрока.ДатаСинхронизации = Выборка.Ссылка.ДатаСинхронизации;
		НоваяСтрока.Статус = Не Выборка.Статус;
	КонецЦикла;
	
	ЗагрузкаНастроекСинхронизацииСGoogle();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаНастроекСинхронизацииСGoogle()
	
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	ОтключенныеОбластиДоступа = РегистрыСведений.СеансовыеДанныеGoogle.ОтключенныеОбластиДоступа(
		АвторизованныйПользователь);
		
	СеансовыеДанные = РегистрыСведений.СеансовыеДанныеGoogle.СеансовыеДанные(
		АвторизованныйПользователь, Перечисления.ОбластиДоступаGoogle.Календарь);
	ЗаполненТокенДоступа = Не ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(СеансовыеДанные);
	
	СинхронизацияКалендаряGoogle = ОтключенныеОбластиДоступа.Найти(
		Перечисления.ОбластиДоступаGoogle.Календарь) = Неопределено;
	
	ИдентификацияПриложенияGoogle = Константы.ИдентификацияПриложенияGoogle.Получить();
	
	Если ИдентификацияПриложенияGoogle <> "" Тогда
		НоваяСтрока = СписокПодключений.Добавить();
		НоваяСтрока.Статус = СинхронизацияКалендаряGoogle И ЗаполненТокенДоступа;
		НоваяСтрока.Логин = "Google";
		НоваяСтрока.Наименование = "Google";
		НоваяСтрока.Провайдер = Перечисления.ТипыСинхронизацииКалендарей.Google;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИспользованиеОбластиДоступаПриложениеGoogle(Статус)
	
	РегистрыСведений.СеансовыеДанныеGoogle.ОтключитьОбластьДоступа(
		Пользователи.АвторизованныйПользователь(),
		Перечисления.ОбластиДоступаGoogle.Календарь,
		Не Статус);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСтатусСинхронизации(Провайдер, Логин, Статус)
	
	Если Провайдер = Перечисления.ТипыСинхронизацииКалендарей.Google Тогда
		ОбновитьИспользованиеОбластиДоступаПриложениеGoogle(Статус);
	Иначе
		ДанныеАвторизацииСсылка = Справочники.УчетныеЗаписиВнешнихКалендарей.НайтиПоКлючевымПолям(Логин, Провайдер);
		Если Не ДанныеАвторизацииСсылка.Пустая() Тогда
			ДанныеАвторизацииОбъект = ДанныеАвторизацииСсылка.ПолучитьОбъект();
			ДанныеАвторизацииОбъект.Заблокировать();
			ДанныеАвторизацииОбъект.ПометкаУдаления = Не Статус;
			ДанныеАвторизацииОбъект.Записать();
			ДанныеАвторизацииОбъект.Разблокировать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НаличиеСеансовыхДанныхGoogle()
	
	СеансовыеДанные = РегистрыСведений.СеансовыеДанныеGoogle.СеансовыеДанные(Пользователи.ТекущийПользователь(),
		ПредопределенноеЗначение("Перечисление.ОбластиДоступаGoogle.Календарь"));
	Возврат СеансовыеДанные.Свойство("access_token") И ЗначениеЗаполнено(СеансовыеДанные.access_token);
	
КонецФункции

#КонецОбласти
