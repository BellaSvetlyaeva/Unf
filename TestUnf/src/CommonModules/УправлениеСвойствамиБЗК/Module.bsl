
#Область СлужебныйПрограммныйИнтерфейс

// Обработчик обновляет доступность всех наборов дополнительных реквизитов и сведений по значениям функциональных опций.
//
Процедура УстановитьДоступностьВсехНаборовДополнительныхРеквизитов(ПараметрыОбновления = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбъектыСоСвойствами = ЗарплатаКадрыПовтИсп.ОбъектыЗарплатноКадровойБиблиотекиСДополнительнымиСвойствами();
	Для Каждого ОписаниеОбъекта Из ОбъектыСоСвойствами Цикл
		
		СтруктураПараметров = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
		СтруктураПараметров.Используется = ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОписаниеОбъекта.Ключ);
		
		УправлениеСвойствами.УстановитьПараметрыНабораСвойств(ОписаниеОбъекта.Значение, СтруктураПараметров);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
	
КонецПроцедуры

// Обработчик обновляет доступность наборов дополнительных реквизитов и сведений объектов не зависящих от функциональных
// опций.
//
Процедура УстановитьДоступностьНаборовДополнительныхРеквизитовОбъектовНеЗависящихОтФункциональныхОпций(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбъектыСоСвойствами = ЗарплатаКадрыПовтИсп.ОбъектыСДополнительнымиСвойствамиНеУправляемыеФункциональнымиОпциями();
	Для Каждого ОписаниеОбъекта Из ОбъектыСоСвойствами Цикл
		
		УправлениеСвойствами.УстановитьПараметрыНабораСвойств(
			ОписаниеОбъекта.Значение, УправлениеСвойствами.СтруктураПараметровНабораСвойств());
		
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
	
КонецПроцедуры

// Обработчик обновления наборов дополнительных реквизитов и сведений зависящих от функциональных опций,
// значение которой хранится в константе
//
Процедура УстановитьДоступностьНаборовДополнительныхРеквизитовПоЗначениюКонстанты(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьДополнительныхРеквизитов(Источник.Метаданные(), Источник.Значение);
	
КонецПроцедуры

// Обработчик обновления наборов дополнительных реквизитов и сведений зависящих от функциональных опций,
// значение которых хранится в ресурсе регистра сведений
//
Процедура УстановитьДоступностьНаборовДополнительныхРеквизитовПоРегиструСведений(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьДополнительныхРеквизитов(Источник.Метаданные(), Источник);
	
КонецПроцедуры

// Устанавливает доступность наборов дополнительных реквизитов и сведений по метаданным
// объекта в котором хранится значение функциональных опций. Возможно использовать для
// обновления доступности наборов дополнительных реквизитов и сведений зависящих от отдельных объектов,
// хранящих значения функциональных опций.
//
// Параметры:
//		МетаданныеИсточника	- ОбъектМетаданных
//		ЗначенияИсточника	- Неопределено, значение константы или набор записей регистра сведений
//		ПараметрыОбновления	- Структура
//
Процедура УстановитьДоступностьДополнительныхРеквизитов(МетаданныеИсточника, ЗначенияИсточника = Неопределено, ПараметрыОбновления = Неопределено) Экспорт
	
	Значения = Новый Соответствие;
	
	Если ЗначенияИсточника = Неопределено Тогда
		Значения = ЗначенияОбъектаЗначенийФункциональныхОпций(МетаданныеИсточника);
	Иначе
		
		Если Метаданные.Константы.Найти(МетаданныеИсточника.Имя) <> Неопределено Тогда
			Значения.Вставить(МетаданныеИсточника.ПолноеИмя(), ЗначенияИсточника);
		Иначе
			
			Если ЗначенияИсточника.Количество() = 0 Тогда
				
				СписокРесурсов = Новый Массив;
				Для Каждого Ресурс Из МетаданныеИсточника.Ресурсы Цикл
					
					Ключ = МетаданныеИсточника.ПолноеИмя() + ".Ресурс." + Ресурс.Имя;
					Значения.Вставить(Ключ, Ложь);
					
				КонецЦикла;
				
			Иначе
				
				Для Каждого Запись Из ЗначенияИсточника Цикл
					
					СписокРесурсов = Новый Массив;
					Для Каждого Ресурс Из МетаданныеИсточника.Ресурсы Цикл
						
						Ключ = МетаданныеИсточника.ПолноеИмя() + ".Ресурс." + Ресурс.Имя;
						ЗначениеРесурса = Значения.Получить(Ключ);
						Если ЗначениеРесурса = Неопределено Тогда
							ЗначениеРесурса = Запись[Ресурс.Имя];
						Иначе
							ЗначениеРесурса = Макс(ЗначениеРесурса, Запись[Ресурс.Имя]);
						КонецЕсли;
						
						Значения.Вставить(Ключ, ЗначениеРесурса);
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьДополнительныхРеквизитовПоПолномуИмениОбъекта(МетаданныеИсточника, Значения);
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
	
КонецПроцедуры

// Регистрирует набор дополнительных реквизитов и сведений.
// Предназначена для вызова в УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств().
//
// Параметры:
//  Наборы - ДеревоЗначений - См. описание 1го параметра процедуры
//      УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств().
//  Идентификатор - Строка - Уникальный идентификатор набора.
//  ОбъектМетаданных - ОбъектМетаданных - Владелец набора.
//
Процедура ЗарегистрироватьНаборСвойств(Наборы, Идентификатор, ОбъектМетаданных) Экспорт
	Набор = Наборы.Строки.Добавить();
	Набор.Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	Набор.Имя = СтрЗаменить(ОбъектМетаданных.ПолноеИмя(), ".", "_");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьДоступностьДополнительныхРеквизитовПоПолномуИмениОбъекта(МетаданныеИсточника, Значения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначенияДругихФункциональныхОпций = Новый Соответствие;
	
	ФункциональныеОпции = ФункциональныеОпцииУправляемыеОбъектом(МетаданныеИсточника);
	Для Каждого ИмяФункциональнойОпции Из ФункциональныеОпции Цикл
		
		ФункциональнаяОпция = Метаданные.НайтиПоПолномуИмени(ИмяФункциональнойОпции);
		
		ОбъектыСоСвойствами = ЗарплатаКадрыПовтИсп.ОбъектыСДополнительнымиСвойствамиУправляемыеФункциональнымиОпциями(ИмяФункциональнойОпции);
		Для Каждого ОписаниеОбъекта Из ОбъектыСоСвойствами Цикл
			
			СтруктураПараметров = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
			Используется = Значения.Получить(ФункциональнаяОпция.Хранение.ПолноеИмя());
			
			Если Не Используется Тогда
				
				ФункциональныеОпцииУправляющиеОбъектом = ЗарплатаКадрыПовтИсп.ОбъектыУправляемыеНесколькимиФункциональнымиОпциями().Получить(ОписаниеОбъекта.Ключ);
				Если ФункциональныеОпцииУправляющиеОбъектом <> Неопределено Тогда
					
					Для Каждого ИмяФункциональнойОпцииУправляющейОбъектом Из ФункциональныеОпцииУправляющиеОбъектом Цикл
						
						Если ИмяФункциональнойОпцииУправляющейОбъектом = ИмяФункциональнойОпции Тогда
							Продолжить;
						КонецЕсли;
						
						Если ЗначениеИспользуется(Метаданные.НайтиПоПолномуИмени(ИмяФункциональнойОпцииУправляющейОбъектом), ЗначенияДругихФункциональныхОпций) Тогда
							Используется = Истина;
							Прервать;
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
			СтруктураПараметров.Используется = Используется;
			
			УправлениеСвойствами.УстановитьПараметрыНабораСвойств(ОписаниеОбъекта.Значение, СтруктураПараметров);
			
		КонецЦикла;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ФункциональныеОпцииУправляемыеОбъектом(МетаданныеИсточника)
	
	Возврат ЗарплатаКадрыПовтИсп.ОбъектыУправляющиеФункциональнымиОпциями().Получить(МетаданныеИсточника.ПолноеИмя());
	
КонецФункции

Функция ЗначениеИспользуется(ФункциональнаяОпция, ЗначенияДругихФункциональныхОпций)
	
	ИмяХранения = ФункциональнаяОпция.Хранение.ПолноеИмя();
	
	Если СтрЧислоВхождений(ИмяХранения, ".") = 1 Тогда
		ПолноеИмяОбъекта = ИмяХранения;
	Иначе
		ПолноеИмяОбъекта = Лев(ИмяХранения, СтрНайти(ИмяХранения, ".", , , 2) - 1);
	КонецЕсли;
	
	ЗначенияОбъекта = ЗначенияДругихФункциональныхОпций.Получить(ПолноеИмяОбъекта);
	Если ЗначенияОбъекта = Неопределено Тогда
		ЗначенияОбъекта = ЗначенияОбъектаЗначенийФункциональныхОпций(Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта));
		ЗначенияДругихФункциональныхОпций.Вставить(ПолноеИмяОбъекта, ЗначенияОбъекта)
	КонецЕсли;
	
	Возврат ЗначенияОбъекта.Получить(ИмяХранения);
	
КонецФункции

Функция ЗначенияОбъектаЗначенийФункциональныхОпций(МетаданныеИсточника)
	
	Значения = Новый Соответствие;
	
	Если Метаданные.Константы.Найти(МетаданныеИсточника.Имя) <> Неопределено Тогда
		Значения.Вставить(МетаданныеИсточника.ПолноеИмя(), Константы[МетаданныеИсточника.Имя].Получить());
	Иначе
		
		СписокРесурсов = Новый Массив;
		Для Каждого Ресурс Из МетаданныеИсточника.Ресурсы Цикл
			СписокРесурсов.Добавить("ЕСТЬNULL(МАКСИМУМ(ТаблицаРегистраСведений." + Ресурс.Имя + "), ЛОЖЬ) КАК " + Ресурс.Имя);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	*
			|ИЗ
			|	#ТаблицаРегистраСведений КАК ТаблицаРегистраСведений";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "*", СтрСоединить(СписокРесурсов, ", "));
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ТаблицаРегистраСведений", МетаданныеИсточника.ПолноеИмя());
		
		ЗначенияОпций = Запрос.Выполнить().Выбрать();
		ЗначенияОпций.Следующий();
		
		Для Каждого Ресурс Из МетаданныеИсточника.Ресурсы Цикл
			Значения.Вставить(МетаданныеИсточника.ПолноеИмя() + ".Ресурс." + Ресурс.Имя, ЗначенияОпций[Ресурс.Имя]);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

#КонецОбласти
