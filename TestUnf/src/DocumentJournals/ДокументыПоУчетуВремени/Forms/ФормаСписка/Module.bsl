
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для каждого Строка Из Метаданные.ЖурналыДокументов.ДокументыПоУчетуВремени.РегистрируемыеДокументы Цикл
		Элементы.ОтборТипДокумента.СписокВыбора.Добавить(Строка.Имя, Строка.Синоним);
	КонецЦикла;
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборамиКлиентСервер.УстановитьОтображениеКомандыСброситьВсеОтборы(ЭтотОбъект);
	//Конец УНФ.ОтборыСписка
	
	списокЗаказчик	= Новый Массив;
	Если Параметры <> Неопределено
		И Параметры.Свойство("Заказчик") Тогда
		
		Заказчик = Параметры.Заказчик;
		
		Если ЗначениеЗаполнено(Заказчик) Тогда
			списокЗаказчик.Добавить(Заказчик);
		КонецЕсли;
		Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", НЕ ЗначениеЗаполнено(списокЗаказчик));
		Список.Параметры.УстановитьЗначениеПараметра("списокЗаказчик", списокЗаказчик);
		
	Иначе
		// установим пустые значения параметров запроса списка
		Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("списокЗаказчик", списокЗаказчик);
		
		//УНФ.ОтборыСписка
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
		//Конец УНФ.ОтборыСписка
	КонецЕсли;
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Процедура - обработчик события ОбработкаВыбора реквизита Заказчик.
//
Процедура ЗаказчикОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбораСКонтрагентом", , , , , ,
			Новый ОписаниеОповещения("ЗаказчикОбработкаВыбораЗавершение", ЭтотОбъект));
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") 
		ИЛИ ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
		ИЛИ ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		ОтборЗаказчикОбработкаВыбора(Элементы.ОтборЗаказчик, ВыбранноеЗначение, Ложь);
		СтандартнаяОбработка = Ложь;

	Иначе
		// был выбран тип данных, продолжаем выбор
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказчикОбработкаВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("СправочникСсылка.ДоговорыКонтрагентов")Тогда

		ОтборЗаказчикОбработкаВыбора(Элементы.ОтборЗаказчик, Результат, Ложь);
		
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказчикОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеДокумента = СтрЗаменить(ВыбранноеЗначение, "Заказ покупателя", "Заказ");
	УстановитьМеткуИОтборСписка("Заказчик", Элемент.Родитель.Имя, ВыбранноеЗначение, ПредставлениеДокумента, "списокЗаказчик");
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПредставлениеОтбора = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;
	ЗначениеТип = ?(ЗначениеЗаполнено(ВыбранноеЗначение), Тип("ДокументСсылка." + ВыбранноеЗначение), Неопределено);

	УстановитьМеткуИОтборСписка("ТипДокумента", Элемент.Родитель.Имя, ЗначениеТип, ПредставлениеОтбора);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура();
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Заказчик");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");
		
	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);
	ОткрытьФорму("Документ."+ИмяФормыСтрока+".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));

КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="", ИмяПараметраЗапроса="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения, ,ИмяПараметраЗапроса);
	
	Если ИмяПараметраЗапроса="" Тогда
		РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	Иначе	
		
		СтруктураОтбораМеток = Новый Структура("ИмяПараметраЗапроса", ИмяПараметраЗапроса);
		НайденныеСтроки = ДанныеМеток.НайтиСтроки(СтруктураОтбораМеток);
		МассивОтбора = Новый Массив;
		Для каждого стр Из НайденныеСтроки Цикл
			МассивОтбора.Добавить(стр.Метка);
		КонецЦикла;
		Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", НайденныеСтроки.Количество()=0);
		Список.Параметры.УстановитьЗначениеПараметра(ИмяПараметраЗапроса, МассивОтбора);
	КонецЕсли; 
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, "Список", "Дата");
	СброситьВсеМеткиОтбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере()
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список);
КонецПроцедуры

#КонецОбласти

