#Область ПрограммныйИнтерфейс

// Вызывается перед записью документа
// 
// Параметры:
// 	Источник - ДокументОбъект - записываемый документ,
// 	Отказ - Булево - признак отказа от записи (можно переопределить),
// 	РежимЗаписи - РежимЗаписиДокумента - режим записи документа (можно переопределить),
// 	РежимПроведения - РежимПроведенияДокумента - режим проведения документа (можно переопределить).
Процедура ПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
КонецПроцедуры

#КонецОбласти