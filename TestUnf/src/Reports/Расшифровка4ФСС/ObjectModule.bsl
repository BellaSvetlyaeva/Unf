#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Если СхемаКомпоновкиДанных = Неопределено Тогда
		СтандартнаяОбработка = Ложь
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура СформироватьОтчетРасшифровку(Параметры, ДокументРезультат) Экспорт
	
	ДатаНачалаНП = '00010101';
	Если Не Параметры.Свойство("мДатаНачалаПериодаОтчета", ДатаНачалаНП) Тогда
		Параметры.Свойство("ДатаНачалаПериодаОтчета", ДатаНачалаНП)
	КонецЕсли;
	ДатаКонцаНП = '00010101';
	Если Не Параметры.Свойство("мДатаКонцаПериодаОтчета", ДатаКонцаНП) Тогда
		Параметры.Свойство("ДатаКонцаПериодаОтчета", ДатаКонцаНП)
	КонецЕсли;
	ДатаКонцаНП = КонецДня(ДатаКонцаНП);
	
	Если Не УчетСтраховыхВзносов.ОрганизацияОтчитываетсяПоВзносамСамостоятельно(Параметры.Организация, ДатаНачалаНП) Тогда
		Возврат
	КонецЕсли;
	
	ИмяПоля = Лев(Параметры.ИДИменПоказателей[0], 13);
	ИсточникРасшифровки = ОбщегоНазначения.ОбщийМодуль(Параметры.ИсточникРасшифровки);
	
	// Получаем данные расшифровки.
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить(Параметры.ИмяСКД); // Имя внешнего набора данных совпадает с ключем варианта.
	
	Организация = УчетСтраховыхВзносов.ОрганизацииДляКонсолидацииОтчетовПоВзносам(Параметры.Организация, ДатаНачалаНП);
	ИсточникРасшифровки.РасчетПоказателей4ФСС(Параметры.ИмяРасчета, ДатаНачалаНП, ДатаКонцаНП, Организация, ВнешниеНаборыДанных, Истина);
	
	// Удалим строки с нулевым значением показателя.
	Данные = ВнешниеНаборыДанных[Параметры.ИмяСКД];
	ВсегоСтрок = Данные.Количество();
	Для Сч = 1 По ВсегоСтрок Цикл
		СтрокаДанных = Данные[ВсегоСтрок - Сч];
		Если Не ЗначениеЗаполнено(СтрокаДанных[ИмяПоля]) Тогда
			Данные.Удалить(СтрокаДанных)
		КонецЕсли;
	КонецЦикла;

	Если Параметры.Свойство("ЗначениеТекущегоПоказателя") Тогда
		ЗарплатаКадры.ВывестиПредупреждениеОРасхожденииПоказателяСРасшифровкой(Параметры.ЗначениеТекущегоПоказателя, Данные.Итог(ИмяПоля), ДокументРезультат);
	КонецЕсли;
	
	// Настраиваем СКД и выводим отчет.
	СхемаКомпоновкиДанных = ПолучитьМакет(Параметры.ИмяСКД);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[Параметры.ИмяСКД].Настройки);
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	
	ОтчетыСервер.ДобавитьВыбранноеПоле(НастройкиКомпоновки, ИмяПоля, ?(Параметры.Свойство("ЗаголовокПоля") И ЗначениеЗаполнено(Параметры.ЗаголовокПоля), Параметры.ЗаголовокПоля, ""));
    Если Параметры.Свойство("Раздел31ФИО") И ЗначениеЗаполнено(Параметры.Раздел31ФИО) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиКомпоновки.Отбор, "ФИО", Параметры.Раздел31ФИО, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	КонецЕсли;
    Если Параметры.Свойство("Таблица1_1_ОКВЭД") И ЗначениеЗаполнено(Параметры.Таблица1_1_ОКВЭД) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиКомпоновки.Отбор, "ОКВЭД", Параметры.Таблица1_1_ОКВЭД, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	КонецЕсли;
	
	МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли