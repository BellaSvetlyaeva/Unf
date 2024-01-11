#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Обработчик заполнения документа на основании параметра ДанныеЗаполнения.
//
// Параметры:
//  ДанныеЗаполнения - Структура - ДанныеЗаполнения.
//
Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	Если Не ДанныеЗаполнения.Свойство("Основание") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения.Основание) <> Тип("ДокументСсылка.ЗаданиеНаРаботу") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МИНИМУМ(НАЧАЛОПЕРИОДА(ЗаданиеНаРаботуРаботы.ДатаНачала, НЕДЕЛЯ)) КАК ДатаС
		|ПОМЕСТИТЬ втМинДата
		|ИЗ
		|	Документ.ЗаданиеНаРаботу.Работы КАК ЗаданиеНаРаботуРаботы
		|ГДЕ
		|	ЗаданиеНаРаботуРаботы.Ссылка = &Ссылка
		|	И ЗаданиеНаРаботуРаботы.НомерСтроки В(&МассивНомеровСтрок)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаданиеНаРаботу.Организация КАК Организация,
		|	ЗаданиеНаРаботу.Сотрудник КАК Сотрудник,
		|	ЗаданиеНаРаботу.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ЗаданиеНаРаботу.ВидЦен КАК ВидЦен,
		|	ЕСТЬNULL(втМинДата.ДатаС, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаС
		|ИЗ
		|	Документ.ЗаданиеНаРаботу КАК ЗаданиеНаРаботу
		|		ЛЕВОЕ СОЕДИНЕНИЕ втМинДата КАК втМинДата
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ЗаданиеНаРаботу.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаданиеНаРаботуРаботы.ВидРабот КАК ВидРабот,
		|	ЗаданиеНаРаботуРаботы.Заказчик КАК Заказчик,
		|	ЗаданиеНаРаботуРаботы.Номенклатура КАК Номенклатура,
		|	ЗаданиеНаРаботуРаботы.Характеристика КАК Характеристика,
		|	ЗаданиеНаРаботуРаботы.Цена КАК Расценка,
		|	ЗаданиеНаРаботуРаботы.Трудоемкость КАК Трудоемкость,
		|	ЗаданиеНаРаботуРаботы.ДатаНачала КАК ДатаНачала,
		|	ЗаданиеНаРаботуРаботы.ДатаОкончания КАК ДатаОкончания,
		|	ЗаданиеНаРаботуРаботы.Комментарий КАК Комментарий
		|ИЗ
		|	Документ.ЗаданиеНаРаботу.Работы КАК ЗаданиеНаРаботуРаботы
		|ГДЕ
		|	ЗаданиеНаРаботуРаботы.Ссылка = &Ссылка
		|	И ЗаданиеНаРаботуРаботы.НомерСтроки В(&МассивНомеровСтрок)";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Основание);
	Запрос.УстановитьПараметр("МассивНомеровСтрок", ДанныеЗаполнения.МассивСтрок);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[1].Выбрать();
	
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка, "Организация,Сотрудник,СтруктурнаяЕдиница,ДатаС");
		Если ЗначениеЗаполнено(ДатаС) Тогда
			ДатаПо = НачалоДня(КонецНедели(ДатаС));
		КонецЕсли;
	КонецЕсли;
	
	ВыборкаТЧ = МассивРезультатов[2].Выбрать();
	
	Пока ВыборкаТЧ.Следующий() Цикл
		
		НоваяСтрока = Операции.Добавить();
		НоваяСтрока.ВидЦен = ВыборкаШапка.ВидЦен;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаТЧ, "ВидРабот,Заказчик,Номенклатура,Характеристика,Расценка,Комментарий");
		
		НомерПоследнегоДняНедели = ДеньНедели(Мин(ДатаПо, ВыборкаТЧ.ДатаОкончания));
		ТекНомерДняНедели = ДеньНедели(ВыборкаТЧ.ДатаНачала);
		ОставшаясяТрудоемкость = ВыборкаТЧ.Трудоемкость;
		
		Пока ТекНомерДняНедели <= НомерПоследнегоДняНедели И ОставшаясяТрудоемкость > 0 Цикл
			
			ИмяДня = ИмяДняНедели(ТекНомерДняНедели);
			
			НачалоТекущегоДня   = '00010101000000';
			КонецТекущегоДня    = '00010101235959';
			НачалоСледующегоДня = '00010102';
			
			// Время начала = для первого дня время из Задания на работу, для последующих дней - пустое время
			// Длительность = константное время конца дня - время начала, но не более оставшейся трудоемкости
			// Время окончания = устанавливается на конец дня при 24 часах длительности
			НоваяСтрока[ИмяДня + "ВремяНачала"] = ?(ТекНомерДняНедели = ДеньНедели(ВыборкаТЧ.ДатаНачала), ВыделитьВремяИзДаты(ВыборкаТЧ.ДатаНачала), НачалоТекущегоДня);
			НоваяСтрока[ИмяДня + "Длительность"] = Мин((НачалоСледующегоДня - НоваяСтрока[ИмяДня + "ВремяНачала"]) / 3600, ОставшаясяТрудоемкость);
			
			Если НоваяСтрока[ИмяДня + "Длительность"] = 24 Тогда
				ВремяОкончания = КонецТекущегоДня;
			Иначе
				ВремяОкончания = НоваяСтрока[ИмяДня + "ВремяНачала"] + НоваяСтрока[ИмяДня + "Длительность"] * 3600;
			КонецЕсли;
			
			Если ВремяОкончания >= НачалоСледующегоДня Тогда
				ВремяОкончания = КонецТекущегоДня;
			КонецЕсли;
			
			НоваяСтрока[ИмяДня + "ВремяОкончания"] = ВремяОкончания;
			
			ТекНомерДняНедели = ТекНомерДняНедели + 1;
			ОставшаясяТрудоемкость = ОставшаясяТрудоемкость - НоваяСтрока[ИмяДня + "Длительность"];
			
		КонецЦикла;
		
		НоваяСтрока.Всего = ВыборкаТЧ.Трудоемкость - ОставшаясяТрудоемкость;
		НоваяСтрока.Сумма = НоваяСтрока.Всего * НоваяСтрока.Расценка;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	
	Если НЕ ДанныеЗаполнения = Неопределено И НЕ ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ДанныеЗаполнения.Вставить("ДокументОснование", ДанныеЗаполнения.Основание)
	КонецЕсли;
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДниНедели = Новый Соответствие;
	ДниНедели.Вставить(1, "Пн");
	ДниНедели.Вставить(2, "Вт");
	ДниНедели.Вставить(3, "Ср");
	ДниНедели.Вставить(4, "Чт");
	ДниНедели.Вставить(5, "Пт");
	ДниНедели.Вставить(6, "Сб");
	ДниНедели.Вставить(7, "Вс");
	
	ДниНеделиПредст = Новый Соответствие;
	ДниНеделиПредст.Вставить(1, НСтр("ru = 'Понедельник'"));
	ДниНеделиПредст.Вставить(2, НСтр("ru = 'Вторник'"));
	ДниНеделиПредст.Вставить(3, НСтр("ru = 'Среда'"));
	ДниНеделиПредст.Вставить(4, НСтр("ru = 'Четверг'"));
	ДниНеделиПредст.Вставить(5, НСтр("ru = 'Пятница'"));
	ДниНеделиПредст.Вставить(6, НСтр("ru = 'Суббота'"));
	ДниНеделиПредст.Вставить(7, НСтр("ru = 'Воскресенье'"));
	
	Для каждого СтрокаТЧ Из Операции Цикл
		
		Для Счетчик = 1 По 7 Цикл
			
			// 1. Заполнено время, но не заполнена длительность.
			Если (ЗначениеЗаполнено(СтрокаТЧ[ДниНедели.Получить(Счетчик) + "ВремяНачала"]) 
				ИЛИ ЗначениеЗаполнено(СтрокаТЧ[ДниНедели.Получить(Счетчик) + "ВремяОкончания"])) 
				И НЕ ЗначениеЗаполнено(СтрокаТЧ[ДниНедели.Получить(Счетчик) + "Длительность"])  Тогда
				
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не корректно заполнена колонка ""%1"" в строке %2.'"),
					ДниНеделиПредст.Получить(Счетчик), СтрокаТЧ.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Операции", СтрокаТЧ.НомерСтроки,
					ДниНедели.Получить(Счетчик) + "Длительность");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
				
			КонецЕсли;
			
			// 2. Заполнена длительность, но не заполнено время.
			Если ЗначениеЗаполнено(СтрокаТЧ[ДниНедели.Получить(Счетчик) + "Длительность"]) 
				И НЕ ЗначениеЗаполнено(СтрокаТЧ[ДниНедели.Получить(Счетчик) + "ВремяОкончания"])  Тогда
				
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не корректно заполнена колонка ""%1"" в строке %2.'"),
					ДниНеделиПредст.Получить(Счетчик), СтрокаТЧ.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Операции", СтрокаТЧ.НомерСтроки,
					ДниНедели.Получить(Счетчик) + "ВремяОкончания");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
				
			КонецЕсли;
		
		КонецЦикла;
	
	КонецЦикла;
	
	ПроверитьЗаполнениеНоменклатурыПоДоговоруОбслуживания(Отказ);
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.УчетВремени.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗаданияНаРаботу", ТаблицыДляДвижений, Движения, Отказ);
	
	// Биллинг
	Если ТаблицыДляДвижений.Свойство("ТаблицаВыполнениеДоговоровОбслуживания") Тогда
		ПроведениеДокументовУНФ.ОтразитьДвижения("ВыполнениеДоговоровОбслуживания", ТаблицыДляДвижений, Движения, Отказ);
	КонецЕсли;
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяДняНедели(НомерДняНедели)
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить("Пн");
	ДниНедели.Добавить("Вт");
	ДниНедели.Добавить("Ср");
	ДниНедели.Добавить("Чт");
	ДниНедели.Добавить("Пт");
	ДниНедели.Добавить("Сб");
	ДниНедели.Добавить("Вс");
	
	Возврат ДниНедели[НомерДняНедели - 1];
	
КонецФункции

Функция ВыделитьВремяИзДаты(Дата)
	
	Возврат '00010101' + (Дата - НачалоДня(Дата));
	
КонецФункции

Процедура ПроверитьЗаполнениеНоменклатурыПоДоговоруОбслуживания(Отказ)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБиллинг") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаОперации Из Операции Цикл
		Если ТипЗнч(СтрокаОперации.Заказчик) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			Договор = СтрокаОперации.Заказчик;
		ИначеЕсли ТипЗнч(СтрокаОперации.Заказчик) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			Договор = СтрокаОперации.Заказчик.Договор;
		Иначе
			Договор = Неопределено;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Договор) Тогда
			Продолжить;
		КонецЕсли;
		
		СвойстваДоговора = Справочники.ДоговорыКонтрагентов.СвойстваДоговораОбслуживания(Договор);
		
		Если Не СвойстваДоговора.ЭтоДоговорОбслуживания Тогда
			Продолжить;
		КонецЕсли;
		
		РазрешенаПродажаПозиции = Справочники.ДоговорыКонтрагентов.РазрешенаПродажаНоменклатурыПоДоговоруОбслуживания(
			Договор, СтрокаОперации.Номенклатура, СтрокаОперации.Характеристика);
		Если РазрешенаПродажаПозиции Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru = 'Запрещено проводить незапланированные товары/услуги по текущему договору обслуживания.'");
		ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаОперации.НомерСтроки, "Номенклатура");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СвойстваДоговора.ДоговорОбслуживанияТарифныйПлан,
			ПутьКДанным, , Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли