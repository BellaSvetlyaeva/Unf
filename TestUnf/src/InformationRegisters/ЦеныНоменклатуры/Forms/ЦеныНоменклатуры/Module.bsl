
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	Элементы.Список.ТолькоПросмотр = Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ЦеныНоменклатуры);

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаДиаграмма", "Пометка", Истина);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номенклатура",
		Параметры.Отбор.Номенклатура, ВидСравненияКомпоновкиДанных.Равно, "Номенклатура", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокИстория, "Номенклатура",
		Параметры.Отбор.Номенклатура, ВидСравненияКомпоновкиДанных.Равно, "Номенклатура", Истина);

	Если Параметры.Отбор.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Цены не хранятся для подарочных сертификатов'");
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.СписокИстория.ТолькоПросмотр = Истина;
	КонецЕсли;

	ПрочитатьИУстановитьНастройкиФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Наборы
	Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") И ВладелецФормы.ИмяФормы
		= "Справочник.Номенклатура.Форма.ФормаЭлемента" Тогда

		ОбъектНоменклатура = ВладелецФормы.Объект;

		Если ОбъектНоменклатура.ЭтоНабор И ОбъектНоменклатура.СпособРасчетаЦеныНабора = ПредопределенноеЗначение(
			"Перечисление.СпособыРасчетаЦеныНабора.СкладыватьИзЦенКомплектующих") Тогда

			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Цены недоступны для наборов со способом расчета цен по комплектующим'");
			Элементы.Список.ТолькоПросмотр = Истина;

		КонецЕсли;

	КонецЕсли; 	
	// Конец Наборы

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокЦенНоменклатуры" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияУстановкаЦенСсылкаНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/list/Документ.УстановкаЦенНоменклатуры");
	
КонецПроцедуры 

&НаКлиенте
Процедура ДекорацияРучноеНазначениеНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/list/Справочник.Номенклатура");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗакрытьНажатие(Элемент)
	
	ДекорацияИнформацияЗакрытьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ИнициироватьЗаполнениеДиаграммы", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Диаграмма(Команда)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаДиаграмма", "Пометка",
		Не Элементы.ФормаДиаграмма.Пометка);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДинамикаИзмененияЦены", "Видимость",
		Элементы.ФормаДиаграмма.Пометка);

КонецПроцедуры

&НаКлиенте
Процедура Хронология(Команда)
	
	СоответствиеСтраниц = Новый Соответствие;
	СоответствиеСтраниц.Вставить(Элементы.СтраницаСписок, Элементы.СтраницаСписокИстория);
	СоответствиеСтраниц.Вставить(Элементы.СтраницаСписокИстория, Элементы.СтраницаСписок);
	
	Элементы.Страницы.ТекущаяСтраница = СоответствиеСтраниц.Получить(Элементы.Страницы.ТекущаяСтраница);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДиаграммуНаСервере(ДанныеТекущейСтроки)
	
	НациональнаяВалюта = Константы.НациональнаяВалюта.Получить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 10
	|	ЦеныНоменклатуры.Период КАК Период,
	|	ЦеныНоменклатуры.Цена КАК Цена,
	|	ВЫБОР КОГДА ЦеныНоменклатуры.ВалютаЦены <> ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|		ТОГДА ЦеныНоменклатуры.ВалютаЦены
	|		ИНАЧЕ ЦеныНоменклатуры.ВидЦен.ВалютаЦены
	|	КОНЕЦ КАК ВалютаЦены
	|ПОМЕСТИТЬ ЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|ГДЕ
	|	ЦеныНоменклатуры.Номенклатура = &Номенклатура
	|	И ЦеныНоменклатуры.Характеристика = &Характеристика
	|	И ЦеныНоменклатуры.ВидЦен = &ВидЦен
	|	И ЦеныНоменклатуры.ЕдиницаИзмерения = &ЕдиницаИзмерения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатуры.Период КАК Период,
	|	ЦеныНоменклатуры.Цена,
	|	ЦеныНоменклатуры.ВалютаЦены
	|ИЗ
	|	ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	Запрос.УстановитьПараметр("Номенклатура",		ДанныеТекущейСтроки.Номенклатура);
	Запрос.УстановитьПараметр("ВидЦен", 			ДанныеТекущейСтроки.ВидЦен);
	
	Если ДанныеТекущейСтроки.Свойство("Характеристика") Тогда
		
		Запрос.УстановитьПараметр("Характеристика",	ДанныеТекущейСтроки.Характеристика);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЦеныНоменклатуры.Характеристика = &Характеристика", "");
		
	КонецЕсли;
	
	Если ДанныеТекущейСтроки.Свойство("ЕдиницаИзмерения") Тогда
		
		Запрос.УстановитьПараметр("ЕдиницаИзмерения", ДанныеТекущейСтроки.ЕдиницаИзмерения);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЦеныНоменклатуры.ЕдиницаИзмерения = &ЕдиницаИзмерения", "");
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДинамикаИзмененияЦены.Очистить();
	ДинамикаИзмененияЦены.Обновление = Ложь;
	ДинамикаИзмененияЦены.ВидПодписей = ВидПодписейКДиаграмме.Значение;
	
	Серия = ДинамикаИзмененияЦены.Серии.Добавить("История цены");
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество() = 1 Тогда
			
			ФорматДатыГрафика		= Формат(Выборка.Период, "");
			ЦенаСтрокой			= Строка("0");
			НоваяТочка 			= ДинамикаИзмененияЦены.Точки.Добавить(Строка(ФорматДатыГрафика));
			ДинамикаИзмененияЦены.УстановитьЗначение(НоваяТочка, Серия, 0, , ЦенаСтрокой);
			
		КонецЕсли;
		
		Цена = Выборка.Цена;
		Если Выборка.ВалютаЦены <> НациональнаяВалюта Тогда
			Цена = РаботаСКурсамиВалют.ПересчитатьВВалюту(Выборка.Цена, Выборка.ВалютаЦены, НациональнаяВалюта,
				ТекущаяДатаСеанса());
		КонецЕсли;
		
		ФорматДатыГрафика		= Формат(Выборка.Период, "");
		ЦенаСтрокой			= Строка(Формат(Цена, "ЧЦ=15; ЧДЦ=2; ЧРГ="));
		НоваяТочка 			= ДинамикаИзмененияЦены.Точки.Добавить(Строка(ФорматДатыГрафика));
		ДинамикаИзмененияЦены.УстановитьЗначение(НоваяТочка, Серия, Цена, , ЦенаСтрокой);
		
	КонецЦикла;
	
	ДинамикаИзмененияЦены.Обновление = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициироватьЗаполнениеДиаграммы()
	
	Если Элементы.ФормаДиаграмма.Пометка Тогда
		
		ДанныеСтроки = Элементы.Список.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено Тогда
			
			ДанныеТекущейСтроки = Новый Структура("Номенклатура, ВидЦен", ДанныеСтроки.Номенклатура, ДанныеСтроки.ВидЦен);
			Если ДанныеСтроки.Свойство("Характеристика") Тогда
				
				ДанныеТекущейСтроки.Вставить("Характеристика", ДанныеСтроки.Характеристика);
				
			КонецЕсли;
			
			Если ДанныеСтроки.Свойство("ЕдиницаИзмерения") Тогда
				
				ДанныеТекущейСтроки.Вставить("ЕдиницаИзмерения", ДанныеСтроки.ЕдиницаИзмерения);
				
			КонецЕсли;
			
			ОбновитьДиаграммуНаСервере(ДанныеТекущейСтроки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДекорацияИнформацияЗакрытьНаСервере()
	
	Элементы.ГруппаПанельИнформации.Видимость = Ложь;
	
	КлючОбъекта			= ИмяФормы + "/НастройкиФормы";
	КлючНастройки = "ОтображатьПанельИнформации";
	ТекущиеНастройки 	= ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта, КлючНастройки);
	
	Если ТекущиеНастройки = Неопределено Тогда
		ТекущиеНастройки = Новый ХранилищеЗначения(Новый Структура("Видимость", Ложь));
	КонецЕсли;
	
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, КлючНастройки, ТекущиеНастройки);

КонецПроцедуры

&НаСервере
Процедура ПрочитатьИУстановитьНастройкиФормы()
	
	КлючОбъекта			= ИмяФормы + "/НастройкиФормы";
	КлючНастройки = "ОтображатьПанельИнформации";
	ТекущиеНастройки 	= ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта, КлючНастройки);
	
	Если ТекущиеНастройки <> Неопределено 
		И ТипЗнч(ТекущиеНастройки) = Тип("ХранилищеЗначения") Тогда
		
		Элементы.ГруппаПанельИнформации.Видимость = ТекущиеНастройки.Получить().Видимость;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти