
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КодФормыРеорганизации = Параметры.КодФормыРеорганизации;
	ИННДоРеорганизации =    Параметры.ИННДоРеорганизации;
	КППДоРеорганизации =    Параметры.КППДоРеорганизации;
	
	СписокКодовФормы = Элементы.ВыборКодаРеорганизации.СписокВыбора;
	
	ПрослеживаемостьБРУ.СписокКодовФормыРеорганизации(СписокКодовФормы);
	
	УправлениеФормой(ЭтотОбъект)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ФормаРеорганизации

&НаКлиенте
Процедура ИННДоРеорганизацииПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КППДоРеорганизацииПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СписокКодовРеорганизацииПриИзменении(Элемент)
	
	ИННДоРеорганизации = "";
	КППДоРеорганизации = "";
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаРеорганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение",ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Элемент.СписокВыбора, Элемент, КодФормыРеорганизации);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(КодФормыРеорганизации)
		И Не ЗначениеЗаполнено(ИННДоРеорганизации) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru = 'Не заполнен ИНН'"),
		,
		,
		,
		Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодФормыРеорганизации)
		И Не ЗначениеЗаполнено(КППДоРеорганизации) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru = 'Не заполнен КПП'"),
		,
		,
		,
		Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность И ПроверитьЗаполнение()  Тогда
		
		ПараметрыПередачи = Новый Структура(
			"КодФормыРеорганизации,ИННДоРеорганизации,КППДоРеорганизации", 
			КодФормыРеорганизации,ИННДоРеорганизации,КППДоРеорганизации);
		
		ОповеститьОВыборе(ПараметрыПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ЗаполненКодФормыРеоганизации = ЗначениеЗаполнено(Форма.КодФормыРеорганизации);
	Элементы.ИННДоРеорганизации.Доступность = ЗаполненКодФормыРеоганизации;
	Элементы.КППДоРеорганизации.Доступность = ЗаполненКодФормыРеоганизации;
		
	Если Не ЗаполненКодФормыРеоганизации Тогда
			
		Элементы.ДекорацияОписаниеКода.Заголовок = "Отсутствует";
			
	Иначе
			
		Элементы.ДекорацияОписаниеКода.Заголовок = 
		ПрослеживаемостьФормыВызовСервера.ОписаниеКодаРеорганизации(Форма.КодФормыРеорганизации);
			
	КонецЕсли;
		
	Элементы.ИННДоРеорганизации.ОтметкаНезаполненного = 
		?(ЗначениеЗаполнено(Форма.ИННДоРеорганизации), Ложь, ЗаполненКодФормыРеоганизации);
		
	Элементы.КППДоРеорганизации.ОтметкаНезаполненного = 
		?(ЗначениеЗаполнено(Форма.КППДоРеорганизации), Ложь, ЗаполненКодФормыРеоганизации);;
		
КонецПроцедуры
	
&НаКлиенте
Процедура ВыборИзСпискаЗавершение(ВыбранныйКод, ДополнительныеПараметры) Экспорт
	
	Модифицированность = Истина;
	КодФормыРеорганизации = ВыбранныйКод.Значение;

КонецПроцедуры

#КонецОбласти
