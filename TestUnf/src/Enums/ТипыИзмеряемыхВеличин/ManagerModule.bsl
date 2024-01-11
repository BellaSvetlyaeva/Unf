#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипыИзмеряемыхВеличин.Ссылка,
	|	ТипыИзмеряемыхВеличин.Порядок КАК Порядок
	|ИЗ
	|	Перечисление.ТипыИзмеряемыхВеличин КАК ТипыИзмеряемыхВеличин
	|ГДЕ
	|	ТипыИзмеряемыхВеличин.Ссылка <> ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка); 
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
