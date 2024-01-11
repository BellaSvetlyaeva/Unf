#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТаблицаПроверяемыхМероприятий = Новый ТаблицаЗначений;
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("СотрудникЗаписи", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("ВидМероприятия", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМероприятийТрудовойДеятельности"));
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("ДатаОтмены", Новый ОписаниеТипов("Дата"));
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("ДатаМероприятия", Новый ОписаниеТипов("Дата"));
	ТаблицаПроверяемыхМероприятий.Колонки.Добавить("ИдМероприятия", Новый ОписаниеТипов("УникальныйИдентификатор"));
	
	Для Каждого СтрокаМероприятия Из Мероприятия Цикл
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, СтрокаМероприятия.ДатаОтмены,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Мероприятия", СтрокаМероприятия.НомерСтроки, "ДатаОтмены"),
			Отказ, НСтр("ru = 'Дата отмены'"), , , Ложь);
		
		Если Не ЗначениеЗаполнено(СтрокаМероприятия.ДатаОтмены) Тогда
			
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, СтрокаМероприятия.ДатаМероприятия,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Мероприятия", СтрокаМероприятия.НомерСтроки, "ДатаМероприятия"),
				Отказ, НСтр("ru = 'Дата мероприятия'"), , , Ложь);
			
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, СтрокаМероприятия.ДатаДокументаОснования,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Мероприятия", СтрокаМероприятия.НомерСтроки, "ДатаДокументаОснования"),
				Отказ, НСтр("ru = 'Дата документа-основания'"), , , Ложь);
			
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, СтрокаМероприятия.ДатаВторогоДокументаОснования,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Мероприятия", СтрокаМероприятия.НомерСтроки, "ДатаВторогоДокументаОснования"),
				Отказ, НСтр("ru = 'Дата второго документа-основания'"), , , Ложь);
			
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, СтрокаМероприятия.ДатаС,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Мероприятия", СтрокаМероприятия.НомерСтроки, "ДатаС"),
				Отказ, НСтр("ru = 'Дата С'"), , , Ложь);
			
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, СтрокаМероприятия.ДатаПо,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Мероприятия", СтрокаМероприятия.НомерСтроки, "ДатаПо"),
				Отказ, НСтр("ru = 'Дата По'"), , , Ложь);
			
		КонецЕсли;
		
		Если Не СтрокаМероприятия.ФиксСтрока Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаМероприятия.НомерДокументаОснования) Тогда
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Не заполнена колонка ""Номер документа-основания"" в строке %1 списка ""Мероприятия""'"),
					СтрокаМероприятия.НомерСтроки);
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
					"Мероприятия[" + Формат(СтрокаМероприятия.НомерСтроки - 1, "ЧН=; ЧГ=") + "].НомерДокументаОснования", "Объект", Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтрокаМероприятия.ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Прием
			Или СтрокаМероприятия.ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Увольнение Тогда
			
			ЗаполнитьЗначенияСвойств(ТаблицаПроверяемыхМероприятий.Добавить(), СтрокаМероприятия);
		КонецЕсли;
		
		ЭлектронныеТрудовыеКнижки.ПроверкаЗаполненияВторогоДокументаОснования(
			СтрокаМероприятия, Ссылка, Отказ, "Мероприятия[" + Формат(СтрокаМероприятия.НомерСтроки - 1, "ЧН=; ЧГ=") + "]",
			СтрШаблон(НСтр("ru = 'В строке %1'"), СтрокаМероприятия.НомерСтроки));
		
		Если СтрокаМероприятия.ДатаМероприятия >= '20210701' И Не ЗначениеЗаполнено(СтрокаМероприятия.ДатаОтмены) Тогда
			Если ЗначениеЗаполнено(СтрокаМероприятия.ВидМероприятия) Тогда
				
				ИменаПолей = ЭлектронныеТрудовыеКнижкиКлиентСервер.ИменаДоступныхПолейВидовМероприятий()[СтрокаМероприятия.ВидМероприятия];
				Если СтрНайти(ИменаПолей, "ТрудоваяФункция") > 0 Тогда
					Если ЗначениеЗаполнено(СтрокаМероприятия.Должность)
						И Не ЗначениеЗаполнено(СтрокаМероприятия.КодПоОКЗ) Тогда
						
						ПутьКПолю = "Мероприятия[" + Формат(СтрокаМероприятия.НомерСтроки - 1, "ЧРГ=") + "].КодПоОКЗ";
						ТекстСообщения = СтрШаблон(
							НСтр("ru = 'Не заполнена колонка ""Код по ОКЗ"" в строке %1 списка ""Мероприятия""'"),
							СтрокаМероприятия.НомерСтроки);
						ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, ПутьКПолю, "Объект", Отказ);
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаПроверяемыхМероприятий.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ТаблицаПроверяемыхМероприятий", ТаблицаПроверяемыхМероприятий);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ТаблицаПроверяемыхМероприятий.НомерСтроки КАК НомерСтроки,
			|	ТаблицаПроверяемыхМероприятий.Сотрудник КАК Сотрудник,
			|	ТаблицаПроверяемыхМероприятий.ИдМероприятия КАК ИдМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ДатаОтмены КАК ДатаОтмены,
			|	ТаблицаПроверяемыхМероприятий.ДатаМероприятия КАК ДатаМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ВидМероприятия КАК ВидМероприятия,
			|	ТаблицаПроверяемыхМероприятий.СотрудникЗаписи КАК СотрудникЗаписи
			|ПОМЕСТИТЬ ВТТаблицаПроверяемыхМероприятий
			|ИЗ
			|	&ТаблицаПроверяемыхМероприятий КАК ТаблицаПроверяемыхМероприятий
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТаблицаПроверяемыхМероприятий.НомерСтроки КАК НомерСтроки,
			|	ТаблицаПроверяемыхМероприятий.Сотрудник КАК Сотрудник,
			|	Мероприятия.ИдМероприятия КАК ИдМероприятия,
			|	Мероприятия.ДатаМероприятия КАК ДатаМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ВидМероприятия КАК ВидМероприятия,
			|	ТаблицаПроверяемыхМероприятий.СотрудникЗаписи КАК СотрудникЗаписи,
			|	Мероприятия.Регистратор КАК Регистратор
			|ПОМЕСТИТЬ ВТМероприятияИнформационнойБазы
			|ИЗ
			|	ВТТаблицаПроверяемыхМероприятий КАК ТаблицаПроверяемыхМероприятий
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК МероприятияОтмененные
			|			ПО Мероприятия.Организация = МероприятияОтмененные.Организация
			|				И Мероприятия.ИдМероприятия = МероприятияОтмененные.ИдМероприятия
			|				И (МероприятияОтмененные.Регистратор <> &Ссылка)
			|				И (МероприятияОтмененные.Отменено)
			|		ПО ТаблицаПроверяемыхМероприятий.Сотрудник = Мероприятия.ФизическоеЛицо
			|			И ТаблицаПроверяемыхМероприятий.СотрудникЗаписи = Мероприятия.Сотрудник
			|			И ТаблицаПроверяемыхМероприятий.ВидМероприятия = Мероприятия.ВидМероприятия
			|			И (Мероприятия.Регистратор <> &Ссылка)
			|			И (НЕ Мероприятия.Отменено)
			|			И (Мероприятия.Организация = &Организация)
			|ГДЕ
			|	МероприятияОтмененные.ИдМероприятия ЕСТЬ NULL
			|	И ТаблицаПроверяемыхМероприятий.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаПроверяемыхМероприятий.НомерСтроки КАК НомерСтроки,
			|	ТаблицаПроверяемыхМероприятий.Сотрудник КАК Сотрудник,
			|	ТаблицаПроверяемыхМероприятий.ИдМероприятия КАК ИдМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ДатаМероприятия КАК ДатаМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ВидМероприятия КАК ВидМероприятия,
			|	ТаблицаПроверяемыхМероприятий.СотрудникЗаписи КАК СотрудникЗаписи,
			|	МИНИМУМ(ТаблицаПроверяемыхМероприятийДубли.НомерСтроки) КАК НомерИсходнойСтроки,
			|	НЕОПРЕДЕЛЕНО КАК Регистратор
			|ИЗ
			|	ВТТаблицаПроверяемыхМероприятий КАК ТаблицаПроверяемыхМероприятий
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаПроверяемыхМероприятий КАК ТаблицаПроверяемыхМероприятийДубли
			|		ПО ТаблицаПроверяемыхМероприятий.Сотрудник = ТаблицаПроверяемыхМероприятийДубли.Сотрудник
			|			И ТаблицаПроверяемыхМероприятий.СотрудникЗаписи = ТаблицаПроверяемыхМероприятийДубли.СотрудникЗаписи
			|			И ТаблицаПроверяемыхМероприятий.ВидМероприятия = ТаблицаПроверяемыхМероприятийДубли.ВидМероприятия
			|			И ТаблицаПроверяемыхМероприятий.НомерСтроки > ТаблицаПроверяемыхМероприятийДубли.НомерСтроки
			|			И (ТаблицаПроверяемыхМероприятийДубли.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1))
			|ГДЕ
			|	ТаблицаПроверяемыхМероприятий.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
			|
			|СГРУППИРОВАТЬ ПО
			|	ТаблицаПроверяемыхМероприятий.НомерСтроки,
			|	ТаблицаПроверяемыхМероприятий.Сотрудник,
			|	ТаблицаПроверяемыхМероприятий.ИдМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ДатаМероприятия,
			|	ТаблицаПроверяемыхМероприятий.ВидМероприятия,
			|	ТаблицаПроверяемыхМероприятий.СотрудникЗаписи
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	МероприятияИнформационнойБазы.НомерСтроки,
			|	МероприятияИнформационнойБазы.Сотрудник,
			|	МероприятияИнформационнойБазы.ИдМероприятия,
			|	МероприятияИнформационнойБазы.ДатаМероприятия,
			|	МероприятияИнформационнойБазы.ВидМероприятия,
			|	МероприятияИнформационнойБазы.СотрудникЗаписи,
			|	НЕОПРЕДЕЛЕНО,
			|	МероприятияИнформационнойБазы.Регистратор
			|ИЗ
			|	ВТМероприятияИнформационнойБазы КАК МероприятияИнформационнойБазы
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаПроверяемыхМероприятий КАК ТаблицаПроверяемыхМероприятий
			|		ПО МероприятияИнформационнойБазы.ИдМероприятия = ТаблицаПроверяемыхМероприятий.ИдМероприятия
			|			И (ТаблицаПроверяемыхМероприятий.ДатаОтмены <> ДАТАВРЕМЯ(1, 1, 1))
			|ГДЕ
			|	ТаблицаПроверяемыхМероприятий.ИдМероприятия ЕСТЬ NULL
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(Выборка.Регистратор) Тогда
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Повторяется мероприятие ""%1"" по сотруднику %2.'"),
					Выборка.ВидМероприятия,
					Выборка.СотрудникЗаписи);
				
			Иначе
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Мероприятие ""%1"" сотрудника %2 уже зарегистрировано документом %3.'"),
					Выборка.ВидМероприятия,
					Выборка.СотрудникЗаписи,
					Выборка.Регистратор);
				
			КонецЕсли;
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
				"Мероприятия[" + Формат(Выборка.НомерСтроки - 1, "ЧН=; ЧГ=") + "].Сотрудник", "Объект", Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = Документы.РегистрацияТрудовойДеятельности.ДанныеДляПроведенияДокумента(Ссылка);
	
	ПараметрыФормирования = ЭлектронныеТрудовыеКнижки.ПараметрыФормированияДвиженийМероприятийТрудовойДеятельности();
	ПараметрыФормирования.ДополнитьСведениямиОТерриториальныхУсловиях = Ложь;
	ПараметрыФормирования.ДополнитьСведениямиОКодахПоОКЗ = Ложь;
	
	ЭлектронныеТрудовыеКнижки.СформироватьДвиженияМероприятийТрудовойДеятельности(
		Движения.МероприятияТрудовойДеятельности,
		ДанныеДляПроведения.МероприятияТрудовойДеятельности,
		ПараметрыФормирования);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли