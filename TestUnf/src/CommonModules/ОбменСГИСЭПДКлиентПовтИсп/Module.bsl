Функция РеквизитыПодчиненнойФормы(ИмяФормы) Экспорт
	
	// BSLLS:GetFormMethod-off
	Форма = ПолучитьФорму(ИмяФормы, Новый Структура("ФормаБезОбработки"));
	
	Возврат Форма.ОписаниеРеквизитовФормы();
	
КонецФункции

Функция ПолучитьАдресаДоставки(ИдентификаторФормы, ЗначениеОтбора) Экспорт
	
	Возврат ОбменСГИСЭПДКлиентСервер.ПолучитьАдресаДоставки(ЗначениеОтбора);
	
КонецФункции