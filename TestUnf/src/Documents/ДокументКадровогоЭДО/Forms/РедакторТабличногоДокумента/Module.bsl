#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ;
	Организация = Параметры.Организация;
	НаименованиеДокумента = Параметры.НаименованиеДокумента;
	Дата = Параметры.Дата;
	
	Если Документ.ВысотаТаблицы = 0 Тогда
		ВывестиМакетПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ОбработкаОтветаНаВОпросОСохраненииИзменений", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Документ изменен. Закрытие формы без сохранения изменений приведет к их потере.
			|
			|Продолжить?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		Модифицированность = Ложь;
		Закрыть(Документ);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ОчиститьБланкДокумента();
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОтветаНаВОпросОСохраненииИзменений(Результат, ДополнительныеПраметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьБланкДокумента()
	
	Документ.Очистить();
	Документ.Область(, 1, , 34).ШиринаКолонки = 3;
	Для НомерСтроки = 1 По 5 Цикл
		ОбластьСтроки = Документ.Область(НомерСтроки, 1, НомерСтроки, 34);
		ОбластьСтроки.Объединить();
		ОбластьСтроки.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиМакетПоУмолчанию()
	
	ЗначенияПараметров = Новый Структура;
	Если ЗначениеЗаполнено(НаименованиеДокумента) Тогда
		ЗначенияПараметров.Вставить("НаименованиеДокумента", НаименованиеДокумента);
	Иначе
		ЗначенияПараметров.Вставить("НаименованиеДокумента", НСтр("ru = '/Введите наименование документа/'"));
	КонецЕсли;
	
	ЗначенияПараметров.Вставить("Номер", "№ _______________");
	ЗначенияПараметров.Вставить("Дата", Формат(Дата, "ДЛФ=DD"));
	
	ПредставлениеДолжности = "";
	ПредставлениеРуководителя = "";
	Если ЗначениеЗаполнено(Организация) Тогда
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "НаимЮЛПол");
		Сведения.Добавить("", "ИННЮЛ");
		Сведения.Добавить("", "НаимЮЛСокр");
		Сведения.Добавить("", "КППЮЛ");
		
		Сведения.Добавить("", "ОГРН");
		Сведения.Добавить("", "РукСсылка");
		Сведения.Добавить("", "ДолжнРукСсылка");
		
		Сведения.Добавить("", "ТелОрганизации");
		Сведения.Добавить("", "ФаксОрганизации");
		
		ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			Организация, Дата, Сведения);
		
		ЗначенияПараметров.Вставить("ОрганизацияНаименованиеПолное", ОргСведения.НаимЮЛПол);
		ЗначенияПараметров.Вставить("ОрганизацияНаименованиеСокращенное", ОргСведения.НаимЮЛСокр);
		ЗначенияПараметров.Вставить("ОрганизацияИНН", ОргСведения.ИННЮЛ);
		ЗначенияПараметров.Вставить("ОрганизацияКПП", ОргСведения.КППЮЛ);
		ЗначенияПараметров.Вставить("ОрганизацияОГРН", ОргСведения.ОГРН);
		ЗначенияПараметров.Вставить("ОрганизацияТелефон", ОргСведения.ТелОрганизации);
		ЗначенияПараметров.Вставить("ОрганизацияФакс", ОргСведения.ФаксОрганизации);
		
		Если ЗначениеЗаполнено(ОргСведения.ДолжнРукСсылка) Тогда
			РеквизитыДолжности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ОргСведения.ДолжнРукСсылка, "Наименование, НаименованиеДляЗаписейОТрудовойДеятельности");
			ПредставлениеДолжности = РеквизитыДолжности.НаименованиеДляЗаписейОТрудовойДеятельности;
			Если Не ЗначениеЗаполнено(ПредставлениеДолжности) Тогда
				ПредставлениеДолжности = РеквизитыДолжности.Наименование;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОргСведения.РукСсылка) Тогда
			КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическогоЛица(Истина, ОргСведения.РукСсылка, "ИОФамилия", Дата);
			Если ЗначениеЗаполнено(КадровыеДанные) Тогда
				ПредставлениеРуководителя = КадровыеДанные.ИОФамилия;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ЗначенияПараметров.Вставить("ОрганизацияНаименованиеПолное", НСтр("ru = '/Введите наименование организации/'"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПредставлениеДолжности) Тогда
		ПредставлениеДолжности = НСтр("ru = 'Руководитель организации'");
	КонецЕсли;
	ЗначенияПараметров.Вставить("ДолжностьРуководителя", ПредставлениеДолжности);
	
	Если Не ЗначениеЗаполнено(ПредставлениеРуководителя) Тогда
		ПредставлениеРуководителя = НСтр("ru = '/Расшифровка подписи/'");
	КонецЕсли;
	ЗначенияПараметров.Вставить("РуководительРасшифровкаПодписи", ПредставлениеРуководителя);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДокументКадровогоЭДО.ПФ_MXL_ПустойБланкДокументаКЭДО");
	Макет.Параметры.Заполнить(ЗначенияПараметров);
	
	Документ.Вывести(Макет);
	
КонецПроцедуры

#КонецОбласти

