#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ложь;
	ДокументРезультат.Очистить();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиОтчета);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	УстановитьПараметрыВыводаТабличногоДокумента(ДокументРезультат);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
КонецПроцедуры

Процедура УстановитьПараметрыВыводаТабличногоДокумента(ДокументРезультат)
	ДокументРезультат.Автомасштаб 			= 	Истина;
	ДокументРезультат.ОриентацияСтраницы 	= 	ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ТолькоПросмотр		= 	Истина;
	ДокументРезультат.ПолеСверху			= 	5;
	ДокументРезультат.ПолеСнизу				= 	5;
	ДокументРезультат.ПолеСлева				= 	10;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли