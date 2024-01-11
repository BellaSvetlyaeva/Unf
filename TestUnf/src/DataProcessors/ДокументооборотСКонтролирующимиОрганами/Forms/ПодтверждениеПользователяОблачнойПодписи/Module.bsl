///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаймАут 				= Параметры.ТаймАут;
	ТекстВопроса 			= Параметры.ТекстВопроса;
	Заголовок 				= Параметры.Заголовок;
	СписокКоманд 			= Параметры.СписокКоманд;
	ПовторнаяОтправкаКода 	= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПовторнаяОтправкаКода", Ложь);
	ИдентификаторСубъекта 	= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ИдентификаторСубъекта", "");
	ПодписьКодаАктивации 	= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПодписьКодаАктивации", "");
	КартинкиДиалога			= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "КартинкиДиалога", "ДиалогИнформация");
	РежимДиалога			= Истина;
	РедактированиеТаблицы 	= Ложь;
	
	ТекущаяВысота 	= Элементы.ТабДок.Высота;
	ТекущаяШирина	= Элементы.ТабДок.Ширина;
	Если Параметры.ТабДок.ВысотаТаблицы > 0 Тогда
		ТабДок = Параметры.ТабДок;
		РежимДиалога = Ложь;
		Если НЕ Параметры.Свойство("Редактирование", РедактированиеТаблицы) Тогда
			РедактированиеТаблицы = Ложь;
		КонецЕсли;
		ТекущаяВысота = Макс(ТекущаяВысота, ТабДок.ВысотаТаблицы);
		ТекущаяВысота = Мин(ТекущаяВысота, 30);
		ТекущаяШирина = Макс(ТекущаяШирина, Параметры.ШиринаТаблицы);
		ТекущаяШирина = Мин(ТекущаяШирина, 125);
		Элементы.ТабДок.Высота = ТекущаяВысота;
		Элементы.ТабДок.Ширина = ТекущаяШирина;
	КонецЕсли;
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Вопрос'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокПодтверждения) Тогда
		Элементы.РежимПодтверждения.Заголовок = Параметры.ЗаголовокПодтверждения;
	Иначе
		Элементы.РежимПодтверждения.Видимость = Ложь;
	КонецЕсли;
	
	Для Счетчик = 1 По СписокКоманд.Количество() Цикл
		ИмяКоманды = "КомандаПользователя" + Формат(Счетчик, "ЧЦ=10; ЧГ=0");
		СтрокаКоманды = СписокКоманд[Счетчик - 1];
		НоваяСтрока = ТаблицаКоманд.Добавить();
		НоваяСтрока.ЗначениеКоманды = СтрокаКоманды.Значение;
		НоваяСтрока.ИмяКоманды = ИмяКоманды;
		НоваяСтрока.Заголовок = СтрокаКоманды.Представление;
		НоваяСтрока.Картинка = СтрокаКоманды.Картинка;
		НоваяСтрока.Пометка = СтрокаКоманды.Пометка;
	КонецЦикла;
	
	Если Параметры.СписокФайлов <> Неопределено Тогда
		
		Для Каждого СтрокаМассива Из Параметры.СписокФайлов Цикл
			НоваяСтрока = СписокФайлов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаМассива);
			Если НЕ ЗначениеЗаполнено(НоваяСтрока.АдресФайла) Тогда
				НоваяСтрока.АдресФайла = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ГруппаОтображение.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	ПодготовитьФормуВопроса();
	НастроитьВидимостьЭлементов(РедактированиеТаблицы);
	
	КлючСохраненияПоложенияОкна = "НастройкиФормы";
	Если РежимДиалога Тогда
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "_РежимДиалога";
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "_" + XMLСтрока(СтрЧислоСтрок(ТекстВопроса));
	Иначе
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "_" + XMLСтрока(ТекущаяВысота);
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "_" + XMLСтрока(ТекущаяШирина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПредставлениеОписания();
	ПроверитьДоступностьКоманд();
	
	ПодключитьОбработчикОжидания("Подключаемый_ИзменитьРазмерыФормы", 0.2, Истина);
	
	Если ЗначениеЗаполнено(ТаймАут) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", ТаймАут, Истина);
	КонецЕсли;
	
	Если Элементы.РежимПодтверждения.Видимость Тогда
		ТекущийЭлемент = Элементы.РежимПодтверждения;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
										
&НаКлиенте
Процедура ПодтверждениеПриИзменении(Элемент)
	
	ПроверитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОписаниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущийФайл = НайтиТекущийФайл(НавигационнаяСсылкаФорматированнойСтроки);
	
	Если ТекущийФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "_Выбрать") > 0 Тогда
		ВыратьФайлСкана(ТекущийФайл);
	ИначеЕсли СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "_Удалить") > 0 Тогда
		УдалитьФайлСкана(ТекущийФайл);
	ИначеЕсли СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "_Выбран") > 0 Тогда
		ФайловаяСистемаКлиент.ОткрытьФайл(ТекущийФайл.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытьФорму(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ТабДок.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторитьОтправкуКода(Команда)
	
	Если НЕ ПовторнаяОтправкаКодаСервер() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось запросить повторный код.'"));
	Иначе
		СчетчикОтсчета = 30;
		Элементы.ПовторитьОтправкуКода.Доступность = Ложь;
		Элементы.ПовторитьОтправкуКода.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		ПодключитьОбработчикОжидания("Подключаемый_ПовторитьОтправкуКода", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДокумент(Команда)
	
	СохранитьТабличныйДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьВидимостьЭлементов(РедактированиеТаблицы)
	
	Элементы.Продолжить.Видимость = ТаблицаКоманд.Количество() = 0 И НЕ РежимДиалога;
	Элементы.ПовторитьОтправкуКода.Видимость = ТаблицаКоманд.Количество() = 0 И ПовторнаяОтправкаКода;
	Элементы.ГруппаОтображение.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Элементы.ДекорацияКартинкаОписания.Видимость = НЕ Элементы.ДекорацияКартинкаОписания.Картинка.Вид = ВидКартинки.Пустая;
	Элементы.ДекорацияКартинка.Видимость = НЕ Элементы.ДекорацияКартинка.Картинка.Вид = ВидКартинки.Пустая;
	Элементы.ГруппаОтобразитьОписание.Видимость = ЗначениеЗаполнено(ТекстВопроса) И НЕ РежимДиалога;
	
	Если РежимДиалога Тогда
		Элементы.ТабДок.Видимость = Ложь;
		Элементы.ГруппаОтображение.ТекущаяСтраница = Элементы.ГруппаОписание;
		
	Иначе
		Элементы.ГруппаОтображение.ТекущаяСтраница = Элементы.ГруппаПечатнаяОбласть;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуВопроса()
	
	ЕстьПодтверждение = Элементы.РежимПодтверждения.Видимость ИЛИ СписокФайлов.Количество() > 0;
	Элементы.ДекорацияКартинка.Картинка = ПолучитьРесурсФормы(КартинкиДиалога);
	
	Если РежимДиалога Тогда
		Элементы.ДекорацияИнформация.Заголовок = ТекстВопроса;
	КонецЕсли;
	
	ПервыйЭлемент = Неопределено;
	
	Для Счетчик = 1 По ТаблицаКоманд.Количество() Цикл
		СтрокаКоманды = ТаблицаКоманд[Счетчик - 1];
		ИмяКоманды = СтрокаКоманды.ИмяКоманды;
		
		НоваяКоманда = Команды.Добавить(ИмяКоманды);
		НоваяКоманда.Действие = "Подключаемый_НажатиеКнопки"; 
		НоваяКоманда.Заголовок = СтрокаКоманды.Заголовок;
		Если ЗначениеЗаполнено(СтрокаКоманды.Картинка) Тогда
			НоваяКоманда.Картинка = СтрокаКоманды.Картинка;
		КонецЕсли;
		
		НовыйЭлемент = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ГруппаКомандыФормы);
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
		
		Если ЕстьПодтверждение И СтрокаКоманды.Пометка Тогда
			НовыйЭлемент.Доступность = Ложь;
		КонецЕсли;
		
		Если ПервыйЭлемент = Неопределено ИЛИ СтрокаКоманды.Пометка Тогда
			ПервыйЭлемент = НовыйЭлемент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПервыйЭлемент <> Неопределено Тогда
		ПервыйЭлемент.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРесурсФормы(ИмяРесурса)
	
	Результат = Новый Картинка();
	НашлиРесурс = Новый Структура(ИмяРесурса);
	
	Попытка
		ЗаполнитьЗначенияСвойств(НашлиРесурс, БиблиотекаКартинок);
	Исключение
		НашлиРесурс.Вставить(ИмяРесурса, Неопределено);
	КонецПопытки;
	
	Если НашлиРесурс[ИмяРесурса] <> Неопределено Тогда
		Результат = НашлиРесурс[ИмяРесурса];
	КонецЕсли;
		
	Возврат Результат;  
	
КонецФункции
	
&НаКлиенте
Процедура Подключаемый_НажатиеКнопки(Команда)
	
	НашлиСтроки = ТаблицаКоманд.НайтиСтроки(Новый Структура("ИмяКоманды", Команда.Имя));
	Если НашлиСтроки.Количество() > 0 Тогда
		ЗначениеКоманды = НашлиСтроки[0].ЗначениеКоманды;
		Если ТипЗнч(ЗначениеКоманды) = Тип("Строка") И СтрНайти(ЗначениеКоманды, "КодВозвратаДиалога.") > 0 Тогда
			ЗначениеКоманды = КодВозвратаДиалога[Сред(ЗначениеКоманды, 20)];
		КонецЕсли;
		
		Если СписокФайлов.Количество() > 0 Тогда
			Результат = Новый Структура;
			Результат.Вставить("Команда", ЗначениеКоманды);
			
			ВсеФайлы = Новый Массив;
			Для Каждого СтрокаТаблицы Из СписокФайлов Цикл
				НоваяСтрока = Новый Структура;
				НоваяСтрока.Вставить("Имя", СтрокаТаблицы.ИмяФайла);
				НоваяСтрока.Вставить("Выбран", СтрокаТаблицы.Выбран);
				НоваяСтрока.Вставить("АдресФайла", СтрокаТаблицы.АдресФайла);
				ВсеФайлы.Добавить(НоваяСтрока);
			КонецЦикла;
			Результат.Вставить("СписокФайлов", ВсеФайлы);
		Иначе
			Результат = ЗначениеКоманды;
		КонецЕсли;
		
		ЗакрытьФорму(Результат);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИзменитьРазмерыФормы()
	
	Элементы.ГруппаКомандыФормы.Видимость = НЕ Элементы.ГруппаКомандыФормы.Видимость;
	Элементы.ГруппаОтображение.Видимость = НЕ Элементы.ГруппаОтображение.Видимость;
	
	Элементы.ГруппаКомандыФормы.Видимость = НЕ Элементы.ГруппаКомандыФормы.Видимость;
	Элементы.ГруппаОтображение.Видимость = НЕ Элементы.ГруппаОтображение.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	ЗакрытьФорму(КодВозвратаДиалога.Таймаут);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(РезультатВыбора = "")
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПовторитьОтправкуКода()
	
	СчетчикОтсчета = СчетчикОтсчета - 1;
	
	Если СчетчикОтсчета > 0 Тогда
		Элементы.ПовторитьОтправкуКода.РасширеннаяПодсказка.Заголовок = 
					СтрШаблон(НСтр("ru = 'Повторить можно через %1 сек.'"), Формат(СчетчикОтсчета, "ЧН=; ЧГ=0"));

		ПодключитьОбработчикОжидания("Подключаемый_ПовторитьОтправкуКода", 1, Истина);
	Иначе
		Элементы.ПовторитьОтправкуКода.Доступность = Истина;
		Элементы.ПовторитьОтправкуКода.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПовторнаяОтправкаКодаСервер()
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("ПодписьКодаАктивации", ПодписьКодаАктивации);
	ПараметрыОперации.Вставить("ИдентификаторСубъекта", ИдентификаторСубъекта);
	
	МодульЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Результат = МодульЭДО.ОбменССерверомОтправитьКодАктивацииКлюча(ПараметрыОперации);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СохранитьТабличныйДокументСервер(ВФормате)

	ФайлТабличногоДокумента = ПолучитьИмяВременногоФайла();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Вывести(ТабДок);
	ТабличныйДокумент.Автомасштаб = Истина;
	ТабличныйДокумент.Записать(ФайлТабличногоДокумента, ВФормате);
	ДанныеФайла = Новый ДвоичныеДанные(ФайлТабличногоДокумента);

	Адрес = ПоместитьВоВременноеХранилище(ДанныеФайла, УникальныйИдентификатор);

	Возврат Адрес;
	
КонецФункции

&НаКлиенте
Процедура СохранитьТабличныйДокумент()
	
	Шаблон = "Файл в формате (*.pdf)|*.pdf|Таблица (*.xlsx)|*.xlsx";
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок = "Сохранение документа";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.ПредварительныйПросмотр = Истина;
	Диалог.Фильтр = Шаблон;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьТабличныйДокументЗавершение", ЭтотОбъект); 
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, Диалог);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТабличныйДокументЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено ИЛИ РезультатВыбора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = РезультатВыбора[0];
	СвойстваФайла = Новый Файл(ИмяФайла);
	РасширениеФайла = ?(НРег(СвойстваФайла.Расширение) = ".pdf", ТипФайлаТабличногоДокумента.PDF, ТипФайлаТабличногоДокумента.XLSX);
	
	ФайловаяСистемаКлиент.СохранитьФайл(
			Неопределено, 
			СохранитьТабличныйДокументСервер(РасширениеФайла),
			ИмяФайла,
			Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОписания()
	
	Если РежимДиалога Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОписания = ТекстВопроса;
	
	Для Каждого СтрокаТаблицы Из СписокФайлов Цикл
		ТекущийИдентификатор = "<" + СтрокаТаблицы.Идентификатор + ">";
		Если СтрокаТаблицы.Выбран Тогда
			НовоеЗначение = "<a href=""" + СтрокаТаблицы.Идентификатор + "_Выбран"">" + СтрокаТаблицы.ИмяФайла + "</a>"
							+ " <a href=""" + СтрокаТаблицы.Идентификатор + "_Удалить"">" 
							+ "" + "<img src=""ОчиститьЗначениеМини"">";
		Иначе
			НовоеЗначение = "<a href=""" + СтрокаТаблицы.Идентификатор + "_Выбрать"" style=""color: ЦветОшибкиПроверкиБРО"">" 
							+ СтрокаТаблицы.Представление + "</a>";
		КонецЕсли;
		ТекстОписания = СтрЗаменить(ТекстОписания, ТекущийИдентификатор, НовоеЗначение);
	КонецЦикла;
	
	Результат = СтроковыеФункцииКлиент.ФорматированнаяСтрока(ТекстОписания);
	Элементы.ДекорацияОписание.Заголовок = Результат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступностьКоманд()
	
	ВыбраныФайлы = Ложь;
	Если СписокФайлов.Количество() > 0 Тогда
		НашлиСтроки = СписокФайлов.НайтиСтроки(Новый Структура("Выбран", Истина));
		ДоступныКоманды = СписокФайлов.Количество() = НашлиСтроки.Количество() ИЛИ Подтверждение;
	ИначеЕсли НЕ Элементы.РежимПодтверждения.Видимость Тогда
		ДоступныКоманды = Истина;
	Иначе
		ДоступныКоманды = Подтверждение;
	КонецЕсли;
	
	Для Каждого СтрокаСписка Из ТаблицаКоманд Цикл
		
		Если СтрокаСписка.Пометка Тогда
			ЭлементКоманды = Элементы[СтрокаСписка.ИмяКоманды];
			ЭлементКоманды.Доступность = ДоступныКоманды;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция НайтиТекущийФайл(ТекстСсылки)
	
	Результат = Неопределено;
	
	Для Каждого СтрокаТаблицы Из СписокФайлов Цикл
		Если СтрНачинаетсяС(ТекстСсылки, СтрокаТаблицы.Идентификатор + "_") Тогда
			Результат = СтрокаТаблицы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УдалитьФайлСкана(ТекущийФайл)
	
	ТекущийФайл.Выбран = Ложь;
	ТекущийФайл.ИмяФайла = "";
	ПоместитьВоВременноеХранилище(Неопределено, ТекущийФайл.АдресФайла);
	
	ПредставлениеОписания();
	ПроверитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыратьФайлСкана(ТекущийФайл)
	
	ПараметрыЦикла = Новый Структура;
	ПараметрыЦикла.Вставить("ТекущийФайл", ТекущийФайл);
	
	МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
	
	ОписаниеСледующее = Новый ОписаниеОповещения("ВыратьФайлСканаЗавершение", ЭтотОбъект, ПараметрыЦикла);
	МодульСервисКриптографииDSSКлиент.ЗагрузитьДанныеИзФайла(ОписаниеСледующее, "", ТекущийФайл.АдресФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыратьФайлСканаЗавершение(РезультатВыбора, ПараметрыЦикла) Экспорт
	
	Если НЕ РезультатВыбора.Выполнено Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка загрузки файла'");
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС
						+ РезультатВыбора.Ошибка;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	Иначе
		ОписаниеФайла = Новый Структура();
		ОписаниеФайла.Вставить("Имя",    РезультатВыбора.Результат.ИмяФайла);
		ОписаниеФайла.Вставить("Адрес",  ПараметрыЦикла.ТекущийФайл.АдресФайла);
		ОписаниеФайла.Вставить("Размер", 0);
		
		ОписаниеФайлов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОписаниеФайла);

		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыратьФайлСканаКонвертация", 
			ЭтотОбъект, 
			ПараметрыЦикла);
			
		Требования = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ТребованияКИзображениямВЗаявленииПо1СОтчетности();
		
		ОперацииСФайламиЭДКОКлиент.ОбработатьКартинки(ОписаниеОповещения, ОписаниеФайлов, Требования, УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыратьФайлСканаКонвертация(РезультатВыбора, ПараметрыЦикла) Экспорт
	
	Если НЕ РезультатВыбора.Выполнено Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка конвертации файла'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Для каждого ОписаниеФайла Из РезультатВыбора.ОписанияФайлов Цикл
	    Имя   = ОписаниеФайла.Имя;
		Адрес = ОписаниеФайла.Адрес;
	КонецЦикла;
	
	МаксимальныйРазмерФайла = 10 * 1024 * 1024;
	ДопустимыеТипыФайлов    = "png;jpeg;jpg;tiff;tif;pdf";
	ФайлыДокумента = ОбработкаЗаявленийАбонентаКлиентСервер.ОписаниеФайла(Имя, Адрес);
	
	ТекстОшибки    = ОперацииСФайламиЭДКОСлужебныйКлиент.ТекстОшибкиДобавленияОдногоФайла(
		ФайлыДокумента, 
		МаксимальныйРазмерФайла, 
		ДопустимыеТипыФайлов);
	
	Если ПустаяСтрока(ТекстОшибки) Тогда
		ОписаниеФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Имя);
		ПараметрыЦикла.ТекущийФайл.Выбран = Истина;
		ПараметрыЦикла.ТекущийФайл.ИмяФайла = ОписаниеФайла.Имя;
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
	ПредставлениеОписания();
	ПроверитьДоступностьКоманд();
	
КонецПроцедуры

#КонецОбласти
