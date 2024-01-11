
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Первоначальное заполнение объекта.
	Если Параметры.Ключ.Пустая() Тогда
		
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(
	ЭтаФорма, "СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев", Объект.Ссылка);
	УчетСтраховыхВзносовКлиентСервер.ОбновитьПолеСтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериод(
	ЭтаФорма, СсылкаНаОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СсылкаНаОбъект = ТекущийОбъект.Ссылка;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория" Тогда
		Если СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевНаборЗаписейПрочитан Тогда
			РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, СсылкаНаОбъект, ИмяСобытия, 
			Параметр, Источник);
			УчетСтраховыхВзносовКлиентСервер.ОбновитьПолеСтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериод(ЭтаФорма, 
			СсылкаНаОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СсылкаНаОбъект = ТекущийОбъект.Ссылка;
	ЗаписатьСтавкуВзносаНаСтрахованиеОтНесчастныхСлучаев();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	ПриПолученииДанныхНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	ЗаписатьНаКлиенте(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	ЗаписатьНаКлиенте(Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Владелец) 
		И Не ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленныеПодразделения") Тогда
		
		ТекстПредупреждения = НСтр("ru='В организации %1 не используются обособленные подразделения'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, Объект.Владелец);
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаписьЭлемента

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстКнопкиДа = НСтр("ru = 'Изменились сведения о ставке взносов в ФСС НС и ПЗ'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'При редактировании были изменены сведения о классе условий труда.
		|Если были исправлены прежние сведения о ставке взносов в ФСС НС и ПЗ (они были ошибочными), 
		|нажмите ""Исправлена ошибка"".
		|Если сведения о ставке взносов в ФСС НС и ПЗ изменились с %1, нажмите ""%2""'"), 
	Формат(СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериод, НСтр("ru='ДФ=ММММ гггг ""г""'")),
		ТекстКнопкиДа);
	
	РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтотОбъект,
		"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев", ТекстВопроса, ТекстКнопкиДа, Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиентеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Записать(ПараметрыЗаписи) И ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ПрочитатьСтавкуВзносаНаСтрахованиеОтНесчастныхСлучаев();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы,
	"Владелец",
	"ТолькоПросмотр",
	ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Владелец));
	
КонецПроцедуры

// АПК:78-выкл: экспорт нужен для вызова из РедактированиеПериодическихСведений

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

// АПК:78-вкл

&НаСервере
Процедура ПрочитатьСтавкуВзносаНаСтрахованиеОтНесчастныхСлучаев()
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев) Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, 
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев", СсылкаНаОбъект);
	УчетСтраховыхВзносовКлиентСервер.ОбновитьПолеСтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериод(ЭтаФорма, 
	СсылкаНаОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСтавкуВзносаНаСтрахованиеОтНесчастныхСлучаев()
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев) Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, 
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев", СсылкаНаОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
	ЭтаФорма, "СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.Период", 
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокой", 
	Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
	ЭтаФорма,
	ЭтаФорма,
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.Период",
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокой",
	,
	,
	НачалоГода(ОбщегоНазначенияКлиент.ДатаСеанса()));
КонецПроцедуры

&НаКлиенте
Процедура СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокойРегулирование(Элемент, Направление, 
	СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
	ЭтаФорма, "СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.Период", 
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокой",
	Направление, Модифицированность, НачалоГода(ОбщегоНазначенияКлиент.ДатаСеанса()));
КонецПроцедуры

&НаКлиенте
Процедура СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, 
	ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевИстория(Команда)
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев", 
	СсылкаНаОбъект, ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаПриИзменении(Элемент)
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(ЭтаФорма, 
	"СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев", СсылкаНаОбъект);
КонецПроцедуры

#КонецОбласти
