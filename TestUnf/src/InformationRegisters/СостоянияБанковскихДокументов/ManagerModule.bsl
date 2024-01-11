#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура УстановитьСостояниеДокумента(Документ, СостояниеДокумента, ПереходСРедакции20 = Ложь) Экспорт
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ПлатежноеПоручение") Тогда
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Организация, Проведен");
		Ссылка			 = Документ;
		Организация		 = РеквизитыДокумента.Организация;
		ДокументПроведен = РеквизитыДокумента.Проведен;
		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументОбъект.ПлатежноеПоручение") Тогда
		
		Ссылка			 = Документ.Ссылка;
		ДокументПроведен = Документ.Проведен;
		Организация		 = Документ.Организация;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипЗнч(СостояниеДокумента) = Тип("Строка") Тогда
		
		Если СостояниеДокумента = "Подготовлено" Тогда
			
			СостояниеДокумента = Перечисления.СостоянияБанковскихДокументов.Подготовлено;
			
		ИначеЕсли СостояниеДокумента = "НаПодписи" Тогда
			
			СостояниеДокумента = Перечисления.СостоянияБанковскихДокументов.НаПодписи;
			
		ИначеЕсли СостояниеДокумента = "Отклонено" Тогда
			
			СостояниеДокумента = Перечисления.СостоянияБанковскихДокументов.Отклонено;
			
		ИначеЕсли СостояниеДокумента = "Отправлено" Тогда
			
			СостояниеДокумента = Перечисления.СостоянияБанковскихДокументов.Отправлено;
			
		Иначе
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СсылкаНаОбъект", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияБанковскихДокументов.Организация,
	|	СостоянияБанковскихДокументов.СсылкаНаОбъект,
	|	СостоянияБанковскихДокументов.Состояние
	|ПОМЕСТИТЬ ВТСостоянияБанковскихДокументов
	|ИЗ
	|	РегистрСведений.СостоянияБанковскихДокументов КАК СостоянияБанковскихДокументов
	|ГДЕ
	|	СостоянияБанковскихДокументов.СсылкаНаОбъект = &СсылкаНаОбъект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСостоянияБанковскихДокументов.Организация,
	|	ВТСостоянияБанковскихДокументов.СсылкаНаОбъект
	|ИЗ
	|	ВТСостоянияБанковскихДокументов КАК ВТСостоянияБанковскихДокументов
	|ГДЕ
	|	ВТСостоянияБанковскихДокументов.Организация <> &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСостоянияБанковскихДокументов.Организация,
	|	ВТСостоянияБанковскихДокументов.СсылкаНаОбъект,
	|	ВТСостоянияБанковскихДокументов.Состояние
	|ИЗ
	|	ВТСостоянияБанковскихДокументов КАК ВТСостоянияБанковскихДокументов
	|ГДЕ
	|	ВТСостоянияБанковскихДокументов.Организация = &Организация";
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Удаляем запись регистра, если в уже проведенном документе изменили организацию.
	Если Не Результат[1].Пустой() Тогда
		
		Выборка = Результат[1].Выбрать();
		Выборка.Следующий();
		
		ЗаписьРегистра = СоздатьМенеджерЗаписи();
		ЗаписьРегистра.Организация		 = Выборка.Организация;
		ЗаписьРегистра.СсылкаНаОбъект	 = Выборка.СсылкаНаОбъект;
		ЗаписьРегистра.Удалить();
		
	КонецЕсли;
	
	Если Не Результат[2].Пустой() Тогда // уже есть записи в регистре сведений
		
		Выборка = Результат[2].Выбрать();
		Выборка.Следующий();
		Если Выборка.Состояние <> СостояниеДокумента И СостояниеДокумента <> Неопределено Тогда // если состояние не изменилось, регистр не перезаписываем
			
			ЗаписатьСостояние(Ссылка, Организация, СостояниеДокумента);
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(СостояниеДокумента) Тогда // еще нет записей в регистре, записываем, если состояние указано
		
		ЗаписатьСостояние(Ссылка, Организация, СостояниеДокумента);
		
	ИначеЕсли ДокументПроведен Тогда // если документ проведен, устанавливаем состояние "Подготовлено"
		
		ЗаписатьСостояние(Ссылка, Организация, Перечисления.СостоянияБанковскихДокументов.Подготовлено);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ТекущееСостояниеДокумента(ДокументСсылка) Экспорт
	
	Если ДокументСсылка.Пустая() Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Результат = Неопределено;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СсылкаНаОбъект", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияБанковскихДокументов.Состояние
	|ИЗ
	|	РегистрСведений.СостоянияБанковскихДокументов КАК СостоянияБанковскихДокументов
	|ГДЕ
	|	СостоянияБанковскихДокументов.СсылкаНаОбъект = &СсылкаНаОбъект";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Результат = Выборка.Состояние;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныйИнтерфейс

Процедура ЗаписатьСостояние(СсылкаНаОбъект, Организация, СостояниеДокумента)
	
	ЗаписьРегистра = СоздатьМенеджерЗаписи();
	ЗаписьРегистра.СсылкаНаОбъект = СсылкаНаОбъект;
	ЗаписьРегистра.Организация    = Организация;
	ЗаписьРегистра.Состояние      = СостояниеДокумента;
	ЗаписьРегистра.Записать();
	
	Если СостояниеДокумента = Перечисления.СостоянияБанковскихДокументов.Оплачено Тогда
		РегистрыСведений.ДокументыИнтеграцииСБанком.УстановитьСостояниеОбменЗавершен(СсылкаНаОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли