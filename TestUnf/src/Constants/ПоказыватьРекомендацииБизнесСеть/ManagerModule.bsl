#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию() Экспорт
	
	// В связи с переименованием константы из НеПоказыватьРекомендацииБизнесСеть инвертируем значение.
	// Так же при начальном заполнении будет установлен флаг Истина.
	ТекущееЗначение = Константы.ПоказыватьРекомендацииБизнесСеть.Получить();
	НовоеЗначение = Не ТекущееЗначение;
	Константы.ПоказыватьРекомендацииБизнесСеть.Установить(НовоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли