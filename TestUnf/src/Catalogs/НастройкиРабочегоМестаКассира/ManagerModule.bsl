
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗагрузитьНастройкиИзXML(ТекстXML, ЕстьОшибки, НастройкаРМКОбъект) Экспорт
	
	Попытка
		СтруктураНастроек = ОбщегоНазначения.ЗначениеИзСтрокиXML(ТекстXML);
	Исключение
		
		ЕстьОшибки = Истина;
		ИмяСобытия = НСтр("ru = 'Загрузка настроек РМК из файла.'",
			ОбщегоНазначения.КодОсновногоЯзыка());
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		Возврат;
		
	КонецПопытки;
	
	Для Каждого ЭлементНастройки Из СтруктураНастроек Цикл
		
		Попытка
			
			Если Лев(ЭлементНастройки.Ключ, 9) = "Константа" Тогда
				
				ИмяКонстанты = Сред(ЭлементНастройки.Ключ, 11);
				Константы[ИмяКонстанты].Установить(ЭлементНастройки.Значение);
				
			ИначеЕсли ЭлементНастройки.Ключ = "НастройкаРМК_ГорячиеКлавиши" Тогда
				НастройкаРМКОбъект.ГорячиеКлавиши.Загрузить(ЭлементНастройки.Значение);
			ИначеЕсли ЭлементНастройки.Ключ = "НастройкаРМК_БыстрыеТовары" Тогда
				
				ТаблицаБыстрыеТовары = ЭлементНастройки.Значение;
				НастройкаРМКОбъект.БыстрыеТовары.Очистить();
				
				Для Каждого СтрокаБыстрыеТовары Из ТаблицаБыстрыеТовары Цикл
					
					Если НЕ ОбщегоНазначения.СсылкаСуществует(СтрокаБыстрыеТовары.Номенклатура)
						Или (НЕ СтрокаБыстрыеТовары.Характеристика.Пустая()
							И НЕ ОбщегоНазначения.СсылкаСуществует(СтрокаБыстрыеТовары.Характеристика)) Тогда
							Продолжить;
					КонецЕсли;
						
					НоваяСтрока = НастройкаРМКОбъект.БыстрыеТовары.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаБыстрыеТовары);
					
				КонецЦикла;
				
			ИначеЕсли ЭлементНастройки.Ключ = "НастройкаРМК_ВводНаличных" Тогда
				ЗагрузитьТаблицуВводаНаличных(НастройкаРМКОбъект, ЭлементНастройки.Значение);
			ИначеЕсли Лев(ЭлементНастройки.Ключ, 12) = "НастройкаРМК" Тогда
				
				ИмяРеквизита = Сред(ЭлементНастройки.Ключ, 14);
				НастройкаРМКОбъект[ИмяРеквизита] = ЭлементНастройки.Значение;
				
			ИначеЕсли ЭлементНастройки.Ключ = "ШаблоныЧеков" Тогда
				
				Для Каждого СтрокаШаблонаЧека Из ЭлементНастройки.Значение Цикл
					
					СсылкаШаблона = СтрокаШаблонаЧека.Ссылка;
					
					Если НЕ СсылкаШаблона.Пустая() И НЕ ОбщегоНазначения.СсылкаСуществует(СсылкаШаблона) Тогда
						
						СтрокаGUID = СсылкаШаблона.УникальныйИдентификатор();
						НовыйGUID = Новый УникальныйИдентификатор(СтрокаGUID);
						НоваяСсылка = Справочники.ХранилищеШаблонов.ПолучитьСсылку(НовыйGUID);
						ОбъектШаблонЧека = Справочники.ХранилищеШаблонов.СоздатьЭлемент();
						ОбъектШаблонЧека.УстановитьСсылкуНового(НоваяСсылка);
						ЗаполнитьЗначенияСвойств(ОбъектШаблонЧека, СтрокаШаблонаЧека, , "Ссылка");
						ОбъектШаблонЧека.Записать();
						
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли ЭлементНастройки.Ключ = "ПалитраБыстрыхТоваров" Или ЭлементНастройки.Ключ = "ПалитраПлитки" Тогда
				
				Для Каждого СтрокаПалитры Из ЭлементНастройки.Значение Цикл
					
					СсылкаПалитраТоваров = СтрокаПалитры.Ссылка;
					
					Если НЕ СсылкаПалитраТоваров.Пустая() Тогда
							
						Если НЕ ОбщегоНазначения.СсылкаСуществует(СсылкаПалитраТоваров) Тогда
						
							СтрокаGUID = СсылкаПалитраТоваров.УникальныйИдентификатор();
							НовыйGUID = Новый УникальныйИдентификатор(СтрокаGUID);
							НоваяСсылка = Справочники.ПалитраТоваровРМК.ПолучитьСсылку(НовыйGUID);
							ОбъектПалитраТоваров = Справочники.ПалитраТоваровРМК.СоздатьЭлемент();
							ОбъектПалитраТоваров.УстановитьСсылкуНового(НоваяСсылка);
							
						Иначе
							ОбъектПалитраТоваров = СсылкаПалитраТоваров.ПолучитьОбъект();
						КонецЕсли;
						
						Попытка
							ОбъектПалитраТоваров.Заблокировать();
						Исключение
							ТекстОшибки = НСтр("ru = 'Ошибка блокировки палитры товаров, при загрузке из файла настроек.'", ОбщегоНазначения.КодОсновногоЯзыка());
							ЗаписьЖурналаРегистрации(ТекстОшибки,
								УровеньЖурналаРегистрации.Ошибка, ,
								ОбъектПалитраТоваров,
								ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
							Продолжить;
						КонецПопытки;
						
						ЗаполнитьЗначенияСвойств(ОбъектПалитраТоваров, СтрокаПалитры, , "Ссылка, Состав");
						
						ОбъектПалитраТоваров.Состав.Очистить();
						Для Каждого СтрокаСостава Из СтрокаПалитры.Состав Цикл
							
							НоваяСтрока = ОбъектПалитраТоваров.Состав.Добавить();
							ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСостава);
							
							Если ЗначениеЗаполнено(СтрокаСостава.НоменклатураГУИД) Тогда
								НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаСостава.НоменклатураГУИД));
							КонецЕсли;
							Если ЗначениеЗаполнено(СтрокаСостава.ХарактеристикаГУИД) Тогда
								НоваяСтрока.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаСостава.ХарактеристикаГУИД));
							КонецЕсли;
							Если ЗначениеЗаполнено(СтрокаСостава.УпаковкаГУИД) Тогда
								НоваяСтрока.Упаковка = Справочники.Упаковки.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаСостава.УпаковкаГУИД));
							КонецЕсли;
							
						КонецЦикла;
						
						ОбъектПалитраТоваров.Записать();
						
						Если ЭлементНастройки.Ключ = "ПалитраБыстрыхТоваров" Тогда
							НастройкаРМКОбъект.СтруктураБыстрыхТоваров = ОбъектПалитраТоваров.Ссылка;
						Иначе
							НастройкаРМКОбъект.СтруктураПлиточногоИнтерфейсаПодбора = ОбъектПалитраТоваров.Ссылка;
						КонецЕсли;
						
					КонецЕсли;
				
				КонецЦикла;
				
			ИначеЕсли ЭлементНастройки.Ключ = "ФайлыПалитрыБыстрыхТоваров" Или ЭлементНастройки.Ключ = "ФайлыПалитрыПлитки" Тогда
				
				Для Каждого СтрокаФайла Из ЭлементНастройки.Значение Цикл
					
					СсылкаФайла = СтрокаФайла.Ссылка;
					
					Если НЕ СсылкаФайла.Пустая() Тогда
						
						Если НЕ ОбщегоНазначения.СсылкаСуществует(СсылкаФайла) Тогда
						
							СтрокаGUID = СсылкаФайла.УникальныйИдентификатор();
							НовыйGUID = Новый УникальныйИдентификатор(СтрокаGUID);
							НоваяСсылка = Справочники.ПалитраТоваровРМКПрисоединенныеФайлы.ПолучитьСсылку(НовыйGUID);
							ОбъектФайл = Справочники.ПалитраТоваровРМКПрисоединенныеФайлы.СоздатьЭлемент();
							ОбъектФайл.УстановитьСсылкуНового(НоваяСсылка);
							
							ЗаполнитьЗначенияСвойств(ОбъектФайл, СтрокаФайла, , "Ссылка");
							ОбъектФайл.Записать();
							
						Иначе
							ОбъектФайл = СсылкаФайла.ПолучитьОбъект();
							ЗаполнитьЗначенияСвойств(ОбъектФайл, СтрокаФайла, , "Ссылка");
						КонецЕсли;
					
						Если ЗначениеЗаполнено(СтрокаФайла.ДвоичныеДанные) Тогда
							АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(СтрокаФайла.ДвоичныеДанные);
							
							ИнформацияОФайле = Новый Структура;
							ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище", АдресВременногоХранилищаФайла);
							ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста", "");
							ИнформацияОФайле.Вставить("ИмяБезРасширения"              , СтрокаФайла.Наименование);
							ИнформацияОФайле.Вставить("ДатаМодификацииУниверсальная"  , СтрокаФайла.ДатаМодификацииУниверсальная);
							ИнформацияОФайле.Вставить("Расширение"                    , СтрЗаменить(СтрокаФайла.Расширение,".",""));
							ИнформацияОФайле.Вставить("Редактирует"                   , Неопределено);
							
							РаботаСФайлами.ОбновитьФайл(ОбъектФайл.Ссылка, ИнформацияОФайле);
							
						КонецЕсли;
							
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		Исключение
			
			ЕстьОшибки = Истина;
			ИмяСобытия = НСтр("ru = 'Сохранение настроек РМК при загрузке из файла настроек.'",
				ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(
				ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
				
		КонецПопытки;
			
	КонецЦикла;
	
	Попытка
		НастройкаРМКОбъект.Записать();
	Исключение
		
		ЕстьОшибки = Истина;
		ИмяСобытия = НСтр("ru = 'Запись справочника НастройкиРМК при загрузке из файла настроек.'",
			ОбщегоНазначения.КодОсновногоЯзыка());
		МетаданныеОбъекта = Метаданные.Справочники.НастройкиРабочегоМестаКассира;
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта,
			НастройкаРМКОбъект.Ссылка, ТекстОшибки);
			
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьВСтруктуруНастроекПалитруТоваров(ПалитраТоваров, СтруктураНастроек, ЭтоПлитка = Ложь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПалитраТоваровРМК.Ссылка КАК Ссылка,
	|	ПалитраТоваровРМК.Наименование КАК Наименование,
	|	ПалитраТоваровРМК.КоличествоЭлементовВРяду КАК КоличествоЭлементовВРяду,
	|	ПалитраТоваровРМК.ВысотаЭлемента КАК ВысотаЭлемента,
	|	ПалитраТоваровРМК.КоличествоРядов КАК КоличествоРядов,
	|	ПалитраТоваровРМК.ШрифтЭлементовПодбора КАК ШрифтЭлементовПодбора,
	|	ПалитраТоваровРМК.Состав.(
	|		ЭтоКатегория КАК ЭтоКатегория,
	|		НомерКатегории КАК НомерКатегории,
	|		НомерКатегорииРазмещения КАК НомерКатегорииРазмещения,
	|		ИндексПозиции КАК ИндексПозиции,
	|		ИмяЭлемента КАК ИмяЭлемента,
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		ЗаголовокЭлемента КАК ЗаголовокЭлемента,
	|		ИзображениеЭлемента КАК ИзображениеЭлемента,
	|		ХарактеристикиИспользуются КАК ХарактеристикиИспользуются,
	|		Шрифт КАК Шрифт,
	|		ЦветШрифта КАК ЦветШрифта,
	|		ЦветФона КАК ЦветФона,
	|		КатегорияРазмещения КАК КатегорияРазмещения,
	|		ИмеетсяВложенность КАК ИмеетсяВложенность,
	|		ВидМодификатора КАК ВидМодификатора,
	|		Упаковка КАК Упаковка,
	|		СкрыватьОстаток КАК СкрыватьОстаток
	|	) КАК Состав
	|ИЗ
	|	Справочник.ПалитраТоваровРМК КАК ПалитраТоваровРМК
	|ГДЕ
	|	ПалитраТоваровРМК.Ссылка = &ПалитраТоваров");
	
	Запрос.УстановитьПараметр("ПалитраТоваров", ПалитраТоваров);
	ПалитраТаблица = Запрос.Выполнить().Выгрузить();
	
	Если ПалитраТаблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Палитра Из ПалитраТаблица Цикл
		СоставПалитры = Палитра.Состав;
		СоставПалитры.Колонки.Добавить("НоменклатураГУИД", ОбщегоНазначения.ОписаниеТипаСтрока(36));
		СоставПалитры.Колонки.Добавить("ХарактеристикаГУИД", ОбщегоНазначения.ОписаниеТипаСтрока(36));
		СоставПалитры.Колонки.Добавить("УпаковкаГУИД", ОбщегоНазначения.ОписаниеТипаСтрока(36));
		
		Для Каждого СрокаПалитры Из СоставПалитры Цикл
			Если ЗначениеЗаполнено(СрокаПалитры.Номенклатура) Тогда
				СрокаПалитры.НоменклатураГУИД = СрокаПалитры.Номенклатура.УникальныйИдентификатор();
			КонецЕсли;
			Если ЗначениеЗаполнено(СрокаПалитры.Характеристика) Тогда
				СрокаПалитры.ХарактеристикаГУИД = СрокаПалитры.Характеристика.УникальныйИдентификатор();
			КонецЕсли;
			Если ЗначениеЗаполнено(СрокаПалитры.Упаковка) Тогда
				СрокаПалитры.УпаковкаГУИД = СрокаПалитры.Упаковка.УникальныйИдентификатор();
			КонецЕсли;
		КонецЦикла;
		
		СоставПалитры.Колонки.Удалить("Номенклатура");
		СоставПалитры.Колонки.Удалить("Характеристика");
		СоставПалитры.Колонки.Удалить("Упаковка");
	КонецЦикла;
	
	ИмяНастройкиВСтруктуре = ?(ЭтоПлитка, "ПалитраПлитки", "ПалитраБыстрыхТоваров");
	СтруктураНастроек.Вставить(ИмяНастройкиВСтруктуре, ПалитраТаблица);
	
	МассивФайлов = Новый Массив;
	Для Каждого СтрокаПалитры Из ПалитраТаблица Цикл
		Для Каждого ФайлПалитры Из СтрокаПалитры.Состав Цикл
			Если ЗначениеЗаполнено(ФайлПалитры.ИзображениеЭлемента) Тогда
				МассивФайлов.Добавить(ФайлПалитры.ИзображениеЭлемента);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПалитраТоваровРМКПрисоединенныеФайлы.Ссылка КАК Ссылка,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.Наименование КАК Наименование,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайла,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.ИндексКартинки КАК ИндексКартинки,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.Размер КАК Размер,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.Расширение КАК Расширение,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.ДатаЗаема КАК ДатаЗаема,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.ДатаСоздания КАК ДатаСоздания,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.СтатусИзвлеченияТекста КАК СтатусИзвлеченияТекста,
	|	ПалитраТоваровРМКПрисоединенныеФайлы.ТипХраненияФайла КАК ТипХраненияФайла
	|ИЗ
	|	Справочник.ПалитраТоваровРМКПрисоединенныеФайлы КАК ПалитраТоваровРМКПрисоединенныеФайлы
	|ГДЕ
	|	ПалитраТоваровРМКПрисоединенныеФайлы.Ссылка В (&СсылкиФайлов)");
	
	Запрос.УстановитьПараметр("СсылкиФайлов", МассивФайлов);
	
	ФайлыПалитрыТоваров = Запрос.Выполнить().Выгрузить();
	ФайлыПалитрыТоваров.Колонки.Добавить("ДвоичныеДанные");
	Для Каждого СтрокаФайла Из ФайлыПалитрыТоваров Цикл
		СтрокаФайла.ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(СтрокаФайла.Ссылка);
	КонецЦикла;
	
	ИмяНастройкиВСтруктуре = ?(ЭтоПлитка, "ФайлыПалитрыПлитки", "ФайлыПалитрыБыстрыхТоваров");
	СтруктураНастроек.Вставить(ИмяНастройкиВСтруктуре, ФайлыПалитрыТоваров);
	
КонецПроцедуры

Функция ПолучитьШаблонТаблицыГорячихКлавиш() Экспорт
	
	Возврат Справочники.НастройкиРабочегоМестаКассира.ПустаяСсылка().ГорячиеКлавиши.ВыгрузитьКолонки();
	
КонецФункции

Функция ПолучитьШаблонТаблицыГорячихКлавишКупюр() Экспорт
	
	ШаблонТаблицы = Справочники.НастройкиРабочегоМестаКассира.ПустаяСсылка().ГорячиеКлавиши.ВыгрузитьКолонки();
	
	ШаблонТаблицы.Колонки.Добавить("Номинал", ОбщегоНазначения.ОписаниеТипаСтрока(10));
	ШаблонТаблицы.Колонки.Удалить("НомерСтроки");
	ШаблонТаблицы.Колонки.Удалить("ИмяКнопки");
	ШаблонТаблицы.Колонки.Удалить("ЗаголовокКнопки");
	
	Возврат ШаблонТаблицы;
	
КонецФункции

Функция ПолучитьТаблицуЗапрещенныхКлавиш() Экспорт
	
	ЗапрещенныеКлавиши = ПолучитьШаблонТаблицыГорячихКлавиш();
	ЗапрещенныеКлавиши.Колонки.Удалить("ИмяКнопки");
	ЗапрещенныеКлавиши.Колонки.Удалить("ЗаголовокКнопки");
	ЗапрещенныеКлавиши.Колонки.Добавить("РаботаСБуфером", Новый ОписаниеТипов("Булево"));
	
	ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "F10", Истина, Ложь, Истина);
	ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "A", Ложь, Истина, Ложь, Истина);
	ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "C", Ложь, Истина, Ложь, Истина);
	ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "V", Ложь, Истина, Ложь, Истина);
	
	Если ОбщегоНазначения.ЭтоLinuxКлиент() Тогда
		ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "U", Истина, Истина, Ложь);
		ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "T", Истина, Истина, Ложь);
		ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "F", Истина, Истина, Ложь);
		ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "D", Истина, Истина, Ложь);
		ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, "L", Истина, Истина, Ложь);
	КонецЕсли;
	
	Возврат ЗапрещенныеКлавиши;
	
КонецФункции

Функция ПолучитьИменаКомандПересекающихсяСАктивнымБуфером() Экспорт
	
	РезультатФункции = Новый Массив;
	РезультатФункции.Добавить("КомандаВозвратБезЧека");
	Возврат РезультатФункции;
	
КонецФункции

Функция ПолучитьСтрокиНекорректныхКомбинацийГорячихКлавиш(ТаблицыГорячихКлавиш) Экспорт
	
	ЗапрещенныеКлавиши = ПолучитьТаблицуЗапрещенныхКлавиш();
	ЗапросЗапрещенныхКомбинаций = Новый Запрос;
	ЗапросЗапрещенныхКомбинаций.Текст = ПолучитьТекстЗапросаЗапрещенныхКомбинацийГорячихКлавиш();
	
	ЗапросЗапрещенныхКомбинаций.УстановитьПараметр("ГорячиеКлавиши", ТаблицыГорячихКлавиш.ОсновныеГорячиеКлавиши);
	ЗапросЗапрещенныхКомбинаций.УстановитьПараметр("ГорячиеКлавишиКупюр", ТаблицыГорячихКлавиш.ГорячиеКлавишиКупюр);
	ЗапросЗапрещенныхКомбинаций.УстановитьПараметр("ЗапрещенныеКлавиши", ЗапрещенныеКлавиши);
	ЗапросЗапрещенныхКомбинаций.УстановитьПараметр("КомандыСАктивнымБуфером",
		ПолучитьИменаКомандПересекающихсяСАктивнымБуфером());
	РезультатЗапроса = ЗапросЗапрещенныхКомбинаций.Выполнить();
	НекорректныеКомбинации = РезультатЗапроса.Выгрузить();
	
	ЗапросДублей = Новый Запрос;
	ЗапросДублей.Текст = ПолучитьТекстЗапросаДублейГорячихКлавиш();
	ЗапросДублей.УстановитьПараметр("ГорячиеКлавиши", ТаблицыГорячихКлавиш.ОсновныеГорячиеКлавиши);
	ЗапросДублей.УстановитьПараметр("Избранное", ТаблицыГорячихКлавиш.ГорячиеКлавишиИзбранное);
	ЗапросДублей.УстановитьПараметр("ГорячиеКлавишиКупюр", ТаблицыГорячихКлавиш.ГорячиеКлавишиКупюр);
	ЗапросДублей.УстановитьПараметр("КлавишаНет", ИнтерфейсРМКСлужебныйКлиентСервер.ПредставлениеПустойКлавиши());
	РезультатЗапроса = ЗапросДублей.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДублей = РезультатЗапроса.Выбрать();
		Пока ВыборкаДублей.Следующий() Цикл
			Если Не ВыборкаДублей.ЗаписьУникальна Тогда
				НоваяСтрока = НекорректныеКомбинации.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДублей);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат НекорректныеКомбинации;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТекстЗапросаДублейГорячихКлавиш()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Избранное.НомерСтроки КАК НомерСтроки,
	|	Избранное.ИмяКнопки КАК ИмяКнопки,
	|	Избранное.ЗаголовокКнопки КАК ЗаголовокКнопки,
	|	Избранное.Клавиша КАК Клавиша,
	|	Избранное.АкселераторAlt КАК АкселераторAlt,
	|	Избранное.АкселераторCtrl КАК АкселераторCtrl,
	|	Избранное.АкселераторShift КАК АкселераторShift
	|ПОМЕСТИТЬ ЗарезервированныеГорячиеКлавишиИзбранного
	|ИЗ
	|	&Избранное КАК Избранное
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГорячиеКлавиши.НомерСтроки КАК НомерСтроки,
	|	ГорячиеКлавиши.ИмяКнопки КАК ИмяКнопки,
	|	ГорячиеКлавиши.ЗаголовокКнопки КАК ЗаголовокКнопки,
	|	ГорячиеКлавиши.Клавиша КАК Клавиша,
	|	ГорячиеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	ГорячиеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	ГорячиеКлавиши.АкселераторShift КАК АкселераторShift
	|ПОМЕСТИТЬ РанееОпределенныеГорячиеКлавиши
	|ИЗ
	|	&ГорячиеКлавиши КАК ГорячиеКлавиши
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГорячиеКлавишиКупюр.Номинал КАК Номинал,
	|	ГорячиеКлавишиКупюр.Клавиша КАК Клавиша,
	|	ГорячиеКлавишиКупюр.АкселераторAlt КАК АкселераторAlt,
	|	ГорячиеКлавишиКупюр.АкселераторCtrl КАК АкселераторCtrl,
	|	ГорячиеКлавишиКупюр.АкселераторShift КАК АкселераторShift
	|ПОМЕСТИТЬ ГорячиеКлавишиВводНаличных
	|ИЗ
	|	&ГорячиеКлавишиКупюр КАК ГорячиеКлавишиКупюр
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РанееОпределенныеГорячиеКлавиши.НомерСтроки КАК НомерСтроки,
	|	"""" КАК Номинал,
	|	РанееОпределенныеГорячиеКлавиши.ИмяКнопки КАК ИмяКнопки,
	|	РанееОпределенныеГорячиеКлавиши.ЗаголовокКнопки КАК ЗаголовокКнопки,
	|	РанееОпределенныеГорячиеКлавиши.Клавиша КАК Клавиша,
	|	РанееОпределенныеГорячиеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	РанееОпределенныеГорячиеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	РанееОпределенныеГорячиеКлавиши.АкселераторShift КАК АкселераторShift
	|ПОМЕСТИТЬ ТаблицаГорячиеКлавиши
	|ИЗ
	|	РанееОпределенныеГорячиеКлавиши КАК РанееОпределенныеГорячиеКлавиши
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗарезервированныеГорячиеКлавишиИзбранного.НомерСтроки,
	|	"""",
	|	ЗарезервированныеГорячиеКлавишиИзбранного.ИмяКнопки,
	|	ЗарезервированныеГорячиеКлавишиИзбранного.ЗаголовокКнопки,
	|	ЗарезервированныеГорячиеКлавишиИзбранного.Клавиша,
	|	ЗарезервированныеГорячиеКлавишиИзбранного.АкселераторAlt,
	|	ЗарезервированныеГорячиеКлавишиИзбранного.АкселераторCtrl,
	|	ЗарезервированныеГорячиеКлавишиИзбранного.АкселераторShift
	|ИЗ
	|	ЗарезервированныеГорячиеКлавишиИзбранного КАК ЗарезервированныеГорячиеКлавишиИзбранного
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	0,
	|	ГорячиеКлавишиВводНаличных.Номинал,
	|	"""",
	|	"""",
	|	ГорячиеКлавишиВводНаличных.Клавиша,
	|	ГорячиеКлавишиВводНаличных.АкселераторAlt,
	|	ГорячиеКлавишиВводНаличных.АкселераторCtrl,
	|	ГорячиеКлавишиВводНаличных.АкселераторShift
	|ИЗ
	|	ГорячиеКлавишиВводНаличных КАК ГорячиеКлавишиВводНаличных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаГорячиеКлавиши.Клавиша КАК Клавиша,
	|	ТаблицаГорячиеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	ТаблицаГорячиеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	ТаблицаГорячиеКлавиши.АкселераторShift КАК АкселераторShift,
	|	СУММА(1) КАК КоличествоЗаписей
	|ПОМЕСТИТЬ НаборРазличныхСочетаний
	|ИЗ
	|	ТаблицаГорячиеКлавиши КАК ТаблицаГорячиеКлавиши
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаГорячиеКлавиши.Клавиша,
	|	ТаблицаГорячиеКлавиши.АкселераторAlt,
	|	ТаблицаГорячиеКлавиши.АкселераторCtrl,
	|	ТаблицаГорячиеКлавиши.АкселераторShift
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Дубль"" КАК ТипНарушения,
	|	ТаблицаГорячиеКлавиши.НомерСтроки КАК НомерСтроки,
	|	ТаблицаГорячиеКлавиши.Номинал КАК Номинал,
	|	ТаблицаГорячиеКлавиши.ЗаголовокКнопки КАК ЗаголовокКнопки,
	|	ТаблицаГорячиеКлавиши.Клавиша КАК Клавиша,
	|	ТаблицаГорячиеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	ТаблицаГорячиеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	ТаблицаГорячиеКлавиши.АкселераторShift КАК АкселераторShift,
	|	ВЫБОР
	|		КОГДА НаборРазличныхСочетаний.КоличествоЗаписей > 1
	|				И НЕ ТаблицаГорячиеКлавиши.Клавиша = &КлавишаНет
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЗаписьУникальна
	|ИЗ
	|	ТаблицаГорячиеКлавиши КАК ТаблицаГорячиеКлавиши
	|		ЛЕВОЕ СОЕДИНЕНИЕ НаборРазличныхСочетаний КАК НаборРазличныхСочетаний
	|		ПО ТаблицаГорячиеКлавиши.Клавиша = НаборРазличныхСочетаний.Клавиша
	|			И ТаблицаГорячиеКлавиши.АкселераторAlt = НаборРазличныхСочетаний.АкселераторAlt
	|			И ТаблицаГорячиеКлавиши.АкселераторCtrl = НаборРазличныхСочетаний.АкселераторCtrl
	|			И ТаблицаГорячиеКлавиши.АкселераторShift = НаборРазличныхСочетаний.АкселераторShift";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьТекстЗапросаЗапрещенныхКомбинацийГорячихКлавиш()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ГорячиеКлавиши.НомерСтроки КАК НомерСтроки,
	|	ГорячиеКлавиши.ИмяКнопки КАК ИмяКнопки,
	|	ГорячиеКлавиши.ЗаголовокКнопки КАК ЗаголовокКнопки,
	|	ГорячиеКлавиши.Клавиша КАК Клавиша,
	|	ГорячиеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	ГорячиеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	ГорячиеКлавиши.АкселераторShift КАК АкселераторShift
	|ПОМЕСТИТЬ РанееОпределенныеГорячиеКлавиши
	|ИЗ
	|	&ГорячиеКлавиши КАК ГорячиеКлавиши
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГорячиеКлавишиКупюр.Номинал КАК Номинал,
	|	ГорячиеКлавишиКупюр.Клавиша КАК Клавиша,
	|	ГорячиеКлавишиКупюр.АкселераторAlt КАК АкселераторAlt,
	|	ГорячиеКлавишиКупюр.АкселераторCtrl КАК АкселераторCtrl,
	|	ГорячиеКлавишиКупюр.АкселераторShift КАК АкселераторShift
	|ПОМЕСТИТЬ ГорячиеКлавишиВводНаличных
	|ИЗ
	|	&ГорячиеКлавишиКупюр КАК ГорячиеКлавишиКупюр
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапрещенныеКлавиши.Клавиша КАК Клавиша,
	|	ЗапрещенныеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	ЗапрещенныеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	ЗапрещенныеКлавиши.АкселераторShift КАК АкселераторShift,
	|	ЗапрещенныеКлавиши.РаботаСБуфером КАК РаботаСБуфером
	|ПОМЕСТИТЬ ЗапрещенныеГорячиеКлавиши
	|ИЗ
	|	&ЗапрещенныеКлавиши КАК ЗапрещенныеКлавиши
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ЗапрещенныеКлавиши.РаботаСБуфером ТОГДА ""ЗапрещеннаяКомбинацияБуфер""  ИНАЧЕ ""ЗапрещеннаяКомбинация"" КОНЕЦ КАК ТипНарушения,
	|	РанееОпределенныеГорячиеКлавиши.НомерСтроки КАК НомерСтроки,
	|	"""" КАК Номинал,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(50)) КАК ЗаголовокКнопки,
	|	РанееОпределенныеГорячиеКлавиши.Клавиша КАК Клавиша,
	|	РанееОпределенныеГорячиеКлавиши.АкселераторAlt КАК АкселераторAlt,
	|	РанееОпределенныеГорячиеКлавиши.АкселераторCtrl КАК АкселераторCtrl,
	|	РанееОпределенныеГорячиеКлавиши.АкселераторShift КАК АкселераторShift
	|ИЗ
	|	РанееОпределенныеГорячиеКлавиши КАК РанееОпределенныеГорячиеКлавиши
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗапрещенныеГорячиеКлавиши КАК ЗапрещенныеКлавиши
	|		ПО РанееОпределенныеГорячиеКлавиши.Клавиша = ЗапрещенныеКлавиши.Клавиша
	|			И РанееОпределенныеГорячиеКлавиши.АкселераторAlt = ЗапрещенныеКлавиши.АкселераторAlt
	|			И РанееОпределенныеГорячиеКлавиши.АкселераторCtrl = ЗапрещенныеКлавиши.АкселераторCtrl
	|			И РанееОпределенныеГорячиеКлавиши.АкселераторShift = ЗапрещенныеКлавиши.АкселераторShift
	|			И ((Не ЗапрещенныеКлавиши.РаботаСБуфером) Или РанееОпределенныеГорячиеКлавиши.ИмяКнопки В (&КомандыСАктивнымБуфером))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ЗапрещеннаяКомбинация"",
	|	0,
	|	ГорячиеКлавишиВводНаличных.Номинал,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(50)),
	|	ГорячиеКлавишиВводНаличных.Клавиша,
	|	ГорячиеКлавишиВводНаличных.АкселераторAlt,
	|	ГорячиеКлавишиВводНаличных.АкселераторCtrl,
	|	ГорячиеКлавишиВводНаличных.АкселераторShift
	|ИЗ
	|	ГорячиеКлавишиВводНаличных КАК ГорячиеКлавишиВводНаличных
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗапрещенныеГорячиеКлавиши КАК ЗапрещенныеКлавиши
	|		ПО ГорячиеКлавишиВводНаличных.Клавиша = ЗапрещенныеКлавиши.Клавиша
	|			И ГорячиеКлавишиВводНаличных.АкселераторAlt = ЗапрещенныеКлавиши.АкселераторAlt
	|			И ГорячиеКлавишиВводНаличных.АкселераторCtrl = ЗапрещенныеКлавиши.АкселераторCtrl
	|			И ГорячиеКлавишиВводНаличных.АкселераторShift = ЗапрещенныеКлавиши.АкселераторShift
	|			И Не ЗапрещенныеКлавиши.РаботаСБуфером";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ДобавитьЗапрещеннуюКомбинациюКлавиш(ЗапрещенныеКлавиши, КлавишаСтрокой,
		АкселераторAlt, АкселераторCtrl, АкселераторShift, РаботаСБуфером = Ложь)
		
	НоваяСтрока = ЗапрещенныеКлавиши.Добавить();
	НоваяСтрока.Клавиша = КлавишаСтрокой;
	НоваяСтрока.АкселераторAlt = АкселераторAlt;
	НоваяСтрока.АкселераторCtrl = АкселераторCtrl;
	НоваяСтрока.АкселераторShift = АкселераторShift;
	НоваяСтрока.РаботаСБуфером = РаботаСБуфером;
	
КонецПроцедуры

Процедура ЗагрузитьТаблицуВводаНаличных(НастройкаРМКОбъект, ТаблицаНоминаловКупюр)
	
	НастройкаРМКОбъект.ВводНаличных.Очистить();
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	
	МассивНоминаловКупюр = ОбщегоНазначенияРМККлиентСервер.НоминалыКупюр();
	ИндексСтроки = 0;
	ТекущаяСтрокаНоминала = Неопределено;
	КоличествоСтрокТаблицы = ТаблицаНоминаловКупюр.Количество();
	Для Каждого ЭлементНоминала Из МассивНоминаловКупюр Цикл
		
		НоминалЧислом = ОписаниеТипаЧисло.ПривестиЗначение(ЭлементНоминала);
		Если НоминалЧислом > 0 Тогда
			
			ТекущийНоминалТаблицы = 0;
			Пока ТекущийНоминалТаблицы < НоминалЧислом И ИндексСтроки < КоличествоСтрокТаблицы Цикл
				ТекущаяСтрокаНоминала = ТаблицаНоминаловКупюр[ИндексСтроки];
				ТекущийНоминалТаблицы = ОписаниеТипаЧисло.ПривестиЗначение(ТекущаяСтрокаНоминала.Номинал);
				ИндексСтроки = ИндексСтроки + 1;
			КонецЦикла;
			КлавишаКупюры = ИнтерфейсРМКСлужебныйКлиентСервер.ПредставлениеПустойКлавиши();
			ИспользованиеНоминала = Истина;
			Если ТекущийНоминалТаблицы = НоминалЧислом Тогда
				ИспользованиеНоминала = ТекущаяСтрокаНоминала.Использование;
				Если Не ТаблицаНоминаловКупюр.Колонки.Найти("Клавиша") = Неопределено Тогда
					КлавишаКупюры = ТекущаяСтрокаНоминала.Клавиша;
				КонецЕсли;
			КонецЕсли;
			НоваяСтрока = НастройкаРМКОбъект.ВводНаличных.Добавить();
			НоваяСтрока.Номинал = ЭлементНоминала;
			НоваяСтрока.Использование = ИспользованиеНоминала;
			НоваяСтрока.Клавиша = КлавишаКупюры;
		
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли