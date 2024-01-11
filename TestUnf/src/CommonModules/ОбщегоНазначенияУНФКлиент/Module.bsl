#Область ПрограммныйИнтерфейс

// Функция возвращает представление дня недели.
// Параметры:
// 	ДеньНеделиКалендаря - Число
// Возвращаемое значение:
// 	Строка - представление дня недели.
Функция ПредставлениеДняНедели(ДеньНеделиКалендаря) Экспорт
	
	НомерДняНедели = ДеньНедели(ДеньНеделиКалендаря);
	Если НомерДняНедели = 1 Тогда
		
		Возврат НСтр("ru = 'Пн'");
		
	ИначеЕсли НомерДняНедели = 2 Тогда
		
		Возврат НСтр("ru = 'Вт'");
		
	ИначеЕсли НомерДняНедели = 3 Тогда
		
		Возврат НСтр("ru = 'Ср'");
		
	ИначеЕсли НомерДняНедели = 4 Тогда
		
		Возврат НСтр("ru = 'Чт'");
		
	ИначеЕсли НомерДняНедели = 5 Тогда
		
		Возврат НСтр("ru = 'Пт'");
		
	ИначеЕсли НомерДняНедели = 6 Тогда
		
		Возврат НСтр("ru = 'Сб'");
		
	ИначеЕсли НомерДняНедели = 7 Тогда
		
		Возврат НСтр("ru = 'Вс'");
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Недопустимый номер дня недели: ""%1"".'"), НомерДняНедели);
		
	КонецЕсли;
	
КонецФункции

// Заполняет структуру данных для открытия формы выбора календаря
// 
// Параметры:
// 	ДатаКалендаряПриОткрытии - Дата - .
// 	ЗакрыватьПриВыборе - Булево - .
// 	МножественныйВыбор - Булево - .
// Возвращаемое значение:
// 	Структура - .
Функция ПараметрыОткрытияФормыКалендаря(ДатаКалендаряПриОткрытии, ЗакрыватьПриВыборе = Истина,
	МножественныйВыбор = Ложь) Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ДатаКалендаря", ДатаКалендаряПриОткрытии);
	Результат.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);
	Результат.Вставить("МножественныйВыбор", МножественныйВыбор);
	
	Возврат Результат;

КонецФункции

// Устанавливает период через стандартный диалог выбора периода
//
// Параметры:
//  Объект                - Произвольный - Объект в котором устанавливается значения периода
//  ПараметрыПериода      - Структура - структура со свойствами "ДатаНачала", "ДатаОкончания" и в значениях имена полей
//                              объекта, для свойства "Вариант" - значение варианта стандартного периода.
//  ОповещениеПослеВыбора - ОписаниеОповещения - Описание оповещение которое выполняется после установки периода.
//                              Может быть установлена пост-обработка в месте вызова после выбора периода.
Процедура РедактироватьПериод(Объект, ПараметрыПериода = Неопределено, ОповещениеПослеВыбора = Неопределено) Экспорт
	
	Если ПараметрыПериода = Неопределено Тогда
		ПараметрыПериода = Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачала", "ДатаОкончания");
	КонецЕсли;
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Если ПараметрыПериода.Свойство("ДатаНачала") Тогда
		Диалог.Период.ДатаНачала = Объект[ПараметрыПериода.ДатаНачала];
	КонецЕсли;
	Если ПараметрыПериода.Свойство("ДатаОкончания") Тогда
		Диалог.Период.ДатаОкончания = Объект[ПараметрыПериода.ДатаОкончания];
	КонецЕсли;
	Если ПараметрыПериода.Свойство("Вариант") Тогда
		Диалог.Период.Вариант = ПараметрыПериода.Вариант;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ПараметрыПериода", ПараметрыПериода);
	Если ОповещениеПослеВыбора <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ОповещениеПослеВыбора", ОповещениеПослеВыбора);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("РедактироватьПериодЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Открывает форму редактирования многострочного комментария.
//
// Параметры:
//  МногострочныйТекст - Строка - произвольный текст, который необходимо отредактировать.
//  ФормаВладелец      - ФормаКлиентскогоПриложения - форма, в поле которой выполняется ввод комментария.
//  ПоляРеквизита      - Структура
//  Заголовок          - Строка - текст, который необходимо отобразить в заголовке формы.
//                                По умолчанию: "Комментарий".
//
Процедура ПоказатьФормуРедактированияРеквизита(МногострочныйТекст, ФормаВладелец, ПоляРеквизита, Заголовок) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец, ПоляРеквизита", ФормаВладелец, ПоляРеквизита);
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("РеквизитЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	
КонецПроцедуры

// Процедура показывает переданное сообщение в отдельной форме
// также в форме может быть отражена гиперссылка
//
// Параметры:
//  ПараметрыСообщения - Структура
//     - поля структуры:
//        - Заголовок            - Строка - текст заголовка формы
//        - Сообщение            - Строка - текст сообщения
//        - ГиперссылкаТекст     - Строка - (необязательный) представление объекта
//        - ГиперссылкаНавигация - Строка - (необязательный) навигационная ссылка объекта
//        - ГиперссылкаИмяФормы  - Строка - (необязательный) имя формы по гиперссылке
//        - ГиперссылкаПараметры - Строка - (необязательный) параметры формы по гиперссылке
//
Процедура ПоказатьСообщениеВФорме(ПараметрыСообщения) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.ФормаСообщение", ПараметрыСообщения);
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриУстановкеЗаголовкаКлиентскогоПриложения.
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	
	ПараметрыКлиента = ?(ПриЗапуске, СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента());
	
	Если НЕ ПараметрыКлиента.Свойство("ТребуетсяЗаменитьЗаголовокПриложения") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыКлиента.ТребуетсяЗаменитьЗаголовокПриложения Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ СтрЗаканчиваетсяНа(ЗаголовокПриложения, "/ Управление нашей фирмой, редакция 3.0") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокПриложения = СтрЗаменить(ЗаголовокПриложения, "/ Управление нашей фирмой, редакция 3.0", "/ Розница, редакция 3.0");
		
КонецПроцедуры

// Актуализирует заголовок приложения в связи с обновлением курсов валют
Процедура АктуализироватьЗаголовокПриложения() Экспорт
	
	ИмяПараметра = "Валюты.АктуализацияЗаголовкаПриложения";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура());
		
		ФОУчетВалютныхОпераций =
			УправлениеНебольшойФирмойВызовСервера.ПолучитьКонстантуСервер("ФункциональнаяУчетВалютныхОпераций");
			
		ТребуетсяАктуализация = ФОУчетВалютныхОпераций И Не ВалютыУНФВызовСервера.КурсыВалютАктуальны();
		ПараметрыПриложения[ИмяПараметра].Вставить("ТребуетсяАктуализацияЗаголовкаПриложения", ТребуетсяАктуализация);
		
		Если ПараметрыПриложения[ИмяПараметра].ТребуетсяАктуализацияЗаголовкаПриложения Тогда
			ПараметрыПриложения[ИмяПараметра].Вставить("ИнтервалОбновления", 300); // 5 минут
			ВремяСледующегоОбновления = ОбщегоНазначенияКлиент.ДатаСеанса()
				+ ПараметрыПриложения[ИмяПараметра].ИнтервалОбновления;
			ПараметрыПриложения[ИмяПараметра].Вставить("ВремяСледующегоОбновления", ВремяСледующегоОбновления);
			ПараметрыПриложения[ИмяПараметра].Вставить("СчетчикПопыток", 3);
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыПриложения[ИмяПараметра].ТребуетсяАктуализацияЗаголовкаПриложения
		И ПараметрыПриложения[ИмяПараметра].ВремяСледующегоОбновления <= ОбщегоНазначенияКлиент.ДатаСеанса()
		И ПараметрыПриложения[ИмяПараметра].СчетчикПопыток > 0 Тогда
		
		Если ВалютыУНФВызовСервера.КурсыВалютАктуальны() Тогда
			СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();	
			ПараметрыПриложения[ИмяПараметра].ТребуетсяАктуализацияЗаголовкаПриложения = Ложь;
		Иначе
			ПараметрыПриложения[ИмяПараметра].СчетчикПопыток = ПараметрыПриложения[ИмяПараметра].СчетчикПопыток - 1;
			ВремяСледующегоОбновления = ОбщегоНазначенияКлиент.ДатаСеанса()
				+ ПараметрыПриложения[ИмяПараметра].ИнтервалОбновления;
			ПараметрыПриложения[ИмяПараметра].Вставить("ВремяСледующегоОбновления", ВремяСледующегоОбновления);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура РеквизитЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКРеквизитуФормыПоТипам = ДополнительныеПараметры.ПоляРеквизита;
	ДополнительныеПараметры.ФормаВладелец[ПутьКРеквизитуФормыПоТипам.Объект][ПутьКРеквизитуФормыПоТипам.ТабЧасть][ПутьКРеквизитуФормыПоТипам.НомерСтроки][ПутьКРеквизитуФормыПоТипам.ИмяРеквизита] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	ДополнительныеПараметры.ФормаВладелец.ОбновитьОтображениеДанных();
#КонецЕсли 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РедактироватьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт

	ПараметрыПериода = ДополнительныеПараметры.ПараметрыПериода;
	Объект = ДополнительныеПараметры.Объект;
	Если Период <> Неопределено Тогда
		Если ПараметрыПериода.Свойство("ДатаНачала") Тогда
			Объект[ПараметрыПериода.ДатаНачала] = Период.ДатаНачала;
		КонецЕсли;
		Если ПараметрыПериода.Свойство("ДатаОкончания") Тогда
			Объект[ПараметрыПериода.ДатаОкончания] = Период.ДатаОкончания;
		КонецЕсли;
		Если ПараметрыПериода.Свойство("Вариант") Тогда
			Объект[ПараметрыПериода.Вариант] = Период.Вариант;
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеПослеВыбора") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеВыбора, Период);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти