#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Возвращает данные звонка, записанные в регистре сведений ДанныеЗвонков
// 
// Параметры:
//  ИдентификаторЗвонкаВАТС - Строка - идентификатор звонка ВАТС
// 
// Возвращаемое значение:
//  Структура - Выборка - данные записанные в регистре сведений ДанныеЗвонков
//
Функция ПолучитьДанныеЗвонкаПоИдентификатору(ИдентификаторЗвонкаВАТС) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеЗвонков.Событие КАК Событие,
	|	ДанныеЗвонков.ИдентификаторЗвонкаВАТС КАК ИдентификаторЗвонкаВАТС,
	|	ДанныеЗвонков.ВходящееИсходящее КАК ВходящееИсходящее,
	|	ДанныеЗвонков.ДатаСобытия КАК ДатаСобытия,
	|	ДанныеЗвонков.НачалоРазговора КАК НачалоРазговора,
	|	ДанныеЗвонков.ДлительностьРазговора КАК ДлительностьРазговора,
	|	ДанныеЗвонков.Контрагент КАК Контрагент,
	|	ДанныеЗвонков.Неотвеченный КАК Неотвеченный,
	|	ДанныеЗвонков.НомерКому КАК НомерКому,
	|	ДанныеЗвонков.НомерОтКого КАК НомерОтКого,
	|	ДанныеЗвонков.НомерОрганизации КАК НомерОрганизации,
	|	ДанныеЗвонков.СсылкаНаЗаписьРазговора КАК СсылкаНаЗаписьРазговора,
	|	ДанныеЗвонков.ВызовЗавершен КАК ВызовЗавершен,
	|	ДанныеЗвонков.Сотрудник КАК Сотрудник,
	|	ДанныеЗвонков.ТребуетсяЗапроситьЗаписьРазговора КАК ТребуетсяЗапроситьЗаписьРазговора,
	|	ДанныеЗвонков.ДатаСозданияЗаписи КАК ДатаСозданияЗаписи
	|ИЗ
	|	РегистрСведений.ДанныеЗвонков КАК ДанныеЗвонков
	|ГДЕ
	|	ДанныеЗвонков.ИдентификаторЗвонкаВАТС = &ИдентификаторЗвонкаВАТС");
	
	Запрос.УстановитьПараметр("ИдентификаторЗвонкаВАТС", ИдентификаторЗвонкаВАТС);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка;
	
КонецФункции

#КонецОбласти

#КонецЕсли