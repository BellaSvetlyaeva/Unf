#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт

	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;

КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	НалоговыеСтавкиПоУмолчанию = УчетНДФЛПредпринимателяКлиентСервер.НалоговыеСтавкиПоУмолчанию(); 
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Код2000";
	Элемент.Наименование = НСтр("ru='Вознаграждение за выполнение трудовых или иных обязанностей; денежное содержание и иные налогооблагаемые выплаты военнослужащим и приравненным к ним'");
	Элемент.СтавкаНДФЛ = НалоговыеСтавкиПоУмолчанию.СтавкаНДФЛ;
	Элемент.СтавкаНДФЛПовышенная = НалоговыеСтавкиПоУмолчанию.СтавкаНДФЛПовышенная;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Код2010";
	Элемент.Наименование = НСтр("ru='Выплаты по договорам гражданско-правового характера (за исключением авторских вознаграждений)'");
	Элемент.СтавкаНДФЛ = НалоговыеСтавкиПоУмолчанию.СтавкаНДФЛ;
	Элемент.СтавкаНДФЛПовышенная = НалоговыеСтавкиПоУмолчанию.СтавкаНДФЛПовышенная;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Код2012";
	Элемент.Наименование = НСтр("ru='Суммы отпускных выплат'");
	Элемент.СтавкаНДФЛ = НалоговыеСтавкиПоУмолчанию.СтавкаНДФЛ;
	Элемент.СтавкаНДФЛПовышенная = НалоговыеСтавкиПоУмолчанию.СтавкаНДФЛПовышенная;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли
