
#Область ПрограммныйИнтерфейс

Функция ПривестиСтроку(Строка, ОписаниеТипов) Экспорт
	
	Если ОписаниеТипов.Типы().Количество() <> 1 Тогда
		Значение = Строка;
	ИначеЕсли ОписаниеТипов.СодержитТип(Тип("Строка")) Тогда
		Значение = Строка;
	Иначе
		
		Если ОписаниеТипов.СодержитТип(Тип("Дата")) Тогда
			// Приведение строки в формате "dd.MM.yyyy" к дате платформой не обеспечивается
			Значение = ПривестиСтрокуКДате(Строка);
		ИначеЕсли ОписаниеТипов.СодержитТип(Тип("Число")) Тогда
			// Используем более гибкое приведение строки к числу, чем обеспечивается платформой.
			// Символ "=" считаем допустимым десятичным разделителем.
			Значение = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрЗаменить(Строка, "=", "."));
		КонецЕсли;
	
		Если Значение = Неопределено Тогда
			Значение = Строка;
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат ОписаниеТипов.ПривестиЗначение(Значение);
	
КонецФункции

// Приводит к дате строку в формате к дате дату в формате "dd.MM.yyyy" 
Функция ПривестиСтрокуКДате(Строка) Экспорт
	
	Если ПустаяСтрока(Строка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЭлементыДаты = СтрРазделить(Строка, ".");
	Если ЭлементыДаты.Количество() <> 3 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	День  = ЭлементыДаты[0];
	Месяц = ЭлементыДаты[1];
	Год   = ЭлементыДаты[2];
	
	Если СтрДлина(Год) = 2 Тогда
		// Преобразование выполняем самое простое. Это поведение может не соответствовать поведению платформы.
		Год = "20" + Год;
	КонецЕсли;
	
	Попытка
		Возврат Дата(Год, Месяц, День);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция ТипИдентификатор() Экспорт
	
	// Тип Max35Text часто используется в ISO 20022 для идентификаторов
	Возврат ОбщегоНазначения.ОписаниеТипаСтрока(35);
	
КонецФункции

Функция ТолькоНулиВСтроке(Строка) Экспорт
	
	ЗначащиеСимволы = СокрЛП(СтрЗаменить(Строка, "0", ""));
	Возврат ПустаяСтрока(ЗначащиеСимволы);
	
КонецФункции

// Проверяет строку на соответствие требованиям
//
// Параметры:
//  ПроверяемаяСтрока - Строка - проверяемый строка.
//
// Возвращаемое значение:
//  Булево - Истина, если ошибок нет.
//
Функция ТолькоСимволыВСтроке(Знач ПроверяемаяСтрока) Экспорт
	
	Если ПустаяСтрока(ПроверяемаяСтрока) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПроверяемаяСтрока = НРег(СокрЛП(ПроверяемаяСтрока));
	
	// допустимые символы
	СпецСимволы = Спецсимволы();
	
	Если СтрНайти(СпецСимволы, Лев(ПроверяемаяСтрока, 1)) > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// проверяем допустимые символы
	Если Не СтрокаСодержитТолькоДопустимыеСимволы(ПроверяемаяСтрока, СпецСимволы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Проверяет символ на соответствие требованиям
//
// Параметры:
//  Символ            - Строка - проверяемый символ.
//  ДопустимыеСимволы - Строка - допустимые символы.
//
// Возвращаемое значение:
//  Булево - Истина, если ошибок нет.
//
Функция ДопустимыйСимвол(Символ, ДопустимыеСимволы) Экспорт
	
	Если СтрДлина(Символ) = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат СтрНайти(ДопустимыеСимволы, Символ) > 0;
	
КонецФункции

// Возвращает строку спецсимволов
//
// Параметры:
//
// Возвращаемое значение:
//  Строка
//
Функция Спецсимволы() Экспорт
	
	Возврат ".,;:$№#@&_-+*^=?!'/|\""%()[]{}<> «»“”";
	
КонецФункции

Функция СтрокаСодержитТолькоДопустимыеСимволы(СтрокаПроверки, ДопустимыеСимволы)
	
	// Проверяем каждый символ в строке - допустим ли он.
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		Символ = Сред(СтрокаПроверки, Индекс, 1);
		ЭтоДопустимыйСимвол =
			СтроковыеФункцииКлиентСерверРФ.ТолькоКириллицаВСтроке(Символ)    // Кириллица и ё
			Или СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(Символ) // Латиница
			Или СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ)    // Цифры
			Или ДопустимыйСимвол(Символ, ДопустимыеСимволы);               // Спецсимволы
		
		Если Не ЭтоДопустимыйСимвол Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти