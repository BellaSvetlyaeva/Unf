#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаспознаваниеДокументовСлужебный.АктуализироватьОбъектыСвязанныеСРаспознаннымДокументом(Параметры.РаспознанныйДокумент);
	
	ЗагрузитьСвязанные();
	
	// Эксперимент с отображением пустой таблицы связанных документов
	//
	//Если СвязанныеДокументы.Количество() = 0 Тогда
	//	Отказ = Истина;
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСвязанныеДокументы

&НаКлиенте
Процедура СвязанныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СвязанныеДокументыСсылка" Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	ИначеЕсли Поле.Имя = "СвязанныеДокументыКоманда" Тогда
		Если Элемент.ТекущиеДанные.ПотенциальныйКандидат Тогда
			ПрикрепитьНаСервере(Элемент.ТекущиеДанные.Ссылка);
			Оповестить("ПрикрепленСканДокумента");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрикрепитьНаСервере(Кандидат)
	
	ДокументОбъект = Параметры.РаспознанныйДокумент.ПолучитьОбъект();
	
	АдресКартинки = ПоместитьВоВременноеХранилище(ДокументОбъект.ИсходноеИзображение.Получить());
	РаспознаваниеДокументовСлужебный.ДобавитьПрисоединенныйФайл(ДокументОбъект, Кандидат.Ссылка, АдресКартинки);
	УдалитьИзВременногоХранилища(АдресКартинки);
	
	РегистрыСведений.СвязанныеОбъектыРаспознаниеДокументов.ЗаписатьЗначения(Кандидат.Ссылка, ДокументОбъект.Ссылка, Ложь);
	
	РезультатОбратнойСвязи = РаспознаваниеДокументов.ОписаниеОбратнойСвязи("ПрикрепилСкан");
	Пакет = Новый Структура("created", РезультатОбратнойСвязи);
	РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(ДокументОбъект.ИдентификаторРезультата, Пакет);
	
	ТекущиеНастройки = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.ТекущиеНастройки();
	
	Если ТекущиеНастройки.ПомечатьДокументОбработаннымПриПрикрепленииИзображения Тогда
		ДокументОбъект.Статус = Перечисления.СтатусыСозданныхДокументовРаспознаваниеДокументов.Обработан;
		ДокументОбъект.Записать();
		
		РезультатОбратнойСвязи = РаспознаваниеДокументов.ОписаниеОбратнойСвязи("Проведен");
		Пакет = Новый Структура("created", РезультатОбратнойСвязи);
		РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(ДокументОбъект.ИдентификаторРезультата, Пакет);
	КонецЕсли;
	
	ЗагрузитьСвязанные();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСвязанные()
	
	СвязанныеДокументы.Загрузить(
		РегистрыСведений.СвязанныеОбъектыРаспознаниеДокументов.ВсеСвязанныеДокументы(Параметры.РаспознанныйДокумент)
	);
	
	Для Каждого Документ Из СвязанныеДокументы Цикл 
		
		Если Документ.ПотенциальныйКандидат Тогда
			
			Документ.Команда = НСтр("ru = 'Прикрепить скан'");
			
		Иначе
			
			Документ.Картинка = БиблиотекаКартинок.Картинка;
			Документ.Команда = НСтр("ru = 'Скан уже прикреплен'");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти