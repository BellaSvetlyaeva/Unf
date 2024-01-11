#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мПараметры = Новый Структура;
	мПараметры.Вставить("ОтключитьАвтоРасчет",                        Истина);
	мПараметры.Вставить("СчетчикСтраниц",                             Истина);
	мПараметры.Вставить("ЗначенияИзСписка",                           Истина);
	мПараметры.Вставить("Автосохранение",                             Истина);
	мПараметры.Вставить("ПараметрыОтображенияСумм",                   Истина);
	мПараметры.Вставить("Печать",                                     Истина);
	мПараметры.Вставить("Выгрузка",                                   Ложь);
	мПараметры.Вставить("ПроверкаСоотношений",                        Ложь);
	мПараметры.Вставить("УправлениеВариантами",                       Ложь);
	мПараметры.Вставить("РазрешитьВстроеннуюПечать",                  Ложь);
	мПараметры.Вставить("СохранятьРасшифровкуАвтозаполнения",         Ложь);
	мПараметры.Вставить("ИмеетсяРеквизитДеревоВыбранныхСтраниц",      Ложь);
	мПараметры.Вставить("ПечататьСтраницыНаОтдельныхЛистах",          Ложь);
	мПараметры.Вставить("ПечататьСтраницыНаОтдельныхЛистахЗаголовок", "");
	мПараметры.Вставить("РучнойВводАдреса",                           Ложь);
	мПараметры.Вставить("ИмяОтчета",                                  "");
	
	Для Каждого ЭлементСтруктуры Из Параметры.мПараметры Цикл
		мПараметры.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
	КонецЦикла;
	
	// ПроцессыОбработкиДокументов
	//
	Если ОбщегоНазначения.ПодсистемаСуществует("ПроцессыОбработкиДокументов") Тогда
		
		МодульПроцессыОбработкиДокументов = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументов");
		
		МодульПроцессыОбработкиДокументов.ПриСозданииНаСервереФормыНастроекРегламентированногоОтчета(ЭтотОбъект, мПараметры);
		
	КонецЕсли;
	//
	// ПроцессыОбработкиДокументов
	
	ПеречислениеПорядкиОкругленияОтчетностиОкр1       = Перечисления.ПорядкиОкругленияОтчетности.Окр1;
	ПеречислениеПорядкиОкругленияОтчетностиОкр1000    = Перечисления.ПорядкиОкругленияОтчетности.Окр1000;
	ПеречислениеПорядкиОкругленияОтчетностиОкр1000000 = Перечисления.ПорядкиОкругленияОтчетности.Окр1000000;
	
	Элементы.ПредставлениеЕдиницыИзмерения.СписокВыбора.Добавить("в рублях");
	Элементы.ПредставлениеЕдиницыИзмерения.СписокВыбора.Добавить("в тысячах рублей");
	Элементы.ПредставлениеЕдиницыИзмерения.СписокВыбора.Добавить("в миллионах рублей");
		
	Элементы.Дерево.ПодчиненныеЭлементы.ДеревоВыгрузитьСтраницу.Видимость = мПараметры.Выгрузка;
	Элементы.Дерево.ПодчиненныеЭлементы.ДеревоВыводНаПечать.Видимость = мПараметры.Печать;
		
	Если мПараметры.ПараметрыОтображенияСумм И НЕ Параметры.ЕдиницаИзмерения = Неопределено Тогда
		Элементы.ЕдиницаИзмеренияИТочность.Видимость = Истина;
		ЕдиницаИзмерения = Параметры.ЕдиницаИзмерения;
		ТочностьЕдиницыИзмерения = Параметры.ТочностьЕдиницыИзмерения;
		ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000);
	Иначе
		Элементы.ЕдиницаИзмеренияИТочность.Видимость = Ложь;
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1;
		ТочностьЕдиницыИзмерения = 0;
	КонецЕсли;
		
	Если ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1 Тогда
		ПредставлениеЕдиницыИзмерения = "в рублях";
	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000 Тогда
		ПредставлениеЕдиницыИзмерения = "в тысячах рублей";
	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000000 Тогда
		ПредставлениеЕдиницыИзмерения = "в миллионах рублей";
	КонецЕсли;
			
	Если мПараметры.РазрешитьВстроеннуюПечать Тогда
		Элементы.РазрешитьВстроеннуюПечать.Видимость = Истина;
		РазрешитьВстроеннуюПечать = Параметры.мПечатьБезШтрихкодаРазрешена;
	КонецЕсли;
	
	Если мПараметры.СчетчикСтраниц Тогда
		Элементы.ОтключитьСчетчикСтраниц.Видимость = Истина;
		ОтключитьСчетчикСтраниц = Параметры.мСчетчикСтраниц;
	КонецЕсли;
	
	Если мПараметры.ЗначенияИзСписка Тогда
		Элементы.ОтклВыборЗначений.Видимость = Истина;
		ОтклВыборЗначений = Параметры.мАвтоВыборКодов;
	КонецЕсли;
	
	Если мПараметры.Автосохранение Тогда
		Элементы.Автосохранение.Видимость = Истина;
		ИнтервалАвтосохранения = Параметры.мИнтервалАвтосохранения;
		Если ИнтервалАвтосохранения = 0 Тогда
			ФлажокАвтосохранение = Ложь;
			Элементы.ИнтервалАвтосохранения.Доступность = Ложь;
		КонецЕсли;
		ФлажокАвтосохранение = (ИнтервалАвтосохранения <> 0);
		Если ИнтервалАвтосохранения = 0 Тогда
			ИнтервалАвтосохранения = 10;
		КонецЕсли;
	КонецЕсли;
	
	Если мПараметры.ПроверкаСоотношений Тогда
		Элементы.ПроверятьСоотношенияПриПечатиИВыгрузки.Видимость = Истина;
		ПроверятьСоотношенияПриПечатиИВыгрузки = Параметры.мПроверятьСоотношенияПриПечатиИВыгрузки;
	КонецЕсли;
	
	Если мПараметры.УправлениеВариантами Тогда
		Элементы.ОтключитьАвтоматическоеУправлениеВариантами.Видимость = Истина;
		ОтключитьАвтоматическоеУправлениеВариантами = Параметры.мОтключитьАвтоматическоеУправлениеВариантами;
	КонецЕсли;
	
	Если мПараметры.ОтключитьАвтоРасчет
	   И НЕ Константы.ЗапрещатьРедактированиеФормРеглОтчетности.Получить() Тогда	
		Элементы.ОтключитьАвтоматическийРасчет.Видимость = Истина;
		ОтключитьАвтоматическийРасчет = Параметры.ФлажокОтклАвтоРасчет;
	КонецЕсли;
	
	Если мПараметры.ПечататьСтраницыНаОтдельныхЛистах Тогда
		Элементы.ПечататьСтраницыНаОтдельныхЛистах.Видимость = Истина;
		ПечататьСтраницыНаОтдельныхЛистах = Параметры.ПечататьСтраницыНаОтдельныхЛистах;
		Если ЗначениеЗаполнено(Параметры.ПечататьСтраницыНаОтдельныхЛистахЗаголовок)
			И ТипЗнч(Параметры.ПечататьСтраницыНаОтдельныхЛистахЗаголовок) = Тип("Строка") Тогда
			Элементы.ПечататьСтраницыНаОтдельныхЛистах.Заголовок = Параметры.ПечататьСтраницыНаОтдельныхЛистахЗаголовок;
		КонецЕсли;
	КонецЕсли;
	
	Если мПараметры.РучнойВводАдреса Тогда
		Элементы.РучнойВводАдреса.Видимость = Истина;
		РучнойВводАдреса = Параметры.ФлажокРучнойВводАдреса;
	КонецЕсли;
	
	Если мПараметры.СохранятьРасшифровкуАвтозаполнения Тогда
		Элементы.СохранятьРасшифровкуАвтозаполнения.Видимость = Истина;
		СохранятьРасшифровкуАвтозаполнения = Параметры.СохранятьРасшифровкуАвтозаполнения;
	КонецЕсли;

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ФлажокАвтосохранение", ФлажокАвтосохранение);
	СтруктураПараметров.Вставить("РазрешитьВстроеннуюПечать", РазрешитьВстроеннуюПечать);
	СтруктураПараметров.Вставить("ОтключитьСчетчикСтраниц", ОтключитьСчетчикСтраниц);
		
	УправлениеЭУ(СтруктураПараметров);
		
	ОтключитьСчетчикСтраниц = СтруктураПараметров.ОтключитьСчетчикСтраниц;
	
	Если Параметры.мПараметры.Свойство("ИмяОтчета")
		И (СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетЗаявлениеОВвозеТоваров") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетПодтверждениеВидаДеятельности") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФорма7Травматизм") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФормаМПм") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчет4ФСС") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета,
		"РегламентированныйОтчетРеестрАкцизыВычетыДенатурированныйЭтиловыйСпирт") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета,
		"РегламентированныйОтчетРеестрАкцизыВычетыВиноград") > 0
		ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета,
		"РегламентированныйОтчетРеестрАкцизыВычетыВиноматериалыВиногрИФруктСусло") > 0) Тогда
		
		мПараметры.Вставить("ИмяОтчета", Параметры.мПараметры.ИмяОтчета);
		
		Если СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетЗаявлениеОВвозеТоваров") > 0 Тогда
			
			ЭтаФорма.УсловноеОформление.Элементы.Получить(0).Отбор.Элементы[0].ПравоеЗначение.Добавить("Раздел1");
			
		ИначеЕсли СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетПодтверждениеВидаДеятельности") > 0 Тогда
			
			ЭтаФорма.УсловноеОформление.Элементы.Получить(0).Отбор.Элементы[0].ПравоеЗначение.Добавить("Приложение1");
			
		ИначеЕсли СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФорма7Травматизм") > 0 Тогда
			
			ЭтаФорма.УсловноеОформление.Элементы.Получить(0).Отбор.Элементы[0].ПравоеЗначение.Добавить("Форма7Травматизм");
			
		ИначеЕсли СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФормаМПм") > 0 Тогда
			
			ЭтаФорма.УсловноеОформление.Элементы.Получить(0).Отбор.Элементы[0].ПравоеЗначение.Добавить("МПм");
			
		ИначеЕсли СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета, "РегламентированныйОтчет4ФСС") > 0
			ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета,
			"РегламентированныйОтчетРеестрАкцизыВычетыДенатурированныйЭтиловыйСпирт") > 0
			ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета,
			"РегламентированныйОтчетРеестрАкцизыВычетыВиноград") > 0
			ИЛИ СтрЧислоВхождений(Параметры.мПараметры.ИмяОтчета,
			"РегламентированныйОтчетРеестрАкцизыВычетыВиноматериалыВиногрИФруктСусло") > 0 Тогда
			
			ЭтаФорма.УсловноеОформление.Элементы.Получить(0).Отбор.Элементы[0].ПравоеЗначение.Удалить(1);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если мПараметры.ИмеетсяРеквизитДеревоВыбранныхСтраниц Тогда
		КопироватьДанныеФормы(Дерево, ВладелецФормы.мДеревоВыбранныхСтраниц);
	КонецЕсли;
	
	Элементы.Дерево.ТолькоПросмотр = (Дерево.ПолучитьЭлементы().Количество() = 1);
	Элементы.УстановитьСнятьФлажки.Доступность = (Дерево.ПолучитьЭлементы().Количество() > 1);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеЕдиницыИзмеренияПриИзменении(Элемент)
		
	Если ПредставлениеЕдиницыИзмерения = "в рублях" Тогда
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1;
	ИначеЕсли ПредставлениеЕдиницыИзмерения = "в тысячах рублей" Тогда
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000;
	ИначеЕсли ПредставлениеЕдиницыИзмерения = "в миллионах рублей" Тогда
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000000;
	КонецЕсли;
	
	ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000);
	
	ТочностьЕдиницыИзмерения = 0;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТочностьЕдиницыИзмеренияПриИзменении(Элемент)
	
	ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВстроеннуюПечатьПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ФлажокАвтосохранение", ФлажокАвтосохранение);
	СтруктураПараметров.Вставить("РазрешитьВстроеннуюПечать", РазрешитьВстроеннуюПечать);
	СтруктураПараметров.Вставить("ОтключитьСчетчикСтраниц", ОтключитьСчетчикСтраниц);
		
	УправлениеЭУ(СтруктураПараметров);
	
	ОтключитьСчетчикСтраниц = СтруктураПараметров.ОтключитьСчетчикСтраниц;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьСчетчикСтраницПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьАвтоматическийРасчетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклВыборЗначенийПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранятьРасшифровкуАвтозаполненияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажокАвтосохранениеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ФлажокАвтосохранение", ФлажокАвтосохранение);
	СтруктураПараметров.Вставить("РазрешитьВстроеннуюПечать", РазрешитьВстроеннуюПечать);
	СтруктураПараметров.Вставить("ОтключитьСчетчикСтраниц", ОтключитьСчетчикСтраниц);
		
	УправлениеЭУ(СтруктураПараметров);
	
	ОтключитьСчетчикСтраниц = СтруктураПараметров.ОтключитьСчетчикСтраниц;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалАвтосохраненияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьСоотношенияПриПечатиИВыгрузкиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьСтраницыНаОтдельныхЛистах(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВводАдресаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)
	
	ТекЭлемент  = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "Дерево", "");
	ТекЗначение = Элемент.ТекущиеДанные[ТекЭлемент];
	
	Если ТекЭлемент = "ПоказатьСтраницу" Тогда
		Если ТекЗначение = 2 Тогда
			Отказ = Истина;
		ИначеЕсли ТекЗначение = 0 Тогда
			Если Элемент.ТекущиеДанные.ПолучитьРодителя() <> Неопределено Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТекЭлемент = "ВыводНаПечать"
		И Элемент.ТекущиеДанные.ИмяСтраницы = "ДопФайлы" И СтрНайти(ЭтаФорма.ВладелецФормы.ИмяФормы,
		"РегламентированныйОтчетОперацииСДенежнымиСредствамиНФО") <> Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ПриИзмененииФлажка(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииФлажка(Элемент)
	
	ТекЭлемент = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "Дерево", "");
	
	НоваяПометка = Элемент.ТекущиеДанные[ТекЭлемент];

	Если ТекЭлемент = "ПоказатьСтраницу" Тогда
		Если НоваяПометка = 1 Тогда

			НоваяПометка = 2;

		ИначеЕсли НоваяПометка = 0 Тогда
			Элемент.ТекущиеДанные.ВыводНаПечать = НоваяПометка;

			Для Каждого Строка Из Элемент.ТекущиеДанные.ПолучитьЭлементы() Цикл
				Строка.ВыводНаПечать = НоваяПометка;
			КонецЦикла;

		КонецЕсли;

	ИначеЕсли ТекЭлемент = "ВыводНаПечать" Тогда

		ВерхняяГруппировка = Элемент.ТекущиеДанные.ПолучитьРодителя();
		Если ВерхняяГруппировка <> Неопределено Тогда
			НеВсеОтмечены = 0;

			Для каждого СтрокаУровня Из ВерхняяГруппировка.ПолучитьЭлементы() Цикл

				Если СтрокаУровня.ВыводНаПечать <> НоваяПометка Тогда

					НеВсеОтмечены = 1;

					Прервать;
				КонецЕсли; 

			КонецЦикла; 

			Если НеВсеОтмечены = 1 Тогда
				ВерхняяГруппировка.ВыводНаПечать = 2;
			Иначе
				ВерхняяГруппировка.ВыводНаПечать = НоваяПометка;
			КонецЕсли;

		КонецЕсли;
		
		Если СтрНайти(ЭтаФорма.ВладелецФормы.ИмяФормы, "РегламентированныйОтчет6НДФЛ") > 0 Тогда
			УстановитьПометкуСтрокДерева(НоваяПометка, Элементы.Дерево.ТекущийЭлемент.Имя);
		КонецЕсли;

	ИначеЕсли ТекЭлемент = "ВыгрузитьСтраницу" Тогда
		
		Если НоваяПометка = 0 Тогда
			Элемент.ТекущиеДанные[ТекЭлемент] = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкуСтрокДерева(0, Элементы.Дерево.ТекущийЭлемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьДанные();
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
			
	Если Элементы.Дерево.ТекущийЭлемент.Имя = "ДеревоВыгрузитьСтраницу" Тогда
		
		МассивНайденныхСтрок = Новый Массив;
		
		РегламентированнаяОтчетностьКлиент.НайтиСтрокиВДанныхФормыДерево(Дерево.ПолучитьЭлементы(), "ВыгрузитьСтраницу", 1, МассивНайденныхСтрок);
		
		Если МассивНайденныхСтрок.Количество() = Дерево.ПолучитьЭлементы().Количество() Тогда
			УстановитьПометкуСтрокДерева(2, Элементы.Дерево.ТекущийЭлемент.Имя);
		Иначе
			УстановитьПометкуСтрокДерева(1, Элементы.Дерево.ТекущийЭлемент.Имя);
		КонецЕсли;
		
	Иначе
		
		УстановитьПометкуСтрокДерева(1, Элементы.Дерево.ТекущийЭлемент.Имя);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеЭУ(СтруктураПараметров)
	
	Если СтруктураПараметров.Элементы.Найти("ОтключитьСчетчикСтраниц") <> Неопределено
	   И СтруктураПараметров.Элементы.Найти("РазрешитьВстроеннуюПечать") <> Неопределено
	   И СтруктураПараметров.Элементы.РазрешитьВстроеннуюПечать.Видимость Тогда
	   
		СтруктураПараметров.Элементы.ОтключитьСчетчикСтраниц.Доступность = СтруктураПараметров.РазрешитьВстроеннуюПечать;
		
		Если НЕ СтруктураПараметров.Элементы.ОтключитьСчетчикСтраниц.Доступность Тогда
			СтруктураПараметров.ОтключитьСчетчикСтраниц = Ложь;
		КонецЕсли;
		
		СтруктураПараметров.Элементы.Дерево.ПодчиненныеЭлементы.ДеревоВыводНаПечать.Видимость
			= СтруктураПараметров.РазрешитьВстроеннуюПечать;
		
	КонецЕсли;
	
	СтруктураПараметров.Элементы.ИнтервалАвтосохранения.Доступность = СтруктураПараметров.ФлажокАвтосохранение;
	СтруктураПараметров.Элементы.НадписьМинут.Доступность = СтруктураПараметров.ФлажокАвтосохранение;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуСтрокДерева(Пометка, Знач ТекКолонка)
	
	ТекКолонка = СтрЗаменить(ТекКолонка, "Дерево", "");

	Если ТекКолонка = "ПоказатьСтраницу" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.ПолучитьЭлементы() Цикл
			
			Если СтрокаУровня1.ИмяСтраницы = "Титульный"
				ИЛИ (СтрокаУровня1.ИмяСтраницы = "Таблица1"
				И СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчет4ФСС") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыДенатурированныйЭтиловыйСпирт") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыВиноград") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыВиноматериалыВиногрИФруктСусло") = 0)
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетЗаявлениеОВвозеТоваров") > 0
				И СтрокаУровня1.ИмяСтраницы = "Раздел1")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетПодтверждениеВидаДеятельности") > 0
				И СтрокаУровня1.ИмяСтраницы = "Приложение1")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФорма7Травматизм") > 0
				И СтрокаУровня1.ИмяСтраницы = "Форма7Травматизм")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФормаМПм") > 0
				И СтрокаУровня1.ИмяСтраницы = "МПм") Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			СтрокаУровня1[ТекКолонка] = Пометка;

			Если Пометка = 1 Тогда
				Если СтрокаУровня1.ПолучитьЭлементы().Количество() > 0 Тогда
					НовПометка = 2;

					Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл

						СтрокаУровня2[ТекКолонка] = НовПометка;

						Если СтрокаУровня2.ПолучитьЭлементы().Количество() = 0 Тогда 
							Продолжить;
						КонецЕсли;

						Для Каждого СтрокаУровня3 Из СтрокаУровня2.ПолучитьЭлементы() Цикл
							СтрокаУровня3[ТекКолонка] = НовПометка;
						КонецЦикла;

					КонецЦикла;

					Продолжить;

				КонецЕсли; 

			ИначеЕсли Пометка = 0 Тогда
				СтрокаУровня1.ВыводНаПечать = Пометка;

				Для Каждого Строка Из СтрокаУровня1.ПолучитьЭлементы() Цикл
					Строка.ВыводНаПечать = Пометка;
				КонецЦикла;

			КонецЕсли;

			Если СтрокаУровня1.ПолучитьЭлементы().Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.ПолучитьЭлементы().Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.ПолучитьЭлементы() Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	ИначеЕсли  ТекКолонка = "ВыгрузитьСтраницу" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.ПолучитьЭлементы() Цикл
			
			Если СтрокаУровня1.ИмяСтраницы = "Титульный"
				ИЛИ (СтрокаУровня1.ИмяСтраницы = "Таблица1"
				И СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчет4ФСС") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыДенатурированныйЭтиловыйСпирт") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыВиноград") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыВиноматериалыВиногрИФруктСусло") = 0)
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетЗаявлениеОВвозеТоваров") > 0
				И СтрокаУровня1.ИмяСтраницы = "Раздел1")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетПодтверждениеВидаДеятельности") > 0
				И СтрокаУровня1.ИмяСтраницы = "Приложение1")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФорма7Травматизм") > 0
				И СтрокаУровня1.ИмяСтраницы = "Форма7Травматизм")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФормаМПм") > 0
				И СтрокаУровня1.ИмяСтраницы = "МПм") Тогда
				
				Продолжить;
				
			КонецЕсли;

			СтрокаУровня1[ТекКолонка] = Пометка;

		КонецЦикла;

	ИначеЕсли ТекКолонка = "ВыводНаПечать" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.ПолучитьЭлементы() Цикл
			
			Если СтрокаУровня1.ИмяСтраницы = "Титульный"
				ИЛИ (СтрокаУровня1.ИмяСтраницы = "Таблица1"
				И СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчет4ФСС") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыДенатурированныйЭтиловыйСпирт") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыВиноград") = 0
				И СтрЧислоВхождений(мПараметры.ИмяОтчета,
				"РегламентированныйОтчетРеестрАкцизыВычетыВиноматериалыВиногрИФруктСусло") = 0)
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетЗаявлениеОВвозеТоваров") > 0
				И СтрокаУровня1.ИмяСтраницы = "Раздел1")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетПодтверждениеВидаДеятельности") > 0
				И СтрокаУровня1.ИмяСтраницы = "Приложение1")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФорма7Травматизм") > 0
				И СтрокаУровня1.ИмяСтраницы = "Форма7Травматизм")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетСтатистикаФормаМПм") > 0
				И СтрокаУровня1.ИмяСтраницы = "МПм")
				ИЛИ (СтрЧислоВхождений(мПараметры.ИмяОтчета, "РегламентированныйОтчетОперацииСДенежнымиСредствамиНФО") > 0
				И СтрокаУровня1.ИмяСтраницы = "ДопФайлы") Тогда
				
				Продолжить;
				
			КонецЕсли;

			СтрокаУровня1[ТекКолонка] = Пометка;

			Если СтрокаУровня1.ПолучитьЭлементы().Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.ПолучитьЭлементы().Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.ПолучитьЭлементы() Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	Иначе
        					   
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для установки или снятия меток по требуемой колонке%1предварительно активизируйте колонку.'"), Символы.ПС));

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные()
	
	Если мПараметры.РазрешитьВстроеннуюПечать Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мПечатьБезШтрихкодаРазрешена = РазрешитьВстроеннуюПечать;
	КонецЕсли;
	
	Если мПараметры.СчетчикСтраниц Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мСчетчикСтраниц = ОтключитьСчетчикСтраниц;
	КонецЕсли;
	
	Если мПараметры.ЗначенияИзСписка Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мАвтоВыборКодов = ОтклВыборЗначений;
	КонецЕсли;
	
	Если мПараметры.Автосохранение Тогда
		ИнтервалАвтосохранения = ?(ФлажокАвтосохранение, ИнтервалАвтосохранения, 0);
		ВладелецФормы.СтруктураРеквизитовФормы.мИнтервалАвтосохранения = ИнтервалАвтосохранения;
	КонецЕсли;
	
	Если мПараметры.ПроверкаСоотношений Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мПроверятьСоотношенияПриПечатиИВыгрузки = ПроверятьСоотношенияПриПечатиИВыгрузки;
	КонецЕсли;
	
	Если мПараметры.УправлениеВариантами Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мОтключитьАвтоматическоеУправлениеВариантами = ОтключитьАвтоматическоеУправлениеВариантами;
	КонецЕсли;
	
	Если мПараметры.ОтключитьАвтоРасчет Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет = ОтключитьАвтоматическийРасчет;
	КонецЕсли;
	
	Если мПараметры.ПечататьСтраницыНаОтдельныхЛистах Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ФлПечататьСтраницыНаОтдельныхЛистах = ПечататьСтраницыНаОтдельныхЛистах;
	КонецЕсли;
	
	Если мПараметры.РучнойВводАдреса Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ФлажокРучнойВводАдреса = РучнойВводАдреса;
	КонецЕсли;
	
	Если мПараметры.СохранятьРасшифровкуАвтозаполнения Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мСохранятьРасшифровку = СохранятьРасшифровкуАвтозаполнения;
	КонецЕсли;
	
	Если мПараметры.ПараметрыОтображенияСумм И Элементы.ЕдиницаИзмеренияИТочность.Видимость Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ЕдиницаИзмерения = ЕдиницаИзмерения;
		ВладелецФормы.СтруктураРеквизитовФормы.ТочностьЕдиницыИзмерения = ТочностьЕдиницыИзмерения;
	КонецЕсли;
	
	Если мПараметры.ИмеетсяРеквизитДеревоВыбранныхСтраниц Тогда
		КопироватьДанныеФормы(Дерево, ВладелецФормы.мДеревоВыбранныхСтраниц);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000)
	
	Если ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1 Тогда

		Если ТочностьЕдиницыИзмерения > 2 Тогда
			ТочностьЕдиницыИзмерения = 2;
		КонецЕсли;

	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000 Тогда

		Если ТочностьЕдиницыИзмерения > 3 Тогда
			ТочностьЕдиницыИзмерения = 3;
		КонецЕсли;

	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000000 Тогда

		Если ТочностьЕдиницыИзмерения > 6 Тогда
			ТочностьЕдиницыИзмерения = 6;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
