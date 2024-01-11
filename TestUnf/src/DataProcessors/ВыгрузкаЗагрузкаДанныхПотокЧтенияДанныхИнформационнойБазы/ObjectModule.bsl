#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущаяИнициализация;
Перем ТекущееИмяФайла;
Перем ПотокЧтения;
Перем ТекущийОбъект;
Перем ТипТекущегоОбъекта;
Перем ТекущиеАртефакты; // см. АртефактыТекущегоОбъекта
Перем ПропускатьОшибки;
Перем Ошибки; // см. Ошибки

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФайл(Знач ИмяФайла, ИгнорироватьОшибки = Ложь) Экспорт
	
	Если ТекущаяИнициализация Тогда
		
		ВызватьИсключение НСтр("ru = 'Объект уже был инициализирован ранее.'");
		
	Иначе
		
		ТекущееИмяФайла = ИмяФайла;
	
		ПотокЧтения = Новый ЧтениеXML();
		ПотокЧтения.ОткрытьФайл(ИмяФайла);
		ПотокЧтения.ПерейтиКСодержимому();

		Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> "Data" Тогда
			
			ВызватьИсключение(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента Data.'"));
		КонецЕсли;
		
		ТипТекущегоОбъекта = ПотокЧтения.ПолучитьАтрибут("Type");

		Если НЕ ПотокЧтения.Прочитать() Тогда
			ВызватьИсключение(НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'"));
		КонецЕсли;
		
		ПропускатьОшибки = ИгнорироватьОшибки;
		Ошибки = Новый Массив();
			
		ТекущаяИнициализация = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Прочитать объект данных информационной базы.
// 
// Возвращаемое значение: 
//  Булево - Истина, если объект прочитан.
Функция ПрочитатьОбъектДанныхИнформационнойБазы() Экспорт
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
		ТекущийОбъект = Неопределено;
		ТекущиеАртефакты = Неопределено;
		Возврат Ложь;
	КонецЕсли;
		
	Если ПотокЧтения.Имя <> "DumpElement" Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента DumpElement.'");
	КонецЕсли;
	
	ПотокЧтения.Прочитать(); // <DumpElement>
	
	ТекущиеАртефакты = Новый Массив();
	
	Если ПотокЧтения.Имя = "Artefacts" Тогда
		
		ПотокЧтения.Прочитать(); // <Artefacts>
		Пока ПотокЧтения.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
			
			URIЭлемента = ПотокЧтения.URIПространстваИмен;
			ИмяЭлемента = ПотокЧтения.Имя;
			ТипАртефакта = ФабрикаXDTO.Тип(URIЭлемента, ИмяЭлемента);
			
			Попытка
				
				Артефакт = ФабрикаXDTO.ПрочитатьXML(ПотокЧтения, ТипАртефакта);
				
			Исключение
				
				ВызватьИсключениеОшибкаПриЧтенииДанных();
				
			КонецПопытки;
			
			ТекущиеАртефакты.Добавить(Артефакт);
			
		КонецЦикла;
		ПотокЧтения.Прочитать(); // </Artefacts>
		
	КонецЕсли;
	
	Если ПропускатьОшибки Тогда
		
		ФрагментОбъекта = ПрочитатьФрагментПотока();
		ПотокЧтенияОбъекта = ПотокЧтенияФрагмента(ФрагментОбъекта);
		
		Попытка
			ТекущийОбъект = СериализаторXDTO.ПрочитатьXML(ПотокЧтенияОбъекта);
		Исключение
			
			ИсходноеИсключение = ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке());
			ТекстОшибкиЧтенияXML = ТекстОшибкиЧтенияXML(ФрагментОбъекта, ИсходноеИсключение);
				
			Ошибки.Добавить(ТекстОшибкиЧтенияXML);
			ПотокЧтения.Прочитать();	
			Возврат ПрочитатьОбъектДанныхИнформационнойБазы();
			
		КонецПопытки;
		
	Иначе
		
		Попытка
			ТекущийОбъект = СериализаторXDTO.ПрочитатьXML(ПотокЧтения);
		Исключение
			ВызватьИсключениеОшибкаПриЧтенииДанных();
		КонецПопытки;
		
	КонецЕсли;
	
	ПотокЧтения.Прочитать(); // </DumpElement>
	
	Возврат Истина;
	
КонецФункции

// Возвращаемое значение: 
//  СправочникОбъект, ДокументОбъект, Структура - текущий объект.
Функция ТекущийОбъект() Экспорт
	
	Возврат ТекущийОбъект;
	
КонецФункции

// Возвращаемое значение: 
//  Строка - тип текущего объекта.
Функция ТипТекущегоОбъекта() Экспорт
	
	Возврат ТипТекущегоОбъекта;
	
КонецФункции

// Артефакты текущего объекта.
// 
// Возвращаемое значение: 
//  Массив из Произвольный - артефакты текущего объекта.
Функция АртефактыТекущегоОбъекта() Экспорт
	
	Возврат ТекущиеАртефакты;
	
КонецФункции

// Возвращает ошибки.
// 
// Возвращаемое значение: 
//  Массив из Строка
Функция Ошибки() Экспорт
	Возврат Ошибки;
КонецФункции

Процедура Закрыть() Экспорт
	
	ПотокЧтения.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Копируется текущий элемент из потока чтения XML.
//
// Параметры:
//	ПотокЧтения - ЧтениеXML - поток чтения выгрузки.
//
// Возвращаемое значение:
//	Строка - текст фрагмента XML.
//
Функция ПрочитатьФрагментПотока()
	
	ЗаписьФрагмента = Новый ЗаписьXML;
	ЗаписьФрагмента.УстановитьСтроку();
	
	ИмяУзлаФрагмента = ПотокЧтения.Имя;
	
	КорневойУзел = Истина;
	Попытка
		
		Пока НЕ (ПотокЧтения.ТипУзла = ТипУзлаXML.КонецЭлемента
				И ПотокЧтения.Имя = ИмяУзлаФрагмента) Цикл
			
			ЗаписьФрагмента.ЗаписатьТекущий(ПотокЧтения);
			
			Если ПотокЧтения.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				Если КорневойУзел Тогда
					URIПространствИмен = ПотокЧтения.КонтекстПространствИмен.URIПространствИмен();
					Для Каждого URI Из URIПространствИмен Цикл
						ЗаписьФрагмента.ЗаписатьСоответствиеПространстваИмен(ПотокЧтения.КонтекстПространствИмен.НайтиПрефикс(URI), URI);
					КонецЦикла;
					КорневойУзел = Ложь;
				КонецЕсли;
				
				ПрефиксыURIПространствИменЭлемента = ПотокЧтения.КонтекстПространствИмен.СоответствияПространствИмен();
				Для Каждого КлючИЗначение Из ПрефиксыURIПространствИменЭлемента Цикл
					Префикс = КлючИЗначение.Ключ;
					URI = КлючИЗначение.Значение;
					ЗаписьФрагмента.ЗаписатьСоответствиеПространстваИмен(Префикс, URI);
				КонецЦикла;
				
			КонецЕсли;
			
			ПотокЧтения.Прочитать();
		КонецЦикла;
		
		ЗаписьФрагмента.ЗаписатьТекущий(ПотокЧтения);
		
		ПотокЧтения.Прочитать();
	Исключение
		ТекстЖР = СтрШаблон(НСтр("ru = 'Ошибка копирования фрагмента исходного файла. Частично скопированный фрагмент:
                  |%1'"),
				ЗаписьФрагмента.Закрыть());
		
		// @skip-check module-nstr-camelcase - ошибка проверки
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выгрузка/загрузка данных.Ошибка чтения XML'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ТекстЖР);
		ВызватьИсключение;
	КонецПопытки;
	
	Фрагмент = ЗаписьФрагмента.Закрыть();
	
	Возврат Фрагмент;
	
КонецФункции

Функция ПотокЧтенияФрагмента(Знач Фрагмент)
	
	ЧтениеФрагмента = Новый ЧтениеXML();
	ЧтениеФрагмента.УстановитьСтроку(Фрагмент);
	ЧтениеФрагмента.ПерейтиКСодержимому();
	
	Возврат ЧтениеФрагмента;
	
КонецФункции

Функция ТекстОшибкиЧтенияXML(Знач Фрагмент, Знач ТекстОшибки)
	
	Возврат СтрШаблон(НСтр("ru = 'Ошибка при чтении данных из файла %1: при чтении фрагмента
              |
              |%2
              |
              |произошла ошибка:
              |
              |%3.'"),
		ТекущееИмяФайла,
		Лев(Фрагмент, 10000),
		ТекстОшибки);
	
КонецФункции

Процедура ВызватьИсключениеОшибкаПриЧтенииДанных()
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ТекущееИмяФайла);
	ПотокЧтения.ПерейтиКСодержимому();
	ПотокЧтения.Прочитать();
	
	Пока ПрочитатьПроблемныйОбъектИнформационнойБазы() Цикл
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПрочитатьПроблемныйОбъектИнформационнойБазы()
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
		ТекущийОбъект = Неопределено;
		ТекущиеАртефакты = Неопределено;
		Возврат Ложь;
	КонецЕсли;
	
	Если ПотокЧтения.Имя <> "DumpElement" Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента DumpElement.'");
	КонецЕсли;
	
	ПотокЧтения.Прочитать(); // <DumpElement>
	
	Если ПотокЧтения.Имя = "Artefacts" Тогда
		
		ПотокЧтения.Прочитать(); // <Artefacts>
		Пока ПотокЧтения.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
			
			URIЭлемента = ПотокЧтения.URIПространстваИмен;
			ИмяЭлемента = ПотокЧтения.Имя;
			ТипАртефакта = ФабрикаXDTO.Тип(URIЭлемента, ИмяЭлемента);
			
			ФрагментАртефакта = ПрочитатьФрагментПотока();
			ПотокЧтенияАртефакта = ПотокЧтенияФрагмента(ФрагментАртефакта);
			Попытка
				Артефакт = ФабрикаXDTO.ПрочитатьXML(ПотокЧтенияАртефакта, ТипАртефакта);
			Исключение
				ИсходноеИсключение = ТехнологияСервиса.КраткийТекстОшибки(ИнформацияОбОшибке());
				ВызватьИсключение ТекстОшибкиЧтенияXML(ФрагментАртефакта, ИсходноеИсключение);
			КонецПопытки;
			
		КонецЦикла;
		ПотокЧтения.Прочитать(); // </Artefacts>
		
	КонецЕсли;
	
	ФрагментОбъекта = ПрочитатьФрагментПотока();
	ПотокЧтенияОбъекта = ПотокЧтенияФрагмента(ФрагментОбъекта);
		
	Попытка
		ТекущийОбъект = СериализаторXDTO.ПрочитатьXML(ПотокЧтенияОбъекта);
	Исключение
		ИсходноеИсключение = ТехнологияСервиса.КраткийТекстОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибкиЧтенияXML(ФрагментОбъекта, ИсходноеИсключение);
	КонецПопытки;
	
	ПотокЧтения.Прочитать(); // </DumpElement>
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ТекущаяИнициализация = Ложь;

#КонецОбласти

#КонецЕсли