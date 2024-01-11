///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеОпции = Новый Структура;
	ДанныеОпции.Вставить("Сервис",             Параметры.Сервис);
	ДанныеОпции.Вставить("ИдентификаторОпции", Параметры.ИдентификаторОпции);
	
	Заголовок = Параметры.Сервис;
	Элементы.ДекорацияИнформацияОбОпциях.Заголовок = Параметры.ПодробныйТекстУведомления;
	Элементы.ДекорацияПодробнее.Заголовок =
		СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'Подробнее о <a href = ""%1"">%2</a>'"),
			Параметры.СтраницаСервиса,
			Параметры.Сервис);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НапомнитьПозже(Команда)
	
	ДатаИнформирования = ДобавитьМесяц(НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()),1);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		МониторПортала1СИТСКлиентСервер.ИдентификаторНастроекМонитораПортала(),
		МониторПортала1СИТСКлиентСервер.КлючНастройкиДатаИнформированияОбОпциях(
			ДанныеОпции),
		ДатаИнформирования);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти