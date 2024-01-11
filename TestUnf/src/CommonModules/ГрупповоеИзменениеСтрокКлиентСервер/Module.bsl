#Область ПрограммныйИнтерфейс

// Устанавливает ограничение типа выбираемому значению в зависимости от выбранного действия
//
// Параметры:
//  НаборЭлементов   - Структура - набор необходимых реквизитов и элементов формы, входящих в панель редактирования.
//    * КнопкаВыполнитьДействие - КнопкаФормы - Кнопка формы, запускающая обработку ТЧ.
//    * Действие - ПеречислениеСсылка.ДействияГрупповогоИзмененияСтрок - Выбранное действие для группового изменения строк.
//    * ЗначениеЭлемент - ПолеФормы - Поле ввода значения для группового изменения строк.
//
Процедура УстановитьПредставлениеДействия(НаборЭлементов, УстановитьСвязиПараметровВыбора) Экспорт
	
	Если НЕ ЗначениеЗаполнено(НаборЭлементов.Действие) Тогда
		
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("Строка"));
		НаборЭлементов.ЗначениеЭлемент.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
		НаборЭлементов.ЗначениеЭлемент.Видимость = Истина;
		НаборЭлементов.ЗначениеЭлемент.Заголовок = НСтр("ru = 'Значение'");
		Возврат;
		
	КонецЕсли;
	
	ПараметрыВыбора = ?(НаборЭлементов.КолонкаОбъектИзменений = Неопределено, Неопределено, НаборЭлементов.КолонкаОбъектИзменений.ПараметрыВыбора);
	СвязиПараметровВыбора = ?(НаборЭлементов.КолонкаОбъектИзменений = Неопределено, Неопределено, НаборЭлементов.КолонкаОбъектИзменений.СвязиПараметровВыбора);
	
	ТипЗначения = ТипОбъектаДействия(НаборЭлементов.Действие, НаборЭлементов.КолонкаОбъектИзменений);
	
	Если ЗначениеЗаполнено(ТипЗначения) Тогда
		
		НаборЭлементов.ЗначениеЭлемент.ОграничениеТипа = ТипЗначения;
		Если ПараметрыВыбора <> Неопределено Тогда
			НаборЭлементов.ЗначениеЭлемент.ПараметрыВыбора = ПараметрыВыбора;
		КонецЕсли;
		Если НаборЭлементов.ЗначениеЭлемент.СвязиПараметровВыбора.Количество() <> 0 Тогда
			УстановитьСвязиПараметровВыбора = Истина;
		ИначеЕсли СвязиПараметровВыбора <> Неопределено Тогда
			УстановитьСвязиПараметровВыбора = СвязиПараметровВыбора.Количество() <> 0;
		Иначе
			УстановитьСвязиПараметровВыбора = Ложь;
		КонецЕсли;
		НаборЭлементов.ЗначениеЭлемент.Заголовок = ПредставлениеЗаголовкаОбъектаДействия(НаборЭлементов.Действие);
		НаборЭлементов.ЗначениеЭлемент.РежимВыбораИзСПиска = Ложь;
		
		Если НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ДобавитьИзДокумента") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ИзменитьЦеныНаПроцент") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ОкруглитьЦены")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ОкруглитьСуммы") Тогда
			
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Ложь;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоКоличеству") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммам") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммеПередачи")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммеВознаграждения") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСтавкуНДС") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Ложь;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьПроцентСкидкиНаценки") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЦены") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЦеныПоВиду") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЗаказПокупателя") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуОтгрузки")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуПоступления")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуРеализации")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуПланирования") Тогда
			
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьПокупателя")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьПоставщика")
			ИЛИ НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьИзготовителя") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЗаказПоставщикуЗаказПокупателя") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСклад") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЯчейку") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьИсходноеМесто") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьНовоеМесто") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.СоздатьПартииНоменклатуры") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаОчистки = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Ложь;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Ложь;
			НаборЭлементов.ЗначениеЭлемент.Заголовок = НСтр("ru = 'Наименование партии'");
			НаборЭлементов.Значение = "Партия создана автоматически";
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЭтап") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Ложь;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
			НаборЭлементов.ЗначениеЭлемент.РежимВыбораИзСПиска = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСпособУказанияЗаказа") Тогда 
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		ИначеЕсли НаборЭлементов.Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ОтменитьСтроки") Тогда
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыбора = Истина;
			НаборЭлементов.ЗначениеЭлемент.КнопкаВыпадающегоСписка = Истина;
		КонецЕсли;
		
	Иначе
		
		НаборЭлементов.ЗначениеЭлемент.Видимость = Ложь;
		НаборЭлементов.КнопкаВыполнитьДействие.Видимость = Истина;
		
	КонецЕсли;
	
	НаборЭлементов.ЗначениеЭлемент.КнопкаОткрытия = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет тип объекта действия.
//
Функция ТипОбъектаДействия(Действие, ОбъектИзменений)
	
	МассивТипов = Новый Массив;
	КвалификаторыЧисла = Неопределено;
	ОписаниеТипов = Неопределено;
	
	Если Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ДобавитьИзДокумента") Тогда
		
		МассивТипов.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ИнвентаризацияЗапасов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ОприходованиеЗапасов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПеремещениеЗапасов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПриходнаяНакладная"));
		МассивТипов.Добавить(Тип("ДокументСсылка.РасходнаяНакладная"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СборкаЗапасов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеЗапасов"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплату"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПоставщика"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ДобавитьИзДокументаИмпортныеТовары") Тогда
		
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПриходнаяНакладная"));
		МассивТипов.Добавить(Тип("ДокументСсылка.СчетНаОплату"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ИзменитьЦеныНаПроцент") Тогда
		
		МассивТипов.Добавить(Тип("Число"));
		КвалификаторыЧисла = Новый КвалификаторыЧисла(10, 2, ДопустимыйЗнак.Любой);
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ОкруглитьЦены")
		ИЛИ Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ОкруглитьСуммы") Тогда
		
		МассивТипов.Добавить(Тип("ПеречислениеСсылка.ПорядкиОкругления"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоКоличеству") Тогда
		
		МассивТипов.Добавить(Тип("Число"));
		КвалификаторыЧисла = Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный);
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммам") Тогда
		
		МассивТипов.Добавить(Тип("Число"));
		КвалификаторыЧисла = Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный);
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммеПередачи")
		ИЛИ Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммеВознаграждения") Тогда
		
		МассивТипов.Добавить(Тип("Число"));
		КвалификаторыЧисла = Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный);
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСтавкуНДС") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.СтавкиНДС"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьПроцентСкидкиНаценки") Тогда
		
		МассивТипов.Добавить(Тип("Число"));
		КвалификаторыЧисла = Новый КвалификаторыЧисла(10, 2, ДопустимыйЗнак.Неотрицательный);
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЦены") Тогда
		
		МассивТипов.Добавить(Тип("Число"));
		КвалификаторыЧисла = Новый КвалификаторыЧисла(10, 2, ДопустимыйЗнак.Неотрицательный);
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЦеныПоВиду") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.ВидыЦен"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УдалитьСтроки") Тогда
		
		МассивТипов.Очистить();
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЗаказПокупателя") Тогда
		
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуОтгрузки")
		ИЛИ Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуПоступления")
		ИЛИ Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуРеализации")
		ИЛИ Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьДатуПланирования") Тогда
		
		МассивТипов.Добавить(Тип("Дата"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьПокупателя")
		ИЛИ Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьПоставщика") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.Контрагенты"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьИзготовителя") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.СтруктурныеЕдиницы"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЗаказПоставщикуЗаказПокупателя") Тогда
		
		ОписаниеТипов = ОбъектИзменений.ОграничениеТипа;
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСклад") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.СтруктурныеЕдиницы"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЯчейку") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.Ячейки"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьИсходноеМесто") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.СтруктурныеЕдиницы"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьНовоеМесто") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.СтруктурныеЕдиницы"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.СоздатьПартииНоменклатуры") Тогда
		
		МассивТипов.Добавить(Тип("Строка"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьЭтап") Тогда
		
		МассивТипов.Добавить(Тип("СправочникСсылка.ЭтапыПроизводства"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСостояниеДоставки") Тогда
		
		МассивТипов.Добавить(Тип("ПеречислениеСсылка.СостоянияДоставкиЗаказа"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСостояниеОплаты") Тогда
		
		МассивТипов.Добавить(Тип("ПеречислениеСсылка.СостоянияОплатыЗаказа"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСпособУказанияЗаказа") Тогда 
		
		МассивТипов.Добавить(Тип("ПеречислениеСсылка.СпособыЗачетаИРаспределенияПлатежей"));
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.ОтменитьСтроки") Тогда
		
		ОписаниеТипов = ОбъектИзменений.ОграничениеТипа;
		
	КонецЕсли;
	
	Если ОписаниеТипов = Неопределено Тогда
		ТипОбъекта = Новый ОписаниеТипов(МассивТипов,,, КвалификаторыЧисла);
	Иначе
		ТипОбъекта = ОписаниеТипов;
	КонецЕсли;
	
	Возврат ТипОбъекта;
	
КонецФункции

// Определяет название объекта действия.
//
Функция ПредставлениеЗаголовкаОбъектаДействия(ДействиеПеречисление)
	
	ДействиеПредставление = Строка(ДействиеПеречисление);
	Возврат Прав(ДействиеПредставление, СтрДлина(ДействиеПредставление) - СтрНайти(ДействиеПредставление, "@"));
	
КонецФункции

#КонецОбласти