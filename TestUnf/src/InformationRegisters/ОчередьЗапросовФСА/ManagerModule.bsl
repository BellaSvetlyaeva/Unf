
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Создает запись о документе СС/ДС в обработке
// 
// Параметры:
//  ПараметрыДокумента - см. РаботаСНоменклатуройСлужебный.НовыеПараметрыДокументаАккредитации
//
Процедура ЗарегистрироватьКОбработке(ПараметрыДокумента) Экспорт
	
	ПараметрыЗаписи = НовыеПараметрыЗаписи();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписи, ПараметрыДокумента);
	ПараметрыЗаписи.Идентификатор = ИдентификаторДокументаАккредитации(ПараметрыДокумента);
	
	ЗаписатьНабор(ПараметрыЗаписи, Истина);
	
КонецПроцедуры

// Возвращает данные документа СС/ДС в виде URL на файл с данными
// 
// Параметры:
//  ПараметрыДокумента - см. РаботаСНоменклатуройСлужебный.НовыеПараметрыДокументаАккредитации
// 
// Возвращаемое значение:
//  Неопределено,Строка
//
Функция АдресДанных(ПараметрыДокумента) Экспорт
	
	Результат     = Неопределено;
	Идентификатор = ИдентификаторДокументаАккредитации(ПараметрыДокумента);
	Запрос        = Новый Запрос(ТекстЗапросаДанныеДокумента());
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ГиперссылкаДанные;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает ближайшую плановую дату запроса к сервису
// 
// Возвращаемое значение:
//  Неопределено,Дата
//
Функция ПлановаяДатаСледующейПопытки() Экспорт
	
	Результат = Неопределено;
	Запрос    = Новый Запрос(ТекстЗапросаПлановаяДатаСледующейПопытки());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ПлановаяДатаСледующейПопытки;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ВыполнитьОбработку() Экспорт
	
	Порция = РазмерПорцииОбработки();
	Запрос = Новый Запрос(ТекстЗапросаПорцияОчередиОбработки(Порция));
	
	Пока Истина Цикл
		Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
		
		ПорцияОчереди = Запрос.Выполнить().Выгрузить();
		Если ПорцияОчереди.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Для Каждого Элемент Из ПорцияОчереди Цикл
			ПараметрыДокумента = РаботаСНоменклатуройСлужебный.НовыеПараметрыДокументаАккредитации();
			ЗаполнитьЗначенияСвойств(ПараметрыДокумента, Элемент);
			АдресДанных = РаботаСНоменклатуройСлужебный.АдресДанныхДокументаАккредитации(ПараметрыДокумента);
			
			ПараметрыЗаписи = НовыеПараметрыЗаписи();
			ЗаполнитьЗначенияСвойств(ПараметрыЗаписи, Элемент);
			ПараметрыЗаписи.НомерПопытки = ПараметрыЗаписи.НомерПопытки + 1;
			ПараметрыЗаписи.ГиперссылкаДанные = АдресДанных;
			ПараметрыЗаписи.ДанныеПолучены = Не ПустаяСтрока(АдресДанных);
			ПараметрыЗаписи.ПлановаяДатаСледующейПопытки = ТекущаяДатаСеанса() + 
				РаботаСНоменклатуройСлужебный.ИнтервалДатыВСекундахАккредитация() * ПараметрыЗаписи.НомерПопытки;
			
			ЗаписатьНабор(ПараметрыЗаписи, Истина);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьИзОчереди(ПараметрыДокумента) Экспорт
	
	ПараметрыЗаписи = НовыеПараметрыЗаписи();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаписи, ПараметрыДокумента);
	ПараметрыЗаписи.Идентификатор = ИдентификаторДокументаАккредитации(ПараметрыДокумента);
	
	ЗаписатьНабор(ПараметрыЗаписи, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекстыЗапросов

Функция ТекстЗапросаДанныеДокумента()
	
	Возврат "ВЫБРАТЬ
	|	АккредитацияСертификатыСоответствия.ГиперссылкаДанные
	|ИЗ
	|	РегистрСведений.ОчередьЗапросовФСА КАК АккредитацияСертификатыСоответствия
	|ГДЕ
	|	АккредитацияСертификатыСоответствия.Идентификатор = &Идентификатор";
	
КонецФункции

Функция ТекстЗапросаПлановаяДатаСледующейПопытки()
	
	Возврат "ВЫБРАТЬ ПЕРВЫЕ 1
	|	АккредитацияСертификатыСоответствия.ПлановаяДатаСледующейПопытки
	|ИЗ
	|	РегистрСведений.ОчередьЗапросовФСА КАК АккредитацияСертификатыСоответствия
	|ГДЕ
	|	НЕ АккредитацияСертификатыСоответствия.ДанныеПолучены
	|
	|УПОРЯДОЧИТЬ ПО
	|	АккредитацияСертификатыСоответствия.ПлановаяДатаСледующейПопытки";
	
КонецФункции

Функция ТекстЗапросаПорцияОчередиОбработки(РазмерПорции)
	
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1000
	|	АккредитацияСертификатыСоответствия.Номер,
	|	АккредитацияСертификатыСоответствия.ДатаРегистрации,
	|	АккредитацияСертификатыСоответствия.ДатаОкончанияДействия,
	|	АккредитацияСертификатыСоответствия.ВидДокумента,
	|	АккредитацияСертификатыСоответствия.НомерПопытки,
	|	АккредитацияСертификатыСоответствия.Идентификатор
	|ИЗ
	|	РегистрСведений.ОчередьЗапросовФСА КАК АккредитацияСертификатыСоответствия
	|ГДЕ
	|	НЕ АккредитацияСертификатыСоответствия.ДанныеПолучены
	|	И АккредитацияСертификатыСоответствия.ПлановаяДатаСледующейПопытки < &ТекущаяДата
	|
	|УПОРЯДОЧИТЬ ПО
	|	АккредитацияСертификатыСоответствия.ПлановаяДатаСледующейПопытки";
	
	Возврат СтрЗаменить(ТекстЗапроса, "1000", Формат(РазмерПорции, "ЧГ=;"));
	
КонецФункции

#КонецОбласти

#Область Словарь

Функция РазмерПорцииОбработки()
	
	Возврат 100;
	
КонецФункции

#КонецОбласти

#Область Конструкторы

Функция НовыеПараметрыЗаписи()
	
	НовыеПараметрыЗаписи = Новый Структура();
	НовыеПараметрыЗаписи.Вставить("Идентификатор", "");
	НовыеПараметрыЗаписи.Вставить("ГиперссылкаДанные", "");
	НовыеПараметрыЗаписи.Вставить("ДанныеПолучены", Ложь);
	НовыеПараметрыЗаписи.Вставить("НомерПопытки", 0);
	НовыеПараметрыЗаписи.Вставить("ПлановаяДатаСледующейПопытки", Дата(1, 1, 1));
	НовыеПараметрыЗаписи.Вставить("Номер", "");
	НовыеПараметрыЗаписи.Вставить("ДатаРегистрации", Дата(1, 1, 1));
	НовыеПараметрыЗаписи.Вставить("ДатаОкончанияДействия", Дата(1, 1, 1));
	НовыеПараметрыЗаписи.Вставить("ВидДокумента", "");
	
	Возврат НовыеПараметрыЗаписи;
	
КонецФункции

#КонецОбласти

// Генерирует идентификатор документа аккредитации
// 
// Параметры:
//  ПараметрыДокумента - см. РаботаСНоменклатуройСлужебный.НовыеПараметрыДокументаАккредитации
// 
// Возвращаемое значение:
//  Строка
//
Функция ИдентификаторДокументаАккредитации(ПараметрыДокумента)
	
	Возврат ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ПараметрыДокумента);
	
КонецФункции

// Выполняет запись набора записей
// 
// Параметры:
//  ПараметрыЗаписи - см. НовыеПараметрыЗаписи
//  Добавить - Булево
//
Процедура ЗаписатьНабор(ПараметрыЗаписи, Добавить)
	
	Набор = СоздатьНаборЗаписей();
	
	Набор.Отбор.Идентификатор.Установить(ПараметрыЗаписи.Идентификатор);
	
	Блокировка = Новый БлокировкаДанных;
	Элемент = Блокировка.Добавить(Набор.Метаданные().ПолноеИмя());
	Элемент.УстановитьЗначение("Идентификатор", ПараметрыЗаписи.Идентификатор);
	Элемент.Режим = РежимБлокировкиДанных.Исключительный;
	
	Если Добавить Тогда
		ЗаполнитьЗначенияСвойств(Набор.Добавить(), ПараметрыЗаписи);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Набор.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Комментарий = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()); 
		ВызватьИсключение Комментарий;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
