#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОсновнаяОрганизация = РегламентированнаяОтчетность.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = ОсновнаяОрганизация;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли