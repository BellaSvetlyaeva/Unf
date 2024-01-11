///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт

	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Комментарий");

	Возврат РедактируемыеРеквизиты;

КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Владелец.ВладелецФайла)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(Владелец.ВладелецФайла)";

	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаОбъекта" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма       = "Обработка.РаботаСФайлами.Форма.ВерсияПрисоединенногоФайла";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
// Параметры:
//  Параметры - Структура - служебный параметр для передачи в процедуру ОбновлениеИнформационнойБазы.ОтметитьКОбработке.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ВерсииФайлов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.Ссылка > &Ссылка
	|	И ВерсииФайлов.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ВТомахНаДиске)
	|	И (ПОДСТРОКА(ВерсииФайлов.ПутьКФайлу, 1, 1) = ""/""
	|	ИЛИ ПОДСТРОКА(ВерсииФайлов.ПутьКФайлу, 1, 1) = ""\"")
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ПустаяСсылка());
	Результат = Запрос.Выполнить().Выгрузить();
	Пока Результат.Количество() > 0 Цикл
		ВерсииДляОбработки = Результат.ВыгрузитьКолонку("Ссылка");
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ВерсииДляОбработки);
		Запрос.УстановитьПараметр("Ссылка", ВерсииДляОбработки[ВерсииДляОбработки.ВГраница()]);
		//@skip-check query-in-loop - Порционная регистрация данных для обработки
		Результат = Запрос.Выполнить().Выгрузить();
	КонецЦикла;

КонецПроцедуры

Процедура ОбработатьПутьХраненияВерсий(Параметры) Экспорт

	ВерсияСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВерсииФайлов");

	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	СписокОшибок = Новый Массив;

	Пока ВерсияСсылка.Следующий() Цикл
		Результат = УдалитьЛишнийРазделитель(ВерсияСсылка.Ссылка);

		Если Результат.Статус = "Ошибка" Тогда
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			СписокОшибок.Добавить(Результат.ТекстОшибки);
		Иначе
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВерсияСсылка.Ссылка);
		КонецЕсли;

		Если ОбъектовОбработано + ПроблемныхОбъектов = 1000 Тогда
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
		"Справочник.ВерсииФайлов");

	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые версии файлов (пропущены): %1
				 |%2'"), ПроблемныхОбъектов, СтрСоединить(СписокОшибок, Символы.ПС));
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, Метаданные.Справочники.ВерсииФайлов,, 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция версий файлов: %1'"), 
				ОбъектовОбработано));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УдалитьЛишнийРазделитель(ВерсияСсылка)

	Результат =  Новый Структура;
	Результат.Вставить("Статус", "ОбновлениеНеТребуется");
	Результат.Вставить("ТекстОшибки", "");
	НовыйПутьКФайлу = Сред(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВерсияСсылка, "ПутьКФайлу"), 2);

	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииФайлов");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", ВерсияСсылка);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;

	НачатьТранзакцию();
	Попытка

		Блокировка.Заблокировать();
		ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
		ВерсияОбъект.ОбменДанными.Загрузка = Истина;
		ВерсияОбъект.ПутьКФайлу = НовыйПутьКФайлу;
		ВерсияОбъект.Записать();

		Результат.Статус = "Обновлен";
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ИнформацияОбОшибке = ИнформацияОбОшибке();

		Результат.Статус = "Ошибка";
		Результат.ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);

		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать версию файла %1 по причине: %2'"), ВерсияСсылка,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));

		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение, Метаданные.Справочники.ВерсииФайлов, ВерсияСсылка, ТекстСообщения);

	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли