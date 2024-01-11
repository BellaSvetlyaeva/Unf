#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	УстановитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементовВыбораФайлов(Ложь);
	
	ТекстСообщения = НСтр("ru = 'Для загрузки файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
	Обработчик = Новый ОписаниеОповещения("УстановитьВидимостьЭлементовВыбораФайлов", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКФайламПриИзменении(Элемент)
	
	ПрочитатьФайлы(ПутьКФайлам);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайламНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = НСтр("ru='Выберите каталог с файлами сведений'");
	ДиалогВыбораКаталога.Каталог = ПутьКФайлам;
	ДиалогВыбораКаталога.Показать(Новый ОписаниеОповещения("ПутьКФайламПослеВыбора", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайламПослеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлам = ВыбранныеФайлы[0];
	
	ПрочитатьФайлы(ПутьКФайлам);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыФайлыСведений

&НаКлиенте
Процедура ФайлыСведенийИмпортироватьСЗВТДПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элементы.ФайлыСведений.ТекущиеДанные.ФайлПротокола) Тогда
		Элементы.ФайлыСведений.ТекущиеДанные.ИмпортироватьПротокол = Элементы.ФайлыСведений.ТекущиеДанные.ИмпортироватьСЗВТД;
	КонецЕсли;
	
	Если Элементы.ФайлыСведений.ТекущиеДанные.ИмпортироватьСЗВТД Тогда
		УстановитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(ЭтотОбъект, Истина);
	Иначе
		ОбновитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыСведенийИмпортироватьПротоколПриИзменении(Элемент)
	
	Если Элементы.ФайлыСведений.ТекущиеДанные.ИмпортироватьПротокол Тогда
		УстановитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(ЭтотОбъект, Истина);
	Иначе
		ОбновитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыСведенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ФайлыСведений.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если Поле.Имя = "ФайлыСведенийФайлСЗВТД" Тогда
			
			Если ЗначениеЗаполнено(ТекущиеДанные.ФайлСЗВТДПолноеИмя) Тогда
				ЗапуститьПриложение(ТекущиеДанные.ФайлСЗВТДПолноеИмя);
			КонецЕсли;
			
		ИначеЕсли Поле.Имя = "ФайлыСведенийФайлПротокола" Тогда
			
			Если ЗначениеЗаполнено(ТекущиеДанные.ФайлПротоколаПолноеИмя) Тогда
				ЗапуститьПриложение(ТекущиеДанные.ФайлПротоколаПолноеИмя);
			КонецЕсли;
			
		ИначеЕсли Поле.Имя = "ФайлыСведенийДокументСЗВТД" Тогда
			
			Если ЗначениеЗаполнено(ТекущиеДанные.ДокументСЗВТД) Тогда
				ПоказатьЗначение(, ТекущиеДанные.ДокументСЗВТД);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиФайлыСведений(Команда)
	
	ПрочитатьФайлы(ПутьКФайлам);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	ПрочитатьФайлы(ПутьКФайлам);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтмеченныеФайлы(Команда)
	
	ОчиститьСообщения();
	ЗагрузитьОтмеченныеФайлыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьСЗВТДБезПроверкиПротоколаПриема(Команда)
	
	ЗагружатьСЗВТДБезПроверкиПротоколаПриема = Не ЗагружатьСЗВТДБезПроверкиПротоколаПриема;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФайлыСведенийЗагружатьСЗВТДБезПроверкиПротоколаПриема",
		"Пометка",
		ЗагружатьСЗВТДБезПроверкиПротоколаПриема);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементовВыбораФайлов(Подключено, ДополнительныеПараметры = Неопределено) Экспорт
	
	РасширениеПодключено = Подключено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПутьКФайлам",
		"Видимость",
		Подключено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФайлыСведенийНайтиФайлыСведений",
		"Видимость",
		Подключено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДобавитьФайл",
		"Видимость",
		Не Подключено);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Доступность импорта для доступных организаций
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.Организация");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ФайлыСведений");
	ОформляемоеПоле.Использование = Истина;
	
	// Доступность флажка импорта файла СЗВ-ТД
	// 1. Есть файл СЗВ-ТД
	// 2. Есть файл протокола приема
	// 3. Нет документа с таким именем файла.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ГруппаИли = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ЭлементОтбора = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ФайлСЗВТД");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОтбора = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ДокументСЗВТД");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Заполнено;
	
	ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ГруппаИлиПротокола = ГруппаИ.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИлиПротокола.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ЭлементОтбора = ГруппаИлиПротокола.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ФайлПротокола");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОтбора = ГруппаИлиПротокола.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ПринятВПФР");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение	= Ложь;
	
	ЭлементОтбора = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ЗагружатьСЗВТДБезПроверкиПротоколаПриема");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение	= Ложь;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ФайлыСведенийИмпортироватьСЗВТД");
	ОформляемоеПоле.Использование = Истина;
	
	
	// Доступность флажка импорта файла протокола
	// 1. Нет документа СЗВ-ТД
	// 2. Или не импортируется файл СЗВ-ТД
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ГруппаИли = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ЭлементОтбора = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ДокументСЗВТД");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОтбора = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ИмпортироватьСЗВТД");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение	= Ложь;
	
	ЭлементОтбора = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ФайлПротокола");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ФайлыСведенийИмпортироватьПротокол");
	ОформляемоеПоле.Использование = Истина;
	
	// Отрицательные протоколы приема помечаем красным цветом
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ГруппаИ = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ЭлементОтбора = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ФайлПротокола");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементОтбора = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ФайлыСведений.ПринятВПФР");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение	= Ложь;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ФайлыСведенийФайлПротокола");
	ОформляемоеПоле.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлы(КаталогФайлов, ПараметрыЗагрузки = Неопределено)
	
	Если Не РасширениеПодключено Тогда
		// Веб-клиент без расширения для работы с файлами.
		Обработчик = Новый ОписаниеОповещения("ПрочитатьФайлыИзКаталогаПослеПомещенияФайла", ЭтотОбъект, ПутьКФайлам);
		НачатьПомещениеФайла(Обработчик, , , , УникальныйИдентификатор); 
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		
		// Веб-клиент с подключенным расширением.
		Если ПрочитанныйПутьКФайлам = ВРег(ПутьКФайлам) Тогда
			Возврат;
		КонецЕсли;
		
	#КонецЕсли
	
	ФайлыСведений.Очистить();
	
	// Инициализируем каталог
	Каталог = Новый Файл;
	Каталог.НачатьИнициализацию(Новый ОписаниеОповещения("ПрочитатьФайлыИзКаталогаПослеИнициализацииКаталога", ЭтотОбъект, ПараметрыЗагрузки), ПутьКФайлам);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлыИзКаталогаПослеИнициализацииКаталога(Каталог, ПараметрыЗагрузки) Экспорт
	
	// Теперь нужно проверить каталог на существование.
	
	Каталог.НачатьПроверкуСуществования(
		Новый ОписаниеОповещения("ПрочитатьФайлыИзКаталогаПослеПроверкиСуществования", ЭтотОбъект, ПараметрыЗагрузки));
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлыИзКаталогаПослеПроверкиСуществования(Существует, ПараметрыЗагрузки) Экспорт
	
	Если Не Существует Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Каталог «%1» не обнаружен.'"), ПутьКФайлам);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	// Если каталог существует, начинаем поиск.
	Обработчик = Новый ОписаниеОповещения("ПрочитатьФайлыИзКаталогаПослеПоискаФайлов", ЭтотОбъект, ПараметрыЗагрузки);
	НачатьПоискФайлов(Обработчик, ПутьКФайлам, "*.xml", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлыИзКаталогаПослеПоискаФайлов(НайденныеФайлы, ПараметрыЗагрузки) Экспорт
	
	Если НайденныеФайлы.Количество() = 0 Тогда
		
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В каталоге «%1» не найдено файлов для загрузки.'"), ПутьКФайлам);
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	Для Каждого ОписаниеФайла Из НайденныеФайлы Цикл
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ОписаниеФайла.ПолноеИмя, ""));
	КонецЦикла;
	
	Если ПомещаемыеФайлы.Количество() = 0 Тогда
		
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В каталоге «%1» не найдено файлов для импорта.'"), ПутьКФайлам);
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ПрочитатьФайлыИзКаталогаПослеПомещенияФайлов", ЭтотОбъект, ПараметрыЗагрузки);
	НачатьПомещениеФайлов(Обработчик, ПомещаемыеФайлы, , Ложь, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлыИзКаталогаПослеПомещенияФайлов(ПомещенныеФайлы, ПараметрыЗагрузки) Экспорт
	
	ОбновитьФайлыСведенийНаСервере(ПомещенныеФайлы);
	ПрочитанныйПутьКФайлам = ВРег(ПутьКФайлам);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлыИзКаталогаПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла, ПараметрыЗагрузки) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ПомещенныеФайлы = Новый Массив;
	ПомещенныеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, Адрес));
	
	ПрочитатьФайлыИзКаталогаЗавершение(ПомещенныеФайлы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлыИзКаталогаЗавершение(ПомещенныеФайлы)
	
	ОбновитьФайлыСведенийНаСервере(ПомещенныеФайлы);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФайлыСведенийНаСервере(ПомещенныеФайлы)
	
	ДокументыСЗВТД = Новый Соответствие;
	
	Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ФайлСЗВТДДляПоиска", ВРег(ПомещенныйФайл.Имя));
		Если ФайлыСведений.НайтиСтроки(СтруктураПоиска).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ФайлПротоколаДляПоиска", ВРег(ПомещенныйФайл.Имя));
		
		Если ФайлыСведений.НайтиСтроки(СтруктураПоиска).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДеревоXML = ЭлектронныеТрудовыеКнижки.ДанныеXMLФайла(ПомещенныйФайл.Хранение, ПомещенныйФайл.Имя);
		Если Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ЭтоДанныеСЗВТД(ДеревоXML) Тогда
			
			ПринятыйФайл = Новый Файл(ПомещенныйФайл.Имя);
			
			РегистрационныйНомерПФР = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СЗВ_ТД/Работодатель/РегНомер");
			ОтчетныйГод = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СЗВ_ТД/ОтчетныйПериод/КалендарныйГод");
			ОтчетныйМесяц = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СЗВ_ТД/ОтчетныйПериод/Месяц");
			ДатаЗаполнения = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СЗВ_ТД/ДатаЗаполнения");
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ФайлСЗВТДГруппировка", ИдентифкаторФайла(ПринятыйФайл.Имя));
			НайденныеСтроки = ФайлыСведений.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				СтрокаФайлыСведений = ФайлыСведений.Добавить();
				Если ДатаЗаполнения <> Неопределено Тогда
					СтрокаФайлыСведений.ДатаЗаполнения = НачалоМесяца(СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаЗаполнения));
				КонецЕсли;
				
				Если ОтчетныйГод <> Неопределено
					И ОтчетныйМесяц <> Неопределено Тогда
					
					СтрокаФайлыСведений.ОтчетныйПериод = Дата(
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйГод),
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйМесяц),
						1);
						
				Иначе
					СтрокаФайлыСведений.ОтчетныйПериод = НачалоМесяца(СтрокаФайлыСведений.ДатаЗаполнения);
				КонецЕсли;
				
				СтрокаФайлыСведений.ФайлСЗВТДГруппировка = ИдентифкаторФайла(ПринятыйФайл.Имя);
				
			Иначе
				СтрокаФайлыСведений = НайденныеСтроки[0];
			КонецЕсли;
			
			СтрокаФайлыСведений.ФайлСЗВТД = ПринятыйФайл.Имя;
			СтрокаФайлыСведений.ХранениеСЗВТД = ПомещенныйФайл.Хранение;
			СтрокаФайлыСведений.ФайлСЗВТДДляПоиска = ВРег(СтрокаФайлыСведений.ФайлСЗВТД);
			
			Если РасширениеПодключено Тогда
				СтрокаФайлыСведений.ФайлСЗВТДПолноеИмя = ПомещенныйФайл.ПолноеИмя;
			Иначе
				СтрокаФайлыСведений.ФайлСЗВТДПолноеИмя = ПомещенныйФайл.Имя;
			КонецЕсли;
			
			СтрокаФайлыСведений.Организация = ЭлектронныеТрудовыеКнижкиПовтИсп.ОрганизацияПоРегистрационномуНомеруПФР(РегистрационныйНомерПФР);
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.Организация) Тогда
				СтрокаФайлыСведений.ОрганизацияПредставление = Строка(СтрокаФайлыСведений.Организация);
			Иначе
				
				СтрокаФайлыСведений.ОрганизацияПредставление = СтрШаблон(
					НСтр("ru = 'Не найдена (рег. %1)'"),
					РегистрационныйНомерПФР);
				
			КонецЕсли;
			
			ДокументСЗВТД = ДокументыСЗВТД.Получить(ПринятыйФайл.Имя);
			Если ДокументСЗВТД = Неопределено Тогда
				
				ДокументСЗВТД = Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ДокументПоИмениФайла(ПринятыйФайл.Имя);
				Если ДокументСЗВТД = Неопределено Тогда
					ДокументыСЗВТД.Вставить(ПринятыйФайл.Имя, Ложь);
				Иначе
					ДокументыСЗВТД.Вставить(ПринятыйФайл.Имя, ДокументСЗВТД);
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаФайлыСведений.ДокументСЗВТД = ДокументСЗВТД;
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.ДокументСЗВТД) Тогда
				СтрокаФайлыСведений.ДатаЗаполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаФайлыСведений.ДокументСЗВТД, "Дата");
			КонецЕсли;
			
		ИначеЕсли Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ЭтоДанныеПротоколаПриемаСЗВТД(ДеревоXML) Тогда
			
			ПринятыйФайл = Новый Файл(ПомещенныйФайл.Имя);
			
			РегистрационныйНомерПФР = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СлужебнаяИнформация/Контрагент/РегистрационныйНомер");
			ИмяФайлаПротокола = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "УПП/ПроверяемыйДокумент/Файл/ИмяФайла");
			ОтчетныйГод = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СлужебнаяИнформация/ОтчетныйГод");
			ОтчетныйМесяц = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СлужебнаяИнформация/ОтчетныйМесяц");
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ФайлСЗВТДГруппировка", ИдентифкаторФайла(ИмяФайлаПротокола));
			НайденныеСтроки = ФайлыСведений.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				СтрокаФайлыСведений = ФайлыСведений.Добавить();
				Если ОтчетныйГод <> Неопределено
					И ОтчетныйМесяц <> Неопределено Тогда
					
					СтрокаФайлыСведений.ОтчетныйПериод = Дата(
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйГод),
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйМесяц),
						1);
					
				КонецЕсли;
				
				СтрокаФайлыСведений.ФайлСЗВТДГруппировка = ИдентифкаторФайла(ИмяФайлаПротокола);
				
			Иначе
				СтрокаФайлыСведений = НайденныеСтроки[0];
			КонецЕсли;
			
			СтрокаФайлыСведений.ФайлПротокола = ПринятыйФайл.Имя;
			СтрокаФайлыСведений.ХранениеПротокола = ПомещенныйФайл.Хранение;
			СтрокаФайлыСведений.ФайлПротоколаДляПоиска = ВРег(СтрокаФайлыСведений.ФайлПротокола);
			
			Если РасширениеПодключено Тогда
				СтрокаФайлыСведений.ФайлПротоколаПолноеИмя = ПомещенныйФайл.ПолноеИмя;
			Иначе
				СтрокаФайлыСведений.ФайлПротоколаПолноеИмя = ПомещенныйФайл.Имя;
			КонецЕсли;
			
			СтрокаФайлыСведений.Организация = ЭлектронныеТрудовыеКнижкиПовтИсп.ОрганизацияПоРегистрационномуНомеруПФР(РегистрационныйНомерПФР);
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.Организация) Тогда
				СтрокаФайлыСведений.ОрганизацияПредставление = Строка(СтрокаФайлыСведений.Организация);
			Иначе
				
				СтрокаФайлыСведений.ОрганизацияПредставление = СтрШаблон(
					НСтр("ru = 'Не найдена (рег. %1)'"),
					РегистрационныйНомерПФР);
				
			КонецЕсли;
			
			ДокументСЗВТД = ДокументыСЗВТД.Получить(ИмяФайлаПротокола);
			Если ДокументСЗВТД = Неопределено Тогда
				
				ДокументСЗВТД = Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ДокументПоИмениФайла(ИмяФайлаПротокола);
				Если ДокументСЗВТД = Неопределено Тогда
					ДокументыСЗВТД.Вставить(ИмяФайлаПротокола, Ложь);
				Иначе
					ДокументыСЗВТД.Вставить(ИмяФайлаПротокола, ДокументСЗВТД);
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаФайлыСведений.ДокументСЗВТД = ДокументСЗВТД;
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.ДокументСЗВТД) Тогда
				СтрокаФайлыСведений.ДатаЗаполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаФайлыСведений.ДокументСЗВТД, "Дата");
			КонецЕсли;
			
			РезультатПроверки = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СлужебнаяИнформация/РезультатПроверки");
			Если РезультатПроверки = НСтр("ru = 'Документ принят'")
				Или РезультатПроверки = НСтр("ru = 'Документ принят частично'") Тогда
				
				СтрокаФайлыСведений.ПринятВПФР = Истина;
				
			ИначеЕсли РезультатПроверки = НСтр("ru = 'Документ не принят'") Тогда
				
				СтрокаФайлыСведений.ФайлПротокола = "(" + НСтр("ru = 'не принят'") + ") " + СтрокаФайлыСведений.ФайлПротокола;
				
			КонецЕсли;
			
		ИначеЕсли Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ЭтоДанныеСЗВТДВЕФС1(ДеревоXML) Тогда
			
			ПринятыйФайл = Новый Файл(ПомещенныйФайл.Имя);
			
			РегистрационныйНомерПФР = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "Страхователь/РегНомер");
			ОтчетныйГод = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СЗВ_ТД/ОтчетныйПериод/КалендарныйГод");
			ОтчетныйМесяц = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СЗВ_ТД/ОтчетныйПериод/Месяц");
			ДатаЗаполнения = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "ДатаЗаполнения");
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ФайлСЗВТДГруппировка", ИдентифкаторФайла(ПринятыйФайл.Имя));
			НайденныеСтроки = ФайлыСведений.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				СтрокаФайлыСведений = ФайлыСведений.Добавить();
				Если ДатаЗаполнения <> Неопределено Тогда
					СтрокаФайлыСведений.ДатаЗаполнения = НачалоМесяца(СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаЗаполнения));
				КонецЕсли;
				
				Если ОтчетныйГод <> Неопределено
					И ОтчетныйМесяц <> Неопределено Тогда
					
					СтрокаФайлыСведений.ОтчетныйПериод = Дата(
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйГод),
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйМесяц),
						1);
						
				Иначе
					СтрокаФайлыСведений.ОтчетныйПериод = НачалоМесяца(СтрокаФайлыСведений.ДатаЗаполнения);
				КонецЕсли;
				
				СтрокаФайлыСведений.ФайлСЗВТДГруппировка = ИдентифкаторФайла(ПринятыйФайл.Имя);
				
			Иначе
				СтрокаФайлыСведений = НайденныеСтроки[0];
			КонецЕсли;
			
			СтрокаФайлыСведений.ФайлСЗВТД = ПринятыйФайл.Имя;
			СтрокаФайлыСведений.ХранениеСЗВТД = ПомещенныйФайл.Хранение;
			СтрокаФайлыСведений.ФайлСЗВТДДляПоиска = ВРег(СтрокаФайлыСведений.ФайлСЗВТД);
			
			Если РасширениеПодключено Тогда
				СтрокаФайлыСведений.ФайлСЗВТДПолноеИмя = ПомещенныйФайл.ПолноеИмя;
			Иначе
				СтрокаФайлыСведений.ФайлСЗВТДПолноеИмя = ПомещенныйФайл.Имя;
			КонецЕсли;
			
			СтрокаФайлыСведений.Организация = ЭлектронныеТрудовыеКнижкиПовтИсп.ОрганизацияПоРегистрационномуНомеруПФР(РегистрационныйНомерПФР);
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.Организация) Тогда
				СтрокаФайлыСведений.ОрганизацияПредставление = Строка(СтрокаФайлыСведений.Организация);
			Иначе
				
				СтрокаФайлыСведений.ОрганизацияПредставление = СтрШаблон(
					НСтр("ru = 'Не найдена (рег. %1)'"),
					РегистрационныйНомерПФР);
				
			КонецЕсли;
			
			ДокументСЗВТД = ДокументыСЗВТД.Получить(ПринятыйФайл.Имя);
			Если ДокументСЗВТД = Неопределено Тогда
				
				ДокументСЗВТД = Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ДокументПоИмениФайла(ПринятыйФайл.Имя);
				Если ДокументСЗВТД = Неопределено Тогда
					ДокументыСЗВТД.Вставить(ПринятыйФайл.Имя, Ложь);
				Иначе
					ДокументыСЗВТД.Вставить(ПринятыйФайл.Имя, ДокументСЗВТД);
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаФайлыСведений.ДокументСЗВТД = ДокументСЗВТД;
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.ДокументСЗВТД) Тогда
				СтрокаФайлыСведений.ДатаЗаполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаФайлыСведений.ДокументСЗВТД, "Дата");
			КонецЕсли;
			
		ИначеЕсли Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ЭтоДанныеПротоколаПриемаСЗВТДВЕФС1(ДеревоXML) Тогда
			
			ПринятыйФайл = Новый Файл(ПомещенныйФайл.Имя);
			
			РегистрационныйНомерПФР = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СлужебнаяИнформация/Контрагент/РегистрационныйНомер");
			ИмяФайлаПротокола = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "УПП/ПроверяемыйДокумент/Файл/ИмяФайла");
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ФайлСЗВТДГруппировка", ИдентифкаторФайла(ИмяФайлаПротокола));
			НайденныеСтроки = ФайлыСведений.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				СтрокаФайлыСведений = ФайлыСведений.Добавить();
				Если ОтчетныйГод <> Неопределено
					И ОтчетныйМесяц <> Неопределено Тогда
					
					СтрокаФайлыСведений.ОтчетныйПериод = Дата(
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйГод),
						СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ОтчетныйМесяц),
						1);
					
				КонецЕсли;
				
				СтрокаФайлыСведений.ФайлСЗВТДГруппировка = ИдентифкаторФайла(ИмяФайлаПротокола);
				
			Иначе
				СтрокаФайлыСведений = НайденныеСтроки[0];
			КонецЕсли;
			
			СтрокаФайлыСведений.ФайлПротокола = ПринятыйФайл.Имя;
			СтрокаФайлыСведений.ХранениеПротокола = ПомещенныйФайл.Хранение;
			СтрокаФайлыСведений.ФайлПротоколаДляПоиска = ВРег(СтрокаФайлыСведений.ФайлПротокола);
			
			Если РасширениеПодключено Тогда
				СтрокаФайлыСведений.ФайлПротоколаПолноеИмя = ПомещенныйФайл.ПолноеИмя;
			Иначе
				СтрокаФайлыСведений.ФайлПротоколаПолноеИмя = ПомещенныйФайл.Имя;
			КонецЕсли;
			
			СтрокаФайлыСведений.Организация = ЭлектронныеТрудовыеКнижкиПовтИсп.ОрганизацияПоРегистрационномуНомеруПФР(РегистрационныйНомерПФР);
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.Организация) Тогда
				СтрокаФайлыСведений.ОрганизацияПредставление = Строка(СтрокаФайлыСведений.Организация);
			Иначе
				
				СтрокаФайлыСведений.ОрганизацияПредставление = СтрШаблон(
					НСтр("ru = 'Не найдена (рег. %1)'"),
					РегистрационныйНомерПФР);
				
			КонецЕсли;
			
			ДокументСЗВТД = ДокументыСЗВТД.Получить(ИмяФайлаПротокола);
			Если ДокументСЗВТД = Неопределено Тогда
				
				ДокументСЗВТД = Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ДокументПоИмениФайла(ИмяФайлаПротокола);
				Если ДокументСЗВТД = Неопределено Тогда
					ДокументыСЗВТД.Вставить(ИмяФайлаПротокола, Ложь);
				Иначе
					ДокументыСЗВТД.Вставить(ИмяФайлаПротокола, ДокументСЗВТД);
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаФайлыСведений.ДокументСЗВТД = ДокументСЗВТД;
			Если ЗначениеЗаполнено(СтрокаФайлыСведений.ДокументСЗВТД) Тогда
				СтрокаФайлыСведений.ДатаЗаполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаФайлыСведений.ДокументСЗВТД, "Дата");
			КонецЕсли;
			
			РезультатПроверки = ЭлектронныеТрудовыеКнижки.ПолучитьСвойствоXDTO(ДеревоXML, "СлужебнаяИнформация/РезультатПроверки");
			Если РезультатПроверки = НСтр("ru = 'Документ принят'")
				Или РезультатПроверки = НСтр("ru = 'Документ принят частично'") Тогда
				
				СтрокаФайлыСведений.ПринятВПФР = Истина;
				
			ИначеЕсли РезультатПроверки = НСтр("ru = 'Документ не принят'") Тогда
				
				СтрокаФайлыСведений.ФайлПротокола = "(" + НСтр("ru = 'не принят'") + ") " + СтрокаФайлыСведений.ФайлПротокола;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ФайлыСведений.Сортировать("ОтчетныйПериод,ОрганизацияПредставление,ДатаЗаполнения");
	
	ОбновитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(УправляемаяФорма)
	
	ДоступностьЗагрузки = УправляемаяФорма.ФайлыСведений.НайтиСтроки(Новый Структура("ИмпортироватьСЗВТД", Истина)).Количество() > 0;
	Если Не ДоступностьЗагрузки Тогда
		ДоступностьЗагрузки = УправляемаяФорма.ФайлыСведений.НайтиСтроки(Новый Структура("ИмпортироватьПротокол", Истина)).Количество() > 0;
	КонецЕсли;
	
	УстановитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(УправляемаяФорма, ДоступностьЗагрузки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандыЗагрузитьОтмеченныеФайлы(УправляемаяФорма, ДоступностьЗагрузки)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ФормаЗагрузитьОтмеченныеФайлы",
		"Доступность",
		ДоступностьЗагрузки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОтмеченныеФайлыНаСервере()
	
	Для Каждого СтрокаФайловСведений Из ФайлыСведений Цикл
		
		Если СтрокаФайловСведений.ИмпортироватьСЗВТД Тогда
			
			Отказ = Ложь;
			
			ОбъектСЗВТД = Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.СоздатьДокумент();
			Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ЗаполнитьПоДаннымФайла(
				ОбъектСЗВТД, СтрокаФайловСведений.ХранениеСЗВТД,
				СтрокаФайловСведений.ФайлСЗВТДПолноеИмя, Отказ);
			
			ОбъектСЗВТД.ДополнительныеСвойства.Вставить("ПроверкаЗаполненияПередЗаписьюЗагруженногоДокумента", Истина);
			Если Не Отказ И ОбъектСЗВТД.ПроверитьЗаполнение() Тогда
				
				ОбъектСЗВТД.ДополнительныеСвойства.Вставить("СохранитьИмяФайла", Истина);
				ОбъектСЗВТД.Записать(РежимЗаписиДокумента.Проведение);
				
				СтрокаФайловСведений.ИмпортироватьСЗВТД = Ложь;
				СтрокаФайловСведений.ДокументСЗВТД = ОбъектСЗВТД.Ссылка;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтрокаФайловСведений.ИмпортироватьПротокол И ЗначениеЗаполнено(СтрокаФайловСведений.ДокументСЗВТД) Тогда
			
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", СтрокаФайловСведений.ДокументСЗВТД);
			
			Попытка
				
				Блокировка.Заблокировать();
				
				ОбъектСЗВТД = СтрокаФайловСведений.ДокументСЗВТД.ПолучитьОбъект();
				Документы.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.ПрочитатьПротоколПриема(
					ОбъектСЗВТД, СтрокаФайловСведений.ХранениеПротокола, СтрокаФайловСведений.ФайлПротоколаПолноеИмя);
				
				ОбъектСЗВТД.ДополнительныеСвойства.Вставить("СохранитьИмяФайла", Истина);
				ОбъектСЗВТД.Записать(РежимЗаписиДокумента.Проведение);
				
				ЗафиксироватьТранзакцию();
				
				СтрокаФайловСведений.ИмпортироватьПротокол = Ложь;
				
			Исключение
				
				ОтменитьТранзакцию();
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Импорт файлов СЗВ-ТД.Ошибка блокировки'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Предупреждение, , СтрокаФайловСведений.ДокументСЗВТД, "Документ.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД");
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ИдентифкаторФайла(ИмяФайла)
	
	ПозицияТочки = СтрНайти(ИмяФайла, ".");
	Если ПозицияТочки > 0 Тогда
		Идентифкатор = СокрЛП(Лев(ИмяФайла, ПозицияТочки - 1));
	Иначе
		Идентифкатор = СокрЛП(ИмяФайла);
	КонецЕсли;
	
	Идентифкатор = Прав(Идентифкатор, 36);
	
	Возврат ВРег(Идентифкатор);
	
КонецФункции

#КонецОбласти

