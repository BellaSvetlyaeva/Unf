
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ТорговыеПредложения.ПравоНастройкиТорговыхПредложений(Истина)
		Или Не ЗначениеЗаполнено(Параметры.ТорговоеПредложение) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СвойстваПредложения = Новый Структура("Организация, Валюта");
	ТорговыеПредложенияПереопределяемый.ПолучитьСвойстваТорговогоПредложения(Параметры.ТорговоеПредложение, СвойстваПредложения);
	
	ТекущаяЗапись = ТорговыеПредложенияСлужебный.ЗаписьСостояниеСинхронизации(
		СвойстваПредложения.Организация, 
		Параметры.ТорговоеПредложение);
	
	Если ТекущаяЗапись = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		ЗначениеВРеквизитФормы(ТекущаяЗапись, "Запись");
	КонецЕсли;
	
	УстановитьВидимостьДоступность(Запись, Элементы);
	
	УстановитьЗаголовокСсылкиОткрытияАдресов();
	Элементы.НастройкиКратностиУпаковок.Заголовок = 
		ЗаголовкиСсылкиОткрытияНастройкиКратностиУпаковок(Запись.ТорговоеПредложение);
	
	НастройкиПодсистемы = ТорговыеПредложения.НастройкиПодсистемы();
	
	ЗаполнитьВариантПубликацииОстатков(НастройкиПодсистемы);
	ЗаполнитьВариантыПубликацииСкидок(НастройкиПодсистемы);
	
	Отбор = Новый Структура("ПрайсЛист", Запись.ТорговоеПредложение);
	СведенияОТорговомПредложении = ТорговыеПредложенияСлужебный.ПолучитьДанныеПубликации("Контакты", Отбор);
	
	ЗаполнитьВариантыСпискаАдресЭлектроннойПочты(СведенияОТорговомПредложении.Контакты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьЗаголовокСсылкиОткрытияАдресов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(Запись.АдресЭлектроннойПочты) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Уведомление о заказах по эл.почте""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , "Запись.АдресЭлектроннойПочты", Отказ);
	ИначеЕсли Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(
																	Запись.АдресЭлектроннойПочты, Истина) Тогда
		ТекстСообщения = НСтр("ru = 'Адрес электронной почты введен неверно'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , "Запись.АдресЭлектроннойПочты", Отказ);
	КонецЕсли;
	
	Если Запись.ПубликоватьРегионыДоступностиТоваров
		И Не ЗначениеЗаполнено(Запись.РегионыДоставки)
		И Не ЗначениеЗаполнено(Запись.РегионыСамовывоза) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не заполнены регионы доступности товаров'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		
	КонецЕсли;
	
	Если Запись.ПубликоватьЦенуДоСкидки И Запись.ВариантПубликацииСкидки.Пустая() Тогда
		
		ТекстСообщения = НСтр("ru = 'Выберите вариант публикации скидки'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Запись.ВариантПубликацииСкидки", , Отказ);
		
	ИначеЕсли Запись.ПубликоватьЦенуДоСкидки И Не ЗначениеЗаполнено(Скидка) Тогда
		
		ТекстСообщения = НСтр("ru = 'Выберите скидку'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Скидка", , Отказ);
		
	КонецЕсли;
	
	Если Запись.ПубликоватьСкидкиЗаРазовыйОбъемПродаж И Запись.ВариантПубликацииСкидкиЗаОпт.Пустая() Тогда
		
		ТекстСообщения = НСтр("ru = 'Выберите вариант публикации скидки за опт'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Запись.ВариантПубликацииСкидкиЗаОпт", , Отказ);
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаписи = Новый Структура;
	ЗначенияЗаписи.Вставить("ТорговоеПредложение"                  , Запись.ТорговоеПредложение);
	ЗначенияЗаписи.Вставить("Организация"                          , Запись.Организация);
	ЗначенияЗаписи.Вставить("АдресЭлектроннойПочты"                , Запись.АдресЭлектроннойПочты);
	ЗначенияЗаписи.Вставить("ПубликоватьОстатки"                   , Запись.ПубликоватьОстатки);
	ЗначенияЗаписи.Вставить("ПубликоватьСрокиПоставки"             , Запись.ПубликоватьСрокиПоставки);
	ЗначенияЗаписи.Вставить("ПубликоватьЦены"                      , Запись.ПубликоватьЦены);
	ЗначенияЗаписи.Вставить("ДополнительноеОписание"               , Запись.ДополнительноеОписание);
	ЗначенияЗаписи.Вставить("ВариантПубликацииОстатков"            , Запись.ВариантПубликацииОстатков);
	ЗначенияЗаписи.Вставить("ВариантПубликацииСкидки"              , Запись.ВариантПубликацииСкидки);
	ЗначенияЗаписи.Вставить("ВариантПубликацииСкидкиЗаОпт"         , Запись.ВариантПубликацииСкидкиЗаОпт);
	Оповестить("ТорговыеПредложения_ЗаписьДополнительныеНастройки" , ЗначенияЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Запись.ТорговоеПредложение);
	Оповестить("ТорговыеПредложения_ПослеЗаписи", Запись.ТорговоеПредложение, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСинхронизацииТорговыеПредложения.ТребуетсяСинхронизация");
	
	Если Запись.ПубликоватьОстатки Тогда
		ТекущийОбъект.ВариантПубликацииОстатков = ВариантПубликацииОстатков;
	Иначе
		ТекущийОбъект.ВариантПубликацииОстатков = ПредопределенноеЗначение("Перечисление.ВариантыПубликацииОстатковТорговыеПредложения.ПустаяСсылка");
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВариантПубликацииСкидки = ТекущийОбъект.ВариантПубликацииСкидки;
	ТорговоеПредложение = ТекущийОбъект.ТорговоеПредложение;
	
	Если Запись.ПубликоватьЦенуДоСкидки Тогда
		
		// Установка транзакционной блокировки.
		Если Запись.ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыЦен Тогда
			РегистрСведенийДляБлокировки = "РегистрСведений.СкидкиТорговыхПредложенийВидыЦен";
		ИначеЕсли Запись.ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыСкидок Тогда
			РегистрСведенийДляБлокировки = "РегистрСведений.СкидкиТорговыхПредложений";
		КонецЕсли;
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(РегистрСведенийДляБлокировки);
		ЭлементБлокировкиДанных.УстановитьЗначение("ТорговоеПредложение", ТорговоеПредложение);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		// Чтение существующей записи скидки.
		ПараметрыОтбора = ТорговыеПредложенияСлужебный.ПараметрыОтбораСкидок();
		ПараметрыОтбора.ТорговоеПредложение = ТорговоеПредложение;
		РезультатЗапроса = ТорговыеПредложенияСлужебный.СкидкиТорговыхПредложений(
				Запись.ВариантПубликацииСкидки, ПараметрыОтбора);
		
		Если РезультатЗапроса <> Неопределено И Не РезультатЗапроса.Пустой() Тогда
			
			// Удаление записи существующей скидки.
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			СкидкаКУдалению = Выборка.ВидыЦен;
			ТорговыеПредложенияСлужебный.ДобавитьИзменитьСкидкуТорговогоПредложения(
					ВариантПубликацииСкидки, ТорговоеПредложение, СкидкаКУдалению, Отказ, Истина);
			
		КонецЕсли;
		
		// Добавление новой записи скидки.
		ТорговыеПредложенияСлужебный.ДобавитьИзменитьСкидкуТорговогоПредложения(
				Запись.ВариантПубликацииСкидки, ТорговоеПредложение, Скидка, Отказ);
		
	Иначе
		
		Если ЗначениеЗаполнено(Скидка) Тогда
			
			ТорговыеПредложенияСлужебный.ДобавитьИзменитьСкидкуТорговогоПредложения(
					ВариантПубликацииСкидки, ТорговоеПредложение, Скидка, Отказ, Истина);
			
			Скидка = ПустоеЗначениеСкидки(ВариантПубликацииСкидки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПубликоватьОстаткиПриИзменении(Элемент)
	УстановитьДоступностьВариантаПубликацииОстатков();
КонецПроцедуры

&НаКлиенте
Процедура СоставРегионовНажатие(Элемент)
	
	ПараметрыФормы = БизнесСетьСлужебныйКлиент.ОписаниеПараметровФормыНастройкиРегионов();
	
	ПараметрыФормы.Организация         = Запись.Организация;
	ПараметрыФормы.ТорговоеПредложение = Запись.ТорговоеПредложение;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораАдресов", ЭтотОбъект);
		
	БизнесСетьСлужебныйКлиент.ОткрытьФормуНастройкиРегионов(ПараметрыФормы, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПубликоватьРегионыПриИзменении(Элемент)
	
	Элементы.СоставРегионов.Доступность = Запись.ПубликоватьРегионыДоступностиТоваров;
	
КонецПроцедуры

&НаКлиенте
Процедура ПубликоватьЦеныПриИзменении(Элемент)
	УстановитьВидимостьДоступность(Запись, Элементы)
КонецПроцедуры

&НаКлиенте
Процедура ВариантыПубликацииСкидкиЗаОптНажатие(Элемент)
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ВариантыПубликацииСкидкиЗаОптНажатиеПродолжение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Для продолжения необходимо записать изменения.'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Ок);
		
	Иначе
		
		ТорговыеПредложенияКлиент.ОткрытьФормуСкидкиТорговыхПредложений(
			ЭтотОбъект, Запись.ВариантПубликацииСкидкиЗаОпт, Запись.ТорговоеПредложение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПубликоватьСкидкиЗаРазовыйОбъемПродажПриИзменении(Элемент)
	УстановитьВидимостьДоступность(Запись, Элементы);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПубликацииСкидкиЗаОптПриИзменении(Элемент)
	
	УстановитьЗаголовкиСсылкиОткрытияВариантовПубликацииСкидок();
	УстановитьВидимостьДоступность(Запись, Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПубликацииСкидкиПриИзменении(Элемент)
	УстановитьВариантПубликацииСкидки();
КонецПроцедуры

&НаКлиенте
Процедура ПубликоватьЦенуДоСкидкиПриИзменении(Элемент)
	УстановитьВидимостьДоступность(Запись, Элементы);
	УстановитьВариантПубликацииСкидки();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКратностиУпаковокНажатие(Элемент)
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("НастройкиКратностиУпаковокНажатиеПродолжение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Для продолжения необходимо записать изменения.'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Ок);
		
	Иначе
		
		ОткрытьФормуНастройкаКратностиУпаковок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПубликоватьКратностьУпаковокПриИзменении(Элемент)
	УстановитьВидимостьДоступность(Запись, Элементы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Запись, Элементы)
	
	Элементы.СоставРегионов.Доступность                      = Запись.ПубликоватьРегионыДоступностиТоваров;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ПубликоватьСкидкиЗаОпт", "Доступность", Запись.ПубликоватьЦены);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ПубликоватьЦенуДоСкидки", "Доступность", Запись.ПубликоватьЦены);
	
	ПубликоватьСкидки = 
		Элементы.ГруппаСкидкиГруппировка.Доступность 
		И Запись.ПубликоватьЦены 
		И Запись.ПубликоватьЦенуДоСкидки;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"ВариантПубликацииСкидки", 
		"Доступность", 
		ПубликоватьСкидки);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"Скидка", 
		"Доступность", 
		ПубликоватьСкидки И Не Запись.ВариантПубликацииСкидки.Пустая());
	
	ПубликоватьСкидкиЗаОпт = 
		Элементы.ГруппаСкидкиГруппировка.доступность 
		И Запись.ПубликоватьЦены 
		И Запись.ПубликоватьСкидкиЗаРазовыйОбъемПродаж;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"ВариантПубликацииСкидкиЗаОпт", 
		"Доступность", 
		ПубликоватьСкидкиЗаОпт);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"ВариантыПубликацииСкидокЗаОпт", 
		"Доступность", 
		ПубликоватьСкидкиЗаОпт И Не Запись.ВариантПубликацииСкидкиЗаОпт.Пустая());
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"НастройкиКратностиУпаковок", 
		"Доступность", 
		Запись.ПубликоватьКратностьУпаковок);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантПубликацииОстатков(НастройкиПодсистемы)
	
	УстановитьДоступностьВариантаПубликацииОстатков();
	
	Элементы.ПубликоватьОстатки.Видимость = НастройкиПодсистемы.ИспользоватьПубликациюОстатков;
	Элементы.ВариантПубликацииОстатков.СписокВыбора.ЗагрузитьЗначения(НастройкиПодсистемы.ВариантыПубликацииОстатков);
	
	Если ЗначениеЗаполнено(Запись.ВариантПубликацииОстатков) Тогда
		ВариантПубликацииОстатков = Запись.ВариантПубликацииОстатков;
	Иначе
		Если ЗначениеЗаполнено(Элементы.ВариантПубликацииОстатков.СписокВыбора) Тогда
			ВариантПубликацииОстатков = Элементы.ВариантПубликацииОстатков.СписокВыбора[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ВариантПубликацииОстатков.СписокВыбора.Количество() = 1 Тогда
		Элементы.ВариантПубликацииОстатков.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантыПубликацииСкидок(НастройкиПодсистемы)
	
	ВариантыПубликацииСкидок = НастройкиПодсистемы.ВариантыПубликацииСкидок;
	Элементы.ВариантПубликацииСкидкиЗаОпт.СписокВыбора.ЗагрузитьЗначения(ВариантыПубликацииСкидок);
	Элементы.ВариантПубликацииСкидки.СписокВыбора.ЗагрузитьЗначения(ВариантыПубликацииСкидок);
	
	Если ВариантыПубликацииСкидок.Количество() = 1 Тогда
		Запись.ВариантПубликацииСкидки = ВариантыПубликацииСкидок[0];
		Запись.ВариантПубликацииСкидкиЗаОпт = ВариантыПубликацииСкидок[0];
	КонецЕсли;
	
	// Вариант публикации скидки за опт.
	Если Элементы.ВариантПубликацииСкидкиЗаОпт.СписокВыбора.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаМатрицаЦен", "Доступность", Ложь);
	ИначеЕсли Элементы.ВариантПубликацииСкидкиЗаОпт.СписокВыбора.Количество() = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ВариантПубликацииСкидкиЗаОпт", "Видимость", Ложь);
	КонецЕсли;
	
	// Вариант публикации скидки.
	Если Элементы.ВариантПубликацииСкидки.СписокВыбора.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ГруппаЦенаДоСкидки", "Доступность", Ложь);
	ИначеЕсли Элементы.ВариантПубликацииСкидки.СписокВыбора.Количество() = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "ВариантПубликацииСкидки", "Видимость", Ложь);
	КонецЕсли;
	
	УстановитьВариантПубликацииСкидки();
	
	УстановитьЗаголовкиСсылкиОткрытияВариантовПубликацииСкидок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораАдресов(Результат, ДополнительныеПараметры) Экспорт
	УстановитьЗаголовокСсылкиОткрытияАдресов(Истина);
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокСсылкиОткрытияАдресов(ПеречитатьДанные = Ложь)
	
	Если ПеречитатьДанные Тогда
		ТекущаяЗапись = ТорговыеПредложенияСлужебный.ЗаписьСостояниеСинхронизации(Запись.Организация, Запись.ТорговоеПредложение);
		ЗаполнитьЗначенияСвойств(Запись, ТекущаяЗапись, "РегионыДоставки, РегионыСамовывоза");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.РегионыДоставки)
		ИЛИ ЗначениеЗаполнено(Запись.РегионыСамовывоза) Тогда
		
		Элементы.СоставРегионов.Заголовок = НСтр("ru = 'Изменить'");
	Иначе
		Элементы.СоставРегионов.Заголовок = "<" + НСтр("ru = 'не указаны'") + ">";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьВариантаПубликацииОстатков()
	Элементы.ВариантПубликацииОстатков.Доступность = Запись.ПубликоватьОстатки;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВариантаПубликацииСкидок(Результат, ДополнительныеПараметры) Экспорт
	УстановитьЗаголовкиСсылкиОткрытияВариантовПубликацииСкидок();
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиСсылкиОткрытияВариантовПубликацииСкидок(ПеречитатьДанные = Ложь)
	
	ТекущаяЗапись = ТорговыеПредложенияСлужебный.ЗаписьСостояниеСинхронизации(
		Запись.Организация, Запись.ТорговоеПредложение);
	
	Если ПеречитатьДанные Тогда
		ЗаполнитьЗначенияСвойств(Запись, ТекущаяЗапись, "ВариантПубликацииСкидкиЗаОпт, ВариантПубликацииСкидки");
	КонецЕсли;
	
	ЗначенияНеУказаны = "<" + НСтр("ru = 'не указаны'") + ">";
	Элементы.ВариантыПубликацииСкидокЗаОпт.Заголовок = ЗначенияНеУказаны;
	
	ПараметрыОтбора = ТорговыеПредложенияСлужебный.ПараметрыОтбораСкидок();
	ПараметрыОтбора.ТорговоеПредложение = Запись.ТорговоеПредложение;
	ПараметрыОтбора.Опт = Истина;
	
	РезультатЗапроса = ТорговыеПредложенияСлужебный.СкидкиТорговыхПредложений(
		Запись.ВариантПубликацииСкидкиЗаОпт, ПараметрыОтбора);
	
	Если РезультатЗапроса <> Неопределено 
		И Не РезультатЗапроса.Пустой() Тогда
		
		Элементы.ВариантыПубликацииСкидокЗаОпт.Заголовок = НСтр("ru = 'Изменить'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантПубликацииСкидки()
	
	ПубликоватьСкидки = Запись.ПубликоватьЦены И Запись.ПубликоватьЦенуДоСкидки;
	
	Если Запись.ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыЦен Тогда
		Элементы.Скидка.ОграничениеТипа = Метаданные.ОпределяемыеТипы.ВидыЦен.Тип;
	ИначеЕсли Запись.ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыСкидок Тогда
		Элементы.Скидка.ОграничениеТипа = Метаданные.ОпределяемыеТипы.ВидыСкидок.Тип;
	Иначе
		ПубликоватьСкидки = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Скидка", "Доступность", ПубликоватьСкидки);
	
	Если Не ПубликоватьСкидки Тогда
		Возврат;
	КонецЕсли;
	
	ПрочитатьЗначениеСкидки();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЗначениеСкидки()
	
	ВариантПубликацииСкидки = Запись.ВариантПубликацииСкидки;
	
	ПараметрыОтбора = ТорговыеПредложенияСлужебный.ПараметрыОтбораСкидок();
	ПараметрыОтбора.ТорговоеПредложение = Запись.ТорговоеПредложение;
	ПараметрыОтбора.Опт = Ложь;
	
	РезультатЗапроса = ТорговыеПредложенияСлужебный.СкидкиТорговыхПредложений(ВариантПубликацииСкидки, ПараметрыОтбора);
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Если ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыЦен Тогда
			Скидка = Выборка.ВидыЦен;
		ИначеЕсли ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыСкидок Тогда
			Скидка = Выборка.ВидСкидки;
		КонецЕсли;
		
	Иначе
		Скидка = ПустоеЗначениеСкидки(ВариантПубликацииСкидки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПустоеЗначениеСкидки(ВариантПубликацииСкидки)
	
	Если ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыЦен Тогда
		Значение = Метаданные.ОпределяемыеТипы.ВидыЦен.Тип.ПривестиЗначение();
	ИначеЕсли ВариантПубликацииСкидки = Перечисления.ВариантыПубликацииСкидок.ВидыСкидок Тогда
		Значение = Метаданные.ОпределяемыеТипы.ВидыСкидок.Тип.ПривестиЗначение();
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаКлиенте
Процедура ВариантыПубликацииСкидкиЗаОптНажатиеПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Если Записать() Тогда
			ТорговыеПредложенияКлиент.ОткрытьФормуСкидкиТорговыхПредложений(
				ЭтотОбъект, Запись.ВариантПубликацииСкидкиЗаОпт, Запись.ТорговоеПредложение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКратностиУпаковокНажатиеПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Записать();
		
		ОткрытьФормуНастройкаКратностиУпаковок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкаКратностиУпаковок()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрайсЛист", Запись.ТорговоеПредложение);
	ТорговыеПредложенияКлиент.ОткрытьФормуНастройкаКратностиУпаковок(ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеНастроекКратностиУпаковок(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.НастройкиКратностиУпаковок.Заголовок = 
		ЗаголовкиСсылкиОткрытияНастройкиКратностиУпаковок(Запись.ТорговоеПредложение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаголовкиСсылкиОткрытияНастройкиКратностиУпаковок(Знач ТорговоеПредложение)
	
	Заголовок = НСтр("ru = 'Изменить'");
	Возврат Заголовок;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВариантыСпискаАдресЭлектроннойПочты(РезультатЗапросаКонтакты)
	
	ВыборкаКонтакты = РезультатЗапросаКонтакты.Выбрать();
	Пока ВыборкаКонтакты.Следующий() Цикл
		Если Не ПустаяСтрока(ВыборкаКонтакты.ЭлектроннаяПочта) Тогда
			Элементы.АдресЭлектроннойПочты.СписокВыбора.Добавить(ВыборкаКонтакты.ЭлектроннаяПочта);
		КонецЕсли;
	КонецЦикла;
	СписокВыбораЗаполнен = Элементы.АдресЭлектроннойПочты.СписокВыбора.Количество();
	Элементы.АдресЭлектроннойПочты.КнопкаВыпадающегоСписка = СписокВыбораЗаполнен;
	
КонецПроцедуры

#КонецОбласти