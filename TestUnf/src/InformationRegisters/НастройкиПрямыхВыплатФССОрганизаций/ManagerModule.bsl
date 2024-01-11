#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область Редактирование

Функция Прочитать(Организация) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ * ИЗ РегистрСведений.НастройкиПрямыхВыплатФССОрганизаций ГДЕ Организация = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() = 0 Тогда
		СтрокаТаблицы = Таблица.Добавить();
		СтрокаТаблицы.Организация = Организация;
		СтрокаТаблицы.ИспользоватьЗарплатныйПроект = Ложь;
		СтрокаТаблицы.ИспользоватьЗарплатныйБанковскийСчет = Истина;
		СтрокаТаблицы.ИспользоватьОсновноеМестоРаботы = Истина;
	КонецЕсли;
	
	МассивСтруктур = ОбщегоНазначения.ТаблицаЗначенийВМассив(Таблица);
	
	Возврат МассивСтруктур[0];
КонецФункции

Функция ЗаписатьМенеджерЗаписи(МенеджерЗаписи) Экспорт
	Набор = НачатьЗаписьНабора(МенеджерЗаписи.Организация);
	Если Набор = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если (Не МенеджерЗаписи.ИспользоватьЗарплатныйПроект Или Не ЗначениеЗаполнено(МенеджерЗаписи.ЗарплатныйПроект))
		И МенеджерЗаписи.ИспользоватьЗарплатныйБанковскийСчет
		И МенеджерЗаписи.ИспользоватьОсновноеМестоРаботы Тогда
		
		Набор.Очистить();
		
	Иначе
		
		Если Набор.Количество() = 0 Тогда
			Запись = Набор.Добавить();
		Иначе
			Запись = Набор[0];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Запись, МенеджерЗаписи);
		
	КонецЕсли;
	
	ЗавершитьЗаписьНабора(Набор);
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область НаборЗаписей

// АПК:326-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// АПК:325-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// Транзакция открывается в методе НачатьЗаписьНабора, закрывается в ЗавершитьЗаписьНабора, отменяется в ОтменитьЗаписьНабора.

// Транзакционный вариант (с управляемой блокировкой) получения набора записей, соответствующего значениям измерений.
//
// Параметры:
//   Организация - ОпределяемыйТип.Организация - Значение отбора по соответствующему измерению.
//
// Возвращаемое значение:
//   РегистрСведенийНаборЗаписей.НастройкиПрямыхВыплатФССОрганизаций - Если удалось установить блокировку
//       и прочитать набор записей. При необходимости, открывает свою локальную транзакцию. Для закрытия транзакции
//       следует использовать одну из терминирующих процедур: ЗавершитьЗаписьНабора, либо ОтменитьЗаписьНабора.
//   Неопределено - Если не удалось установить блокировку и прочитать набор записей.
//       Вызывать процедуры ЗавершитьЗаписьНабора, ОтменитьЗаписьНабора не требуется,
//       поскольку если перед блокировкой функции потребовалось открыть локальную транзакцию,
//       то после неудачной блокировки локальная транзакция была отменена.
//
Функция НачатьЗаписьНабора(Организация) Экспорт
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПолныеПраваИлиПривилегированныйРежим = Пользователи.ЭтоПолноправныйПользователь();
	Если Не ПолныеПраваИлиПривилегированныйРежим
		И Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФССОрганизаций) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".'"),
			Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФССОрганизаций.Представление());
	КонецЕсли;
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиПрямыхВыплатФССОрганизаций");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		Блокировка.Заблокировать();
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Прочитать();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЛокальнаяТранзакция", ЛокальнаяТранзакция);
	Исключение
		Если ЛокальнаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось изменить настройки способа прямых выплат ФСС организации %1 по причине: %2'"),
			Организация,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		СпособыПрямыхВыплатФСС.ЗаписатьОшибку(
			Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФССОрганизаций,
			Организация,
			ТекстСообщения);
		НаборЗаписей = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НаборЗаписей;
КонецФункции

// Записывает набор и фиксирует локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.НастройкиПрямыхВыплатФССОрганизаций
//
Процедура ЗавершитьЗаписьНабора(НаборЗаписей) Экспорт
	НаборЗаписей.Записать(Истина);
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Отменяет запись набора и отменяет локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.НастройкиПрямыхВыплатФССОрганизаций
//
Процедура ОтменитьЗаписьНабора(НаборЗаписей) Экспорт
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// АПК:326-вкл.
// АПК:325-вкл.

#КонецОбласти

#КонецОбласти

#КонецЕсли