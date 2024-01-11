
#Область ПрограммныйИнтерфейс    

#Область УстаревшиеПроцедурыИФункции

// Устарела: следует использовать ФорматноЛогическийКонтроль.ПровестиФорматноЛогическийКонтроль.
// Функция выполняет проверку сумм фискальных строк,
// осуществляя форматно-логический контроль чека.
// Функция переопределяется методом ФорматноЛогическийКонтрольПереопределяемый.ПровестиФорматноЛогическийКонтроль.
//
// Параметры:
//   ОбщиеПараметры - Структура - Полученная ранее методом ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека,
//                    и заполненная данными чека.
//                    Содержит параметры для контроля:
//                      СпособФорматноЛогическогоКонтроля - ПеречислениеСсылка.СпособыФорматноЛогическогоКонтроля - если не заполнена,
//                                                         то контроль не выполняется,
//                      ДопустимоеРасхождениеФорматноЛогическогоКонтроля - Число - по умолчанию установленное 54-ФЗ отклонение - 0.01.
//
//   ПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудование - Не обязательный
//                              Если заполнено оборудование и не заполнен способ контроля в общих параметрах,
//                              то способ контроля и допустимое расхождение получаются из подключаемого оборудования.
//
Процедура ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры, ПодключаемоеОборудование = Неопределено) Экспорт
	
	ФорматноЛогическийКонтрольВызовСервера.ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры, ПодключаемоеОборудование);
	
КонецПроцедуры

// Устарела: следует использовать ФорматноЛогическийКонтроль.НуженФорматноЛогическийКонтроль.
// Функция выполняет проверку сумм фискальных строк,
// осуществляя форматно-логический контроль чека.
//
// Параметры:
//  ОбщиеПараметры - Структура
//
// Возвращаемое значение:
//  Булево
//
Функция НуженФорматноЛогическийКонтроль(ОбщиеПараметры) Экспорт
	
	Возврат ФорматноЛогическийКонтрольВызовСервера.НуженФорматноЛогическийКонтроль(ОбщиеПараметры);
	
КонецФункции

// Устарела: следует использовать ФорматноЛогическийКонтроль.ПривестиДанныеКТребуемомуФормату.
// Процедура приводит к формату согласованному с ФНС.
//
//  Параметры:
//    ОсновныеПараметры - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//    Отказ - Булево
//    ОписаниеОшибки - Строка
//    ИсправленыОсновныеПараметры - Булево
//
Процедура ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры) Экспорт
	
	ФорматноЛогическийКонтрольВызовСервера.ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры);
	
КонецПроцедуры

// Устарела: больше не используется
// Процедура приводит суммы позиций чека к сумме полной оплаты
// 
// Параметры:
//    ОсновныеПараметры - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//    ОбщаяСуммаЧека - Число - Общая сумма позиций чека
//    СуммаПолнойОплаты - Число - Сумма оплаченная
//    СуммаПередачиБезОплаты - Число - Сумма без оплаты
//    Отказ - Булево - Флаг отказа
//    ОписаниеОшибки - Строка - Описание ошибки
//
Процедура ПривестиСуммыПозицийЧекаКСуммеТаблицыОплат(ОсновныеПараметры, ОбщаяСуммаЧека, СуммаПолнойОплаты, СуммаПередачиБезОплаты, Отказ, ОписаниеОшибки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
