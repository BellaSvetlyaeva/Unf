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
	
	Если Не УчетСтраховыхВзносов.ОрганизацияОтчитываетсяПоВзносамСамостоятельно(Параметры.Организация, Параметры.ДатаНачалаПериодаОтчета) Тогда
		Возврат
	КонецЕсли;
	
	ИмяПоля = Лев(Параметры.ИДИменПоказателей[0], 13);
	ДатаНачалаНП = НачалоДня(Параметры.ДатаНачалаПериодаОтчета);
	ДатаКонцаНП  = КонецДня(Параметры.ДатаКонцаПериодаОтчета);
	ИсточникРасшифровки = ОбщегоНазначения.ОбщийМодуль(Параметры.ИсточникРасшифровки);
	
	// Получаем данные расшифровки.
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить(Параметры.ИмяСКД); // Имя внешнего набора данных совпадает с ключем варианта.
		
	Организация = УчетСтраховыхВзносов.ОрганизацииДляКонсолидацииОтчетовПоВзносам(Параметры.Организация, ДатаНачалаНП);
	ИсточникРасшифровки.РасчетПоказателейПерсонифицированныеСведенияОФизическихЛицах(Параметры.ИмяРасчета, ДатаНачалаНП, ДатаКонцаНП, Организация, ВнешниеНаборыДанных, Истина, ?(Параметры.ДатаПодписи > ДатаКонцаНП,Параметры.ДатаПодписи, ДатаКонцаНП));
	
	// Удалим строки с нулевым значением показателя.
	Данные = ВнешниеНаборыДанных[Параметры.ИмяСКД];
	ВсегоСтрок = Данные.Количество();
	Для Сч = 1 По ВсегоСтрок Цикл
		СтрокаДанных = Данные[ВсегоСтрок - Сч];
		Если Не ЗначениеЗаполнено(СтрокаДанных[ИмяПоля]) Тогда
			Данные.Удалить(СтрокаДанных)
		КонецЕсли;
	КонецЦикла;
	
	// Подготовим табличку для проверки с учетом отборов.
	ДанныеДляПроверки = Неопределено;
	Если Параметры.Свойство("ЗначениеТекущегоПоказателя") Тогда
		ДанныеДляПроверки = Данные.Скопировать();
	КонецЕсли;
	
	// Настраиваем СКД и выводим отчет.
	СхемаКомпоновкиДанных = ПолучитьМакет(Параметры.ИмяСКД);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[Параметры.ИмяСКД].Настройки);
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	
	ОтчетыСервер.ДобавитьВыбранноеПоле(НастройкиКомпоновки, ИмяПоля, ?(Параметры.Свойство("ЗаголовокПоля") И ЗначениеЗаполнено(Параметры.ЗаголовокПоля), Параметры.ЗаголовокПоля, " "));
	
	Если Параметры.Свойство("СНИЛС") И ЗначениеЗаполнено(Параметры.СНИЛС) Тогда
		ДобавитьОтборПоПараметру(НастройкиКомпоновки, "П000010003001", Параметры.СНИЛС, ДанныеДляПроверки)
	КонецЕсли;
	
	Если ДанныеДляПроверки <> Неопределено Тогда
		ЗарплатаКадры.ВывестиПредупреждениеОРасхожденииПоказателяСРасшифровкой(Параметры.ЗначениеТекущегоПоказателя, ДанныеДляПроверки.Итог(ИмяПоля), ДокументРезультат);
		ДанныеДляПроверки = Неопределено;
	КонецЕсли;
	
	МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОтборПоПараметру(НастройкиКомпоновки, ИмяОтбора, ЗначениеОтбора, ДанныеДляПроверки)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиКомпоновки.Отбор, ИмяОтбора, ЗначениеОтбора, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Если ДанныеДляПроверки <> Неопределено И ДанныеДляПроверки.Колонки.Найти(ИмяОтбора) <> Неопределено Тогда
		ДанныеДляПроверки = ДанныеДляПроверки.Скопировать(ДанныеДляПроверки.НайтиСтроки(Новый Структура(ИмяОтбора, ЗначениеОтбора)))
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли