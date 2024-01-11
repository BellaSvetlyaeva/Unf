&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РФИлиНетПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеФормы(ЭтотОбъект, Элемент.Имя);
	
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
Процедура ОбщееПолеВводаИННПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиент.ЗаполнениеРеквизитовИзОбщегоПоляВвода(Элемент, ЭтотОбъект);
	
КонецПроцедуры