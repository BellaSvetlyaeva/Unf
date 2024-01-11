
#Область СлужебныйПрограммныйИнтерфейс

#Область ФоновыеЗадания

// Начинает фоновое выполнение загрузки операций.
//
// Параметры:
//  ПараметрыЗагрузки - Структура - параметры загрузки операций.
//   * Период - СтандартныйПериод, Структура - Период за который будут выбираться операции.
//    ** ДатаНачала - Дата - начало периода запроса. 
//                           Если не указан, дата начала будет определена автоматически.
//    ** ДатаОкончания - Дата - окончание периода запроса. 
//                              Если не указан, дата окончания будет равна текущей дате.
//   * Организация - ОпределяемыйТип.Организация - организация, по которой нужно отобрать операции. 
//                                                 Если не указана то, будут обработаны все действительные настройки;
//   * СДоговором - Булево, Неопределено - позволяет указать для каких настроек следует загружать операции:
//    ** Неопределено - будут загружены и операции по схемам "С договором" и "Без договора"
//    ** Истина - будут загружены операции по схеме "С договором"
//    ** Ложь - будут загружены операции по схеме "Без договора"
//    Если указан параметр Организация, этот параметр не учитывается.
//
// Возвращаемое значение:
//  Структура - описание длительной операции. См. ДлительныеОперации.ВыполнитьВФоне.
//
Функция НачатьЗагрузкуОпераций(ПараметрыЗагрузки) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка операций по ЮKassa'");
	
	ИмяПроцедуры = "ОнлайнОплатыУНФ.ЗагрузитьОперацииОнлайнОплатыВФоне";
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыЗагрузки, ПараметрыВыполнения);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

#КонецОбласти 

#КонецОбласти
