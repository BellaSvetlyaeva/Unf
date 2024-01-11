#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Получатели.Контакт, NULL КАК ИСТИНА)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбработчикиОбновления

// Меняет старое состояние Отправлено на состояние Внешний сервис
// Версия 3.0.6
//
// Параметры:
//  Параметры - Структура - См. ОбновлениеИнформационнойБазыУНФ.ПриДобавленииОбработчиковОбновления
//
Процедура УстановитьНовоеСостояниеДляВнешнихСервисов(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	МассоваяРассылка.Ссылка КАК Ссылка,
		|	МассоваяРассылка.Представление КАК Представление
		|ИЗ
		|	Документ.МассоваяРассылка КАК МассоваяРассылка
		|ГДЕ
		|	МассоваяРассылка.СервисМассовойРассылки <> ЗНАЧЕНИЕ(Перечисление.СервисыМассовыхРассылок.ПустаяСсылка)
		|	И МассоваяРассылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОтправкиРассылки.Отправлено)
		|
		|УПОРЯДОЧИТЬ ПО
		|	МассоваяРассылка.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Параметры.ОбработкаЗавершена = Истина;
		ТекстСообщения = НСтр(
		"ru='Процедура УстановитьНовоеСостояниеДляВнешнихСервисов завершила обработку. Запрос вернул пустую порцию документов.'",
		ОбщегоНазначения.КодОсновногоЯзыка());
		
		ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Документы.МассоваяРассылка, ,
		ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			ОбъектРассылка = Выборка.Ссылка.ПолучитьОбъект();
			Если ОбъектРассылка = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбъектРассылка.Заблокировать();
			ОбъектРассылка.Состояние = Перечисления.СостоянияОтправкиРассылки.ВнешнийСервис;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектРассылка);
			ЗафиксироватьТранзакцию();
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстСообщения = НСтр("ru='Не удалось обработать объект ""%1"" по причине:
			|%2'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Представление, ТекстОшибки);
			
			ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.МассоваяРассылка,
			Выборка.Ссылка,
			ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано Тогда
		
		ТекстСообщения = НСтр(
		"ru='Процедура УстановитьНовоеСостояниеДляВнешнихСервисов обработала очередную порцию объектов: %1'",
		ОбщегоНазначения.КодОсновногоЯзыка());
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОбъектовОбработано);
		
		ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Документы.МассоваяРассылка, ,
		ТекстСообщения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Процедуре УстановитьНовоеСостояниеДляВнешнихСервисов не удалось обработать некоторые объекты (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

// Меняет старое состояние Отправлено на новые
// Версия 3.0.6
//
// Параметры:
//  Параметры - Структура - См. ОбновлениеИнформационнойБазыУНФ.ПриДобавленииОбработчиковОбновления
//
Процедура УстановитьНовыеСостоянияДляРассылок(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ДокументМассоваяРассылка.Ссылка КАК Ссылка,
		|	ДокументМассоваяРассылка.Представление КАК Представление
		|ИЗ
		|	РегистрСведений.ОчередьРассылок КАК ОчередьРассылок
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.МассоваяРассылка КАК ДокументМассоваяРассылка
		|		ПО ОчередьРассылок.МассоваяРассылка = ДокументМассоваяРассылка.Ссылка
		|ГДЕ
		|	ОчередьРассылок.ПопытокОсталось <= 0
		|	И (ВЫРАЗИТЬ(ОчередьРассылок.СообщениеОбОшибке КАК СТРОКА(1))) <> """"
		|	И ОчередьРассылок.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияОтправкиРассылки.ОшибкаОтправки)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Параметры.ОбработкаЗавершена = Истина;
		ТекстСообщения = НСтр(
		"ru='Процедура УстановитьНовоеСостояниеДляВнешнихСервисов завершила обработку. Запрос вернул пустую порцию документов.'",
		ОбщегоНазначения.КодОсновногоЯзыка());
		
		ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Документы.МассоваяРассылка, ,
		ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			ОбъектРассылка = Выборка.Ссылка.ПолучитьОбъект();
			Если ОбъектРассылка = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбъектРассылка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ОчередьРассылок.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.МассоваяРассылка.Установить(Выборка.Ссылка);
			НаборЗаписей.Прочитать();
			
			РассылкаОтправляется = Ложь;
			ЕстьОшибкиОтправки = Ложь;
			ЕстьОтправленные = Ложь;
			Для Каждого Запись Из НаборЗаписей Цикл
				
				Если Запись.ПопытокОсталось > 0 Тогда
					РассылкаОтправляется = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ПустаяСтрока(Запись.СообщениеОбОшибке) Тогда
					ЕстьОтправленные = Истина;
					Продолжить;
				КонецЕсли;
				
				ЕстьОшибкиОтправки = Истина;
				Запись.Состояние = Перечисления.СостоянияОтправкиРассылки.ОшибкаОтправки;
				
			КонецЦикла;
			
			Если Не ЕстьОшибкиОтправки Тогда
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если Не РассылкаОтправляется Тогда
				
				Если ЕстьОтправленные Тогда
					ОбъектРассылка.Состояние = Перечисления.СостоянияОтправкиРассылки.ОтправленоЧастично;
				Иначе
					ОбъектРассылка.Состояние = Перечисления.СостоянияОтправкиРассылки.ОшибкаОтправки;
				КонецЕсли;
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектРассылка);
				
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			ЗафиксироватьТранзакцию();
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстСообщения = НСтр("ru='Не удалось обработать объект ""%1"" по причине:
			|%2'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Представление, ТекстОшибки);
			
			ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.МассоваяРассылка,
			Выборка.Ссылка,
			ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано Тогда
		
		ТекстСообщения = НСтр(
		"ru='Процедура УстановитьНовыеСостоянияДляРассылок обработала очередную порцию объектов: %1'",
		ОбщегоНазначения.КодОсновногоЯзыка());
		ТекстСообщения = СтрШаблон(ТекстСообщения, ОбъектовОбработано);
		
		ЗаписьЖурналаРегистрации(
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Документы.МассоваяРассылка, ,
		ТекстСообщения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Процедуре УстановитьНовыеСостоянияДляРассылок не удалось обработать некоторые объекты (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Используется для получения данных сервиса в фоновом задании. См. МассоваяРассылка.Форма.РассылкаСервиса.
//
Функция ЗагрузитьДанныеСервисаДляДанныхФормы(ДанныеРассылки) Экспорт
	
	АдресныеКнигиСервиса = МассовыеРассылкиИнтеграция.ПолучитьАдресныеКнигиСервиса();
	ОтправителиСервиса = МассовыеРассылкиИнтеграция.ПолучитьОтправителейСервиса();
	
	Если ЗначениеЗаполнено(ДанныеРассылки.Идентификатор)
		Или ДанныеРассылки.Свойство("ИдентификаторПисьмаОснования") И ЗначениеЗаполнено(ДанныеРассылки.ИдентификаторПисьмаОснования) Тогда
		МассовыеРассылкиИнтеграция.ПолучитьСостояниеРассылки(ДанныеРассылки);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеРассылки.ИдентификаторШаблона) Тогда
		ДанныеШаблона = МассовыеРассылкиИнтеграция.ПолучитьШаблонСервиса(ДанныеРассылки.ИдентификаторШаблона);
	Иначе
		ДанныеШаблона = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеРассылки.ИдентификаторАдреснойКниги) И Не ЗначениеЗаполнено(ДанныеРассылки.Идентификатор) Тогда
		ДанныеАдреснойКниги = МассовыеРассылкиИнтеграция.ДанныеАдреснойКнигиСервиса(ДанныеРассылки.ИдентификаторАдреснойКниги);
	Иначе
		ДанныеАдреснойКниги = Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("АдресныеКнигиСервиса", АдресныеКнигиСервиса);
	Результат.Вставить("ОтправителиСервиса", ОтправителиСервиса);
	Результат.Вставить("ДанныеРассылки", ДанныеРассылки);
	Если ДанныеШаблона <> Неопределено Тогда
		Результат.Вставить("ДанныеШаблона", ДанныеШаблона);
	КонецЕсли;
	Если ДанныеАдреснойКниги <> Неопределено Тогда
		Результат.Вставить("ДанныеАдреснойКниги", ДанныеАдреснойКниги);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Используется для создания массовой рассылки сервиса в фоновом задании. См. МассоваяРассылка.Форма.РассылкаСервиса.
//
Функция СоздатьМассовуюРассылкуСервиса(ДанныеРассылки) Экспорт
	
	ОтправкаЗапросов.Подождать(8);
	МассовыеРассылкиИнтеграция.СоздатьРассылку(ДанныеРассылки);
	Возврат ДанныеРассылки;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("ДатаРассылки");
	Поля.Добавить("Номер");
	Поля.Добавить("ПометкаУдаления");
	Поля.Добавить("СервисМассовойРассылки");
	Поля.Добавить("Состояние");
	Поля.Добавить("СпособОтправки");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидРассылки = СтрШаблон(НСтр("ru='Рассылка %1'"), Данные.СпособОтправки);
	Если ЗначениеЗаполнено(Данные.СервисМассовойРассылки) Тогда
		ВидРассылки = ВидРассылки + " " + МассовыеРассылкиИнтеграция.ПредставлениеСервиса(Данные.СервисМассовойРассылки);
	КонецЕсли;
	
	Если Данные.ПометкаУдаления Тогда
		Состояние = НСтр("ru='(удалена)'");
	Иначе
		Состояние = СтрШаблон("(%1)", НРег(Строка(Данные.Состояние)));
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1: %2 %3 %4'"),
		ВидРассылки,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Данные.Номер, Истина, Истина),
		?(ЗначениеЗаполнено(Данные.ДатаРассылки), "от " + Формат(Данные.ДатаРассылки, "ДЛФ=D"), ""),
		Состояние);
	
	Представление = СокрЛП(Представление);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если НРег(ВидФормы) = НРег("ФормаДокумента") Или НРег(ВидФормы) = НРег("ФормаОбъекта") Тогда
		
		Ссылка = Неопределено;
		Параметры.Свойство("Ключ", Ссылка);
		
		ЗначениеКопирования = Неопределено;
		Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
		
		ЗначениеЗаполненияСервиса = Неопределено;
		ЗначениеЗаполнения(Параметры, "СервисМассовойРассылки", ЗначениеЗаполненияСервиса);
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			СервисРассылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СервисМассовойРассылки");
		ИначеЕсли ЗначениеЗаполнено(ЗначениеКопирования) Тогда
			СервисРассылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеКопирования, "СервисМассовойРассылки");
		ИначеЕсли ТипЗнч(ЗначениеЗаполненияСервиса) = Тип("ПеречислениеСсылка.СервисыМассовыхРассылок")
			И ЗначениеЗаполнено(ЗначениеЗаполненияСервиса) Тогда
			СервисРассылки = ЗначениеЗаполненияСервиса;
		Иначе
			СервисРассылки = Неопределено;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СервисРассылки) Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Документы.МассоваяРассылка.ПустаяСсылка().Метаданные().Формы.РассылкаСервиса.Имя;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанныхИзВнешнегоИсточника

// Поля загрузки данных из внешнего источника.
// 
// Параметры:
//  ТаблицаПолейЗагрузки - см. ЗагрузкаДанныхИзВнешнегоИсточника.СоздатьТаблицуПолейОписанияЗагрузки
//  НастройкиЗагрузкиДанных - см. ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере
//
Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	ОписаниеТиповСтрока200 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
	
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Контакт", 
		НСтр("ru = 'Получатель (контакт)'"), ОписаниеТиповСтрока200, ОписаниеТиповСтрока200);
		
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "КакСвязаться", 
		НСтр("ru = 'Электронный адрес'"), ОписаниеТиповСтрока200, ОписаниеТиповСтрока200, , , Истина);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Промокод", 
		НСтр("ru = 'Промокод'"), ОписаниеТиповСтрока200, ОписаниеТиповСтрока200);

КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Контакт, СтрокаТаблицыФормы.Контакт_ВходящиеДанные);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.КакСвязаться, СтрокаТаблицыФормы.КакСвязаться_ВходящиеДанные);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СкопироватьСтрокуВЗначениеСтроковогоТипа(СтрокаТаблицыФормы.Промокод, СтрокаТаблицыФормы.Промокод_ВходящиеДанные);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗначениеЗаполнено(СтрокаТаблицыФормы.КакСвязаться)
		И СтрНайти(СтрокаТаблицыФормы.КакСвязаться, "@") > 0;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗначениеЗаполнения(Параметры, Свойство, Значение)
	
	Если Не Параметры.Свойство("ЗначенияЗаполнения") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Параметры.ЗначенияЗаполнения.Свойство(Свойство) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Значение = Параметры.ЗначенияЗаполнения[Свойство];
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли