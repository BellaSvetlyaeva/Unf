#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организации.Очистить();
	Если Параметры.Свойство("Организации") И ЗначениеЗаполнено(Параметры.Организации) Тогда
		Если ТипЗнч(Параметры.Организации) = Тип("Массив") Тогда
			Организации.ЗагрузитьЗначения(Параметры.Организации);
		ИначеЕсли ТипЗнч(Параметры.Организации) = Тип("СписокЗначений") Тогда
			Организации.ЗагрузитьЗначения(Параметры.Организации.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСписокПроблем();
	
	СобытияФормИС.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ХранитьФайлыВТомахНаДиске" Тогда
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.НастройкиРаботыСФайлами");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЕстьСообщенияОжидающиеОтправки" Тогда
		
		ПараметрыОткрытияФормы = Неопределено;
		Если Организации.Количество() > 0 Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("Организация", Организации.ВыгрузитьЗначения());
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
			
		КонецЕсли;
		
		ОткрытьФорму("РегистрСведений.ОчередьСообщенийЗЕРНО.ФормаСписка", ПараметрыОткрытияФормы, ВладелецФормы);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДлительностьРегламентныхЗаданийОбмена"
	Или НавигационнаяСсылкаФорматированнойСтроки = "НастройкаРегламентногоОбменаЗагрузкиСДИЗЗерноСХТП"
	Или НавигационнаяСсылкаФорматированнойСтроки = "НастройкаРегламентногоОбменаЗагрузкиСДИЗЗерноЭлеватор"
	Или НавигационнаяСсылкаФорматированнойСтроки = "НастройкаРегламентногоОбменаЗагрузкиСДИЗППЗ"
	Или НавигационнаяСсылкаФорматированнойСтроки = "НастройкаРегламентногоОбменаЗагрузкиПартийЗерноСобственныеПартии"
	Или НавигационнаяСсылкаФорматированнойСтроки = "НастройкаРегламентногоОбменаЗагрузкиОстатковПартий"
	Или НавигационнаяСсылкаФорматированнойСтроки = "НастройкаРегламентногоОбменаДанными" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Организации", Организации);
		ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийЗЕРНО.Форма.ФормаНастроек", ПараметрыОткрытияФормы, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НастройкаСертификатаНаСервере" Тогда
		
		ОткрытьФорму("ОбщаяФорма.НастройкаСертификатовДляАвтоматическогоОбменаИС",, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НастройкаОтветственныхЗаПодписаниеСообщений" Тогда
		
		ОткрытьФорму("Справочник.ОтветственныеЗаПодписаниеСообщенийЗЕРНО.Форма.ФормаСписка",, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВыполнитьОбмен" Тогда
		
		ИнтеграцияЗЕРНОКлиент.ВыполнитьОбмен(
			ВладелецФормы,
			ИнтеграцияЗЕРНОКлиент.ОрганизацииДляОбмена(ВладелецФормы));
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПовторитьПроверкуПроблемыОбновленияКлассификаторов" Тогда
		
		ОбновитьСписокПроблем();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОбновлениеКлассификаторов" Тогда
		
		РаботаСКлассификаторамиКлиент.ОбновитьКлассификаторы();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НесопоставленныеКлючиАдресов" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("СтруктураОтбора", Новый Структура);
		ПараметрыОткрытияФормы.СтруктураОтбора.Вставить("Организация", Организации);
		ОткрытьФорму(
			"Справочник.КлючиАдресовЗЕРНО.Форма.СопоставлениеКлючейАдресов",
			ПараметрыОткрытияФормы, ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли СтрНачинаетсяС(НРег(НавигационнаяСсылкаФорматированнойСтроки), "http") Тогда
		
		ЗапуститьПриложение(НавигационнаяСсылкаФорматированнойСтроки);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неизвестная ссылка: %1'"),
			НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = РаботаСКлассификаторамиКлиент.ИмяСобытияОповещенияОЗагрузки() Тогда
		ОбновитьСписокПроблем();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТребуетсяЗагрузкаРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПросмотрОписанияОкружения" Тогда
		СтандартнаяОбработка = Ложь;
		ЛогированиеЗапросовИСКлиент.ОткрытьПросмотрИнформацииОбОкружении(ЭтотОбъект, "ЗЕРНО");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокПроблем();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПроблем()
	
	СтруктураОтбора = Новый Структура("Организация", Организации);
	
	РезультатыЗапроса                    = ИнтеграцияЗЕРНО.СостояниеОбмена(Организации);
	ПроблемыКлассификаторовВПанелиОбмена = ИнтеграцияЗЕРНО.ПроблемыКлассификаторовВПанелиОбмена();
	МассивНесопоставленныхКлючей         = ИнтеграцияЗЕРНО.НеСопоставленныеКлючиАдресов(СтруктураОтбора);
	
	ПроверитьОбновлениеКлассификаторов(ПроблемыКлассификаторовВПанелиОбмена);
	ПроверитьПроблемыТребуетсяЗагрузка(ПроблемыКлассификаторовВПанелиОбмена);
	
	ПроверитьХранениеФайловВТомахНаДиске();
	ПроверитьНастройкиРегламентныхЗаданийОбмена(РезультатыЗапроса);
	ПроверитьНастройкуСертификатаНаСервере(РезультатыЗапроса);
	ПроверитьНастройкуОтветственныхЗаПодписаниеСообщений(РезультатыЗапроса);
	ПроверитьСопоставлениеКлючейАдресов(МассивНесопоставленныхКлючей);
	ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьОбновлениеКлассификаторов(ПроблемыКлассификаторовВПанелиОбмена)
	
	ИдентификаторПроблемы = "ОбновлениеКлассификаторов";
	ИмяЭлемента           = "ОбновлениеКлассификаторов";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = ЗначениеЗаполнено(ПроблемыКлассификаторовВПанелиОбмена.ДоступноОбновлениеОписание);
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Если ПроблемыКлассификаторовВПанелиОбмена.ИнтерактивнаяЗагрузкаДоступна Тогда
			Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
				ПроблемыКлассификаторовВПанелиОбмена.ДоступноОбновлениеОписание,,,,
				ИдентификаторПроблемы);
		Иначе
			Элементы[ИмяЭлемента].Заголовок = ПроблемыКлассификаторовВПанелиОбмена.ДоступноОбновлениеОписание;
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ПроблемыКлассификаторовВПанелиОбмена.ДоступноОбновлениеТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПроблемыТребуетсяЗагрузка(ПроблемыКлассификаторовВПанелиОбмена)
	
	ИмяЭлемента = "ТребуетсяЗагрузка";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = ЗначениеЗаполнено(ПроблемыКлассификаторовВПанелиОбмена.ТребуетсяЗагрузкаОписание);
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = ПроблемыКлассификаторовВПанелиОбмена.ТребуетсяЗагрузкаОписание;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ПроблемыКлассификаторовВПанелиОбмена.ТребуетсяЗагрузкаТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьХранениеФайловВТомахНаДиске()
	
	ИдентификаторПроблемы = "ХранитьФайлыВТомахНаДиске";
	ИмяЭлемента           = "ХранитьФайлыВТомахНаДиске";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		И Не ОбщегоНазначения.РазделениеВключено()
		И Не ИнтеграцияИС.ХранитьФайлыВТомахНаДиске();
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить хранение файлов в томах на диске'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru='Файлы обмена могут занимать значительный объем данных в базе.
			|Для уменьшения объема базы данных, файлы необходимо хранить в томах на диске.'");
		
		Если Не ИнтеграцияИС.ПравоДоступаПанельАдминистрированиеБСП() Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru='У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьСообщенияОжидающиеОтправки";
	ИмяЭлемента           = "ЕстьСообщенияОжидающиеОтправки";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	ДоступностьКомандыВыполнитьОбмен = Истина;
	
	Если Организации.Количество() = 0 Тогда
		ОрганизациияДляПроверки = ИнтеграцияИС.ДоступныеОрганизации();
	Иначе
		ОрганизациияДляПроверки = Организации;
	КонецЕсли;
	
	Для Каждого ЭлементСпискаЗначений Из ОрганизациияДляПроверки Цикл
		Если ИнтеграцияЗЕРНОПовтИсп.ИспользоватьАвтоматическийОбменДанными(ЭлементСпискаЗначений.Значение) Тогда
			ДоступностьКомандыВыполнитьОбмен = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Выборка.Следующий();
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть сообщения ожидающие отправки (%1)'"),
				Выборка.КоличествоСообщений),,,,
			ИдентификаторПроблемы);
		
		СтрокаЗаголовка = Новый Массив;
		СтрокаЗаголовка.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не все подготовленные для отправки сообщения доставлены в ФГИС ""Зерно"".'")));
		
		Если ДоступностьКомандыВыполнитьОбмен Тогда
			СтрокаЗаголовка.Добавить(Символы.ПС);
			СтрокаЗаголовка.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'Рекомендуется'")));
			СтрокаЗаголовка.Добавить(" ");
			СтрокаЗаголовка.Добавить(
				Новый ФорматированнаяСтрока(
					Нстр("ru='выполнить обмен'"),,,, "ВыполнитьОбмен"));
			СтрокаЗаголовка.Добавить(".");
		КонецЕсли;
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = Новый ФорматированнаяСтрока(СтрокаЗаголовка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиРегламентныхЗаданийОбмена(РезультатЗапроса)
	
	НетПравНаИзменениеРегламентныхЗаданий = Не ПравоДоступа("Изменение", Метаданные.Справочники.НастройкиРегламентныхЗаданийЗЕРНО);
	
	ИдентификаторПроблемы = "ДлительностьРегламентныхЗаданийОбмена";
	ИмяЭлемента           = "ДлительностьРегламентныхЗаданийОбмена";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не РезультатЗапроса[ИдентификаторПроблемы].Пустой();
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		ВремяВыполнения = ОбменДаннымиЗЕРНО.ДопустимоеВремяВыполненияРегламентногоЗаданияПоНастройкеОбмена();
		ТекстЗаголовка =
			СтрШаблон(
				НСтр("ru = 'Длительность выполнения регламентного задания обмена превышает допустимое время выполнения %1 секунд'"), 
				ВремяВыполнения);
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			ТекстЗаголовка,,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Возможно, что настройки регламентных заданий выполнены некорректно.
		                            |Проверьте, что интервал получениях данных установлен в разумных пределах: до 7 дней.'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	ИдентификаторПроблемы = "НастройкаРегламентногоОбменаЗагрузкиСДИЗЗерноСХТП";
	ИмяЭлемента           = "НастройкаРегламентногоОбменаЗагрузкиСДИЗЗерноСХТП";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не (РезультатЗапроса[ИдентификаторПроблемы].Пустой()
		Или ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы));
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить регламентное задание для загрузки СДИЗ (зерно)'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Используется для автоматической загрузки СДИЗ, подлежащих гашению.'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	ИдентификаторПроблемы = "НастройкаРегламентногоОбменаЗагрузкиСДИЗППЗ";
	ИмяЭлемента           = "НастройкаРегламентногоОбменаЗагрузкиСДИЗППЗ";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не (РезультатЗапроса[ИдентификаторПроблемы].Пустой()
		Или ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы));
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить регламентное задание для загрузки СДИЗ (ППЗ)'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Используется для автоматической загрузки СДИЗ, подлежащих гашению.'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	ИдентификаторПроблемы = "НастройкаРегламентногоОбменаЗагрузкиСДИЗЗерноЭлеватор";
	ИмяЭлемента           = "НастройкаРегламентногоОбменаЗагрузкиСДИЗЗерноЭлеватор";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не (РезультатЗапроса[ИдентификаторПроблемы].Пустой()
		Или ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы));
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить регламентное задание для загрузки элеваторных СДИЗ'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Используется для автоматической загрузки элеваторных СДИЗ, подлежащих гашению.'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	ИдентификаторПроблемы = "НастройкаРегламентногоОбменаЗагрузкиПартийЗерноСобственныеПартии";
	ИмяЭлемента           = "НастройкаРегламентногоОбменаЗагрузкиПартийЗерноСобственныеПартии";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не (РезультатЗапроса[ИдентификаторПроблемы].Пустой()
		Или ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы));
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить регламентное задание для загрузки партий зерна'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'После передачи зерна на ответственное хранение на элеваторе
		                            |могут происходить объединения партий, подработка, списание .'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	ИдентификаторПроблемы = "НастройкаРегламентногоОбменаЗагрузкиОстатковПартий";
	ИмяЭлемента           = "НастройкаРегламентногоОбменаЗагрузкиОстатковПартий";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не (РезультатЗапроса[ИдентификаторПроблемы].Пустой()
		Или ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы));
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить регламентное задание для загрузки остатков партий зерна'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'В процессе хранения зерна элеватор может осуществлять работы по сушке, подработке и объединению партий.
		                            |Поэтому остатки зерна могут измениться и их рекомендуется периодически подгружать.'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	ИдентификаторПроблемы = "НастройкаРегламентногоОбменаДанными";
	ИмяЭлемента           = "НастройкаРегламентногоОбменаДанными";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не (РезультатЗапроса[ИдентификаторПроблемы].Пустой()
		Или ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы));
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить регламентное задание для отправки сообщений из общей очереди'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Если несколько пользователей используют для обмена с ФГИС Зерно
		                            |один и тот же сертификат ЭЦП и настроены регламентные задания,
		                            |то общее количество отправляемых сообщений в минуту по сертификату
		                            |может превысить допустимые пределы и сертификат будет будет временно заблокирован.'");
		
		Если НетПравНаИзменениеРегламентныхЗаданий Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкуСертификатаНаСервере(РезультатЗапроса)
	
	ИдентификаторПроблемы = "НастройкаСертификатаНаСервере";
	ИмяЭлемента           = "НастройкаСертификатаНаСервере";
	
	// Если задание включено, необходимо настроить сертификаты
	Элементы["Группа" + ИмяЭлемента].Видимость = ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы, Ложь);
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить сертификаты на сервере для автоматического подписания сообщений'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Для выполнения регламентных заданий по загрузке СДИЗ и партий
		                            |требуется подписание отправляемых сообщений.
		                            |Сообщения могут быть подписаны:
		                            |- Автоматически, если настроены сертификаты ЭЦП на сервере
		                            |- Ответственным за подписание сообщений.'");
		
		Если Не ПравоДоступа("Изменение", Метаданные.Константы.НастройкиОбменаГосИС) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкуОтветственныхЗаПодписаниеСообщений(РезультатЗапроса)
	
	ИдентификаторПроблемы = "НастройкаОтветственныхЗаПодписаниеСообщений";
	ИмяЭлемента           = "НастройкаОтветственныхЗаПодписаниеСообщений";
	
	// Если сертификат не настроен и задание включено, необходимо настроить ответственных
	Элементы["Группа" + ИмяЭлемента].Видимость = ИнтеграцияИС.РегЗаданияНастроены(РезультатЗапроса, ИдентификаторПроблемы, Ложь);
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить ответственных за подписание сообщений'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Для выполнения регламентных заданий по загрузке СДИЗ и партий
		                            |требуется подписание отправляемых сообщений.
		                            |Сообщения могут быть подписаны:
		                            |- Автоматически, если настроены сертификаты ЭЦП на сервере
		                            |- Ответственным за подписание сообщений.'");
		
		Если Не ПравоДоступа("Изменение", Метаданные.Справочники.ОтветственныеЗаПодписаниеСообщенийЗЕРНО) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСопоставлениеКлючейАдресов(МассивНесопоставленныхКлючей)
	
	ИмяЭлемента           = "НесопоставленныеКлючиАдресов";
	ИдентификаторПроблемы = "НесопоставленныеКлючиАдресов";
	
	КоличествоНесопоставленныхАдресов = МассивНесопоставленныхКлючей.Количество();
	Элементы["Группа" + ИмяЭлемента].Видимость = КоличествоНесопоставленныхАдресов > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		ТекстПодсказки = НСтр("ru = 'На остатках имеются партии с несопоставленным местоположением.'");
		ШаблонСтрокиЗаголовка = НСтр("ru = 'Рекомендуется сопоставить местоположения партий (%1)'");
		СтрокаЗаголовка       = СтроковыеФункции.ФорматированнаяСтрока(ШаблонСтрокиЗаголовка, 
			КоличествоНесопоставленныхАдресов);
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(СтрокаЗаголовка,,,, ИдентификаторПроблемы);
		
		Если Не ПравоДоступа("Изменение", Метаданные.Справочники.КлючиАдресовЗЕРНО) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти