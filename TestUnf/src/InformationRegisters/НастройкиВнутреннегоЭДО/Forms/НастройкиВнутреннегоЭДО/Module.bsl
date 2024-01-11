
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);
	
	ЭтоНовый = Ложь;
	Если НастройкиВнутреннегоЭДОСлужебный.НастройкаВнутреннегоЭДО(Организация) = Неопределено Тогда
		ЭтоНовый = Истина;
	КонецЕсли;
	
	Элементы.Организация.ТолькоПросмотр = ЗначениеЗаполнено(Организация);
	ЕстьПравоНастройкиОбмена = НастройкиЭДО.ЕстьПравоНастройкиОбмена();
	ТолькоПросмотр = Не ЕстьПравоНастройкиОбмена;
	Элементы.НастройкиПечатнаяФорма.Доступность = ЕстьПравоНастройкиОбмена;
	ЗаполнитьНастройки();
	УстановитьВидЭлектроннойПодписи(ЭтаФорма);
	УстановитьУсловноеОформление();
	УстановитьВидимостьМенюПечатныхФорм(ЭтаФорма);
	УстановитьВидимостьКолонкиВидПодписи(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Настройки внутреннего электронного документооборота не сохранены.
										|Завершить работу с программой?'")
		Иначе
			Описание = Новый ОписаниеОповещения("ПередЗакрытиемОкнаФормы", ЭтотОбъект);
			ПоказатьВопрос(Описание, НСтр("ru = 'Настройки внутреннего электронного документооборота изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоНовый И ЕстьНастройкаПоОрганизации() Тогда
		ТекстСообщения = НСтр("ru = 'Настройка по данной организации уже существует'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый И Настройки.НайтиСтроки(Новый Структура("Формировать", 2)).Количество() = Настройки.Количество() Тогда
		ТекстСообщения = НСтр("ru = 'Не отмечено ни одной настройки'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Счетчик = 0;
	Для каждого Настройка Из Настройки Цикл
		Если Настройка.Формировать = 1 Тогда
			Если Настройка.РасширенныйРежимНастройки Тогда
				Для каждого ПечатнаяФорма Из Настройка.ПечатныеФормы Цикл
					Если ПечатнаяФорма.Формировать = 1 И Не ЗначениеЗаполнено(ПечатнаяФорма.МаршрутПодписания) Тогда
						ТекстСообщения = НСтр("ru = 'Поле ""Маршрут подписания"" в настройках печатных форм не заполнено'");
						Поле = СтрШаблон("Настройки[%1].ПредставлениеПечатныхФорм", Счетчик);
						ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
					КонецЕсли;
				КонецЦикла;
			Иначе 
				Если Не ЗначениеЗаполнено(Настройка.МаршрутПодписания) Тогда
					ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Поле", "Заполнение", НСтр("ru = 'Маршрут подписания'"));
					Поле = СтрШаблон("Настройки[%1].МаршрутПодписания", Счетчик);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
				КонецЕсли;
			КонецЕсли;
			Если Настройка.ПечатныеФормы.НайтиСтроки(Новый Структура("Формировать", 1)).Количество() = 0 Тогда
				ТекстСообщения = НСтр("ru = 'Не выбрано ни одной печатной формы'");
				Поле = СтрШаблон("Настройки[%1].ПредставлениеПечатныхФорм", Счетчик);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
			КонецЕсли;
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЭлектроннойПодписиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидыПодписей = Новый СписокЗначений();
	ВидыПодписей.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая"), НСтр("ru = 'Простая'"));
	ВидыПодписей.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная"), НСтр("ru = 'Усиленная квалифицированная'"));
	
	ПодписьПоВидамДокументов = НастройкиВнутреннегоЭДОКлиентСервер.ВидЭлектроннойПодписиПоВидамДокументов();
	ВидыПодписей.Добавить(ПодписьПоВидамДокументов, ПодписьПоВидамДокументов);
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораВариантаПодписиИзСписка", ЭтотОбъект);
	
	ПоказатьВыборИзСписка(Оповещение, ВидыПодписей, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура НастройкиМаршрутПодписанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбраннаяСтрока = Элементы.Настройки.ТекущаяСтрока;
	ДанныеСтроки = Элементы.Настройки.ТекущиеДанные;
	Если МожноВыбиратьМаршрут(ДанныеСтроки.ВидПодписи, ВыбраннаяСтрока) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("МаршрутПодписанияЗавершениеВыбора", ЭтотОбъект);
		Отбор = МаршрутыПодписанияБЭДКлиент.НовыйОтборМаршрутовПодписания();
		Отбор.Организация = Организация;
		Если ДанныеСтроки.ВидПодписи <> ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая") Тогда
			Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.ОднойДоступнойПодписью"));
		КонецЕсли;
		Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.ПоПравилам"));
		Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.УказыватьПриСоздании"));
		Отбор.ВидПодписи = ДанныеСтроки.ВидПодписи;
		
		МаршрутыПодписанияБЭДКлиент.ВыбратьМаршрутПодписания(Отбор, ДанныеСтроки.МаршрутПодписания, 
			УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура МаршрутПодписанияЗавершениеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда 
		Элементы.Настройки.ТекущиеДанные.МаршрутПодписания = Результат;
		НастройкиМаршрутПодписанияПриИзменении(Элементы.НастройкиМаршрутПодписания);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиМаршрутПодписанияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	Для каждого ПечатнаяФорма Из ТекущиеДанные.ПечатныеФормы Цикл
		ПечатнаяФорма.МаршрутПодписания = Элементы.Настройки.ТекущиеДанные.МаршрутПодписания;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройки

&НаКлиенте
Процедура НастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = Элементы.Настройки.ТекущиеДанные;
	Если Поле = Элементы.НастройкиПечатнаяФорма И Элемент.ТекущиеДанные.Формировать = 1
		И МожноВыбиратьМаршрут(ДанныеСтроки.ВидПодписи, ВыбраннаяСтрока) Тогда
		СтандартнаяОбработка = Ложь;
		Если Элемент.ТекущиеДанные.ПечатныеФормы.Количество() = 0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НастройкиВнутреннегоЭДОСлужебныйКлиентСервер.СообщениеОбОтсутствииПечатныхФормДляВнутреннегоЭДО());
			Возврат;
		КонецЕсли;
		ПечатныеФормы = Новый Массив;
		Для каждого ПечатнаяФорма Из Элемент.ТекущиеДанные.ПечатныеФормы Цикл
			СвойстваСтруктуры = "Формировать, Идентификатор, Представление, МаршрутПодписания";
			ПечатнаяФормаСтруктура = Новый Структура(СвойстваСтруктуры);
			ЗаполнитьЗначенияСвойств(ПечатнаяФормаСтруктура, ПечатнаяФорма);
			ПечатныеФормы.Добавить(ПечатнаяФормаСтруктура);
		КонецЦикла;
		ПараметрыОткрытия = НастройкиВнутреннегоЭДОСлужебныйКлиент.НовыеПараметрыОткрытияНастройкиПечатныхФорм();
		ПараметрыОткрытия.Организация = Организация;
		ПараметрыОткрытия.ВидЭлектроннойПодписи = ДанныеСтроки.ВидПодписи;
		ПараметрыОткрытия.ПечатныеФормы = ПечатныеФормы;
		ПараметрыОткрытия.ПечатнаяФормаПоУмолчанию = Элемент.ТекущиеДанные.ПечатнаяФормаПоУмолчанию;
		ПараметрыОткрытия.РасширенныйРежим = ДанныеСтроки.РасширенныйРежимНастройки;
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораПечатныхФорм", ЭтотОбъект);
		НастройкиВнутреннегоЭДОСлужебныйКлиент.ОткрытьНастройкиПечатныхФорм(ПараметрыОткрытия, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиФормироватьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	Если ТекущиеДанные.Формировать = 2 Тогда
		ТекущиеДанные.Формировать = 0;
	КонецЕсли;
	Если ТекущиеДанные.Формировать = 0 Тогда
		Для каждого ПечатнаяФорма Из ТекущиеДанные.ПечатныеФормы Цикл
			ПечатнаяФорма.Формировать = ТекущиеДанные.Формировать;
		КонецЦикла;
	КонецЕсли;
	Если ТекущиеДанные.Формировать = 1 Тогда
		Если Не ЗначениеЗаполнено(ТекущиеДанные.ВидПодписи) Тогда
			ТекущиеДанные.ВидПодписи = ВидЭлектроннойПодписи;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекущиеДанные.ПечатнаяФормаПоУмолчанию) Тогда
			Для каждого ПечатнаяФорма Из ТекущиеДанные.ПечатныеФормы Цикл
				Если ТекущиеДанные.ПечатнаяФормаПоУмолчанию = ПечатнаяФорма.Идентификатор Тогда
					ПечатнаяФорма.Формировать = 1;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ТекущиеДанные.ПредставлениеПечатныхФорм = ПредставлениеПечатныхФорм(ТекущиеДанные);
		
	УстановитьВидЭлектроннойПодписи(ЭтаФорма);
	УстановитьВидимостьКолонкиВидПодписи(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВидПодписиПриИзменении(Элемент)

	ДанныеСтроки = Элементы.Настройки.ТекущиеДанные;
	Если ЗначениеЗаполнено(ДанныеСтроки.МаршрутПодписания) Тогда
		Если Не ДанныеСтроки.ВидПодписи = ВидПодписиВМаршруте(ДанныеСтроки.МаршрутПодписания) Тогда
			ДанныеСтроки.МаршрутПодписания = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВидЭлектроннойПодписи(ЭтаФорма);
	УстановитьВидимостьМенюПечатныхФорм(ЭтаФорма);

	УстановитьВидЭлектроннойПодписи(ЭтаФорма);
	УстановитьВидимостьМенюПечатныхФорм(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ВыполнитьКомандуЗаписать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ВыполнитьКомандуЗаписать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьСоглашенияССотрудниками(Команда)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные <> неопределено Тогда 
		
		НастройкиВнутреннегоЭДОСлужебныйКлиент.ОткрытьФормуФормированияУведомленияОбИспользованииПЭП(Организация,
			СписокПодписантовМаршрута(ТекущиеДанные.МаршрутПодписания), ЭтаФорма);
		
	КонецЕсли;
					
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПоложениеОбИспользованииПЭП(Команда)
	
	Если ЗначениеЗаполнено(Организация) Тогда 
		
		НастройкиВнутреннегоЭДОСлужебныйКлиент.ОткрытьФормуФормированияПоложенияОбИспользованииПЭП(Организация,
			ЭтаФорма);
			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	УдалитьНастройку();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ВидПодписиВМаршруте(МаршрутПодписания) 
	
	Результат = МаршрутыПодписанияБЭД.ВидПодписиМаршрута(МаршрутПодписания);
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокПодписантовМаршрута(Маршрут) 
	
	Возврат МаршрутыПодписанияБЭД.ВозможныеПодписантыМаршрута(Маршрут);
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеПечатныхФорм(Настройка) 
	
	ПредставлениеПечатныхФорм = "";
	ОтмеченныеПечатныеФормы = Новый Массив;
	Для каждого ПечатнаяФорма Из Настройка.ПечатныеФормы Цикл
		Если ПечатнаяФорма.Формировать = 1 Тогда
			ОтмеченныеПечатныеФормы.Добавить(ПечатнаяФорма.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	КоличествоПечатныхФорм = ОтмеченныеПечатныеФормы.Количество();
	Если ЗначениеЗаполнено(Настройка.ПечатнаяФормаПоУмолчанию) Тогда
		Если КоличествоПечатныхФорм > 0 И ОтмеченныеПечатныеФормы.Найти(Настройка.ПечатнаяФормаПоУмолчанию) <> Неопределено Тогда
			КоличествоПечатныхФорм = КоличествоПечатныхФорм - 1;
		КонецЕсли;
		СтрокиПечатныхФорм  = Настройка.ПечатныеФормы.НайтиСтроки(Новый Структура("Идентификатор", Настройка.ПечатнаяФормаПоУмолчанию));
		Если СтрокиПечатныхФорм.Количество() Тогда
			ПредставлениеПечатнойФормыПоУмолчанию = СтрокиПечатныхФорм[0].Представление;
		Иначе 
			ПредставлениеПечатнойФормыПоУмолчанию = "";
		КонецЕсли;
		Если КоличествоПечатныхФорм = 0 Тогда
			ПредставлениеПечатныхФорм = ПредставлениеПечатнойФормыПоУмолчанию;
		Иначе 
			ШаблонПредставления = НСтр("ru = '%1 и еще %2'");
			ПредставлениеПечатныхФорм = СтрШаблон(ШаблонПредставления, ПредставлениеПечатнойФормыПоУмолчанию, КоличествоПечатныхФорм);
		КонецЕсли;
	Иначе 
		Если КоличествоПечатныхФорм = 0 Тогда
			ПредставлениеПечатныхФорм = НСтр("ru = 'Указать'");
		Иначе
			ПредставлениеПечатныхФорм = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru=';%1 форма;;%1 формы;%1 форм;%1 формы'"), 
				КоличествоПечатныхФорм,, "ЧДЦ=0");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПредставлениеПечатныхФорм;
	
КонецФункции 

&НаСервере
Процедура СохранитьНастройки() 
	
	Отказ = Ложь;
	НастройкиВнутреннегоЭДОСлужебный.ЗаписатьНастройкиВнутреннегоЭДО(Организация, СформироватьНастройки(),, Отказ);
	Если Не Отказ Тогда
		ЭтоНовый = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПечатныхФорм(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Модифицированность = Истина;
		ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
		ТекущиеДанные.ПечатныеФормы.Очистить();
		Для каждого ПечатнаяФорма Из РезультатЗакрытия.ПечатныеФормы Цикл
			НоваяСтрока = ТекущиеДанные.ПечатныеФормы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ПечатнаяФорма);
		КонецЦикла; 
		ТекущиеДанные.ПечатнаяФормаПоУмолчанию = РезультатЗакрытия.ПечатнаяФормаПоУмолчанию;
		ТекущиеДанные.ПредставлениеПечатныхФорм = ПредставлениеПечатныхФорм(ТекущиеДанные);
		ТекущиеДанные.РасширенныйРежимНастройки = РезультатЗакрытия.РасширенныйРежимНастройки;
		Если Не РезультатЗакрытия.РасширенныйРежимНастройки И РезультатЗакрытия.ПечатныеФормы.Количество() Тогда
			ТекущиеДанные.МаршрутПодписания = РезультатЗакрытия.ПечатныеФормы[0].МаршрутПодписания;
		КонецЕсли;
		ЕстьОтметка = Ложь;
		Для каждого ЭлементСписка Из ТекущиеДанные.ПечатныеФормы Цикл
			Если ЭлементСписка.Формировать = 1 Тогда
				ЕстьОтметка = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьОтметка Тогда
			ТекущиеДанные.Формировать = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройки() 
	
	АктуальныеКомандыПечати = НастройкиВнутреннегоЭДОПовтИсп.КомандыПечатиВнутреннихЭлектронныхДокументов();
	
	Если Не ЭтоНовый Тогда
		
		ЗаполнитьСуществующиеНастройки(АктуальныеКомандыПечати);
		
	КонецЕсли;
	
	Для каждого КлючИЗначение Из АктуальныеКомандыПечати Цикл
		ИдентификаторОбъектаУчета = КлючИЗначение.Ключ;
		КомандыПечати = КлючИЗначение.Значение;
		Строки = Настройки.НайтиСтроки(Новый Структура("ИдентификаторОбъектаУчета", ИдентификаторОбъектаУчета));
		Если Строки.Количество() = 0 Тогда
			СтрокаНастроек = Настройки.Добавить();
			СтрокаНастроек.Формировать = 2;
			СтрокаНастроек.ИдентификаторОбъектаУчета = ИдентификаторОбъектаУчета;
			СтрокаНастроек.ВидВнутреннегоДокумента = ИдентификаторОбъектаУчета;
		Иначе 
			СтрокаНастроек = Строки[0];
		КонецЕсли;
		
		Для каждого КомандаПечати Из КомандыПечати Цикл
			Отбор = Новый Структура("Идентификатор", КомандаПечати.Идентификатор);
			Если СтрокаНастроек.ПечатныеФормы.НайтиСтроки(Отбор).Количество() = 0 Тогда
				ПечатнаяФорма = СтрокаНастроек.ПечатныеФормы.Добавить();
				ПечатнаяФорма.Формировать = 2;
				ПечатнаяФорма.Идентификатор = КомандаПечати.Идентификатор;
				ПечатнаяФорма.Представление = КомандаПечати.Представление;
			КонецЕсли;
		КонецЦикла;
		СтрокаНастроек.ПредставлениеПечатныхФорм = ПредставлениеПечатныхФорм(СтрокаНастроек);
	КонецЦикла;
	
	Настройки.Сортировать("ИдентификаторОбъектаУчета");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуществующиеНастройки(АктуальныеКомандыПечати) 
	
	ПараметрыАктуализации = Новый Структура;
	ПараметрыАктуализации.Вставить("НеактуальныеВидыДокументов", Новый Массив);
	
	Запросы = Новый Массив;
	
	Отбор = НастройкиВнутреннегоЭДОСлужебный.НовыйОтборНастроекВнутреннегоЭДО();
	Отбор.Организация = "&Организация";
	ЗапросНастроек = НастройкиВнутреннегоЭДОСлужебный.ЗапросНастроекВнутреннегоЭДО("НастройкиВнутреннегоЭДО",
		Отбор);
	Запросы.Добавить(ЗапросНастроек);
	
	Отбор = ЭлектронныеДокументыЭДО.НовыйОтборВидовДокументов();
	Отбор.Ссылка = "ВЫБРАТЬ ВидВнутреннегоДокумента ИЗ НастройкиВнутреннегоЭДО";
	ЗапросВидовДокументов = ЭлектронныеДокументыЭДО.ЗапросВидовДокументов("ВидыДокументовЭДО", Отбор);
	Запросы.Добавить(ЗапросВидовДокументов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиВнутреннегоЭДО.Формировать КАК Формировать,
	|	НастройкиВнутреннегоЭДО.ВидПодписи КАК ВидПодписи,
	|	НастройкиВнутреннегоЭДО.МаршрутПодписания КАК МаршрутПодписания,
	|	НастройкиВнутреннегоЭДО.ЭтоОсновнойВидДокумента КАК ЭтоОсновнойВидДокумента,
	|	ВидыДокументовЭДО.ИдентификаторОбъектаУчета КАК ИдентификаторОбъектаУчета,
	|	ВидыДокументовЭДО.Наименование КАК ПредставлениеКомандыПечати,
	|	ВидыДокументовЭДО.ИдентификаторКомандыПечати КАК ИдентификаторКомандыПечати,
	|	ВидыДокументовЭДО.Ссылка КАК ВидВнутреннегоДокумента
	|ИЗ
	|	НастройкиВнутреннегоЭДО КАК НастройкиВнутреннегоЭДО
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВидыДокументовЭДО КАК ВидыДокументовЭДО
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	|			ПО ВидыДокументовЭДО.ИдентификаторОбъектаУчета = ИдентификаторыОбъектовМетаданных.Ссылка
	|		ПО НастройкиВнутреннегоЭДО.ВидВнутреннегоДокумента = ВидыДокументовЭДО.Ссылка
	|ИТОГИ
	|ПО
	|	ИдентификаторОбъектаУчета,
	|	ИдентификаторКомандыПечати";
	
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = ИтоговыйЗапрос.Выполнить();
	
	ВыборкаИдентификаторОбъектаУчета = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаИдентификаторОбъектаУчета.Следующий() Цикл
		АктуальныеКомандыПечатиОбъектаУчета = АктуальныеКомандыПечати[ВыборкаИдентификаторОбъектаУчета.ИдентификаторОбъектаУчета];
		Если АктуальныеКомандыПечатиОбъектаУчета = Неопределено Тогда
			ВыборкаИдентификаторКомандыПечати = ВыборкаИдентификаторОбъектаУчета.Выбрать(
				ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаИдентификаторКомандыПечати.Следующий() Цикл
				ВыборкаДетальныеЗаписи = ВыборкаИдентификаторКомандыПечати.Выбрать();
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					ПараметрыАктуализации.НеактуальныеВидыДокументов.Добавить(
						ВыборкаДетальныеЗаписи.ВидВнутреннегоДокумента);
				КонецЦикла;
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		СтрокаНастроек = Настройки.Добавить();
		СтрокаНастроек.ИдентификаторОбъектаУчета = ВыборкаИдентификаторОбъектаУчета.ИдентификаторОбъектаУчета;
		
		ВыборкаИдентификаторКомандыПечати = ВыборкаИдентификаторОбъектаУчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаИдентификаторКомандыПечати.Следующий() Цикл
			АктуальнаяПечатнаяФорма = АктуальныеКомандыПечатиОбъектаУчета.Найти(
				ВыборкаИдентификаторКомандыПечати.ИдентификаторКомандыПечати, "Идентификатор");
			Если АктуальнаяПечатнаяФорма = Неопределено Тогда
				ПечатнаяФорма = Неопределено;
			Иначе 
				ПечатнаяФорма = СтрокаНастроек.ПечатныеФормы.Добавить();
				ПечатнаяФорма.Идентификатор = ВыборкаИдентификаторКомандыПечати.ИдентификаторКомандыПечати;
			КонецЕсли;
			ВыборкаДетальныеЗаписи = ВыборкаИдентификаторКомандыПечати.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если ПечатнаяФорма <> Неопределено И АктуальнаяПечатнаяФорма <> Неопределено Тогда
					ПечатнаяФорма.Формировать = ВыборкаДетальныеЗаписи.Формировать;
					ПечатнаяФорма.Представление = АктуальнаяПечатнаяФорма.Представление;
					ПечатнаяФорма.МаршрутПодписания = ВыборкаДетальныеЗаписи.МаршрутПодписания;
				КонецЕсли;
				СтрокаНастроек.ВидВнутреннегоДокумента = ВыборкаДетальныеЗаписи.ВидВнутреннегоДокумента;
				СтрокаНастроек.Формировать = СтрокаНастроек.Формировать Или ВыборкаДетальныеЗаписи.Формировать;
				СтрокаНастроек.МаршрутПодписания = ВыборкаДетальныеЗаписи.МаршрутПодписания;
				СтрокаНастроек.ПредставлениеПечатныхФорм = ПредставлениеПечатныхФорм(СтрокаНастроек);
				СтрокаНастроек.ВидПодписи = ВыборкаДетальныеЗаписи.ВидПодписи;
				Если Не ЗначениеЗаполнено(СтрокаНастроек.ПечатнаяФормаПоУмолчанию)
					И ВыборкаДетальныеЗаписи.ЭтоОсновнойВидДокумента Тогда
					СтрокаНастроек.ПечатнаяФормаПоУмолчанию = ВыборкаДетальныеЗаписи.ИдентификаторКомандыПечати;
				КонецЕсли;
				Прервать; 
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Для каждого СтрокаНастроек Из Настройки Цикл
		ТаблицаПечатныхФорм = СтрокаНастроек.ПечатныеФормы.Выгрузить();
		ТаблицаПечатныхФорм.Свернуть("МаршрутПодписания");
		СтрокаНастроек.РасширенныйРежимНастройки = ТаблицаПечатныхФорм.Количество() > 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуЗаписать(Закрыть = Ложь) 
	
	Если ПроверитьЗаполнение() Тогда
		СохранитьНастройки();
		Модифицированность = Ложь;
		Оповестить("ОбновитьТекущиеДелаЭДО");
		Для каждого Настройка Из Настройки Цикл
			Если ЗначениеЗаполнено(Настройка.ПечатнаяФормаПоУмолчанию) Тогда
				НастройкиВнутреннегоЭДОСлужебныйКлиент.ОповеститьОбИсправленииОшибкиНеустановленнойПоУмолчаниюПечатнойФормы(
					Организация, Настройка.ИдентификаторОбъектаУчета);
			КонецЕсли;
		КонецЦикла;
		Если Закрыть Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.Формировать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиВидДокумента");
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиПечатнаяФорма");
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиМаршрутПодписания");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.Формировать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиПечатнаяФорма");
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиМаршрутПодписания");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<расширенный режим>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.РасширенныйРежимНастройки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиМаршрутПодписания");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.РасширенныйРежимНастройки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.Формировать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.МаршрутПодписания");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиМаршрутПодписания");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемОкнаФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		ВыполнитьКомандуЗаписать(Истина);
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция СформироватьНастройки() 
	
	СохраняемыеНастройки = НастройкиВнутреннегоЭДОСлужебный.НоваяТаблицаНастроекВнутреннегоЭДО();
	
	Для каждого Настройка Из Настройки Цикл
		Если Настройка.Формировать = 2 Тогда
			Продолжить;
		КонецЕсли;
		Для каждого ПечатнаяФорма Из Настройка.ПечатныеФормы Цикл
			Если ПечатнаяФорма.Формировать = 2 Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = СохраняемыеНастройки.Добавить();
			НоваяСтрока.Формировать = Настройка.Формировать = 1 И ПечатнаяФорма.Формировать = 1;
			НоваяСтрока.Организация = Организация;
			НоваяСтрока.ВидПодписи = Настройка.ВидПодписи;
			
			НоваяСтрока.МаршрутПодписания = ПечатнаяФорма.МаршрутПодписания;
			КомандаПечати = Новый Структура;
			КомандаПечати.Вставить("Идентификатор", ПечатнаяФорма.Идентификатор);
			КомандаПечати.Вставить("Представление", ПечатнаяФорма.Представление);
			НоваяСтрока.КомандаПечати = КомандаПечати;
			НоваяСтрока.ИдентификаторОбъектаУчета = Настройка.ИдентификаторОбъектаУчета;
			Если Настройка.ПечатнаяФормаПоУмолчанию = ПечатнаяФорма.Идентификатор Тогда
				НоваяСтрока.ЭтоОсновнойВидДокумента = Истина;
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
	
	Возврат СохраняемыеНастройки;
	
КонецФункции 

&НаКлиенте
Функция МожноВыбиратьМаршрут(ВидПодписи, ВыбраннаяСтрока) 
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Организация",, Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВидПодписи) Тогда
		ТекстСообщения = ОбщегоНазначенияБЭДКлиентСервер.ТекстСообщения("Поле", "Заполнение", НСтр("ru = 'Вид электронной подписи'"));
		КолонкаНастроекВидима = Элементы.НастройкиВидПодписи.Видимость;
		Поле = "ВидЭлектроннойПодписи";
		Если КолонкаНастроекВидима Тогда
			СтрокаТаблицы = Настройки.НайтиПоИдентификатору(ВыбраннаяСтрока);
			Если СтрокаТаблицы <> Неопределено Тогда
				ИндексВыбраннойСтроки = Настройки.Индекс(СтрокаТаблицы);
				Поле = СтрШаблон("Настройки[%1].ВидПодписи", ИндексВыбраннойСтроки);
			КонецЕсли;
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
	КонецЕсли;
			
	Возврат Не Отказ;
	
КонецФункции 

&НаКлиенте
Процедура УдалитьНастройку()
	
	Если ЭтоНовый Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Настройка еще не записана, удаление невозможно'"));
		Возврат; 
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Удалить настройку внутреннего документооборота?'");
	Описание = Новый ОписаниеОповещения("УдалитьНастройкуПослеВопроса", ЭтотОбъект);
	ПоказатьВопрос(Описание, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуПослеВопроса(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	УдалитьНастройкуНаСервере();
	
	Оповестить("ОбновитьТекущиеДелаЭДО");
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройкуНаСервере()
	
	НастройкиВнутреннегоЭДОСлужебный.УдалитьНастройкуВнутреннегоЭДО(Организация);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьМенюПечатныхФорм(Форма)
	
	ПростаяПодпись = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая");
	ЕстьПростаяПодпись = Форма.Настройки.НайтиСтроки(Новый Структура("ВидПодписи,Формировать", ПростаяПодпись, 1)).Количество();
	
	Форма.Элементы.ГруппаФормированияПечатныхФорм.Видимость = 
		Форма.ВидЭлектроннойПодписи = ПростаяПодпись
		Или ЕстьПростаяПодпись;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьКолонкиВидПодписи(Форма)
	
	Форма.Элементы.НастройкиВидПодписи.Видимость = ТипЗнч(Форма.ВидЭлектроннойПодписи) = Тип("Строка");
	
КонецПроцедуры

&НаСервере
Функция ЕстьНастройкаПоОрганизации() 
	
	Возврат НастройкиВнутреннегоЭДОСлужебный.НастройкаВнутреннегоЭДО(Организация) <> Неопределено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидЭлектроннойПодписи(Форма)
	
	ПростаяПодпись = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая");
	УсиленнаяПодпись = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная");
	
	ЕстьПростаяПодпись = Форма.Настройки.НайтиСтроки(Новый Структура("ВидПодписи,Формировать", ПростаяПодпись, 1)).Количество();
	ЕстьУсиленнаяПодпись = Форма.Настройки.НайтиСтроки(Новый Структура("ВидПодписи,Формировать", УсиленнаяПодпись, 1)).Количество();
	
	Если ЕстьПростаяПодпись И ЕстьУсиленнаяПодпись Тогда
		Форма.ВидЭлектроннойПодписи = НастройкиВнутреннегоЭДОКлиентСервер.ВидЭлектроннойПодписиПоВидамДокументов();
	ИначеЕсли ЕстьПростаяПодпись Тогда
		Форма.ВидЭлектроннойПодписи = ПростаяПодпись;
	ИначеЕсли ЕстьУсиленнаяПодпись Тогда
		Форма.ВидЭлектроннойПодписи = УсиленнаяПодпись;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВариантаПодписиИзСписка(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИсключаемыеВидыЭлектронныхПодписей = ИсключаемыеВидыЭлектронныхПодписей(ВидЭлектроннойПодписи, ВыбранныйЭлемент.Значение);
	
	ВидЭлектроннойПодписи = ВыбранныйЭлемент.Значение;
	ПредопределенныеМаршруты = МаршрутыПодписанияБЭДКлиент.ПредопределенныеМаршруты();
	
	// По видам документов не нужно обрабатывать
	Если ТипЗнч(ВидЭлектроннойПодписи) = Тип("ПеречислениеСсылка.ВидыЭлектронныхПодписей") Тогда
		Для каждого СтрокаНастроек Из Настройки Цикл
			СтрокаНастроек.ВидПодписи = ВидЭлектроннойПодписи;
			
			Если ВидПодписиМаршрутаВИсключаемых(ИсключаемыеВидыЭлектронныхПодписей, СтрокаНастроек.МаршрутПодписания)
				И СтрокаНастроек.МаршрутПодписания <> ПредопределенныеМаршруты.УказыватьПриСоздании Тогда
				
				СтрокаНастроек.МаршрутПодписания = Неопределено;
			КонецЕсли;
			Для каждого ПечатнаяФорма Из СтрокаНастроек.ПечатныеФормы Цикл
				Если ВидПодписиМаршрутаВИсключаемых(ИсключаемыеВидыЭлектронныхПодписей, ПечатнаяФорма.МаршрутПодписания)
					И ПечатнаяФорма.МаршрутПодписания <> ПредопределенныеМаршруты.УказыватьПриСоздании Тогда
					
					ПечатнаяФорма.МаршрутПодписания = Неопределено;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	УстановитьВидимостьМенюПечатныхФорм(ЭтаФорма);
	УстановитьВидимостьКолонкиВидПодписи(ЭтаФорма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ИсключаемыеВидыЭлектронныхПодписей(ТекущийВид, ВыбранныйВид)
	
	Результат = Новый Массив();
	
	ПЭП = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая");
	КЭП = ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.УсиленнаяКвалифицированная");
	ПВД = НастройкиВнутреннегоЭДОКлиентСервер.ВидЭлектроннойПодписиПоВидамДокументов();
	
	Если ТекущийВид = ПВД И ВыбранныйВид = ПЭП
		Или ТекущийВид = КЭП И ВыбранныйВид = ПЭП Тогда
		
		Результат.Добавить(КЭП);
	ИначеЕсли ТекущийВид = ПВД И ВыбранныйВид = КЭП
		Или ТекущийВид = ПЭП И ВыбранныйВид = КЭП Тогда
		
		Результат.Добавить(ПЭП);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВидПодписиМаршрутаВИсключаемых(ИсключаемыеПодписи, Маршрут)
	
	ВидПодписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Маршрут, "ВидПодписи");
	Результат = ИсключаемыеПодписи.Найти(ВидПодписи) <> Неопределено;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти