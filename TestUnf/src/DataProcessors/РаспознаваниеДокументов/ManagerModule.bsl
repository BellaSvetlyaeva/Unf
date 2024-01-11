#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОтправитьФайлыНаРаспознавание(Файлы) Экспорт
	
	ДлительныеОперации.СообщитьПрогресс(, НСтр("ru = 'Создание задания распознавания документов...'"));
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Пользователь", Пользователи.ТекущийПользователь());
	
	Источник = Перечисления.ИсточникиПолученияФайлов.Вручную;
	
	Попытка
		
		ИменаФайлов = Новый Массив;
		Для Каждого Файл Из Файлы Цикл
			ИменаФайлов.Добавить(Файл.ИмяФайла);
		КонецЦикла;
		
		ЗаписьЖурналаРегистрации(
			РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Отправлены файлы для распознавания:'") + Символы.ПС + СтрСоединить(ИменаФайлов, ", ")
		);
		
		ДатаСоздания = ТекущаяУниверсальнаяДата();
		
		ИдентификаторЗадания = РаспознаваниеДокументовSDK.СоздатьЗаданиеРаспознавания(ИменаФайлов, ДатаСоздания);
		
		ЗаписьЖурналаРегистрации(
			РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Получен идентификатор нового задания:'") + Символы.ПС + ИдентификаторЗадания
		);
		
		РегистрыСведений.ПредставлениеЗаданийРаспознаваниеДокументов.Записать(
			ИдентификаторЗадания, ДатаСоздания, ИменаФайлов, Источник);
		
		Результат = РаспознаваниеДокументовSDK.ПолучитьСостояниеОбработкиЗадания(ИдентификаторЗадания);
		
		Если Результат.ОбработкаЗавершена Или Результат.АдресаЗагрузкиФайлов.Количество() = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Произошла ошибка при создании задания. Попробуйте повторить позже.'");
		КонецЕсли;
		
		РегистрыСведений.СостоянияЗаданийРаспознаваниеДокументов.ИзменитьСтатусОбработкиЗадания(
			ИдентификаторЗадания,
			Перечисления.СтатусыНаСервисеРаспознаваниеДокументов.Обрабатывается
		);
		
		ИндексФайла = 0;
		КоличествоФайлов = Файлы.Количество();
		Для Каждого АдресЗагрузкиФайла Из Результат.АдресаЗагрузкиФайлов Цикл
			
			ДлительныеОперации.СообщитьПрогресс(, СтрШаблон(
				НСтр("ru = 'Отправка файла %1 (%2 из %3)...'"),
				Файлы[ИндексФайла].ИмяФайла,
				ИндексФайла + 1,
				КоличествоФайлов
			));
			
			Попытка
				ИдентификаторФайла = РаспознаваниеДокументовSDK.ЗагрузкаФайлаПоАдресу(
					АдресЗагрузкиФайла,
					Файлы[ИндексФайла].ДвоичныеДанные
				);
			Исключение
				// Не удалось загрузить файл по адресу, который выдал сервис
				Продолжить;
			КонецПопытки;
			
			РегистрыСведений.ИсходныеДанныеЗаданийРаспознаваниеДокументов.Записать(
				ИдентификаторФайла,
				ИдентификаторЗадания,
				ДатаСоздания,
				Файлы[ИндексФайла],
				ПараметрыЗадания
			);
			
			ИндексФайла = ИндексФайла + 1;
			
		КонецЦикла;
		
		// Замер производительности
		РезультатОбратнойСвязи = РаспознаваниеДокументов.ОписаниеОбратнойСвязи("Отправлен");
		Пакет = Новый Структура("created", РезультатОбратнойСвязи);
		РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(Результат, Пакет);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(
			РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			НСтр("ru = 'Ошибка при создании задания распознавания'") + Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Произошла ошибка при отправке:
			           |%1'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
