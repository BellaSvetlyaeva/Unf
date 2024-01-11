
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	Если СтруктураДанных <> Неопределено Тогда
		ДокументВид 				= СтруктураДанных.ДокументВид;
		ДокументДатаВыдачи 			= СтруктураДанных.ДокументДатаВыдачи;
		ДокументКемВыдан 			= СтруктураДанных.ДокументКемВыдан;
		ДокументКодПодразделения 	= СтруктураДанных.ДокументКодПодразделения;
		ДокументНомер 				= СтруктураДанных.ДокументНомер;
		ДокументСерия 				= СтруктураДанных.ДокументСерия;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ДокументВид", 				ДокументВид);
	СтруктураДанных.Вставить("ДокументСерия", 				ДокументСерия);
	СтруктураДанных.Вставить("ДокументНомер", 				ДокументНомер);
	СтруктураДанных.Вставить("ДокументДатаВыдачи", 			ДокументДатаВыдачи);
	СтруктураДанных.Вставить("ДокументКемВыдан", 			ДокументКемВыдан);
	СтруктураДанных.Вставить("ДокументКодПодразделения",	ДокументКодПодразделения);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(ДокументВид) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан вид документа.'"),, "ДокументВид",, Отказ);
	КонецЕсли;
	
	КодВидаДокумента = ДокументооборотСКОВызовСервера.ПолучитьКодВидаДокументаФизическогоЛица(ДокументВид);
	Если ЗначениеЗаполнено(ДокументВид) И КодВидаДокумента <> "07" И КодВидаДокумента <> "10"
		И КодВидаДокумента <> "11" И КодВидаДокумента <> "12" И КодВидаДокумента <> "13" И КодВидаДокумента <> "15"
		И КодВидаДокумента <> "19" И КодВидаДокумента <> "21" И КодВидаДокумента <> "24" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Вид документа не поддерживается.'"),, "ДокументВид",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СокрЛП(ДокументСерия) + СокрЛП(ДокументНомер)) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заданы серия и номер документа.'"),,
			"ДокументСерия",, Отказ);
	КонецЕсли;
	
	Если СтрДлина(СокрЛП(ДокументСерия) + СокрЛП(ДокументНомер)) > 25 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Длина серии и номера документа больше 25 символов.'"),,
			"ДокументСерия",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументДатаВыдачи) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана дата выдачи документа.'"),,
			"ДокументДатаВыдачи",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументКемВыдан) И КодВидаДокумента = "21" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование органа, выдавшего документ.'"),,
			"ДокументКемВыдан",, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументКодПодразделения) И СтрДлина(СокрЛП(ДокументКодПодразделения)) <> 7 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Длина кода подразделения не 7 символов.'"),,
			"ДокументКодПодразделения",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

#КонецОбласти
