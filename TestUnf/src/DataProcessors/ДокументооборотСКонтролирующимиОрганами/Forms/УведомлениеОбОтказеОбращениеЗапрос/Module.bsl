
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Сообщение) Тогда
		Отказ = Истина;
		Возврат;
	Иначе 
		Сообщение = Параметры.Сообщение;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	
	// извлекаем файл уведомления из содержимого сообщения
	СтрУведомления = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбОтказе, ИмяФайлаУведомления);
	Если СтрУведомления.Количество() = 0 Тогда
		ТекстПредупреждения = "Уведомление об отказе не обнаружено среди содержимого сообщения.";
		Возврат;
	КонецЕсли;
	СтрУведомление = СтрУведомления[0];
	
	// записываем вложение во временный файл
	ФайлУведомления = ПолучитьИмяВременногоФайла("xml");
	Попытка
		СтрУведомление.Данные.Получить().Записать(ФайлУведомления);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ошибка выгрузки уведомления об отказе во временный файл: %1'"), Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	// считываем уведомление из файла в дерево XML
	ОписаниеОшибки = "";
	ДеревоXML = КонтекстЭДО.ЗагрузитьXMLВДеревоЗначений(ФайлУведомления, , ОписаниеОшибки);
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлУведомления);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ошибка чтения XML из файла уведомления об отказе: %1'"), Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	
	// анализируем XML
	УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
		ТекстСообщения = НСтр("ru='Некорректная структура XML уведомления: не обнаружен узел ""Файл"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УзелДокумент = УзелФайл.Строки.Найти("Документ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелДокумент) Тогда
		ТекстСообщения = НСтр("ru='Некорректная структура XML уведомления: не обнаружен узел ""Документ"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УзелСведУведОтказ = УзелДокумент.Строки.Найти("СведУведОтказ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСведУведОтказ) Тогда
		ТекстСообщения = НСтр("ru='Некорректная структура XML уведомления: не обнаружен узел ""СведУведОтказ"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// анализируем общий перечень нарушений
	УзлыПеречВыявНар = УзелСведУведОтказ.Строки.НайтиСтроки(Новый Структура("Имя", "ПеречВыявНар"));
	Для Каждого УзелПеречВыявНар Из УзлыПеречВыявНар Цикл
		УзелКодОш = УзелПеречВыявНар.Строки.Найти("КодОш", "Имя");
		УзелТекстОш = УзелПеречВыявНар.Строки.Найти("ТекстОш", "Имя");
		Если ЗначениеЗаполнено(УзелКодОш) ИЛИ ЗначениеЗаполнено(УзелТекстОш) Тогда
			
			КодОшибки = ?(ЗначениеЗаполнено(УзелКодОш), СокрЛП(УзелКодОш.Значение), "");
			ТекстОшибки = ?(ЗначениеЗаполнено(УзелТекстОш), СокрЛП(УзелТекстОш.Значение), "");
			
			НовСтр = Ошибки.Добавить();
			НовСтр.КодОшибки = КодОшибки;
			НовСтр.Описание = ТекстОшибки;
			
		КонецЕсли;
	КонецЦикла;
	
	// разбираем узел с перечнем выявленных нарушений
	УзлыВыявлНарФайл = УзелСведУведОтказ.Строки.НайтиСтроки(Новый Структура("Имя", "ВыявлНарФайл"));
	Если УзлыВыявлНарФайл.Количество() > 0 Тогда
		
		СоотвУзлаИмениФайла = Новый Соответствие;
		
		Для Каждого УзелВыявНарФайл Из УзлыВыявлНарФайл Цикл
			
			УзелИмяОбрабФайла = УзелВыявНарФайл.Строки.Найти("ИмяОбрабФайла", "Имя");
			Если УзелВыявНарФайл = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ИмяОбрабФайла = СокрЛП(УзелИмяОбрабФайла.Значение);
			
			// ищем узел с тем же именем файла
			УзелФайл = СоотвУзлаИмениФайла.Получить(ИмяОбрабФайла);
			Если УзелФайл = Неопределено Тогда
				УзелФайл = ВыявлНарФайл.ПолучитьЭлементы().Добавить();
				УзелФайл.Описание = ИмяОбрабФайла;
				СоотвУзлаИмениФайла.Вставить(ИмяОбрабФайла, УзелФайл);
			КонецЕсли;
			
			УзлыПеречВыявНар = УзелВыявНарФайл.Строки.НайтиСтроки(Новый Структура("Имя", "ПеречВыявНар"));
			Для Каждого УзелПеречВыявНар Из УзлыПеречВыявНар Цикл
				УзелКодОш = УзелПеречВыявНар.Строки.Найти("КодОш", "Имя");
				УзелТекстОш = УзелПеречВыявНар.Строки.Найти("ТекстОш", "Имя");
				Если ЗначениеЗаполнено(УзелКодОш) ИЛИ ЗначениеЗаполнено(УзелТекстОш) Тогда
					
					КодОшибки = ?(ЗначениеЗаполнено(УзелКодОш), СокрЛП(УзелКодОш.Значение), "");
					ТекстОшибки = ?(ЗначениеЗаполнено(УзелТекстОш), СокрЛП(УзелТекстОш.Значение), "");
					
					НовСтр = УзелФайл.ПолучитьЭлементы().Добавить();
					НовСтр.КодОшибки = КодОшибки;
					НовСтр.Описание = ТекстОшибки;
					
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		Элементы.ВыявлНарФайл.Видимость = Ложь;
	КонецЕсли;
	
	// разбираем узел с общими сведениями
	ОбщиеСведения = Новый Структура;
	УзлыОбщСвУвед = УзелСведУведОтказ.Строки.НайтиСтроки(Новый Структура("Имя", "ОбщСвУвед"));
	Если УзлыОбщСвУвед.Количество() > 0 Тогда
		УзелОбщСвУвед = УзлыОбщСвУвед[0];
		Для Каждого УзелОбщСвед Из УзелОбщСвУвед.Строки Цикл
			ОбщиеСведения.Вставить(УзелОбщСвед.Имя, СокрЛП(УзелОбщСвед.Значение));
		КонецЦикла;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("КНД") Тогда
		КНД = ОбщиеСведения.КНД;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("НаимВидДок") Тогда
		НаимВидДок = ОбщиеСведения.НаимВидДок;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ДатаНапр") Тогда
		ДатаВремяПредст = ОбщиеСведения.ДатаНапр;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ВремНапр") Тогда
		ДатаВремяПредст = СокрЛП(ДатаВремяПредст + " " + ОбщиеСведения.ВремНапр);
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ДатаПост") Тогда
		ДатаПрием = ОбщиеСведения.ДатаПост;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ИмяПринятФайла") Тогда
		ИмяОбрабФайла = ОбщиеСведения.ИмяПринятФайла;
	КонецЕсли;
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Элементы.ВыявлНарФайл.Видимость Тогда
		ЭлементыВыявлНарФайл = ВыявлНарФайл.ПолучитьЭлементы();
		Для Каждого ЭлементВыявлНарФайл Из ЭлементыВыявлНарФайл Цикл
			Элементы.ВыявлНарФайл.Развернуть(ЭлементВыявлНарФайл.ПолучитьИдентификатор());
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбщиеСведенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПечататьРезультатПриема, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти

