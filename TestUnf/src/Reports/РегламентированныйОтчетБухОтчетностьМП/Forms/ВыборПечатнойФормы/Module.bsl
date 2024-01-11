#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыПечати = Параметры.ПараметрыПечати;
	
	// Переопределение текста (информации) на форме.
	Если Параметры.Свойство("РедакцияФормы") Тогда
		Если ЗначениеЗаполнено(Параметры.РедакцияФормы) Тогда
			Элементы.Переключатель2.СписокВыбора[0].Представление
				= "Формы в редакции приказа Минфина России " + Параметры.РедакцияФормы;
		КонецЕсли;
	КонецЕсли;
	
	// Настройки по умолчанию.
	НастройкиВФорме = Новый Структура;
	НастройкиВФорме.Вставить("АктивныйПункт", 2);
	НастройкиВФорме.Вставить("ДоступенПункт1", Истина);
	НастройкиВФорме.Вставить("ДоступенПункт2", Истина);
	НастройкиВФорме.Вставить("ВключатьКодыСтрок", Истина);
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(НастройкиВФорме, ПараметрыПечати);
	КонецЕсли;
	
	ДоступныеПункты = Новый Массив;
	Если НастройкиВФорме.ДоступенПункт1 Тогда
		ДоступныеПункты.Добавить(1);
	КонецЕсли;
	Если НастройкиВФорме.ДоступенПункт2 Тогда
		ДоступныеПункты.Добавить(2);
	КонецЕсли;
	
	ИндексДоступногоПункта = ДоступныеПункты.Найти(НастройкиВФорме.АктивныйПункт);
	Если ИндексДоступногоПункта = Неопределено Тогда
		ИндексДоступногоПункта = 0;
	КонецЕсли;
	Переключатель1 = ДоступныеПункты[ИндексДоступногоПункта];
	
	Элементы.Переключатель1.Доступность = НастройкиВФорме.ДоступенПункт1;
	Элементы.Переключатель2.Доступность = НастройкиВФорме.ДоступенПункт2;
	
	ВыводитьКолонкуСКодамиСтрок = НастройкиВФорме.ВключатьКодыСтрок;
	УстановитьДоступностьВключенияКодов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьВключенияКодов(Форма)
	
	Форма.Элементы.ВыводитьКолонкуСКодамиСтрок.Доступность = (Форма.Переключатель1 = 2);
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель1ПриИзменении(Элемент)
	
	УстановитьДоступностьВключенияКодов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель2ПриИзменении(Элемент)
	
	УстановитьДоступностьВключенияКодов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБланк(Команда)
	
	НастройкиВФорме.Вставить("ВключатьКодыСтрок", ВыводитьКолонкуСКодамиСтрок);
	НастройкиВФорме.Вставить("АктивныйПункт", Переключатель1);
	НастройкиВФорме.Вставить("Команда", Команда.Имя);
	Закрыть(НастройкиВФорме);
	
КонецПроцедуры

#КонецОбласти
