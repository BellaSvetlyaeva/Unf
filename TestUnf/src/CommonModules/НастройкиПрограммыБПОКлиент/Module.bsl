
#Область СлужебныйПрограммныйИнтерфейс

#Область ПанельАдминистрирования

// Обработчик команды формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой выполняется команда.
//   Команда - КомандаФормы - выполняемая команда.
//   Источник - ТаблицаФормы
//            - ДанныеФормыСтруктура - объект или список формы с полем "Ссылка".
//
Процедура НачатьВыполнениеКомандыПанелиАдминистрирования(Форма, Команда, Источник) Экспорт
	
	ИмяКоманды      = Команда.Имя;
	АдресНастроек   = Форма.ПараметрыПодключаемыхКоманд.АдресТаблицыКоманд;
	ОписаниеКоманды = ОписаниеКоманды(ИмяКоманды, АдресНастроек);
	
	ПараметрыВыполнения = ПараметрыВыполненияКоманды();
	ПараметрыВыполнения.ОписаниеКоманды = Новый Структура(ОписаниеКоманды);
	ПараметрыВыполнения.Форма           = Форма;
	ПараметрыВыполнения.Источник        = Источник;
	ПараметрыВыполнения.ЭтоФормаОбъекта = ТипЗнч(Источник) = Тип("ДанныеФормыСтруктура");
	
	ПродолжитьВыполнениеКоманды(ПараметрыВыполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПанельАдминистрирования

// Свойства второго параметра обработчика подключаемой команды, выполняемой на клиенте.
//
// Возвращаемое значение:
//  Структура:
//   * ОписаниеКоманды - Структура - состав свойств совпадает с колонками таблицы значений параметра Команды процедуры
///                                  ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
//                                   Ключевые свойства:
//      ** Идентификатор  - Строка - идентификатор команды.
//      ** Представление  - Строка - представление команды в форме.
//      ** Имя            - Строка - имя команды в форме.
//      ** ДополнительныеПараметры - Структура - дополнительные свойства, состав которых определяется видом 
//                                   конкретной команды.
//   * Форма - ФормаКлиентскогоПриложения - форма, из которой вызвана команда.
//           - РасширениеУправляемойФормыДляДокумента
//   * ЭтоФормаОбъекта - Булево - Истина, если команда вызвана из формы объекта.
//   * Источник - ТаблицаФормы
//              - ДанныеФормыСтруктура - объект или список формы с полем "Ссылка":
//     ** Ссылка - ЛюбаяСсылка
//
Функция ПараметрыВыполненияКоманды()
	
	Результат = Новый Структура();
	Результат.Вставить("ОписаниеКоманды", Неопределено);
	Результат.Вставить("Форма", Неопределено);
	Результат.Вставить("Источник", Неопределено);
	Результат.Вставить("ЭтоФормаОбъекта", Ложь);

	Результат.Вставить("Уникальность");
	Результат.Вставить("Окно");
	
	// Служебные параметры.
	Результат.Вставить("ТребуетсяЗапись", Ложь);
	Результат.Вставить("ТребуетсяПроведение", Ложь);
	Результат.Вставить("ТребуетсяРаботаСФайлами", Ложь);
	Результат.Вставить("МассивСсылок", Новый Массив);
	Результат.Вставить("ВызовСервераЧерезОбработкуОповещения", Ложь);
	Результат.Вставить("НепроведенныеДокументы", Новый Массив);
	Возврат Результат;
	
КонецФункции

// Выполняет команду, подключенную к форме.
//
// Параметры:
//  ПараметрыВыполнения - см. ПараметрыВыполненияКоманды
// 
Процедура ПродолжитьВыполнениеКоманды(ПараметрыВыполнения)
	
	ОписаниеКоманды = ПараметрыВыполнения.ОписаниеКоманды;
	
	// Выполнение команды.
	ПараметрКоманды = Неопределено;
	// Выполнение команды.
	Если ЗначениеЗаполнено(ОписаниеКоманды.Обработчик) Тогда
		Если СтрНачинаетсяС(ОписаниеКоманды.Обработчик, "e1cib") Тогда
			
			// Нужно проверять по подсистеме БазоваяФункциональность, но эта подсистема частично загружена в БПО
			Если ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Пользователи") Тогда
				ОбщегоНазначенияБПОКлиент.ОткрытьНавигационнуюСсылку(ОписаниеКоманды.Обработчик);
			Иначе
				Если ОбщегоНазначенияБПОКлиентСервер.СтрокаЗапускаБезопасная(ОписаниеКоманды.Обработчик) Тогда
					ПерейтиПоНавигационнойСсылке(ОписаниеКоманды.Обработчик); // АПК:534 произведена проверка запуска
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли СтрНайти(ОписаниеКоманды.Обработчик, "://")>0 Тогда
			
			// Нужно проверять по подсистеме БазоваяФункциональность, но эта подсистема частично загружена в БПО
			Если ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Пользователи") Тогда
				ОбщегоНазначенияБПОКлиент.ОткрытьНавигационнуюСсылку(ОписаниеКоманды.Обработчик);
			Иначе
				Если ОбщегоНазначенияБПОКлиентСервер.СтрокаЗапускаБезопасная(ОписаниеКоманды.Обработчик) Тогда
					ПерейтиПоНавигационнойСсылке(ОписаниеКоманды.Обработчик); // АПК:534 произведена проверка запуска
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			МассивПодстрок = СтрРазделить(ОписаниеКоманды.Обработчик, ".");
			Если МассивПодстрок.Количество() = 1 Тогда
				ПараметрыФормы = ПараметрыФормы(ПараметрыВыполнения, ПараметрКоманды);
				// АПК:65-выкл ПолучитьФорму используется для вызова обработчика описания оповещения
				КлиентскийМодуль = ПолучитьФорму(ОписаниеКоманды.ИмяФормы, ПараметрыФормы, ПараметрыВыполнения.Форма, Истина);
				// АПК:65-вкл
				ИмяПроцедуры = ОписаниеКоманды.Обработчик;
			Иначе
				КлиентскийМодуль = ОбщегоНазначенияБПОКлиент.ОбщийМодуль(МассивПодстрок[0]);
				ИмяПроцедуры = МассивПодстрок[1];
			КонецЕсли;
			ПараметрыВыполнения.Уникальность = ПараметрыВыполнения.Форма.УникальныйИдентификатор;
			Обработчик = Новый ОписаниеОповещения(ИмяПроцедуры, КлиентскийМодуль, ПараметрыВыполнения);
			ВыполнитьОбработкуОповещения(Обработчик, ПараметрКоманды);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ОписаниеКоманды.ИмяФормы) Тогда
		ПараметрыФормы = ПараметрыФормы(ПараметрыВыполнения, ПараметрКоманды);
		ОткрытьФорму(ОписаниеКоманды.ИмяФормы, ПараметрыФормы, ПараметрыВыполнения.Форма, Истина);
	КонецЕсли;
КонецПроцедуры

// Формирует параметры формы подключенного объекта в контексте выполняемой команды.
Функция ПараметрыФормы(Контекст, ПараметрКоманды)
	Результат = Контекст.ОписаниеКоманды.ПараметрыФормы;
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура;
	КонецЕсли;
	Контекст.ОписаниеКоманды.Удалить("ПараметрыФормы");
	Результат.Вставить("ОписаниеКоманды", Контекст.ОписаниеКоманды);
	Если ПустаяСтрока(Контекст.ОписаниеКоманды.ИмяПараметраФормы) Тогда
		Результат.Вставить("ПараметрКоманды", ПараметрКоманды);
	Иначе
		МассивИмен = СтрРазделить(Контекст.ОписаниеКоманды.ИмяПараметраФормы, ".", Ложь);
		Узел = Результат;
		ВГраница = МассивИмен.ВГраница();
		Для Индекс = 0 По ВГраница-1 Цикл
			Имя = СокрЛП(МассивИмен[Индекс]);
			Если Не Узел.Свойство(Имя) Или ТипЗнч(Узел[Имя]) <> Тип("Структура") Тогда
				Узел.Вставить(Имя, Новый Структура);
			КонецЕсли;
			Узел = Узел[Имя];
		КонецЦикла;
		Узел.Вставить(МассивИмен[ВГраница], ПараметрКоманды);
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает описание команды по имени элемента формы.
// 
// Параметры:
//  ИмяКомандыВФорме Имя команды в форме
//  АдресНастроек Адрес настроек
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//   * Идентификатор - Строка
//   * Представление - Строка
//   * Подсказка - Строка
//   * ГруппаФормы - Неопределено, 
//                 - ГруппаФормы
//   * Важность - Строка
//   * Порядок - Число
//   * ФункциональныеОпции - Строка
//   * Менеджер - Строка
//   * Обработчик - Строка
//   * ДополнительныеПараметры - Структура
//   * ИмяФормы - Строка
//   * ПараметрыФормы - Структура, Неопределено -
//   * ИмяПараметраФормы - Строка
//   * ПорядокВажности - Число
//   * ИмяВФорме - Строка
//
Функция ОписаниеКоманды(ИмяКомандыВФорме, АдресНастроек) Экспорт
	
	Команды = ПолучитьИзВременногоХранилища(АдресНастроек);
	ОписаниеКоманды = Неопределено;
	Для Каждого Команда Из Команды Цикл
		Если Команда.ИмяВФорме = ИмяКомандыВФорме Тогда
			ОписаниеКоманды = Команда;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОписаниеКоманды = Неопределено Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Сведения о команде ""%1"" не существуют.'"),
			ИмяКомандыВФорме);
	КонецЕсли;
	
	ОписаниеКоманды.Вставить("Серверная", Ложь);
	Если ЗначениеЗаполнено(ОписаниеКоманды.ИмяФормы) Тогда
		МассивПодстрок = СтрРазделить(ОписаниеКоманды.ИмяФормы, ".");
		КоличествоПодстрок = МассивПодстрок.Количество();
		Если КоличествоПодстрок = 1
			Или (КоличествоПодстрок = 2 И ВРег(МассивПодстрок[0]) <> "ОБЩАЯФОРМА") Тогда
			ОписаниеКоманды.ИмяФормы = ОписаниеКоманды.Менеджер + "." + ОписаниеКоманды.ИмяФормы;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ОписаниеКоманды.Обработчик) Тогда
			Если Не ПустаяСтрока(ОписаниеКоманды.Менеджер) И СтрНайти(ОписаниеКоманды.Обработчик, ".") = 0 Тогда
				ОписаниеКоманды.Обработчик = ОписаниеКоманды.Менеджер + "." + ОписаниеКоманды.Обработчик;
			КонецЕсли;
			Если СтрНачинаетсяС(ОписаниеКоманды.Обработчик, "e1cib") Тогда
			ИначеЕсли СтрНайти(ОписаниеКоманды.Обработчик, "://")>0 Тогда
			Иначе
				Если СтрНачинаетсяС(ВРег(ОписаниеКоманды.Обработчик), ВРег("ОбщийМодуль.")) Тогда
					ПозицияТочки = СтрНайти(ОписаниеКоманды.Обработчик, ".");
					ОписаниеКоманды.Обработчик = Сред(ОписаниеКоманды.Обработчик, ПозицияТочки + 1);
				КонецЕсли;
				МассивПодстрок = СтрРазделить(ОписаниеКоманды.Обработчик, ".");
				КоличествоПодстрок = МассивПодстрок.Количество();
				Если КоличествоПодстрок = 2 Тогда
					ИмяМодуля = МассивПодстрок[0];
					Попытка
						ОбъектМетаданныхОбщийМодуль = ОбщегоНазначенияБПОКлиент.ОбщийМодуль(ИмяМодуля);
					Исключение
						ВызватьИсключение СтрШаблон(
							НСтр("ru = 'Клиентский общий модуль ""%1"" не существует.'"),
							ИмяМодуля);
					КонецПопытки;
				Иначе
					ВызватьИсключение СтрШаблон(
						НСтр("ru = 'Серверные ""%1"" вызовы не поддерживаются.'"),
						ИмяМодуля);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ОписаниеКоманды.Удалить("Менеджер");
	ОписаниеКоманды.Удалить("ГруппаФормы");
	
	Возврат Новый ФиксированнаяСтруктура(ОписаниеКоманды);
КонецФункции

#КонецОбласти

#КонецОбласти

