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
	
	Если ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно
	   И Не Параметры.СкрытьЗаявление Тогда
		Элементы.ДобавитьЗаявлениеНаВыпускСертификата.Видимость = Истина;
	Иначе
		Элементы.ДобавитьЗаявлениеНаВыпускСертификата.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЭлектроннаяПодпись.ДобавлениеИзменениеЭлектронныхПодписей() Тогда
		
		Элементы.ДобавитьДляПодписанияИШифрования.Заголовок = НСтр("ru = 'Добавить для шифрования и расшифровки...'");
		НазначениеДляПодписанияИШифрования = "ДляШифрованияИРасшифровки";
		
	ИначеЕсли Не ЭлектроннаяПодпись.ИспользоватьШифрование()
		И Не Элементы.ДобавитьЗаявлениеНаВыпускСертификата.Видимость Тогда
	
		Отказ = Истина;
		Возврат;
		
	Иначе
		
		Элементы.ДобавитьДляПодписанияИШифрования.Заголовок = НСтр("ru = 'Добавить для подписания и шифрования...'");
		НазначениеДляПодписанияИШифрования = "ДляПодписанияШифрованияИРасшифровки";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДляПодписанияИШифрования(Команда)
	
	Закрыть(НазначениеДляПодписанияИШифрования);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзФайлов(Команда)
	
	Закрыть("ТолькоДляШифрованияИзФайлов");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзКаталога(Команда)
	
	Закрыть("ТолькоДляШифрованияИзКаталога");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаявлениеНаВыпускСертификата(Команда)
	
	Закрыть("ЗаявлениеНаВыпускСертификата");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТолькоДляШифрования(Команда)
	
	Закрыть("ТолькоДляШифрования");
	
КонецПроцедуры

#КонецОбласти
