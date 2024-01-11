////////////////////////////////////////////////////////////////////////////////
// Клиентские и серверные процедуры и функции общего назначения
//
////////////////////////////////////////////////////////////////////////////////

// Код, доступный и на клиенте, и на сервере, не обязательно должен использоваться в обоих режимах
// АПК:558-выкл 

#Область ПрограммныйИнтерфейс

// Устанавливает значение свойства произвольного объекта, если такое свойство существует.
// При отсутствии свойства ничего не происходит.
//
// Параметры:
//  Объект      - Произвольный - объект, в котором нужно установить значение свойства;
//  ИмяСвойства - Строка       - имя реквизита или свойства;
//  Значение    - Произвольный - устанавливаемое значение.
//
Процедура УстановитьЗначениеСвойства(Объект, ИмяСвойства, Значение) Экспорт
	
	СтруктураСвойства = Новый Структура(ИмяСвойства, Значение);
	ЗаполнитьЗначенияСвойств(Объект, СтруктураСвойства);
	
КонецПроцедуры

// Проверяет заполненность свойства у произвольного объекта
// У пустого объекта свойство считается не заполненным.
// При отсутствии свойства оно считается не заполненным.
//
// Параметры:
//  Объект       - Произвольный - объект, у которого нужно проверить наличие реквизита или свойства;
//  ИмяРеквизита - Строка       - имя реквизита или свойства.
//
// Возвращаемое значение:
//  Булево - Истина, если есть свойство объекта и оно заполнено.
//
Функция ЗаполненоЗначениеСвойства(Объект, ИмяСвойства) Экспорт
	
	Возврат 
		ЗначениеЗаполнено(Объект)
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяСвойства) 
		И ЗначениеЗаполнено(Объект[ИмяСвойства])
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с управляемыми формами.
//

// Устанавливает значение свойства элементов формы.
// Применяется в тех случаях, когда элемента формы может не быть на форме 
// из-за отсутствия прав у пользователя на объект, реквизит объекта или команду.
//
// Параметры:
//  ЭлементыФормы  - ФормаКлиентскогоПриложения, ВсеЭлементыФормы, ЭлементыФормы - коллекция элементов управляемой формы.
//  ИменаЭлементов - Строка, Массив - имя элемента формы.
//  ИмяСвойства    - Строка         - имя устанавливаемого свойства элементов формы.
//  Значение       - Произвольный   - новое значение элементов.
// 
Процедура УстановитьСвойствоЭлементовФормы(Знач ЭлементыФормы, Знач ИменаЭлементов, ИмяСвойства, Значение) Экспорт
	
	Если ТипЗнч(ЭлементыФормы) = Тип("ФормаКлиентскогоПриложения") Тогда
		ЭлементыФормы = ЭлементыФормы.Элементы;
	КонецЕсли;
	
	Если ТипЗнч(ИменаЭлементов) = Тип("Строка") Тогда
		ИменаЭлементов = СтроковыеФункцииБЗККлиентСервер.РазделитьИменаСвойств(ИменаЭлементов);
	КонецЕсли;	
	
	Для Каждого ИмяЭлемента Из ИменаЭлементов Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение);
	КонецЦикла;	
	
КонецПроцедуры 

// Задает обязательность заполнения поля формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного поля формы. 
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - форма.
//  ИмяЭлемента  - Строка - Имя поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).  
//  Обязательное - Булево - Признак обязательности поля, по умолчанию Истина.
//  ПутьКДанным  - Строка - Путь к данным поля ввода, например: "Объект.МесяцНачисления".
//                          Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьПоляВводаФормы(Форма, ИмяЭлемента, Знач Обязательное = Истина, Знач ПутьКДанным = Неопределено) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ИмяПроцедуры = "ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы";
	ИмяПараметра = "ИмяЭлемента";
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		ИмяПараметра,
		ЭлементФормы,
		Новый ОписаниеТипов("ПолеФормы"));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение свойства ""Вид"" поля %3, переданного в параметре %2 в процедуру %1. Ожидается поле ввода.'"),
			ИмяПроцедуры, ИмяПараметра, ИмяЭлемента));
			
	Если Не Обязательное Тогда
		УстановитьНеобязательностьЗаполненияПоляВвода(ЭлементФормы);
	Иначе	
		ЭлементФормы.АвтоОтметкаНезаполненного = Истина;
		ЭлементФормы.ОтметкаНезаполненного     = Не ПоляВводаФормыЗаполнено(Форма, ЭлементФормы, ПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры

// Задает обязательность заполнения поля формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного поля формы.
//
// Параметры:
//  ПолеВвода - ПолеФормы - Поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).
//  Значение  - Произвольный - Текущее значение поля ввода.
//
Процедура УстановитьОбязательностьЗаполненияПоляВвода(ПолеВвода, Значение) Экспорт
	
	ПолеВвода.АвтоОтметкаНезаполненного = Истина;
	ПолеВвода.ОтметкаНезаполненного     = Не ЗначениеЗаполнено(Значение);
	
КонецПроцедуры

// Задает необязательность заполнения поля формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного поля формы.
//
// Параметры:
//  ПолеВвода - ПолеФормы - Поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).
//
Процедура УстановитьНеобязательностьЗаполненияПоляВвода(ПолеВвода) Экспорт
	
	ПолеВвода.АвтоОтметкаНезаполненного = Ложь;
	ПолеВвода.ОтметкаНезаполненного     = Ложь;
	
КонецПроцедуры


// Задает обязательность заполнения таблицы формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного таблицы формы. 
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - форма.
//  ИмяЭлемента  - Строка - Имя таблицы формы.   
//  Обязательное - Булево - Признак обязательности поля, по умолчанию Истина.
//  ПутьКДанным  - Строка - Путь к данным таблицы, например: "Объект.МесяцНачисления".
//                          Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьТаблицыФормы(Форма, ИмяЭлемента, Знач Обязательная = Истина, Знач ПутьКДанным = Неопределено) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьТаблицыФормы",
		"ИмяЭлемента",
		ЭлементФормы,
		Новый ОписаниеТипов("ТаблицаФормы"));
		
	Если Не Обязательная Тогда
		ЭлементФормы.АвтоОтметкаНезаполненного = Ложь;
		ЭлементФормы.ОтметкаНезаполненного     = Ложь;
	Иначе	
		ЭлементФормы.АвтоОтметкаНезаполненного = Истина;
		ЭлементФормы.ОтметкаНезаполненного     = Не ТаблицаФормыЗаполнена(Форма, ЭлементФормы, ПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры	

// Задает обязательность заполнения поля ввода в таблице формы (колонки).
// Устанавливает свойство АвтоОтметкаНезаполненного поля таблицы формы. 
// (свойство ОтметкаНезаполненного в поле таблицы всегда устанавливается автоматически).
//
// Параметры:
//  Форма           - ФормаКлиентскогоПриложения - форма.
//  ИмяЭлемента     - Строка - имя поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).  
//  Обязательное    - Булево - признак обязательности поля, по умолчанию Истина.
//  ПутьКДаннымПоля - Строка - путь к данным поля ввода, например: "Объект.МесяцНачисления".
//                    Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьПоляВводаТаблицыФормы(Форма, ИмяЭлемента, Знач Обязательное = Истина) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ИмяПроцедуры = "ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаТаблицыФормы";
	ИмяПараметра = "ИмяЭлемента";
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		ИмяПараметра,
		ЭлементФормы,
		Новый ОписаниеТипов("ПолеФормы"));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение свойства ""Вид"" поля %3, переданного в параметре %2 в процедуру %1. Ожидается поле ввода.'"),
			ИмяПроцедуры, ИмяПараметра, ИмяЭлемента));
			
	ЭлементФормы.АвтоОтметкаНезаполненного = Обязательное;
	Если Не Обязательное Тогда
		ЭлементФормы.ОтметкаНезаполненного = Ложь;
	КонецЕсли;	
			
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// Функции для вызова необязательных подсистем.

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//  Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Подработки") Тогда
//  	МодульПодработок = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("Подработки");
//  	МодульПодработок.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево - Истина, если существует.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
// АПК:547-выкл Инструкция препроцессора использована для поддержки обратной совместимости
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ОбщегоНазначения.ПодсистемаСуществует(ПолноеИмяПодсистемы);
#Иначе
	Возврат ОбщегоНазначенияКлиент.ПодсистемаСуществует(ПолноеИмяПодсистемы);
#КонецЕсли
// АПК:547-вкл

КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "Подработки",
//                 "ПодработкиКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль - общий модуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
// АПК:547-выкл Инструкция препроцессора использована для поддержки обратной совместимости
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ОбщегоНазначения.ОбщийМодуль(Имя);
#Иначе
	Возврат ОбщегоНазначенияКлиент.ОбщийМодуль(Имя);
#КонецЕсли
// АПК:547-вкл
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с датами

// Определяет, является ли год високосным (или дата относится к високосному году)
//
// Параметры:
//  Год - Число - год, високосность которого определяется;
//      - Дата  - любая дата года, високосность которого нужно проверить
// 
// Возвращаемое значение:
//  Булево - Истина, если год является високосным.
//
Функция ЭтоВисокосныйГод(Знач Год) Экспорт
	
	Если ТипЗнч(Год) = Тип("Дата") Тогда
		Год = Год(Год);
	КонецЕсли;	
	
	Возврат День(КонецМесяца(Дата(Год, 2, 1))) = 29;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с коллекциями 

// Возвращает соответствие, ключами которого являются элементы массива.
// В качестве значений для всех ключей будет установлено Истина.
//
// Параметры:
//	Массив - Массив - элементы которого нужно поместить в Соответствие.
//
// Возвращаемое значение:
//	Соответствие - соответствие, в ключи которого помещены элементы переданного массива.
//
Функция МассивВСоответствие(Массив) Экспорт
	Соответствие = Новый Соответствие;
	
	Для Каждого ЭлементМассива Из Массив Цикл
		Соответствие.Вставить(ЭлементМассива, Истина);
	КонецЦикла;	

	Возврат Соответствие;
КонецФункции	

// Возвращает элементы массива с <НачальныйИндекс> по <КонечныйИндекс>.
//
// Параметры:
//	Массив          - Массив - исходный массив, срез которого будет получен.
//	НачальныйИндекс - Число  - Индекс элемента, с которого начинается срез (включительно).
//                             Если параметр не указан, то выбираются элементы с начала массива.
//                             Если указано значение, меньшее нуля, то параметр принимает значение 0. 
//	КонечныйИндекс  - Число  - Индекс элемента, по который выполняется срез (включительно). 
//                             Если параметр не указан, то выбираются элементы до конца массива.
//                             Если указано значение, большее индекса конечного элемента, 
//                             то параметр принимает значение, равное индексу конечного элемента. 
//
// Возвращаемое значение:
//	Массив - элементы исходного массива в указанном диапазоне.
//
Функция СрезМассива(Массив, Знач НачальныйИндекс = 0, Знач КонечныйИндекс = Неопределено) Экспорт
	Срез = Новый Массив;
	
	НачальныйИндекс = МАКС(НачальныйИндекс, 0);
	Если КонечныйИндекс = Неопределено Тогда
		КонечныйИндекс = Массив.ВГраница();
	Иначе	
		КонечныйИндекс  = МИН(КонечныйИндекс, Массив.ВГраница());
	КонецЕсли;	
	
	Для Индекс = НачальныйИндекс По КонечныйИндекс Цикл
		Срез.Добавить(Массив[Индекс]);
	КонецЦикла;	
		
	Возврат Срез
КонецФункции	

// Удаляет все вхождения кроме значений указанного типа.
//
// Параметры:
//  Массив - Массив - массив, из которого необходимо удалить значения;
//  Тип - Тип - тип значений, которые должны остаться в массиве.
// 
Процедура УдалитьВсеВхожденияКромеТипаИзМассива(Массив, Тип) Экспорт
	
	КоличествоЭлементовКоллекции = Массив.Количество();
	
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		
		Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		
		Если ТипЗнч(Массив[Индекс]) <> Тип Тогда
			
			Массив.Удалить(Индекс);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Удаляет пустые значения из массива.
//
// Параметры:
//  Массив - Массив - массив, из которого необходимо удалить пустые значения;
//
Процедура УдалитьПустыеЗначенияИзМассива(Массив) Экспорт
	
	КоличествоЭлементовКоллекции = Массив.Количество();
	
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		Если Не ЗначениеЗаполнено(Массив[Индекс]) Тогда
			Массив.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Очищает значения свойств структуры
//
// Параметры:
//  Структура - Структура - очищаемая структура.
//
Процедура ОчиститьЗначенияСтруктуры(Структура) Экспорт
	
	Для Каждого Свойство Из Структура Цикл
		Структура[Свойство.Ключ] = Неопределено; 
	КонецЦикла;
	
КонецПроцедуры	

// Формирует небольшой массив размером от 2 до 5 элементов по их значениям.
// Для создания массива из единственного элемента см. ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве. 
// 
// Параметры:
// 	Элемент<n> - элементы массива. 
// 
// Возвращаемое значение:
// 	Массив из Элемент<n>.
//
Функция ЗначенияВМассиве(
	Элемент1, 
	Элемент2, 
	Элемент3 = "440e3512-0df8-4081-a10d-9dc877fbe625", 
	Элемент4 = "440e3512-0df8-4081-a10d-9dc877fbe625", 
	Элемент5 = "440e3512-0df8-4081-a10d-9dc877fbe625") Экспорт

	НебольшойМассив = Новый Массив;
	НебольшойМассив.Добавить(Элемент1);
	НебольшойМассив.Добавить(Элемент2);
	Если Элемент3 <> "440e3512-0df8-4081-a10d-9dc877fbe625" Тогда
		НебольшойМассив.Добавить(Элемент3);
	КонецЕсли;
	Если Элемент4 <> "440e3512-0df8-4081-a10d-9dc877fbe625" Тогда
		НебольшойМассив.Добавить(Элемент4);
	КонецЕсли;
	Если Элемент5 <> "440e3512-0df8-4081-a10d-9dc877fbe625" Тогда
		НебольшойМассив.Добавить(Элемент5);
	КонецЕсли;
	Возврат НебольшойМассив;

КонецФункции

// Добавляет значение в массив, если его нет в массиве
//
// Параметры:
//		Массив - Массив, в который требуется добавить значение
//		Значение - Значение, которое добавляется в массив
//
Процедура ДобавитьЗначениеВМассив(Массив, Значение) Экспорт
	Если Массив.Найти(Значение) = Неопределено Тогда
		Массив.Добавить(Значение);
	КонецЕсли;
КонецПроцедуры

// Выгружает в массив значения соответствия.
// 
// Параметры:
// 	Соответствие - Соответствие.
// 
// Возвращаемое значение:
// 	Массив - значения соответствия.
//
Функция ЗначенияСоответствия(Соответствие) Экспорт

	Значения = Новый Массив;

	Для Каждого КлючИЗначение Из Соответствие Цикл
		Значения.Добавить(КлючИЗначение.Значение);
	КонецЦикла;
	
	Возврат Значения;

КонецФункции

// Выгружает в массив ключи соответствия.
// 
// Параметры:
// 	Соответствие - Соответствие.
// 
// Возвращаемое значение:
// 	Массив - ключи соответствия.
//
Функция КлючиСоответствия(Соответствие) Экспорт

	Значения = Новый Массив;

	Для Каждого КлючИЗначение Из Соответствие Цикл
		Значения.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат Значения;

КонецФункции

// Создает массив и копирует в него значения, содержащиеся в колонке объекта, для
// которого доступен обход посредством оператора Для каждого … Из.
//
// Параметры:
//  КоллекцияСтрок           - ТаблицаЗначений
//                           - ДеревоЗначений
//                           - СписокЗначений
//                           - ТабличнаяЧасть
//                           - Соответствие
//                           - Структура - коллекция, колонку которой нужно выгрузить в массив.
//                                         А так же другие объекты, для которых доступен обход
//                                         посредством оператора Для каждого … Из … Цикл.
//  ИмяКолонки               - Строка - имя поля коллекции, значения которого нужно выгрузить.
//  ТолькоУникальныеЗначения - Булево - если Истина, то в массив будут включены
//                                      только различающиеся значения.
//
// Возвращаемое значение:
//  Массив - значения колонки.
//
Функция ВыгрузитьКолонку(КоллекцияСтрок, ИмяКолонки, ТолькоУникальныеЗначения = Ложь) Экспорт

	МассивЗначений = Новый Массив;
	
	УникальныеЗначения = Новый Соответствие;
	
	Для каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		Значение = СтрокаКоллекции[ИмяКолонки];
		Если ТолькоУникальныеЗначения И УникальныеЗначения[Значение] <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		МассивЗначений.Добавить(Значение);
		УникальныеЗначения.Вставить(Значение, Истина);
	КонецЦикла; 
	
	Возврат МассивЗначений;
	
КонецФункции

// Преобразует коллекцию в массив структур.
// Полученный массив содержит структуры, каждая из которых повторяет
// структуру колонок таблицы значений.
//
// Параметры:
//  КоллекцияСтрок  - ТаблицаЗначений
//                  - ДеревоЗначений
//                  - СписокЗначений
//                  - ТабличнаяЧасть
//                  - Соответствие
//                  - Структура - коллекция, колонку которой нужно выгрузить в массив.
//                  А так же другие объекты, для которых доступен обход
//                  посредством оператора Для каждого … Из … Цикл.
//  ИменаКолонок    - Строка
//                  - Массив из Строка - имена полей коллекции, значения которого нужно выгрузить.
//
// Возвращаемое значение:
//  Массив - коллекция строк коллекции в виде структур.
//
Функция КоллекцияВМассив(КоллекцияСтрок, Знач ИменаКолонок) Экспорт
	
	Массив = Новый Массив();
	
	Если ТипЗнч(ИменаКолонок) = Тип("Массив") Тогда
		ИменаКолонокСтрокой = СтрСоединить(ИменаКолонок, ",")
	Иначе
		ИменаКолонокСтрокой = ИменаКолонок
	КонецЕсли;
	
	Для Каждого Строка Из КоллекцияСтрок Цикл
		НоваяСтрока = Новый Структура(ИменаКолонокСтрокой);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		Массив.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Возврат Массив;

КонецФункции

// Получает идентификатор (метод ПолучитьИдентификатор()) строки дерева значений по вхождению заданной строки в строку
// поля дерева, начиная со строки после строки с переданным идентификатором.
// Используется для позиционирования курсора в иерархических списках.
//
// Параметры:
//  ИдентификаторСтроки - Число             - идентификатор текущей строки, после которой начинается поиск;
//  Дерево              - ДанныеФормыДерево - дерево, в котором следует выполнять поиск.
//  ИмяПоля             - Строка            - имя колонки дерева значений, по которому выполняется поиск.
//                                            полученный в результате поиска идентификатор строки дерева значений.
//  СтрокаДляПоиска     - Строка            - искомое значение поля.
// 
// Возвращаемое значение:
//  Булево - Признак успешного нахождения заданной строки.
//
Функция СледующийИдентификаторСтрокиДереваПоЗначениюПоля(ИдентификаторСтроки, Дерево,  ИмяПоля, СтрокаДляПоиска) Экспорт
	
	ТекущаяСтрока = Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// проверяем дочернюю ветку текущей строки
	Если СледующийИдентификаторСтрокиКоллекцииЭлементовДереваПоЗначениюПоля(
			ИдентификаторСтроки, 
			ТекущаяСтрока.ПолучитьЭлементы(), 
			ИмяПоля,
			СтрокаДляПоиска) Тогда
		Возврат Истина;
	КонецЕсли;
			
	Пока Истина Цикл
		Родитель = ТекущаяСтрока.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			ЭлементыРодителя = Дерево.ПолучитьЭлементы();
		Иначе
			ЭлементыРодителя = Родитель.ПолучитьЭлементы();
		КонецЕсли;
		
		// поиск со следующей ветки от текущей
		Если СледующийИдентификаторСтрокиКоллекцииЭлементовДереваПоЗначениюПоля(
				ИдентификаторСтроки,
				ЭлементыРодителя,
				ИмяПоля,
				СтрокаДляПоиска,
				ЭлементыРодителя.Индекс(ТекущаяСтрока) + 1) Тогда
			Возврат Истина;
		КонецЕсли;
		
		Если Родитель = Неопределено Тогда
			Возврат Ложь; // достигнут конец верхнего уровня
		Иначе
			ТекущаяСтрока = Родитель; // переход на уровень вверх
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

// Возвращает идентификатор строки дерева значений по вхождению заданной строки в строку
// поля дерева, начиная с начала дерева.
// Используется для позиционирования курсора в иерархических списках.
//
// Параметры:
//  Дерево          - ДанныеФормыДерево - дерево, в котором следует выполнять поиск.
//  ИмяПоля         - Строка            - имя колонки дерева значений, по которому выполняется поиск.
//  СтрокаДляПоиска - Строка            - искомое значение поля.
// 
// Возвращаемое значение:
//  Число, Неопределено - Идентификатор найденной строки.
//
Функция ИдентификаторСтрокиДереваПоЗначениюПоля(Дерево, ИмяПоля, СтрокаДляПоиска) Экспорт
	
	ИдентификаторСтроки = 0;
	Если СледующийИдентификаторСтрокиКоллекцииЭлементовДереваПоЗначениюПоля(
			ИдентификаторСтроки, 
			Дерево.ПолучитьЭлементы(), 
			ИмяПоля, 
			СтрокаДляПоиска) Тогда
		Возврат ИдентификаторСтроки;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Для методов служебного API использование не контролируем          
// АПК:581-выкл 
// АПК:580-выкл 
// АПК:299-выкл

////////////////////////////////////////////////////////////////////////////////
// Свойства объектов.

// Получает значение свойства. Если свойство отсутствует, то возвращает Неопределено.
//
// Параметры:
//   Объект - Произвольный
//   ПутьКСвойству - Строка - Путь к свойству. 
//       Например: "Оформление.Цвет" получит свойство "Цвет" свойства "Оформление" объекта.
//
// Возвращаемое значение:
//   Произвольный - Значения свойства.
//
Функция ЗначениеСвойства(Объект, ПутьКСвойству) Экспорт
	Если Объект = Неопределено Или Не ЗначениеЗаполнено(ПутьКСвойству) Тогда
		Возврат Объект;
	КонецЕсли;
	МассивИмен = СтрРазделить(ПутьКСвойству, ".");
	ТекущийОбъект = Объект;
	Для Каждого ИмяРеквизита Из МассивИмен Цикл
		ТекущийОбъект = ЗначенияСвойств(ТекущийОбъект, ИмяРеквизита)[ИмяРеквизита];
	КонецЦикла;
	Возврат ТекущийОбъект;
КонецФункции

// Получает значения свойств. Если свойство отсутствует, то в значении будет Неопределено.
//
// Параметры:
//   Объект - Произвольный
//   ИменаСвойств - Строка - Имена получаемых свойств.
//
// Возвращаемое значение:
//   Структура - Значения свойств.
//
Функция ЗначенияСвойств(Объект, ИменаСвойств) Экспорт
	Структура = Новый Структура(ИменаСвойств);
	Если Объект <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Структура, Объект);
	КонецЕсли;
	Возврат Структура;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Даты, периоды.

// Возвращает представление периода.
//   Имя функции "ПредставлениеПериода" занято платформой.
//
// Параметры:
//   НачалоПериода - Дата
//   ОкончаниеПериода - Дата
//
// Возвращаемое значение:
//   Строка - Представление периода.
//
Функция НаименованиеПериода(НачалоПериода, ОкончаниеПериода) Экспорт
	Если Не ЗначениеЗаполнено(НачалоПериода)
		Или Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		Возврат "";
	КонецЕсли;
	
	НачалоПериодаГод    = Год(НачалоПериода);
	ОкончаниеПериодаГод = Год(ОкончаниеПериода);
	
	Если НачалоПериодаГод = ОкончаниеПериодаГод Тогда
		
		Если НачалоПериодаГод = Год(ТекущаяДата()) Тогда // АПК:143 Для вычисления года не важно какую дату взять.
			ОкончаниеПериодаПредставление = Формат(ОкончаниеПериода, НСтр("ru = 'ДФ=''d MMMM'''"));
		Иначе
			ОкончаниеПериодаПредставление = Формат(ОкончаниеПериода, НСтр("ru = 'ДФ=''d MMMM yyyy"" года""'''"));
		КонецЕсли;
		
		Если НачалоПериода = ОкончаниеПериода Тогда
			Возврат ОкончаниеПериодаПредставление;
		КонецЕсли;
		
		НачалоПериодаМесяц    = Месяц(НачалоПериода);
		ОкончаниеПериодаМесяц = Месяц(ОкончаниеПериода);
		
		Если НачалоПериодаМесяц = ОкончаниеПериодаМесяц Тогда
			
			// "с 5 по 22 апреля 2020".
			НачалоПериодаПредставление = Формат(НачалоПериода, НСтр("ru = 'ДФ=''d'''"));
			
		Иначе
			
			// "с 5 февраля по 22 апреля 2020".
			НачалоПериодаПредставление = Формат(НачалоПериода, НСтр("ru = 'ДФ=''d MMMM'''"));
			
		КонецЕсли;
		
	Иначе
		
		// "с 05.02.2019 по 22.05.2020".
		НачалоПериодаПредставление    = Формат(НачалоПериода, "ДЛФ=D");
		ОкончаниеПериодаПредставление = Формат(ОкончаниеПериода, "ДЛФ=D");
		
	КонецЕсли;
	
	Возврат СтрШаблон(НСтр("ru = 'с %1 по %2'"), НачалоПериодаПредставление, ОкончаниеПериодаПредставление);
КонецФункции

// Возвращает представление количества дней в периоде.
Функция ПредставлениеКоличестваДней(ДатаНачала, ДатаОкончания) Экспорт
	Если Не ПериодСоответствуетТребованиям(ДатаНачала, ДатаОкончания) Тогда
		Возврат "";
	КонецЕсли;
	Возврат СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
		НСтр("ru = ';%1 день;;%1 дня;%1 дней;'"),
		КоличествоДнейВПериоде(ДатаНачала, ДатаОкончания));
КонецФункции

// Возвращает признак того, что период соответствует базовым требованиям.
Функция ПериодСоответствуетТребованиям(ДатаНачала, ДатаОкончания) Экспорт
	Возврат ЗначениеЗаполнено(ДатаНачала) И ДатаНачала <= ДатаОкончания И Год(ДатаНачала) + 100 > Год(ДатаОкончания);
КонецФункции

// Возвращает массив дней, входящих в период.
//
// Параметры:
//   ДатаНачала - Дата
//   ОкончаниеПериода - Дата
//
// Возвращаемое значение:
//   Массив из Дата - Дни периода.
//
Функция МассивДатИзПериода(ДатаНачала, ДатаОкончания) Экспорт
	Результат = Новый Массив;
	
	Если ПериодСоответствуетТребованиям(ДатаНачала, ДатаОкончания) Тогда
		ТекущийДень = НачалоДня(ДатаНачала);
		Пока ТекущийДень <= ДатаОкончания Цикл
			Результат.Добавить(ТекущийДень);
			ТекущийДень = ТекущийДень + 86400;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает массив дней, входящих в массив периодов.
//
// Параметры:
//   Периоды - Массив, ТаблицаЗначений - Коллекция периодов.
//       * ДатаНачала - Дата
//       * ДатаОкончания - Дата
//
// Возвращаемое значение:
//   Массив из Дата - Дни периодов.
//
Функция МассивДатИзПериодов(Периоды) Экспорт
	Результат = Новый Массив;
	
	Для Каждого Период Из Периоды Цикл
		ТекущийДень = НачалоДня(Период.ДатаНачала);
		Пока ТекущийДень <= Период.ДатаОкончания Цикл
			Если Результат.Найти(ТекущийДень) = Неопределено Тогда
				Результат.Добавить(ТекущийДень);
			КонецЕсли;
			ТекущийДень = ТекущийДень + 86400;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Возвращает массив периодов на основании массива дней.
//   Внимание. Массив дней должен быть предварительно отсортирован по возрастанию.
//
// Параметры:
//   МассивДат - Массив из Дата
//
// Возвращаемое значение:
//   Массив - Периоды.
//       * ДатаНачала - Дата
//       * ДатаОкончания - Дата
//
Функция ПериодыИзМассиваДат(МассивДат) Экспорт
	// МассивДат должен быть отсортирован (см. функцию МассивДатИзПериода).
	Периоды = Новый Массив;
	
	ТекущийПериод = Неопределено;
	Для Каждого Дата Из МассивДат Цикл
		Если ТекущийПериод = Неопределено
			Или Дата > ТекущийПериод.ДатаОкончания + 86400 Тогда
			ТекущийПериод = Новый Структура("ДатаНачала, ДатаОкончания", Дата, Дата);
			Периоды.Добавить(ТекущийПериод);
		Иначе
			ТекущийПериод.ДатаОкончания = Дата;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Периоды;
КонецФункции

// Возвращает количество дней в периоде.
Функция КоличествоДнейВПериоде(ДатаНачала, ДатаОкончания) Экспорт
	Возврат Цел((ДатаОкончания - НачалоДня(ДатаНачала)) / 86400) + 1;
КонецФункции

// АПК:299-вкл
// АПК:580-вкл
// АПК:581-вкл

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПоляВводаФормыЗаполнено(Форма, ЭлементФормы, Знач ПутьКДанным = Неопределено)
	
	ЗначениеПоля = Неопределено;
	
	ПутьРеквизита = ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным);
	
	Если ЗначениеЗаполнено(ПутьРеквизита) Тогда
		ЗначениеПоля = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьРеквизита);
	Иначе
// АПК:547-выкл Инструкция препроцессора использована для получения значения поля на клиенте
#Если Клиент Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ТекстРедактирования доступен только в клиентском режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно.
		Попытка
			ЗначениеПоля = ЭлементФормы.ТекстРедактирования;
		Исключение	
		КонецПопытки	
#КонецЕсли
// АПК:547-вкл
	
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(ЗначениеПоля)
	
КонецФункции

Функция ТаблицаФормыЗаполнена(Форма, ЭлементФормы, Знач ПутьКДанным = Неопределено)
	
	КоличествоСтрок = Неопределено;
	
	ПутьРеквизита = ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным);
	
	Если ЗначениеЗаполнено(ПутьРеквизита) Тогда
		КоличествоСтрок = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьРеквизита).Количество();
	Иначе
// АПК:547-выкл Инструкция препроцессора использована для получения количества строк на клиенте
#Если Клиент Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ВыделенныеСтроки доступны только в клиентском режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно.
		Попытка
			КоличествоСтрок = ЭлементФормы.ВыделенныеСтроки.Количество()
		Исключение	
		КонецПопытки	
#КонецЕсли
// АПК:547-вкл
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрок)
	
КонецФункции

Функция ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным)
	ПутьКДаннымЭлементаФормы = Неопределено;
	Если ЗначениеЗаполнено(ПутьКДанным)	Тогда
		ПутьКДаннымЭлементаФормы = ПутьКДанным
	Иначе	
// АПК:547-выкл Инструкция препроцессора использована для получения пути к данным, доступным только на сервере
#Если Сервер Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ПутьКДанным доступен только в серверном режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно.
		Попытка
			ПутьКДаннымЭлементаФормы = ЭлементФормы.ПутьКДанным;
		Исключение	
		КонецПопытки	
#КонецЕсли
// АПК:547-вкл
	КонецЕсли;	
	Возврат ПутьКДаннымЭлементаФормы
КонецФункции

Функция СледующийИдентификаторСтрокиКоллекцииЭлементовДереваПоЗначениюПоля(ИдентификаторСтроки, ЭлементыРодителя, ИмяПоля, 
	СтрокаДляПоиска, СтартовыйИндекс = 0)
	
	Для Индекс = СтартовыйИндекс По ЭлементыРодителя.Количество() - 1 Цикл
		
		СтрокаДерева = ЭлементыРодителя.Получить(Индекс);
		
		Если СтрНайти(НРег(СтрокаДерева[ИмяПоля]), НРег(СтрокаДляПоиска)) <> 0 Тогда
			ИдентификаторСтроки = СтрокаДерева.ПолучитьИдентификатор();
			Возврат Истина;
		КонецЕсли;

		Если СледующийИдентификаторСтрокиКоллекцииЭлементовДереваПоЗначениюПоля(
				ИдентификаторСтроки,
				СтрокаДерева.ПолучитьЭлементы(), 
				ИмяПоля, 
				СтрокаДляПоиска) Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

// АПК:558-вкл 
