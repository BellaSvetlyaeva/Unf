
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ВходящаяТранспортнаяОперацияВЕТИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияВЕТИС.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения, "ДвиженияСерийТоваров");
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура")Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
	//ВСД, массив ВСД, (ТТН, массив ТТН - преобразовываются при вызове заполнения), плюс значения заполнения
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС")ИЛИ
		(ТипДанныхЗаполнения = Тип("Массив")
		И ДанныеЗаполнения.Количество()
		И ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС"))Тогда 
		ЗаполнитьВходящуюТранспортнуюОперациюВЕТИСПоВетеринарноСопроводительномуДокументуВЕТИС(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВыполнятьПроверкиРеквизитовВетИС = Истина;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ТекущееСостояние = РегистрыСведений.СтатусыДокументовВЕТИС.ТекущееСостояние(Ссылка);
		КонечныеСтатусы = Документы.ВходящаяТранспортнаяОперацияВЕТИС.КонечныеСтатусы(Ложь);
		Если КонечныеСтатусы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
			ВыполнятьПроверкиРеквизитовВетИС = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьПроверкиРеквизитовВетИС Тогда
		
		ПеревозкаОтсутствует = ГрузоотправительПредприятие = ГрузополучательПредприятие;
		
		ЭтоИмпорт = ЗначениеЗаполнено(ГрузоотправительХозяйствующийСубъект)
			И ГрузоотправительХозяйствующийСубъект = ГрузополучательХозяйствующийСубъект
			И Не ЗначениеЗаполнено(ГрузоотправительПредприятие);
		
		ПроверкаРеквизитаНеВыполняется = Новый Соответствие;
		ПроверкаРеквизитаНеВыполняется.Вставить("ГрузоотправительПредприятие", ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("ГрузоотправительХозяйствующийСубъект", ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("ДатаТТН", Не ТТНУказан Или ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("НомерТТН", Не ТТНУказан Или ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("СерияТТН", Не ТТНУказан Или ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("ТипТТН", Не ТТНУказан Или ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("НомерАвтомобильногоКонтейнера", ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("НомерАвтомобильногоПрицепа", ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("НомерТранспортногоСредства", ПеревозкаОтсутствует Или ГашениеНаСВХ Или ТипТранспорта = Перечисления.ТипыТранспортаВЕТИС.ПерегонСкота);
		ПроверкаРеквизитаНеВыполняется.Вставить("ТипТранспорта", ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("ПеревозчикХозяйствующийСубъект", ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("СпособХранения", ПеревозкаОтсутствует Или ГашениеНаСВХ);
		ПроверкаРеквизитаНеВыполняется.Вставить("ТоварыУточнение.Количество", Истина);
		ПроверкаРеквизитаНеВыполняется.Вставить("ТоварыУточнение.КоличествоВЕТИС", Истина);
		
		Для каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
			Если ПроверкаРеквизитаНеВыполняется.Получить(ПроверяемыйРеквизит) = Истина Тогда
				МассивНепроверяемыхРеквизитов.Добавить(ПроверяемыйРеквизит);
			КонецЕсли;
		КонецЦикла;
		
		Если Не ПеревозкаОтсутствует И Не ГашениеНаСВХ Тогда
			Если ТипТранспорта = Перечисления.ТипыТранспортаВЕТИС.ПерегонСкота Тогда
				РеквизитыТранспортногоСредства = "ТипТранспорта";
			Иначе
				РеквизитыТранспортногоСредства = "НомерАвтомобильногоКонтейнера,НомерАвтомобильногоПрицепа,НомерТранспортногоСредства,ТипТранспорта";
			КонецЕсли;
			
			ТранпортноеСредствоЗаполнено = Истина;
			Для каждого РеквизитТранспортногоСредства Из СтрРазделить(РеквизитыТранспортногоСредства, ",") Цикл
				Если ПроверяемыеРеквизиты.Найти(РеквизитТранспортногоСредства) <> Неопределено
					И Не ЗначениеЗаполнено(ЭтотОбъект[РеквизитТранспортногоСредства]) Тогда
					МассивНепроверяемыхРеквизитов.Добавить(РеквизитТранспортногоСредства);
					ТранпортноеСредствоЗаполнено = Ложь;
				КонецЕсли;
			КонецЦикла;
			Если Не ТранпортноеСредствоЗаполнено Тогда
				ТекстОшибки = НСтр("ru = 'Не все данные транспортного средства заполнены'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "ПредставлениеТранспортногоСредства",, Отказ);
			КонецЕсли;
		КонецЕсли;
		
		ПредставлениеТЧ = Метаданные().ТабличныеЧасти.Товары.Синоним;
		ТипЖивыеЖивотные =
			ИнтеграцияВЕТИСВызовСервера.ПродукцияПринадлежитТипуЖивыеЖивотные(Товары.ВыгрузитьКолонку("Продукция"));
		
		Для каждого СтрокаТовары Из Товары Цикл
			
			Если СтрокаТовары.ЕстьУточнения Тогда
				
				ОтборУточнений = Новый Структура("ИдентификаторСтроки", СтрокаТовары.ИдентификаторСтроки);
				ТоварыУточнения = ТоварыУточнение.НайтиСтроки(ОтборУточнений);
				
				Для каждого СтрокаУточнения Из ТоварыУточнения Цикл
					Если Не ЗначениеЗаполнено(СтрокаУточнения.Номенклатура) И ЗначениеЗаполнено(СтрокаУточнения.Количество) Тогда
						
						Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовары.НомерСтроки, "ЕстьУточнения");
						ШаблонСообщенияСроки = НСтр("ru = 'Нет данных по уточняемым товарам в строке %1 списка ""%2""'");
						ТекстСообщения = СтрШаблон(ШаблонСообщенияСроки, СтрокаТовары.НомерСтроки, ПредставлениеТЧ);
						ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
						Прервать;
						
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТовары.Продукция)
				И НЕ ЗначениеЗаполнено(СтрокаТовары.СрокГодностиНачалоПериода)
				И НЕ ТипЖивыеЖивотные[СтрокаТовары.Продукция]
				И ИнтеграцияВЕТИСВызовСервера.ПродукцияИмеетСрокГодности(СтрокаТовары.Продукция) Тогда
				
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовары.НомерСтроки, "ПредставлениеСрокГодности");
				ШаблонСообщенияСроки = НСтр("ru = 'Не заполнено поле ""%1"" в строке %2 списка ""%3""'");
				ТекстСообщения = СтрШаблон(ШаблонСообщенияСроки, НСтр("ru = 'Срок годности'"), СтрокаТовары.НомерСтроки, ПредставлениеТЧ);
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЭтоИмпорт Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СпособХранения");
			МассивНепроверяемыхРеквизитов.Добавить("ГрузоотправительПредприятие");
		КонецЕсли;
		
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ГрузоотправительПредприятие");
		МассивНепроверяемыхРеквизитов.Добавить("ГрузоотправительХозяйствующийСубъект");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаТТН");
		МассивНепроверяемыхРеквизитов.Добавить("НомерТТН");
		МассивНепроверяемыхРеквизитов.Добавить("СерияТТН");
		МассивНепроверяемыхРеквизитов.Добавить("ТипТТН");
		МассивНепроверяемыхРеквизитов.Добавить("НомерАвтомобильногоКонтейнера");
		МассивНепроверяемыхРеквизитов.Добавить("НомерАвтомобильногоПрицепа");
		МассивНепроверяемыхРеквизитов.Добавить("НомерТранспортногоСредства");
		МассивНепроверяемыхРеквизитов.Добавить("ТипТранспорта");
		МассивНепроверяемыхРеквизитов.Добавить("ПеревозчикХозяйствующийСубъект");
		МассивНепроверяемыхРеквизитов.Добавить("СпособХранения");
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыУточнение.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыУточнение.КоличествоВЕТИС");
		
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ПроверитьЗаполнениеКоличества(ЭтотОбъект, Отказ, МассивНепроверяемыхРеквизитов);
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Товары.Итог("ВозвращаемоеКоличествоВЕТИС") = 0 И МаршрутВозврата.Количество() <> 0 Тогда
		МаршрутВозврата.Очистить();
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИнтеграцияВЕТИС.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект);
	
	Если ТоварыУточнение.Количество() > 0 Тогда
		ТаблицаУточнений = ТоварыУточнение.Выгрузить(, "ИдентификаторСтроки,Номенклатура,Характеристика,Серия,Количество");
		ТаблицаУточнений.Колонки.Добавить("ЗаписьСкладскогоЖурнала", Новый ОписаниеТипов("СправочникСсылка.ЗаписиСкладскогоЖурналаВЕТИС"));
		ТаблицаУточнений.Колонки.Добавить("Продукция", Новый ОписаниеТипов("СправочникСсылка.ПродукцияВЕТИС"));
		ТаблицаУточнений.Колонки.Добавить("КоличествоЗаполнено");
		Для Каждого СтрокаУточнение Из ТаблицаУточнений Цикл
			СтрокаУточнение.КоличествоЗаполнено = ЗначениеЗаполнено(СтрокаУточнение.Количество);
		КонецЦикла;
		ТаблицаУточнений = ТаблицаУточнений.Скопировать(Новый Структура("КоличествоЗаполнено", Истина));
		ТаблицаУточнений.Индексы.Добавить("ИдентификаторСтроки");
		Для Каждого СтрокаТовар Из Товары Цикл
			Для Каждого СтрокаУточнение Из ТаблицаУточнений.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаТовар.ИдентификаторСтроки)) Цикл
				ЗаполнитьЗначенияСвойств(СтрокаУточнение, СтрокаТовар, "ЗаписьСкладскогоЖурнала,Продукция");
			КонецЦикла;
		КонецЦикла;
		ИнтеграцияВЕТИС.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, ТаблицаУточнений);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияВЕТИС.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ЗаписатьСтатусДокументаВЕТИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	Идентификатор     = "";
	
	СерияАктаНесоответствия = "";
	НомерАктаНесоответствия = "";
	ДатаАктаНесоответствия  = Неопределено;
	ПричинаНесоответствия   = "";
	
	ПоляОчисткиТаблиц = Новый Структура("РезультатПроверкиПравилРегионализации,УсловияРегионализацииВыполнены,
		|ВетеринарноСопроводительныйДокументНаВозврат,ЗаписьСкладскогоЖурнала,ВетеринарноСопроводительныйДокумент");
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти,ПоляОчисткиТаблиц);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из МаршрутВозврата Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ПоляОчисткиТаблиц)
	КонецЦикла;
	
	Регионализация.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВходящуюТранспортнуюОперациюВЕТИСПоВетеринарноСопроводительномуДокументуВЕТИС(ДанныеЗаполнения, ДополнитьДокумент = Ложь) 
	
	Если Не ДополнитьДокумент Тогда
	
		ДанныеШапки = Документы.ВходящаяТранспортнаяОперацияВЕТИС.ВыборкаДанныхШапкиВСД(ДанныеЗаполнения);
	
		Если ДанныеШапки.Следующий() Тогда
		
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеШапки);
			
			Если ГрузоотправительПредприятие.Пустая() И ГрузополучательПредприятие.Пустая() Тогда
				ГашениеНаСВХ = Истина;
			КонецЕсли;
			
			Маршрут.Очистить();
			ДанныеМаршрута = ДанныеШапки.Маршрут.Выгрузить();
			
			ДанныеПоследнегоТранспорта = Неопределено;
			Для Каждого СтрокаТЧ Из ДанныеМаршрута Цикл
				
				Если ДанныеМаршрута.Индекс(СтрокаТЧ) = 0 Или СтрокаТЧ.СПерегрузкой Тогда
					ДанныеПоследнегоТранспорта = СтрокаТЧ;
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(Маршрут.Добавить(), СтрокаТЧ);
				
			КонецЦикла;
			
			Если ДанныеПоследнегоТранспорта <> Неопределено Тогда
				
				ЭтотОбъект.ТипТранспорта                 = ДанныеПоследнегоТранспорта.ТипТранспорта;
				ЭтотОбъект.НомерТранспортногоСредства    = ДанныеПоследнегоТранспорта.НомерТранспортногоСредства;
				ЭтотОбъект.НомерАвтомобильногоПрицепа    = ДанныеПоследнегоТранспорта.НомерАвтомобильногоПрицепа;
				ЭтотОбъект.НомерАвтомобильногоКонтейнера = ДанныеПоследнегоТранспорта.НомерАвтомобильногоКонтейнера;
				
			КонецЕсли;
		
			Товары.Очистить();
			ТоварыУточнение.Очистить();
			УпаковкиВЕТИС.Очистить();
			ШтрихкодыУпаковок.Очистить();
			
			ТТНУказан = ЗначениеЗаполнено(ТипТТН) Или ЗначениеЗаполнено(НомерТТН) Или ЗначениеЗаполнено(ДатаТТН) Или ЗначениеЗаполнено(СерияТТН);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьДанныеПродукции(Документы.ВходящаяТранспортнаяОперацияВЕТИС.ВыборкаДанныхВСД(ДанныеЗаполнения));
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПродукции(ВыборкаВСД)
	
	ВсяПродукцияСопоставлена = Истина;
	
	Пока ВыборкаВСД.Следующий() Цикл 
		
		СтрокаТЧ = Товары.Найти(ВыборкаВСД.ВетеринарноСопроводительныйДокумент, "ВетеринарноСопроводительныйДокумент");
		
		Если СтрокаТЧ = Неопределено Тогда
			СтрокаТЧ = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, ВыборкаВСД);
			СтрокаТЧ.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ЕдиницаИзмеренияВЕТИС) Тогда
				ИнтеграцияВЕТИС.ПроверитьОчиститьЕдиницуИзмеренияВЕТИС(СтрокаТЧ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
				ИнтеграцияВЕТИСПереопределяемый.ЗаполнитьКоличествоНоменклатурыПоКоличествуВЕТИС(СтрокаТЧ);
			Иначе
				ВсяПродукцияСопоставлена = Ложь;
			КонецЕсли;
		Иначе
			ОчиститьСвязанныеСтрокиТабличнойЧасти(СтрокаТЧ.ИдентификаторСтроки, "УпаковкиВЕТИС");
			ОчиститьСвязанныеСтрокиТабличнойЧасти(СтрокаТЧ.ИдентификаторСтроки, "ПроизводственныеПартии");
		КонецЕсли;
		
		ВыборкаУпаковки = ВыборкаВСД.УпаковкиВЕТИС.Выбрать();
		Пока ВыборкаУпаковки.Следующий() Цикл
			СтрокаУпаковкиДокумента = УпаковкиВЕТИС.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУпаковкиДокумента, ВыборкаУпаковки);
			СтрокаУпаковкиДокумента.ИдентификаторСтрокиТовары = СтрокаТЧ.ИдентификаторСтроки;
		КонецЦикла;
		
		ВыборкаШтрихкоды = ВыборкаВСД.ШтрихкодыУпаковок.Выбрать();
		Пока ВыборкаШтрихкоды.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ШтрихкодыУпаковок.Добавить(), ВыборкаШтрихкоды);
		КонецЦикла;
		
		ВыборкаПартии = ВыборкаВСД.ПроизводственныеПартии.Выбрать();
		Пока ВыборкаПартии.Следующий() Цикл
			СтрокаПроизводственнойПартииДокумента = ?(ВыборкаПартии.Количество() = 1, СтрокаТЧ, ТоварыУточнение.Добавить());
			Если ВыборкаПартии.Количество() > 1 Тогда
				СтрокаПроизводственнойПартииДокумента.ИдентификаторСтроки = СтрокаТЧ.ИдентификаторСтроки;
			КонецЕсли;
			СтрокаПроизводственнойПартииДокумента.ИдентификаторПартии = ВыборкаПартии.ИдентификаторПартии;
		КонецЦикла;
		
	КонецЦикла;
	
	Если НЕ ВсяПродукцияСопоставлена Тогда
		СопоставленныеТовары = ИнтеграцияВЕТИС.ПолучитьСопоставленныеТовары(Товары);
		
		Для Каждого СтрокаТЧ Из Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаСопоставленногоТовара = СопоставленныеТовары.Найти(СтрокаТЧ.НомерСтроки, "НомерСтрокиТовара");
			
			Если СтрокаСопоставленногоТовара <> Неопределено Тогда
				Если СтрокаСопоставленногоТовара.Количество = 1 Тогда
					СтрокаТЧ.Номенклатура   = СтрокаСопоставленногоТовара.Номенклатура;
					СтрокаТЧ.Характеристика = СтрокаСопоставленногоТовара.Характеристика;
					Для Каждого СтрокаУточнения Из ТоварыУточнение.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки)) Цикл
						ЗаполнитьЗначенияСвойств(СтрокаУточнения, СтрокаТЧ, "Номенклатура, Характеристика");
					КонецЦикла;
					ИнтеграцияВЕТИСПереопределяемый.ЗаполнитьКоличествоНоменклатурыПоКоличествуВЕТИС(СтрокаТЧ);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьСвязанныеСтрокиТабличнойЧасти(ИдентификаторСтроки, ИмяТабличнойЧасти)
	
	КолонкаОтбора = ?(ИмяТабличнойЧасти = "УпаковкиВЕТИС", "ИдентификаторСтрокиТовары", "ИдентификаторСтроки");
	СтруктураОтбора = Новый Структура(КолонкаОтбора, ИдентификаторСтроки);
	СтрокиКУдалению = ЭтотОбъект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
		Если ИмяТабличнойЧасти = "УпаковкиВЕТИС" Тогда
			ОчиститьСвязанныеСтрокиТабличнойЧасти(СтрокаКУдалению.ИдентификаторСтроки, "ШтрихкодыУпаковок");
		КонецЕсли;
		ИндексСтроки = ЭтотОбъект[ИмяТабличнойЧасти].Индекс(СтрокаКУдалению);
		ЭтотОбъект[ИмяТабличнойЧасти].Удалить(ИндексСтроки);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
