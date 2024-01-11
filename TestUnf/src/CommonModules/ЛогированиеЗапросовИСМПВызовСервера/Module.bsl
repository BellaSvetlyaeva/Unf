#Область СлужебныйПрограммныйИнтерфейс

// Получает содержимое текущего лога запросов и помещает во временной хранилище.
// 
// Параметры:
// 	УникальныйИдентификаторФормы - УникальныйИдентификатор - Уникальный идентификатор формы.
// Возвращаемое значение:
// 	Строка - Адрес содержания лога во временном хранилище.
Функция АдресСодержанияЛоговЗапросов(УникальныйИдентификаторФормы) Экспорт
	
	ПараметрыЛогирования = ЛогированиеЗапросовИСМП.ПараметрыЛогированияЗапросов();
	СодержаниеЛогаЗапросов = ЛогированиеЗапросовИС.СодержаниеЛогаЗапросов(ПараметрыЛогирования);
	
	Возврат ПоместитьВоВременноеХранилище(СодержаниеЛогаЗапросов, УникальныйИдентификаторФормы);
	
КонецФункции

// см. ЛогированиеЗапросовИС.ВключитьЛогированиеЗапросов
Процедура ВключитьЛогированиеЗапросов(ЗаписыватьСекунд = 300, НовыйЛог = Ложь) Экспорт
	
	ПараметрыЛогирования = ЛогированиеЗапросовИСМП.ПараметрыЛогированияЗапросов();
	ЛогированиеЗапросовИС.ВключитьЛогированиеЗапросов(ПараметрыЛогирования, ЗаписыватьСекунд, НовыйЛог);
	ЛогированиеЗапросовИСМП.УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Выводит содержимое в лог запросов.
// 
// Параметры:
//  ТекстДляВывода            - Строка - Текст для вывода в лог
//  Штрихкод                  - Неопределено, Массив из Структура - список данных штрихкодов для вывода в лог
//  РезультатРазбораШтрихКода - Неопределено, Массив Из Структура - даннные разбора штрихкода для вывода в лог
Процедура Вывести(ТекстДляВывода, Штрихкод = Неопределено, РезультатРазбораШтрихКода = Неопределено) Экспорт
	
	ДанныеЗаписи = ЛогированиеЗапросовИС.НоваяСтруктураДанныхЗаписи();
	ДанныеЗаписи.ТекстОшибки               = ТекстДляВывода;
	ДанныеЗаписи.Штрихкод                  = Штрихкод;
	ДанныеЗаписи.РезультатРазбораШтрихКода = РезультатРазбораШтрихКода;
	
	ПараметрыЛогированияЗапросов = ЛогированиеЗапросовИСМП.ПараметрыЛогированияЗапросов();
	ЛогированиеЗапросовИС.Вывести(ДанныеЗаписи, ПараметрыЛогированияЗапросов);
	
КонецПроцедуры

// см. ЛогированиеЗапросовИС.ВыполняетсяЛогированиеЗапросов
Функция ВыполняетсяЛогированиеЗапросов() Экспорт
	ПараметрыЛогирования = ЛогированиеЗапросовИСМП.ПараметрыЛогированияЗапросов();
	Возврат ЛогированиеЗапросовИС.ВыполняетсяЛогированиеЗапросов(ПараметрыЛогирования);
КонецФункции

#КонецОбласти