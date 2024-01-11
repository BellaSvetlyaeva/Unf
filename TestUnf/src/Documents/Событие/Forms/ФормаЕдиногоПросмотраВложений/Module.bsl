#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ссылка = Параметры.Ссылка;
	ПринятыеВложения = Неопределено;
	Параметры.Свойство("ПринятыеВложения", ПринятыеВложения);
	
	Если ПринятыеВложения <> Неопределено И ЭтоАдресВременногоХранилища(ПринятыеВложения) Тогда
		
		ТаблицаВложений = ПолучитьИзВременногоХранилища(Параметры.Вложения);
		ЗначениеВРеквизитФормы(ТаблицаВложений, "Вложения");
		УчастникиИДубли.ЗагрузитьЗначения(Параметры.Участники);
		
		Основание = Параметры.Основание;
		ТекущийПользователь = Пользователи.АвторизованныйПользователь();
		РедактированиеРазрешено = Параметры.РедактированиеРазрешено;
		
	Иначе
		
		ЗаполнитьРеквизитыФормыПоСобытию(Ссылка);
		
	КонецЕсли;
	
	АвтоЗаголовок = Ложь;
	Заголовок = НСтр("ru = 'Предпросмотр файлов'");
	ТекстПредупреждение = НСтр("ru = 'Невозможно отобразить данный файл для просмотра'");
	Если Не ЗначениеЗаполнено(ТаблицаВложений) Тогда
		ТипФайла = "Неподдерживаемый";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Модифицированность И РедактированиеРазрешено Тогда
		Закрыть(АдресВложенийВХранилище());
		Модифицированность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьКомандыИПросмотр();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Свойство("Событие")
		И (Параметр.Событие = "ЗаконченоРедактирование") Тогда
		
		ДанныеФайла = ПолучитьДанныеФайла(Источник, УникальныйИдентификатор);
		Отбор = Новый Структура("Ссылка", ДанныеФайла.Ссылка);
		НужнаяСтрока = Вложения.НайтиСтроки(Отбор);
		
		Если ЗначениеЗаполнено(НужнаяСтрока) Тогда
			НужнаяСтрока[0].АдресВоВременномХранилище = 
			ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
			Элементы.Вложения.ТекущаяСтрока = НужнаяСтрока[0].ПолучитьИдентификатор();
			ВложенияПриАктивизацииСтроки(Элементы.Вложения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаДвоичныеДанныеФайла = Элемент.ТекущиеДанные.АдресВоВременномХранилище;
	РасширениеТекущегоФайла = НРег(ПолучитьРасширениеИмениФайла(Элемент.ТекущиеДанные.Представление));
	
	Если СсылкаНаДвоичныеДанныеФайла = "" Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьПредпросмотр();
	ПоказатьФайл();
	
	ПоказатьОповещениеПользователя(
	НСтр("ru = 'Предпросмотр вложения'"),,
	НСтр("ru = 'Файл загружается для предпросмотра'"),
	БиблиотекаКартинок.Информация32);
	
	ПодключитьОбработчикОжидания("ПолучитьФайлДляПредпросмотра", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьВложение();
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	ДобавлениеФайлаКВложениям();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьВложение();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	Если Элементы.Вложения.ТекущаяСтрока = Неопределено Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Файл для сохранения не обнаружен'"));
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.СохранитьФайл(
	,
	Элементы.Вложения.ТекущиеДанные.АдресВоВременномХранилище,
	Элементы.Вложения.ТекущиеДанные.Представление);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВсеФайлы(Команда)
	
	Если ЗначениеЗаполнено(Вложения) Тогда
		
		МассивДанных = Новый Массив;
		Для Каждого ЭлементКоллекции Из Вложения Цикл
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
			ЭлементКоллекции.Представление,
			ЭлементКоллекции.АдресВоВременномХранилище);
			МассивДанных.Добавить(ОписаниеФайла);
		КонецЦикла;
		
		ФайловаяСистемаКлиент.СохранитьФайлы(, МассивДанных);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Если Не ЗначениеЗаполнено(ИмяОткрываемогоФайла) Тогда
		Возврат;
	КонецЕсли;
	
	СписокРасширенийИзображений = СписокРасширенийИзображенийДляПредпросмотра();
	СписокРасширенийТекстовыхДокументов = СписокРасширенийТекстовыхФайловДляПредпросмотра();
	СписокРасширенийТабличныхДокументов = СписокРасширенийТабличныхФайловДляПредпросмотра();
	
	Если РасширениеТекущегоФайла = "pdf" Тогда
		ДокументПДФ.Напечатать();
	ИначеЕсли Не (СписокРасширенийТабличныхДокументов.НайтиПоЗначению(РасширениеТекущегоФайла) = Неопределено) Тогда
		Таблица.Напечатать();
	ИначеЕсли РасширениеТекущегоФайла = "grs" Тогда 
		ГрафическаяСхема.Напечатать();
	ИначеЕсли РасширениеТекущегоФайла = "geo" Тогда 
		ГеографическаяСхема.Напечатать();
	ИначеЕсли РасширениеТекущегоФайла = "htm" Или РасширениеТекущегоФайла = "html" Тогда
		Элементы.ТекстHTML.Документ.execCommand("Print");
	Иначе
		Если Не ЗначениеЗаполнено(ИмяОткрываемогоФайла) Тогда
			Возврат;
		КонецЕсли;
		ФайловаяСистемаКлиент.НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПисьмо(Команда)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипСобытия",
	ПолучитьТипСобытияПисьма());
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора",Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",Истина);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОбработкаВыбора = Новый ОписаниеОповещения("ПолучитьПисьмаДляВложения", ЭтаФорма);
	
	ОткрытьФорму("Документ.Событие.ФормаВыбора",ПараметрыФормы,
	ЭтаФорма, , , , ОбработкаВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВПисьме(Команда)
	
	СтруктураФайла = Новый Структура("Идентификатор, АдресВоВременномХранилище");
	
	Для каждого ЭлементКоллекции Из Элементы.Вложения.ВыделенныеСтроки Цикл
		Вложение = Элементы.Вложения.ДанныеСтроки(ЭлементКоллекции);
		ЗаполнитьЗначенияСвойств(СтруктураФайла, Вложение);
		СтруктураФайла.Вставить("ИмяФайла", Вложение.Представление);
	КонецЦикла;
	
	ДанныеПисьма = ПолучитьДанныеДляВложения(СтруктураФайла);
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСобытия", ДанныеПисьма.ТипСобытия);
	ЗначенияЗаполнения.Вставить("АдресВременногоХранилища", ДанныеПисьма.Адрес);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.Событие.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуФайла(Команда)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ТекущийИндексВКоллекции = Элементы.Вложения.ВыделенныеСтроки[0];
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ТекстПредупреждения = НСтр("ru='Файл еще не записан.
		|Работа с файлом возможна только после записи данных.
		|Файл будет записан.'");
		ДополнительныеПараметры = Новый Структура("ТекущийИндексВКоллекции", ТекущийИндексВКоллекции);
		ДополнительныеПараметры.Вставить("Событие", "ОткрытьКарточкуФайла");
		ПредложитьСохранитьФайл(ТекстПредупреждения, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	ОткрытьКарточкуЗаписанногоФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлИзОснования(Команда)
	
	ОткрытьФормуРаботыСОснованиями(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлВОсновании(Команда)
	
	Если Элементы.Вложения.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИндексВКоллекции = Элементы.Вложения.ВыделенныеСтроки[0];
	Если Не ЗначениеЗаполнено(Элементы.Вложения.ТекущиеДанные.Ссылка) Тогда
		ТекстПредупреждения = НСтр("ru='Файл еще не записан.
		|Работа с основанием возможна только после записи данных.
		|Файл будет записан.'");
		ДополнительныеПараметры = Новый Структура("ТекущийИндексВКоллекции", ТекущийИндексВКоллекции);
		ДополнительныеПараметры.Вставить("Событие", "ДобавитьФайлВОснование");
		ПредложитьСохранитьФайл(ТекстПредупреждения, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	ДобавитьЗаписанныйФайлВОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИндексВКоллекции = Вложения.Индекс(ТекущиеДанные);
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ДополнительныеПараметры = Новый Структура("ТекущийИндексВКоллекции", ТекущийИндексВКоллекции);
		ДополнительныеПараметры.Вставить("Событие", "РедактироватьВложение");
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОЗаписиФайлаПослеЗакрытия", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Свойства файла доступны только после его записи. Записать?'");
		ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		РедактироватьЗаписанныйФайл();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если Не ЗначениеЗаполнено(ДанныеФайла.Редактирует)
		Или ДанныеФайла.Редактирует <> ТекущийПользователь Тогда
			Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакончитьРедактированиеВыполненоПомещение", ЭтотОбъект);
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(
	ОписаниеОповещения,
	ДанныеФайла.Ссылка,
	УникальныйИдентификатор);
	
	ПараметрыОбновленияФайла.ХранитьВерсии = ДанныеФайла.ХранитьВерсии;
	ПараметрыОбновленияФайла.Вставить("СоздатьНовуюВерсию", Ложь);
	ПараметрыОбновленияФайла.ФайлРедактируетТекущийПользователь = ДанныеФайла.ФайлРедактируетТекущийПользователь;
	ПараметрыОбновленияФайла.Редактирует = ДанныеФайла.Редактирует;
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПоСобытию(Событие)
	
	МассивВложений = Документы.Событие.ВложенияСобытия(Событие, УникальныйИдентификатор);
	
	Для Каждого Вложение Из МассивВложений Цикл
		
		НовоеВложение = Вложения.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеВложение, Вложение);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	NULL КАК КонтактCRM,
		|	СобытиеДокументыОснования.ДокументОснование КАК ДокументОснование,
		|	Событие.НачалоСобытия КАК НачалоСобытия
		|ИЗ
		|	Документ.Событие.ДокументыОснования КАК СобытиеДокументыОснования
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Событие КАК Событие
		|		ПО СобытиеДокументыОснования.Ссылка = Событие.Ссылка
		|ГДЕ
		|	СобытиеДокументыОснования.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЕСТЬNULL(СвязиАдресатКонтактCRM.КонтактCRM, СобытиеУчастники.Контакт),
		|	NULL,
		|	NULL
		|ИЗ
		|	Документ.Событие.Участники КАК СобытиеУчастники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиАдресатКонтактCRM КАК СвязиАдресатКонтактCRM
		|		ПО СобытиеУчастники.Контакт = СвязиАдресатКонтактCRM.Адресат
		|ГДЕ
		|	СобытиеУчастники.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ДокументыОснования = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Контакты
		Если ЗначениеЗаполнено(Выборка.КонтактCRM) Тогда
			
			Значение = Новый Структура;
			Значение.Вставить("Дубли", Новый Массив);
			Значение.Вставить("КонтактCRM", Выборка.КонтактCRM);
			Значение.Вставить("ИндексКартинки", ЭлектроннаяПочтаУНФ.НомерКартинкиУчастникаПоТипуКонтакта(Значение.КонтактCRM));
			
			НовыйУчастник = УчастникиИДубли.Добавить(Значение);
			
		КонецЕсли;
		
		// Основания
		ДокументОснование = Выборка.ДокументОснование;
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			
			Если ДокументыОснования.НайтиПоЗначению(ДокументОснование) = Неопределено Тогда
				ДокументыОснования.Добавить(ДокументОснование);
			КонецЕсли;
			
		КонецЕсли;
		
		// Поля
		Если ЗначениеЗаполнено(Выборка.НачалоСобытия) Тогда
			
			РедактированиеРазрешено = (Выборка.НачалоСобытия = '00010101');
			
		КонецЕсли;
		
	КонецЦикла;
	
	Основание = ПоместитьВоВременноеХранилище(ДокументыОснования, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложение()
	
	Если Элементы.Вложения.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеВложение = Вложения.НайтиПоИдентификатору(Элементы.Вложения.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ВыбранноеВложение.Письмо) Тогда
		ПоказатьЗначение(, ВыбранноеВложение.Письмо);
		Возврат;
	КонецЕсли;
	
	Если РасширениеТекущегоФайла = "eml" Тогда
		ПараметрыФормы = ДанныеДляОткрытияПисьмаВложения(
		ВыбранноеВложение.АдресВоВременномХранилище,
		ВыбранноеВложение.Представление);
		
		ОткрытьФорму("Документ.Событие.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект, Истина);
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		ПолучитьФайл(ВыбранноеВложение.АдресВоВременномХранилище, ВыбранноеВложение.Представление, Истина);
	#Иначе
		ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ИмяВременнойПапки);
		
		ИмяВременногоФайла = 
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ВыбранноеВложение.Представление;
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ВыбранноеВложение.АдресВоВременномХранилище);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		Файл = Новый Файл(ИмяВременногоФайла);
		Файл.УстановитьТолькоЧтение(Истина);
		Если Файл.Расширение = ".mxl" Тогда
			ТабличныйДокумент = ТабличныйДокументИзВременногоФайла(ИмяВременногоФайла);
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("ИмяДокумента", ВыбранноеВложение.Представление);
			ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
			ПараметрыОткрытия.Вставить("ПутьКФайлу", ИмяВременногоФайла);
			ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Иначе
			ФайловаяСистемаКлиент.ОткрытьФайл(ИмяВременногоФайла);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФайлДляПредпросмотра()

	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	СсылкаНаДвоичныеДанныеФайла = ТекущиеДанные.АдресВоВременномХранилище;
	
	Если СсылкаНаДвоичныеДанныеФайла = "" Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьФайлДляОтображения(СсылкаНаДвоичныеДанныеФайла, ТекущиеДанные.Ссылка);
	ОбновитьВидимостьКомандРедактирования(Редактирует);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодировкаТекстаДляЧтения(КодировкаТекстаФайла)
	
	КодировкаТекстаДляЧтения = ?(ЗначениеЗаполнено(КодировкаТекстаФайла), КодировкаТекстаФайла, Неопределено);
	Если КодировкаТекстаДляЧтения = "utf-8_WithoutBOM" Тогда
		КодировкаТекстаДляЧтения = "utf-8";
	КонецЕсли;
	
	Возврат КодировкаТекстаДляЧтения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстовыйДокументИзВременногоФайла(ИмяВременногоФайла, Кодировка, Расширение = "")
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекстаДляЧтения(Кодировка));
	
	УстановленБезопасныйРежим = БезопасныйРежим();
	Если ТипЗнч(УстановленБезопасныйРежим) = Тип("Строка") Тогда
		УстановленБезопасныйРежим = Истина;
	КонецЕсли;
	
	Если Не УстановленБезопасныйРежим Тогда
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	
	Возврат ТекстовыйДокумент;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВременныйФайлИзДвоичныхДанных(ДвоичныеДанные, Знач Расширение = "")
	
	ВременныйФайл = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные.Записать(ВременныйФайл);
	Возврат ВременныйФайл;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеДляОткрытияПисьмаВложения(Знач АдресВоВременномХранилище, Знач Представление)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные.Записать(ВременныйФайл);
	
	ИнтернетПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
	ИнтернетПочтовоеСообщение.УстановитьИсходныеДанные(ДвоичныеДанные);
	
	ВложенияПисьма = Новый Массив;
	Для Каждого Вложение Из ИнтернетПочтовоеСообщение.Вложения Цикл
		СтруктураВложения = Новый Структура("Данные, Идентификатор, ИмяФайла, ТипСодержимого");
		ЗаполнитьЗначенияСвойств(СтруктураВложения, Вложение);
		СтруктураВложения.Вставить("ЭтоВложениеПисьмаВложения", Истина);
		Если ТипЗнч(СтруктураВложения.Данные) = Тип("ИнтернетПочтовоеСообщение") Тогда
			СтруктураВложения.Данные = СтруктураВложения.Данные.ПолучитьИсходныеДанные();
			СтруктураВложения.Вставить("ЭтоПисьмо", Истина);
		КонецЕсли;
		ВложенияПисьма.Добавить(СтруктураВложения);
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяДокумента", Представление);
	ПараметрыОткрытия.Вставить("ИнтернетПочтовоеСообщение", ДвоичныеДанные);
	ПараметрыОткрытия.Вставить("ПутьКФайлу", ВременныйФайл);
	ПараметрыОткрытия.Вставить("ТипСобытия", ПолучитьТипСобытияПисьма());
	ПараметрыОткрытия.Вставить("Вложения", ВложенияПисьма);
	ПараметрыОткрытия.Вставить("ЭтоОткрытиеСтороннегоВложенногоПисьма", Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия);
	ПараметрыФормы.Вставить("ЭтоОткрытиеПисьмаВложения", Истина);
	
	Возврат ПараметрыФормы;
КонецФункции

&НаСервереБезКонтекста
Функция ТабличныйДокументИзВременногоФайла(Знач ИмяФайла)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяФайла);
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипСобытияПисьма()
	
	Возврат Перечисления.ТипыСобытий.ЭлектронноеПисьмо;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор = Неопределено)
	
	ПараметрыДанныхФайла = Неопределено;
	Если УникальныйИдентификатор <> Неопределено Тогда
		ПараметрыДанныхФайла = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ПараметрыДанныхФайла.ИдентификаторФормы = УникальныйИдентификатор;
	КонецЕсли;
	
	Возврат РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(Ссылка,,ПараметрыДанныхФайла);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВложения(ДанныеСобытия)
	
	Если Не ДанныеСобытия.Свойство("Вложения") Тогда
		Возврат;
	КонецЕсли;
	
	ВложенияТЗ = Документы.Событие.ФорматированныеВложенияПослеЗагрузкиПисьма(
		ДанныеСобытия.Вложения, УникальныйИдентификатор);
	
	Для Каждого Вложение Из ВложенияТЗ Цикл
		
		НовоеВложениеНаФорме = Вложения.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеВложениеНаФорме, Вложение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеФайлаКВложениям()
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ДобавитьФайлВоВложенияПриПомещенииФайлов", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Истина;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВоВложения(ПомещенныеФайлы)
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		
		Файл = Новый Файл(ОписаниеФайла.Имя);
		ПозицияТочки = СтрНайти(Файл.Расширение, ".");
		РасширениеБезТочки = Сред(Файл.Расширение, ПозицияТочки + 1);
		
		Вложение = Вложения.Добавить();
		Вложение.Представление = Файл.Имя;
		Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
		ПолучитьИзВременногоХранилища(ОписаниеФайла.Хранение), УникальныйИдентификатор);
		Вложение.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(РасширениеБезТочки);
		Вложение.ЭтоВложениеЭлектронногоПисьма = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеДляВложения(СтруктураФайла)
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтруктураФайла.АдресВоВременномХранилище);
	
	Расширение = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(СтруктураФайла.ИмяФайла);
	Если Расширение = "eml" Тогда
		ИнтернетПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
		ИнтернетПочтовоеСообщение.ПолучитьИсходныеДанные(ДвоичныеДанные);
		ДвоичныеДанные = ИнтернетПочтовоеСообщение;
	КонецЕсли; 
	СтруктураФайла.Вставить("Данные", ДвоичныеДанные);
	
	МассивФайла = Новый Массив;
	МассивФайла.Добавить(СтруктураФайла);
	
	СтруктураВложений = Новый Структура;
	СтруктураВложений.Вставить("Вложения", МассивФайла);
	
	Адрес = ПоместитьВоВременноеХранилище(СтруктураВложений);
	
	СтруктураРезультата = Новый Структура("ТипСобытия, Адрес");
	СтруктураРезультата.ТипСобытия = Перечисления.ТипыСобытий.ЭлектронноеПисьмо;
	СтруктураРезультата.Адрес = Адрес;
	
	Возврат СтруктураРезультата;
КонецФункции

&НаСервере
Функция АдресВложенийВХранилище()
	
	ТаблицаЗначений = РеквизитФормыВЗначение("Вложения", Тип("ТаблицаЗначений"));
	Адрес = ПоместитьВоВременноеХранилище(ТаблицаЗначений, УникальныйИдентификатор);
	Возврат Адрес;
	
КонецФункции 

&НаКлиенте
Процедура РедактироватьЗаписанныйФайл()
	
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	ДанныеФайла = ПолучитьДанныеФайла(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
	Если (ЗначениеЗаполнено(ДанныеФайла.Редактирует) И НЕ ДанныеФайла.ФайлРедактируетТекущийПользователь)
		ИЛИ ДанныеФайла.Зашифрован
		ИЛИ ДанныеФайла.ПодписанЭП Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.РедактироватьСОповещением(Неопределено, ТекущиеДанные.Ссылка);
	ОбновитьВидимостьКомандРедактирования(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьСохранитьФайл(ТекстПредупреждения, ДополнительныеПараметры = Неопределено)
	
	ВопросОЗаписиФайлаПослеЗакрытия = Новый ОписаниеОповещения("ВопросОЗаписиФайлаПослеЗакрытия", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(ВопросОЗаписиФайлаПослеЗакрытия, ТекстПредупреждения, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаписанныйФайлВОснование()
	
	ВыбранныеПрисоединенныеФайлы = Новый Массив;
	Для каждого ИдентификаторСтроки Из Элементы.Вложения.ВыделенныеСтроки Цикл
		СтрокаТаблицы = Вложения.НайтиПоИдентификатору(ИдентификаторСтроки);
		ВыбранныеПрисоединенныеФайлы.Добавить(СтрокаТаблицы.Ссылка);
	КонецЦикла;
	
	ОткрытьФормуРаботыСОснованиями(Ложь, ВыбранныеПрисоединенныеФайлы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуЗаписанногоФайла()
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", Элементы.Вложения.ТекущиеДанные.Ссылка);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФайлДляОтображения(Знач СсылкаНаДвоичныеДанные, Знач СсылкаНаФайл)
	
	Если ЗначениеЗаполнено(СсылкаНаФайл) Тогда
		ДанныеФайла = ПолучитьДанныеФайла(СсылкаНаФайл, УникальныйИдентификатор);
		Редактирует = ЗначениеЗаполнено(ДанныеФайла.Редактирует);
	КонецЕсли;
	
	Если СсылкаНаДвоичныеДанные = "" Тогда 
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(СсылкаНаДвоичныеДанные);
	ВременныйФайл = ВременныйФайлИзДвоичныхДанных(ДвоичныеДанные, РасширениеТекущегоФайла);
	ИмяОткрываемогоФайла = ВременныйФайл;
	
	Если ТипФайла = "Неподдерживаемый" Тогда
		Возврат;
	ИначеЕсли ТипФайла = "Изображение" Тогда
		Картинка = СсылкаНаДвоичныеДанные;
	ИначеЕсли ТипФайла = "Таблица" Тогда
		Таблица = ТабличныйДокументИзВременногоФайла(ВременныйФайл);
	ИначеЕсли ТипФайла = "Текстовый" Тогда
		КодировкаТекстаФайла = КодировкаТекстовогоФайла(ДвоичныеДанные, РасширениеТекущегоФайла);
		Текст = ТекстовыйДокументИзВременногоФайла(ВременныйФайл, КодировкаТекстаФайла, РасширениеТекущегоФайла);
	ИначеЕсли ТипФайла = "ГрафическаяСхема" Тогда
		ГрафическаяСхема.Прочитать(ВременныйФайл);
	ИначеЕсли ТипФайла = "ГеографическаяСхема" Тогда
		ГеографическаяСхема.Прочитать(ВременныйФайл);
	ИначеЕсли ТипФайла = "PDF" Тогда
		ДокументПДФ.Прочитать(ВременныйФайл,);
	ИначеЕсли ТипФайла = "Html" Тогда
		ЧтениеТекста = Новый ЧтениеТекста(ВременныйФайл);
		ТекстHtm = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		
		ТекстHtmНРег = НРег(ТекстHtm);
		
		Если СтрНайти(ТекстHtmНРег, "charset=utf-8") <> 0 
			Или СтрНайти(ТекстHtmНРег, "charset=""utf-8""") <> 0 Тогда
			ЧтениеТекста = Новый ЧтениеТекста(ВременныйФайл, "UTF-8");
			ТекстHtm = ЧтениеТекста.Прочитать();
			ЧтениеТекста.Закрыть();
		КонецЕсли;
		
		Если СтрЧислоВхождений(ТекстHtm, "<html") = 0 Тогда
			ТекстHtm= СтрШаблон("<html>%1</html>", ТекстHtm);
		КонецЕсли;
		
		ТекстHTML = ТекстHtm;
		
	КонецЕсли;
	
	ФайловаяСистема.УдалитьВременныйФайл(ВременныйФайл);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРаботыСОснованиями(ВыборФайла, ВыбранныеПрисоединенныеФайлы = Неопределено)
	
	МассивУчастников = УчастникиИДубли.ВыгрузитьЗначения();
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВыборФайлов", ВыборФайла);
	ПараметрыОткрытия.Вставить("Основания", ПолучитьИзВременногоХранилища(Основание));
	ПараметрыОткрытия.Вставить("Ссылка", Ссылка);
	ПараметрыОткрытия.Вставить("Участники", МассивУчастников);
	
	Если ВыборФайла Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайловОснований", ЭтотОбъект);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлыПослеВыбораОснования", ЭтотОбъект, ВыбранныеПрисоединенныеФайлы);
	КонецЕсли;
	ОткрытьФорму("Документ.Событие.Форма.ФормаЕдиногоВыбораФайла",ПараметрыОткрытия, ЭтаФорма, , , ,
	ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПрисоединенныеФайлыВСписок(АдресФайлаВХранилище)
	
	ВыбранныеПрисоединенныеФайлы = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	
	Для каждого ПрисоединенныйФайл Из ВыбранныеПрисоединенныеФайлы Цикл
		ПараметрыДанныхФайла = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ПараметрыДанныхФайла = УникальныйИдентификатор;
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл.Ссылка, ПараметрыДанныхФайла);
		
		Вложение = Вложения.Добавить();
		Вложение.Представление = ДанныеФайла.ИмяФайла;
		Вложение.АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
		Вложение.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ДанныеФайла.Расширение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПрисоединенныйФайлИзВложенийВОбъекте(ВладелецФайлов, ВыбранныеПрисоединенныеФайлы)
	
	Для каждого ВыбранныйПрисоединенныйФайл Из ВыбранныеПрисоединенныеФайлы Цикл
		ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ДополнительныеПараметры.ИдентификаторФормы = УникальныйИдентификатор;
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ВыбранныйПрисоединенныйФайл, ДополнительныеПараметры);
		
		ПараметрыДобавления = РаботаСФайлами.ПараметрыДобавленияФайла();
		ПараметрыДобавления.ВладелецФайлов = ВладелецФайлов;
		ПараметрыДобавления.ИмяБезРасширения = ДанныеФайла.ИмяФайла;
		ПараметрыДобавления.РасширениеБезТочки = ДанныеФайла.Расширение;
		ПараметрыДобавления.ВремяИзмененияУниверсальное = ДанныеФайла.ДатаМодификацииУниверсальная;
		РаботаСФайлами.ДобавитьФайл(ПараметрыДобавления, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СсылкаЗаписанногоФайла(АдресВХранилище, ИмяФайла)
	
	ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайла);
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("Автор", Пользователи.ТекущийПользователь());
	ПараметрыФайла.Вставить("ВладелецФайлов", Ссылка);
	ПараметрыФайла.Вставить("ИмяБезРасширения", ПолноеИмяФайла.ИмяБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки", ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ПолноеИмяФайла.Расширение));
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяУниверсальнаяДата());
	ПрисоединенныйФайлСсылка = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресВХранилище);
	Возврат ПрисоединенныйФайлСсылка;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРасширениеИмениФайла(Знач ИмяФайла)
	
	РасширениеФайла = "";
	МассивСтрок = СтрРазделить(ИмяФайла, ".", Ложь);
	Если МассивСтрок.Количество() > 1 Тогда
		РасширениеФайла = МассивСтрок[МассивСтрок.Количество() - 1];
	КонецЕсли;
	Возврат РасширениеФайла;
	
КонецФункции

&НаКлиенте
Функция СписокРасширенийИзображенийДляПредпросмотра()
	
	РасширенияДляПредпросмотра = Новый СписокЗначений;
	РасширенияДляПредпросмотра.Добавить("bmp");
	РасширенияДляПредпросмотра.Добавить("ico");
	РасширенияДляПредпросмотра.Добавить("jpg");
	РасширенияДляПредпросмотра.Добавить("jpeg");
	РасширенияДляПредпросмотра.Добавить("png");
	РасширенияДляПредпросмотра.Добавить("svg");
	РасширенияДляПредпросмотра.Добавить("gif");
	
	#Если НЕ ВебКлиент Тогда
		РасширенияДляПредпросмотра.Добавить("tiff");
		РасширенияДляПредпросмотра.Добавить("tif");
		РасширенияДляПредпросмотра.Добавить("wmf");
		РасширенияДляПредпросмотра.Добавить("emf");
	#КонецЕсли
	
	Возврат РасширенияДляПредпросмотра;
	
КонецФункции

&НаКлиенте
Функция СписокРасширенийТекстовыхФайловДляПредпросмотра()
	
	РасширенияДляПредпросмотра = Новый СписокЗначений;
	РасширенияДляПредпросмотра.Добавить("txt");
	РасширенияДляПредпросмотра.Добавить("ini");
	РасширенияДляПредпросмотра.Добавить("xml");
	
	Возврат РасширенияДляПредпросмотра;
	
КонецФункции

&НаКлиенте
Функция СписокРасширенийТабличныхФайловДляПредпросмотра()
	
	РасширенияДляПредпросмотра = Новый СписокЗначений;
	РасширенияДляПредпросмотра.Добавить("mxl");
	
	Возврат РасширенияДляПредпросмотра;
	
КонецФункции

&НаСервере
// Определяет кодировку текстового файла.
//
// Параметры:
//  ДвоичныеДанные - Строка - двоичные данные текстового файла.
//  Расширение     - Строка - расширение файла .
//
// Возвращаемое значение:
//   Строка - кодировка файла.
//
Функция КодировкаТекстовогоФайла(ДвоичныеДанные, Расширение)
	
	Кодировка = "";
	
	ОбщиеНастройки = РаботаСФайламиСлужебныйПовтИсп.НастройкиРаботыСФайлами().ОбщиеНастройки;
	АвтоопределениеКодировки = РаботаСФайламиСлужебныйКлиентСервер.РасширениеФайлаВСписке(
	ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, Расширение);
	Если Не АвтоопределениеКодировки Тогда
		Возврат Кодировка;
	КонецЕсли;
	
	Если ДвоичныеДанные <> Неопределено Тогда
		Кодировка = РаботаСФайламиСлужебныйКлиентСервер.ОпределитьКодировкуДвоичныхДанных(ДвоичныеДанные, Расширение);
	КонецЕсли;
	
	Возврат Кодировка;
КонецФункции

&НаСервере
Процедура ЗаполнитьВложенияПолученнымиПисьмами(Письма)
	
	МассивДанных = ЭлектроннаяПочтаУНФ.ИнтернетПочтовыеСообщенияПисем(Письма);
	СтруктураВложений = Новый Структура;
	СтруктураВложений.Вставить("Вложения", МассивДанных);
	ЗаполнитьВложения(СтруктураВложений);
	
КонецПроцедуры

#Область ОбработкаОповещений

&НаКлиенте
Процедура ВопросОЗаписиФайлаПослеЗакрытия(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущиеДанные = Вложения.Получить(ДополнительныеПараметры.ТекущийИндексВКоллекции);
		Если ТекущиеДанные <> Неопределено Тогда
			ИмяФайла = ТекущиеДанные.Представление;
		Иначе
			Возврат;
		КонецЕсли;
		
		СсылкаНаФайл = СсылкаЗаписанногоФайла(ТекущиеДанные.АдресВоВременномХранилище, ИмяФайла);
		ТекущиеДанные.Ссылка = СсылкаНаФайл;
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Представление", ИмяФайла);
		
		НайденныеСтроки = Вложения.НайтиСтроки(ПараметрыПоиска);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			ИдентификаторСтроки = Вложения.Индекс(НайденныеСтроки[0]);
			Элементы.Вложения.ТекущаяСтрока = ИдентификаторСтроки;
			ДополнительныеПараметры.ТекущийИндексВКоллекции = ИдентификаторСтроки;
		Иначе
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Событие = "РедактироватьВложение" Тогда
		РедактироватьЗаписанныйФайл();
	ИначеЕсли ДополнительныеПараметры.Событие = "ДобавитьФайлВОснование" Тогда
		ДобавитьЗаписанныйФайлВОснование();
	ИначеЕсли ДополнительныеПараметры.Событие = "ОткрытьКарточкуФайла" Тогда
		ОткрытьКарточкуЗаписанногоФайла();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВоВложенияПриПомещенииФайлов(ПомещенныеФайлы, Параметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьФайлыВоВложения(ПомещенныеФайлы);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайловОснований(АдресФайлаВХранилище, ДополнительныеПараметры) Экспорт
	
	Если АдресФайлаВХранилище = Неопределено Или Не ЭтоАдресВременногоХранилища(АдресФайлаВХранилище)Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПрисоединенныеФайлыВСписок(АдресФайлаВХранилище);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлыПослеВыбораОснования(ВыбранныйДокумент, ВыбранныеПрисоединенныеФайлы) Экспорт
	
	Если ВыбранныйДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьПрисоединенныйФайлИзВложенийВОбъекте(ВыбранныйДокумент.Значение, ВыбранныеПрисоединенныеФайлы);
	
	Если ВыбранныеПрисоединенныеФайлы.Количество() = 1 Тогда
		ТекстОповещения = НСтр("ru='Сохранение файла'");
	Иначе
		ТекстОповещения = НСтр("ru='Сохранение файлов'");
	КонецЕсли;
	ПоказатьОповещениеПользователя(
	ТекстОповещения,
	ПолучитьНавигационнуюСсылку(ВыбранныйДокумент.Значение),
	Строка(ВыбранныйДокумент.Значение));
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПисьмаДляВложения(Письма, ДопПараметры) Экспорт
	
	Если Письма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьВложенияПолученнымиПисьмами(Письма);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактированиеВыполненоПомещение(ИнформацияОФайле, ДополнительныеПараметры) Экспорт
	
	СсылкаНаТекущийОбъект = Элементы.Вложения.ТекущиеДанные.Ссылка;
	ОповеститьОбИзменении(СсылкаНаТекущийОбъект);
	Оповестить("Запись_Файл", Новый Структура, СсылкаНаТекущийОбъект);
	ОбновитьВидимостьКомандРедактирования(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПрограммаLinuxУстановленаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПроцедуры = СтрНайти(Результат.ПотокВывода, "Status: install ok installed") <> Ложь;
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, РезультатПроцедуры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область НастройкаВидимостьЭлементовФормы

&НаКлиенте
Процедура ПоказатьФайл()
	
	СписокРасширенийИзображений = СписокРасширенийИзображенийДляПредпросмотра();
	СписокРасширенийТекстовыхДокументов = СписокРасширенийТекстовыхФайловДляПредпросмотра();
	СписокРасширенийТабличныхДокументов = СписокРасширенийТабличныхФайловДляПредпросмотра();
	
	Если Не (СписокРасширенийИзображений.НайтиПоЗначению(РасширениеТекущегоФайла) = Неопределено) Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаКартинка;
		ТипФайла = "Изображение";
	ИначеЕсли Не (СписокРасширенийТабличныхДокументов.НайтиПоЗначению(РасширениеТекущегоФайла) = Неопределено) Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаТаблица;
		Элементы.ГруппаКомандПросмотраТаблицы.Видимость = Истина;
		ТипФайла = "Таблица";
	ИначеЕсли Не (СписокРасширенийТекстовыхДокументов.НайтиПоЗначению(РасширениеТекущегоФайла) = Неопределено) Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаТекст;
		ТипФайла = "Текстовый";
	ИначеЕсли РасширениеТекущегоФайла = "grs" Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаГрафическаяСхема;
		ТипФайла = "ГрафическаяСхема";
	ИначеЕсли РасширениеТекущегоФайла = "geo" Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаГеографическаяСхема;
		ТипФайла = "ГеографическаяСхема";
	ИначеЕсли РасширениеТекущегоФайла = "htm" Или РасширениеТекущегоФайла = "html" Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаHTML;
		ТипФайла = "Html";
	ИначеЕсли РасширениеТекущегоФайла = "pdf" Тогда
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаPDF;
		Элементы.ГруппаКомандыПросмотраПДФ.Видимость = Истина;
		ТипФайла = "PDF";
	Иначе
		Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаПредупреждение;
		ТипФайла = "Неподдерживаемый";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПредпросмотр();
	Элементы.ГруппаКомандыПросмотраПДФ.Видимость = Ложь;
	Элементы.ГруппаКомандПросмотраТаблицы.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКомандыИПросмотр()
	
	Элементы.ВложенияКонтекстноеМенюДобавить.Видимость = РедактированиеРазрешено;
	Элементы.ВложенияКонтекстноеМенюДобавитьПисьмо.Видимость = РедактированиеРазрешено;
	Элементы.ВложенияКонтекстноеМенюПереместитьВверх.Видимость = РедактированиеРазрешено;
	Элементы.ВложенияКонтекстноеМенюПереместитьВниз.Видимость = РедактированиеРазрешено;
	Элементы.Добавить.Видимость = РедактированиеРазрешено;
	Элементы.ДобавитьПисьмо.Видимость = РедактированиеРазрешено;
	Элементы.ФормаРедактировать.Видимость = РедактированиеРазрешено;
	Элементы.ВложенияКонтекстноеМенюУдалить.Видимость = РедактированиеРазрешено;
	
	Записано = ЗначениеЗаполнено(Ссылка);
	Элементы.СохранитьФайлВОсновании.Видимость = Записано;
	Элементы.ВложенияКонтекстноеМенюСохранитьФайлВОсновании.Видимость = Записано;
	Элементы.ДобавитьФайлИзОснования.Видимость = Записано И РедактированиеРазрешено;
	Элементы.ВложенияКонтекстноеМенюДобавитьФайлИзОснования.Видимость = Записано И РедактированиеРазрешено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьКомандРедактирования(Редактирует);
	
	Если РедактированиеРазрешено Тогда
		Элементы.ФормаРедактировать.Видимость = Не Редактирует;
		Элементы.ФормаЗакончитьРедактирование.Видимость = Редактирует;
	Иначе
		Элементы.ФормаРедактировать.Видимость = Ложь;
		Элементы.ФормаЗакончитьРедактирование.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти