#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЕстьДокументы() Экспорт
	
	ВыборкаДокументов = Документы.ПриходТовараМП.Выбрать();
	
	Пока ВыборкаДокументов.Следующий() Цикл
		Если НЕ ВыборкаДокументов.ПометкаУдаления Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	ВыборкаДокументов = Документы.РасходТовараМП.Выбрать();
	
	Пока ВыборкаДокументов.Следующий() Цикл
		Если НЕ ВыборкаДокументов.ПометкаУдаления Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецЕсли
