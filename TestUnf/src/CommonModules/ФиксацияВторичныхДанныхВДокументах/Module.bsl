
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает шаблон описания фиксируемого реквизита.
//    При использовании совместно с процедурой ДобавитьФиксируемыйРеквизит,
//    результат функции используется как шаблон описания группы фиксируемых реквизитов,
//    соответственно поля ИмяРеквизита и ОтображатьПредупреждение не заполняются,
//    а передаются в параметрах процедуры ДобавитьФиксируемыйРеквизит.
//
// Возвращаемое значение:
//   Структура - Описание "по умолчанию" фиксируемого реквизита.
//       * ИмяРеквизита - Строка - Имя реквизита объекта.
//       * ИмяГруппы - Строка - Имя группы реквизитов. Группы могут использоваться для фиксации и отмены фиксации.
//       * ОснованиеЗаполнения - Строка - Имя реквизита, на основе которого заполняется описываемый реквизит.
//       * ФиксацияГруппы - Булево - Не обязательный. Признак фиксации всей группы реквизитов как единого целого.
//           По умолчанию Ложь. Если Истина, то при изменении одного из реквизитов группы, фиксируется вся группа.
//       * Путь - Строка - Имя таблицы объекта, в которой размещен реквизит. Например: "ФизическиеЛица" или "Сотрудники".
//       * РеквизитСтроки - Булево - Признак того, что это реквизит табличной части.
//           По умолчанию Ложь. Если Истина, то необходимо также заполнить Путь.
//       * ОтображатьПредупреждение - Булево - Не обязательный. Признак отображения предупреждения при редактировании
//           автоматически заполненного (незафиксированного) реквизита.
//           По умолчанию Истина. Если Ложь, то при начале редактирования реквизита не будет выводиться предупреждение.
//           Имеет смысл отключать для реквизитов, которые требуется часто редактировать.
//           В частности, рекомендуется отключать для реквизитов, которые заполняются из последнего выбранного значения.
//       * СтрокаПредупреждения - Строка - Не обязательный. Сообщение, которое отображается перед началом редактирования.
//           Не используется если ОтображатьПредупреждение = Ложь.
//       * Используется - Булево - Не обязательный. Признак использования фиксации реквизита.
//           По умолчанию Истина. Если Ложь, то реквизит не фиксируется.
//           В некоторых объектах фиксируемость может зависеть от заполненности реквизитов-оснований.
//           В таких случаях рекомендуется изменять не состав фиксируемых реквизитов, а только данный флажок.
//
Функция ОписаниеФиксируемогоРеквизита() Экспорт
	
	ФиксацияРеквизита = Новый Структура();
	
	ФиксацияРеквизита.Вставить("ИмяРеквизита",             Неопределено);
	ФиксацияРеквизита.Вставить("ИмяГруппы",                Неопределено);
	ФиксацияРеквизита.Вставить("ОснованиеЗаполнения",      Неопределено);
	ФиксацияРеквизита.Вставить("ФиксацияГруппы",           Ложь);
	ФиксацияРеквизита.Вставить("Путь",                     "");
	ФиксацияРеквизита.Вставить("РеквизитСтроки",           Ложь);
	ФиксацияРеквизита.Вставить("ОтображатьПредупреждение", Истина);
	ФиксацияРеквизита.Вставить("СтрокаПредупреждения",     НСтр("ru = 'Эти данные заполнены автоматически'"));
	ФиксацияРеквизита.Вставить("Используется",             Истина);
	
	Возврат ФиксацияРеквизита;
	
КонецФункции

// Регистрирует описание фиксируемого реквизита.
//
// Параметры:
//   ФиксируемыеРеквизиты - Соответствие - Коллекция, в которую добавляется описание фиксируемого реквизита
//       и которая далее используется как первый параметр функции
//       ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксацииВторичныхДанных().
//   Шаблон - Структура - Описание группы фиксируемых реквизитов, полученное при помощи функции 
//       ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита().
//   ИмяРеквизита - Строка - Имя реквизита объекта.
//   ОтображатьПредупреждение - Булево - Признак отображения предупреждения при редактировании
//       автоматически заполненного (незафиксированного) реквизита.
//       Переопределяет значение флажка "Шаблон.ОтображатьПредупреждение" для данного реквизита.
//
Процедура ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Группа, ИмяРеквизита, ОтображатьПредупреждение = Неопределено) Экспорт
	Ключ = ?(Группа.Путь = Неопределено, ИмяРеквизита, Группа.Путь + ИмяРеквизита);
	Значение = Группа;
	Значение.ИмяРеквизита = ИмяРеквизита;
	Если ТипЗнч(ОтображатьПредупреждение) = Тип("Булево")
		И Значение.ОтображатьПредупреждение <> ОтображатьПредупреждение Тогда
		Значение = Новый Структура(Новый ФиксированнаяСтруктура(Значение));
		Значение.ОтображатьПредупреждение = ОтображатьПредупреждение;
	КонецЕсли;
	ФиксируемыеРеквизиты.Вставить(Ключ, Новый ФиксированнаяСтруктура(Значение));
КонецПроцедуры

// Процедура обновляет данные табличной части с учетом зафиксированных реквизитов.
// 	Параметры:
//    	МенеджерВременныхТаблиц 	- менеджер временных таблиц, должен содержать временную таблицу с именем переданным в
//    	                           ИмяВТ.
//    	ИмяВТ 		- строка, имя ВТ содержащей данные для обновления вторичных данных.
//    	Объект		- ДокументОбъект, объект в котором надо обновить вторичные данные в ТЧ.
//    	ИмяТЧ 		- имя обновляемой табличной части.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Функция ОбновитьВторичныеДанные(МенеджерВременныхТаблиц, Объект, ИмяТЧ = "", ИмяВТ = "ВТВторичныеДанные", ПараметрыФиксацииВторичныхДанных = Неопределено) Экспорт
	Если ПараметрыФиксацииВторичныхДанных = Неопределено Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Объект.Метаданные().ПолноеИмя());
		ПараметрыФиксацииВторичныхДанных = МенеджерОбъекта.ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	СоздатьВТОбновленныеДанные(МенеджерВременныхТаблиц, Объект, ИмяВТ, ИмяТЧ, ПараметрыФиксацииВторичныхДанных);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса = "ВЫБРАТЬ * ИЗ #ВТОбновленнаяТЧ# КАК ОбновленнаяТЧ";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ВТОбновленнаяТЧ#",	"ВТОбновленныеДанные" + ИмяТЧ);
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	ОбъектМодифицирован = Ложь;
	
	ФиксироватьОтличия = ПараметрыФиксацииВторичныхДанных.ФиксироватьОтличия;
	ИзменятьДанныеПриФиксацииОтличий = ПараметрыФиксацииВторичныхДанных.ИзменятьДанныеПриФиксацииОтличий;
	Если ИмяТЧ  = "" Тогда
		ОбновленныеДанные = Результат.Выгрузить()[0];
		Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
			Если ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
				Продолжить;
			КонецЕсли;
			ИмяРеквизита = ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
			Если Не ЗначениеЗаполнено(Объект[ИмяРеквизита]) И Не ЗначениеЗаполнено(ОбновленныеДанные[ИмяРеквизита]) Тогда
				Продолжить;
			КонецЕсли;
			СтароеЗначение = Объект[ИмяРеквизита];
			Объект[ИмяРеквизита] = ОбновленныеДанные[ИмяРеквизита];
			Если СтароеЗначение <> Объект[ИмяРеквизита] Тогда
				ОбъектМодифицирован = Истина;
				Если ФиксироватьОтличия Тогда
					Если Не ИзменятьДанныеПриФиксацииОтличий Тогда
						Объект[ИмяРеквизита] = СтароеЗначение;
					КонецЕсли;
					ЗафиксироватьРеквизитОбъекта(Объект, ИмяРеквизита);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОбновленныеДанные = Результат.Выгрузить();
		Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
			Если НЕ (ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки
				И ОписаниеФиксацииРеквизита.Значение.Путь = ИмяТЧ) Тогда
				Продолжить;
			КонецЕсли;
			ТабличнаяЧасть = Объект[ИмяТЧ];
			ИмяРеквизита = ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
			Для Каждого ОбновленнаяСтрока Из ОбновленныеДанные Цикл
				ИндексСтроки = ОбновленнаяСтрока["НомерСтроки"] - 1;
				ТекущаяСтрока = ТабличнаяЧасть[ИндексСтроки];
				Если Не ЗначениеЗаполнено(ОбновленнаяСтрока[ИмяРеквизита]) И Не ЗначениеЗаполнено(ТекущаяСтрока[ИмяРеквизита]) Тогда
					Продолжить;
				КонецЕсли;
				СтароеЗначение = ТекущаяСтрока[ИмяРеквизита];
				ТекущаяСтрока[ИмяРеквизита] = ОбновленнаяСтрока[ИмяРеквизита];
				Если СтароеЗначение <> ТекущаяСтрока[ИмяРеквизита] Тогда
					ОбъектМодифицирован = Истина;
					Если ФиксироватьОтличия Тогда
						Если Не ИзменятьДанныеПриФиксацииОтличий Тогда
							ТекущаяСтрока[ИмяРеквизита] = СтароеЗначение;
						КонецЕсли;
						ЗафиксироватьРеквизитОбъекта(Объект, ИмяРеквизита, ИмяТЧ, ТекущаяСтрока["ИдентификаторСтрокиФикс"]);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ОбъектМодифицирован;
КонецФункции

// Процедура обновляет данные шапки с учетом зафиксированных реквизитов.
//
// Параметры:
//   НовыеЗначенияРеквизитов - Структура - Новые значения реквизитов шапки документа.
//   Объект - ДокументОбъект.* - Документ в котором надо обновить вторичные данные.
//   ПараметрыФиксацииВторичныхДанных - Структура - Параметры фиксации реквизитов документа.
//       См. ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных().
//
Функция ОбновитьДанныеШапки(НовыеЗначенияРеквизитов, Объект, ПараметрыФиксацииВторичныхДанных = Неопределено) Экспорт
	Если ПараметрыФиксацииВторичныхДанных = Ложь Тогда
		Возврат ОбновитьДанныеШапкиБезУчетаФиксации(Объект, НовыеЗначенияРеквизитов);
	КонецЕсли;
	Если ПараметрыФиксацииВторичныхДанных = Неопределено Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Объект.Метаданные().ПолноеИмя());
		ПараметрыФиксацииВторичныхДанных = МенеджерОбъекта.ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	ОбъектМодифицирован = Ложь;
	
	ФиксироватьОтличия = ПараметрыФиксацииВторичныхДанных.ФиксироватьОтличия;
	ОписанияРеквизитов = ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов;
	ИзменятьДанныеПриФиксацииОтличий = ПараметрыФиксацииВторичныхДанных.ИзменятьДанныеПриФиксацииОтличий;
	Если ТипЗнч(ОписанияРеквизитов) = Тип("ФиксированноеСоответствие") Тогда
		ОписанияРеквизитов = Новый Соответствие(ОписанияРеквизитов); // Чтобы можно было получать значения по отсутствующим ключам.
	КонецЕсли;
	Для Каждого КлючИЗначение Из НовыеЗначенияРеквизитов Цикл
		ОписаниеРеквизита = ОписанияРеквизитов[КлючИЗначение.Ключ];
		Если ОписаниеРеквизита = Неопределено Тогда
			Продолжить; // Реквизит не фиксируется в данной конфигурации или режиме работы.
		КонецЕсли;
		ИмяРеквизита = ОписаниеРеквизита.ИмяРеквизита;
		Если Объект.ФиксацияИзменений.Найти(ИмяРеквизита, "ИмяРеквизита") <> Неопределено Тогда
			Продолжить; // Реквизит зафиксирован.
		КонецЕсли;
		СтароеЗначение = Объект[ИмяРеквизита];
		Если Не ЗначениеЗаполнено(СтароеЗначение) И Не ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить; // Оба значения - пустые.
		КонецЕсли;
		Объект[ИмяРеквизита] = КлючИЗначение.Значение; // Новое значение неявно приводится к типу реквизита.
		Если СтароеЗначение <> Объект[ИмяРеквизита] Тогда // Приведенное значение сравнивается со старым значением.
			ОбъектМодифицирован = Истина;
			Если ФиксироватьОтличия Тогда
				Если Не ИзменятьДанныеПриФиксацииОтличий Тогда
					Объект[ИмяРеквизита] = СтароеЗначение;
				КонецЕсли;
				ЗафиксироватьРеквизитОбъекта(Объект, ИмяРеквизита);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОбъектМодифицирован;
КонецФункции

// Процедура обновляет данные шапки с учетом зафиксированных реквизитов.
//
// Параметры:
//   Объект - ДокументОбъект.* - Документ в котором надо обновить вторичные данные.
//   ЗначенияРеквизитов - Структура - Новые значения реквизитов шапки документа.
//
Функция ОбновитьДанныеШапкиБезУчетаФиксации(Объект, ЗначенияРеквизитов) Экспорт
	ОбъектМодифицирован = Ложь;
	ИзмененныеРеквизиты = Новый Массив;
	
	Для Каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Структура = Новый Структура(ИмяРеквизита, Null);
		ЗаполнитьЗначенияСвойств(Структура, Объект);
		СтароеЗначение = Структура[ИмяРеквизита];
		Если СтароеЗначение = Null Тогда
			Продолжить; // Реквизит отсутствует
		ИначеЕсли Не ЗначениеЗаполнено(СтароеЗначение) И Не ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить; // Оба значения - пустые.
		КонецЕсли;
		Объект[ИмяРеквизита] = КлючИЗначение.Значение; // Новое значение неявно приводится к типу реквизита.
		Если СтароеЗначение <> Объект[ИмяРеквизита] Тогда // Приведенное значение сравнивается со старым значением.
			ОбъектМодифицирован = Истина;
			ИзмененныеРеквизиты.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
	Если ОбъектМодифицирован
		И ОбщегоНазначенияБЗК.ЗначениеСвойства(Объект, "ФиксацияИзменений") <> Неопределено Тогда
		ОтменитьФиксациюРеквизитовШапки(Объект, ИзмененныеРеквизиты);
	КонецЕсли;
	
	Возврат ОбъектМодифицирован;
КонецФункции


// Процедура обновляет данные шапки с учетом зафиксированных реквизитов.
//
// Параметры:
//   НовыеЗначенияРеквизитов - Структура            - Новые значения реквизитов шапки документа.
//   Объект                  - ДокументОбъект.*     - Документ в котором надо обновить вторичные данные.
//   ИмяТаблицы              - Строка               - Имя таблицы в которой надо обновить вторичные данные.
//   СтрокаТаблицы           - СтрокаТабличнойЧасти - Строка таблицы в которой надо обновить вторичные данные.
//   ИмяРеквизита            - Строка               - Имя фиксируемого реквизита.
//   ПараметрыФиксации       - Структура            - Параметры фиксации реквизитов документа.
//
Функция ОбновитьДанныеСтроки(НовыеЗначенияРеквизитов, Объект, ИмяТаблицы, СтрокаТаблицы, ПараметрыФиксации) Экспорт
	СтрокаМодифицирована = Ложь;
	
	ОписанияРеквизитов = ПараметрыФиксации.ОписаниеФиксацииРеквизитов;
	Если ТипЗнч(ОписанияРеквизитов) = Тип("ФиксированноеСоответствие") Тогда
		ОписанияРеквизитов = Новый Соответствие(ОписанияРеквизитов); // Чтобы можно было получать значения по отсутствующим ключам.
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из НовыеЗначенияРеквизитов Цикл
		ОписаниеРеквизита = ОписанияРеквизитов[ИмяТаблицы + КлючИЗначение.Ключ];
		Если ОписаниеРеквизита = Неопределено Тогда
			Продолжить; // Реквизит не фиксируется в данной конфигурации или режиме работы.
		КонецЕсли;
		ИмяРеквизита = ОписаниеРеквизита.ИмяРеквизита;
		Если РеквизитТаблицыЗафиксирован(Объект, ИмяТаблицы, СтрокаТаблицы, ИмяРеквизита) Тогда
			Продолжить; // Реквизит зафиксирован.
		КонецЕсли;
		СтароеЗначение = СтрокаТаблицы[ИмяРеквизита];
		Если Не ЗначениеЗаполнено(СтароеЗначение) И Не ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить; // Оба значения - пустые.
		КонецЕсли;
		СтрокаТаблицы[ИмяРеквизита] = КлючИЗначение.Значение; // Новое значение неявно приводится к типу реквизита.
		Если СтароеЗначение <> СтрокаТаблицы[ИмяРеквизита] Тогда // Приведенное значение сравнивается со старым значением.
			СтрокаМодифицирована = Истина;
			Если ПараметрыФиксации.ФиксироватьОтличия Тогда
				Если Не ПараметрыФиксации.ИзменятьДанныеПриФиксацииОтличий Тогда
					СтрокаТаблицы[ИмяРеквизита] = СтароеЗначение;
				КонецЕсли;
				ЗафиксироватьРеквизитОбъекта(СтрокаТаблицы, ИмяРеквизита);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаМодифицирована;
КонецФункции

// Проверяет зафиксирован-ли реквизит шапки документа.
//
// Параметры:
//   Объект       - ДокументОбъект.* - Документ с фиксируемым реквизитом.
//   ИмяРеквизита - Строка           - Имя реквизита.
//
// Возвращаемое значение:
//   Булево - Истина если реквизит зафиксирован.
//
Функция РеквизитШапкиЗафиксирован(Объект, ИмяРеквизита) Экспорт
	Возврат ЭлементыФиксации(Объект, ИмяРеквизита).Количество() > 0;
КонецФункции

// Проверяет зафиксированы-ли реквизиты шапки документа. Рекомендуется использовать в целях оптимизации.
//
// Параметры:
//   Объект          - ДокументОбъект.*          - Документ с фиксируемым реквизитом.
//   ИменаРеквизитов - Строка, Массив, Структура - Имена реквизитов.
//
// Возвращаемое значение:
//   Булево - Истина если все реквизиты зафиксированы.
//   Неопределено - Если передано значение недопустимого типа.
//
Функция РеквизитыШапкиЗафиксированы(Объект, ИменаРеквизитов) Экспорт
	Если ТипЗнч(ИменаРеквизитов) = Тип("Строка") Тогда
		Массив = СтрРазделить(ИменаРеквизитов, ", ", Ложь);
		Для Каждого ИмяРеквизита Из Массив Цикл
			Если Не РеквизитШапкиЗафиксирован(Объект, ИмяРеквизита) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ИменаРеквизитов) = Тип("Массив") Тогда
		Для Каждого ИмяРеквизита Из ИменаРеквизитов Цикл
			Если Не РеквизитШапкиЗафиксирован(Объект, ИмяРеквизита) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ИменаРеквизитов) = Тип("Структура") Тогда
		Для Каждого КлючИЗначение Из ИменаРеквизитов Цикл
			Если Не РеквизитШапкиЗафиксирован(Объект, КлючИЗначение.Ключ) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Возврат Истина;
КонецФункции

// Отменяет фиксацию реквизита шапки документа.
//
// Параметры:
//   Объект       - ДокументОбъект.* - Документ с фиксируемым реквизитом.
//   ИмяРеквизита - Строка           - Имя реквизита.
//
Процедура ОтменитьФиксациюРеквизитаШапки(Объект, ИмяРеквизита) Экспорт
	Найденные = ЭлементыФиксации(Объект, ИмяРеквизита);
	Для Каждого СтрокаТаблицы Из Найденные Цикл
		Объект.ФиксацияИзменений.Удалить(СтрокаТаблицы);
	КонецЦикла;
КонецПроцедуры

// Отменяет фиксацию реквизитов шапки документа.
//
// Параметры:
//   Объект          - ДокументОбъект.*          - Документ с фиксируемым реквизитом.
//   ИменаРеквизитов - Строка, Массив, Структура - Имена реквизитов.
//
Процедура ОтменитьФиксациюРеквизитовШапки(Объект, ИменаРеквизитов) Экспорт
	Если ТипЗнч(ИменаРеквизитов) = Тип("Строка") Тогда
		Массив = СтрРазделить(ИменаРеквизитов, ", ", Ложь);
		Для Каждого ИмяРеквизита Из Массив Цикл
			ОтменитьФиксациюРеквизитаШапки(Объект, ИмяРеквизита);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ИменаРеквизитов) = Тип("Массив") Тогда
		Для Каждого ИмяРеквизита Из ИменаРеквизитов Цикл
			ОтменитьФиксациюРеквизитаШапки(Объект, ИмяРеквизита);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ИменаРеквизитов) = Тип("Структура") Тогда
		Для Каждого КлючИЗначение Из ИменаРеквизитов Цикл
			ОтменитьФиксациюРеквизитаШапки(Объект, КлючИЗначение.Ключ);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Отменяет фиксацию реквизита шапки документа.
//
// Параметры:
//   Объект       - ДокументОбъект.* - Документ с фиксируемым реквизитом.
//   ИмяРеквизита - Строка           - Имя реквизита.
//
Процедура ОтменитьФиксациюРеквизитаТаблицы(Объект, ИмяТаблицы, СтрокаТаблицы, ИмяРеквизита) Экспорт
	Найденные = ЭлементыФиксации(Объект, ИмяРеквизита, ИмяТаблицы, СтрокаТаблицы.ИдентификаторСтрокиФикс);
	Для Каждого СтрокаТаблицы Из Найденные Цикл
		Объект.ФиксацияИзменений.Удалить(СтрокаТаблицы);
	КонецЦикла;
КонецПроцедуры

// Проверяет зафиксирован-ли реквизит строки таблицы документа.
//
// Параметры:
//   Объект        - ДокументОбъект.*     - Документ с табличной частью и фиксируемым реквизитом.
//   ИмяТаблицы    - Строка               - Имя таблицы с реквизитом.
//   СтрокаТаблицы - СтрокаТабличнойЧасти - Строка таблицы с реквизитом.
//   ИмяРеквизита  - Строка               - Имя фиксируемого реквизита.
//
// Возвращаемое значение:
//   Булево - Истина если реквизит зафиксирован.
//
Функция РеквизитТаблицыЗафиксирован(Объект, ИмяТаблицы, СтрокаТаблицы, ИмяРеквизита) Экспорт
	Возврат ЭлементыФиксации(Объект, ИмяРеквизита, ИмяТаблицы, СтрокаТаблицы.ИдентификаторСтрокиФикс).Количество() > 0;
КонецФункции

// Отменяет фиксацию всех реквизитов табличной части или реквизитов указанной строки табличной части.
//
// Параметры:
//   Объект - Произвольный - Объект с табличной частью.
//   ИмяТЧ - Строка - Имя табличной части.
//   СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - Необязательный. Строка табличной части.
//   ПараметрыФиксации - Структура, Неопределено - Необязательный. Параметры фиксации вторичных данных объекта.
//
Процедура ОтменитьФиксациюТабличнойЧасти(Объект, ИмяТЧ, СтрокаТабличнойЧасти = Неопределено, ПараметрыФиксации = Неопределено) Экспорт
	Если ПараметрыФиксации = Неопределено Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Объект.Метаданные().ПолноеИмя());
		ПараметрыФиксации = МенеджерОбъекта.ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	ТаблицаФиксацииИзменений = Объект.ФиксацияИзменений;
	
	Фильтр = Новый Структура("Путь", ИмяТЧ);
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		Фильтр.Вставить("ИдентификаторСтроки", СтрокаТабличнойЧасти.ИдентификаторСтрокиФикс);
	КонецЕсли;
	
	Найденные = ТаблицаФиксацииИзменений.НайтиСтроки(Фильтр);
	Для Каждого Строка Из Найденные Цикл
		ТаблицаФиксацииИзменений.Удалить(Строка)
	КонецЦикла;
КонецПроцедуры

// Процедура переносит признаки фиксации из реквизитов формы в табличную часть объекта.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура ЗафиксироватьВторичныеДанныеДокумента(Объект, ПараметрыФиксацииВторичныхДанных = Неопределено) Экспорт
	Если ПараметрыФиксацииВторичныхДанных = Неопределено Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Объект.Метаданные().ПолноеИмя());
		ПараметрыФиксацииВторичныхДанных = МенеджерОбъекта.ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	Объект.ФиксацияИзменений.Очистить();
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если НЕ ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
			НоваяФиксацияРеквизита = Объект.ФиксацияИзменений.Добавить();
			НоваяФиксацияРеквизита.ИмяРеквизита = ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
			НоваяФиксацияРеквизита.Путь 		= ОписаниеФиксацииРеквизита.Значение.Путь;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыФиксацииВторичныхДанных.ОписанияТЧ  = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТЧДокумента Из ПараметрыФиксацииВторичныхДанных.ОписанияТЧ Цикл
		ИдентификаторСтрокиФикс = 1;
		Для каждого СтрокаТЧ Из Объект[ТЧДокумента.Ключ] Цикл
			СтрокаТЧ["ИдентификаторСтрокиФикс"] = ИдентификаторСтрокиФикс;
			Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
				Если ОписаниеФиксацииРеквизита.Значение.РеквизитСтроки Тогда
					НоваяФиксацияРеквизита 						= Объект.ФиксацияИзменений.Добавить();
					НоваяФиксацияРеквизита.ИмяРеквизита 		= ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита;
					НоваяФиксацияРеквизита.Путь 				= ОписаниеФиксацииРеквизита.Значение.Путь;
					НоваяФиксацияРеквизита.ИдентификаторСтроки 	= ИдентификаторСтрокиФикс;
				КонецЕсли;
			КонецЦикла;
			ИдентификаторСтрокиФикс = ИдентификаторСтрокиФикс + 1;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьФизическоеЛицо(Объект) Экспорт
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Объект.ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сотрудник, "ФизическоеЛицо");
	Иначе
		Объект.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры

// Возвращает параметры механизма фиксации изменений.
//
// Параметры:
//   ФиксируемыеРеквизиты - Соответствие - Описание фиксируемых реквизитов, их групп и зависимостей.
//       См. описание процедуры ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит().
//   ПоляУникальностиТаблиц - Структура - Описание ключей уникальности табличных частей.
//       * Ключ     - Строка            - Имя табличной части.
//       * Значение - Массив из Строка  - Имена реквизитов табличной части, определяющих уникальность строки.
//
// Возвращаемое значение:
//   Структура - Параметры фиксации.
//
Функция ПараметрыФиксации(ФиксируемыеРеквизиты, ПоляУникальностиТаблиц = Неопределено) Экспорт
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОписаниеФиксацииРеквизитов", ФиксируемыеРеквизиты);
	СтруктураПараметров.Вставить("ОписанияТЧ",                 ПоляУникальностиТаблиц);
	СтруктураПараметров.Вставить("ЖирныйШрифт",                ШрифтТекста(Истина));
	СтруктураПараметров.Вставить("НеЖирныйШрифт",              ШрифтТекста(Ложь));
	СтруктураПараметров.Вставить("ФиксироватьОтличия",         Ложь);
	СтруктураПараметров.Вставить("ИзменятьДанныеПриФиксацииОтличий", Ложь);
	Возврат СтруктураПараметров
КонецФункции

#Область ОбновлениеИнформационнойБазы

// Устанавливает признак фиксации реквизита объекта.
//
// Параметры:
//   Объект - ДокументОбъект.*, * - Объект данных с табличной частью "ФиксацияИзменений".
//   ИмяРеквизита - Строка - Имя фиксируемого реквизита.
//   ИмяТаблицы - Строка - Необязательный. Имя табличной части с реквизитом.
//   ИдентификаторСтрокиФикс - Число - Необязательный. Идентификатор фиксируемой строки табличной части.
//
Процедура ЗафиксироватьРеквизитОбъекта(Объект, ИмяРеквизита, ИмяТаблицы = "", ИдентификаторСтрокиФикс = 0) Экспорт
	
	Фильтр = Неопределено;
	Найденные = ЭлементыФиксации(Объект, ИмяРеквизита, ИмяТаблицы, ИдентификаторСтрокиФикс, Фильтр);
	Если Найденные.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект.ФиксацияИзменений.Добавить(), Фильтр);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак фиксации реквизита шапки документа.
//
// Параметры:
//   Объект       - ДокументОбъект.* - Документ с фиксируемым реквизитом.
//   ИмяРеквизита - Строка           - Имя реквизита.
//
// Возвращаемое значение:
//   Булево - Удалось ли зафиксировать реквизит шапки или реквизит уже был зафиксирован ранее.
//       Истина - Реквизит шапки успешно зафиксирован.
//       Ложь   - Реквизит шапки уже был зафиксирован ранее.
//
//
Функция ЗафиксироватьРеквизитШапки(Объект, ИмяРеквизита) Экспорт
	
	Фильтр = Неопределено;
	Найденные = ЭлементыФиксации(Объект, ИмяРеквизита, , , Фильтр);
	
	Если Найденные.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект.ФиксацияИзменений.Добавить(), Фильтр);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Устанавливает признак фиксации реквизита строки таблицы документа.
//
// Параметры:
//   Объект        - ДокументОбъект.*     - Документ с табличной частью и фиксируемым реквизитом.
//   ИмяТаблицы    - Строка               - Имя таблицы с реквизитом.
//   СтрокаТаблицы - СтрокаТабличнойЧасти - Строка таблицы с реквизитом.
//   ИмяРеквизита  - Строка               - Имя фиксируемого реквизита.
//
// Возвращаемое значение:
//   Булево - Удалось ли зафиксировать реквизит таблицы или реквизит уже был зафиксирован ранее.
//       Истина - Реквизит таблицы зафиксирован.
//       Ложь   - Реквизит таблицы уже был зафиксирован ранее.
//
//
Функция ЗафиксироватьРеквизитТаблицы(Объект, ИмяТаблицы, СтрокаТаблицы, ИмяРеквизита) Экспорт
	
	Фильтр = Неопределено;
	Найденные = ЭлементыФиксации(Объект, ИмяРеквизита, ИмяТаблицы, СтрокаТаблицы.ИдентификаторСтрокиФикс, Фильтр);
	
	Если Найденные.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект.ФиксацияИзменений.Добавить(), Фильтр);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита.
// Функция возвращает структуру для формирования описания элемента фиксации реквизита.
// 	Параметры:
//    	Нет
// 	Возвращаемое значение
//		Структура с полями:
//			Имя реквизита 				- Строка, имя реквизита объекта фиксируемого механизмом.
//          ИмяГруппы               	- Строка, имя группировки описаний, механизм позволяет зафиксировать или снять
//                                     фиксацию для всех элементов группировки.
//          ОснованиеЗаполнения     	- Строка, имя группировки описаний, механизм позволяет зафиксировать или снять
//                                     фиксацию для всех элементов группировки.
//          Путь                    	- Строка, путь к таблице -  реквизиту формы, например ФизическиеЛица или.
//                                     Сотрудники(если реквизит ТЧ)  или ""(если реквизит объекта).
//          ОтображатьПредупреждение    - Булево, необходимость отображать предупреждение при редактировании для
//                                        реквизитов формы.
//          СтрокаПредупреждения    	- Строка, предупреждение при редактировании.
//          Используется			    - Булево, фиксация реквизита может использоваться не всегда.
//          РеквизитСтроки			    - Булево, реквизит относится к табличной части.
//
Функция СтруктураПараметровОписанияФиксацииРеквизитов() Экспорт
	Возврат ОписаниеФиксируемогоРеквизита();
КонецФункции

// Устарела. Следует использовать ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит.
// Функция возвращает описание элемента описания фиксации реквизитов.
// 	Параметры:
//    	ПараметрыОписания - Структура с полями как у ОписаниеФиксируемогоРеквизита().
// 	Возвращаемое значение
//		Структура с полями - см. описание ОписаниеФиксируемогоРеквизита().
//
Функция ОписаниеФиксацииРеквизита(ПараметрыОписания) Экспорт
	ФиксацияРеквизита = ОписаниеФиксируемогоРеквизита();
	
	ЗаполнитьЗначенияСвойств(ФиксацияРеквизита, ПараметрыОписания);
	
	Возврат Новый ФиксированнаяСтруктура(ФиксацияРеквизита);
КонецФункции

// Устарела. Следует использовать ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации.
// Функция возвращает структуру параметров механизма фиксации изменений.
// 	Параметры:
//    	Нет
// 	Возвращаемое значение
//		Структура с полями:
//			ОписаниеФиксацииРеквизитов 			- Структура, см. ОписаниеФиксируемогоРеквизита.
//          ИмяТабличнойЧастиФиксацияИзменений  - Строка, имя ТЧ в которой хранятся признаки зафиксированности
//                                                реквизитов формы.
//
Функция ПараметрыФиксацииВторичныхДанных(ОписаниеФиксацииРеквизитов, ИмяТабличнойЧастиФиксацияИзменений = "ФиксацияИзменений", ОписанияТЧ = Неопределено) Экспорт
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОписаниеФиксацииРеквизитов", 			ОписаниеФиксацииРеквизитов);
	СтруктураПараметров.Вставить("ОписанияТЧ", 							ОписанияТЧ);
	СтруктураПараметров.Вставить("ИмяТабличнойЧастиФиксацияИзменений", 	ИмяТабличнойЧастиФиксацияИзменений);
	СтруктураПараметров.Вставить("ЖирныйШрифт", 	ШрифтТекста(Истина));
	СтруктураПараметров.Вставить("НеЖирныйШрифт", 	ШрифтТекста(Ложь));
	СтруктураПараметров.Вставить("ФиксироватьОтличия", Ложь);
	СтруктураПараметров.Вставить("ИзменятьДанныеПриФиксацииОтличий", Ложь);
	Возврат СтруктураПараметров
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает элементы табличной части ФиксацияИзменений, соответствующие указанному реквизиту.
Функция ЭлементыФиксации(Объект, ИмяРеквизита, ИмяТаблицы = "", ИдентификаторСтрокиФикс = 0, Фильтр = Неопределено)
	Фильтр = Новый Структура;
	Фильтр.Вставить("ИмяРеквизита", ИмяРеквизита);
	Фильтр.Вставить("Путь", ИмяТаблицы);
	Если ИмяТаблицы <> "" Тогда
		Фильтр.Вставить("ИдентификаторСтроки", ИдентификаторСтрокиФикс);
	КонецЕсли;
	Возврат Объект.ФиксацияИзменений.НайтиСтроки(Фильтр);
КонецФункции

Функция ШрифтТекста(Жирный)
	Возврат ?(Жирный, ШрифтыСтиля.ИзмененныйРеквизитШрифт, ШрифтыСтиля.ОбычныйШрифтТекста);
КонецФункции

// Процедура создает образ табличной части с учетом зафиксированных реквизитов.
// 	Параметры:
//    	МенеджерВременныхТаблиц 	- менеджер временных таблиц, должен содержать временную таблицу с именем переданным в
//    	                           ИмяВТ.
//    	ИмяВТ 		- строка, имя ВТ содержащей данные для обновления вторичных данных.
//    	Объект		- ДокументОбъект, объект в котором надо обновить вторичные данные в ТЧ.
//    	ИмяТЧ 		- имя обновляемой табличной части.
//    	ПараметрыФиксацииВторичныхДанных - структура см.
//    	                                   ФиксацияВторичныхДанныхВДокументахКлиентСервер.ПараметрыФиксацииВторичныхДанных.
//
Процедура СоздатьВТОбновленныеДанные(МенеджерВременныхТаблиц, Объект, ИмяВТ = "ВТВторичныеДанные", ИмяТЧ = "", ПараметрыФиксацииВторичныхДанных = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	*
	|ИЗ
	|	#ИмяВТ# КАК ДанныеБД";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяВТ#", ИмяВТ);
	Запрос.Текст = ТекстЗапроса;
	ОбновляемыеПоля = Запрос.Выполнить().Выгрузить();
	
	Если НЕ ИмяТЧ = "" Тогда
		ОписанияТЧ = ПараметрыФиксацииВторичныхДанных.ОписанияТЧ;
		Если ОписанияТЧ = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		КлючевыеПоляТЧ = Неопределено;
		Если НЕ ОписанияТЧ.Свойство(ИмяТЧ, КлючевыеПоляТЧ) Тогда
			Возврат
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеФиксации = Новый ТаблицаЗначений;
	ТипБулево = Новый ОписаниеТипов("Булево");
	
	Реквизиты = Новый Массив;
	
	Если ИмяТЧ = "" Тогда
		Для каждого Реквизит Из Объект.Метаданные().Реквизиты Цикл
			Реквизиты.Добавить(Новый Структура("Имя,Тип", Реквизит.Имя, Реквизит.Тип));
		КонецЦикла;
		// Т.к. в запросе будем использовать поле ИдентификаторСтрокиФикс, то добавим его в таблицы.
		// Для не ТЧ всегда = 0.
		ДанныеФиксации.Колонки.Добавить("ИдентификаторСтрокиФикс", Новый ОписаниеТипов("Число"));
	Иначе
		Для каждого Реквизит Из Объект.Метаданные().ТабличныеЧасти[ИмяТЧ].Реквизиты Цикл
			Реквизиты.Добавить(Новый Структура("Имя,Тип", Реквизит.Имя, Реквизит.Тип));
		КонецЦикла;
		
		// Для ТЧ также добавим стандартные реквизиты, ожидая, что там только номер строки.
		Для каждого Реквизит Из Объект.Метаданные().ТабличныеЧасти[ИмяТЧ].СтандартныеРеквизиты Цикл
			Реквизиты.Добавить(Новый Структура("Имя,Тип", Реквизит.Имя, Реквизит.Тип));
		КонецЦикла;
	КонецЕсли;
	
	Для каждого ТекущийРеквизит Из Реквизиты Цикл
		Если ТекущийРеквизит.Имя = "ИдентификаторСтрокиФикс" Тогда
			ДанныеФиксации.Колонки.Добавить(ТекущийРеквизит.Имя, ТекущийРеквизит.Тип);
		Иначе
			ДанныеФиксации.Колонки.Добавить(ТекущийРеквизит.Имя, ТипБулево);
		КонецЕсли;
	КонецЦикла;
	
	СтрокиФиксацииПоПути = Объект.ФиксацияИзменений.НайтиСтроки(Новый Структура("Путь", ИмяТЧ));
	Для каждого СтрокаФиксации Из СтрокиФиксацииПоПути Цикл
		ЗаполняемаяСтрокаФиксации = ДанныеФиксации.Найти(СтрокаФиксации.ИдентификаторСтроки, "ИдентификаторСтрокиФикс");
		Если ЗаполняемаяСтрокаФиксации = Неопределено Тогда
			ЗаполняемаяСтрокаФиксации = ДанныеФиксации.Добавить();
			ЗаполняемаяСтрокаФиксации.ИдентификаторСтрокиФикс = СтрокаФиксации.ИдентификаторСтроки;
		КонецЕсли;
		ЗаполняемаяСтрокаФиксации[СтрокаФиксации.ИмяРеквизита] = Истина;
	КонецЦикла;
	
	Если ИмяТЧ = "" Тогда
		ДанныеДокумента = Новый ТаблицаЗначений;
		Для каждого ТекущийРеквизит Из Реквизиты Цикл
			ДанныеДокумента.Колонки.Добавить(ТекущийРеквизит.Имя, ТекущийРеквизит.Тип);
		КонецЦикла;
		ДанныеДокумента.Колонки.Добавить("ИдентификаторСтрокиФикс", Новый ОписаниеТипов("Число"));
		
		ЗаполнитьЗначенияСвойств(ДанныеДокумента.Добавить(), Объект);
	Иначе
		ДанныеДокумента = Объект[ИмяТЧ].Выгрузить();
	КонецЕсли;
	
	// Подготовим блоки для замены в запросе.
	
	// #СтрокаОбновляемыеПоляСВыбором#
	ШаблонПоляСВыбором = "
	|	ВЫБОР
	|		КОГДА ДанныеФиксации.ИмяПоля ИЛИ ДанныеБД.ИмяПоля ЕСТЬ NULL
	|			ТОГДА ДанныеВДокументе.ИмяПоля
	|		ИНАЧЕ ДанныеБД.ИмяПоля
	|	КОНЕЦ КАК ИмяПоля,";
	
	ШаблонПоляДокумента = "
	|	ДанныеВДокументе.ИмяПоля КАК ИмяПоля,";
	
	// #СтрокаОбновляемыеПоля#
	ШаблонПоляФикс = "
	|	ЕстьNULL(ДанныеФиксации.ИмяПоля, 0) КАК ИмяПоля,";
	
	ШаблонПоля = "
	|	Таблица.ИмяПоля КАК ИмяПоля,";
	
	СтрокаОбновляемыеПоля = "";
	СтрокаПоляДанных = "";
	
	Если ИмяТЧ = "" Тогда
		СтрокаПоляДанных = СтрокаПоляДанных + СтрЗаменить(ШаблонПоля, "ИмяПоля", "ИдентификаторСтрокиФикс");
	КонецЕсли;
	
	Для каждого Колонка Из Реквизиты Цикл
		Если Колонка.Имя = "ИдентификаторСтрокиФикс" Тогда
			СтрокаОбновляемыеПоля = СтрокаОбновляемыеПоля + СтрЗаменить(ШаблонПоляФикс, "ИмяПоля", Колонка.Имя);
		Иначе
			ПолеВторичныхДанных = Ложь;
			Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
				Если ОписаниеФиксацииРеквизита.Значение.Путь = ИмяТЧ И Колонка.Имя = ОписаниеФиксацииРеквизита.Значение.ИмяРеквизита Тогда
					ПолеВторичныхДанных = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ПолеВторичныхДанных И ОбновляемыеПоля.Колонки.Найти(Колонка.Имя) <> Неопределено И ?(ИмяТЧ = "", Истина, (КлючевыеПоляТЧ.Найти(Колонка.Имя) = Неопределено)) Тогда
				СтрокаОбновляемыеПоля = СтрокаОбновляемыеПоля + СтрЗаменить(ШаблонПоляСВыбором, "ИмяПоля", Колонка.Имя);
			Иначе
				СтрокаОбновляемыеПоля = СтрокаОбновляемыеПоля + СтрЗаменить(ШаблонПоляДокумента, "ИмяПоля", Колонка.Имя);
			КонецЕсли;
		КонецЕсли;
		СтрокаПоляДанных = СтрокаПоляДанных + СтрЗаменить(ШаблонПоля, "ИмяПоля", Колонка.Имя);
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СтрокаОбновляемыеПоля, 1);
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СтрокаПоляДанных, 1);
	
	// #УсловияСоединения#
	СтрокаУсловияСоединения = "";
	Если НЕ ИмяТЧ = "" Тогда
		Для каждого КлючевоеПоле Из КлючевыеПоляТЧ Цикл
			СтрокаУсловияСоединения = СтрокаУсловияСоединения +"
			| ДанныеБД." + КлючевоеПоле + " = ДанныеВДокументе." + КлючевоеПоле + " И";
		КонецЦикла;
	КонецЕсли;
	
	СтрокаУсловияСоединения = ?(СтрокаУсловияСоединения = "", "ИСТИНА ", СтрокаУсловияСоединения);
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СтрокаУсловияСоединения, 1);
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	#СтрокаПоляДанных#
	|ПОМЕСТИТЬ ВТДанныеВДокументе
	|ИЗ
	|	&ДанныеВОбъекте КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	#СтрокаПоляДанных#
	|ПОМЕСТИТЬ ВТДанныеФиксации
	|ИЗ
	|	&ДанныеФиксации КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	#СтрокаОбновляемыеПоляСВыбором#
	|	ПОМЕСТИТЬ #ВТОбновленнаяТЧ#
	| ИЗ
	|	ВТДанныеВДокументе КАК ДанныеВДокументе
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ИмяВТ# КАК ДанныеБД
	|			ПО #УсловияСоединения#
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеФиксации КАК ДанныеФиксации
	|			ПО ДанныеВДокументе.ИдентификаторСтрокиФикс = ДанныеФиксации.ИдентификаторСтрокиФикс;
	|	
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДанныеВДокументе;
	|	
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДанныеФиксации";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#СтрокаОбновляемыеПоляСВыбором#", 	СтрокаОбновляемыеПоля);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#СтрокаПоляДанных#", 					СтрокаПоляДанных);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#УсловияСоединения#", 				СтрокаУсловияСоединения);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяВТ#", 							ИмяВТ);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ВТОбновленнаяТЧ#", 					"ВТОбновленныеДанные" + ИмяТЧ);
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДанныеВОбъекте", ДанныеДокумента);
	Запрос.УстановитьПараметр("ДанныеФиксации", ДанныеФиксации);
	
	Запрос.Выполнить();
КонецПроцедуры

#КонецОбласти