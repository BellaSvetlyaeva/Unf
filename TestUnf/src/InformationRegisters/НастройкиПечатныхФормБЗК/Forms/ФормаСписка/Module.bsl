#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереЗаблокированнойФормыСписка(ЭтотОбъект, Элементы.ФормаКоманднаяПанель);
	// Конец БлокировкаИзмененияОбъектов
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ОткрытьФормуВводаНовойЗаписи();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьФормуСписка(ЭтотОбъект);
	
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура ДобавитьИдентификаторыВнешнихПечатныхФорм(Команда)
	
	СписокВнешнихПечатныхФорм = ИдентификаторыВнешнихПечатныхФорм();
	Если СписокВнешнихПечатныхФорм.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Не найдено подключенных внешних печатных форм'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	Иначе
		Оповещение = Новый ОписаниеОповещения("ОбработатьВыборВнешнейПечатнойФормы", ЭтотОбъект);
		СписокВнешнихПечатныхФорм.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выберите печатную форму'"), );
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборВнешнейПечатнойФормы(ОписаниеПечатнойФормы, ДополнительныеПараметры) Экспорт
	
	Если ОписаниеПечатнойФормы <> Неопределено Тогда
		ОткрытьФормуВводаНовойЗаписи(ОписаниеПечатнойФормы.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеДобавленияИдентификатора(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторыВнешнихПечатныхФорм()
	
	ВнешниеПечатныеФормы = Новый СписокЗначений;
	
	ВнешниеПечатныеФормыБазыДанных = Новый СписокЗначений;
	ДополнительныеОтчетыИОбработки.ПриПолученииСпискаВнешнихПечатныхФорм(ВнешниеПечатныеФормыБазыДанных, Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВнешниеПечатныеФормыБазыДанных", ВнешниеПечатныеФормыБазыДанных);
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор КАК Идентификатор,
		|	ДополнительныеОтчетыИОбработкиКоманды.Представление КАК Представление,
		|	ДополнительныеОтчетыИОбработкиНазначение.ОбъектНазначения.ПолноеИмя КАК ПолноеИмяОбъектаМетаданных
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Назначение КАК ДополнительныеОтчетыИОбработкиНазначение
		|		ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ДополнительныеОтчетыИОбработкиНазначение.Ссылка
		|ГДЕ
		|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор В(&ВнешниеПечатныеФормыБазыДанных)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Идентификатор,
		|	ПолноеИмяОбъектаМетаданных";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Идентификатор") Цикл
		
		ДобавитьИдентификатор = Ложь;
		ПредставленияОбъектовМетаданных = Новый Массив;
		Пока Выборка.Следующий() Цикл
			
			Если КадровыйЭДО.ЭтоТипОбъектаСПечатнымиФормами(
				ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
					Выборка.ПолноеИмяОбъектаМетаданных).ПустаяСсылка())) Тогда
				
				Если ПредставленияОбъектовМетаданных.Количество() = 4 Тогда
					ПредставленияОбъектовМетаданных.Добавить("...");
					Прервать;
				ИначеЕсли ПредставленияОбъектовМетаданных.Количество() < 4 Тогда
					ПредставленияОбъектовМетаданных.Добавить(Метаданные.НайтиПоПолномуИмени(Выборка.ПолноеИмяОбъектаМетаданных).Представление());
				КонецЕсли;
				
				ДобавитьИдентификатор = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ДобавитьИдентификатор Тогда
			Представление = Выборка.Представление + ": (" + СтрСоединить(ПредставленияОбъектовМетаданных, ", ") + ")";
			ВнешниеПечатныеФормы.Добавить(Выборка.Идентификатор, Представление);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВнешниеПечатныеФормы;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВводаНовойЗаписи(ИдентификаторПечатнойФормы = "")
	
	ПараметрыОткрытия = Новый Структура;
	Если ЗначениеЗаполнено(ИдентификаторПечатнойФормы) Тогда
		Если КадровыйЭДОКлиентСервер.ЭтоИдентификаторыЭлектронногоДокумента(ИдентификаторПечатнойФормы) Тогда
			ПараметрыОткрытия.Вставить("Ключ", КлючЗаписиПоИдентификаторуПечатнойФормы(ИдентификаторПечатнойФормы));
		Иначе
			ЗначенияЗаполнения = Новый Структура("ИдентификаторПечатнойФормы", ИдентификаторПечатнойФормы);
			ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		КонецЕсли;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеДобавленияИдентификатора", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.НастройкиПечатныхФормБЗК.ФормаЗаписи", ПараметрыОткрытия, ЭтотОбъект,
		Истина, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючЗаписиПоИдентификаторуПечатнойФормы(ИдентификаторПечатнойФормы)
	
	Возврат РегистрыСведений.НастройкиПечатныхФормБЗК.СоздатьКлючЗаписи(
		Новый Структура("ИдентификаторПечатнойФормы", ИдентификаторПечатнойФормы))
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("КодДокументаКадровогоМероприятия");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.КодДокументаКадровогоМероприятия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра(
		"Текст", КадровыйЭДОПовтИсп.СвойстваКодаКадровогоДокумента().Код);
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти

