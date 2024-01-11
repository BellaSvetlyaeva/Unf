////////////////////////////////////////////////////////////////////////////////
// РасчетЗарплатыДляНебольшихОрганизацийКлиент: 
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Показывает предупреждение о достижении максимально возможного количества
// работающих сотрудников.
//
// Параметры:
//		Форма		- ФормаКлиентскогоПриложения
//		Организация - СправочникСсылка.Организации
//
Функция ПоказатьПредупреждениеОбОграниченияхРежимаРасчетаЗарплатыДляНебольшихОрганизаций(Форма, Организация) Экспорт
	
	ПредупреждениеПоказано = Ложь;
	
	Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("РасчетЗарплатыДляНебольшихОрганизаций")
		ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Возврат ПредупреждениеПоказано;
		
	КонецЕсли;
	
	ТекстПредупреждения = РасчетЗарплатыДляНебольшихОрганизацийВызовСервера.ТекстПредупрежденияОбОграниченияхРежимаРасчетаЗарплатыДляНебольшихОрганизаций(Организация, Форма.ТекущееКоличествоСотрудников);
	Если НЕ ПустаяСтрока(ТекстПредупреждения) Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьПредупреждениеОбОграниченияхРежимаРасчетаЗарплатыДляНебольшихОрганизацийЗавершение", Форма);
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
		
		ПредупреждениеПоказано = Истина;
		
	КонецЕсли; 
	
	Возврат ПредупреждениеПоказано;
	
КонецФункции

#КонецОбласти

