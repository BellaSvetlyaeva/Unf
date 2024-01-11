#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьКоличествоКассККМ() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(КассыККММП.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.КассыККММП КАК КассыККММП";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	Иначе
		Возврат 0;
	КонецЕсли;
		
КонецФункции

#КонецОбласти

#КонецЕсли
