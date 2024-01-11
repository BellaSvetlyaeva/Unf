#Область СлужебныеПроцедурыИФункции

Функция PostEntriesPOST(Запрос)
		
	ДанныеЗаказов = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	КодУзлаОбмена = Запрос.ПараметрыЗапроса.Получить("SettingsExchangeCode");
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗагрузки = ОбменССайтом.ЗагрузитьЗаписьНаУслугиHTTPСервис(ДанныеЗаказов, КодУзлаОбмена);
	
	Если РезультатЗагрузки.УспешноЗагружено Тогда
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "text/xml;charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(РезультатЗагрузки.ОтветJSON, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.Авто);	
	Иначе
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-Type", "text/xml;charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(РезультатЗагрузки.ОписаниеОшибки, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.Авто);
	КонецЕсли;
	Возврат Ответ;
	
КонецФункции

Функция pingGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("ok");
	Возврат Ответ;
КонецФункции

#КонецОбласти
