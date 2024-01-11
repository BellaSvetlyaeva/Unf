
#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

&НаКлиенте
Перем ПодтвержденоЗакрытиеФормы; // Для подтверждения закрытия формы пользователем

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();

	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, "Организация, ВалютаДокумента, СтруктурнаяЕдиница,
		|Грузоотправитель, Контрагент, Договор, БанковскийСчетКонтрагента, Грузополучатель, АдресДоставки,
		|ДоверенностьВыдана, ДоверенностьДата, ДоверенностьЛицо, ДоверенностьНомер, ПодписьРуководителя,
		|ПодписьГлавногоБухгалтера, ПодписьКладовщика, КонтактноеЛицоПодписант, БанковскийСчет, ДокументОснование");

	УстановитьВидФормы();
	ЗаголовокФормы();
	ЗаполнитьАдресДоставки();
	ЗаполнитьПараметрыВыбораБанковскогоСчета();
	ЗаполнитьПодсказкиПодписей();
	УстановитьКартинкиКнопок();
	
	ГрузоотправительОнЖе = НЕ ЗначениеЗаполнено(КонтекстПечати.Грузоотправитель);
	ГрузополучательОнЖе = НЕ ЗначениеЗаполнено(КонтекстПечати.Грузополучатель);
	УстановитьОтображениеГрузоперевозки();	
	
	ДоступностьКомандФормы();
	РаботаСФормойДокумента.НастроитьВидимостьГруппыИнформации(ЭтотОбъект, "ГруппаИнформацияПоНовымРеквизитам",
							"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивИзмененныхРеквизитов = Новый Массив;
	ПодтвержденоЗакрытиеФормы = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ ЗавершениеРаботы И НЕ ПодтвержденоЗакрытиеФормы Тогда
		
		Отказ = Истина;
        ОписаниеОповещенияОЗавершении    = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);                
        ТекстВопроса        = НСтр("ru = 'Выполненные изменения будут отменены. Продолжить?'");                
        ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет); 		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
    
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ПодтвержденоЗакрытиеФормы = Истина;
               
    Закрыть();
    
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодписьРуководителяПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьГлавногоБухгалтераПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьКладовщикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоПодписантПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительОнЖеПриИзменении(Элемент)

	Элементы.Грузоотправитель.Видимость = НЕ ГрузоотправительОнЖе;
	Элементы.ГрузоотправительОрганизация.Видимость = ГрузоотправительОнЖе;
	
	Если ГрузоотправительОнЖе Тогда
		КонтекстПечати.Грузоотправитель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;

	ЗафиксироватьИзменениеЗначенияРеквизита("Грузоотправитель");

КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОнЖеПриИзменении(Элемент)

	Элементы.Грузополучатель.Видимость = НЕ ГрузополучательОнЖе;
	Элементы.ГрузополучательКонтрагент.Видимость = ГрузополучательОнЖе;

	Если ГрузополучательОнЖе Тогда
		КонтекстПечати.Грузополучатель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;

	ЗафиксироватьИзменениеЗначенияРеквизита("Грузополучатель");	

КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
	ЗаполнитьАдресДоставки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ПриИзмененииПредставленияАдреса(
	Элемент.ТекстРедактирования,
	КонтекстПечати["АдресДоставкиЗначение"]);

КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФормуВыбораАдресаИОбработатьРезультат(
		Элемент,
		КонтекстПечати,
		"АдресДоставки",
		СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПолучателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	КонтекстПечати.АдресДоставки = ВыбранноеЗначение.АдресДоставки;
	КонтекстПечати.АдресДоставкиЗначение = ВыбранноеЗначение.АдресДоставкиЗначение;
	КонтекстПечати.АдресДоставкиЗначенияПолей = ВыбранноеЗначение.АдресДоставкиЗначенияПолей;

	ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставки");
	ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставкиЗначение");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьНомерПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьДатаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьВыданаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьЛицоПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетКонтрагентаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияПоНовойСхемеЗакрытьНажатие(Элемент)

	Элементы.ГруппаИнформацияПоНовымРеквизитам.Видимость = Ложь;	
	СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура("ПодписьРуководителя, ПодписьГлавногоБухгалтера, ПодписьКладовщика");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьРуководителяНажатие(Команда)
	
    ЗаписатьНастройкуПользователя("ПодписьРуководителя", КонтекстПечати.ПодписьРуководителя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьГлавногоБухгалтераНажатие(Команда)

	ЗаписатьНастройкуПользователя("ПодписьГлавногоБухгалтера", КонтекстПечати.ПодписьГлавногоБухгалтера);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьКладовщикаНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("ПодписьМОЛ", КонтекстПечати.ПодписьКладовщика);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);

	ПараметрыЗакрытия.Вставить("ГрузоотправительОнЖе", ГрузоотправительОнЖе);
	ПараметрыЗакрытия.Вставить("ГрузополучательОнЖе", ГрузополучательОнЖе);
	
	ПодтвержденоЗакрытиеФормы = Истина;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораАдресаДоставки(ЭлементАдреса, Владелец, ВидыКИ)
	
	МассивВладельцев = Новый Массив;
	МассивВладельцев.Добавить(Владелец);
	
	Адреса = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивВладельцев,
		,
		ВидыКИ,
		ТекущаяДатаСеанса());
	
	Для Каждого Адрес Из Адреса Цикл
		
		ЭлементАдреса.СписокВыбора.Добавить(Адрес.Представление);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресДоставки(ОчиститьПоле = Ложь)
	
	Если ОчиститьПоле Тогда
		
		КонтекстПечати.АдресДоставки = "";
		
	КонецЕсли;
	
	Элементы.АдресДоставки.СписокВыбора.Очистить();
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента);
	
	ИсточникАдресовДоставки = ?(ЗначениеЗаполнено(КонтекстПечати.Грузополучатель), КонтекстПечати.Грузополучатель, КонтекстПечати.Контрагент);
	ЗаполнитьСписокВыбораАдресаДоставки(Элементы.АдресДоставки, ИсточникАдресовДоставки, ВидыКИ);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	ДокументОбъект = ДанныеФормыВЗначение(КонтекстПечати, Тип("ДокументОбъект.КорректировкаРеализации"));
	Обработки.РеквизитыПечати.ПодписиПоУмолчанию(ДокументОбъект);
	ЗначениеВДанныеФормы(ДокументОбъект, КонтекстПечати);
	
	КонтекстПечати.КонтактноеЛицоПодписант = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Контрагент, "КонтактноеЛицоПодписант");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВыбораБанковскогоСчета()
	
	Обработки.РеквизитыПечати.ЗаполнитьПараметрыВыбораБанковскогоСчетаОрганизации(Элементы.БанковскийСчет, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКомандФормы()
	
	Если НЕ ПравоДоступа("Изменение", КонтекстПечати.Ссылка.Метаданные()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВосстановитьПодписиПоУмолчанию", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораАдресаИОбработатьРезультат(Элемент, Объект, ИмяРеквизитаАдресаДоставки, СтандартнаяОбработка = Ложь)
	
	СтандартнаяОбработка = Ложь;
	
	АдресПредставление = Объект[ИмяРеквизитаАдресаДоставки];
	АдресЗначение = Объект[ИмяРеквизитаАдресаДоставки + "Значение"];
	
	// Откроем диалог редактирования КИ
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента"));
	ПараметрыОткрытия.Вставить("Значение", АдресЗначение);
	ПараметрыОткрытия.Вставить("Представление", АдресПредставление);
	ПараметрыОткрытия.Вставить("Комментарий", Объект.ДополнительнаяИнформацияПоДоставке);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаАдресаДоставки", ИмяРеквизитаАдресаДоставки);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение", 
		ЭтотОбъект, ДополнительныеПараметры);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ИмяРеквизитаАдресаДоставки = ДополнительныеПараметры.ИмяРеквизитаАдресаДоставки;
		
	Если ТипЗнч(Результат) = Тип("Структура") Тогда // КИ введена
		
		// Перенесем данные в форму
		КонтекстПечати[ИмяРеквизитаАдресаДоставки + "Значение"] = Результат.Значение;
		КонтекстПечати[ИмяРеквизитаАдресаДоставки] = Результат.Представление;
		КонтекстПечати.ДополнительнаяИнформацияПоДоставке = Результат.Комментарий;

		ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставки");
		ЗафиксироватьИзменениеЗначенияРеквизита("АдресДоставкиЗначение");
		
		Модифицированность = Истина;
		ОбновитьОтображениеДанных();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуПользователя(НазваниеНастройки, ЗначениеНастройки)
	
	ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки);	
	
	СтрокаЗаголовка = НСтр("ru='Сохранение настроек пользователя'");
	ШаблонСообщения = НСтр("ru='Значение сохранено для использования в новых документах %1 %2'");
	
	ПараметрОрганизация = "";
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		
		НаименованиеОрганизации = УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(
			КонтекстПечати.Организация, "Наименование");
		ПараметрОрганизация = СтрШаблон(НСтр("ru='по организации %1'"), НаименованиеОрганизации);
		
	КонецЕсли;
	
	ПараметрПользователь = СтрШаблон(НСтр("ru='пользователем %1'"), ПользователиКлиент.АвторизованныйПользователь());

	СтрокаТекста = СтрШаблон(ШаблонСообщения, ПараметрОрганизация, ПараметрПользователь);
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	
	ПоказатьОповещениеПользователя(СтрокаЗаголовка, , СтрокаТекста, КартинкаСохранения,
		СтатусОповещенияПользователя.Важное);
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки)

	РегистрыСведений.НастройкиПользователей.Установить(ЗначениеНастройки, НазваниеНастройки, ,
		КонтекстПечати.Организация);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриИзмененииПредставленияАдреса(Представление, АдресЗначение)
	
	Если ЗначениеЗаполнено(Представление) Тогда
		АдресЗначение = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Представление,
			Перечисления.ТипыКонтактнойИнформации.Адрес);
	Иначе
		АдресЗначение = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодсказкиПодписей() 
	
	Если КонтекстПечати.ПодписьГлавногоБухгалтера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Организация,
			"ПодписьГлавногоБухгалтера") Тогда
		Элементы.ПодписьГлавногоБухгалтера.Подсказка = НСтр("ru='Подпись из реквизитов организации'");
	Иначе
		Элементы.ПодписьГлавногоБухгалтера.Подсказка = НСтр("ru='Подпись из настроек пользователя'");
	КонецЕсли;

	Если КонтекстПечати.ПодписьРуководителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Организация,
			"ПодписьРуководителя") Тогда
		Элементы.ПодписьРуководителя.Подсказка = НСтр("ru='Подпись из реквизитов организации'");
	Иначе
		Элементы.ПодписьРуководителя.Подсказка = НСтр("ru='Подпись из настроек пользователя'");
	КонецЕсли;
	
	Если КонтекстПечати.ПодписьКладовщика = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			КонтекстПечати.СтруктурнаяЕдиница, "ПодписьМОЛ") Тогда
		Элементы.ПодписьКладовщика.Подсказка = НСтр("ru='Подпись из реквизитов структурной единицы'");
	Иначе
		Элементы.ПодписьКладовщика.Подсказка = НСтр("ru='Подпись из настроек пользователя'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкиКнопок()
	
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	Элементы.СохранитьПодписьРуководителя.Картинка = КартинкаСохранения;
	Элементы.СохранитьПодписьГлавногоБухгалтера.Картинка = КартинкаСохранения;
	Элементы.СохранитьПодписьКладовщика.Картинка = КартинкаСохранения;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидФормы()
	
	Если Параметры.Свойство("РазвернутьГруппы") И Параметры.РазвернутьГруппы <> "" Тогда
		СписокГрупп = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Параметры.РазвернутьГруппы);
		Для каждого ЭлементФормы Из Элементы Цикл
			Если ЭлементФормы.Вид = ВидГруппыФормы.ОбычнаяГруппа Тогда
				Если СписокГрупп.Найти(ЭлементФормы.Имя) <> Неопределено Тогда
					ЭлементФормы.Показать();
				Иначе
					ЭлементФормы.Скрыть();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийЭлемент") Тогда
		
		ТекущийЭлемент = Элементы[Параметры.ТекущийЭлемент];

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеГрузоперевозки()

	РаботаСФормойДокумента.НастроитьГруппуГрузоперевозки(ЭтотОбъект, КонтекстПечати.Организация,
		КонтекстПечати.Контрагент);

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме()

	РаботаСФормойДокумента.СохранитьВидимостьГруппыИнформации(ИмяФормы,
			"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", Ложь, "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, КонтекстПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, КонтекстПечати);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
