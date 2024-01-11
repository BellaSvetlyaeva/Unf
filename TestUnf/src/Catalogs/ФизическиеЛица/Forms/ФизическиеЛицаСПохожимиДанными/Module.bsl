
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ЗаголовокФормы;
	ТекстИнформационнойНадписи = Параметры.ТекстИнформационнойНадписи;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
		|	ФизическиеЛица.Наименование КАК ФИО,
		|	ФизическиеЛица.ДатаРождения КАК ДатаРождения,
		|	ФизическиеЛица.ИНН КАК ИНН,
		|	ФизическиеЛица.СтраховойНомерПФР КАК СтраховойНомерПФР,
		|	ЕСТЬNULL(ДокументыФизическихЛицСрезПоследних.Представление, """") КАК ДокументПредставление
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
		|				,
		|				Физлицо В (&ФизическиеЛица)
		|					И ЯвляетсяДокументомУдостоверяющимЛичность) КАК ДокументыФизическихЛицСрезПоследних
		|		ПО ФизическиеЛица.Ссылка = ДокументыФизическихЛицСрезПоследних.Физлицо
		|ГДЕ
		|	ФизическиеЛица.Ссылка В(&ФизическиеЛица)";
	
	Запрос.УстановитьПараметр("ФизическиеЛица", Параметры.ФизическиеЛица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаДанных = ДанныеФизическихЛиц.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДанных, Выборка);
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.ДатаРождения) Тогда
			НоваяСтрокаДанных.ДатаРождения = "<" + НСтр("ru='Не заполнена'") + ">";
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.ИНН) Тогда
			НоваяСтрокаДанных.ИНН = "<" + НСтр("ru='Не заполнен'") + ">";
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.СтраховойНомерПФР) Тогда
			НоваяСтрокаДанных.СтраховойНомерПФР = "<" + НСтр("ru='Не заполнен'") + ">";
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(НоваяСтрокаДанных.ДокументПредставление) Тогда
			НоваяСтрокаДанных.ДокументПредставление = "<" + НСтр("ru='Не заполнен'") + ">";
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ДанныеФизическихЛиц.ТекущаяСтрока = ДанныеФизическихЛиц[0].ПолучитьИдентификатор();
	
	Если ДанныеФизическихЛиц.Количество() = 1 Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеФизическихЛиц[0]);	
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОдногоЧеловека;
		
	Иначе
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаНесколькихЧеловек;
		Элементы.ДаЭтоТотКтоМнеНужен.Заголовок = НСтр("ru='Отмеченный человек тот, кто мне нужен'");
		
	КонецЕсли;
	
	Если Параметры.СкрытьКомандуДругойЧеловек Тогда
		
		Элементы.НетЭтоДругойЧеловек.Видимость = Ложь;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГиперСсылкаОткрытьЛичныеДанныеНажатие(Элемент)
	
	ОткрытьЛичныеДанные(ФизическоеЛицо);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеФизическихЛиц

&НаКлиенте
Процедура ДанныеФизическихЛицВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ДанныеФизическихЛиц.ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьЛичныеДанные(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФизическихЛицПометкаПриИзменении(Элемент)
	
	ТекущиеДанныеСотрудника = Элементы.ДанныеФизическихЛиц.ТекущиеДанные;
	
	Если ТекущиеДанныеСотрудника.Пометка Тогда
		
		ПомеченныеСтроки = ДанныеФизическихЛиц.НайтиСтроки(Новый Структура("Пометка", Истина));
		Для Каждого СтрокаПомеченныеСтроки Из ПомеченныеСтроки Цикл
			
			Если СтрокаПомеченныеСтроки <> ТекущиеДанныеСотрудника Тогда
				СтрокаПомеченныеСтроки.Пометка = Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДанныеФизическогоЛица(Команда)
	
	Если Элементы.ДанныеФизическихЛиц.ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьЛичныеДанные(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФизическоеЛицоКонтекстноеМеню(Команда)
	
	Если Элементы.ДанныеФизическихЛиц.ТекущиеДанные <> Неопределено Тогда
		
		Закрыть(Элементы.ДанныеФизическихЛиц.ТекущиеДанные.ФизическоеЛицо);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДаЭтоТотКтоМнеНужен(Команда)
	
	ВыбратьФизическоеЛицоИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура НетЭтоДругойЧеловек(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьЛичныеДанные(ФизическоеЛицоСсылка)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Ключ", ФизическоеЛицоСсылка);
	ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", Истина);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФизическоеЛицоИЗакрытьФорму()
	
	Если ДанныеФизическихЛиц.Количество() > 1 Тогда
		
		ПомеченныеСтроки = ДанныеФизическихЛиц.НайтиСтроки(Новый Структура("Пометка", Истина));
		Если ПомеченныеСтроки.Количество() > 0 Тогда
			Закрыть(ПомеченныеСтроки[0].ФизическоеЛицо);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо установить отметку напротив нужного человека'"));
		КонецЕсли;
		
	Иначе
		Закрыть(ДанныеФизическихЛиц[0].ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
