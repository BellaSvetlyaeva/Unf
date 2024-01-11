&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитHTMLДокументаСообщение 		= Параметры.РеквизитHTMLДокументаСообщение;
	ИзменившиесяПараметрыПодключения 	= Параметры.ИзменившиесяПараметрыПодключения;
	
	// Загружаем таблицу, полученную как результат выполнения фонового задания в таблицу-реквизит формы
	Для каждого ИзменившийсяПараметр Из ИзменившиесяПараметрыПодключения Цикл
		НоваяСтрока = ИзмененныеПараметрыПодключения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ИзменившийсяПараметр);		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отложить(Команда)
	
	СохранитьДатуНапоминания();
	
	Если НапомнитьЧерез = "-1" Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"Отложить_Завершение", 
			ЭтотОбъект);
			
		Текст = НСтр("ru = 'Вы всегда можете посмотреть и при необходимости продлить срок действия лицензии и сертификата по гиперссылке 
                      |""Настройки обмена с контролирующими органами"" в разделе ""Настройки"" формы ""1С-Отчетность"".'");
		ПоказатьПредупреждение(ОписаниеОповещения, Текст);
		
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Отложить_Завершение(ВходящийКонтекст) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДатуНапоминания()
	
	// Определяем, когда в следующий раз нужно напоминать пользователю
	ДатаНапоминания = НачалоДня(ТекущаяДатаСеанса());
	Если НапомнитьЧерез = "1" Тогда
		ДатаНапоминания = ДатаНапоминания + 24 * 60 * 60 * 7;
	ИначеЕсли НапомнитьЧерез = "2" Тогда
		ДатаНапоминания = ДобавитьМесяц(ДатаНапоминания, 1);
	ИначеЕсли НапомнитьЧерез = "-1" Тогда
		ДатаНапоминания = '00010101000000';
	Иначе
		ДатаНапоминания = ДатаНапоминания + 24 * 60 * 60;
	КонецЕсли;
	 
    ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	
	КонтекстЭДОСервер.СохранитьДатуНапоминанияДляСертификатов(ИзмененныеПараметрыПодключения, ДатаНапоминания);
	КонтекстЭДОСервер.СохранитьДатуНапоминанияДляЛицензий(ИзмененныеПараметрыПодключения, ДатаНапоминания);
	КонтекстЭДОСервер.СохранитьДатуНапоминанияДляИзменившихсяРеквизитов(ИзмененныеПараметрыПодключения, ДатаНапоминания);
	КонтекстЭДОСервер.СохранитьДатуНапоминанияДляНовогоСертификата(ИзмененныеПараметрыПодключения, ДатаНапоминания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Href <> Неопределено Тогда
		
		Если СтрНайти(ДанныеСобытия.Href, "its.1c.ru") > 0 Тогда
			СтандартнаяОбработка = Истина;
			Возврат;
		КонецЕсли; 
		
		СтандартнаяОбработка = ЛОЖЬ;
		
		КонецМетки = СтрНайти(ДанныеСобытия.Href, "КонецСсылки");
		Если КонецМетки > 0 Тогда
			МеткиВСсылках = Новый Массив;
			МеткиВСсылках.Добавить("&ПросмотрОрганизации");
			МеткиВСсылках.Добавить("&ПросмотрСертификата");
			МеткиВСсылках.Добавить("&ОтправкаЗаявленияНаИзменениеРеквизитовПодключения");
			МеткиВСсылках.Добавить("&ПросмотрУчетнойЗаписи");
			
			Для Каждого МеткаВСсылке Из МеткиВСсылках Цикл
				
				НачалоМетки = СтрНайти(ДанныеСобытия.Href, МеткаВСсылке);
				Если НачалоМетки > 0 Тогда
					НачалоНомераВСсылке = НачалоМетки + СтрДлина(МеткаВСсылке);
					НомерВСсылке = Сред(ДанныеСобытия.Href, НачалоНомераВСсылке, КонецМетки - НачалоНомераВСсылке);
					
					Если МеткаВСсылке = "&ПросмотрОрганизации" ИЛИ МеткаВСсылке = "&ОтправкаЗаявленияНаИзменениеРеквизитовПодключения" Тогда
						
						ИндексОрганизации = НомерВСсылке - 1;
						
						// просмотр организации
						Организация = ИзмененныеПараметрыПодключения[ИндексОрганизации].Организация;
						
						Если Организация <> Неопределено Тогда
							Если МеткаВСсылке = "&ПросмотрОрганизации" Тогда
								ПоказатьЗначение(, Организация);
							Иначе
								
								Если ЗначениеЗаполнено(ИзмененныеПараметрыПодключения[ИндексОрганизации].ОтпечатокНовогоСертификата) Тогда
									НовыйСертификатСтруктура = Новый Структура("НовыйСертификат, ОтпечатокНовогоСертификата");
									ЗаполнитьЗначенияСвойств(НовыйСертификатСтруктура, ИзмененныеПараметрыПодключения[ИндексОрганизации]); 
								Иначе
									НовыйСертификатСтруктура = Неопределено;
								КонецЕсли;
								
								ДополнительныеПараметры = Новый Структура();
								ДополнительныеПараметры.Вставить("Организация",     Организация);
								ДополнительныеПараметры.Вставить("НовыйСертификат", НовыйСертификатСтруктура);
								
								Если ИзмененныеПараметрыПодключения.Количество() = 1 Тогда
									Закрыть(ДополнительныеПараметры);
								Иначе
									КонтекстЭДОКлиент.ВыполнитьДействиеПослеПоказаПредупрежденияОбИстеченииСертификатов(ДополнительныеПараметры, Неопределено);
								КонецЕсли;
								
							КонецЕсли;
								
						КонецЕсли;
						
					ИначеЕсли МеткаВСсылке = "&ПросмотрСертификата" Тогда
						
						// просмотр сертификата
						ИндексСертификата = НомерВСсылке - 1;
						ОтпечатокСертификата = ИзмененныеПараметрыПодключения[ИндексСертификата].ОтпечатокСертификата;
						
						КриптографияЭДКОКлиент.ПоказатьСертификат(Новый Структура("Отпечаток", ОтпечатокСертификата));
						#Если ВебКлиент Тогда
						Активизировать();
						#КонецЕсли
					
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

