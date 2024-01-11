///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеРасписанием

// Формирует новое описания параметров выполнения
// операций регламентного задания.
//
// Параметры:
//  ПериодичностьЗапуска - Число - периодичность запуска в минутах.
//
// Возвращаемое значение:
//  Структура - параметры выполнения:
//   *ПериодичностьЗапуска - Число - периодичность запуска в минутах.
//
Функция ОписаниеПараметровВыполнения(ПериодичностьЗапуска) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПериодичностьЗапуска", ПериодичностьЗапуска);
	
	Возврат Результат;
	
КонецФункции

// Определяет необходимость выполнения операции.
//
// Параметры:
//  Операция - Строка - идентификатор операции.
//
// Возвращаемое значение:
//  Булево - если Истина, необходимо выполнить операцию.
//
Функция ТребуетсяВыполнение(Операция) Экспорт
	
	Возврат ДатаСледующегоВыполнения(Операция) <= ТекущаяДатаСеанса();
	
КонецФункции

// Возвращает дату следующего выполнения.
//
// Параметры:
//  Операция - Строка - идентификатор операции.
//
// Возвращаемое значение:
//  Дата - Дата следующего выполнения.
//
Функция ДатаСледующегоВыполнения(Операция) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОперацииРегламентныхЗаданий.ДатаВыполнения КАК ДатаВыполнения
		|ИЗ
		|	&Мета_Таблица КАК ОперацииРегламентныхЗаданий
		|ГДЕ
		|	ОперацииРегламентныхЗаданий.Операция = &Операция";
	
	Запрос.УстановитьПараметр("Операция", Операция);
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&Мета_Таблица",
		"РегистрСведений." + ?((ОбщегоНазначения.РазделениеВключено()
			И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()),
			"ОперацииРегламентныхЗаданийОбластейДанных",
			"ОперацииРегламентныхЗаданий"));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат '00010101';
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.ДатаВыполнения;
	
КонецФункции

// Обновляет дату следующего выполнения операции.
//
// Параметры:
//  Операция - Строка - идентификатор операции;
//  ПараметрыВыполнения - Структура - см. РасписанияРегламентныхЗаданий.ОписаниеПараметровВыполнения.
//
Процедура ОперацияВыполнена(Операция, ПараметрыВыполнения) Экспорт

	ПроверитьПараметрыВыполнения(
		ПараметрыВыполнения,
		Операция);

	УстановитьДатуВыполненияОперации(Операция, ТекущаяДатаСеанса() + ПараметрыВыполнения.ПериодичностьЗапуска * 60);

КонецПроцедуры

// Сдвигает дату следующего выполнения операции на указанное количество секунд.
//
// Параметры:
//  Операция - Строка - идентификатор операции;
//  ВремяСекунд - Число - время в секундах, на которое необходимо отложить запуск.
//
Процедура ОтложитьОперацию(Операция, ВремяСекунд) Экспорт

	УстановитьДатуВыполненияОперации(Операция, ТекущаяДатаСеанса() + ВремяСекунд);

КонецПроцедуры

// Сдвигает дату следующего выполнения операции на определенное время со случайным разбросом,
// чтобы исключить одномоментное обращение к нашим сервисам.
//
// Параметры:
//  Операция    - Строка - идентификатор операции;
//  ВремяСекунд - Число - базовое время в секундах, на которое необходимо отложить запуск;
//  НачалоИнтервала   - Число - начало интервала разброса в секундах;
//  КонецИнтервала   - Число - конец интервала разброса в секундах.
//
Процедура ОтложитьОперациюСлучайно(
		Операция,
		ВремяСекунд,
		НачалоИнтервала,
		КонецИнтервала) Экспорт

	Если НачалоИнтервала >= КонецИнтервала Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для операции %1 некорректно указан интервал разброса (%2..%3)'"),
			Операция,
			НачалоИнтервала,
			КонецИнтервала);
	КонецЕсли;

	ГенераторСЧ = Новый ГенераторСлучайныхЧисел(Секунда(ТекущаяУниверсальнаяДата()));
	// Параметрами СлучайноеЧисло не могут быть отрицательные числа,
	//  поэтому для реализации интервала +- разброс придется задать другие ограничения.
	Разница = КонецИнтервала - НачалоИнтервала;
	СлучайноеЧислоСекунд = Цел(ГенераторСЧ.СлучайноеЧисло(0, Разница) - Разница / 2);

	УстановитьДатуВыполненияОперации(Операция, ТекущаяДатаСеанса() + ВремяСекунд + СлучайноеЧислоСекунд);

КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияСБиблиотекойТехнологияСервиса

// См. описание этой же процедуры в общем модуле
// ВыгрузкаЗагрузкаДанныхПереопределяемый.
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ОперацииРегламентныхЗаданий);
	Типы.Добавить(Метаданные.РегистрыСведений.ОперацииРегламентныхЗаданийОбластейДанных);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет корректность заполнения параметров выполнения.
// В случае возникновения ошибки будет вызвано исключение.
//
// Параметры:
//  ПараметрыВыполнения - Структура - см. ОписаниеПараметровВыполнения;
//  Операция - Строка - идентификатор операции.
//
Процедура ПроверитьПараметрыВыполнения(ПараметрыВыполнения, Операция)
	
	Если ПараметрыВыполнения = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для операции %1 не заполнены параметры выполнения'"),
			Операция);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет дату следующего выполнения операции.
//
// Параметры:
//  Операция       - Строка - идентификатор операции;
//  ДатаВыполнения - Дата - новая дата выполнения.
//
Процедура УстановитьДатуВыполненияОперации(Операция, ДатаВыполнения)

	БлокировкаДанных = Новый БлокировкаДанных;

	Если ОбщегоНазначения.РазделениеВключено()
			И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Запись = РегистрыСведений.ОперацииРегламентныхЗаданийОбластейДанных.СоздатьМенеджерЗаписи();
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ОперацииРегламентныхЗаданийОбластейДанных");
	Иначе
		Запись = РегистрыСведений.ОперацииРегламентныхЗаданий.СоздатьМенеджерЗаписи();
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ОперацииРегламентныхЗаданий");
	КонецЕсли;

	ЭлементБлокировки.УстановитьЗначение("Операция", Операция);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

	НачатьТранзакцию();
	Попытка
		БлокировкаДанных.Заблокировать();

		Запись.Операция = Операция;
		Запись.ДатаВыполнения = ДатаВыполнения;
		Запись.Записать();

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		// В общем случае ошибка блокировки может быть только в случае, когда
		// одновременно осуществляется запись одинаковой операции.
		// В этом случае время следующего запуска все равно будет одинаковым.
		// Никакие ошибки можно не писать и не выдавать.
	КонецПопытки;

КонецПроцедуры

#КонецОбласти