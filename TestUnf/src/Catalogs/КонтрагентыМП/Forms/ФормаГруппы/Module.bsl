
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке("https://sbm.1c.ru/about/razdel-kontragenty/gruppy-kontragentov/");
	// АПК:534-вкл
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	АвтоЗаголовок = Ложь;
	Если Объект.Ссылка.Пустая() Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Группа (новая)';en='Group (new)'");
	ИначеЕсли Объект.ПометкаУдаления Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Группа (к удалению)';en='Group (removed)'");
	Иначе
		ЭтаФорма.Заголовок = НСтр("ru='Группа';en='Group'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
