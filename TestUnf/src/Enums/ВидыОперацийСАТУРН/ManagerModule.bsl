#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ЭтоАбстрактнаяОперация(ВидОперации) Экспорт
	
	Если АбстрактныеОперации().Найти(ВидОперации) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ЭтоОперацияРаботыСКлассификаторами(ВидОперация) Экспорт

	Если ОперацииРаботыСКлассификаторами().Найти(ВидОперация) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции

Функция ЭтоОперацияЗагрузкиДокументов(ВидОперация) Экспорт

	Если ВидОперация = НакладнаяЗагрузкаДокументов
		Или ВидОперация = НакладнаяЗагрузкаСтатусов
		Или ВидОперация = НакладнаяЗагрузкаСтатусовРасчетСтатуса Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция ЭтоЗапросСписка(Операция) Экспорт
	
	Возврат Операция = НакладнаяЗагрузкаСтатусов;
	
КонецФункции

Функция ОперацияЯвляетсяОснованием(ВидОперации) Экспорт
	
	Если ОперацииОснования().Найти(ВидОперации) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция АбстрактныеОперации() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(АктИнвентаризацииРасчетСтатуса);
	МассивОпераций.Добавить(АктПримененияРасчетСтатуса);
	МассивОпераций.Добавить(ЗапросОстатковПартийРасчетСтатуса);
	МассивОпераций.Добавить(ИмпортПродукцииРасчетСтатуса);
	МассивОпераций.Добавить(ИмпортПродукцииРасчетСтатусовПоДокументу);
	МассивОпераций.Добавить(НакладнаяРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяПодтверждениеРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяВозвратРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяПодтверждениеВозвратаРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяПодтверждениеУтериГрузаПриВозвратеРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяГрузУтерянРасчетСтатуса);
	МассивОпераций.Добавить(ПроизводственнаяОперацияРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяЗагрузкаДокументовРасчетСтатуса);
	МассивОпераций.Добавить(ПланПримененияРасчетСтатуса);
	МассивОпераций.Добавить(ПланПримененияРасчетСтатусовПоДокументу);
	МассивОпераций.Добавить(НакладнаяЗагрузкаСтатусовРасчетСтатуса);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция ОперацииОснования() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(АктИнвентаризацииРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяПодтверждениеРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяВозвратРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяПодтверждениеВозвратаРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяПодтверждениеУтериГрузаПриВозвратеРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяГрузУтерянРасчетСтатуса);
	МассивОпераций.Добавить(АктПримененияРасчетСтатуса);
	МассивОпераций.Добавить(ИмпортПродукцииРасчетСтатуса);
	МассивОпераций.Добавить(ИмпортПродукцииРасчетСтатусовПоДокументу);
	МассивОпераций.Добавить(ПроизводственнаяОперацияРасчетСтатуса);
	МассивОпераций.Добавить(ЗапросОстатковПартийРасчетСтатуса);
	МассивОпераций.Добавить(ПланПримененияРасчетСтатуса);
	МассивОпераций.Добавить(ПланПримененияРасчетСтатусовПоДокументу);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция ОперацииРасчетСтатуса() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ПланПримененияРасчетСтатусовПоДокументу);
	МассивОпераций.Добавить(НакладнаяЗагрузкаСтатусовРасчетСтатуса);
	МассивОпераций.Добавить(НакладнаяЗагрузкаСтатусов);
	МассивОпераций.Добавить(ИмпортПродукцииРасчетСтатусовПоДокументу);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция ОперацииРаботыСКлассификаторами() Экспорт
	
	МассивОпераций = Новый Массив();
	МассивОпераций.Добавить(ПАТСозданиеКлассификатора);
	МассивОпераций.Добавить(ПАТИзменениеКлассификатора);
	МассивОпераций.Добавить(ПАТСменаСтатусаИзЧерновикаВОтменено);
	МассивОпераций.Добавить(ПАТСменаСтатусаИзЧерновикВАктуально);
	
	МассивОпераций.Добавить(ОрганизацияЗапросКлассификатора);
	МассивОпераций.Добавить(ПАТЗапросКлассификатора);
	МассивОпераций.Добавить(МестоПримененияЗапросКлассификатора);
	МассивОпераций.Добавить(МестоХраненияЗапросКлассификатора);
	МассивОпераций.Добавить(ПартияЗапросКлассификатора);
	МассивОпераций.Добавить(ИмпортируемаяПартияЗапросКлассификатора);
	
	МассивОпераций.Добавить(ОрганизацияСозданиеКлассификатора);
	МассивОпераций.Добавить(ОрганизацияИзменениеКлассификатора);
	МассивОпераций.Добавить(ОрганизацияСменаСтатусаИзЧерновикаВОтменено);
	МассивОпераций.Добавить(ОрганизацияСменаСтатусаИзЧерновикаВАктуально);
	
	Возврат МассивОпераций;
	
КонецФункции

Функция БазовыеОперации() Экспорт
	
	МассивОпераций = Новый Массив();
	Возврат МассивОпераций;
	
КонецФункции

#КонецОбласти

#КонецЕсли
