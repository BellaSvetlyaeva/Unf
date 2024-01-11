
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ВариантУказанияНоменклатурыВДокументе(Знач Документ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВариантыУказанияНоменклатурыВДокументахБЭД.ВариантУказанияНоменклатуры КАК ВариантУказанияНоменклатуры
	|ИЗ
	|	РегистрСведений.ВариантыУказанияНоменклатурыВДокументахБЭД КАК ВариантыУказанияНоменклатурыВДокументахБЭД
	|ГДЕ
	|	ВариантыУказанияНоменклатурыВДокументахБЭД.ДокументСопоставления = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.ВариантУказанияНоменклатуры;
		
	КонецЕсли;
	
КонецФункции

Функция ПоследняяНастройкаВариантаУказанияНоменклатуры(Знач Документ, Знач Контрагент, Знач Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВариантыУказанияНоменклатурыВДокументахБЭД.ВариантУказанияНоменклатуры КАК ВариантУказанияНоменклатуры
	|ИЗ
	|	РегистрСведений.ВариантыУказанияНоменклатурыВДокументахБЭД КАК ВариантыУказанияНоменклатурыВДокументахБЭД
	|ГДЕ
	|	ВариантыУказанияНоменклатурыВДокументахБЭД.Контрагент = &Контрагент
	|	И ВариантыУказанияНоменклатурыВДокументахБЭД.Организация = &Организация
	|	И ТИПЗНАЧЕНИЯ(ВариантыУказанияНоменклатурыВДокументахБЭД.ДокументСопоставления) = &ТипДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВариантыУказанияНоменклатурыВДокументахБЭД.ДатаДокумента УБЫВ";
	
	Запрос.УстановитьПараметр("ТипДокумента", ТипЗнч(Документ));
	Запрос.УстановитьПараметр("Контрагент"  , Контрагент);
	Запрос.УстановитьПараметр("Организация" , Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.ВариантУказанияНоменклатуры;
		
	КонецЕсли;
	
КонецФункции

Процедура ЗаписатьНаборЗаписейВариантаУказанияНоменклатурыДокумента(Знач СсылкаНаДокумент,
																	Знач Организация,
																	Знач Контрагент,
																	Знач ВариантУказанияНоменклатуры, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		НаборЗаписей = РегистрыСведений.ВариантыУказанияНоменклатурыВДокументахБЭД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДокументСопоставления.Установить(СсылкаНаДокумент);
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
		
		Запись = НаборЗаписей.Добавить();
		Запись.ДокументСопоставления       = СсылкаНаДокумент;
		Запись.ДатаДокумента               = СсылкаНаДокумент.Дата;
		Запись.ВариантУказанияНоменклатуры = ВариантУказанияНоменклатуры;
		Запись.Организация                 = Организация;
		Запись.Контрагент                  = Контрагент;
				
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
				
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ОбщегоНазначенияБЭД.ЗаписатьВЖурналРегистрации(ТекстОшибки, 
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().СопоставлениеНоменклатурыКонтрагентов);
		
		Отказ = Истина;
		
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли