#Область ПрограммныйИнтерфейс

// Переопределяет хозяйственную операцию в соответствии с видом операции документа.
// В процедуре можно установить значение параметра ХозяйственнаяОперация,
// которое соответствует переданному виду операции.
//
// Параметры:
//  ВидОперации - Строка, ПеречислениеСсылка.ВидыОпераций* - вид операции,
//  ХозяйственнаяОперация - СправочникСсылка.ХозяйственныеОперации - переопределяемое значение хозяйственной операции,
//  СсылкаНаДокумент - ДокументСсылка - ссылка на документ, для которого определяется хозяйственная операция.
//
Процедура УстановитьХозяйственнуюОперациюПоВидуОперацииДокумента(ВидОперации, ХозяйственнаяОперация,
	СсылкаНаДокумент = Неопределено) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти