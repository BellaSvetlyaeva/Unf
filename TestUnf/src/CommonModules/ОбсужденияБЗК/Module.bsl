#Область ПрограммныйИнтерфейс

Функция ОписаниеСообщения(Знач Текст, КлючСообщения) Экспорт
	
	Описание = Обсуждения.ОписаниеСообщения(Текст);
	Описание.Вставить("КлючСообщения", КлючСообщения);
	Возврат Описание;
	
КонецФункции

Процедура ОтправитьУведомление(Ассистент, Сообщение, Получатели, КонтекстСообщения = Неопределено) Экспорт
	
	Если Не Обсуждения.СистемаВзаимодействийПодключена() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ОтправитьСообщение(Ассистент,
			Получатели,
			Сообщение,
			КонтекстСообщения);
	Исключение
		
		КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
		
		ЗаписьЖурналаРегистрации(
			КадровыйЭДО.ИмяСобытияЖурналаРегистрации(
				НСтр("ru = 'Обсуждения БЗК.Отправка уведомлений'", КодОсновногоЯзыка)),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьУведомление(Ассистент, Сообщение, Получатели, КонтекстСообщения = Неопределено) Экспорт
	
	УдалитьСообщения(Ассистент, Сообщение.КлючСообщения, Получатели);
	ОтправитьУведомление(Ассистент, Сообщение, Получатели, КонтекстСообщения);
	
КонецПроцедуры

Процедура УдалитьСообщения(Ассистент, КлючСообщения, Получатели, КонтекстСообщения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	НайденныеСообщения = НайтиСообщения(Ассистент, КлючСообщения, Получатели, КонтекстСообщения);
	Для Каждого НайденноеСообщениеПользователя Из НайденныеСообщения Цикл
		Для Каждого Сообщение Из НайденноеСообщениеПользователя.Значение Цикл
			СистемаВзаимодействия.УдалитьСообщение(Сообщение.Идентификатор);
		КонецЦикла;
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция Ассистент(Знач ИмяДляВхода, Знач Картинка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательАссистент = Пользователи.НайтиПоИмени(ИмяДляВхода);
	Если Не ЗначениеЗаполнено(ПользовательАссистент) Тогда
		
		Если ПользовательАссистент = Неопределено Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
			ПользовательИБ.Имя = ИмяДляВхода;
			ПользовательИБ.Пароль = Строка(Новый УникальныйИдентификатор);
			ПользовательИБ.ЗапрещеноИзменятьПароль = Истина;
			ПользовательИБ.ПоказыватьВСпискеВыбора = Ложь;
			ПользовательИБ.Язык = Метаданные.Языки.Русский;
			ПользовательИБ.Записать();
			
		Иначе
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяДляВхода);
		КонецЕсли;
		
		// Обновление пользователя - элемента справочника Пользователи.
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя", ПользовательИБ.Имя);
		ОписаниеПользователяИБ.Вставить("ПолноеИмя", ПользовательИБ.ПолноеИмя);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", ПользовательИБ.ПоказыватьВСпискеВыбора);
		ОписаниеПользователяИБ.Вставить("УникальныйИдентификатор", ПользовательИБ.УникальныйИдентификатор);
		
		Отбор = Новый Структура("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
		Выборка = Справочники.Пользователи.Выбрать(,, Отбор);
		ЭтоНовый = Не Выборка.Следующий();
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.Пользователи.ПолноеИмя());
			
			Если Не ЭтоНовый Тогда 
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			КонецЕсли;
			
			Блокировка.Заблокировать();
			
			Если ЭтоНовый Тогда 
				ПользовательАссистент = Справочники.Пользователи.СоздатьЭлемент();
			Иначе
				ПользовательАссистент = Выборка.Ссылка.ПолучитьОбъект();
			КонецЕсли;
			
			ПользовательАссистент.Наименование = ПользовательИБ.Имя;
			ПользовательАссистент.Служебный = Истина;
			ПользовательАссистент.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
			ПользовательАссистент.Записать();
			
			ПользовательСВ = Обсуждения.ПользовательСистемыВзаимодействия(ПользовательАссистент);
			ПользовательСВ.Картинка = Картинка;
			ПользовательСВ.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПользовательАссистент = Неопределено;
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Обсуждения БЗК.Создание служебного пользователя'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Пользователи,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
	КонецЕсли;
	
	Если ПользовательАссистент = Неопределено Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Не удалось создать пользователя-ассистента %1.
				|%2'"),
			ИмяДляВхода,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецЕсли;
	
	Возврат ПользовательАссистент;
	
КонецФункции

Процедура ЗапланироватьУведомления(Исполнители) Экспорт
	
	Если Не Обсуждения.СистемаВзаимодействийПодключена() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Исполнители", Исполнители);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Исполнитель
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиКОбновлениюУведомлений КАК ПользователиКОбновлениюУведомлений
		|		ПО Пользователи.Ссылка = ПользователиКОбновлениюУведомлений.Исполнитель
		|ГДЕ
		|	ПользователиКОбновлениюУведомлений.Исполнитель ЕСТЬ NULL
		|	И Пользователи.Ссылка В(&Исполнители)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПользователиКОбновлениюУведомлений");
			ЭлементБлокировки.УстановитьЗначение("Исполнитель", Выборка.Исполнитель);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ПользователиКОбновлениюУведомлений.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Исполнитель.Установить(Выборка.Исполнитель);
			Запись = НаборЗаписей.Добавить();
			Запись.Исполнитель = Выборка.Исполнитель;
			НаборЗаписей.Записать();
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбновитьУведомленияОНеобходимостиПодписанияФайловДокументовКЭДО() Экспорт
	
	Если Не Обсуждения.СистемаВзаимодействийПодключена() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПользователиКОбновлениюУведомлений.Исполнитель КАК Исполнитель
		|ИЗ
		|	РегистрСведений.ПользователиКОбновлениюУведомлений КАК ПользователиКОбновлениюУведомлений
		|
		|ДЛЯ ИЗМЕНЕНИЯ";
	
	Исполнители = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Исполнитель");
	Если ЗначениеЗаполнено(Исполнители) Тогда
		
		// ЗарплатаКадрыПодсистемы.КадровыйЭДО
		РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.ОбновитьУведомленияОНеобходимостиПодписанияФайловДокументовКЭДО(Исполнители);
		// Конец ЗарплатаКадрыПодсистемы.КадровыйЭДО
		
		Для Каждого Исполнитель Из Исполнители Цикл
			НаборЗаписей = РегистрыСведений.ПользователиКОбновлениюУведомлений.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Исполнитель.Установить(Исполнитель);
			НаборЗаписей.Записать();
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиСообщения(Знач Ассистент, Знач КлючСообщения, Знач Получатели, Знач КонтекстСообщения = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденныеСообщения = Новый Соответствие;
	Если Обсуждения.ОбсужденияДоступны() Тогда
		
		НайденныеОбсуждения = НайтиОбсуждения(Ассистент, Получатели, КонтекстСообщения);
		Для Каждого ОбсуждениеПользователя Из НайденныеОбсуждения Цикл
			Для Каждого Обсуждение Из ОбсуждениеПользователя.Значение Цикл
				ОтборСообщений = Новый ОтборСообщенийСистемыВзаимодействия;
				ОтборСообщений.Обсуждение = Обсуждение.Идентификатор;
				Сообщения = СистемаВзаимодействия.ПолучитьСообщения(ОтборСообщений);
				Для Каждого Сообщение Из Сообщения Цикл
					Если ТипЗнч(Сообщение.Данные) = Тип("Структура")
						И Сообщение.Данные.Свойство("КлючСообщения")
						И Сообщение.Данные.КлючСообщения = КлючСообщения Тогда
						
						НайденныеСообщенияПользователя = НайденныеСообщения.Получить(ОбсуждениеПользователя.Ключ);
						Если НайденныеСообщенияПользователя = Неопределено Тогда
							НайденныеСообщенияПользователя = Новый Массив;
							НайденныеСообщения.Вставить(ОбсуждениеПользователя.Ключ, НайденныеСообщенияПользователя);
						КонецЕсли;
						НайденныеСообщенияПользователя.Добавить(Сообщение);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат НайденныеСообщения;
	
КонецФункции

Функция НайтиОбсуждения(Знач Ассистент, Знач Получатели, Знач КонтекстСообщения = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденныеОбсуждения = Новый Соответствие;
	Если Обсуждения.ОбсужденияДоступны() Тогда
		
		Контекст = КонтекстОбсуждения(КонтекстСообщения);
		КлючиОбсуждений = КлючиОбсужденийПользователей(Ассистент, Получатели);
		Для Каждого Получатель Из Получатели Цикл
			ОтборОбсуждений = Новый ОтборОбсужденийСистемыВзаимодействия;
			ОтборОбсуждений.Ключ = КлючиОбсуждений.Получить(Получатель);
			ОтборОбсуждений.КонтекстОбсуждения = Контекст;
			ОтборОбсуждений.Отображаемое = Истина;
			ОтборОбсуждений.КонтекстноеОбсуждение = (Контекст <> Неопределено);
			ОтборОбсуждений.ТекущийПользовательЯвляетсяУчастником = Ложь;
			НайденныеОбсужденияПользователя = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений);
			Если ЗначениеЗаполнено(НайденныеОбсужденияПользователя) Тогда
				НайденныеОбсуждения.Вставить(Получатель, НайденныеОбсужденияПользователя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат НайденныеОбсуждения;
	
КонецФункции

Функция КлючиОбсужденийПользователей(Знач Ассистент, Знач Получатели)
	
	КлючиОбсуждений = Новый Соответствие;
	
	ПолучателиСообщений = ОбщегоНазначения.СкопироватьРекурсивно(Получатели);
	ПолучателиСообщений.Добавить(Ассистент);
	
	ИдентификаторыПользователей = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
		ПолучателиСообщений, "ИдентификаторПользователяИБ");
	
	Для Каждого Получатель Из Получатели Цикл
		КлючиОбсуждений.Вставить(Получатель, КлючОбсужденияПользователя(Ассистент, Получатель, ИдентификаторыПользователей));
	КонецЦикла;
	
	Возврат КлючиОбсуждений;
	
КонецФункции

Функция КлючОбсужденияПользователя(Знач Ассистент, Знач Получатель, Знач ИдентификаторыПользователей)
	
	Возврат СтрШаблон("%1 - %2",
		Строка(ИдентификаторыПользователей.Получить(Ассистент)),
		Строка(ИдентификаторыПользователей.Получить(Получатель)));
	
КонецФункции

Функция КонтекстОбсуждения(Знач КонтекстСообщения)
	
	Контекст = Неопределено;
	Если КонтекстСообщения <> Неопределено Тогда
		Контекст = Новый КонтекстОбсужденияСистемыВзаимодействия(
			ПолучитьНавигационнуюСсылку(КонтекстСообщения))
	КонецЕсли;
	
	Возврат Контекст;
	
КонецФункции

Функция ИдентификаторыОбсужденийПользователей(Знач Ассистент, Знач Получатели)
	
	ИдентификаторыОбсуждений = Новый Соответствие;
	НайденныеОбсуждения = НайтиОбсуждения(Ассистент, Получатели);
	Для Каждого ОбсуждениеПользователя Из НайденныеОбсуждения Цикл
		Если ЗначениеЗаполнено(ОбсуждениеПользователя.Значение) Тогда
			ИдентификаторыОбсуждений.Вставить(
				ОбсуждениеПользователя.Ключ, ОбсуждениеПользователя.Значение[0].Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	КлючиОбсуждений = КлючиОбсужденийПользователей(Ассистент, Получатели);
	Для Каждого Получатель Из Получатели Цикл
		Если ИдентификаторыОбсуждений.Получить(Получатель) = Неопределено Тогда
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.Отображаемое = Истина;
			Обсуждение.Ключ = КлючиОбсуждений.Получить(Получатель);
			Обсуждение.Групповое = Ложь;
			Обсуждение.Участники.Добавить(
				Обсуждения.ПользовательСистемыВзаимодействия(Ассистент).Идентификатор);
			Обсуждение.Участники.Добавить(
				Обсуждения.ПользовательСистемыВзаимодействия(Получатель).Идентификатор);
			Обсуждение.Записать();
			ИдентификаторыОбсуждений.Вставить(Получатель, Обсуждение.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИдентификаторыОбсуждений;
	
КонецФункции

Процедура ОтправитьСообщение(Знач Ассистент, Знач Получатели, Сообщение, КонтекстСообщения = Неопределено) Экспорт
	
	АссистентСВ = Обсуждения.ПользовательСистемыВзаимодействия(Ассистент);
	Если АссистентСВ = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не указан автор сообщения'");
	КонецЕсли;
	
	Если Получатели.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не указаны получатели сообщения'");
	КонецЕсли;
	
	ПолучателиСВ = Обсуждения.ПользователиСистемыВзаимодействия(Получатели);
	Контекст = КонтекстОбсуждения(КонтекстСообщения);
	
	Если ТипЗнч(Контекст) = Тип("ИдентификаторОбсужденияСистемыВзаимодействия") Тогда
		ИдентификаторыОбсуждения = Контекст;
	ИначеЕсли Контекст = Неопределено Тогда
		ИдентификаторыОбсуждения = ИдентификаторыОбсужденийПользователей(Ассистент, Получатели);
	Иначе
		
		Контекст = Новый КонтекстОбсужденияСистемыВзаимодействия(Контекст);
		Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
		Отбор.КонтекстОбсуждения = Контекст;
		Отбор.ТекущийПользовательЯвляетсяУчастником = Ложь;
		Отбор.Отображаемое = Истина;
		Отбор.КонтекстноеОбсуждение = Истина;
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
		Если Обсуждение.Количество() = 0 Тогда
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.КонтекстОбсуждения = Контекст;
			Обсуждение.Отображаемое = Истина;
			Обсуждение.Заголовок = Строка(Контекст);
			Обсуждение.Записать();
		Иначе 
			Обсуждение = Обсуждение[0];
		КонецЕсли;
		ИдентификаторыОбсуждения = Обсуждение.Идентификатор;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ИдентификаторыОбсуждения) = Тип("Соответствие") Тогда
		
		Для Каждого ИдентификаторОбсужденияПользователя Из ИдентификаторыОбсуждения Цикл
			ДобавитьСообщение(АссистентСВ, ИдентификаторОбсужденияПользователя.Значение,
				ПолучателиСВ.Получить(ИдентификаторОбсужденияПользователя.Ключ), Сообщение);
		КонецЦикла;
		
	Иначе
		ДобавитьСообщение(АссистентСВ, ИдентификаторыОбсуждения, ПолучателиСВ, Сообщение);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ДобавитьСообщение(Ассистент, ИдентификаторОбсуждения, Получатели, Сообщение)
	
	СообщениеСВ = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
	СообщениеСВ.Автор = Ассистент.Идентификатор;
	СообщениеСВ.Текст = Сообщение.Текст;
	ДанныеСообщения = Новый Структура("КлючСообщения", Сообщение.КлючСообщения);
	Если ЗначениеЗаполнено(Сообщение.Данные) Тогда
		ДанныеСообщения.Вставить("Данные", Сообщение.Данные);
	КонецЕсли; 
	СообщениеСВ.Данные = ДанныеСообщения;
	Для каждого Действие Из Сообщение.Действия Цикл
		СообщениеСВ.Действия.Добавить(Действие.Значение, Действие.Представление);
	КонецЦикла;
	
	Если ТипЗнч(Получатели) = Тип("Соответствие") Тогда
		Для Каждого ПолучательСВ Из Получатели Цикл
			СообщениеСВ.Получатели.Добавить(ПолучательСВ.Идентификатор);
		КонецЦикла;
	Иначе
		СообщениеСВ.Получатели.Добавить(Получатели.Идентификатор);
	КонецЕсли;
	
	Для каждого Вложение Из Сообщение.Вложения Цикл
		СообщениеСВ.Вложения.Добавить(Вложение.Поток,
			Вложение.Имя,
			Вложение.ТипСодержимого,
			Вложение.Отображаемое);
	КонецЦикла;
	
	СообщениеСВ.Записать();
	
КонецПроцедуры

#КонецОбласти
