
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	времФорматОбмена = Неопределено;
	времБазаТоваров = Неопределено;
	времФайлОтчета = Неопределено;
	времФлагВыгрузки = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("ФорматОбмена", времФорматОбмена);
	Параметры.ПараметрыОборудования.Свойство("БазаТоваров", времБазаТоваров);
	Параметры.ПараметрыОборудования.Свойство("ФайлОтчета", времФайлОтчета);
	Параметры.ПараметрыОборудования.Свойство("ФлагВыгрузки",времФлагВыгрузки);
	
	ФорматОбмена = ?(времФорматОбмена = Неопределено, 0, времФорматОбмена);
	БазаТоваров  = ?(времБазаТоваров = Неопределено, "", времБазаТоваров);
	ФайлОтчета   = ?(времФайлОтчета = Неопределено, "", времФайлОтчета);
	ФлагВыгрузки = ?(времФлагВыгрузки = Неопределено, "", времФлагВыгрузки);
	
	
	// Налоги
	ЗаполнитьНалоги();
	
	времНомерНалога0 = Неопределено;
	времНомерНалога10 = Неопределено;
	времФлагНомерНалога18 = Неопределено;
	времФлагНомерНалога20 = Неопределено;
	времФлагНомерНалогаБезНДС = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("НомерНалога0", времНомерНалога0);
	Параметры.ПараметрыОборудования.Свойство("НомерНалога10", времНомерНалога10);
	Параметры.ПараметрыОборудования.Свойство("НомерНалога18", времФлагНомерНалога18);
	Параметры.ПараметрыОборудования.Свойство("НомерНалога20", времФлагНомерНалога20);
	Параметры.ПараметрыОборудования.Свойство("НомерНалогаБезНДС", времФлагНомерНалогаБезНДС);
	
	НомерНалога0 = ?(времНомерНалога0 = Неопределено, НомерНалога0, времНомерНалога0);
	НомерНалога10 = ?(времНомерНалога10 = Неопределено, НомерНалога10, времНомерНалога10);
	НомерНалога18 = ?(времФлагНомерНалога18 = Неопределено, НомерНалога18, времФлагНомерНалога18);
	НомерНалога20 = ?(времФлагНомерНалога20 = Неопределено, НомерНалога20, времФлагНомерНалога20);
	НомерНалогаБезНДС = ?(времФлагНомерНалогаБезНДС = Неопределено, НомерНалогаБезНДС, времФлагНомерНалогаБезНДС);
	
	Драйвер = НСтр("ru='Не требуется'");
	Версия  = НСтр("ru='Не определена'");
	
	МенеджерОфлайнОборудованияПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСозданииНаСервере(ЭтотОбъект, Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриОткрытии(ЭтотОбъект, Идентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БазаТоваровНачалоВыбораЗавершение(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		БазаТоваров = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БазаТоваровНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("БазаТоваровНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОфлайнОборудованияКлиент.НачатьВыборФайла(Оповещение, БазаТоваров);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагВыгрузкиНачалоВыбораЗавершение(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		ФлагВыгрузки = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ФлагВыгрузкиНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОфлайнОборудованияКлиент.НачатьВыборФайла(Оповещение, ФлагВыгрузки);
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ФайлОтчетаНачалоВыбораЗавершение(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		ФайлОтчета = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОтчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ФайлОтчетаНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОфлайнОборудованияКлиент.НачатьВыборФайла(Оповещение, ФлагВыгрузки);
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ТекстОшибкиОбщий = "";

	Если ПустаяСтрока(БазаТоваров) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru='Файл базы товаров не указан.'");
	КонецЕсли;
	
	Если ПустаяСтрока(ФайлОтчета) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Файл отчета не указан.'") 
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстОшибкиОбщий) Тогда
		
		НовыеЗначениеПараметров = Новый Структура;
		НовыеЗначениеПараметров.Вставить("ФорматОбмена", ФорматОбмена);
		НовыеЗначениеПараметров.Вставить("БазаТоваров",  БазаТоваров);
		НовыеЗначениеПараметров.Вставить("ФайлОтчета",   ФайлОтчета);
		НовыеЗначениеПараметров.Вставить("ФлагВыгрузки", ФлагВыгрузки);
		
		НовыеЗначениеПараметров.Вставить("НомерНалога0",  НомерНалога0);
		НовыеЗначениеПараметров.Вставить("НомерНалога10", НомерНалога10);
		НовыеЗначениеПараметров.Вставить("НомерНалога18", НомерНалога18);
		НовыеЗначениеПараметров.Вставить("НомерНалога20", НомерНалога20);
		НовыеЗначениеПараметров.Вставить("НомерНалогаБезНДС", НомерНалогаБезНДС);
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор", Идентификатор);
		Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
		
		МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСохраненииПараметров(
			ЭтотОбъект,
			Идентификатор,
			НовыеЗначениеПараметров);
		
		Закрыть(Результат);
		
	Иначе
		ОчиститьСообщения();
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(НСтр("ru= 'При проверке были обнаружены следующие ошибки:'")+ Символы.ПС + ТекстОшибкиОбщий);
	КонецЕсли;
	   
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();

	ВходныеПараметры  = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("БазаТоваров", БазаТоваров);
	времПараметрыУстройства.Вставить("ФайлОтчета", ФайлОтчета);
	времПараметрыУстройства.Вставить("ФлагВыгрузки", ФлагВыгрузки);
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Команда", "ТестУстройства");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ТестУстройстваЗавершение", ЭтотОбъект);
	МенеджерОфлайнОборудованияКлиент.НачатьВыполнениеКомандыОфлайнОборудования(ОписаниеОповещения,
		Идентификатор,
		ВходныеПараметры,
		времПараметрыУстройства,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНалогиПоУмолчанию(Команда)
	
	ЗаполнитьНалоги();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНалоги()
	
	Налоги = ОфлайнОборудованиеАтолККМВызовСервера.НомераНалоговНаККМПоУмолчанию();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Налоги,
		"НомерНалога0, НомерНалога10, НомерНалога18, НомерНалога20, НомерНалогаБезНДС");
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройстваЗавершение(РезультатКоманды, ВыходныеПараметры) Экспорт
	
	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
	                           И ВыходныеПараметры.Количество() >= 2,
	                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
	                           "");
	Если РезультатКоманды.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти