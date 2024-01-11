#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция ПараметрыЗаписиРегистра(Идентификатор = Неопределено) Экспорт
	
	Результат = Новый Структура();
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		Результат.Вставить("Идентификатор", Идентификатор);
	Иначе
		Результат.Вставить("Идентификатор", Строка(Новый УникальныйИдентификатор));
	КонецЕсли;
	Результат.Вставить("ИдентификаторЭДО", Неопределено);
	Результат.Вставить("ИдентификаторМП", Неопределено);
	Результат.Вставить("ВидСообщения", Неопределено);
	Результат.Вставить("Прочитано", Неопределено);
	Результат.Вставить("ДатаПолучения", Неопределено);
	Результат.Вставить("Исходящее", Неопределено);
	Результат.Вставить("Содержимое", Неопределено);
	Результат.Вставить("ДанныеСообщения", Неопределено);
	Результат.Вставить("Автор", Неопределено);
	Результат.Вставить("ВнешнийИД", Неопределено);
	Результат.Вставить("Дата", Неопределено);
	Результат.Вставить("ИдентификаторДокумента", Неопределено);
	Результат.Вставить("ИдентификаторРодителя", Неопределено);
	Результат.Вставить("Найден", Ложь);
	Результат.Вставить("ДокументЭПД", Неопределено);
	
	Возврат Результат;
	
КонецФункции

Функция РегистрироватьЗапись(ТекущаяЗапись) Экспорт
	
	Результат = Ложь;
	
	Попытка
		НашлиЗапись = НайтиЗапись(ТекущаяЗапись);
		СервисВзаимодействияМПЭПД.ЗаполнитьЗначенияОбъекта(НашлиЗапись, ТекущаяЗапись);

		ЗаписьРегистра = СоздатьМенеджерЗаписи();
		СервисВзаимодействияМПЭПД.ЗаполнитьЗначенияОбъекта(ЗаписьРегистра, НашлиЗапись);
		
		Если ЗаписьРегистра.Исходящее = Ложь Тогда
			ЗаписьРегистра.Дата = ЗаписьРегистра.Дата + СмещениеСтандартногоВремени();
			Если ЗначениеЗаполнено(ЗаписьРегистра.ДатаПолучения) = Ложь Тогда
				ЗаписьРегистра.ДатаПолучения = ТекущаяДатаСеанса();
			КонецЕсли;
		КонецЕсли;
		ЗаписьРегистра.Записать(Истина);
	Исключение
		СервисВзаимодействияМПЭПД.РегистрацияВЖурнале(УровеньЖурналаРегистрации.Ошибка,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция РегистрироватьНабор(ТекущийОтбор, НовыйНабор) Экспорт
	
	Результат = Ложь;
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьЗапись(ТекущаяЗапись) Экспорт
	
	Результат = Ложь;
	
	Попытка
		НашлиЗапись = НайтиЗапись(ТекущаяЗапись);
		Если НашлиЗапись.Найден Тогда
			ЗаписьРегистра = СоздатьМенеджерЗаписи();
			СервисВзаимодействияМПЭПД.ЗаполнитьЗначенияОбъекта(ЗаписьРегистра, НашлиЗапись);
			ЗаписьРегистра.Удалить();
			Результат = Истина;
		КонецЕсли;
	Исключение
		СервисВзаимодействияМПЭПД.РегистрацияВЖурнале(УровеньЖурналаРегистрации.Ошибка,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция НайтиЗапись(ТекущаяЗапись) Экспорт
	
	Результат = ПараметрыЗаписиРегистра(ТекущаяЗапись.Идентификатор);
	
	Если ЗначениеЗаполнено(ТекущаяЗапись.ВнешнийИД) Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1 РАЗРЕШЕННЫЕ
		|	КэшВзаимодействияМПЭПД.Идентификатор КАК Идентификатор
		|ИЗ
		|	РегистрСведений.КэшВзаимодействияМПЭПД КАК КэшВзаимодействияМПЭПД
		|ГДЕ
		|	КэшВзаимодействияМПЭПД.ВнешнийИД = &ВнешнийИД";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("ВнешнийИД", ТекущаяЗапись.ВнешнийИД);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекущаяЗапись.Идентификатор = Выборка.Идентификатор;
		КонецЕсли;
	КонецЕсли;
	
	ЗаписьРегистра = СоздатьМенеджерЗаписи();
	ЗаписьРегистра.Идентификатор = ТекущаяЗапись.Идентификатор;
	ЗаписьРегистра.Прочитать();
	Если ЗаписьРегистра.Выбран() Тогда
		ЗаполнитьЗначенияСвойств(Результат, ЗаписьРегистра);
		Результат.Найден = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли