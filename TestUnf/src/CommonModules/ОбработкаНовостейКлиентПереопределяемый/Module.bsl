///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейКлиентПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработкаСобытий

// В процедуре могут прописываться специфичные для этой конфигурации вызовы процедур и функций,
//  соответственно новости с помощью гиперссылок могут запускать эти процедуры / функции.
// Из обработчика ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки для действия "Запуск процедуры с параметрами"
//  вызывается этот метод со списком значений параметров.
// Состав значений параметров - произвольный.
//
// Параметры:
//  НовостьСсылка    - СправочникСсылка.Новости - Ссылка на новость;
//  Форма            - ФормаКлиентскогоПриложения - Форма-владелец, откуда вызывается обработчик;
//  СписокПараметров - СписокЗначений - произвольный список параметров.
//
// Пример:
//	Если ТипЗнч(СписокПараметров) = Тип("СписокЗначений") Тогда
//		НайденноеДействие = ОбработкаНовостейКлиент.НайтиЭлементСпискаЗначений(
//			СписокПараметров,
//			Новый Структура("ВариантПоиска, ЗначениеПоиска",
//				"ПоПредставлениюБезУчетаРегистра",
//				"Действие"));
//		Если НайденноеДействие <> Неопределено Тогда
//			Если НайденноеДействие.Значение = "ОткрытьОбработку" Тогда
//				ОткрываемаяФорма = ОбработкаНовостейКлиент.НайтиЭлементСпискаЗначений(
//					СписокПараметров,
//					Новый Структура("ВариантПоиска, ЗначениеПоиска",
//						"ПоПредставлениюБезУчетаРегистра",
//						"ИмяФормы"));
//				Если ОткрываемаяФорма <> Неопределено Тогда
//					ОткрытьФорму(ОткрываемаяФорма);
//				КонецЕсли;
//			ИначеЕсли НайденноеДействие.Значение = "Предупреждение" Тогда
//				Текст = ОбработкаНовостейКлиент.НайтиЭлементСпискаЗначений(
//					СписокПараметров,
//					Новый Структура("ВариантПоиска, ЗначениеПоиска",
//						"ПоПредставлениюБезУчетаРегистра",
//						"Текст"));
//				Если Текст <> Неопределено Тогда
//					Предупреждение(
//						Текст,
//						0,
//						НСтр("ru='Информация'"));
//				КонецЕсли;
//			Иначе
//				// Другие действия
//			КонецЕсли;
//		КонецЕсли;
//	КонецЕсли;
//
//@skip-warning
Процедура ОбработкаСобытия(НовостьСсылка, Форма, СписокПараметров) Экспорт

	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ВариантПоиска", "ПоПредставлениюБезУчетаРегистра");
	ПараметрыПоиска.Вставить("ЗначениеПоиска", "Действие");
	
	НайденноеДействие = ОбработкаНовостейКлиент.НайтиЭлементСпискаЗначений(СписокПараметров, ПараметрыПоиска);
	
	Если НайденноеДействие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НайденноеДействие.Значение = "ПодключитьЭДО" Тогда
		
		Если УправлениеНебольшойФирмойВызовСервера.ПолучитьФункциональнуюОпциюСервер("ИспользоватьОбменЭД") Тогда
			
			Если УправлениеДоступомУНФКлиентПовтИсп.ЕстьПравоНастройкиЭДО() Тогда
				ОбменСКонтрагентамиКлиент.ПомощникПодключенияКСервису1СЭДО();
			Иначе
				ТекстПредупреждения = НСтр("ru='Недостаточно прав для настройки обмена электронными документами. Обратитесь к администратору.'");
				ПоказатьПредупреждение(,ТекстПредупреждения);
			КонецЕсли;
			
		ИначеЕсли ОбработкаНовостейУНФВызовСервера.ЭтоПолноправныйПользователь() Тогда
			
			ОткрытьФорму("Обработка.ПанельАдминистрированияБЭД.Форма.ОбщиеНастройки");
			
		Иначе
			
			ТекстПредупреждения = НСтр("ru='Для включения возможности обмена электронными документами с контрагентами обратитесь к администратору.'");
			ПоказатьПредупреждение(,ТекстПредупреждения);
			
		КонецЕсли;
		
	ИначеЕсли НайденноеДействие.Значение = "Отписаться" Тогда
		
		Результат = ОбработкаНовостейУНФВызовСервера.ОтписатьсяОтЛентыНовостей(НовостьСсылка);
		Если Результат.Успешно Тогда
			ПоказатьОповещениеПользователя(
			НСтр("ru='Отказ получения новостей'"),
			,
			СтрШаблон(НСтр("ru='Лента новостей ""%1"" отключена'"), Результат.ПредставлениеЛентыНовостей),
			БиблиотекаКартинок.Информация32);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// В процедуре могут прописываться специфичные для этой конфигурации обработчики нажатия в тексте новости.
//
// Параметры:
//  Новости       - ДанныеФормыСтруктура, СправочникСсылка.Новости, ДокументСсылка.Новости, СписокЗначений - Новость,
//                   в которой произошло нажатие.
//                  Если передано значение типа СписокЗначений (где Значение - СправочникСсылка.Новости,
//                  ДокументСсылка.Новости, а представление - УИННовости), то определить,
//                   к какой новости относится это нажатие;
//  ДанныеСобытия - COMОбъект - описатель события нажатия;
//  Форма         - ФормаКлиентскогоПриложения - форма, в которой произошло нажатие;
//  ЭлементФормы  - ЭлементыФормы - Элементы формы типа ПолеHTMLдокумента;
//  СтандартнаяОбработкаПлатформой  - Булево - признак выполнения стандартной обработки нажатия платформой;
//  СтандартнаяОбработкаПодсистемой - Булево - признак выполнения стандартной обработки подсистемой.
//
//@skip-warning
Процедура ОбработкаНажатияВТекстеНовости(
			Новости,
			ДанныеСобытия,
			Форма,
			ЭлементФормы,
			СтандартнаяОбработкаПлатформой,
			СтандартнаяОбработкаПодсистемой) Экспорт

КонецПроцедуры

#КонецОбласти

#Область КонтекстныеНовости

// Переопределяет надписи всплывающего сообщения при попытке открытия формы контекстных новостей,
//  но если контекстных новостей нет.
//
// Параметры:
//  Форма              - ФормаКлиентскогоПриложения - форма, из которой происходит показ оповещения пользователю;
//  ТекстСообщения     - Строка - заголовок оповещения пользователю, если установить в пустую строку, то сообщение выводиться не будет;
//  ПояснениеСообщения - Строка - пояснение оповещения пользователю;
//  Отказ              - Булево - установить в Ложь, чтобы форма контекстных новостей открылась.
//
//@skip-warning
Процедура ПереопределитьНадписиСообщенияПриОтсутствииКонтекстныхНовостей(Форма, ТекстСообщения, ПояснениеСообщения, Отказ) Экспорт

КонецПроцедуры

// Переопределяет структуру параметров открытия формы контекстных новостей.
// Можно установить произвольные настройки открытия формы списка контекстных новостей, например скрыть колонку "Подзаголовок" и т.п.
// Если настройки не меняются - можно вызвать из модуля с повторным использованием.
//
// Параметры:
//  ПараметрыОткрытия - Структура - Структура с параметрами открытия, до обработки. Возможны ключи:
//    * ЗаголовокФормы                - Строка - заголовок формы контекстных новостей;
//    * СкрыватьКолонкуЛентаНовостей  - Булево - Истина, если надо скрыть колонку "ЛентаНовостей";
//    * СкрыватьКолонкуПодзаголовок   - Булево - Истина, если надо скрыть колонку "Подзаголовок";
//    * СкрыватьКолонкуДатаПубликации - Булево - Истина, если надо скрыть колонку "ДатаПубликации";
//    * ПоказыватьПанельНавигации     - Булево - Истина, если надо показать гиперссылку перехода к списку всех новостей;
//    * РежимОткрытияОкна             - Строка - режим открытия окна ("Независимый", "БлокироватьОкноВладельца" (по-умолчанию),
//                                                "БлокироватьВесьИнтерфейс");
//    * ИнициаторОткрытияНовости      - Строка - описание места (форма, событие), откуда открывается новость.
//
//@skip-warning
Процедура ПереопределитьПараметрыОткрытияФормыКонтекстныхНовостей(ПараметрыОткрытия) Экспорт


КонецПроцедуры

// Обрабатывает нажатие кнопки, принадлежащей механизму контекстных новостей.
// Вызывается после выполнения стандартных команд (показ формы списка контекстных новостей,
//  открытие новости из подменю контекстных новостей).
//  Можно прописать обработку нестандартных событий. Например, в кнопку "Новости" можно добавить две команды:
//   "Команда_Новость_Список_БыстроеОсвоение" и "Команда_Новость_Список_БазаЗнаний" и на нажатие этих
//    кнопок вызывать форму списка контекстных новостей, но отфильтрованную по определенным лентам новостей, например:
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать нажатие на кнопку механизма контекстных новостей;
//  Команда - КомандаФормы - вызванная команда.
//
// Пример:
//	СписокЛент_БыстроеОсвоение = МойМодуль.ПолучитьСписокЛентНовостей_БыстроеОсвоение(); // Необходимо самостоятельно написать эту функцию!
//	СписокЛент_БазаЗнаний      = МойМодуль.ПолучитьСписокЛентНовостей_БазаЗнаний(); // Необходимо самостоятельно написать эту функцию!
//	Если Команда.Имя = "Команда_Новость_Список_БыстроеОсвоение" Тогда
//	ПоказатьКонтекстныеНовости(
//		Форма, // ФормаВладелец
//		СписокЛент_БыстроеОсвоение, // СписокЛентНовостей
//		Форма.Новости.Метаданные, // ИмяМетаданных
//		, // ИмяФормы = По всем
//		, // ИмяСобытия = По всем
//		ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыКонтекстныхНовостей(
//			Новый Структура("ЗаголовокФормы, СкрыватьКолонкуЛентаНовостей, СкрыватьКолонкуПодзаголовок, СкрыватьКолонкуДатаПубликации, ПоказыватьПанельНавигации, РежимОткрытияОкна",
//				Форма.Новости.ЗаголовокФормыКонтекстныхНовостей, // ЗаголовокФормы
//				Истина, // СкрыватьКолонкуЛентаНовостей
//				Ложь, // СкрыватьКолонкуПодзаголовок
//				Ложь, // СкрыватьКолонкуДатаПубликации
//				Ложь, // ПоказыватьПанельНавигации
//				"БлокироватьОкноВладельца" // РежимОткрытияОкна ("Независимый", "БлокироватьОкноВладельца" (по-умолчанию), "БлокироватьВесьИнтерфейс")
//			)
//		) // ПараметрыОткрытия
//	);
//	ИначеЕсли Команда.Имя = "Команда_Новость_Список_БазаЗнаний" Тогда
//	ПоказатьКонтекстныеНовости(
//		Форма, // ФормаВладелец
//		СписокЛент_БазаЗнаний, // СписокЛентНовостей
//		Форма.Новости.Метаданные, // ИмяМетаданных
//		, // ИмяФормы = По всем
//		, // ИмяСобытия = По всем
//		ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыКонтекстныхНовостей(
//			Новый Структура("ЗаголовокФормы, СкрыватьКолонкуЛентаНовостей, СкрыватьКолонкуПодзаголовок, СкрыватьКолонкуДатаПубликации, ПоказыватьПанельНавигации, РежимОткрытияОкна",
//				Форма.Новости.ЗаголовокФормыКонтекстныхНовостей, // ЗаголовокФормы
//				Истина, // СкрыватьКолонкуЛентаНовостей
//				Ложь, // СкрыватьКолонкуПодзаголовок
//				Ложь, // СкрыватьКолонкуДатаПубликации
//				Ложь, // ПоказыватьПанельНавигации
//				"БлокироватьОкноВладельца" // РежимОткрытияОкна ("Независимый", "БлокироватьОкноВладельца" (по-умолчанию), "БлокироватьВесьИнтерфейс")
//			)
//		) // ПараметрыОткрытия
//	);
//	КонецЕсли;
//
//@skip-warning
Процедура КонтекстныеНовости_ОбработкаКомандыНовости(Форма, Команда) Экспорт


КонецПроцедуры

// Обрабатывает оповещение, приходящее в форму через обработчик ОбработкаОповещения.
// Можно прописать обработку нестандартных оповещений или нестандартные действия.
// Например, при поступлении события "Новости. Новость прочтена" можно в каком-то
//  элементе управления изменить счетчик непрочитанных новостей.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать оповещение;
//  ИмяСобытия   - Произвольный - данные обработчика оповещения;
//  Параметр     - Произвольный - данные обработчика оповещения;
//  Источник     - Произвольный - данные обработчика оповещения.
//
//@skip-warning
Процедура КонтекстныеНовости_ОбработкаОповещения(
			Форма,
			ИмяСобытия,
			Параметр,
			Источник) Экспорт

КонецПроцедуры

// Вызывается при открытии формы с контекстными новостями, перед выполнением стандартной обработки.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать событие ПриОткрытии;
//  СтандартнаяОбработка - Булево - если установить в Ложь, то стандартная обработка, а также
//                                  вызов КонтекстныеНовости_ПриОткрытии_ПослеСтандартнойОбработки выполняться не будут.
//
//@skip-warning
Процедура КонтекстныеНовости_ПриОткрытии_ПередСтандартнойОбработкой(Форма, СтандартнаяОбработка = Истина) Экспорт

КонецПроцедуры

// Вызывается при открытии формы с контекстными новостями, после выполнения стандартной обработки.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать событие ПриОткрытии.
//
//@skip-warning
Процедура КонтекстныеНовости_ПриОткрытии_ПослеСтандартнойОбработки(Форма) Экспорт

КонецПроцедуры

// Вызывается из подключаемой процедуры показа контекстных новостей для отображения важных
//  и очень важных новостей при открытии формы.
//
// Параметры:
//  Форма                            - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать событие ПриОткрытии;
//  ИдентификаторыСобытийПриОткрытии - Строка, Массив из Строка - идентификаторы событий, по которым необходимо отбирать контекстные новости;
//  СтандартнаяОбработка             - Булево - если установить в Ложь, то стандартная обработка, а также
//                                     вызов КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии_ПослеСтандартнойОбработки
//                                     выполняться не будут.
//
//@skip-warning
Процедура КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии_ПередСтандартнойОбработкой(
			Форма,
			ИдентификаторыСобытийПриОткрытии,
			СтандартнаяОбработка = Истина) Экспорт

КонецПроцедуры

// Вызывается из подключаемой процедуры показа контекстных новостей для отображения важных
//  и очень важных новостей при открытии формы.
//
// Параметры:
//  Форма                            - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать событие ПриОткрытии;
//  ИдентификаторыСобытийПриОткрытии - Строка, Массив из Строка - идентификаторы событий, по которым необходимо отбирать контекстные новости.
//
//@skip-warning
Процедура КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии_ПослеСтандартнойОбработки(
			Форма,
			ИдентификаторыСобытийПриОткрытии) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ПанельКонтекстныхНовостей

// Метод обрабатывает нажатие на элементах управления в элементе ПанельКонтекстныхНовостей.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать событие Нажатие;
//  Элемент              - ЭлементУправления - элемент управления, на котором произвели нажатие мышкой.
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
//
//@skip-warning
Процедура ПанельКонтекстныхНовостей_ЭлементПанелиНовостейНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Метод обрабатывает переход по навигационным ссылкам в элементе ПанельКонтекстныхНовостей.
//
// Параметры:
//  Форма                           - ФормаКлиентскогоПриложения - форма, в которой необходимо обработать событие Нажатие;
//  Элемент                         - ЭлементУправления - элемент управления, на котором произвели нажатие мышкой;
//  НавигационнаяСсылкаЭлемента     - Строка - навигационная ссылка;
//  СтандартнаяОбработкаПлатформой  - Булево - признак выполнения стандартной обработки навигационной ссылки платформой;
//  СтандартнаяОбработкаПодсистемой - Булево - признак выполнения стандартной обработки подсистемой.
//
//@skip-warning
Процедура ПанельКонтекстныхНовостей_ЭлементПанелиНовостейОбработкаНавигационнойСсылки(
			Форма,
			Элемент,
			НавигационнаяСсылкаЭлемента,
			СтандартнаяОбработкаПлатформой,
			СтандартнаяОбработкаПодсистемой) Экспорт

КонецПроцедуры

// Переопределяет основные параметры обработчиков панели контекстных новостей.
//
// Параметры:
//  Результат - Структура - структура с ключами:
//    * ИнтервалАвтолистанияСекунд - Число - частота автолистания, 10..999 секунд. По-умолчанию - 15;
//    * ПаузаАвтолистанияПриРучнойПеремоткеСекунд - Число - пауза перед возобновлением автолистания,
//                если пользователь вручную переключился на другую новость, 10..999 секунд. По-умолчанию - 60 секунд;
//    * ВыключениеАнимированнойИконкиСекунд - Число - время, через которое анимированная иконка
//                станет статичной, 10...999 секунд. По-умолчанию - 30 секунд.
//
//@skip-warning
Процедура ПанельКонтекстныхНовостей_ПараметрыОбработчиков(Результат) Экспорт

КонецПроцедуры

#КонецОбласти

#Область НастройкиНовостей

// Вызывается из формы пользовательских настроек новостей (Хранилища настроек / НастройкиНовостей / ФормаНастройкиПоказаНовостей)
//  после нажатия на кнопку ОК.
// Если в переопределяемых модулях с повторно используемыми значениями используется, например,
//   список лент новостей (с учетом отключенных пользователем), то после нажатия на ОК надо сбросить повторно используемые значения:
// ОбновитьПовторноИспользуемыеЗначения();
// Метод не вызывается при записи настроек видимости лент новостей из других форм, например, из формы новости.
//
// Параметры:
//  СохраненныеНастройки - Структура - структура уже сохраненных настроек с ключами:
//    * ОтборыПоЛентамНовостейПользовательские - Соответствие - данные по отборам;
//    * ОтключенныеЛентыНовостей               - Массив - список отключенных лент новостей;
//    * НастройкиПоказаНовостей                - Структура - данные по настройкам показа новостей;
//    * СпособыОповещений                      - Соответствие - способы оповещений по лентам новостей;
//  Отказ                - Булево - Если установить в Истина, то форма настроек не будет закрыта.
//                                  В таком случае необходимо также вывести сообщение пользователю, почему форма не может быть закрыта.
//
//@skip-warning
Процедура ПослеЗаписиПользовательскихНастроек(СохраненныеНастройки, Отказ) Экспорт

КонецПроцедуры

// Переопределяет время в секундах, после которого необходимо после старта программы показать важные и очень важные новости.
// По-умолчанию это время = 2 секунды.
// Если переопределить на значение = 0, то при старте программы важные и очень важные новости
//  не будут показаны (но будут показаны после интервала обновления новостей);
// Это значение может быть переопределено параметром запуска /C"ОтложитьПоказНовостей=ХХ;", где ХХ - число секунд,
//  на которое необходимо отложить показ новостей (если ХХ не в интервале от 2 до 999, то этот параметр запуска
//  будет округлен до крайних значений интервала).
//
// Параметры:
//  ИнтервалСекунд - Число - интервал в секундах, после которого (при старте программы) необходимо показать важные и очень важные новости.
//
//@skip-warning
Процедура ПереопределитьВремяПервогоПоказаВажныхИОченьВажныхНовостейПриСтартеПрограммы(ИнтервалСекунд) Экспорт

	ОбработкаНовостейУНФКлиент.ПереопределитьВремяПервогоПоказаВажныхИОченьВажныхНовостейПриСтартеПрограммы(
		ИнтервалСекунд);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеФорм

// Переопределяет имя и параметры открытия формы списка новостей.
// Можно задать другое имя формы, например
//	ИмяФормы = "ОбщиеФормы.НоваяФормаСпискаНовостей";
// Можно задать другие параметры открытия формы, например:
//	ПараметрыОткрытия.Вставить("ЗаголовокФормы", "Все новости");
//
// Параметры:
//  ИмяФормы           - Строка - имя формы по-умолчанию;
//  ПараметрыОткрытия  - Структура - структура параметров открытия формы, по умолчанию в ней могут быть ключи:
//    * ЗаголовокФормы - Строка - новый заголовок формы;
//  ПараметрКоманды    - Произвольный - Параметры, которые были переданы в команду показа списка новостей ("Справочник.Новости.Команда*");
//  ПараметрыВыполненияКоманды - Структура - Параметры, которые были переданы в команду показа списка новостей ("Справочник.Новости.Команда*").
//
//@skip-warning
Процедура ПереопределитьПараметрыОткрытияФормыСпискаНовостей(
			ИмяФормы,
			ПараметрыОткрытия,
			ПараметрКоманды = Неопределено,
			ПараметрыВыполненияКоманды = Неопределено) Экспорт

КонецПроцедуры

// Переопределяет имя и параметры открытия формы списка контекстных новости.
// Можно задать другое имя формы, например
//	ИмяФормы = "ОбщиеФормы.НоваяФормаСпискаКонтекстныхНовостей";
// Можно задать другие параметры открытия формы, например:
//	ПараметрыОткрытия.Вставить("ПоказыватьПанельНавигации", Истина);
//
// Параметры:
//  ИмяФормы          - Строка - имя формы по-умолчанию;
//  ПараметрыОткрытия - Структура - структура параметров открытия формы, по умолчанию в ней могут быть ключи:
//    * РежимОткрытияОкна         - Строка - или "БлокироватьОкноВладельца", или любое другое значение
//                                            (которое будет воспринято как "Независимое");
//    * ПоказыватьПанельНавигации - Булево - Истина, если надо показать гиперссылку перехода к списку всех новостей;
//    * ИнициаторОткрытияНовости  - Строка - описание места (форма, событие), откуда открывается новость.
//
//@skip-warning
Процедура ПереопределитьПараметрыОткрытияФормыСпискаКонтекстныхНовостей(ИмяФормы, ПараметрыОткрытия) Экспорт

КонецПроцедуры

// Переопределяет имя и параметры открытия формы единственной новости.
// Можно задать другое имя формы, например
//	ИмяФормы = "ОбщиеФормы.НоваяФормаНовости";
// Можно задать другие параметры открытия формы, например:
//	ПараметрыОткрытия.Вставить("ПоказыватьПанельНавигации", Истина);
//
// Параметры:
//  ИмяФормы          - Строка - имя формы по-умолчанию;
//  ПараметрыОткрытия - Структура - структура параметров открытия формы, по умолчанию в ней могут быть ключи:
//    * ИнициаторОткрытияНовости  - Строка - (только чтение) описание места (форма, событие),
//                                            откуда открывается новость;
//    * НовостьНаименование       - Строка - (только чтение) заголовок новости;
//    * НовостьКодЛентыНовостей   - Строка - (только чтение) код ленты новостей;
//    * ИдентификаторМеста        - Строка - (только чтение) идентификатор якоря ("<a id=ИдентификаторМеста>"),
//                                            к которому необходимо переместиться после открытия новости;
//    * РежимОткрытияОкна         - Строка - или "БлокироватьОкноВладельца", или любое другое значение
//                                            (которое будет воспринято как "Независимое");
//    * ПоказыватьПанельНавигации - Булево - Истина, если надо показать гиперссылку перехода к списку всех новостей;
//    * ПоказыватьКнопкиЗакрытия  - Булево - Истина, если надо вместо галочки "Напоминать об этой новости" (ОповещениеВключено)
//                                            использовать кнопки "Больше не показывать" и "Показать позже".
//
//@skip-warning
Процедура ПереопределитьПараметрыОткрытияФормыНовости(ИмяФормы, ПараметрыОткрытия) Экспорт


КонецПроцедуры

// Переопределяет имя и параметры открытия формы очень важных контекстных новостей.
// Можно задать другое имя формы, например
//	ИмяФормы = "ОбщиеФормы.НоваяФормаСпискаОченьВажныхКонтекстныхНовостей";
//
// Можно задать другое имя формы, в зависимости от параметров открытия, например если хотим открыть только одну новость
//  в окне для показа одной новости, а не в форме просмотра списка новостей:
// Если ТипЗнч(ПараметрыОткрытия) = Тип("Структура") Тогда
//	Если (ПараметрыОткрытия.Свойство("СписокНовостей") = Истина)
//			И (ТипЗнч(ПараметрыОткрытия.СписокНовостей) = Тип("СписокЗначений"))
//			И (ПараметрыОткрытия.СписокНовостей.Количество() = 1) Тогда
//		ПараметрыОткрытия.Вставить("Ключ", ПараметрыОткрытия.СписокНовостей[0].Значение);
//		ИмяФормы = "Справочник.Новости.Форма.ФормаНовости";
//	ИначеЕсли (ПараметрыОткрытия.Свойство("АдресМассиваНовостей") = Истина)
//			И (ТипЗнч(ПараметрыОткрытия.АдресМассиваНовостей) = Тип("Строка")) Тогда
//		// Вызов серверного кода для проверки - одна новость или несколько, затратен
//		// Если новости находятся на сервере, то тогда всегда открываем форму по-умолчанию
//	КонецЕсли;
// КонецЕсли;
//
// Параметры:
//  ИмяФормы          - Строка - имя формы по-умолчанию;
//  ПараметрыОткрытия - Структура - структура параметров открытия формы, по умолчанию в ней могут быть ключи:
//    * РежимОткрытияОкна                     - Строка - или "БлокироватьОкноВладельца", или любое другое значение
//                                                        (которое будет воспринято как "Независимое");
//    * Заголовок                             - Строка - Заголовок окна;
//    * СписокНовостей                        - СписокЗначений - список новостей (если передан, то параметры АдресМассиваНовостей,
//                                                       ИдентификаторФормы, ИдентификаторыСобытий) можно не проверять;
//    * АдресМассиваНовостей                  - Строка - Адрес хранилища новостей (массив структур) - в случае,
//                                                       если новости не хранятся в реквизите формы;
//    * ИдентификаторФормы                    - Строка - идентификатор формы, в случае, если новости не хранятся в реквизите формы;
//    * ИдентификаторыСобытий                 - Строка - идентификатор события, в случае, если новости не хранятся в реквизите формы;
//    * Ключ                                  - СправочникСсылка.Новости - в случае, если будет открываться форма единственной новости;
//    * ВремяПереносаПоказатьПозжеМинут       - Число - Время (в минутах), на которое новости из списка становятся неважными
//                                                       и не отображаются при повторном открытии формы-владельца;
//    * СкрыватьСписокНовостейДляОднойНовости - Булево - Если = ИСТИНА и в СписокНовостей всего 1 новость, то список новостей
//                                                       (слева в форме контекстных новостей) не будет отображаться.
//
//@skip-warning
Процедура ПереопределитьПараметрыОткрытияФормыСпискаОченьВажныхКонтекстныхНовостей(ИмяФормы, ПараметрыОткрытия) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ИнтерактивныеДействия

// Выполняет интерактивное действие, которое невозможно выполнить на сервере - оповещения и т.п.
//
// Параметры:
//  Действие - Произвольный - параметр произвольного типа.
//
//@skip-warning
Процедура ВыполнитьИнтерактивноеДействие(Действие) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ОбработкаОповещений

// Обработчик оповещения в формах показа новостей.
// Как правило, используется для интерактивной обработки представления новости в случае срабатывания действий новости типа "Оповещение".
//
// Параметры:
//  ИмяСобытия           - Строка - произвольные параметры;
//  Параметр             - СписокЗначений - произвольные параметры;
//  Источник             - СписокЗначений - произвольные параметры;
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой произошло оповещение;
//  ДокументыHTML        - Массив из COMОбъект, Массив из ВнешнийОбъект - массив объектов типа COMОбъект или ВнешнийОбъект
//                           (свойство "Документ" расширения поля формы для поля HTML документа);
//  СтандартнаяОбработка - Булево - если установить в Ложь, то стандартная обработка выполняться не будет.
//
//@skip-warning
Процедура ПросмотрНовости_ОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма, ДокументыHTML, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ФункциональныеОпции

// Метод переопределяет, можно ли работать с новостями текущему пользователю.
//
// Параметры:
//  Результат - Булево - входящее значение - библиотечное значение разрешения работы с новостями,
//                       исходящее значение - переопределенное значение разрешения работы с новостями.
//
//@skip-warning
Процедура РазрешенаРаботаСНовостямиТекущемуПользователю(Результат) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ВажныеИОченьВажныеГлобальныеНовости

// Метод показывает глобальные важные и очень важные новости пользователю.
//
// Параметры:
//  ОченьВажныеНовости - Массив из Структура - массив структур, в который будут возвращены новости с важностью "Очень важная", где:
//    * Новость                        - СправочникСсылка.Новости - ссылка на новость;
//    * НовостьУникальныйИдентификатор - УникальныйИдентификатор - УИН от ссылки на новость;
//    * НовостьНаименование            - Строка - заголовок новости;
//    * НовостьПодзаголовок            - Строка - подзаголовок новости;
//    * НовостьКодЛентыНовостей        - Строка - код ленты новостей;
//    * ОповещениеВключено             - Булево - Признак, что оповещение включено;
//    * ИконкаНовости                  - Неопределено - всегда Неопределено.
//  ВажныеНовости      - Массив из Структура - массив структур, в который будут возвращены новости с важностью "Важная", где:
//    * Новость                        - СправочникСсылка.Новости - ссылка на новость;
//    * НовостьУникальныйИдентификатор - УникальныйИдентификатор - УИН от ссылки на новость;
//    * НавигационнаяСсылка            - Строка - навигационная ссылка на новость;
//    * НовостьНаименование            - Строка - заголовок новости;
//    * НовостьПодзаголовок            - Строка - подзаголовок новости;
//    * НовостьКодЛентыНовостей        - Строка - код ленты новостей;
//    * ОповещениеВключено             - Булево - Признак, что оповещение включено;
//    * ИконкаНовости                  - Картинка, Неопределено - иконка новости для оповещения пользователю;
//  ДополнительныеПараметры - Произвольный - произвольные параметры;
//  СтандартнаяОбработка    - Булево - признак выполнения стандартной обработки.
//
//@skip-warning
Процедура ПоказатьВажныеНовостиСВключеннымиНапоминаниями(
			ОченьВажныеНовости,
			ВажныеНовости,
			ДополнительныеПараметры,
			СтандартнаяОбработка) Экспорт


КонецПроцедуры

#КонецОбласти

#Область УстаревшийФункционал

// Устаревший функционал.
// Начиная с 8.3.10.2168 все важные новости просто выводятся в цикле, и сама платформа отображает их пачками по 3 штуки.
// Подробности: https://wonderland.v8.1c.ru/blog/mekhanizm-opoveshcheniy-polzovatelya-i-tsentr-opoveshcheniy/.
// Метод переопределяет время в секундах между показами важных новостей.
// По-умолчанию это время = 7 секунд.
// Возможные значения - в интервале 1..30 секунд.
// Механизм последовательного показа новостей необходим для замены стандартного платформенного механизма вызова
//  в цикле ПоказатьОповещениеПользователю, при котором показывается только последнее оповещение, а предыдущие остаются
//  только в окне истории.
//
// Параметры:
//  ИнтервалСекунд - Число - интервал в секундах между показами каждой следующей важной новости.
//
//@skip-warning
Процедура ПереопределитьИнтервалПоказаВажныхНовостей(ИнтервалСекунд) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

