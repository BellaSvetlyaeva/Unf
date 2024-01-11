
#Область КомандыЭДО

Процедура КомандыЭДО_ПриОткрытии(Форма) Экспорт

	ПараметрыПриОткрытии = ОбменСКонтрагентамиКлиент.ПараметрыПриОткрытии();
	ПараметрыПриОткрытии.Форма = Форма;
	ПараметрыПриОткрытии.МестоРазмещенияКоманд = Форма.Элементы.ГруппаКомандыЭДО;
	ПараметрыПриОткрытии.ЕстьОбработчикОбновитьКомандыЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ПараметрыПриОткрытии);

КонецПроцедуры

Процедура КомандыЭДО_ФормаСпискаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт

	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = Форма;
	ПараметрыОповещенияЭДО.МестоРазмещенияКоманд = Форма.Элементы.ГруппаКомандыЭДО;
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновитьКомандыЭДО = Истина;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);

КонецПроцедуры

Процедура КомандыЭДО_ФормаЭлементаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт

	Элементы = Форма.Элементы;
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСправочника();
	ПараметрыОповещенияЭДО.Форма                            = Форма;
	ПараметрыОповещенияЭДО.МестоРазмещенияКоманд            = Элементы.ГруппаКомандыЭДО;
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновитьКомандыЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСправочника(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);

КонецПроцедуры

Процедура ПриАктивизацииСтроки_ФормаСписка(Форма) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ПриАктивизацииСтроки_ФормаСписка(Форма);

КонецПроцедуры

#КонецОбласти
