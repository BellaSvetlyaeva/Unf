#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициироватьПодсказки();
	Если Не ЗначениеЗаполнено( Запись.Статус ) Тогда
		Элементы.ИдентификаторПубликации.Видимость = Ложь;
		Элементы.ГруппаЕслиСоздание.Видимость = Истина;
		Элементы.Номенклатура.ТолькоПросмотр = Ложь;
		Элементы.Характеристика.ТолькоПросмотр = Ложь;
		
	Иначе
		Элементы.ИдентификаторПубликации.Видимость = Истина;
		Элементы.ГруппаЕслиСоздание.Видимость = Ложь;
		Элементы.Номенклатура.ТолькоПросмотр = Истина;
		Элементы.Характеристика.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	Элементы.Статус.ЦветТекста = ПолучитьЦветТекстаПоМаркеру();
	ИнициализироватьСтраницы();
	ОбновитьПредставлениеТовара();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЯНеЗнаюНажатие(Элемент)
	
	Элементы.ПодсказкаЯНеЗнаюSKU.Видимость = НЕ Элементы.ПодсказкаЯНеЗнаюSKU.Видимость; 
	Если Элементы.ПодсказкаЯНеЗнаюSKU.Видимость Тогда
		Элементы.ПодсказкаЯЗнаюSKU.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЯЗнаюSKUНажатие(Элемент)
	
	Элементы.ПодсказкаЯЗнаюSKU.Видимость = НЕ Элементы.ПодсказкаЯЗнаюSKU.Видимость;
	Если Элементы.ПодсказкаЯЗнаюSKU.Видимость Тогда
		Элементы.ПодсказкаЯНеЗнаюSKU.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЦветТекстаПоМаркеру()
	
	Если Запись.МаркерСтатуса = 0 Тогда
		Цвет = ЦветаСтиля.ЦветОсобогоТекста;
	ИначеЕсли Запись.МаркерСтатуса = 1 Тогда
		Цвет = ЦветаСтиля.ЦветВажного;
	ИначеЕсли Запись.МаркерСтатуса = 2 Тогда
		Цвет = ЦветаСтиля.ЦветПустойГиперссылки;
	ИначеЕсли Запись.МаркерСтатуса = 3 Тогда 
		Цвет = ЦветаСтиля.ЦветАкцента;
	КонецЕсли;
	
	Возврат Цвет;

КонецФункции

&НаСервере
Процедура ИнициализироватьСтраницы()
	
	Элементы.СтраницаДанныеСвязи.ТолькоПросмотр = Ложь;
	Элементы.СтраницаДанныеТовара.ТолькоПросмотр = Ложь;
	Элементы.СообщениеОНедоступности.Видимость = Ложь;
	Элементы.СтраницаОписаниеОшибки.Видимость = Ложь;
	
	Если Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.НаМодерации
		ИЛИ  Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.МодерацияПройдена
		ИЛИ  Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.УтвержденаРекомендация Тогда
		
		Элементы.СтраницаДанныеСвязи.ТолькоПросмотр = Истина;
		Элементы.СообщениеОНедоступности.Видимость = Истина;
		Элементы.ПолучитьРекомендацию.Видимость = Ложь;
		Элементы.ОтправитьНаМодерацию.Видимость = Ложь;
		Элементы.УтвердитьРекомендацию.Видимость = Ложь;
		Элементы.ОтклонитьРекомендацию.Видимость = Ложь;
		
	ИначеЕсли Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ПолученаРекомендация Тогда
		
		Элементы.ПолучитьРекомендацию.Видимость = Ложь;
		Элементы.ОтправитьНаМодерацию.Видимость = Ложь;
		Элементы.УтвердитьРекомендацию.Видимость = Истина;
		Элементы.ОтклонитьРекомендацию.Видимость = Истина;
	Иначе
		
		Элементы.ПолучитьРекомендацию.Видимость = Истина;
		Элементы.ОтправитьНаМодерацию.Видимость = Истина;
		Элементы.УтвердитьРекомендацию.Видимость = Ложь;
		Элементы.ОтклонитьРекомендацию.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Запись.МаркерСтатуса = 0 И НЕ Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ПустаяСсылка() Тогда // красный
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОписаниеОшибки;
		Элементы.СтраницаОписаниеОшибки.Видимость = Истина;
		
	ИначеЕсли Запись.МаркерСтатуса = 1 Тогда // желтый
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДанныеСвязи;
		
	ИначеЕсли Запись.МаркерСтатуса = 2 Тогда // серый
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДанныеТовара;
		
	ИначеЕсли Запись.МаркерСтатуса = 3  ИЛИ Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.ПустаяСсылка() Тогда // зеленый
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДанныеТовара;
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ИнициироватьПодсказки()
	
	Элементы.ПодсказкаЯЗнаюSKU.Заголовок = 
	НСтр("ru = 'Если уже знаете SKU товара на Маркете, заполните информацию "
	+ "на закладке ""Данные связи"" и отправьте товар на модерацию (кнопка ""Отправить на модерацию"").'");
	
	Элементы.ПодсказкаЯНеЗнаюSKU.Заголовок = 
	НСтр("ru = 'Если не знаете SKU товара на Маркете, "
	+ "получите информацию о рекомендованных связях - проверьте информацию о товаре на закладке "
	+ """Данные товара"", при необходимости дозаполните недостающую информацию и нажмите кнопку "
	+ """Получить рекомендацию"". Все поля на закладке ""Данные товара"" необязательны, но " 
	+ "рекомендованы к заполнению - подробное описание свойств товара увеличит вероятность "
	+ "подбора правильной рекомендации. Дождитесь результатного статуса, после смены статуса "
	+ " переходите к проверке и утверждению рекомендованной связи.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиПоСсылкеНажатие(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ГиперссылкаНаРекомендованныеТовар) Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку( Запись.ГиперссылкаНаРекомендованныеТовар );
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Заполните поле ""Гиперссылка на пример товара""'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаМодерациюНаСервере()
	
	Если ЗначениеЗаполнено(Запись.ИдентификаторТовараПлощадки) Тогда
		Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.УтвержденаРекомендация;	
	Иначе
		Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.СозданиеНового;
	КонецЕсли;
	Если ПустаяСтрока( Запись.НаименованиеТовараПлощадки ) Тогда
		Запись.НаименованиеТовараПлощадки = Запись.ПредставлениеТовара;
	КонецЕсли;
	ЭтотОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНаМодерацию(Команда)  
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Запись.Номенклатура) Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Заполните поле Номенклатура'"),,
		,,
		Отказ);	
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ОтправитьНаМодерациюНаСервере();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтклонитьРекомендациюНаСервере()
	
	Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.НевернаяРекомендация;
	Запись.ОписаниеОшибки = 
	"Если товар определен неправильно: 
	|Проверьте, что товар относится к одной из категорий, представленных на Маркете.
	|Убедитесь, что предоставили наиболее полные и точные данные о товаре. 
	|Если не указана какая-либо информация, уточните входные данные запроса "
	+ "(например, добавьте цвет или размер в характеристики товара или добавьте описание модели, "
	+ "скорректировав данные в поле ""Представление"" на закладке ""Данные о товаре"", "
	+ "укажите базовую цену товара, если она не заполнена).
	|После заполнения данных отправьте повторно публикацию на получение "
	+ "рекомендации (кнопка ""Получить рекомендацию""). 
	|Попробуйте найти товар в поиске по разделу «Покупки» на Маркете. Если товар найдется, "
	+ "SKU на Яндексе можно взять из URL его страницы. Например, если URL страницы товара "
	+ "- https://pokupki.market.yandex.ru/product/7715752, то его SKU на Яндексе - 7715752. "
	+ "Если советы не помогли - отправьте информацию о товаре без SKU на Яндексе "
	+ "(кнопка ""Отправить на модерацию"") - сотрудники Маркета могут подобрать "
	+ "или создать карточки для ваших товаров в личном кабинете, если товар еще не продается на Маркете.";				
	ЭтотОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьРекомендацию(Команда) 
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Запись.Номенклатура) Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Заполните поле Номенклатура'"),,
		,,
		Отказ);	
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ОтклонитьРекомендациюНаСервере();
		Закрыть(); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УтвердитьРекомендациюНаСервере()
	
	Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.УтвержденаРекомендация;	
	ЭтотОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура УтвердитьРекомендацию(Команда)
	Отказ = Ложь;   
	
	Если НЕ ЗначениеЗаполнено(Запись.Номенклатура) Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Заполните поле Номенклатура'"),,
		,,
		Отказ);	
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		УтвердитьРекомендациюНаСервере();
		Закрыть();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПолучитьРекомендациюНаСервере()
	
	Запись.Статус = Перечисления.СтатусыВыгрузкиТоваровЯндексМаркет.Новый;
	ЭтотОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьРекомендацию(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Запись.Номенклатура) Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Заполните поле Номенклатура'"),,
		,,
		Отказ);	
	КонецЕсли;     
	
	Если НЕ Отказ Тогда	
		ПолучитьРекомендациюНаСервере();
		Закрыть(); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеТовара()
	
	Если Не ЗначениеЗаполнено( Запись.Номенклатура ) Тогда
		Возврат;
	КонецЕсли;
	
	ХарактеристикаСтрока = ?( ЗначениеЗаполнено( Запись.Характеристика ), ", " + Запись.Характеристика, "" );
	
	Запись.ПредставлениеТовара = "" + Запись.Номенклатура + ХарактеристикаСтрока;
	Запись.КатегорияНоменклатуры = Запись.Номенклатура.КатегорияНоменклатуры;
	
	ОбновитьДопИнфо();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДопИнфо()
	
	Если Запись.КатегорияНоменклатуры <> "" Тогда 		
		ШаблонСообщения = НСтр("ru = 'Категория: %1'") + Символы.ПС;
		КатегорияНоменклатуры = СтрШаблон(ШаблонСообщения, Запись.КатегорияНоменклатуры);
	Иначе	
		КатегорияНоменклатуры  = НСтр("ru = 'Категория: не указана'") + Символы.ПС;
	КонецЕсли;
	
	Если Запись.Номенклатура.Артикул <> "" Тогда 
		ШаблонСообщения = НСтр("ru = 'Артикул: %1'") + Символы.ПС;
		Артикул = СтрШаблон(ШаблонСообщения, Запись.Номенклатура.Артикул);
	Иначе	
		Артикул  = НСтр("ru = 'Артикул: не указан'") + Символы.ПС;
	КонецЕсли;
	
	Если Запись.Номенклатура.Производитель <> Справочники.Контрагенты.ПустаяСсылка() Тогда 
		ШаблонСообщения = НСтр("ru = 'Производитель: %1'") + Символы.ПС;
		Производитель = СтрШаблон(ШаблонСообщения, Запись.Номенклатура.Производитель.Наименование);					
	Иначе	
		Производитель  = НСтр("ru = 'Производитель: не указан'") + Символы.ПС;
	КонецЕсли;
	
	Если Запись.Номенклатура.СтранаПроисхождения <> Справочники.СтраныМира.ПустаяСсылка() Тогда 		
		ШаблонСообщения = НСтр("ru = 'Страна происхождения: %1'") + Символы.ПС;
		Страна = СтрШаблон(ШаблонСообщения, Запись.Номенклатура.СтранаПроисхождения.Наименование);		
	Иначе	
		Страна  = НСтр("ru = 'Страна происхождения: не указана'") + Символы.ПС;
	КонецЕсли;
	
	ЕстьШтрихКоды = ПолучитьШтрихКоды().Количество()>0; 
	
	Если  ЕстьШтрихКоды Тогда
		ШтрихКоды  = НСтр("ru = 'Штрих-коды: указаны'") + Символы.ПС;
	Иначе
		ШтрихКоды  = НСтр("ru = 'Штрих-коды: не указаны'") + Символы.ПС;
	КонецЕсли;
	
	ДанныеВесогабаритов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Номенклатура,
	"Вес,Высота,Длина,Ширина");
	
	Весогабариты =  ИнтеграцияСЯндексМаркетСервер.ПолучитьВесогабариты(ДанныеВесогабаритов.Вес,
	ДанныеВесогабаритов.Высота,
	ДанныеВесогабаритов.Длина,
	ДанныеВесогабаритов.Ширина
	);
	
	ВесогабаритыЗаголовок = НСтр("ru = 'Весогабариты:'") + Символы.ПС;
	
	Если Весогабариты.length <>"" Тогда   
		ШаблонСообщения = "	" + НСтр("ru = 'Длина: %1 см'") + Символы.ПС;
		ВесогабаритыДлина = СтрШаблон(ШаблонСообщения, Число(Весогабариты.length));		
	Иначе
		ВесогабаритыДлина = НСтр("ru = '	Длина: не указана'") + Символы.ПС;
	КонецЕсли;  
	
	Если Весогабариты.width <>"" Тогда  
		ШаблонСообщения = "	" + НСтр("ru = 'Ширина: %1 см'") + Символы.ПС;
		ВесогабаритыШирина = СтрШаблон(ШаблонСообщения, Число(Весогабариты.width));	
	Иначе
		ВесогабаритыШирина = "	" + НСтр("ru = 'Ширина: не указана'") + Символы.ПС;
	КонецЕсли; 
	
	Если Весогабариты.height <>"" Тогда    
		ШаблонСообщения = "	" + НСтр("ru = 'Высота: %1 см'") + Символы.ПС;
		ВесогабаритыВысота = СтрШаблон(ШаблонСообщения, Число(Весогабариты.height));	
	Иначе
		ВесогабаритыВысота = "	" + НСтр("ru = 'Высота: не указана'") + Символы.ПС;
	КонецЕсли; 
	
	Если Весогабариты.weight <>"" Тогда   
		ШаблонСообщения = "	" + НСтр("ru = 'Вес: %1 см'") + Символы.ПС;
		ВесогабаритыВес = СтрШаблон(ШаблонСообщения, Число(Весогабариты.weight));	
	Иначе
		ВесогабаритыВес = "	" + НСтр("ru = 'Вес: не указан'") + Символы.ПС;
	КонецЕсли;  
	
	ДопИнфо = КатегорияНоменклатуры + Артикул 
	+ Производитель + Страна + ШтрихКоды + ВесогабаритыЗаголовок
	+ ВесогабаритыДлина + ВесогабаритыШирина + ВесогабаритыВысота + ВесогабаритыВес;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьШтрихКоды()
	
	Запрос = Новый Запрос ();
	Запрос.Параметры.Вставить("Номенклатура",Запись.Номенклатура);
	Запрос.Параметры.Вставить("Характеристика",Запись.Характеристика);
	Запрос.Текст = "ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
	|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура
	|	И ШтрихкодыНоменклатуры.Характеристика = &Характеристика";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ШтрихКоды = Новый Массив;
	
	Если Результат.Количество()>0 Тогда
		ШтрихКоды = Результат.ВыгрузитьКолонку("Штрихкод");
	КонецЕсли;	
	
	Возврат ШтрихКоды;
КонецФункции

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	ОбновитьПредставлениеТовара();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	
	ОбновитьПредставлениеТовара();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Оповестить( "ПриЗакрытии", ЭтаФорма.ИмяФормы, ЭтаФорма );
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОбновитьПредставлениеТовара(Команда)
	ОбновитьПредставлениеТовара();
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти
