&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Элементы.Тип.СписокВыбора.ЗагрузитьЗначения(ОбменСГИСЭПДКлиентСервер.ПолучитьМассивТиповПрицепов());
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции




&НаКлиенте
Процедура ТитулГрузоотправителяОснованияВладенияПрицепомПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ТекущиеДанные.ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулГрузоотправителяОснованиеВладенияПрицепомРеквизитыСторонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ОснованияВладенияПрицепом.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяОснованияВладенияПрицепомВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ЗаполнитьОснованиеВладенияПрицепомРеквизитыСторон" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяОснованияВладенияПрицепомПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);

	ТекущиеДанные = Элемент.ТекущиеДанные;
	ТекущиеДанные.ЗаполнитьОснованиеВладенияПрицепомРеквизитыСторон = "Заполнить";

КонецПроцедуры
