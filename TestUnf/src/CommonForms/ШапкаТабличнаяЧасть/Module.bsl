#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("ВидДокумента") Тогда
		
		АвтоЗаголовок = Ложь;
		УстановитьЗаголовок(Параметры.ВидДокумента);
		
	КонецЕсли;

	Если Параметры.Свойство("ДополнениеПодсказкиПоложениеСклада") Тогда
		
		ДополнениеПодсказкиПоложениеСклада = Параметры.ДополнениеПодсказкиПоложениеСклада;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокДекорацияВидимостьКолонок")
		И ЗначениеЗаполнено(Параметры.ЗаголовокДекорацияВидимостьКолонок) Тогда

		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияВидимостьКолонок", 
			"Заголовок", Параметры.ЗаголовокДекорацияВидимостьКолонок);		
		
	КонецЕсли;
		
	ЗначенияСвойствПриОткрытии = Новый Структура;
	
	ВидимыеЭлементы = Новый Массив;
	
	СчетчикВидимыхНастроек = 0;
	СчетчикПоказыватьСодержание = 0;
	СчетчикПоказыватьКолонку = 0;
	
	Для Каждого ТекИмяСвойства Из ИменаВозможныхСвойств() Цикл
		
		Если Не Параметры.Свойство(ТекИмяСвойства) Тогда
			Элементы[ТекИмяСвойства].Видимость = Ложь;
			Продолжить;
		КонецЕсли;
		
		ЭтотОбъект[ТекИмяСвойства] = Параметры[ТекИмяСвойства];
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект[ТекИмяСвойства]) Тогда
			ЭтотОбъект[ТекИмяСвойства] = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		КонецЕсли; 
		ЗначенияСвойствПриОткрытии.Вставить(ТекИмяСвойства, Параметры[ТекИмяСвойства]);
		Элементы[ТекИмяСвойства].Видимость = Истина;
		СчетчикВидимыхНастроек = СчетчикВидимыхНастроек + 1;
		Если СтрНайти(ТекИмяСвойства, "Содержание") <> 0 Тогда
			СчетчикПоказыватьСодержание = СчетчикПоказыватьСодержание + 1;
		КонецЕсли;
		Если СтрНайти(ТекИмяСвойства, "ПоказыватьКолонку") <> 0 Тогда
			СчетчикПоказыватьКолонку = СчетчикПоказыватьКолонку + 1;
		КонецЕсли;
		 
		Если СтрНайти(ТекИмяСвойства, "Валюта") > 0 Тогда
		    Элементы[ТекИмяСвойства].Видимость = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
		КонецЕсли;
		
		ВидимыеЭлементы.Добавить(ТекИмяСвойства);
	
	КонецЦикла;
	
	Если СчетчикПоказыватьСодержание > 1 Тогда
		Элементы.ДекорацияПоказыватьКолонкуСодержание.Видимость = Истина;
	КонецЕсли;
	
	ВидимостьКолонок = СчетчикПоказыватьКолонку <> 0;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияВидимостьКолонок",
			"Видимость", ВидимостьКолонок);
	
	Если Параметры.Свойство("Заголовки") Тогда
		ОбновитьЗаголовкиСвойств(Параметры.Заголовки);
	КонецЕсли; 
	
	Если Параметры.Свойство("Доступность") Тогда
		НастройкиДоступности = Параметры.Доступность;
	Иначе
		НастройкиДоступности = Новый Структура;
	КонецЕсли; 
	НастроитьДоступностьЭлементов(НастройкиДоступности);
	КлючСохраненияПоложенияОкна = СтрСоединить(ВидимыеЭлементы);
	
	Если Параметры.Свойство("РасширенныеПодсказки") Тогда
		УстановитьРасширенныеПодсказки(Параметры.РасширенныеПодсказки);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		НастроитьДоступностьЭлементов(НастройкиДоступности);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПерсональныеНастройкиНажатие(Элемент)
	
	СтруктураПараметров = Новый Структура;
	ОткрытьФорму("РегистрСведений.НастройкиПользователей.Форма.ФормаНастройкиПользователя", СтруктураПараметров);
    ИзмененыПерсональныеНастройки = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПоложениеСкладаВДокументахРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("СтрокаПоиска", НавигационнаяСсылкаФорматированнойСтроки);
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.НастройкаПрограммы", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоложениеСкладаВДокументахПоступленияПриИзменении(Элемент)
	
	Элементы.ПоложениеДокументаПоступления.Доступность = ПоложениеСкладаВДокументахПоступления = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке");
	ПоложениеДокументаПоступления = ?(ПоложениеСкладаВДокументахПоступления = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке")
	, ПоложениеДокументаПоступления, ПоложениеСкладаВДокументахПоступления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоложениеСкладаВДокументахОтгрузкиПриИзменении(Элемент)
	Элементы.ПоложениеДокументаПоступления.Доступность = ПоложениеСкладаВДокументахОтгрузки = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке");
	ПоложениеДокументаПоступления = ?(ПоложениеСкладаВДокументахОтгрузки = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке")
	, ПоложениеДокументаПоступления, ПоложениеСкладаВДокументахОтгрузки);
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(ПараметрЗакрытия());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьВыбор(Команда)
	
	ЗаписатьНовыеНастройки();
	Закрыть(ПараметрЗакрытия());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура записывает настройки пользователя в регистр.
//
&НаСервере
Процедура УстановитьНастройку(ИмяНастройки)
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	НаборЗаписей = РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Пользователь.Использование = Истина;
	НаборЗаписей.Отбор.Пользователь.Значение	  = Пользователь;
	НаборЗаписей.Отбор.Настройка.Использование	  = Истина;
	НаборЗаписей.Отбор.Настройка.Значение		  = ПланыВидовХарактеристик.НастройкиПользователей[ИмяНастройки];
	
	Запись = НаборЗаписей.Добавить();
	
	Запись.Пользователь = Пользователь;
	Запись.Настройка    = ПланыВидовХарактеристик.НастройкиПользователей[ИмяНастройки];
	Запись.Значение     = ПланыВидовХарактеристик.НастройкиПользователей[ИмяНастройки].ТипЗначения.ПривестиЗначение(ЗначениеНастройки(ИмяНастройки, ЭтотОбъект));
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеНастройки(ИмяНастройки, Форма)
	
	Если ИмяНастройки = "ПоложениеДокументаПоступления" 
		И Форма.Элементы[ИмяНастройки].Видимость
		И Не Форма.Элементы[ИмяНастройки].Доступность Тогда
		Возврат Форма[ИмяНастройки];
	КонецЕсли;
	
	Если Форма.Элементы[ИмяНастройки].Доступность Тогда
		Возврат Форма[ИмяНастройки];
	КонецЕсли;
	
	Возврат Форма.ЗначенияСвойствПриОткрытии[ИмяНастройки];
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовок(ВидДокумента)
	
	ТекстЗаголовка = НСтр("ru='Персональная настройка %1'");
	ВидДокументаТекст = ПолучитьСклоненияСтроки(ВидДокумента, "Л=ru_RU", "ПД=Родительный")[0];
	Заголовок = СтрШаблон(ТекстЗаголовка, ВидДокументаТекст);
		
КонецПроцедуры

// Процедура записывает настройки пользователя в регистр.
//
&НаСервере
Процедура ЗаписатьНовыеНастройки()
	
	Для Каждого ТекЭлемент Из ЗначенияСвойствПриОткрытии Цикл
		УстановитьНастройку(ТекЭлемент.Ключ);
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Функция БылиВнесеныИзменения()
	
	Для Каждого ТекЭлемент Из ЗначенияСвойствПриОткрытии Цикл
		Если ЭтотОбъект[ТекЭлемент.Ключ] <> ТекЭлемент.Значение Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Функция ПараметрЗакрытия()
	
	Результат = Новый Структура;
	
	Результат.Вставить("БылиВнесеныИзменения", БылиВнесеныИзменения());
	
	Для Каждого ТекЭлемент Из ЗначенияСвойствПриОткрытии Цикл
		Результат.Вставить(ТекЭлемент.Ключ, ЗначениеНастройки(ТекЭлемент.Ключ, ЭтотОбъект));
	КонецЦикла;
	
	Результат.Вставить("БылиИзмененыПерсональныеНастройки", ИзмененыПерсональныеНастройки);
	
	Возврат Результат
	
КонецФункции

&НаСервере
Функция ИменаВозможныхСвойств()
	
	Результат = Новый Массив;
	Результат.Добавить("ПоложениеВидаРаботВЗаказНаряде");
	Результат.Добавить("ПоложениеВидаРаботВЗаданииНаРаботу");
	Результат.Добавить("ПоложениеДатыОтгрузкиВЗаказеПокупателя");
	Результат.Добавить("ПоложениеДатыПоступленияВЗаказеПоставщику");
	Результат.Добавить("ПоложениеЗаказаНаПроизводствоВДокументахОтгрузки");
	Результат.Добавить("ПоложениеЗаказаПокупателяВДокументахПоступления");
	Результат.Добавить("ПоложениеЗаказаПокупателяВДокументахОтгрузки");
	Результат.Добавить("ПоложениеЗаказаПокупателяВПеремещенииЗапасов");
	Результат.Добавить("ПоложениеЗаказаПокупателяВДокументахПроизводства");
	Результат.Добавить("ПоложениеЗаказаПоставщикуВДокументахПоступления");
	Результат.Добавить("ИспользоватьМатериалыЗаказчикаВЗаказНаряде");
	Результат.Добавить("ИспользоватьТоварыВЗаказНаряде");
	Результат.Добавить("ИспользоватьМатериалыВЗаказНаряде");
	Результат.Добавить("ИспользоватьЗарплатаИсполнителейВЗаказНаряде");
	Результат.Добавить("ПоложениеИсполнитель");
	Результат.Добавить("ПоложениеОтветственный");
	Результат.Добавить("ПоложениеСкладаВДокументахПоступления");
	Результат.Добавить("ПоложениеСкладаВДокументахОтгрузки");
	Результат.Добавить("ПоложениеСкладаВДокументахПроизводства");
	Результат.Добавить("ПоложениеИсполнителяВСдельномНаряде");
	Результат.Добавить("ПоложениеСтруктурнойЕдиницыВСдельномНаряде");
	Результат.Добавить("ПоложениеЭквайринговогоТерминалаВБанковскихДокументах");
	Результат.Добавить("ПоложениеНастроекНалоговогоУчетаВБанковскихДокументах");
	Результат.Добавить("ПроверятьРасхожденияСВходящимДокументом");
	Результат.Добавить("ПроверятьРасхожденияСЗаказом");
	Результат.Добавить("ПоложениеРасходовВОтчетеПереработчика");
	Результат.Добавить("ПоложениеПроекта");
	Результат.Добавить("ПоложениеСтатьи");
	Результат.Добавить("ПоложениеПодразделенияВДенежныхДокументах");
	Результат.Добавить("ПоложениеЯчейкиОтправителя");
	Результат.Добавить("ПоложениеЯчейкиПолучателя");
	
	Результат.Добавить("ПоказыватьКолонкуАртикулВНоменклатуреУстановкиЦен");
	Результат.Добавить("ПоказыватьКолонкуАртикулВХарактеристикахУстановкиЦен");
	Результат.Добавить("ПоказыватьКолонкуШтрихкодВНоменклатуреУстановкиЦен");
	Результат.Добавить("ПоказыватьКолонкуШтрихкодВХарактеристикахУстановкиЦен");
	Результат.Добавить("ПоказыватьКолонкуКодВНоменклатуреУстановкиЦен");
	Результат.Добавить("ПоказыватьКолонкуКодВХарактеристикахУстановкиЦен");
	
	Результат.Добавить("ПоложениеДокументаПоступления");
	Результат.Добавить("ПоложениеЯчейки");
		
	// Видимость колонки "Содержание"
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВАвансовомОтчетеЗапасы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВАвансовомОтчетеРасходы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВАктеВыполненныхРабот");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВАктеОРасхожденияхЗапасы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВАктеОРасхожденияхРасходы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВАктеОРасхожденияхПолученном");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВДополнительныхРасходахРасходы");	
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВЗаказеПокупателяЗапасы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВЗаказеПокупателяРаботы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВЗаказеПоставщику");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВКорректировкеПоступленияЗапасы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВКорректировкеПоступленияРасходы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВКорректировкеРеализации");	
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВПередачеТоваровМеждуОрганизациями");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВПриходнойНакладнойЗапасы");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВПриходнойНакладнойРасходы");	
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВРасходнойНакладной");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВСчетеНаОплату");
	Результат.Добавить("ПоказыватьКолонкуСодержаниеВСчетеНаОплатуПолученном");
	// Видимость колонок "Вес" и "Объем"
	Результат.Добавить("ПоказыватьКолонкуВесВЗаказеНаПеремещение");
	Результат.Добавить("ПоказыватьКолонкуВесВЗаказеПокупателя"); 
	Результат.Добавить("ПоказыватьКолонкуВесВЗаказеПоставщику");
	Результат.Добавить("ПоказыватьКолонкуВесВПеремещенииЗапасов");
	Результат.Добавить("ПоказыватьКолонкуВесВРасходнойНакладной");
	Результат.Добавить("ПоказыватьКолонкуВесВСчетеНаОплату"); 
	Результат.Добавить("ПоказыватьКолонкуВесВСписанииЗапасов");
	Результат.Добавить("ПоказыватьКолонкуОбъемВЗаказеНаПеремещение");
	Результат.Добавить("ПоказыватьКолонкуОбъемВЗаказеПокупателя");
	Результат.Добавить("ПоказыватьКолонкуОбъемВЗаказеПоставщику");
	Результат.Добавить("ПоказыватьКолонкуОбъемВПеремещенииЗапасов");
	Результат.Добавить("ПоказыватьКолонкуОбъемВРасходнойНакладной");
	Результат.Добавить("ПоказыватьКолонкуОбъемВСчетеНаОплату");
	

	// Видимость колонок "Цена" и "Сумма"
	Результат.Добавить("ПоказыватьКолонкуЦенаВСписанииЗапасов");
	Результат.Добавить("ПоказыватьКолонкуСуммаВСписанииЗапасов");
	Результат.Добавить("ПоказыватьКолонкуРасчетныйДокументВСверкеВзаиморасчетов");
	Результат.Добавить("ПоказыватьКолонкуВалютаВСверкеВзаиморасчетов");
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьЗаголовкиСвойств(Заголовки)
	
	Для Каждого ТекЭлемент Из ЗначенияСвойствПриОткрытии Цикл
		Если Заголовки.Свойство(ТекЭлемент.Ключ) Тогда
			Элементы[ТекЭлемент.Ключ].Заголовок = Заголовки[ТекЭлемент.Ключ];
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьЭлементов(НастройкиДоступности)
	
	Для Каждого ТекЭлемент Из ЗначенияСвойствПриОткрытии Цикл
		Элементы[ТекЭлемент.Ключ].Доступность = ДоступностьСвойства(ТекЭлемент.Ключ);
		Если Элементы[ТекЭлемент.Ключ].Доступность И НастройкиДоступности.Свойство(ТекЭлемент.Ключ) Тогда
			// Доступность регулируется параметрами открытия формы
			Элементы[ТекЭлемент.Ключ].Доступность = НастройкиДоступности[ТекЭлемент.Ключ];
		КонецЕсли; 
	КонецЦикла;
	
	ОбновитьПодсказкиЭлементов();
	
КонецПроцедуры

&НаСервере
Функция ДоступностьСвойства(Знач ИмяСвойства)
	
	Если ИмяСвойства = "ПоложениеСкладаВДокументахПоступления" Тогда
		Возврат ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях");
	КонецЕсли;
	
	Если ИмяСвойства = "ПоложениеСкладаВДокументахОтгрузки" Тогда
		Возврат ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях");
	КонецЕсли;
	
	Если ИмяСвойства = "ПоложениеСкладаВДокументахПроизводства" Тогда
		Возврат ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях");
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьПодсказкиЭлементов()
	
	СписокДокументовДляПодсказки = Новый Массив;
	Если Элементы.ПоложениеСкладаВДокументахПоступления.Видимость Тогда
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Дополнительные расходы'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Заказ поставщику'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Приходная накладная'"));
		ИмяЭлементаФормы = "ПоложениеСкладаВДокументахПоступления";
	ИначеЕсли Элементы.ПоложениеСкладаВДокументахОтгрузки.Видимость Тогда
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Заказ покупателя'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Заказ-наряд'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Расходная накладная'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Передача товаров между организациями'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Чек ККМ'"));
		ИмяЭлементаФормы = "ПоложениеСкладаВДокументахОтгрузки";
	ИначеЕсли Элементы.ПоложениеСкладаВДокументахПроизводства.Видимость Тогда
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Заказ на производство'"));
		СписокДокументовДляПодсказки.Добавить(НСтр("ru='Производство'"));		
		ИмяЭлементаФормы = "ПоложениеСкладаВДокументахПроизводства";
	КонецЕсли;
	
	Если СписокДокументовДляПодсказки.Количество() <> 0 Тогда
		ПереченьДокументов = СтрСоединить(СписокДокументовДляПодсказки, ", ");
		ОбновитьПодсказкиЭлементовСклад(ИмяЭлементаФормы, ПереченьДокументов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПодсказкиЭлементовСклад(ИмяЭлементаФормы, ПереченьДокументов)

	СкладыВТабличныхЧастях = ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях");
	ШаблонТекстаПодсказки = НСтр("ru='Определяет положение поля ""Склад"" в документах %1. '")
		+ Символы.ПС;
    ТекстПодсказки = СтрШаблон(ШаблонТекстаПодсказки, ПереченьДокументов);
	
	Если Элементы[ИмяЭлементаФормы].Доступность Тогда
		Элементы.ГруппаПоложениеСкладаВДокументахРасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("РазрешитьСкладыВТабличныхЧастях") Тогда
		ТекстУсловий = НСтр("ru='Для возможности настройки включите опцию <a href = ""Разрешить склады в табличных частях"">Разрешить склады в табличных частях</a>'");
		ТекстЗаголовка = СтроковыеФункции.ФорматированнаяСтрока(ТекстПодсказки + ТекстУсловий);
		Элементы.ГруппаПоложениеСкладаВДокументахРасширеннаяПодсказка.Заголовок = ТекстЗаголовка;
		Возврат;
	КонецЕсли;
		
	Если НЕ ПустаяСтрока(ДополнениеПодсказкиПоложениеСклада) Тогда
		ТекстЗаголовка = СтроковыеФункции.ФорматированнаяСтрока(ТекстПодсказки + ДополнениеПодсказкиПоложениеСклада);
		Элементы.ГруппаПоложениеСкладаВДокументахРасширеннаяПодсказка.Заголовок = ТекстЗаголовка;
		Возврат;
	КонецЕсли;		

	Элементы.ГруппаПоложениеСкладаВДокументахРасширеннаяПодсказка.Заголовок = ТекстПодсказки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасширенныеПодсказки(ДанныеРасширенныхПодсказок)
	
	Для Каждого ТекЭлемент Из ДанныеРасширенныхПодсказок Цикл
		// Без предварительной очистки значение не поменяется, если отличие только в гиперссылке, а текст полностью совпадает
		Элементы[ТекЭлемент.Ключ].РасширеннаяПодсказка.Заголовок = "";
		Элементы[ТекЭлемент.Ключ].РасширеннаяПодсказка.Заголовок = ДанныеРасширенныхПодсказок[ТекЭлемент.Ключ];
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПоложениеЭквайринговогоТерминалаВБанковскихДокументахРасширеннаяПодсказкаОбработкаНавигационнойСсылки(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбработкаНавигационнойСсылкиСРеквизитом(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиСРеквизитом(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	МассивСтрок1 = СтрРазделить(НавигационнаяСсылкаФорматированнойСтроки, ".");
	КорректноеКоличествоЭлементовМассива1 = 3;
	
	Если МассивСтрок1.Количество() = КорректноеКоличествоЭлементовМассива1 Тогда
		МассивСтрок2 = СтрРазделить(МассивСтрок1[2], "?");
		КорректноеКоличествоЭлементовМассива2 = 2;
		Если МассивСтрок2.Количество() = КорректноеКоличествоЭлементовМассива2 Тогда
			СтандартнаяОбработка = Ложь;
			
			НавигационнаяСсылкаБезРеквизита = МассивСтрок1[0] + "." + МассивСтрок1[1] + "?" + МассивСтрок2[1];  
			
			СсылкаНаОбъект = СсылкаНаОбъектИзНавигационнойСсылки(НавигационнаяСсылкаБезРеквизита); 
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Ключ", СсылкаНаОбъект);
			СтруктураПараметров.Вставить("ВыделитьЭлемент", МассивСтрок2[0]);
			
			ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента", СтруктураПараметров, ЭтотОбъект);

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СсылкаНаОбъектИзНавигационнойСсылки(НавигационнаяСсылка)
    
	ПервыйПрефикс = "e1cib/data/";
	ВторойПрефикс = "?ref=";
	ПерваяТочка = СтрНайти(НавигационнаяСсылка, ПервыйПрефикс);
	ВтораяТочка = СтрНайти(НавигационнаяСсылка, ВторойПрефикс);
	ДлинаПервогоПрефикса = СтрДлина(ПервыйПрефикс);
	ДлинаВторогоПрефикса = СтрДлина(ВторойПрефикс);
	
	ПредставлениеТипа   = Сред(НавигационнаяСсылка, ПерваяТочка + ДлинаПервогоПрефикса,
		ВтораяТочка - ПерваяТочка - ДлинаПервогоПрефикса);
	ШаблонЗначения = ЗначениеВСтрокуВнутр(ПредопределенноеЗначение(ПредставлениеТипа + ".ПустаяСсылка"));
	УникальныйИдентификаторСтрокой = Сред(НавигационнаяСсылка, ВтораяТочка + ДлинаВторогоПрефикса);
	ЗначениеСсылки = СтрЗаменить(ШаблонЗначения, "00000000000000000000000000000000", УникальныйИдентификаторСтрокой);
	
	Возврат ЗначениеИзСтрокиВнутр(ЗначениеСсылки);
    
КонецФункции   



#КонецОбласти
