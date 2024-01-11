#Область ПрограммныйИнтерфейс

// Устанавливает картинку для комментария в указанной группе.
// 
// Параметры:
// 	ГруппаДополнительно - ГруппаФормы - группа, в которой устанавливается картинка,
// 	Комментарий - Строка - текст комментария.
Процедура УстановитьКартинкуДляКомментария(ГруппаДополнительно, Комментарий) Экспорт

	Если ЗначениеЗаполнено(Комментарий) Тогда
		ГруппаДополнительно.Картинка = БиблиотекаКартинок.НаписатьSMS;
	Иначе
		ГруппаДополнительно.Картинка = Новый Картинка;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти