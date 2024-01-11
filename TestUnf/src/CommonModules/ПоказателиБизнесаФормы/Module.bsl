////////////////////////////////////////////////////////////////////////////////
// Подсистема "Развитие бизнеса"
//
// Процедуры и функции для работы с формами показателей
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет переданное условное оформление для деревьев формы
//
// Параметры:
//  УсловноеОформление - УсловноеОформление
//
Процедура УстановитьУсловноеОформление(УсловноеОформление) Экспорт
	
	УсловноеОформление.Элементы.Очистить();
	
	ИменаДеревьев = ИменаДеревьевФормы();
	
	Для каждого ИмяДерева Из ИменаДеревьев Цикл
		
		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяДерева + ".ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Доход, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяДерева);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветФона", Новый Цвет(238,255,240));
		
		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяДерева + ".ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Расход, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяДерева);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветФона", Новый Цвет(255,238,240));
		
		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяДерева + ".ЭтоПроцент", Истина, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяДерева);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Формат","ЧФ='Ч %'");
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет служебные реквизиты формы значениями по умолчанию
//
// Параметры:
//  Форма - УправляемаяФорма
//
Процедура ИнициализироватьСлужебныеРеквизитыФормы(Форма) Экспорт
	
	// Добавляем предопределенные варианты
	Если Форма.ВидыОтчетов.Количество() = 0 Тогда
		Форма.ВидыОтчетов.Добавить(Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы, "ДоходыРасходы");
		Форма.ВидыОтчетов.Добавить(Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток, "ДенежныйПоток");
		Форма.ВидыОтчетов.Добавить(Перечисления.ВидыФинансовыхОтчетов.Баланс, "Баланс");
	КонецЕсли;
	
	Форма.ВыбранныйОтчет = Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы;
	
КонецПроцедуры

// Заполняет деревья формы списками показателей отчетов из справочника
//
// Параметры:
//  Форма - УправляемаяФорма
//  ВидОтчетаОтбор - Перечисление.ВидыФинансовыхОтчетов - если параметр заполнен, будут загружены только показатели по
//                                                        данному виду отчета
//  ЗаполнятьДиаграммы - Булево - Истина, если необходимо также создавать точки диаграммы для добавляемых показателей
//  ЗаполнятьИдентификаторыСтрок - Булево - Истина, если необходимо также заполнять идентификаторы для пересчета формул
//
Процедура ЗагрузитьПоказателиОтчетов(Форма, ВидОтчетаОтбор = Неопределено, ЗаполнятьДиаграммы = Ложь, ЗаполнятьИдентификаторыСтрок = Ложь) Экспорт
	
	ВременноеСоответствиеЗависимыхЭлементов 	= Новый Соответствие;
	ВременныеИдентификаторыПоказателей 			= Новый Соответствие;
	ВременныеИдентификаторыПоказателейДляФормул = Новый Соответствие;
	
	Для каждого ВидОтчета Из Форма.ВидыОтчетов Цикл
		
		Если ЗначениеЗаполнено(ВидОтчетаОтбор) И ВидОтчета.Значение <> ВидОтчетаОтбор Тогда
			Продолжить;
		КонецЕсли;
		
		Выборка = ПоказателиБизнеса.ВыборкаДереваПоказателей(ВидОтчета.Значение);
		ИмяДерева = "ДеревоПоказателей" + ВидОтчета.Представление;
		ВременноеДеревоПоказателей = ДанныеФормыВЗначение(Форма[ИмяДерева], Тип("ДеревоЗначений"));
		ВременноеДеревоПоказателей.Строки.Очистить();
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаРодителя = Неопределено;
			
			Если ЗначениеЗаполнено(Выборка.Родитель) Тогда
				СтрокаРодителя = ВременноеДеревоПоказателей.Строки.Найти(Выборка.Родитель, "Показатель", Истина);
			КонецЕсли;
			
			НоваяСтрока = ?(СтрокаРодителя = Неопределено, ВременноеДеревоПоказателей.Строки.Добавить(), СтрокаРодителя.Строки.Добавить());
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ЭтоВерхнийУровеньИерархии = НЕ ЗначениеЗаполнено(Выборка.Родитель);
			
			// Диаграмма
			Если ЗаполнятьДиаграммы Тогда
				ДобавитьТочкуДиаграммы(Форма, ВидОтчета.Значение, НоваяСтрока);
			КонецЕсли;
			
			// Зависимые показатели
			Если ЗаполнятьИдентификаторыСтрок Тогда
				
				Если Выборка.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Формула 
					И ЗначениеЗаполнено(СокрЛП(Выборка.СтрокаФормулы)) Тогда
					
					Операнды = Новый Массив;
					ПоказателиБизнесаФормулы.ПарсингФормулыНаИдентификаторыОперандов(Выборка.СтрокаФормулы, Операнды);
					
					Для каждого Операнд Из Операнды Цикл
						
						ЗависимыеЭлементыОперанда = ВременноеСоответствиеЗависимыхЭлементов.Получить(Операнд);
						Если ЗависимыеЭлементыОперанда = Неопределено Тогда
							ЗависимыеЭлементыОперанда = Новый Массив;
						КонецЕсли;
						
						ЗависимыеЭлементыОперанда.Добавить(Выборка.ИдентификаторПоказателя);
						ВременноеСоответствиеЗависимыхЭлементов.Вставить(Операнд, ЗависимыеЭлементыОперанда);
						
					КонецЦикла;
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ВременноеДеревоПоказателей.Строки.Сортировать("Порядок", Истина);
		ЗначениеВДанныеФормы(ВременноеДеревоПоказателей, Форма[ИмяДерева]);
		
	КонецЦикла;
	
	// Заполнение служебных соответствий, которые хранятся в реквизитах формы
	Если ЗаполнятьИдентификаторыСтрок Тогда
		
		Для каждого ВидОтчета Из Форма.ВидыОтчетов Цикл
			ИмяДерева = "ДеревоПоказателей" + ВидОтчета.Представление;
			ЗаполнитьИдентификаторыПоказателейРекурсивно(Форма[ИмяДерева].ПолучитьЭлементы(), ВременныеИдентификаторыПоказателей);
			ЗаполнитьИдентификаторыПоказателейДляФормулРекурсивно(Форма[ИмяДерева].ПолучитьЭлементы(), ВременныеИдентификаторыПоказателейДляФормул);
		КонецЦикла;
		
		Форма.ИдентификаторыПоказателей 		   = Новый ФиксированноеСоответствие(ВременныеИдентификаторыПоказателей);
		Форма.ИдентификаторыПоказателейДляФормул   = Новый ФиксированноеСоответствие(ВременныеИдентификаторыПоказателейДляФормул);
		Форма.СоответствиеЗависимыхЭлементов 	   = Новый ФиксированноеСоответствие(ВременноеСоответствиеЗависимыхЭлементов);
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в соответствующую выбранному отчету диаграмму точку по переданной строке дерева
//
// Параметры:
//  Форма - УправляемаяФорма
//  ВидОтчета - Перечисление.ВидыФинансовыхОтчетов
//  СтрокаДерева - СтрокаДереваЗначений
//
Процедура ДобавитьТочкуДиаграммы(Форма, ВидОтчета, СтрокаДерева) Экспорт
	
	Диаграмма = Неопределено;
	
	Если ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы Тогда
		 
		Если СтрокаДерева.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Доход Тогда
			Диаграмма = Форма.ДиаграммаДоходы;
		ИначеЕсли СтрокаДерева.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Расход Тогда
			Диаграмма = Форма.ДиаграммаРасходы;
		КонецЕсли;
		
	ИначеЕсли ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток Тогда
		
		Если СтрокаДерева.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Доход Тогда
			Диаграмма = Форма.ДиаграммаПоступления;
		ИначеЕсли СтрокаДерева.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Расход Тогда
			Диаграмма = Форма.ДиаграммаВыбытия;
		КонецЕсли;
		
	Иначе // Баланс
		Возврат;
	КонецЕсли;
	
	Если Диаграмма <> Неопределено Тогда
		ТекущаяСерия = Диаграмма.УстановитьСерию(СтрокаДерева.Показатель);
		Диаграмма.УстановитьЗначение(0, ТекущаяСерия, 0);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список значений периодами, с учетом выбранной периодичности
//
// Параметры:
//  СписокПериодов - СписокЗначений
//  ПериодПланирования - СтандартныйПериод
//  Периодичность - Перечисление.Периодичность
//
Процедура ЗаполнитьСписокПериодов(СписокПериодов, ПериодПланирования, Периодичность) Экспорт
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		ПервыйПериод = НачалоМесяца(ПериодПланирования.ДатаНачала);
		ПоследнийПериод = НачалоМесяца(ПериодПланирования.ДатаОкончания);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ПервыйПериод = НачалоКвартала(ПериодПланирования.ДатаНачала);
		ПоследнийПериод = НачалоКвартала(ПериодПланирования.ДатаОкончания);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		
		МесяцДатыНачала = Месяц(ПериодПланирования.ДатаНачала);
		ПервыйПериод = НачалоГода(ПериодПланирования.ДатаНачала);
		Если МесяцДатыНачала > 6 Тогда
			ПервыйПериод = ДобавитьМесяц(ПервыйПериод, 6);
		КонецЕсли;
		
		МесяцДатыОкончания = Месяц(ПериодПланирования.ДатаОкончания);
		ПоследнийПериод = НачалоГода(ПериодПланирования.ДатаОкончания);
		Если МесяцДатыОкончания > 6 Тогда
			ПоследнийПериод = ДобавитьМесяц(ПоследнийПериод, 6);
		КонецЕсли;
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		ПервыйПериод = НачалоГода(ПериодПланирования.ДатаНачала);
		ПоследнийПериод = НачалоГода(ПериодПланирования.ДатаОкончания);
	Иначе // Другая периодичность не поддерживаются
		Возврат;
	КонецЕсли;
	
	СписокПериодов.Очистить();
	Пока ПервыйПериод <= ПоследнийПериод Цикл
		СписокПериодов.Добавить(ПервыйПериод);
		
		Если Периодичность = Перечисления.Периодичность.Месяц Тогда
			ПервыйПериод = КонецМесяца(ПервыйПериод) + 1;
		ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
			ПервыйПериод = КонецКвартала(ПервыйПериод) + 1;
		ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
			ПервыйПериод = ДобавитьМесяц(ПервыйПериод, 6);
		Иначе // Год
			ПервыйПериод = КонецГода(ПервыйПериод) + 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Добавляет на форму новый реквизит дерева, в котором будет храниться суммы по переданному периоду
//
// Параметры:
//  ИмяДерева - Строка - Имя дерева формы, в который необходимо добавить новую колонку периода
//  Период - Дата
//
Функция НовыйРеквизитПериода(ИмяДерева, Период) Экспорт
	
	ИмяКолонки = СформироватьИмяКолонкиПоПериоду(Период);
	Возврат Новый РеквизитФормы(ИмяКолонки, Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)), ИмяДерева);
	
КонецФункции

// Возвращает массив, который содержит строки с именами деревьев показателей на форме
//
Функция ИменаДеревьевФормы() Экспорт
	
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("ДеревоПоказателейДоходыРасходы"); // Не локализуется
	МассивИмен.Добавить("ДеревоПоказателейДенежныйПоток"); // Не локализуется
	МассивИмен.Добавить("ДеревоПоказателейБаланс"); // Не локализуется
	
	Возврат МассивИмен;
	
КонецФункции

// Возвращает отформатированный заголовок колонки дерева формы
//
// Параметры:
//  Период - Дата
//  Периодичность - Перечисление.Периодичность
//
Функция ЗаголовокКолонки(Период, Периодичность) Экспорт
	
	ЗаголовокКолонки = "";
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		
		ЗаголовокКолонки = ВРег(Формат(Период, НСтр("ru = 'ДФ=''MMMM yy'''")));
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		
		Год = Формат(Период, НСтр("ru = 'ДФ=yy'"));
		ЗаголовокКвартала = НСтр("ru = '%1 КВАРТАЛ %2'");
		
		Если Месяц(Период) <= 3 Тогда
			НомерКвартала = "1";
		ИначеЕсли Месяц(Период) <= 6 Тогда
			НомерКвартала = "2";
		ИначеЕсли Месяц(Период) <= 9 Тогда
			НомерКвартала = "3";
		Иначе
			НомерКвартала = "4";
		КонецЕсли;
		
		ЗаголовокКолонки = СтрШаблон(ЗаголовокКвартала, НомерКвартала, Год);
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		
		Год = Формат(Период, НСтр("ru = 'ДФ=yy'"));
		ЗаголовокПолугодие = НСтр("ru = '%1 ПОЛУГОДИЕ %2'");
		
		Если Месяц(Период) <= 6 Тогда
			НомерПолугодия = "1";
		Иначе
			НомерПолугодия = "2";
		КонецЕсли;
		
		ЗаголовокКолонки = СтрШаблон(ЗаголовокПолугодие, НомерПолугодия, Год);
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		
		ЗаголовокКолонки = ВРег(Формат(Период, НСтр("ru = 'ДФ=yyyy'")));
		 
	Иначе
		 Возврат ЗаголовокКолонки;
	КонецЕсли;
	
	Возврат ЗаголовокКолонки;
	
КонецФункции

// Заполняет переданную диаграмму временными значениями для корректного отображения при открытии формы
//
// Параметры:
//  Диаграмма - Диаграмма
//
Процедура ИнициализироватьПустуюДиаграмму(Диаграмма) Экспорт
	
	Если Диаграмма.Точки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокДиаграммы = Диаграмма.Точки[0].Текст;
	
	Серия1 = Диаграмма.Серии.Вставить(0, "ПервыйДемоПоказатель"); // Не локализуется
	Серия1.Цвет = Новый Цвет(192, 192, 192);
	Серия2 = Диаграмма.Серии.Вставить(0, "ВторойДемоПоказатель"); // Не локализуется
	Серия2.Цвет = Новый Цвет(220, 220, 220);
	Серия3 = Диаграмма.Серии.Вставить(0, "ТретийДемоПоказатель"); // Не локализуется
	Серия3.Цвет = Новый Цвет(228, 228, 228);
	
	КоличествоЗначений = 3;
	
	ГСЧ = Новый ГенераторСлучайныхЧисел(СтрДлина(ЗаголовокДиаграммы));
	ОбщаяСумма = 0;
	
	Для Итератор = 0 По КоличествоЗначений - 1 Цикл
		СлучайнаяСумма = ГСЧ.СлучайноеЧисло(10000, 100000);
		ОбщаяСумма = ОбщаяСумма + СлучайнаяСумма;
		Диаграмма.УстановитьЗначение(0, Итератор, СлучайнаяСумма,, " ");
	КонецЦикла;
	
	Диаграмма.ОбластьЗаголовка.Текст = ЗаголовокДиаграммы + ": 0";
	
КонецПроцедуры

// Очищает служебные реквизиты формы, которая содержит списки показателей бизнеса
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, реквизиты которой необходимо очистить
//
Процедура ОчиститьФорму(Форма) Экспорт
	
	// Удалим колонки и реквизиты периодов
	МассивУдалить = Новый Массив;
	
	ИменаДеревьев = ИменаДеревьевФормы();
	
	Для каждого ИмяДерева Из ИменаДеревьев Цикл
		Для каждого Элемент Из Форма.Элементы[ИмяДерева].ПодчиненныеЭлементы Цикл
			Если Найти(Элемент.Имя, ИмяДерева + "_") > 0 Тогда
				МассивУдалить.Добавить(Элемент);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	
	Для каждого Элемент Из МассивУдалить Цикл
		Форма.Элементы.Удалить(Элемент);
	КонецЦикла; 
	
	МассивУдалить = Новый Массив;
	
	Для каждого ИмяДерева Из ИменаДеревьев Цикл
		МассивРеквизитов = Форма.ПолучитьРеквизиты(ИмяДерева);
		Для каждого Реквизит Из МассивРеквизитов Цикл
			Если Найти(Реквизит.Имя,"_") > 0 Тогда
				МассивУдалить.Добавить(Реквизит.Путь+"."+Реквизит.Имя);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	
	Если МассивУдалить.Количество() > 0 Тогда
		Форма.ИзменитьРеквизиты(,МассивУдалить);
	КонецЕсли; 
	
	Форма.ПериодыПланирования.Очистить();
	
	Для каждого ИмяДерева Из ИменаДеревьев Цикл
		ОчиститьИтогиРекурсивно(Форма[ИмяДерева].ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры


// Очищает суммы показателей в переданном дереве
//
// Параметры:
//  Дерево - ДанныеФормыКоллекцияЭлементовДерева - Дерево для очистки
//  Периоды - СписокЗначений - Список ПериодовПланирования
//
Процедура ОчиститьЗначенияДереваРекурсивно(Дерево, Периоды) Экспорт

	Для каждого СтрокаДерева Из Дерево Цикл
		Для каждого Период Из Периоды Цикл
			ИмяКолонки = СформироватьИмяКолонкиПоПериоду(Период.Значение);
			СтрокаДерева[ИмяКолонки] = 0;
		КонецЦикла;
		ОчиститьЗначенияДереваРекурсивно(СтрокаДерева.ПолучитьЭлементы(), Периоды);
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИдентификаторыПоказателейРекурсивно(Показатели, ВременныеИдентификаторыПоказателей)
	
	Для каждого СтрокаПоказателя Из Показатели Цикл
		
		ВременныеИдентификаторыПоказателей.Вставить(СтрокаПоказателя.Показатель, СтрокаПоказателя.ПолучитьИдентификатор());
		ПодчиненныеЭлементыПоказателя = СтрокаПоказателя.ПолучитьЭлементы();
		
		Если ПодчиненныеЭлементыПоказателя.Количество() <> 0 Тогда
			ЗаполнитьИдентификаторыПоказателейРекурсивно(ПодчиненныеЭлементыПоказателя, ВременныеИдентификаторыПоказателей)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьИдентификаторыПоказателейДляФормулРекурсивно(Показатели, ВременныеИдентификаторыПоказателей)
	
	Для каждого СтрокаПоказателя Из Показатели Цикл
		
		ВременныеИдентификаторыПоказателей.Вставить(СтрокаПоказателя.ИдентификаторПоказателя, СтрокаПоказателя.ПолучитьИдентификатор());
		ПодчиненныеЭлементыПоказателя = СтрокаПоказателя.ПолучитьЭлементы();
		
		Если ПодчиненныеЭлементыПоказателя.Количество() <> 0 Тогда
			ЗаполнитьИдентификаторыПоказателейДляФормулРекурсивно(ПодчиненныеЭлементыПоказателя, ВременныеИдентификаторыПоказателей)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьИмяКолонкиПоПериоду(Знач Период)
	Возврат Формат(Период,"ДФ=_ггггММдд");
КонецФункции

Процедура ОчиститьИтогиРекурсивно(ЭлементыДерева)
	
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		ЭлементДерева.ИтогоПлан = 0;
		ЕстьКолонкаФакт = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭлементДерева, "ИтогоФакт");
		Если ЕстьКолонкаФакт Тогда
			ЭлементДерева.ИтогоФакт = 0;
		КонецЕсли;
		ОчиститьИтогиРекурсивно(ЭлементДерева.ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
