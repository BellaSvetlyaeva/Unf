#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОрганизацияСАТУРН = Параметры.ОрганизацияСАТУРН;
	
	СобытияФормИС.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	СобытияФормСАТУРН.УстановитьПараметрыВыбораОрганизации(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьТекущуюСтраницуНавигации();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьРезультат") Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Изменения", ВходящиеСообщения);
		
		ОткрытьФорму("ОбщаяФорма.РезультатВыполненияОбменаСАТУРН", ПараметрыОткрытияФормы, ЭтотОбъект);
			
	Иначе
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗагруженныеОбъекты

&НаКлиенте
Процедура ЗагруженныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ЗагруженныеОбъекты.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(, ТекущиеДанные.Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалееНачало(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаВходящихДокументовНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВНачало(Команда)
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаИсходныеДанные;
	
	УстановитьТекущуюСтраницуНавигации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеЗакрыть(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеОбмена

&НаСервере
Функция ЗагрузкаВходящихДокументовНачалоНаСервере()
	
	ВходящиеСообщения.Очистить();
	ЗагруженныеОбъекты.Очистить();
	
	РезультатОбмена = Неопределено;
	
	ВходящиеДанные = Новый Массив();
	
	ПараметрыОбработкиДокументов = ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПараметрыОбработкиДокументов();
	ПараметрыОбработкиДокументов.ОрганизацияСАТУРН = ОрганизацияСАТУРН;
	ПараметрыОбработкиДокументов.Ссылка = Документы.НакладнаяСАТУРН.ПустаяСсылка();
	ПараметрыОбработкиДокументов.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные");
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Операция", Перечисления.ВидыОперацийСАТУРН.НакладнаяЗагрузкаСтатусов);//НакладнаяЗагрузкаДокументов);
	
	Если ЗначениеЗаполнено(ДатаСинхронизации) Тогда
		ПараметрыЗапроса.Вставить("ДатаСинхронизации", ДатаСинхронизации);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		ПараметрыЗапроса.Вставить("Интервал", ИнтеграцияСАТУРНКлиентСервер.СтруктураИнтервала(НачалоПериода, КонецПериода));
	ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
		ПараметрыЗапроса.Вставить("Интервал", ИнтеграцияСАТУРНКлиентСервер.СтруктураИнтервала(НачалоПериода));
	ИначеЕсли Не ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		ПараметрыЗапроса.Вставить("Интервал", ИнтеграцияСАТУРНКлиентСервер.СтруктураИнтервала(, КонецПериода));
	КонецЕсли;
	ПараметрыОбработкиДокументов.ДополнительныеПараметры = ПараметрыЗапроса;
	
	ВходящиеДанные.Добавить(ПараметрыОбработкиДокументов);
	
	РезультатОбмена = ИнтеграцияСАТУРНВызовСервера.ПодготовитьКПередаче(ВходящиеДанные, УникальныйИдентификатор);
	
	Возврат РезультатОбмена;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузкаВходящихДокументовНачало()
	
	РезультатОбмена = ЗагрузкаВходящихДокументовНачалоНаСервере();
	
	ОбработатьРезультатОбменаСАТУРН(РезультатОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСАТУРН(РезультатОбмена)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатЗагрузкаВходящихДокументов", ЭтотОбъект);
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОписаниеОповещения);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатЗагрузкаВходящихДокументов", ЭтотОбъект);
	ИнтеграцияСАТУРНСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОписаниеОповещения, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияРезультатЗагрузкаВходящихДокументов(Изменения, ДополнительныеПараметры) Экспорт
	
	Если Изменения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоОшибок     = 0;
	КоличествоОбъектов   = 0;
	
	СтруктураПоиска = Новый Структура("Объект");
	
	ТипНакладная = Тип("ДокументСсылка.НакладнаяСАТУРН");
	Для Каждого ЭлементДанных Из Изменения Цикл
		
		НоваяСтрока = ВходящиеСообщения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементДанных,, "Объект");
		
		Если ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
			НоваяСтрока.Объект = Новый ФиксированныйМассив(ЭлементДанных.Объект);
			КоличествоОбъектов = КоличествоОбъектов + ЭлементДанных.Объект.Количество();
			Для Каждого СсылкаНаОбъект Из ЭлементДанных.Объект Цикл
				СтруктураПоиска.Объект = СсылкаНаОбъект;
				Если ТипЗнч(СсылкаНаОбъект) <> ТипНакладная Тогда
					Продолжить;
				КонецЕсли;
				Если ЗагруженныеОбъекты.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
					СтрокаДанных = ЗагруженныеОбъекты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаДанных, СтруктураПоиска);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецЕсли;
			
	КонецЦикла;
	
	Если КоличествоОшибок > 0 Тогда
		ТекстРезультатаВыполненияОбмена = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр( "ru = 'Результат обмена данным с ошибками (%1)'"),
				КоличествоОшибок),, ЦветПроблема,, "ОткрытьРезультат");
	Иначе
		ТекстРезультатаВыполненияОбмена = Новый ФорматированнаяСтрока(
			НСтр( "ru = 'Результат обмена данным'"),,,, "ОткрытьРезультат");
	КонецЕсли;
	
	Элементы.ТекстРезультатаВыполненияОбмена.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат;
	
	УстановитьТекущуюСтраницуНавигации();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтраницуНавигации()
	
	СтраницыФормы     = Элементы.ГруппаСтраницы;
	СтраницыНавигации = Элементы.Навигация;
	
	Если СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаИсходныеДанные Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияНачало;
		Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОкончание;
		Элементы.ОкончаниеЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти