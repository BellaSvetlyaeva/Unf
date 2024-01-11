#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПараметрыПодключенияЕГАИС.Видимость = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.НастройкиОбменаЕГАИС);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	НастроитьДополнительныеКонстанты();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСверткуРегистраСоответствиеНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетСведенийПоАлкогольнойПродукцииЕГАИСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаРегистрацииРозничныхПродажВЕГАИСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаРегистрацииРозничныхПродажВЕГАИСВСельскойМестностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияЛитрИСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьОтправкуПолучениеЕГАИС(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОтправкиПолученияЕГАИС", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОтправкиПолученияЕГАИС);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСверткуРегистраСоответствияНоменклатурыЕГАИС(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеСверткиРегистраСоответствияЕГАИС", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеСверткиРегистраСоответствиеНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПодключенияКЕГАИС(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьДополнительныеКонстанты()
	
	ЭлементыПоТипам = Новый Соответствие();
	ЭлементыПоТипам.Вставить(
		Тип("Дата"),
		Новый Структура(
			"Родитель, ВидПоля, ПоложениеЗаголовка",
			Элементы.ГруппаДатыПравая,
			ВидПоляФормы.ПолеВвода,
			ПоложениеЗаголовкаЭлементаФормы.Верх));
	ЭлементыПоТипам.Вставить(
		Тип("Булево"),
		Новый Структура(
		"Родитель, ВидПоля, ПоложениеЗаголовка",
		Элементы.ГруппаНастройкиПраваяПанель,
		ВидПоляФормы.ПолеФлажка,
		ПоложениеЗаголовкаЭлементаФормы.Право));
	
	Для Каждого СтрокаТаблицы Из ДополнительныеКонстанты Цикл
		
		ИмяКонстанты        = СтрокаТаблицы.Имя;
		Пояснение           = СтрокаТаблицы.Описание;
		МетаданныеКонстанты = Метаданные.Константы[ИмяКонстанты];
		
		Если Не ПравоДоступа("Изменение", МетаданныеКонстанты) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Пояснение) Тогда
			Пояснение = МетаданныеКонстанты.Пояснение;
		КонецЕсли;
		
		ПараметрыРазмещения = Неопределено;
		Для Каждого СтрокаТип Из МетаданныеКонстанты.Тип.Типы() Цикл
			ПараметрыРазмещения = ЭлементыПоТипам.Получить(СтрокаТип);
			Прервать;
		КонецЦикла;
		
		Если ПараметрыРазмещения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяКонстанты, МетаданныеКонстанты.Тип,, СтрокаТаблицы.Заголовок));
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		ЭтотОбъект[ИмяКонстанты] = Константы[ИмяКонстанты].Получить();
		
		Если ПараметрыРазмещения.Родитель = Элементы.ГруппаДатыПравая Тогда
			ПараметрыРазмещения.Родитель = Элементы.ГруппаДатыЛевая;
		ИначеЕсли ПараметрыРазмещения.Родитель = Элементы.ГруппаДатыЛевая Тогда
			ПараметрыРазмещения.Родитель = Элементы.ГруппаДатыПравая
		ИначеЕсли ПараметрыРазмещения.Родитель = Элементы.ГруппаНастройкиЛеваяПанель Тогда
			ПараметрыРазмещения.Родитель = Элементы.ГруппаНастройкиПраваяПанель
		ИначеЕсли ПараметрыРазмещения.Родитель = Элементы.ГруппаНастройкиПраваяПанель Тогда
			ПараметрыРазмещения.Родитель = Элементы.ГруппаНастройкиЛеваяПанель
		КонецЕсли;
		
		ЭлементФормы                      = Элементы.Добавить(ИмяКонстанты, Тип("ПолеФормы"), ПараметрыРазмещения.Родитель);
		ЭлементФормы.Вид                  = ПараметрыРазмещения.ВидПоля;
		ЭлементФормы.ПоложениеЗаголовка   = ПараметрыРазмещения.ПоложениеЗаголовка;
		ЭлементФормы.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		ЭлементФормы.Подсказка            = Пояснение;
		ЭлементФормы.ПутьКДанным          = ИмяКонстанты;
		
		ЭлементФормы.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииРеквизита");
		МаксимальнаяШирина = Элементы.ДатаНачалаРегистрацииРозничныхПродажВЕГАИС.РасширеннаяПодсказка.МаксимальнаяШирина;
		
		ЭлементФормы.РасширеннаяПодсказка.Заголовок              = Пояснение;
		ЭлементФормы.РасширеннаяПодсказка.АвтоМаксимальнаяШирина = Ложь;
		ЭлементФормы.РасширеннаяПодсказка.МаксимальнаяШирина     = МаксимальнаяШирина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеОтправкиПолученияЕГАИС(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОтправкиПолученияЕГАИС = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания("ОбработкаОтветовЕГАИС", РасписаниеОтправкиПолученияЕГАИС);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеСверткиРегистраСоответствияЕГАИС(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеСверткиРегистраСоответствиеНоменклатуры = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания(
		"СверткаРегистраСоответствиеНоменклатурыЕГАИС",
		РасписаниеСверткиРегистраСоответствиеНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Истина И Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// ОбработкаОтветовЕГАИС
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОбработкаОтветовЕГАИС");
	ЗаданиеОтправкаПолучениеДанныхЕГАИС = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	РасписаниеОтправкиПолученияЕГАИС = ЗаданиеОтправкаПолучениеДанныхЕГАИС.Расписание;
	
	Элементы.ОбработкаОтветовЕГАИС.Доступность = ЗаданиеОтправкаПолучениеДанныхЕГАИС.Использование;
	УстановитьТекстНадписиРегламентнойНастройки(
		ЗаданиеОтправкаПолучениеДанныхЕГАИС,
		Элементы.ОбработкаОтветовЕГАИС);
	
	// СверткаРегистраСоответствиеНоменклатурыЕГАИС
	
	Если ИнтеграцияИС.СерииИспользуются() Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Метаданные", "СверткаРегистраСоответствиеНоменклатурыЕГАИС");
		ЗаданиеСверткиРегистраСоответствиеНоменклатурыЕГАИС = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
		
		РасписаниеСверткиРегистраСоответствиеНоменклатуры = ЗаданиеСверткиРегистраСоответствиеНоменклатурыЕГАИС.Расписание;
		
		Элементы.СверткаРегистраСоответствиеНоменклатурыЕГАИС.Доступность = ЗаданиеСверткиРегистраСоответствиеНоменклатурыЕГАИС.Использование;
		УстановитьТекстНадписиРегламентнойНастройки(
			ЗаданиеСверткиРегистраСоответствиеНоменклатурыЕГАИС,
			Элементы.СверткаРегистраСоответствиеНоменклатурыЕГАИС);
		
		Элементы.РегламентноеЗаданиеСверткаРегистраСоответствия.Видимость = Истина;
		
	Иначе
		
		Элементы.РегламентноеЗаданиеСверткаРегистраСоответствия.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания, РасписаниеАктивно;
	
	ИнтеграцияИС.ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	СтрокаДополнительнаяКонстанта = ДополнительныеКонстанты.НайтиСтроки(Новый Структура("Имя", РеквизитПутьКДанным));
	
	Если СтрокаДополнительнаяКонстанта.Количество() Тогда
		
		ИмяДополнительнойКонстанты = СтрокаДополнительнаяКонстанта.Получить(0).Имя;
		КонстантаЗначение          = ЭтотОбъект[ИмяДополнительнойКонстанты];
		
		Константы[ИмяДополнительнойКонстанты].Установить(КонстантаЗначение);
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, ИмяДополнительнойКонстанты, КонстантаЗначение);
		
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, КонстантаИмя, КонстантаЗначение);
		
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС" Тогда
		ИзменитьИспользованиеЗадания(
			"ОбработкаОтветовЕГАИС",
			НаборКонстант.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС);
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьАвтоматическуюСверткуРегистраСоответствиеНоменклатурыЕГАИС" Тогда
		ИзменитьИспользованиеЗадания(
			"СверткаРегистраСоответствиеНоменклатурыЕГАИС",
			НаборКонстант.ИспользоватьАвтоматическуюСверткуРегистраСоответствиеНоменклатурыЕГАИС);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиСведенияДляДекларацийПоАлкогольнойПродукции" 
		Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиСведенияДляДекларацийПоАлкогольнойПродукции;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетСведенийПоАлкогольнойПродукцииЕГАИС, ЗначениеКонстанты);
		
	КонецЕсли;
	
	ВестиУчетСведенийЕГАИС = ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции");
	
	Элементы.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС.Доступность   = ВестиУчетСведенийЕГАИС;
	Элементы.ИспользоватьСверткуРегистраСоответствиеНоменклатурыЕГАИС.Доступность = ВестиУчетСведенийЕГАИС;
	Элементы.ОбработкаОтветовЕГАИС.Доступность                                    = ВестиУчетСведенийЕГАИС;
	Элементы.СверткаРегистраСоответствиеНоменклатурыЕГАИС.Доступность             = ВестиУчетСведенийЕГАИС;
	Элементы.ПараметрыПодключенияЕГАИС.Доступность                                = ВестиУчетСведенийЕГАИС;
	Элементы.ГруппаДаты.Доступность                                               = ВестиУчетСведенийЕГАИС;
	Элементы.УдалятьКвитанцииУТМДляАСИиУ.Доступность                              = ВестиУчетСведенийЕГАИС;
	Элементы.ЕдиницаИзмеренияЛитрИС.Доступность                                   = ВестиУчетСведенийЕГАИС;
	
	Для Каждого СтрокаТаблицы Из ДополнительныеКонстанты Цикл
		Элементы[СтрокаТаблицы.Имя].Доступность = ВестиУчетСведенийЕГАИС;
	КонецЦикла;
	
	// В модели сервиса расписание настраивается в неразделенном режиме из панели управления очередью регламентных заданий.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НастройкиРегламентныхЗаданий.Видимость = Ложь;
	Иначе
		УстановитьНастройкиЗаданий();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

