#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ЭтоАбстрактнаяОперация(ВидОперации) Экспорт
	
	Если АбстрактныеОперации().Найти(ВидОперации) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ОперацияЯвляетсяОснованием(ВидОперации) Экспорт
	
	Если ОперацииОснования().Найти(ВидОперации) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ЭтоОперацияДополнительногоЗапроса(ВидОперации) Экспорт
	
	Если ОперацииССобственнымиЗапросами().Найти(ВидОперации) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция АбстрактныеОперации() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ФормированиеПартииРасчетСтатуса);
	МассивОпераций.Добавить(ОформлениеСДИЗРасчетСтатуса);
	МассивОпераций.Добавить(СписаниеПартиийРасчетСтатуса);
	МассивОпераций.Добавить(ЗапросПартийРасчетСтатуса);
	МассивОпераций.Добавить(ПогашениеСДИЗРасчетСтатуса);
	МассивОпераций.Добавить(ЗапросКлассификатораАбстрактнаяОперация);
	МассивОпераций.Добавить(ЗапросМестФормированияПартийАбстрактнаяОперация);
	МассивОпераций.Добавить(ЗапросРезультатовИсследованийАбстрактнаяОперация);
	МассивОпераций.Добавить(ЗапросСДИЗАбстрактнаяОперация);
	МассивОпераций.Добавить(ВнесениеСведенийОСобранномУрожаеРасчетСтатуса);
	МассивОпераций.Добавить(МестоФормированияПартииРасчетСтатуса);
	МассивОпераций.Добавить(АннулированиеСДИЗРасчетСтатуса);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция ОперацииОснования() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ЗапросПартийРасчетСтатуса);
	МассивОпераций.Добавить(ЗапросКлассификатораАбстрактнаяОперация);
	МассивОпераций.Добавить(ЗапросМестФормированияПартийАбстрактнаяОперация);
	МассивОпераций.Добавить(ЗапросРезультатовИсследованийАбстрактнаяОперация);
	МассивОпераций.Добавить(ЗапросСДИЗАбстрактнаяОперация);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция ОперацииССобственнымиЗапросами()
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ЗапросРеестраЭлеваторов);
		
	Возврат МассивОпераций;
	
КонецФункции

Функция ОперацииРасчетСтатуса() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ФормированиеПартииРасчетСтатуса);
	МассивОпераций.Добавить(ОформлениеСДИЗРасчетСтатуса);
	МассивОпераций.Добавить(СписаниеПартиийРасчетСтатуса);
	МассивОпераций.Добавить(ПогашениеСДИЗРасчетСтатуса);
	МассивОпераций.Добавить(ВнесениеСведенийОСобранномУрожаеРасчетСтатуса);
	МассивОпераций.Добавить(МестоФормированияПартииРасчетСтатуса);
	МассивОпераций.Добавить(АннулированиеСДИЗРасчетСтатуса);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция БазовыеОперации() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ФормированиеПартииИзОстатков);
	МассивОпераций.Добавить(ФормированиеПартииИмпорт);
	МассивОпераций.Добавить(ФормированиеПартииПоРезультатамГосмониторинга);
	МассивОпераций.Добавить(ФормированиеПартииПриСбореУрожая);
	МассивОпераций.Добавить(ФормированиеПартииИзДругихПартий);
	МассивОпераций.Добавить(ФормированиеПартииПроизводство);
	МассивОпераций.Добавить(АннулированиеФормированияПартии);
	
	МассивОпераций.Добавить(ОформлениеСДИЗИмпорт);
	МассивОпераций.Добавить(ОформлениеСДИЗЭкспорт);
	МассивОпераций.Добавить(ОформлениеСДИЗРФ);
	МассивОпераций.Добавить(ОформлениеСДИЗЭлеватор);
	МассивОпераций.Добавить(АннулированиеСДИЗ);
	
	МассивОпераций.Добавить(МестоФормированияПартииСоздание);
	МассивОпераций.Добавить(ПогашениеСДИЗ);
	МассивОпераций.Добавить(СписаниеПартии);
	
	Возврат МассивОпераций;
	
КонецФункции

#КонецОбласти

#КонецЕсли
