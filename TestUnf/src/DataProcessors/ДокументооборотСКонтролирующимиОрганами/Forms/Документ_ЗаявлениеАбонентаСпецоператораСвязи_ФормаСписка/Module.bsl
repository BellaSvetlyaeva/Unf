&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
		Если Параметры.Свойство("ТекущаяСтрока") Тогда
			Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	
	ДействияВРежимеОднойОрганизации(Параметры);
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.УстановитьВидимостьМенюПФР(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДействияВРежимеОднойОрганизации(Параметры)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.Список.ПодчиненныеЭлементы.КраткоеНаименование.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Организация", 
			Параметры.Организация,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ,
			Строка(Новый УникальныйИдентификатор));
		
	КонецЕсли;
		
	ИспользуетсяОднаОрганизация = РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация();
	
	Если ИспользуетсяОднаОрганизация Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		ОрганизацияПоУмолчанию = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Ссылка = ТекущиеДанные.Ссылка;
		Если Поле.Имя = "Статус" Тогда
			
			СтандартнаяОбработка = Ложь;
			
			// Проверяем, было ли отправлено заявление
			СостояниеСдачиОтчетностиВСписке = ТекущиеДанные.Статус;
			Если СостояниеСдачиОтчетностиВСписке = ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Подготовлено") Тогда
				ТекстПредупреждения = НСтр("ru = 'Просмотр подробной информации о состоянии заявления 
												 |возможен только после его отправки'");
				ПоказатьПредупреждение(,ТекстПредупреждения);
				Возврат;
			КонецЕсли;
			
			КонтекстЭДОКлиент.ПоказатьФормуСтатусовОтправки(Ссылка);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокЗаявленийВПФР(Команда)
	
	Организация = ОрганизацияВОтборе();
	КонтекстЭДОКлиент.ОткрытьСписокЗаявленийВПФР(Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявлениеВПФРИзМеню(Команда)
	
	Организация = ОрганизацияВОтборе();
	КонтекстЭДОКлиент.СоздатьЗаявлениеВПФРИзМеню(Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаМастерНастройки(Команда)
	
	// Открытие первичного мастера
	Первичное = ПредопределенноеЗначение("Перечисление.ТипыЗаявленияАбонентаСпецоператораСвязи.Первичное");
		
	ДополнительныеПараметры = ДокументооборотСКОКлиентСервер.ПараметрыОткрытияМастера();
	ДополнительныеПараметры.Вставить("Организация", 			 ОрганизацияВОтборе());
	ДополнительныеПараметры.Вставить("ВидЗаявления", 			 Первичное);
	ДополнительныеПараметры.Вставить("ВладелецОткрываемойФормы", ЭтаФорма);
	
	КонтекстЭДОКлиент.ОткрытьФормуЗаявления(ДополнительныеПараметры);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьСтатусыЗаявлений(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандаОбновитьСтатусыЗаявлений_Завершение", 
		ЭтотОбъект);
	
	Организация = ОрганизацияИзОтбора();
	КонтекстЭДОКлиент.ОбновитьСтатусыЗаявленийАбонентов_ИзФормыСписка(, ЭтаФорма.УникальныйИдентификатор, ОписаниеОповещения,Организация);
		
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьСтатусыЗаявлений_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры	

&НаКлиенте
Процедура ДействияФормыИзменитьСтатус(Команда)
	
	Данные = ЭтаФорма.Элементы.Список.ТекущиеДанные;
	Если Данные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите заявление для изменения статуса !");
	ИначеЕсли Данные.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Подготовлено") 
		И Данные.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено") Тогда
		ПоказатьПредупреждение(, "Ручное изменение статуса возможно только для заявлений со статусом <Подготовлено> или <Отправлено> !")
	Иначе
		ДополнительныеПараметры = Новый Структура("Данные", Данные);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДействияФормыИзменитьСтатусЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = "Отменить заявление? 
			|
			|Отмена необратима, получение ответа на заявление и создание учетной записи станет невозможным.";
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыПечатьЗаявка(Команда)
	
	
	Для каждого Документ Из ЭтаФорма.Элементы.Список.ВыделенныеСтроки Цикл	
		
		КонтекстЭДОКлиент.НапечататьЗаявлениеПо1СОтчетности(Документ);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыПечатьСоглашение(Команда)
	
	Для каждого Документ Из ЭтаФорма.Элементы.Список.ВыделенныеСтроки Цикл
		
		КонтекстЭДОКлиент.ПечатьСоглашенияобОказанииУслуг(Документ);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыПечатьЛицензия(Команда)
	
	Для каждого Документ Из ЭтаФорма.Элементы.Список.ВыделенныеСтроки Цикл
		
		КонтекстЭДОКлиент.ПечатьЛицензииОбИспользованииПО(Документ);
		
	КонецЦикла;

	
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыПечатьСертификат(Команда)
	
	Для каждого Документ Из ЭтаФорма.Элементы.Список.ВыделенныеСтроки Цикл
		
		КонтекстЭДОКлиент.ПечатьСертификатаПользователя(Документ);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеФормыПечатьПакет(Команда)
	
	МассивДокументов =  ЭтаФорма.Элементы.Список.ВыделенныеСтроки;
	ПечатьПакетаДокумента(МассивДокументов, 0);

КонецПроцедуры

&НаКлиенте
Процедура КомандаМастерФормированияЗаявкиНаИзменениеПараметровПодключения(Команда)
	
	Организация = ОрганизацияВОтборе();
	
	Изменение = ПредопределенноеЗначение("Перечисление.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение");
	
	ДополнительныеПараметры = ДокументооборотСКОКлиентСервер.ПараметрыОткрытияМастера();
	ДополнительныеПараметры.Вставить("Организация",  Организация);
	ДополнительныеПараметры.Вставить("ВидЗаявления", Изменение);

	КонтекстЭДОКлиент.ОткрытьФормуЗаявления(ДополнительныеПараметры);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОрганизацияВОтборе()
	
	Организация = Неопределено;
	
	Если ИспользуетсяОднаОрганизация Тогда
		Организация = ОрганизацияПоУмолчанию;
	Иначе
		
		Компоновщик = Список.КомпоновщикНастроек;
		
		ОрганизацияВПрограммномОтборе      = ОрганизацияИзЭлементовОтбора(Компоновщик.Настройки.Отбор.Элементы);
		ОрганизацияВПользовательскомОтборе = ОрганизацияИзЭлементовОтбора(Компоновщик.ПользовательскиеНастройки.Элементы);
		
		Если ЗначениеЗаполнено(ОрганизацияВПользовательскомОтборе) Тогда
			Организация = ОрганизацияВПользовательскомОтборе;
		Иначе
			Организация = ОрганизацияВПрограммномОтборе;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыИзменитьСтатусЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Данные = ДополнительныеПараметры.Данные;
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		РеквизитыДокументаДляЗаписи = Новый Структура;
		РеквизитыДокументаДляЗаписи.Вставить("Статус",				ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено"));
		РеквизитыДокументаДляЗаписи.Вставить("СтатусКомментарий",	"Отменено пользователем.");

		ОбработкаЗаявленийАбонентаВызовСервера.ОбновитьРеквизитыЗаявления(Данные.Ссылка, РеквизитыДокументаДляЗаписи);
		
		ОповеститьОбИзменении(Данные.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПакетаДокумента(МассивДокументов, НомерОбъекта)

	Если НомерОбъекта + 1 <= МассивДокументов.Количество() Тогда
		Документ = МассивДокументов[НомерОбъекта];
		ДополнительныеПараметры = Новый Структура("МассивДокументов, НомерОбъекта", МассивДокументов, НомерОбъекта);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьПакетаДокументаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		КонтекстЭДОКлиент.ПечатьПакетаДокументов(Документ, ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПечатьПакетаДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НомерОбъекта = ДополнительныеПараметры.НомерОбъекта;
	МассивДокументов = ДополнительныеПараметры.МассивДокументов;
	
	ПечатьПакетаДокумента(МассивДокументов, НомерОбъекта + 1);
	
КонецПроцедуры

&НаКлиенте
Функция ОрганизацияИзОтбора()
	
	ОрганизацияЗаявлений = Неопределено;
	Если Список.Отбор.Элементы.Количество() > 0 Тогда
		// Обновляем только по списку организаций
		Отборы = Список.Отбор.Элементы;
		Для каждого Отбор Из Отборы Цикл
			
			ЭтоОтборПоОрганизации = 
				ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") 
				И Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
			
			Если ЭтоОтборПоОрганизации Тогда
				ОрганизацияЗаявлений = Отбор.ПравоеЗначение;
			КонецЕсли;
			
		КонецЦикла; 
	КонецЕсли;
		
	Возврат ОрганизацияЗаявлений;
		
КонецФункции

&НаКлиенте
Функция ОрганизацияИзЭлементовОтбора(Отбор)
	
	Организация = Неопределено;
	
	Для каждого ЭлементОтбора из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		ЭтоОрганизация = 
			ЭлементОтбора.Использование 
			И ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.Организации");
		
		Если ЭтоОрганизация Тогда
			Организация = ЭлементОтбора.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Организация;

КонецФункции

&НаСервере
Процедура СброситьСтатусНаСервере(Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДокументОбъект.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено;
	ДокументОбъект.НастройкаЗавершена = Ложь;
	ДокументОбъект.НастройкаЭДОЗавершена = Ложь;
	ДокументОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьСтатус(Команда)
	Ссылка = Элементы.Список.ТекущиеДанные.Ссылка;
	СброситьСтатусНаСервере(Ссылка);
КонецПроцедуры

#КонецОбласти

