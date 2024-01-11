
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Фамилия + " " + Параметры.Имя + " " + Параметры.Отчество;
	
	Если Параметры.ВозможнаПроверкаПоИНН И НЕ Параметры.ВозможнаПроверкаПоСНИЛС Тогда
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Найден человек с похожим именем.
			|Для того, что бы проверить, что это тот
			|человек, данные которого вводятся
			|введите ИНН нового человека.'");
		
		Элементы.ГруппаСНИЛС.Видимость = Ложь;
		Элементы.ГруппаРежимПроверкиИНН.ТекущаяСтраница = Элементы.СтраницаНадписьИНН;
		
	ИначеЕсли НЕ Параметры.ВозможнаПроверкаПоИНН И Параметры.ВозможнаПроверкаПоСНИЛС Тогда
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Найден человек с похожим именем.
			|Для того, что бы проверить, что это тот
			|человек, данные которого вводятся
			|введите СНИЛС нового человека.'");
			
		РежимПроверки = 1;
		
		Элементы.ГруппаИНН.Видимость = Ложь;
		Элементы.ГруппаРежимПроверкиСНИЛС.ТекущаяСтраница = Элементы.СтраницаНадписьСНИЛС;
		
	Иначе
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Найден человек с похожим именем.
			|Для того, что бы проверить, что это тот
			|человек, данные которого вводятся
			|введите ИНН или СНИЛС нового человека.'");
		
		Элементы.ГруппаРежимПроверкиИНН.ТекущаяСтраница = Элементы.СтраницаРежимПроверкиИНН;
		Элементы.ГруппаРежимПроверкиСНИЛС.ТекущаяСтраница = Элементы.СтраницаРежимПроверкиСНИЛС;
		
	КонецЕсли;
	
	УстановитьСтраницыВводаИННИСНИЛС(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	СообщенияПроверки = "";
	
	Если НЕ ПустаяСтрока(ИНН) Тогда
		
		Если РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИНН, Ложь, СообщенияПроверки) Тогда
		
			Если ИдентификаторФизическогоЛицаУникален("ИНН", ИНН) Тогда
			
				ПоИННПроверкаПройдена = Истина;
				
				ПроверкаПройдена();
		
			Иначе
			
				ПоИННПроверкаПройдена = Ложь;
				
				ИННКартинка = БиблиотекаКартинок.ПротоколСОшибкой;
			
				СообщенияПроверки = НСтр("ru='Найден человек с таким же ИНН. Обратитесь к администратору информационной системы для устранения проблемы.'");
				
				Элементы.ГруппаРежимПроверкиИНН.ТолькоПросмотр = Истина;
				Элементы.ГруппаРежимПроверкиСНИЛС.ТолькоПросмотр = Истина;
				
			КонецЕсли;
			
		Иначе
		
			ПоИННПроверкаПройдена = Ложь;
				
			ИННКартинка = БиблиотекаКартинок.Предупреждение;
			
		КонецЕсли;
		
	Иначе
		
		ИННКартинка = Новый Картинка;
		
		Элементы.ГруппаРежимПроверкиИНН.ТолькоПросмотр = Ложь;
		Элементы.ГруппаРежимПроверкиСНИЛС.ТолькоПросмотр = Ложь;
				
	КонецЕсли;
	
	Элементы.ИНН.Подсказка = СообщенияПроверки;
	Элементы.ИННКартинка.Подсказка = СообщенияПроверки;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраховойНомерПФРПриИзменении(Элемент)
	
	СообщенияПроверки = "";
		
	Если НЕ ПустаяСтрока(СтраховойНомерПФР) Тогда
		
		Если РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(СтраховойНомерПФР, СообщенияПроверки) Тогда
		
			Если ИдентификаторФизическогоЛицаУникален("СтраховойНомерПФР", СтраховойНомерПФР) Тогда
			
				ПоСНИЛСПроверкаПройдена = Истина;
				
				ПроверкаПройдена();
			
			Иначе
			
				ПоСНИЛСПроверкаПройдена = Ложь;
				
				СтраховойНомерПФРКартинка = БиблиотекаКартинок.ПротоколСОшибкой;
			
				СообщенияПроверки = НСтр("ru='Найден человек с таким же СНИЛС. Обратитесь к администратору информационной системы для устранения проблемы.'");
				
				Элементы.ГруппаРежимПроверкиИНН.ТолькоПросмотр = Истина;
				Элементы.ГруппаРежимПроверкиСНИЛС.ТолькоПросмотр = Истина;
				
			КонецЕсли;
			
		Иначе
			
			ПоСНИЛСПроверкаПройдена = Ложь;
				
			СтраховойНомерПФРКартинка = БиблиотекаКартинок.Предупреждение;
			
		КонецЕсли;
		
	Иначе
		
		СтраховойНомерПФРКартинка = Новый Картинка;
		
		Элементы.ГруппаРежимПроверкиИНН.ТолькоПросмотр = Ложь;
		Элементы.ГруппаРежимПроверкиСНИЛС.ТолькоПросмотр = Ложь;
				
	КонецЕсли;
	
	Элементы.СтраховойНомерПФР.Подсказка = СообщенияПроверки;
	Элементы.СтраховойНомерПФРКартинка.Подсказка = СообщенияПроверки;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПроверкиИНН1ПриИзменении(Элемент)
	
	УстановитьСтраницыВводаИННИСНИЛС(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПроверкиСНИЛСПриИзменении(Элемент)
	
	УстановитьСтраницыВводаИННИСНИЛС(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверкаПройдена()
	
	Если ПоИННПроверкаПройдена 
		ИЛИ ПоСНИЛСПроверкаПройдена Тогда
		
		СтруктураВозврата = Новый Структура();
		
		Если ПоИННПроверкаПройдена Тогда
			СтруктураВозврата.Вставить("ИНН", ИНН);
			ТекстСообщения = НСтр("ru='С таким ИНН людей не найдено'");
		КонецЕсли;
		
		Если ПоСНИЛСПроверкаПройдена Тогда
			СтруктураВозврата.Вставить("СтраховойНомерПФР", СтраховойНомерПФР);
			ТекстСообщения = НСтр("ru='С таким СНИЛС людей не найдено'");
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ПроверкаПройденаЗавершение", ЭтотОбъект, СтруктураВозврата);
		ПоказатьПредупреждение(Оповещение, ТекстСообщения, 5, НСтр("ru='Проверка пройдена'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПройденаЗавершение(СтруктураВозврата) Экспорт
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторФизическогоЛицаУникален(Идентификатор, ЗначениеИдентификатора)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ФизическиеЛица.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.ИНН = &ЗначениеИдентификатора";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, ".ИНН", "." + Идентификатор);
	
	Запрос.УстановитьПараметр("ЗначениеИдентификатора", ЗначениеИдентификатора);
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтраницыВводаИННИСНИЛС(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.РежимПроверки = 0 Тогда
		
		Элементы.ГруппаСтраницыИНН.ТекущаяСтраница = Элементы.СтраницаИННДоступен;
		Элементы.ГруппаСтраницыСНИЛС.ТекущаяСтраница = Элементы.СтраницаСНИЛСНеДоступен;
		
	Иначе
		
		Элементы.ГруппаСтраницыИНН.ТекущаяСтраница = Элементы.СтраницаИНННеДоступен;
		Элементы.ГруппаСтраницыСНИЛС.ТекущаяСтраница = Элементы.СтраницаСНИЛСДоступен;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
