#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс
	
// Возвращаемое значение:
// 	РасписаниеРегламентногоЗадания
//
Функция РасписаниеПоУмолчанию() Экспорт
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодПовтораВТечениеДня = 60;
	
	Возврат Расписание;
	
КонецФункции

// Обработчик обновления
//
Процедура ПеренестиДанныеИзРегламентногоЗадания() Экспорт
	
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.УдалитьОбработкаОчередиЗаданийБТС);
	НайденныеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Для Каждого Задание Из НайденныеЗадания Цикл
		Ссылка = Справочники.ОбработчикиОчередиЗаданий.ПолучитьСсылку(Новый УникальныйИдентификатор(Задание.Ключ));
		ОбработчикОчередиЗаданий = Ссылка.ПолучитьОбъект();
		Если ОбработчикОчередиЗаданий <> Неопределено Тогда
			ОбработчикОчередиЗаданий.Использование = Задание.Использование;
			ОбработчикОчередиЗаданий.Расписание = Новый ХранилищеЗначения(Задание.Расписание);
			ОбработчикОчередиЗаданий.ОбменДанными.Загрузка = Истина;
			ОбработчикОчередиЗаданий.Записать();
		КонецЕсли;
		Задание.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли
