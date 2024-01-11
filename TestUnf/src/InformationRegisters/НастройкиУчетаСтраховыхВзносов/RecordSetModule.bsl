#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.ИспользуетсяТрудФармацевтов КАК ИспользуетсяТрудФармацевтов,
	|	УточняемыеДанные.ИспользуетсяТрудЧленовЛетныхЭкипажей КАК ИспользуетсяТрудЧленовЛетныхЭкипажей,
	|	УточняемыеДанные.ИспользуетсяТрудЧленовЭкипажейМорскихСудов КАК ИспользуетсяТрудЧленовЭкипажейМорскихСудов,
	|	УточняемыеДанные.ИспользуетсяТрудШахтеров КАК ИспользуетсяТрудШахтеров,
	|	УточняемыеДанные.ИспользуютсяРаботыВСельскомХозяйстве КАК ИспользуютсяРаботыВСельскомХозяйстве,
	|	УточняемыеДанные.ИспользуетсяТрудИностранцевСОсобымиВзносами КАК ИспользуетсяТрудИностранцевСОсобымиВзносами,
	|	УточняемыеДанные.ИспользуютсяРаботыСДосрочнойПенсией КАК ИспользуютсяРаботыСДосрочнойПенсией,
	|	УточняемыеДанные.ИспользоватьСамостоятельныеКлассификационныеЕдиницы КАК ИспользоватьСамостоятельныеКлассификационныеЕдиницы,
	|	УточняемыеДанные.ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда КАК ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда,
	|	УточняемыеДанные.ИспользуетсяТрудСтудентовСтуденческихОтрядов КАК ИспользуетсяТрудСтудентовСтуденческихОтрядов
	|ПОМЕСТИТЬ ВТДанныеДляУточнения
	|ИЗ
	|	&Данные КАК УточняемыеДанные";
	Запрос.УстановитьПараметр("Данные", Выгрузить());
	Запрос.Выполнить(); 
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуетсяТрудФармацевтов
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудФармацевтов, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуетсяТрудФармацевтов,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуетсяТрудЧленовЛетныхЭкипажей
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудЧленовЛетныхЭкипажей, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуетсяТрудЧленовЛетныхЭкипажей,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуетсяТрудЧленовЭкипажейМорскихСудов
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудЧленовЭкипажейМорскихСудов, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуетсяТрудЧленовЭкипажейМорскихСудов,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуетсяТрудШахтеров
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудШахтеров, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуетсяТрудШахтеров,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуетсяТрудИностранцевСОсобымиВзносами
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудИностранцевСОсобымиВзносами, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуетсяТрудИностранцевСОсобымиВзносами,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуютсяРаботыВСельскомХозяйстве
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуютсяРаботыВСельскомХозяйстве, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуютсяРаботыВСельскомХозяйстве,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуютсяРаботыСДосрочнойПенсией
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуютсяРаботыСДосрочнойПенсией, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуютсяРаботыСДосрочнойПенсией,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда, ЛОЖЬ)
	|	КОНЕЦ КАК ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользоватьСамостоятельныеКлассификационныеЕдиницы
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользоватьСамостоятельныеКлассификационныеЕдиницы, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользоватьСамостоятельныеКлассификационныеЕдиницы,
	|	ВЫБОР
	|			КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|				ТОГДА УточняемыеДанные.ИспользуетсяТрудЧленовЭкипажейМорскихСудов
	|			ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудЧленовЭкипажейМорскихСудов, ЛОЖЬ)
	|		КОНЕЦ
	|		И УточняемыеДанные.Организация.ЕстьОбособленныеПодразделения КАК ПрименяютсяЛьготныеТарифыВПодразделениях,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|			ТОГДА УточняемыеДанные.ИспользуетсяТрудСтудентовСтуденческихОтрядов
	|		ИНАЧЕ ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудСтудентовСтуденческихОтрядов, ЛОЖЬ)
	|	КОНЕЦ КАК ИспользуетсяТрудСтудентовСтуденческихОтрядов
	|ИЗ
	|	ВТДанныеДляУточнения КАК УточняемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаСтраховыхВзносов КАК НастройкиУчетаСтраховыхВзносов
	|		ПО УточняемыеДанные.Организация.ГоловнаяОрганизация = НастройкиУчетаСтраховыхВзносов.Организация";
	
    Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.ИспользуетсяТрудФармацевтов КАК ИспользуетсяТрудФармацевтов,
	|	УточняемыеДанные.ИспользуетсяТрудЧленовЛетныхЭкипажей КАК ИспользуетсяТрудЧленовЛетныхЭкипажей,
	|	УточняемыеДанные.ИспользуетсяТрудЧленовЭкипажейМорскихСудов КАК ИспользуетсяТрудЧленовЭкипажейМорскихСудов,
	|	УточняемыеДанные.ИспользуетсяТрудШахтеров КАК ИспользуетсяТрудШахтеров,
	|	УточняемыеДанные.ИспользуетсяТрудИностранцевСОсобымиВзносами КАК ИспользуетсяТрудИностранцевСОсобымиВзносами,
	|	УточняемыеДанные.ИспользуютсяРаботыВСельскомХозяйстве КАК ИспользуютсяРаботыВСельскомХозяйстве,
	|	УточняемыеДанные.ИспользуютсяРаботыСДосрочнойПенсией КАК ИспользуютсяРаботыСДосрочнойПенсией,
	|	УточняемыеДанные.ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда КАК ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда,
	|	УточняемыеДанные.ИспользоватьСамостоятельныеКлассификационныеЕдиницы КАК ИспользоватьСамостоятельныеКлассификационныеЕдиницы,
	|	УточняемыеДанные.ПрименяютсяЛьготныеТарифыВПодразделениях КАК ПрименяютсяЛьготныеТарифыВПодразделениях,
	|	УточняемыеДанные.ИспользуетсяТрудСтудентовСтуденческихОтрядов КАК ИспользуетсяТрудСтудентовСтуденческихОтрядов
	|ПОМЕСТИТЬ ВТНовыеДанные
	|ИЗ
	|	&Данные КАК УточняемыеДанные";
	Запрос.УстановитьПараметр("Данные", Выгрузить());
	Запрос.Выполнить(); 
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Ссылка КАК Организация,
	|	НовыеДанные.ИспользуетсяТрудФармацевтов КАК ИспользуетсяТрудФармацевтов,
	|	НовыеДанные.ИспользуетсяТрудЧленовЛетныхЭкипажей КАК ИспользуетсяТрудЧленовЛетныхЭкипажей,
	|	НовыеДанные.ИспользуетсяТрудЧленовЭкипажейМорскихСудов КАК ИспользуетсяТрудЧленовЭкипажейМорскихСудов,
	|	НовыеДанные.ИспользуетсяТрудШахтеров КАК ИспользуетсяТрудШахтеров,
	|	НовыеДанные.ИспользуетсяТрудИностранцевСОсобымиВзносами КАК ИспользуетсяТрудИностранцевСОсобымиВзносами,
	|	НовыеДанные.ИспользуютсяРаботыВСельскомХозяйстве КАК ИспользуютсяРаботыВСельскомХозяйстве,
	|	НовыеДанные.ИспользуютсяРаботыСДосрочнойПенсией КАК ИспользуютсяРаботыСДосрочнойПенсией,
	|	НовыеДанные.ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда КАК ПрименяютсяРезультатыСпециальнойОценкиУсловийТруда,
	|	НовыеДанные.ИспользоватьСамостоятельныеКлассификационныеЕдиницы КАК ИспользоватьСамостоятельныеКлассификационныеЕдиницы,
	|	НовыеДанные.ПрименяютсяЛьготныеТарифыВПодразделениях КАК ПрименяютсяЛьготныеТарифыВПодразделениях,
	|	НовыеДанные.ИспользуетсяТрудСтудентовСтуденческихОтрядов КАК ИспользуетсяТрудСтудентовСтуденческихОтрядов
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНовыеДанные КАК НовыеДанные
	|		ПО Организации.Ссылка.ГоловнаяОрганизация = НовыеДанные.Организация
	|ГДЕ
	|	Организации.Ссылка <> Организации.ГоловнаяОрганизация
	|	И Организации.ГоловнаяОрганизация В
	|			(ВЫБРАТЬ
	|				Организации.Организация
	|			ИЗ
	|				ВТНовыеДанные КАК Организации
	|			ГДЕ
	|				Организации.Организация = Организации.Организация.ГоловнаяОрганизация)";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.НастройкиУчетаСтраховыхВзносов.СоздатьНаборЗаписей();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОбновитьНастройкиИспользованияСтраховыхВзносовПоКлассамУсловийТруда", Ложь);
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
	    ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),Выборка);
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудФармацевтов, ЛОЖЬ)) КАК ИспользуетсяТрудФармацевтов,
	|	МАКСИМУМ(ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудЧленовЛетныхЭкипажей, ЛОЖЬ)) КАК ИспользуетсяТрудЧленовЛетныхЭкипажей,
	|	МАКСИМУМ(ЕСТЬNULL(НастройкиУчетаСтраховыхВзносов.ИспользуетсяТрудШахтеров, ЛОЖЬ)) КАК ИспользуетсяТрудШахтеров
	|ПОМЕСТИТЬ ВТЗначенияФункциональныхОпций
	|ИЗ
	|	РегистрСведений.НастройкиУчетаСтраховыхВзносов КАК НастройкиУчетаСтраховыхВзносов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Должности.Ссылка
	|ПОМЕСТИТЬ ВТДолжностиЛетногоЭкипажа
	|ИЗ
	|	Справочник.Должности КАК Должности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияФункциональныхОпций КАК ЗначенияФункциональныхОпций
	|		ПО (ЗначенияФункциональныхОпций.ИспользуетсяТрудЧленовЛетныхЭкипажей = ЛОЖЬ)
	|			И (Должности.ЯвляетсяДолжностьюЛетногоЭкипажа = ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Должности.Ссылка
	|ПОМЕСТИТЬ ВТДолжностиФармацевтов
	|ИЗ
	|	Справочник.Должности КАК Должности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияФункциональныхОпций КАК ЗначенияФункциональныхОпций
	|		ПО (ЗначенияФункциональныхОпций.ИспользуетсяТрудФармацевтов = ЛОЖЬ)
	|			И (Должности.ЯвляетсяФармацевтическойДолжностью = ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Должности.Ссылка
	|ПОМЕСТИТЬ ВТДолжностиШахтеров
	|ИЗ
	|	Справочник.Должности КАК Должности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияФункциональныхОпций КАК ЗначенияФункциональныхОпций
	|		ПО (ЗначенияФункциональныхОпций.ИспользуетсяТрудШахтеров = ЛОЖЬ)
	|			И (Должности.ЯвляетсяШахтерскойДолжностью = ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДолжностиЛетногоЭкипажа.Ссылка
	|ПОМЕСТИТЬ ВТОбновляемыеСсылки
	|ИЗ
	|	ВТДолжностиЛетногоЭкипажа КАК ДолжностиЛетногоЭкипажа
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДолжностиФармацевтов.Ссылка
	|ИЗ
	|	ВТДолжностиФармацевтов КАК ДолжностиФармацевтов
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДолжностиШахтеров.Ссылка
	|ИЗ
	|	ВТДолжностиШахтеров КАК ДолжностиШахтеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбновляемыеСсылки.Ссылка,
	|	ВЫБОР
	|		КОГДА ЗначенияФункциональныхОпций.ИспользуетсяТрудЧленовЛетныхЭкипажей = ИСТИНА
	|			ТОГДА ОбновляемыеСсылки.Ссылка.ЯвляетсяДолжностьюЛетногоЭкипажа
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЯвляетсяДолжностьюЛетногоЭкипажа,
	|	ВЫБОР
	|		КОГДА ЗначенияФункциональныхОпций.ИспользуетсяТрудШахтеров = ИСТИНА
	|			ТОГДА ОбновляемыеСсылки.Ссылка.ЯвляетсяШахтерскойДолжностью
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЯвляетсяШахтерскойДолжностью,
	|	ВЫБОР
	|		КОГДА ЗначенияФункциональныхОпций.ИспользуетсяТрудФармацевтов = ИСТИНА
	|			ТОГДА ОбновляемыеСсылки.Ссылка.ЯвляетсяФармацевтическойДолжностью
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЯвляетсяФармацевтическойДолжностью
	|ИЗ
	|	ВТОбновляемыеСсылки КАК ОбновляемыеСсылки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияФункциональныхОпций КАК ЗначенияФункциональныхОпций
	|		ПО (ИСТИНА)";
		
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДолжностьОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Попытка 
				ДолжностьОбъект.Заблокировать();
			Исключение
				ТекстИсключенияЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось изменить должность ""%1"" 
				|Возможно, позиция редактируется другим пользователем'"),
				ДолжностьОбъект.Наименование);			
				ВызватьИсключение ТекстИсключенияЗаписи;
			КонецПопытки;	
			ЗаполнитьЗначенияСвойств(ДолжностьОбъект, Выборка);
			ДолжностьОбъект.ДополнительныеСвойства.Вставить("ОбновитьНастройкиИспользованияСтраховыхВзносовПоКлассамУсловийТруда", Ложь);
			ДолжностьОбъект.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОтборПоОрганизациям = Новый Массив;
	ОтборПоОрганизациям.Добавить(ЭтотОбъект[0].Организация);
	УчетСтраховыхВзносов.УстановитьФункциональныеОпцииИспользованияСтраховыхВзносовПоКлассамУсловийТруда(ОтборПоОрганизациям);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли