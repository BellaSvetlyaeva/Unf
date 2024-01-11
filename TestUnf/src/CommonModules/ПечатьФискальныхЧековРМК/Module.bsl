
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет структуру шаблона чека по исходным данным
//
// Параметры:
//  ПараметрыЧека - Структура
//  СтрокаОсновногоРаздела - СтрокаДереваЗначений
//  ТаблицаДанных - ТаблицаЗначений - см. ПечатьФискальныхЧековРМК.ТаблицаСКД()
//  ФискальныеПозицииЧека - Структура
//
Процедура ОбработатьСоставЧека(ПараметрыЧека, СтрокаОсновногоРаздела, ТаблицаДанных, ФискальныеПозицииЧека = Неопределено) Экспорт
	
	СтрокаШапкиЧека = Неопределено;
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяТаблицы", "СоставЧека");
	СтрокиВыборки = ТаблицаДанных.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого СтрокаВыборки Из СтрокиВыборки Цикл
		
		СтрокаШапкиЧека = СтрокаВыборки;
		Прервать;
		
	КонецЦикла;
	
	Если СтрокаОсновногоРаздела.ИмяКолонки = "Текст" Тогда
		
		Если СтрокаОсновногоРаздела.ВыводитьКакШтрихкод Тогда
			ОбработатьДанныеШтрихкода(ПараметрыЧека, СтрокаОсновногоРаздела, СтрокаШапкиЧека, ТаблицаДанных);
		Иначе
			ОбработатьТекстовуюСтроку(ПараметрыЧека, СтрокаОсновногоРаздела, СтрокаШапкиЧека, ТаблицаДанных);
		КонецЕсли;
		
	ИначеЕсли СтрокаОсновногоРаздела.ИмяКолонки = "СоставнаяСтрока" Тогда
		ОбработатьСоставнуюСтроку(ПараметрыЧека, СтрокаОсновногоРаздела, СтрокаШапкиЧека, ТаблицаДанных);
	ИначеЕсли СтрокаОсновногоРаздела.ИмяКолонки = "Таблица" Тогда
		
		СтруктураОтбора = Новый Структура;
		ИмяТаблицы = СтрокаОсновногоРаздела.Элемент;
		СтруктураОтбора.Вставить("ИмяТаблицы", ИмяТаблицы);
		СтрокиВыборки = ТаблицаДанных.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого СтрокаВыборки Из СтрокиВыборки Цикл
			
			Для Каждого ПоляСтрокиТаблицы Из СтрокаОсновногоРаздела.Строки Цикл
				Если ПоляСтрокиТаблицы.ИмяКолонки = "СоставнаяСтрока" Тогда
					ОбработатьСоставнуюСтроку(ПараметрыЧека, ПоляСтрокиТаблицы, СтрокаШапкиЧека,
						ТаблицаДанных, СтрокаВыборки, ИмяТаблицы);
				ИначеЕсли ПоляСтрокиТаблицы.ИмяКолонки = "Текст" Тогда
					
					Если ПоляСтрокиТаблицы.ВыводитьКакШтрихкод Тогда
						ОбработатьДанныеШтрихкода(ПараметрыЧека, ПоляСтрокиТаблицы, СтрокаШапкиЧека,
							ТаблицаДанных, СтрокаВыборки, ИмяТаблицы);
					Иначе
						ОбработатьТекстовуюСтроку(ПараметрыЧека, ПоляСтрокиТаблицы, СтрокаШапкиЧека,
							ТаблицаДанных, СтрокаВыборки, ИмяТаблицы);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	ИначеЕсли СтрокаОсновногоРаздела.ИмяКолонки = "ТаблицаТовары" Тогда
		
		Если ФискальныеПозицииЧека = Неопределено Тогда
			
			СтрокаИсключения =
				НСтр("ru = 'Некорректно настроен шаблон чека. Отсутствует фискальный раздел в таблице товаров.'");
			ВызватьИсключение СтрокаИсключения;
			
		КонецЕсли;
		
		ПоследняяСтрока = 0;
		ИндексПоследнейПозиции = ФискальныеПозицииЧека.ВГраница();
		ИндексТекущейПозиции = 0;
		ИмяТаблицы = СтрокаОсновногоРаздела.Элемент;
		
		Пока ИндексТекущейПозиции <= ИндексПоследнейПозиции Цикл
			
			СтрокаВыборки = ФискальныеПозицииЧека[ИндексТекущейПозиции];
			ФискальныйРазделБыл = Ложь;
			ВыводитьНефискальныеПосле = Истина;
			
			Для Каждого ПоляСтрокиТаблицы Из СтрокаОсновногоРаздела.Строки Цикл
				
				Если ПоляСтрокиТаблицы.ИмяКолонки = "ФискальныйРаздел" Тогда
					
					ФискальныйРазделБыл = Истина;
					
					СтрокаПозицииЧека = Новый Структура;
					Для Каждого ЭлементЧека Из СтрокаВыборки Цикл
						СтрокаПозицииЧека.Вставить(ЭлементЧека.Ключ, ЭлементЧека.Значение);
					КонецЦикла;
					ПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
					
					Если ИндексТекущейПозиции < ИндексПоследнейПозиции Тогда
						
						СледующаяСтрока = ФискальныеПозицииЧека[ИндексТекущейПозиции + 1];
						Если СледующаяСтрока.НомерСтрокиТовара = СтрокаВыборки.НомерСтрокиТовара Тогда
							ВыводитьНефискальныеПосле = Ложь;
						КонецЕсли;
						
					КонецЕсли;
					
				ИначеЕсли ПоляСтрокиТаблицы.ИмяКолонки = "СоставнаяСтрока" Тогда
					
					Если ФискальныйРазделБыл Тогда
						
						Если НЕ ВыводитьНефискальныеПосле Тогда
							Продолжить;
						КонецЕсли;
						
					Иначе
						
						Если ИндексТекущейПозиции > 0 Тогда
							
							ПредыдущаяСтрока = ФискальныеПозицииЧека[ИндексТекущейПозиции - 1];
							Если ПредыдущаяСтрока.НомерСтрокиТовара = СтрокаВыборки.НомерСтрокиТовара Тогда
								Продолжить;
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЕсли;
					
					СтруктураПоиска = Новый Структура;
					СтруктураПоиска.Вставить("НомерСтрокиТовара", СтрокаВыборки.НомерСтрокиТовара);
					СтруктураПоиска.Вставить("ИмяТаблицы", "Товары");
					СтрокиДанных = ТаблицаДанных.НайтиСтроки(СтруктураПоиска);
					
					СтрокаДанных = ?(СтрокиДанных.Количество() > 0, СтрокиДанных[0], СтрокаВыборки);
					
					ОбработатьСоставнуюСтроку(ПараметрыЧека, ПоляСтрокиТаблицы, СтрокаШапкиЧека,
						ТаблицаДанных, СтрокаДанных, ИмяТаблицы);
						
				ИначеЕсли ПоляСтрокиТаблицы.ИмяКолонки = "Текст" Тогда
					
					Если ФискальныйРазделБыл Тогда
						
						Если НЕ ВыводитьНефискальныеПосле Тогда
							Продолжить;
						КонецЕсли;
						
					Иначе
						
						Если ИндексТекущейПозиции > 0 Тогда
							
							ПредыдущаяСтрока = ФискальныеПозицииЧека[ИндексТекущейПозиции - 1];
							
							Если ПредыдущаяСтрока.НомерСтрокиТовара = СтрокаВыборки.НомерСтрокиТовара Тогда
								Продолжить;
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЕсли;
					
					СтруктураПоиска = Новый Структура;
					СтруктураПоиска.Вставить("НомерСтрокиТовара", СтрокаВыборки.НомерСтрокиТовара);
					СтруктураПоиска.Вставить("ИмяТаблицы", "Товары");
					СтрокиДанных = ТаблицаДанных.НайтиСтроки(СтруктураПоиска);
					
					Если СтрокиДанных.Количество() > 0 Тогда
						СтрокаДанных = СтрокиДанных[0];
					Иначе
						СтрокаДанных = СтрокаВыборки;
					КонецЕсли;
					
					Если ПоляСтрокиТаблицы.ВыводитьКакШтрихкод Тогда
						ОбработатьДанныеШтрихкода(ПараметрыЧека, ПоляСтрокиТаблицы, СтрокаШапкиЧека,
							ТаблицаДанных, СтрокаДанных, ИмяТаблицы);
					Иначе
						ОбработатьТекстовуюСтроку(ПараметрыЧека, ПоляСтрокиТаблицы, СтрокаШапкиЧека,
							ТаблицаДанных, СтрокаДанных, ИмяТаблицы);
					КонецЕсли;
						
				КонецЕсли;
				
			КонецЦикла;
			
			ПоследняяСтрока = СтрокаВыборки.НомерСтрокиТовара;
			ИндексТекущейПозиции = ИндексТекущейПозиции + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет добавление строки в дерево шаблона с заданными параметрами.
//
// Параметры:
//	КоллекцияСтрок	 - КоллекцияСтрокДереваЗначений - коллекция строк в которую необходимо добавить новую строку.
//	Параметры	- Структура:
//		*ИмяЭлемента - Строка - имя элемента.
//		*ТипЭлемента - Строка - тип элемента.
//		*Ширина - Число - ширина в символах.
//		*РазмещениеТекста - число - размещение текста.
//		*Выравнивание - Строка - выравнивание текста.
//		*Формат - Строка - формат строки.
//		*ИмяКолонки - Строка - имя колонки для СКД.
//		*Вычислять - Булево - необходимо ли вычислять значение элемента.
//
// Возвращаемое значение:
//		СтрокаДереваЗначений - Строка дерева значений.
//
Функция ДобавитьСтрокуВКоллекциюСтрокДерева(КоллекцияСтрок, Параметры) Экспорт

	НоваяСтрока = КоллекцияСтрок.Добавить();
	
	СтроковоеЗначениеПоУмолчанию = НСтр("ru = ''");
	ЧисленноеЗначениеПоУмолчанию = 0;
	БулевоЗначениеПоУмолчанию = Ложь;
	ЗначениеВыравниванияПоУмолчанию = НСтр("ru = 'Лево'");
	НовыйУникальныйИдентификатор = ПолучитьИдентификатор();
	РазмещениеТекстаЗначениеПоУмолчанию = 1;
	ОписаниеСтроковогоТипаПоУмолчанию = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50));
	
	ЗначенияСвойствПоУмолчанию = Новый Структура();
	ЗначенияСвойствПоУмолчанию.Вставить("Ширина", ЧисленноеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("ИмяЭлемента", СтроковоеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("ТипЭлемента", СтроковоеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("Идентификатор", НовыйУникальныйИдентификатор);
	ЗначенияСвойствПоУмолчанию.Вставить("РазмещениеТекста", РазмещениеТекстаЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("Выравнивание", ЗначениеВыравниванияПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("ИмяКолонки", СтроковоеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("Формат", СтроковоеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("Вычислять", БулевоЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("Префикс", СтроковоеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("Постфикс", СтроковоеЗначениеПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("ОписаниеТипа", ОписаниеСтроковогоТипаПоУмолчанию);
	ЗначенияСвойствПоУмолчанию.Вставить("ПустоеЗначение", Неопределено);
	ЗначенияСвойствПоУмолчанию.Вставить("СтрокаПустоеЗначение", СтроковоеЗначениеПоУмолчанию);
	
	Для каждого Элемент Из ЗначенияСвойствПоУмолчанию Цикл
		УстановитьЗначениеСвойстваСтроки(НоваяСтрока, Параметры, Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
	Если НоваяСтрока.ТипЭлемента = "ОбластьЧека" Тогда
		НоваяСтрока.ИндексКартинки = 0.00; // СистемнаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "СтрокаДанных" Тогда
		НоваяСтрока.ИндексКартинки = 1.00; // ВычисляемаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "СтрокаТекста" Тогда
		НоваяСтрока.ИндексКартинки = 2.00; // ПользовательскаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "СоставнаяСтрока" Тогда
		НоваяСтрока.ИндексКартинки = 3.00; // СоставнаяСтрока
	ИначеЕсли НоваяСтрока.ТипЭлемента = "Таблица" Тогда
		НоваяСтрока.ИндексКартинки = 4.00; // СтрокаТаблицы
	Иначе
		НоваяСтрока.ИндексКартинки = 5.00;
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Выполняет печать строк на ФР.
//
// Параметры:
//  СтруктураШаблона  - Структура -  параметры шаблона.
//  Свойство          - Строка - наименование свойства.
//
// Возвращаемое значение:
//  Массив - массив напечатанных строк.
//
Функция НапечататьСтроки(СтруктураШаблона, Свойство) Экспорт
	
	МассивСтрок = Новый Массив();
	
	Если СтруктураШаблона <> Неопределено Тогда
		МассивСтрок = НапечататьНеФискальныеСтроки(СтруктураШаблона, Свойство);
	КонецЕсли;
	
	Возврат МассивСтрок;
	
КонецФункции

// Генерирует уникальный идентификатор строки дерева шаблона.
//
// Возвращаемое значение:
//	Строка - уникальный идентификатор.
//
Функция ПолучитьИдентификатор() Экспорт
	Возврат СтрШаблон(НСтр("ru = 'ID%1'"), СтрЗаменить(Новый УникальныйИдентификатор, "-", "_"));
КонецФункции

// Выполняет формирование предопределенной структуры шаблона
//	значений.
//
// Параметры:
//	ИерархическийШаблон - ДеревоЗначений - шаблон для которого необходимо сформировать предопределенную структуру.
//	ПервичнаяСтруктура - Структура - структура первичных данных.
//	ИмяОбъекта - Строка - имя объекта метаданных.
//	Загружать - Булево - признак загрузки данных.
//
// Возвращаемое значение:
//	Результат - ТекстовыйДокумент
//
Функция СформироватьПервичнуюСтруктуруИерархическогоШаблона(ИерархическийШаблон, ПервичнаяСтруктура,
		ИмяОбъекта = "ЧекККМ", Загружать = Истина) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	Возврат МенеджерОбъекта.СформироватьПервичнуюСтруктуруШаблона(ИерархическийШаблон, ИмяОбъекта,
		ПервичнаяСтруктура, Загружать);
	
КонецФункции

// Добавляет фискальные строки в дерево шаблона перед формированием
// по нему представления чека.
//
// Параметры:
//
//	КопияШаблона - КоллекцияСтрокДереваЗначений - коллекция строк в которую необходимо добавить фискальные строки.
//	ШиринаЧека - Число - ширина чека в символах.
//	ОднаФискальнаяСтрока - Булево - определяется наличие режима одна фискальная строка.
//	ИмяОбъекта - Строка - имя объекта для которого нужно сформировать фискальные строки.
// Возвращаемое значение:
//	КоллекцияСтрокДереваЗначений - коллекция строк дерева значений.
//
Функция СформироватьФискальныеСтрокиМакетаФискальногоЧека(КопияШаблона, ШиринаЧека,
		ОднаФискальнаяСтрока, ИмяОбъекта = "ЧекККМ") Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	
	Результат = ?(МенеджерОбъекта = Неопределено, КопияШаблона,
		МенеджерОбъекта.СформироватьФискальныеСтроки(КопияШаблона, ШиринаЧека, ОднаФискальнаяСтрока));
		
	Возврат Результат;
	
КонецФункции

// Возвращает значение текстового поля.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка - документ в котором ищется значение поля.
//	ПоляСтроки - Структура - структура данных поля строки.
//	СтрокаШапкиЧека - Структура - строка шапки чека.
//	ТаблицаДанных - ТаблицаЗначений - таблица в которой ищется значение поля.
//	СтрокаДанных - СтрокаТаблицыЗначений - строка в которой ищется значение поля.
//	ИмяРаздела - Строка - имя раздела для поиска.
//
// Возвращаемое значение:
//	Произвольный - значение текстового поля.
//
Функция ЗначениеТекстовогоПоля(ДокументСсылка, ПоляСтроки, СтрокаШапкиЧека, ТаблицаДанных,
		СтрокаДанных = Неопределено, ИмяРаздела = "СоставЧека") Экспорт
	
	ЗначениеСтроки = Неопределено;
		
		Если ПоляСтроки.Вычислять Тогда
			
			Попытка
				
				Если СтрокаДанных = Неопределено Тогда
					ЗначениеСтроки = СтрокаШапкиЧека[ПоляСтроки.Элемент];
				Иначе
					
					ЕстьКолонка = Ложь;
					
					Если ТаблицаДанных.Колонки.Найти(ПоляСтроки.Элемент) = Неопределено Тогда
						
						Если СтрокаДанных <> Неопределено Тогда
							
							Попытка
								
								ЕстьКолонка = СтрокаДанных[ПоляСтроки.Элемент] <> Null;
								
							Исключение
								
								ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
								ЗаписьЖурналаРегистрации(
									НСтр("ru = 'Ошибка получения значения текстового поля.'", ОбщегоНазначения.КодОсновногоЯзыка()),
										УровеньЖурналаРегистрации.Предупреждение,,, ТекстОшибки);
								
							КонецПопытки;
							
						КонецЕсли;
						
					Иначе
						// Если null - то значение или в шапке, или в другом разделе.
						ЕстьКолонка = СтрокаДанных[ПоляСтроки.Элемент] <> Null;
					КонецЕсли;
					
					ЗначениеСтроки = ?(ЕстьКолонка, СтрокаДанных[ПоляСтроки.Элемент], СтрокаШапкиЧека[ПоляСтроки.Элемент]);
					
				КонецЕсли;
				
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
		Иначе
			ЗначениеСтроки = ПоляСтроки.Элемент;
		КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЗначениеСтроки) Тогда
		
		Если ПоляСтроки.ВыводитьПустоеЗначение Тогда
			ЗначениеСтроки = ПоляСтроки.ПустоеЗначение;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеСтроки;
	
КонецФункции

// Формирует таблицу значений по СКД и документу.
//
// Параметры:
//	СКД - СхемаКомпоновкиДанных - схема компоновки данных для формирования таблицы значений.
//	ДокументСсылка - ДокументСсылка - документ по которому формируется таблица значений.
//
// Возвращаемое значение:
//	Результат - ТаблицаЗначений
//
Функция ТаблицаСКД(СКД, ДокументСсылка) Экспорт
	
	Настройки = СКД.НастройкиПоУмолчанию;
	ПараметрЧек = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДокументСсылка"));
	
	Если ПараметрЧек <> Неопределено Тогда
		
		ПараметрЧек.Значение = ДокументСсылка;
		ПараметрЧек.Использование = Истина;
		
	КонецЕсли;
	
	ПараметрГраница = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ГраницаПередЧеком"));

	Если ПараметрГраница <> Неопределено Тогда
		
		ПараметрГраница.Значение = Новый Граница(ДокументСсылка.МоментВремени(), ВидГраницы.Исключая);
		ПараметрГраница.Использование = Истина;
		
	КонецЕсли;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД,
		Настройки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаЗначений;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьПараметрыЧека(ПараметрыЧека, ДанныеДляДополнения) Экспорт
	
	СтрокаПозицииЧека = Новый Структура;
	СтрокаПозицииЧека.Вставить("ТекстоваяСтрока");
	СтрокаПозицииЧека.Вставить("Текст", ДанныеДляДополнения);
	ПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
	
КонецПроцедуры

Процедура ОбработатьТекстовуюСтроку(ПараметрыЧека, ПоляСтроки, СтрокаШапкиЧека, ТаблицаДанных,
	СтрокаДанных = Неопределено, ИмяРаздела = "СоставЧека")
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПоляСтроки, "Идентификатор") И Не ПоляСтроки.Идентификатор = "" Тогда 
		ИмяРазделаДляПроверкиУсловий = ИмяРаздела;
		Если Не ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) И ПараметрыЧека.Свойство("ИмяРаздела") Тогда
			ИмяРазделаДляПроверкиУсловий = ПараметрыЧека.ИмяРаздела;
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) 
			И Не УсловияВыполнены(ПараметрыЧека.ШаблонЧека, ПоляСтроки.Идентификатор, ИмяРазделаДляПроверкиУсловий, СтрокаШапкиЧека, СтрокаДанных) Тогда
			// Данный блок чека не выводится, т.к. не выполнены условия проверки.
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ЗначениеСтроки = ЗначениеТекстовогоПоля(ПараметрыЧека.ДокументОснование, ПоляСтроки,
		СтрокаШапкиЧека, ТаблицаДанных, СтрокаДанных, ИмяРаздела);
		
	Если ЗначениеЗаполнено(ЗначениеСтроки) ИЛИ ПоляСтроки.ВыводитьПустоеЗначение Тогда
		
		ТекстСтроки = СтрШаблон("%1%2%3",
			ПоляСтроки.Префикс,
			Формат(ЗначениеСтроки, ПоляСтроки.Формат),
			ПоляСтроки.Постфикс);
					
		СтрокаПозицииЧека = Новый Структура;
		СтрокаПозицииЧека.Вставить("ТекстоваяСтрока");
		СтрокаПозицииЧека.Вставить("Текст", ТекстСтроки);
		
		Если ПоляСтроки.Выравнивание = "Право" Тогда
			СтрокаПозицииЧека.Вставить("Выравнивание", "Право");
		ИначеЕсли ПоляСтроки.Выравнивание = "Центр" Тогда
			СтрокаПозицииЧека.Вставить("Выравнивание", "Центр");
		КонецЕсли;
		
		Если ПоляСтроки.РазмещениеТекста = 0 Тогда
			СтрокаПозицииЧека.Вставить("ПереносСтроки", Истина);
		КонецЕсли;
		
		ПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанныеШтрихкода(ПараметрыЧека, ПоляСтроки, СтрокаШапкиЧека, ТаблицаДанных,
	СтрокаДанных = Неопределено, ИмяРаздела = "СоставЧека")
	
	// Проверка условия на составную строку в целом
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПоляСтроки, "Идентификатор") И Не ПоляСтроки.Идентификатор = "" Тогда 
		ИмяРазделаДляПроверкиУсловий = ИмяРаздела;
		Если Не ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) И ПараметрыЧека.Свойство("ИмяРаздела") Тогда
			ИмяРазделаДляПроверкиУсловий = ПараметрыЧека.ИмяРаздела;
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) 
			И Не УсловияВыполнены(ПараметрыЧека.ШаблонЧека, ПоляСтроки.Идентификатор, ИмяРазделаДляПроверкиУсловий, СтрокаШапкиЧека, СтрокаДанных) Тогда
			// Данный блок чека не выводится, т.к. не выполнены условия проверки.
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ЗначениеСтроки = ЗначениеТекстовогоПоля(ПараметрыЧека.ДокументОснование, ПоляСтроки, СтрокаШапкиЧека,
		ТаблицаДанных, СтрокаДанных, ИмяРаздела);
		
	Если ЗначениеЗаполнено(ЗначениеСтроки) ИЛИ ПоляСтроки.ВыводитьПустоеЗначение Тогда
		Попытка
			ТипШтрихкодаРТ = ПоляСтроки.ТипШтрихкода;
		Исключение
			
			СтрокаОшибки = СтрШаблон("%1%2%3",
				НСтр("ru = 'Не удалось определить тип штрихкода. Следует отредактировать шаблон чека.'",
					ОбщегоНазначения.КодОсновногоЯзыка()),
				Символы.ПС,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТипШтрихкодаРТ = 99;
			
		КонецПопытки;
		
		Если ТипШтрихкодаРТ = 99 Тогда
			ТипШтрихкодаРТ = МенеджерОборудованияКлиентСервер.ОпределитьТипШтрихкода(ЗначениеСтроки);
		Иначе
			
			Если ТипШтрихкодаРТ = 0 Тогда
				ТипШтрихкодаРТ = "EAN8";
			ИначеЕсли ТипШтрихкодаРТ = 1 Тогда
				ТипШтрихкодаРТ = "EAN13";
			ИначеЕсли ТипШтрихкодаРТ = 2 Тогда
				ТипШтрихкодаРТ = "EAN128";
			ИначеЕсли ТипШтрихкодаРТ = 3 Тогда
				ТипШтрихкодаРТ = "CODE39";
			ИначеЕсли ТипШтрихкодаРТ = 4 Тогда
				ТипШтрихкодаРТ = "CODE128";
			ИначеЕсли ТипШтрихкодаРТ = 11 Тогда
				ТипШтрихкодаРТ = "ITF14";
			ИначеЕсли ТипШтрихкодаРТ = 16 Тогда
				ТипШтрихкодаРТ = "QR";
			ИначеЕсли ТипШтрихкодаРТ = 14 Тогда
				ТипШтрихкодаРТ = "EAN13Addon2";
			ИначеЕсли ТипШтрихкодаРТ = 15 Тогда
				ТипШтрихкодаРТ = "EAN13Addon5";
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПоляСтроки.Префикс) Тогда
			ДополнитьПараметрыЧека(ПараметрыЧека, ПоляСтроки.Префикс);
		КонецЕсли;
		
		
		СтрокаПозицииЧека = Новый Структура;
		СтрокаПозицииЧека.Вставить("ШтрихКод", ЗначениеСтроки);
		СтрокаПозицииЧека.Вставить("ТипШтрихкода", ТипШтрихкодаРТ);
		ПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
		
		Если ЗначениеЗаполнено(ПоляСтроки.ПостФикс) Тогда
			ДополнитьПараметрыЧека(ПараметрыЧека, ПоляСтроки.Постфикс);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСоставнуюСтроку(ПараметрыЧека, ПоляСтроки, СтрокаШапкиЧека, ТаблицаДанных, СтрокаДанных = Неопределено, ИмяРаздела = "СоставЧека")
	
	ТекстСтроки = НСтр("ru = ''");
	
	// Проверка условия на составную строку в целом
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПоляСтроки, "Идентификатор") И Не ПоляСтроки.Идентификатор = "" Тогда 
		ИмяРазделаДляПроверкиУсловий = ИмяРаздела;
		Если Не ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) И ПараметрыЧека.Свойство("ИмяРаздела") Тогда
			ИмяРазделаДляПроверкиУсловий = ПараметрыЧека.ИмяРаздела;
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) 
			И Не УсловияВыполнены(ПараметрыЧека.ШаблонЧека, ПоляСтроки.Идентификатор, ИмяРазделаДляПроверкиУсловий, СтрокаШапкиЧека, СтрокаДанных) Тогда
			// Данный блок чека не выводится, т.к. не выполнены условия проверки.
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ПараметрСтроки Из ПоляСтроки.Строки Цикл
		
		Если ЗначениеЗаполнено(ПараметрСтроки.ИмяКолонки) Тогда
			
			// Проверка условия для каждого элемента составной строки
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрСтроки, "Идентификатор") И Не ПараметрСтроки.Идентификатор = "" Тогда 
				ИмяРазделаДляПроверкиУсловий = ИмяРаздела;
				Если Не ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) И ПараметрыЧека.Свойство("ИмяРаздела") Тогда
					ИмяРазделаДляПроверкиУсловий = ПараметрыЧека.ИмяРаздела;
				КонецЕсли;
				Если ЗначениеЗаполнено(ИмяРазделаДляПроверкиУсловий) 
					И Не УсловияВыполнены(ПараметрыЧека.ШаблонЧека, ПараметрСтроки.Идентификатор, ИмяРазделаДляПроверкиУсловий, СтрокаШапкиЧека, СтрокаДанных) Тогда
					// Данный элемент строки не выводится, т.к. не выполнены условия проверки.
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			ЗначениеПоля = ЗначениеТекстовогоПоля(ПараметрыЧека.ДокументОснование, ПараметрСтроки,
				СтрокаШапкиЧека, ТаблицаДанных, СтрокаДанных, ИмяРаздела);;
			
			Если ЗначениеЗаполнено(ЗначениеПоля) Тогда
			
				ДлинаПостфикса = СтрДлина(ПараметрСтроки.Постфикс);
				ПозицияСимволаПереноса = СтрНайти(ПараметрСтроки.Постфикс, Символ(182));
				ЕстьПереносСтроки = ПозицияСимволаПереноса > 0;
				
				ТекстСтроки = СтрШаблон("%1%2%3%4",
						ТекстСтроки,
						ПараметрСтроки.Префикс,
						Формат(ЗначениеПоля, ПараметрСтроки.Формат),
						?(ЕстьПереносСтроки, 
							Лев(ПараметрСтроки.Постфикс, ПозицияСимволаПереноса - 1),
							ПараметрСтроки.Постфикс));
							
				Если ЕстьПереносСтроки Тогда
					
					Если ЗначениеЗаполнено(ТекстСтроки) ИЛИ ПоляСтроки.ВыводитьПустоеЗначение Тогда
						ДополнитьПараметрыЧека(ПараметрыЧека, ТекстСтроки);
					КонецЕсли;
					
					ТекстСтроки = Прав(ПараметрСтроки.Постфикс, ДлинаПостфикса - ПозицияСимволаПереноса);
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстСтроки) Тогда
		
		СтрокаПозицииЧека = Новый Структура;
		СтрокаПозицииЧека.Вставить("ТекстоваяСтрока");
		СтрокаПозицииЧека.Вставить("Текст", ТекстСтроки);
		
		Если ПоляСтроки.Выравнивание = "Право" Тогда
			СтрокаПозицииЧека.Вставить("Выравнивание", "Право");
		ИначеЕсли ПоляСтроки.Выравнивание = "Центр" Тогда
			СтрокаПозицииЧека.Вставить("Выравнивание", "Центр");
		КонецЕсли;
		
		Если ПоляСтроки.РазмещениеТекста = 0 Тогда
			СтрокаПозицииЧека.Вставить("ПереносСтроки", Истина);
		КонецЕсли;
		ПараметрыЧека.ПозицииЧека.Добавить(СтрокаПозицииЧека);
		
	КонецЕсли;
	
КонецПроцедуры

Функция УсловияВыполнены(ШаблонЧека, Идентификатор, ИмяРаздела, СтрокаШапкиЧека, СтрокаДанных = Неопределено) Экспорт
	
	УсловияВыполнены = Истина;
	ТаблицаУсловий = Неопределено;
	Если ТипЗнч(ШаблонЧека) = Тип("СправочникСсылка.ХранилищеШаблонов") 
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ШаблонЧека, "Условия") Тогда
		ТаблицаУсловий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ШаблонЧека, "Условия").Выгрузить();
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ШаблонЧека, "Условия") Тогда
		ТаблицаУсловий = ШаблонЧека.Условия;	
	КонецЕсли;
	Если ТаблицаУсловий = Неопределено Тогда 
		// Проверка условий не поддерживается, поля выводятся безусловно
		Возврат Истина;
	КонецЕсли;
	УсловияВыводаСоставнойСтроки = ТаблицаУсловий.НайтиСтроки(Новый Структура("Идентификатор", Число(Идентификатор)));
	
	Равно = Перечисления.ВидСравненияЗначений.Равно;
	НеРавно = Перечисления.ВидСравненияЗначений.НеРавно;
	Больше = Перечисления.ВидСравненияЗначений.Больше;
	БольшеИлиРавно = Перечисления.ВидСравненияЗначений.БольшеИлиРавно;
	Меньше = Перечисления.ВидСравненияЗначений.Меньше;
	МеньшеИлиРавно = Перечисления.ВидСравненияЗначений.МеньшеИлиРавно;
	Для Каждого Условие Из УсловияВыводаСоставнойСтроки Цикл
		РезультатПроверки = Неопределено;
		СтруктураДанныРасчета = Новый Структура("Шапка", СтрокаШапкиЧека);
		Если ИмяРаздела = "ПромокодыКВыдаче" И Не СтрокаДанных = Неопределено Тогда
			СтруктураДанныРасчета.Вставить("ТекущаяСтрокаВыдачиПромокода", СтрокаДанных);
		ИначеЕсли Не СтрокаДанных = Неопределено Тогда
			СтруктураДанныРасчета.Вставить("ТекущаяСтрокаТЧ", СтрокаДанных);
		КонецЕсли;	
		ЛевоеЗначение = Перечисления.УсловиеВыводаСекцииШаблона.ВычислитьЛевоеЗначение(Условие.ТипУсловия, СтруктураДанныРасчета);
		Если Условие.ВидСравнения = Равно Тогда
			РезультатПроверки = ЛевоеЗначение = Условие.ЗначениеСравнения;	
		ИначеЕсли Условие.ВидСравнения = НеРавно Тогда
			РезультатПроверки = ЛевоеЗначение <> Условие.ЗначениеСравнения;	
		ИначеЕсли Условие.ВидСравнения = Больше Тогда
			РезультатПроверки = ЛевоеЗначение > Условие.ЗначениеСравнения;	
		ИначеЕсли Условие.ВидСравнения = БольшеИлиРавно Тогда
			РезультатПроверки = ЛевоеЗначение >= Условие.ЗначениеСравнения;	
		ИначеЕсли Условие.ВидСравнения = Меньше Тогда
			РезультатПроверки = ЛевоеЗначение < Условие.ЗначениеСравнения;	
		ИначеЕсли Условие.ВидСравнения = МеньшеИлиРавно Тогда
			РезультатПроверки = ЛевоеЗначение <= Условие.ЗначениеСравнения;	
		Иначе
			ВызватьИсключение("Не предусмотренный вид сравнения условия при выводе чека согласно шаблона!");
		КонецЕсли;
		Если РезультатПроверки = Ложь Тогда
			УсловияВыполнены = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;  
		
	Возврат УсловияВыполнены;
КонецФункции

Процедура УстановитьЗначениеСвойстваСтроки(Строка, Параметры, ИмяСвойства, ЗначениеПоУмолчанию)
	
		Значение = Неопределено;
		
		Строка[ИмяСвойства] = ?(Параметры.Свойство(ИмяСвойства, Значение),
			Значение, ЗначениеПоУмолчанию);
	
КонецПроцедуры

// Выполняет печать нефискальных строк на ККМ.
//
// Параметры:
//  СтруктураШаблона - Структура - параметры шаблона.
//  Свойство         - Строка - Наименование свойства
//
// Возвращаемое значение:
//  Ошибка - Представление ошибки печати на ФР.
//
Функция НапечататьНеФискальныеСтроки(СтруктураШаблона, Свойство)
	
	МассивСоответствий = Неопределено;
	СтруктураШаблона.Шаблон.Свойство(Свойство, МассивСоответствий);
	
	Если МассивСоответствий <> Неопределено И МассивСоответствий.Количество() > 0 Тогда
		МассивСоответствий = ПреобразоватьМассивСоответствийВМассивТекстовыхСтрок(МассивСоответствий);
	КонецЕсли;
	
	Возврат ?(МассивСоответствий = Неопределено, Новый Массив(), МассивСоответствий);
	
КонецФункции

// Преобразует массивы (из массива соответствий в массив текстовых строк).
//
// Параметры:
//  МассивСоответствий - Массив - Массив соответствий.
//
// Возвращаемое значение:
//  Массив - массив текстовых строк.
//
Функция ПреобразоватьМассивСоответствийВМассивТекстовыхСтрок(МассивСоответствий)

	РезультирующийМассив = Новый Массив;
	
	Для каждого Соответствия Из МассивСоответствий Цикл
		
		Для каждого ЭлементСоответствия Из Соответствия Цикл
			
			Для каждого СтрокаМассива Из ЭлементСоответствия.Значение Цикл
				РезультирующийМассив.Добавить(СтрокаМассива);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат РезультирующийМассив;
	
КонецФункции

#КонецОбласти