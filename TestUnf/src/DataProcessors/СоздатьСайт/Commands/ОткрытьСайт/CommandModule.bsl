#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеСайтаСтруктура = ПолучитьАдресСайта();
	#Если МобильныйКлиент Тогда
	    ОткрытьФорму("РегистрСведений.ДанныеСайта.ФормаСписка");
	#Иначе	
		ОткрытьФорму("Обработка.СоздатьСайт.Форма.Список");
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьАдресСайта()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСайта.АдресСайта,
	|	ДанныеСайта.IDСайта,
	|	ДанныеСайта.URLАдминЗоны
	|ИЗ
	|	РегистрСведений.ДанныеСайта КАК ДанныеСайта";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество()<=1 Тогда
		Выборка.Следующий();
		Возврат Новый Структура("АдресСайта, URLАдминЗоны", Выборка.АдресСайта, Выборка.URLАдминЗоны);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
