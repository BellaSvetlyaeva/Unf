
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Выполняется только при закрытии формы
	СохранитьИзменения();
	Отказ = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеИспользоватьПриИзменении(Элемент)
	
	ПредставленияОбщихДанныхКлиент.ПредставлениеИспользоватьПриИзменении(ЭтотОбъект);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНаименованиеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТекстОснованияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеИспользуетсяПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьНаКлиенте(Команда)
	СохранитьИзменения();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Команда)
	
	СохранитьИзменения();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИзменения()
	ЗаписатьНаСервере();
	ОповеститьОбИзменении(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ПредставленияОбщихДанных.ПриПолученииДанныхНаСервере(ЭтотОбъект, ТекущийОбъект);
	БольшеНеИспользуется = РегистрыСведений.ОснованияУвольненияВАрхиве.ОснованиеВАрхиве(Объект.Ссылка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СрокДействия",
		"Видимость",
		ЗначениеЗаполнено(Объект.СрокДействия));
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ОснованияУвольненияВАрхиве) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"БольшеНеИспользуется",
			"ТолькоПросмотр",
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ПредставленияОбщихДанных.ЗаписатьНаСервере(ЭтотОбъект);
	РегистрыСведений.ОснованияУвольненияВАрхиве.ПоместитьОснованиеУвольненияВАрхив(
		Объект.Ссылка, БольшеНеИспользуется);
	
КонецПроцедуры

#КонецОбласти
