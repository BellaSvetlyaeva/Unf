
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("НастройкаИнтеграции", ПараметрКоманды);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьФайлЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьФайлЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Или Результат.Количество() = 0 Или Не ЗначениеЗаполнено(Результат.Хранение) Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗагрузки = ИнтеграцияСИнтернетМагазиномВызовСервера.ЗагрузитьЗаказыИзФайла(
	ДополнительныеПараметры.НастройкаИнтеграции,
	Результат.Хранение
	);
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЗагрузки);
	
КонецПроцедуры

#КонецОбласти
