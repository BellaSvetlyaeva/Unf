#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Приложение = Параметры.Приложение;
	Если Не ЗначениеЗаполнено(Приложение) Тогда
		Возврат;
	КонецЕсли;
	УстановитьТекстыЗапросов();
	
	ПоказыватьПозиции = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура");
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокОшибокЗаполненияИнтеграцияУправлениеПерсоналом" Тогда
		ОбновитьСписки();
	ИначеЕсли ИмяСобытия = "ИзмененаПубликуемаяСтруктураКомпании" Тогда 
		ОбновитьЭлементыФормы();
		ОбновитьСписки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьЗаполнениеОбъектов(Команда)
	НачатьПроверкуЗаполнения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекстыЗапросов()

	МенеджерТипОбъекта = Перечисления.ТипыОбъектовИнтеграцияУправлениеПерсоналом;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ТекстЗапроса = Позиции.ТекстЗапроса;
	СтрокаПоиска = "Справочник.ШтатноеРасписание КАК ШтатноеРасписание"; 
	Если Приложение = Перечисления.ПриложенияДляИнтеграции.УправлениеПерсоналом Тогда
		СтрокаЗамены = "
		|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
		|		ПО ШтатноеРасписание.Ссылка = ВыгружаемыеОбъекты.Ссылка";
	Иначе
		СтрокаЗамены = "
		|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъектыКабинетСотрудника КАК ВыгружаемыеОбъекты
		|		ПО ШтатноеРасписание.Ссылка = ВыгружаемыеОбъекты.Ссылка";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,СтрокаПоиска,СтрокаЗамены);
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Позиции, СвойстваСписка);
	Позиции.Параметры.УстановитьЗначениеПараметра("ТипОбъекта", МенеджерТипОбъекта.ДолжностьПоШтатномуРасписанию);
	Позиции.Параметры.УстановитьЗначениеПараметра("Приложение", Приложение);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ТекстЗапроса = Сотрудники.ТекстЗапроса;
	СтрокаПоиска = "Справочник.Сотрудники КАК СправочникСотрудники"; 
	Если Приложение = Перечисления.ПриложенияДляИнтеграции.УправлениеПерсоналом Тогда
		СтрокаЗамены = "
		|	Справочник.Сотрудники КАК СправочникСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
		|		ПО СправочникСотрудники.Ссылка = ВыгружаемыеОбъекты.Ссылка";
	Иначе
		СтрокаЗамены = "
		|	Справочник.Сотрудники КАК СправочникСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъектыКабинетСотрудника КАК ВыгружаемыеОбъекты
		|		ПО СправочникСотрудники.Ссылка = ВыгружаемыеОбъекты.Ссылка";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,СтрокаПоиска,СтрокаЗамены);
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Сотрудники, СвойстваСписка);
	Сотрудники.Параметры.УстановитьЗначениеПараметра("ТипОбъекта", МенеджерТипОбъекта.Сотрудник); 
	Сотрудники.Параметры.УстановитьЗначениеПараметра("Приложение", Приложение);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ТекстЗапроса = ФизическиеЛица.ТекстЗапроса;
	СтрокаПоиска = "Справочник.ФизическиеЛица КАК ФизическиеЛица"; 
	Если Приложение = Перечисления.ПриложенияДляИнтеграции.УправлениеПерсоналом Тогда
		СтрокаЗамены = "
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъекты1СПерсонал КАК ВыгружаемыеОбъекты
		|		ПО ФизическиеЛица.Ссылка = ВыгружаемыеОбъекты.Ссылка";
	Иначе
		СтрокаЗамены = "
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъектыКабинетСотрудника КАК ВыгружаемыеОбъекты
		|		ПО ФизическиеЛица.Ссылка = ВыгружаемыеОбъекты.Ссылка";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,СтрокаПоиска,СтрокаЗамены);
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.ФизическиеЛица, СвойстваСписка);
	ФизическиеЛица.Параметры.УстановитьЗначениеПараметра("ТипОбъекта", МенеджерТипОбъекта.ФизическоеЛицо);
	ФизическиеЛица.Параметры.УстановитьЗначениеПараметра("Приложение", Приложение);

КонецПроцедуры

&НаКлиенте
Процедура НачатьПроверкуЗаполнения()

	ДлительнаяОперация = ДлительнаяОперацияПроверкаЗаполнения();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Текст = НСтр("ru = 'Проверка заполнения объектов выполнена.'");
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПроверкаЗаполненияЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияПроверкаЗаполнения()

	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания", НСтр("ru = 'Проверка заполнения объектов'"));
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	ПараметрыПроцедуры = Новый Структура("Приложение", Приложение);
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияУправлениеПерсоналом.ПроверитьЗаполнениеОбъектовПриложенияФоновоеЗадание",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);

КонецФункции

&НаКлиенте
Процедура ПроверкаЗаполненияЗавершение(ДлительнаяОперация, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбновитьСписки();
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, ДлительнаяОперация.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписки()
	
	Элементы.ФизическиеЛица.Обновить();
	Элементы.Сотрудники.Обновить();
	Если Элементы.СтраницаПозиции.Видимость Тогда
		Элементы.Позиции.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()

	Показывать = ПоказыватьПозиции И Не ИнтеграцияУправлениеПерсоналом.ПубликоватьСтруктуруЮридическихЛиц();
	Элементы.СтраницаПозиции.Видимость 		= Показывать;
	Элементы.СотрудникиПозицияШР.Видимость 	= Показывать;

КонецПроцедуры

#КонецОбласти