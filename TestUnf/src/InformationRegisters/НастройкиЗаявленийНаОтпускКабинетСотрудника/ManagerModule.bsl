#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция НастройкиЗаявокНаОтпуск() Экспорт
	
	Настройки = РегистрыСведений.НастройкиЗаявленийНаОтпускКабинетСотрудника.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	СтруктураНастроек = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(
							Настройки, Метаданные.РегистрыСведений.НастройкиЗаявленийНаОтпускКабинетСотрудника);
	
	Возврат СтруктураНастроек;

КонецФункции

Процедура СохранитьНовыеНастройки(СохраняемыеНастройки) Экспорт

	НаборЗаписей = РегистрыСведений.НастройкиЗаявленийНаОтпускКабинетСотрудника.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), СохраняемыеНастройки);
	Иначе
		ЗаполнитьЗначенияСвойств(НаборЗаписей[0], СохраняемыеНастройки);
	КонецЕсли;
	НаборЗаписей.Записать();

КонецПроцедуры


#КонецОбласти

#КонецЕсли
