#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьСостояниеЗачисленияЗарплатыПоДокументу(
		ПервичныйДокумент,
		Отказ,
		ОбменСБанкамиПоЗарплатнымПроектам.СостояниеЗачисленияЗарплатыДляПодтверждения(Ссылка),
		,
		Ссылка);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		МетаданныеОбъекта = Метаданные();
		Для Каждого ПараметрЗаполнения Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(ПараметрЗаполнения.Ключ)<>Неопределено Тогда
				ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
			Иначе
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ПараметрЗаполнения.Ключ) Тогда
					ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ЗаполняемыеЗначения = Новый Структура;
		ЗаполняемыеЗначения.Вставить("Ответственный");
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
		Ответственный = ЗаполняемыеЗначения.Ответственный;
		
		Если ДанныеЗаполнения.Свойство("Сотрудники") Тогда
			Для Каждого СтрокаЗначенийЗаполнения Из ДанныеЗаполнения.Сотрудники Цикл
				ЗаполнитьЗначенияСвойств(Сотрудники.Добавить(), СтрокаЗначенийЗаполнения);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтандартнаяОбработка = Истина;
	ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ПервичныйДокумент", ПервичныйДокумент);
		Запрос.УстановитьПараметр("Сотрудники", Сотрудники.Выгрузить());
		Запрос.УстановитьПараметр("ХешФайла", ХешФайла);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодтверждениеЗачисленияЗарплаты.Ссылка
		|ИЗ
		|	Документ.ПодтверждениеЗачисленияЗарплаты КАК ПодтверждениеЗачисленияЗарплаты
		|ГДЕ
		|	ПодтверждениеЗачисленияЗарплаты.ПервичныйДокумент = &ПервичныйДокумент
		|	И ПодтверждениеЗачисленияЗарплаты.Ссылка <> &Ссылка
		|	И ПодтверждениеЗачисленияЗарплаты.Проведен
		|	И ПодтверждениеЗачисленияЗарплаты.ХешФайла = &ХешФайла";
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если НЕ Результат.Пустой() Тогда
			ТекстОшибки = НСтр("ru = 'Подтверждение по первичному документу уже зарегистрировано.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ПервичныйДокумент", , Отказ);
		КонецЕсли;
		
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПлатежныеДокументыПеречисленияЗарплаты.ПлатежныйДокумент КАК ПлатежныйДокумент
		|ИЗ
		|	РегистрСведений.ПлатежныеДокументыПеречисленияЗарплаты КАК ПлатежныеДокументыПеречисленияЗарплаты
		|ГДЕ
		|	ПлатежныеДокументыПеречисленияЗарплаты.ПлатежныйДокумент = &ПервичныйДокумент";
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Ведомости = Новый Массив;
		Если Результат.Пустой() Тогда
			Ведомости.Добавить(ПервичныйДокумент);
		Иначе	
			Ведомости = ОбменСБанкамиПоЗарплатнымПроектам.ВедомостиПлатежногоДокументаПеречисленияЗарплаты(ПервичныйДокумент)
		КонецЕсли;
		
		ДанныеВедомостей = ВзаиморасчетыССотрудниками.ДанныеВедомостейДляОплатыДокументом(ПервичныйДокумент, Ведомости,, Неопределено);
		
		ПараметрыОтбора = Новый Структура("ФизическоеЛицо");
		ДанныеВедомостей.Индексы.Добавить("ФизическоеЛицо");
		Для Каждого Сотрудник Из Сотрудники Цикл
			
			ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Сотрудник);
			
			ДанныеФизлица = ДанныеВедомостей.Скопировать(ПараметрыОтбора, "СуммаКВыплате, КомпенсацияЗаЗадержкуЗарплаты");
			
			Если ДанныеФизлица.Количество() = 0 Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'В строке №%1 указан сотрудник, отсутствующий в первичном документе.'"),
						Сотрудник.НомерСтроки), 
					ЭтотОбъект, 
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", Сотрудник.НомерСтроки, "ФизическоеЛицо"),, 
					Отказ);
				Продолжить;
			КонецЕсли;	
			
			Если Сотрудник.Сумма <> ДанныеФизлица.Итог("СуммаКВыплате") + ДанныеФизлица.Итог("КомпенсацияЗаЗадержкуЗарплаты") Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Сумма, зачисленная по сотруднику %1, не совпадает с суммой первичного документа.'"),
						Сотрудник.ФизическоеЛицо), 
					ЭтотОбъект, 
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", Сотрудник.НомерСтроки, "Сумма"),, 
					Отказ);
			КонецЕсли;	
			
		КонецЦикла;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЛицевыеСчетаФизическихЛицДляРегистрации = ЛицевыеСчетаФизическихЛицДляРегистрации();
	ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьЛицевыеСчетаФизическихЛиц(ЛицевыеСчетаФизическихЛицДляРегистрации);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДокументов = ДанныеДляПроведения();
	
	Для каждого ДанныеДокумента Из ДанныеДокументов Цикл
		
		// Суммы по ведомости не зачислены.
		ВзаиморасчетыССотрудниками.ЗарегистрироватьНевыплатуПоВедомости(Движения, Отказ, ДанныеДокумента.Ключ, ДанныеДокумента.Значение);
		
		Если НЕ Отказ Тогда
			УчетНДФЛ.ЗарегистрироватьНевыплатуДокументом(Движения, Отказ, ДанныеДокумента.Ключ, ДанныеДокумента.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ПервичныйДокумент", ПервичныйДокумент);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлатежныеДокументыПеречисленияЗарплаты.ПлатежныйДокумент КАК ПлатежныйДокумент,
	|	ПлатежныеДокументыПеречисленияЗарплаты.Ведомость КАК Ведомость,
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.КВыплате + ВедомостьНаВыплатуЗарплатыВБанкЗарплата.КомпенсацияЗаЗадержкуЗарплаты КАК Сумма
	|ПОМЕСТИТЬ ВТВедомостиПлатежногоДокумента
	|ИЗ
	|	РегистрСведений.ПлатежныеДокументыПеречисленияЗарплаты КАК ПлатежныеДокументыПеречисленияЗарплаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьНаВыплатуЗарплатыВБанкЗарплата
	|		ПО ПлатежныеДокументыПеречисленияЗарплаты.Ведомость = ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка
	|ГДЕ
	|	ПлатежныеДокументыПеречисленияЗарплаты.ПлатежныйДокумент = &ПервичныйДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.ФизическоеЛицо,
	|	СУММА(ПодтверждениеЗачисленияЗарплатыСотрудники.Сумма) КАК НезачисленнаяСумма
	|ПОМЕСТИТЬ ВТНезачисленныеСуммы
	|ИЗ
	|	Документ.ПодтверждениеЗачисленияЗарплаты.Сотрудники КАК ПодтверждениеЗачисленияЗарплатыСотрудники
	|ГДЕ
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.Ссылка = &Ссылка
	|	И ПодтверждениеЗачисленияЗарплатыСотрудники.РезультатЗачисленияЗарплаты <> ЗНАЧЕНИЕ(Перечисление.РезультатыЗачисленияЗарплаты.Зачислено)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ПервичныйДокумент КАК Ведомость,
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.КВыплате КАК СуммаВедомости,
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.Сумма КАК СуммаНезачисления
	|ИЗ
	|	Документ.ПодтверждениеЗачисленияЗарплаты.Сотрудники КАК ПодтверждениеЗачисленияЗарплатыСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВедомостиПлатежногоДокумента КАК ВедомостиПлатежногоДокумента
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьНаВыплатуЗарплатыВБанкЗарплата
	|		ПО (ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка = &ПервичныйДокумент)
	|ГДЕ
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.Ссылка = &Ссылка
	|	И ПодтверждениеЗачисленияЗарплатыСотрудники.РезультатЗачисленияЗарплаты <> ЗНАЧЕНИЕ(Перечисление.РезультатыЗачисленияЗарплаты.Зачислено)
	|	И ВедомостиПлатежногоДокумента.ПлатежныйДокумент ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВедомостиПлатежногоДокумента.Ведомость,
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.ФизическоеЛицо,
	|	ВедомостиПлатежногоДокумента.Сумма,
	|	НезачисленныеСуммы.НезачисленнаяСумма
	|ИЗ
	|	Документ.ПодтверждениеЗачисленияЗарплаты.Сотрудники КАК ПодтверждениеЗачисленияЗарплатыСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВедомостиПлатежногоДокумента КАК ВедомостиПлатежногоДокумента
	|		ПО ПодтверждениеЗачисленияЗарплатыСотрудники.ФизическоеЛицо = ВедомостиПлатежногоДокумента.ФизическоеЛицо
	|			И (ПодтверждениеЗачисленияЗарплатыСотрудники.РезультатЗачисленияЗарплаты <> ЗНАЧЕНИЕ(Перечисление.РезультатыЗачисленияЗарплаты.Зачислено))
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНезачисленныеСуммы КАК НезачисленныеСуммы
	|		ПО ПодтверждениеЗачисленияЗарплатыСотрудники.ФизическоеЛицо = НезачисленныеСуммы.ФизическоеЛицо
	|ГДЕ
	|	ПодтверждениеЗачисленияЗарплатыСотрудники.Ссылка = &Ссылка";
	
	// Создадим соответствие ведомостей и физических лиц, из этих ведомостей, по которым требуется указать незачисленные
	// суммы.
	ДанныеДокументов = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
		СуммаНезачисленияПоФизическомуЛицу = Выборка.СуммаНезачисления;
		Пока Выборка.СледующийПоЗначениюПоля("Ведомость") Цикл
			Если СуммаНезачисленияПоФизическомуЛицу <= 0 Тогда
				Продолжить; // Отметили все незачисленные суммы.
			КонецЕсли;
			
			Если СуммаНезачисленияПоФизическомуЛицу > Выборка.СуммаВедомости Тогда
				СуммаНезачисленияПоДокументу = Выборка.СуммаВедомости;
			Иначе
				СуммаНезачисленияПоДокументу = СуммаНезачисленияПоФизическомуЛицу;
			КонецЕсли;
			СуммаНезачисленияПоФизическомуЛицу = СуммаНезачисленияПоФизическомуЛицу - СуммаНезачисленияПоДокументу;
			
			ФизическиеЛицаДокумента = ДанныеДокументов.Получить(Выборка.Ведомость);
			Если ФизическиеЛицаДокумента = Неопределено Тогда
				ДанныеДокументов.Вставить(Выборка.Ведомость, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка.ФизическоеЛицо));
			Иначе
				ФизическиеЛицаДокумента.Добавить(Выборка.ФизическоеЛицо);
				ДанныеДокументов.Вставить(Выборка.Ведомость, ФизическиеЛицаДокумента);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

Функция ЛицевыеСчетаФизическихЛицДляРегистрации()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ВедомостьНаВыплатуЗарплатыВБанк.Дата, МЕСЯЦ) КАК МесяцОткрытия,
		|	ПодтверждениеЗачисленияЗарплаты.Организация КАК Организация,
		|	ЗарплатныеПроекты.Ссылка КАК ЗарплатныйПроект,
		|	СотрудникиПодтверждениеЗачисленияЗарплаты.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СотрудникиПодтверждениеЗачисленияЗарплаты.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
		|	ПодтверждениеЗачисленияЗарплаты.Ссылка КАК ДокументОснование,
		|	ВедомостьНаВыплатуЗарплатыВБанк.Ссылка КАК Ведомость,
		|	СотрудникиПодтверждениеЗачисленияЗарплаты.БИКБанкаСчета КАК БИКБанкаСчета
		|ПОМЕСТИТЬ ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты
		|ИЗ
		|	Документ.ПодтверждениеЗачисленияЗарплаты.Сотрудники КАК СотрудникиПодтверждениеЗачисленияЗарплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПодтверждениеЗачисленияЗарплаты КАК ПодтверждениеЗачисленияЗарплаты
		|		ПО СотрудникиПодтверждениеЗачисленияЗарплаты.Ссылка = ПодтверждениеЗачисленияЗарплаты.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК ВедомостьНаВыплатуЗарплатыВБанк
		|		ПО (ПодтверждениеЗачисленияЗарплаты.ПервичныйДокумент = ВедомостьНаВыплатуЗарплатыВБанк.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
		|		ПО (ПодтверждениеЗачисленияЗарплаты.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка)
		|ГДЕ
		|	СотрудникиПодтверждениеЗачисленияЗарплаты.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.МесяцОткрытия КАК МесяцОткрытия,
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.Организация КАК Организация,
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.НомерЛицевогоСчета КАК НомерЛицевогоСчетаДляРегистрации,
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.ДокументОснование КАК ДокументОснование,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СпособЗачисления КАК СпособЗачисления,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.БанковскийСчет КАК БанковскийСчет,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.БанковскаяКарта КАК БанковскаяКарта,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Телефон КАК Телефон,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета КАК НомерЛицевогоСчета
		|ПОМЕСТИТЬ ВТЛицевыеСчетаДляРегистрации
		|ИЗ
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты КАК ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
		|		ПО ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.ФизическоеЛицо = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо
		|			И ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.ЗарплатныйПроект = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект
		|			И ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.Организация = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация
		|ГДЕ
		|	ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.НомерЛицевогоСчета <> """"
		|	И ВТЛицевыеСчетПодтвержденияЗачисленияЗарплаты.БИКБанкаСчета = """"
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТЛицевыеСчетаДляРегистрации.МесяцОткрытия КАК МесяцОткрытия,
		|	ВТЛицевыеСчетаДляРегистрации.Организация КАК Организация,
		|	ВТЛицевыеСчетаДляРегистрации.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ВТЛицевыеСчетаДляРегистрации.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТЛицевыеСчетаДляРегистрации.ДокументОснование КАК ДокументОснование,
		|	ВТЛицевыеСчетаДляРегистрации.СпособЗачисления КАК СпособЗачисления,
		|	ВТЛицевыеСчетаДляРегистрации.БанковскийСчет КАК БанковскийСчет,
		|	ВТЛицевыеСчетаДляРегистрации.БанковскаяКарта КАК БанковскаяКарта,
		|	ВТЛицевыеСчетаДляРегистрации.Телефон КАК Телефон,
		|	ВТЛицевыеСчетаДляРегистрации.НомерЛицевогоСчетаДляРегистрации КАК НомерЛицевогоСчета
		|ИЗ
		|	ВТЛицевыеСчетаДляРегистрации КАК ВТЛицевыеСчетаДляРегистрации
		|ГДЕ
		|	ЕСТЬNULL(ВТЛицевыеСчетаДляРегистрации.НомерЛицевогоСчета, """") = """"";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Область ПроцедурыИФункцииДляПолученияФайлаПодтверждения

Процедура ЗаполнитьДокументИзОбъектаXDTO(ОбъектXDTO, ХешСумма, СсылкаНаПервичныйДокумент, Отказ) Экспорт
	
	ПервичныйДокумент = СсылкаНаПервичныйДокумент;
	
	СтруктураДанныхДляЗаполненияДокумента = ОбменСБанкамиПоЗарплатнымПроектам.СтруктураДляЗаполненияДокументаПоПодтверждениюБанка(
			"ПодтверждениеЗачисленияЗарплаты", ОбъектXDTO, ХешСумма, ПервичныйДокумент, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивВедомостей = ОбменСБанкамиПоЗарплатнымПроектам.ВедомостиПлатежногоДокументаПеречисленияЗарплаты(ПервичныйДокумент);
	Если МассивВедомостей.Количество() = 0 Тогда
		МассивВедомостей.Добавить(ПервичныйДокумент);
	КонецЕсли;
	
	СопоставлениеПоЛицевомуСчету = СтруктураДанныхДляЗаполненияДокумента.Сотрудники.Колонки.Найти("ИдентификаторПлатежа") = Неопределено;
	
	Если СопоставлениеПоЛицевомуСчету Тогда
		НомераЛицевыхСчетов = СтруктураДанныхДляЗаполненияДокумента.Сотрудники.ВыгрузитьКолонку("НомерЛицевогоСчета");
		ФизическиеЛицаЛицевыхСчетов = Новый Соответствие;
	Иначе 
		ИдентификаторыПлатежей = СтруктураДанныхДляЗаполненияДокумента.Сотрудники.ВыгрузитьКолонку("ИдентификаторПлатежа");
		ФизическиеЛицаПоИдентификаторуПлатежа = Новый Соответствие;
	КонецЕсли;
	
	ВедомостиПоТипам = ОбщегоНазначенияБЗК.ОбъектыПоТипам(МассивВедомостей);
	
	КолонкиТЗ = СтруктураДанныхДляЗаполненияДокумента.Сотрудники.Колонки;
	Если КолонкиТЗ.Найти("ФизическоеЛицо") = Неопределено Тогда
		КолонкиТЗ.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	КонецЕсли;
	
	Если СопоставлениеПоЛицевомуСчету Тогда
		
		Для Каждого ВедомостиПоТипу Из ВедомостиПоТипам Цикл
			МенеджерВедомости = ОбщегоНазначенияБЗК.МенеджерОбъектаПоТипу(ВедомостиПоТипу.Ключ);
			ФизическиеЛицаЛицевыхСчетовВедомостей = 
				МенеджерВедомости.ФизическиеЛицаЛицевыхСчетов(
					ВедомостиПоТипу.Значение,
					НомераЛицевыхСчетов);
			ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(
				ФизическиеЛицаЛицевыхСчетов, 
				ФизическиеЛицаЛицевыхСчетовВедомостей);
		КонецЦикла;
		
		Для Каждого СтрокаТЧ Из СтруктураДанныхДляЗаполненияДокумента.Сотрудники Цикл
			СтрокаТЧ.ФизическоеЛицо = ФизическиеЛицаЛицевыхСчетов.Получить(СтрокаТЧ.НомерЛицевогоСчета);
		КонецЦикла;

	Иначе
		
		Для Каждого ВедомостиПоТипу Из ВедомостиПоТипам Цикл
			МенеджерВедомости = ОбщегоНазначенияБЗК.МенеджерОбъектаПоТипу(ВедомостиПоТипу.Ключ);
			ФизическиеЛицаПоИдентификаторуПлатежаВедомости = 
				МенеджерВедомости.ФизическиеЛицаПоИдентификаторуПлатежа(
					ВедомостиПоТипу.Значение,
					ИдентификаторыПлатежей);
			ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(
				ФизическиеЛицаПоИдентификаторуПлатежа, 
				ФизическиеЛицаПоИдентификаторуПлатежаВедомости);
		КонецЦикла;
		
		Для Каждого СтрокаТЧ Из СтруктураДанныхДляЗаполненияДокумента.Сотрудники Цикл
			СтрокаТЧ.ФизическоеЛицо = ФизическиеЛицаПоИдентификаторуПлатежа.Получить(СтрокаТЧ.ИдентификаторПлатежа);
		КонецЦикла;
	
	КонецЕсли;
	
	Сотрудники.Очистить();
	Заполнить(СтруктураДанныхДляЗаполненияДокумента);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли