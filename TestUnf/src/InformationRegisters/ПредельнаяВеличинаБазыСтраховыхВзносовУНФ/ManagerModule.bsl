#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Первоначальное заполнение регистра
Процедура УстановитьПредельнуюВеличинуБазыСтраховыхВзносов() Экспорт
	
	НаборЗаписей = РегистрыСведений.ПредельнаяВеличинаБазыСтраховыхВзносовУНФ.СоздатьНаборЗаписей();
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20100101';
	НоваяСтрока.РазмерФСС = 415000;
	НоваяСтрока.РазмерПФР = 415000;
	НоваяСтрока.РазмерФОМС = 415000;
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20110101';
	НоваяСтрока.РазмерФСС = 463000;
	НоваяСтрока.РазмерПФР = 463000;
	НоваяСтрока.РазмерФОМС = 463000;
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20120101';
	НоваяСтрока.РазмерФСС = 512000;
	НоваяСтрока.РазмерПФР = 512000;
	НоваяСтрока.РазмерФОМС = 512000;
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20130101';
	НоваяСтрока.РазмерФСС = 568000;
	НоваяСтрока.РазмерПФР = 568000;
	НоваяСтрока.РазмерФОМС = 568000;
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20140101';
	НоваяСтрока.РазмерФСС = 624000;
	НоваяСтрока.РазмерПФР = 624000;
	НоваяСтрока.РазмерФОМС = 624000;
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20150101';
	НоваяСтрока.РазмерФСС = 670000;
	НоваяСтрока.РазмерПФР = 711000;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20160101';
	НоваяСтрока.РазмерФСС = 718000;
	НоваяСтрока.РазмерПФР = 796000;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170101';
	НоваяСтрока.РазмерФСС = 755000;
	НоваяСтрока.РазмерПФР = 876000;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20180101';
	НоваяСтрока.РазмерФСС = 815000;
	НоваяСтрока.РазмерПФР = 1021000;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20190101';
	НоваяСтрока.РазмерФСС = 865000;
	НоваяСтрока.РазмерПФР = 1150000;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20200101';
	НоваяСтрока.РазмерФСС = 912000;
	НоваяСтрока.РазмерПФР = 1292000;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20210101';
	НоваяСтрока.РазмерФСС = 966000;
	НоваяСтрока.РазмерПФР = 1465000; 
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20220101';
	НоваяСтрока.РазмерФСС = 1032000;
	НоваяСтрока.РазмерПФР = 1565000;  
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20230101';
	НоваяСтрока.РазмерФСС = 1917000;
	НоваяСтрока.РазмерПФР = 1917000; 	
	НаборЗаписей.Записать();
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20240101';
	НоваяСтрока.РазмерФСС = 2225000;
	НоваяСтрока.РазмерПФР = 2225000; 	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Обновляет данные в регистре
//
// Параметры:
//  Идентификатор           - Строка - идентификатор классификатора в сервисе классификаторов.
//                            Определяется в процедуре ПриДобавленииКлассификаторов.
//  Версия                  - Число - номер загруженной версии;
//  Адрес                   - Строка - адрес двоичных данных файла обновления во
//                            временном хранилище;
//  Обработан               - Булево - если Ложь, при обработке файла обновления были ошибки
//                            и его необходимо загрузить повторно;
//  ДополнительныеПараметры - Структура - содержит дополнительные параметры обработки.
//                            Необходимо использовать для передачи значений в переопределяемый
//                            метод РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.ПриОбработкеОбластиДанных
//                            и метод ИнтеграцияПодсистемБИП.ПриОбработкеОбластиДанных..
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт
	
	Если Идентификатор <> "MaxInsurancePaymentBasis" Тогда
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ТекстXML = НалогиУНФ.ДвоичныеДанныеВСтроку(ДвоичныеДанные, КодировкаТекста.UTF8);
	
	ЗагружаемыеСведения = ОбщегоНазначения.ЗначениеИзСтрокиXML(ТекстXML);
	
	МодульРаботаСКлассификаторами = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		ТекущаяВерсия = МодульРаботаСКлассификаторами.ВерсияКлассификатора(ЗагружаемыеСведения.Идентификатор, Истина);
		Если ЗагружаемыеСведения.Версия < ТекущаяВерсия Тогда

			// В данную ветку процесс попадает когда пользователь хочет сбросить данные регистра до значений по умолчанию,
			// но версия загруженных данных классификатора выше версии из макета в метаданных.
			// Проверка возможности загрузки обновления из веб-сервиса.
			СведенияИзВебСервиса = НалогиУНФ.ПолучитьДанныеКлассификатораИзСервиса(ЗагружаемыеСведения.Идентификатор);
			Если СведенияИзВебСервиса = Неопределено
				Или СведенияИзВебСервиса.Версия < ТекущаяВерсия
				Или ВРег(СведенияИзВебСервиса.ПолноеИмя) <> ВРег(ЗагружаемыеСведения.ПолноеИмя) Тогда
				Возврат; // Пользователь загружал обновление из файла.
			КонецЕсли;
			// Загрузка обновления из веб-сервиса.
			ЗагружаемыеСведения = СведенияИзВебСервиса;
		КонецЕсли;
	КонецЕсли;
	
	// Поиск ссылок.
	ТаблицаЗагрузки = ЗагружаемыеСведения.Данные;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	Для Каждого СтрокаТаблицыЗагрузки Из ТаблицаЗагрузки Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Активность 	= Истина;
		НоваяЗапись.Период 		= СтрокаТаблицыЗагрузки.Период;
		НоваяЗапись.РазмерФСС 	= СтрокаТаблицыЗагрузки.РазмерФСС;
		НоваяЗапись.РазмерПФР 	= СтрокаТаблицыЗагрузки.РазмерПФР;
		НоваяЗапись.РазмерФОМС 	= СтрокаТаблицыЗагрузки.РазмерФОМС;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
	РегистрыСведений.ПредельнаяВеличинаБазыСтраховыхВзносов.Обновить(ТекстXML);
	
	Если МодульРаботаСКлассификаторами <> Неопределено Тогда
		МодульРаботаСКлассификаторами.УстановитьВерсиюКлассификатора(ЗагружаемыеСведения.Идентификатор, ЗагружаемыеСведения.Версия);
	КонецЕсли;
	
	Обработан = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли