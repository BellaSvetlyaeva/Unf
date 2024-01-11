#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);

	УстановитьВидимостьОтборовОпераций();
	ВосстановитьНастройкиОтборовОпераций();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.ОтборОрганизация.Видимость = Ложь;
	ИначеЕсли Константы.УчетПоКомпании.Получить() Тогда
		Элементы.ОтборОрганизация.Доступность = Ложь;
		Элементы.ОтборОрганизация.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПоВидуОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		СохранитьНастройкиОтборовОпераций();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасчетПрямыхЗатратПриИзменении(Элемент)
	УстановитьОтборПоВидуОперации();
КонецПроцедуры

&НаКлиенте
Процедура РасчетФинансовогоРезультатаПриИзменении(Элемент)
	УстановитьОтборПоВидуОперации();
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеЗатратПриИзменении(Элемент)
	УстановитьОтборПоВидуОперации();
КонецПроцедуры

&НаКлиенте
Процедура РасчетФактическойСебестоимостиПриИзменении(Элемент)
	УстановитьОтборПоВидуОперации();
КонецПроцедуры

&НаКлиенте
Процедура РасчетСебестоимостиВРозницеСуммовойУчетПриИзменении(Элемент)
	УстановитьОтборПоВидуОперации();
КонецПроцедуры

&НаКлиенте
Процедура РасчетКурсовыхРазницПриИзменении(Элемент)
	УстановитьОтборПоВидуОперации();
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
Процедура ОтборОрганизацияРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент,
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;	
	ПараметрыФормы = Новый Структура("СтрокаПоиска", "в целом");
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.НастройкаПрограммы", ПараметрыФормы);		

КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьОтборовОпераций();
	
	ВключенУчетРозничныхПродаж = Константы.ФункциональнаяОпцияСуммовойУчетВРознице.Получить();
	ВключенУчетВалютныхОпераций = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
	ВключенРасчетФинансовогоРезультата = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетФинансовогоРезультата");
	ВключенИспользоватьРаспределениеЗатрат = ПолучитьФункциональнуюОпцию("ИспользоватьРаспределениеЗатрат");

	Элементы.РаспределениеЗатрат.Видимость = ВключенИспользоватьРаспределениеЗатрат;
    Элементы.РасчетСебестоимостиВРозницеСуммовойУчет.Видимость = ВключенУчетРозничныхПродаж;
	Элементы.РасчетКурсовыхРазниц.Видимость = ВключенУчетВалютныхОпераций;
	Элементы.РасчетФинансовогоРезультата.Видимость = ВключенРасчетФинансовогоРезультата;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиОтборовОпераций();

	ИмяКлючаОбъекта = СтрЗаменить(ИмяФормы,".","");
	СохраненноеЗначение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяКлючаОбъекта,
		ИмяКлючаОбъекта + "Список_ОтборПоОперациям");
	
	Если ЗначениеЗаполнено(СохраненноеЗначение) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраненноеЗначение);
		
		ЕстьЗаполненныеЭлементы = Ложь;
		Для Каждого Элемент Из СохраненноеЗначение Цикл
			Если Элемент.Значение = Истина Тогда
				ЕстьЗаполненныеЭлементы = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьЗаполненныеЭлементы Тогда
			РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Истина);
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоВидуОперации()
	
	ГруппаОтбораИЛИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ЭтаФорма.Список.КомпоновщикНастроек.Настройки.Отбор.Элементы, "Отбор",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИЛИ);
		
	Если РаспределениеЗатрат Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбораИЛИ, "РаспределениеЗатрат", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);			
	КонецЕсли;		
	Если РасчетПрямыхЗатрат Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбораИЛИ, "РасчетПрямыхЗатрат", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);			
	КонецЕсли;		
	Если РасчетФинансовогоРезультата Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбораИЛИ, "РасчетФинансовогоРезультата", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);			
	КонецЕсли;						
	Если РасчетФактическойСебестоимости Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбораИЛИ, "РасчетФактическойСебестоимости", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);			
	КонецЕсли;						
	Если РасчетСебестоимостиВРозницеСуммовойУчет Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбораИЛИ, "РасчетСебестоимостиВРозницеСуммовойУчет", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;						
	Если РасчетКурсовыхРазниц Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаОтбораИЛИ, "РасчетКурсовыхРазниц", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);			
	КонецЕсли;						
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборовОпераций();

	НастройкиОтбора = Новый Структура;
	НастройкиОтбора.Вставить("РаспределениеЗатрат", РаспределениеЗатрат);
	НастройкиОтбора.Вставить("РасчетПрямыхЗатрат", РасчетПрямыхЗатрат);
	НастройкиОтбора.Вставить("РасчетФинансовогоРезультата", РасчетФинансовогоРезультата);
	НастройкиОтбора.Вставить("РасчетФактическойСебестоимости", РасчетФактическойСебестоимости);
	НастройкиОтбора.Вставить("РасчетСебестоимостиВРозницеСуммовойУчет", РасчетСебестоимостиВРозницеСуммовойУчет);
	НастройкиОтбора.Вставить("РасчетКурсовыхРазниц", РасчетКурсовыхРазниц);
	
	ИмяКлючаОбъекта = СтрЗаменить(ИмяФормы,".","");
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяКлючаОбъекта, ИмяКлючаОбъекта + "Список_ОтборПоОперациям",
		НастройкиОтбора);
	
КонецПроцедуры

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение,
	ПредставлениеЗначения = "")

	
	Если ГруппаРодительМетки = "ГруппаОтборОплата" Тогда
		ПредставлениеЗначения = РаботаСОтборами.СформироватьПредставлениеМеткиОплата(ВыбранноеЗначение);
		Если ИмяПоляОтбораСписка = "НомерКартинкиОплаты" Тогда
			ВыбранноеЗначение = РаботаСОтборами.НомерКартинкиПоСтатусуОплаты(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Если ГруппаРодительМетки = "ГруппаОтборОтгрузка" Тогда
		Если ИмяПоляОтбораСписка = "НомерКартинкиОтгрузки" Тогда
			ПредставлениеЗначения = РаботаСОтборами.СформироватьПредставлениеМеткиОтгрузка(ВыбранноеЗначение);
			ВыбранноеЗначение = РаботаСОтборами.НомерКартинкиПоСтатусуОплаты(ВыбранноеЗначение);
		Иначе
			ПредставлениеЗначения = РаботаСОтборами.СформироватьПредставлениеМеткиОтгрузка(ПредставлениеЗначения);
		КонецЕсли;
	КонецЕсли;

	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли;
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);

КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	ЧисловойИдентификаторМетки = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(МеткаИД);
	СтрокаМеток = ДанныеМеток.НайтиПоИдентификатору(ЧисловойИдентификаторМетки);
	Если СтрокаМеток <> Неопределено И СтрокаМеток.ИмяПоляОтбора = "ВидЗаказа" Тогда
		ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Истина;
	КонецЕсли;
	
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
	
	Если Элементы.ФильтрыНастройкиИДопИнфо.Видимость Тогда
		Элементы.ПраваяПанель.Ширина = 28;
	КонецЕсли;
		
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

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

//@skip-check module-unused-method
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

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
