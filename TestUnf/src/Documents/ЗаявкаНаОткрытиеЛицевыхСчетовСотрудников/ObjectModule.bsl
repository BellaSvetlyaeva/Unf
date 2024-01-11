#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтандартнаяОбработка = Истина;
	ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
		ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= Дата;
		ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= Дата;
		
		КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
			Сотрудники.ВыгрузитьКолонку("ФизическоеЛицо"),
			ПараметрыПолученияСотрудниковОрганизаций,
			Отказ,
			Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект.Сотрудники"));
		
		Для Каждого СтрокаПоФизическомуЛицу Из Сотрудники Цикл
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
				"Объект.Сотрудники", 
				СтрокаПоФизическомуЛицу.НомерСтроки, 
				"ФизическоеЛицо");
			
			// Физическое лицо
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ФизическоеЛицо") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ФизическоеЛицо) Тогда
				ТекстОшибки = НСтр("ru = 'Не выбран сотрудник.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Эмбоссированный текст
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ЭмбоссированныйТекст1") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.ЭмбоссированныйТекст1) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 не заполнено поле ""Имя"" на латинице.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Эмбоссированный текст
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ЭмбоссированныйТекст2") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.ЭмбоссированныйТекст2) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 не заполнено поле ""Фамилия"" на латинице.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Проверка максимальной длины эмбоссированного текста, она не должна превышать указанной в зарплатном проекте.
			МаксимальнаяДлинаЭмбоссированногоТекста = Справочники.ЗарплатныеПроекты.МаксимальнаяДлинаИмениДержателяКарты(ЗарплатныйПроект);
			ЭмбоссированныйТекст = ОбщегоНазначенияБЗККлиентСервер.ЗначенияВМассиве(
					СтрокаПоФизическомуЛицу.ЭмбоссированныйТекст1,
					СтрокаПоФизическомуЛицу.ЭмбоссированныйТекст2,
					СтрокаПоФизическомуЛицу.ЭмбоссированныйТекст3);
			ДлинаЭмбоссированногоТекста = СтрДлина(СтрСоединить(ЭмбоссированныйТекст, " "));
			Если ДлинаЭмбоссированногоТекста > МаксимальнаяДлинаЭмбоссированногоТекста Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 фамилию и имя на латинице необходимо сократить, т.к. этот текст наносится на пластиковую карту и имеет ограничение до %2.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо,
					ПолучитьСклоненияСтрокиПоЧислу(
						"символ", 
						МаксимальнаяДлинаЭмбоссированногоТекста, 
						"", 
						"ЧС=Количественное", "ПД=Родительный")[0]);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Дата рождения
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаРождения") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаРождения) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 не заполнена дата рождения.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Пол
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.Пол") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.Пол) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 не заполнен пол.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Система расчетов по банковским картам.
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.СистемаРасчетовПоБанковскимКартам") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.СистемаРасчетовПоБанковскимКартам) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 не выбрана система расчетов по банковским картам.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Счет дебета
			Если НЕ ПустаяСтрока(СтрокаПоФизическомуЛицу.СчетДебета) И СтрДлина(СтрокаПоФизическомуЛицу.СчетДебета) <> 20 Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'У сотрудника %1 длина счета дебета менее 20 цифр.'"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Документ удостоверяющий личность.
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДокументВид") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДокументВид) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'На дату %1 у сотрудника %2 не указан вид документа, удостоверяющего личность.'"),
					Формат(Дата, "ДЛФ=ДД"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДокументНомер") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.ДокументНомер) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'На дату %1 у сотрудника %2 не указан номер документа, удостоверяющего личность.'"),
					Формат(Дата, "ДЛФ=ДД"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДокументДатаВыдачи") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДокументДатаВыдачи) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'На дату %1 у сотрудника %2 не указана дата выдачи документа, удостоверяющего личность.'"),
					Формат(Дата, "ДЛФ=ДД"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДокументКемВыдан") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.ДокументКемВыдан) Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'На дату %1 у сотрудника %2 не указано, кем выдан документ, удостоверяющего личность.'"),
					Формат(Дата, "ДЛФ=ДД"),
					СтрокаПоФизическомуЛицу.ФизическоеЛицо);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
			КонецЕсли;
			
			// Миграционная карта
			Если Не ПустаяСтрока(СтрокаПоФизическомуЛицу.НомерМиграционнойКарты)
				Или ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаНачалаПребыванияМиграционнойКарты)
				Или ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаОкончанияПребыванияМиграционнойКарты) Тогда
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.НомерМиграционнойКарты") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.НомерМиграционнойКарты) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указан номер миграционной карты.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаНачалаПребыванияМиграционнойКарты") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаНачалаПребыванияМиграционнойКарты) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указана дата начала пребывания миграционной карты.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаОкончанияПребыванияМиграционнойКарты") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаОкончанияПребыванияМиграционнойКарты) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указана дата окончания пребывания миграционной карты.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаНачалаПребыванияМиграционнойКарты") <> Неопределено
					И ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаОкончанияПребыванияМиграционнойКарты") <> Неопределено
					И СтрокаПоФизическомуЛицу.ДатаНачалаПребыванияМиграционнойКарты > СтрокаПоФизическомуЛицу.ДатаОкончанияПребыванияМиграционнойКарты Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 дата окончания не может быть меньше даты начала пребывания миграционной карты.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
			КонецЕсли;
			
			// Миграционный документ
			Если ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ВидМиграционногоДокумента)
				Или Не ПустаяСтрока(СтрокаПоФизическомуЛицу.НомерМиграционногоДокумента)
				Или ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаНачалаПребыванияМиграционногоДокумента)
				Или ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаОкончанияПребыванияМиграционногоДокумента) Тогда
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ВидМиграционногоДокумента") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ВидМиграционногоДокумента) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указан вид миграционного документа.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.НомерМиграционногоДокумента") <> Неопределено И ПустаяСтрока(СтрокаПоФизическомуЛицу.НомерМиграционногоДокумента) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указан номер миграционного документа.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаНачалаПребыванияМиграционногоДокумента") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаНачалаПребыванияМиграционногоДокумента) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указана дата начала пребывания миграционного документа.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаОкончанияПребыванияМиграционногоДокумента") <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаПоФизическомуЛицу.ДатаОкончанияПребыванияМиграционногоДокумента) Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 не указана дата окончания пребывания миграционного документа.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
				Если ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаНачалаПребыванияМиграционногоДокумента") <> Неопределено
					И ПроверяемыеРеквизиты.Найти("Сотрудники.ДатаОкончанияПребыванияМиграционногоДокумента") <> Неопределено
					И СтрокаПоФизическомуЛицу.ДатаНачалаПребыванияМиграционногоДокумента > СтрокаПоФизическомуЛицу.ДатаОкончанияПребыванияМиграционногоДокумента Тогда
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'У сотрудника %1 дата окончания не может быть меньше даты начала пребывания миграционного документа.'"),
						СтрокаПоФизическомуЛицу.ФизическоеЛицо);
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Поле, , Отказ);
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ФизическоеЛицо");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ЭмбоссированныйТекст1");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ЭмбоссированныйТекст2");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДатаРождения");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.Пол");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.СистемаРасчетовПоБанковскимКартам");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.СчетДебета");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДокументВид");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДокументНомер");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДокументДатаВыдачи");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДокументКемВыдан");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.НомерМиграционнойКарты");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДатаНачалаПребыванияМиграционнойКарты");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДатаОкончанияПребыванияМиграционнойКарты");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ВидМиграционногоДокумента");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.НомерМиграционногоДокумента");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДатаНачалаПребыванияМиграционногоДокумента");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ДатаОкончанияПребыванияМиграционногоДокумента");
		
	КонецЕсли;
	
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
		Если ДанныеЗаполнения.Свойство("ДокументКопирования") Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.ДокументКопирования);
			Запрос.УстановитьПараметр("Сотрудники", ДанныеЗаполнения.Сотрудники);
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	*
			|ИЗ
			|	Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников
			|ГДЕ
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка = &Ссылка
			|	И ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ФизическоеЛицо В(&Сотрудники)";
			
			МассивИдентификаторовСтрокиФикс = Новый Массив;
			СоответствиеНовыхИдентификаторов = Новый Соответствие;
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяСтрокаСотрудники = Сотрудники.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаСотрудники, Выборка);
				НовыйИдентификатор = СоответствиеНовыхИдентификаторов.Количество() + 1;
				НоваяСтрокаСотрудники.ИдентификаторСтрокиФикс = НовыйИдентификатор;
				МассивИдентификаторовСтрокиФикс.Добавить(Выборка.ИдентификаторСтрокиФикс);
				СоответствиеНовыхИдентификаторов.Вставить(Выборка.ИдентификаторСтрокиФикс, НовыйИдентификатор);
			КонецЦикла;
			
			Запрос.УстановитьПараметр("ИдентификаторСтроки", МассивИдентификаторовСтрокиФикс);
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка,
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.НомерСтроки,
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ИмяРеквизита,
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Путь,
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ИдентификаторСтроки
			|ИЗ
			|	Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ФиксацияИзменений КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников
			|ГДЕ
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка = &Ссылка
			|	И ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ИдентификаторСтроки В(&ИдентификаторСтроки)";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяСтрокаФиксации = ФиксацияИзменений.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаФиксации, Выборка);
				НоваяСтрокаФиксации.ИдентификаторСтроки = СоответствиеНовыхИдентификаторов.Получить(Выборка.ИдентификаторСтроки);
			КонецЦикла;
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Сотрудники") Тогда
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			
			ОбменСБанкамиПоЗарплатнымПроектам.СоздатьВТСостоянияОткрытияЛицевыхСчетовФизическихЛиц(
				Запрос.МенеджерВременныхТаблиц, Истина,
				Организация, ЗарплатныйПроект, ДанныеЗаполнения.ДатаПолученияДанных, 
				Подразделение, ДанныеЗаполнения.Сотрудники, Ссылка);
			
			ДанныеСотрудников = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСотрудниковДляОткрытияЛицевыхСчетов(
			Запрос.МенеджерВременныхТаблиц, ДанныеЗаполнения.ДатаПолученияДанных, Организация, ЗарплатныйПроект, ДанныеЗаполнения.Сотрудники, Ссылка);
			
			Для Каждого ДанныеСотрудника Из ДанныеСотрудников Цикл
				ЗаполнитьЗначенияСвойств(Сотрудники.Добавить(), ДанныеСотрудника);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерРеестра = 0;
	
	МассивФизическихЛиц = Неопределено;
	Если ОбъектКопирования.ДополнительныеСвойства.Свойство("МассивФизическихЛицДляКопирования", МассивФизическихЛиц) Тогда
		
		ИзменилиОбъектКопирования = Ложь;
		ФизическиеЛицаДокумента = Сотрудники.ВыгрузитьКолонку("ФизическоеЛицо");
		Для каждого ФизическоеЛицо Из ФизическиеЛицаДокумента Цикл
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ФизическоеЛицо", ФизическоеЛицо);
			
			Если МассивФизическихЛиц.Найти(ФизическоеЛицо) = Неопределено Тогда
				
				НайденныеСтроки = Сотрудники.НайтиСтроки(ПараметрыОтбора);
				Для каждого СтрокаДляУдаления Из НайденныеСтроки Цикл
					Сотрудники.Удалить(СтрокаДляУдаления);
				КонецЦикла;
				
			Иначе
				
				НайденныеСтроки = ОбъектКопирования.Сотрудники.НайтиСтроки(ПараметрыОтбора);
				Для каждого СтрокаДляУдаления Из НайденныеСтроки Цикл
					ОбъектКопирования.Сотрудники.Удалить(СтрокаДляУдаления);
					ИзменилиОбъектКопирования = Истина;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
		
		Если ИзменилиОбъектКопирования Тогда
			ОбъектКопирования.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка КАК ДокументПодтверждения
	|ИЗ
	|	Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудников
	|ГДЕ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПервичныйДокумент = &Ссылка
	|	И ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Проведен";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ТекстОшибки = СтрШаблон(
		НСтр("ru = 'По заявке на открытие лицевых счетов зарегистрировано подтверждение %1.'"),
		Выборка.ДокументПодтверждения);
	ОбщегоНазначения.СообщитьПользователю(
		ТекстОшибки,
		Выборка.ДокументПодтверждения,,,
		Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерРеестра) Тогда
		Если ПустаяСтрока(Номер) Тогда
			УстановитьНовыйНомер();
		КонецЕсли;
		НомерРеестра = ОбменСБанкамиПоЗарплатнымПроектам.СтрокаВЧисло(Номер);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И ОбъектЗафиксирован() Тогда
		ФиксацияВторичныхДанныхВДокументах.ЗафиксироватьВторичныеДанныеДокумента(ЭтотОбъект);
	КонецЕсли;
	
	Для каждого СтрокаДокумента Из Сотрудники Цикл
		СтрокаДокумента.ДокументНомерСерия = СтрокаДокумента.ДокументСерия + СтрокаДокумента.ДокументНомер;
		СтрокаДокумента.ДокументНомерСерия = СтрЗаменить(СтрокаДокумента.ДокументНомерСерия, " ", "");
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ЗаявкаНаОткрытиеЛицевыхСчетов", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Проведен КАК Проведен,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Организация КАК Организация,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ЗарплатныйПроект КАК ЗарплатныйПроект,";
	Для каждого Реквизит Из Метаданные().ТабличныеЧасти.Сотрудники.Реквизиты Цикл
		Если Реквизит.Тип = Новый ОписаниеТипов("Строка") Тогда
			Запрос.Текст = Запрос.Текст + "
			|	ВЫРАЗИТЬ(ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники." + Реквизит.Имя + " КАК СТРОКА(500)) КАК " + Реквизит.Имя + ",";
		Иначе
			Запрос.Текст = Запрос.Текст + "
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники." + Реквизит.Имя + ",";
		КонецЕсли;
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	Запрос.Текст = Запрос.Текст + "
	|ИЗ
	|	Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников
	|		ПО ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка
	|ГДЕ
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = &ЗаявкаНаОткрытиеЛицевыхСчетов";
	
	ДополнительныеСвойства.Вставить("ДанныеОткрытияЛицевыхСчетовПередЗаписью", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ЗаявкаНаОткрытиеЛицевыхСчетов", Ссылка);
	Запрос.УстановитьПараметр("ДанныеОткрытияЛицевыхСчетовПередЗаписью", ДополнительныеСвойства.ДанныеОткрытияЛицевыхСчетовПередЗаписью);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеОткрытияЛицевыхСчетовПередЗаписью.Проведен КАК Проведен,
	|	ДанныеОткрытияЛицевыхСчетовПередЗаписью.Организация КАК Организация,
	|	ДанныеОткрытияЛицевыхСчетовПередЗаписью.ЗарплатныйПроект КАК ЗарплатныйПроект,";
	Для каждого Реквизит Из Метаданные().ТабличныеЧасти.Сотрудники.Реквизиты Цикл
		Запрос.Текст = Запрос.Текст + "
		|	ДанныеОткрытияЛицевыхСчетовПередЗаписью." + Реквизит.Имя + ",";
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТДанныеОткрытияЛицевыхСчетовПередЗаписью
	|ИЗ
	|	&ДанныеОткрытияЛицевыхСчетовПередЗаписью КАК ДанныеОткрытияЛицевыхСчетовПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Проведен КАК Проведен,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Организация КАК Организация,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ЗарплатныйПроект КАК ЗарплатныйПроект,";
	Для каждого Реквизит Из Метаданные().ТабличныеЧасти.Сотрудники.Реквизиты Цикл
		Если Реквизит.Тип = Новый ОписаниеТипов("Строка") Тогда
			Запрос.Текст = Запрос.Текст + "
			|	ВЫРАЗИТЬ(ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники." + Реквизит.Имя + " КАК СТРОКА(500)) КАК " + Реквизит.Имя + ",";
		Иначе
			Запрос.Текст = Запрос.Текст + "
			|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники." + Реквизит.Имя + ",";
		КонецЕсли;
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТДанныеОткрытияЛицевыхСчетовПриЗаписи
	|ИЗ
	|	Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников
	|		ПО ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка
	|ГДЕ
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = &ЗаявкаНаОткрытиеЛицевыхСчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле
	|ИЗ
	|	ВТДанныеОткрытияЛицевыхСчетовПередЗаписью КАК ДанныеОткрытияЛицевыхСчетовПередЗаписью
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТДанныеОткрытияЛицевыхСчетовПриЗаписи КАК ДанныеОткрытияЛицевыхСчетовПриЗаписи
	|		ПО ДанныеОткрытияЛицевыхСчетовПередЗаписью.Организация = ДанныеОткрытияЛицевыхСчетовПриЗаписи.Организация
	|			И ДанныеОткрытияЛицевыхСчетовПередЗаписью.ЗарплатныйПроект = ДанныеОткрытияЛицевыхСчетовПриЗаписи.ЗарплатныйПроект
	|			И ДанныеОткрытияЛицевыхСчетовПередЗаписью.Проведен = ДанныеОткрытияЛицевыхСчетовПриЗаписи.Проведен";
	Для каждого Реквизит Из Метаданные().ТабличныеЧасти.Сотрудники.Реквизиты Цикл
		Запрос.Текст = Запрос.Текст + "
		|			И ДанныеОткрытияЛицевыхСчетовПередЗаписью." + Реквизит.Имя + " = ДанныеОткрытияЛицевыхСчетовПриЗаписи." + Реквизит.Имя;
	КонецЦикла;
	Запрос.Текст = Запрос.Текст + "
	|ГДЕ
	|	(ДанныеОткрытияЛицевыхСчетовПередЗаписью.Организация ЕСТЬ NULL 
	|			ИЛИ ДанныеОткрытияЛицевыхСчетовПриЗаписи.Организация ЕСТЬ NULL )";
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьСостояниеОткрытияЛицевыхСчетов(Ссылка, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак изменения данных, влияющих на формирование электронного документа.
// 
Функция ИзменилисьКлючевыеРеквизитыЭлектронногоДокумента() Экспорт
	
	ИзменилисьКлючевыеРеквизиты = 
		ЭлектронноеВзаимодействиеБЗК.ИзменилисьРеквизитыОбъекта(ЭтотОбъект, "Дата, Номер, Организация, ЗарплатныйПроект, НомерРеестра, ПометкаУдаления")	
		Или ЭлектронноеВзаимодействиеБЗК.ИзмениласьТабличнаяЧастьОбъекта(ЭтотОбъект, "Сотрудники");
		
	Возврат ИзменилисьКлючевыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТабличнуюЧастьФизическимиЛицамиНеИмеющихЛицевыхСчетов(ДатаПолученияДанных) Экспорт
	
	Сотрудники.Очистить();
	
	ДанныеСотрудников = ФизическиеЛицаНеИмеющиеЛицевыхСчетов(ДатаПолученияДанных);
	
	Для каждого СтрокаДанных Из ДанныеСотрудников Цикл
		
		СтрокаТабличнойЧастиСотрудники = Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧастиСотрудники, СтрокаДанных);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОбновитьТабличнуюЧастьФизическиеЛица(МассивСотрудников = Неопределено) Экспорт
	
	СписокФизическихЛиц = ?(МассивСотрудников = Неопределено, Сотрудники.Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо"), МассивСотрудников);
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивСотрудников", СписокФизическихЛиц);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Организация КАК Организация,
	|	ЛОЖЬ КАК ОткрытиеЛицевогоСчетаОтложено,
	|	ЛОЖЬ КАК ОжидаетПодтверждения,
	|	ЛОЖЬ КАК ЛицевойСчетНеОткрыт,
	|	ЛОЖЬ КАК ЗаявкаНеОформлялась,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка КАК ДокументОткрытияЛицевыхСчетов,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Подразделение КАК Подразделение,
	|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.НомерСтроки КАК НомерСтрокиДокумента
	|ПОМЕСТИТЬ ВТСостоянияОткрытияЛицевыхСчетовФизическихЛиц
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники
	|		ПО (ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = &Ссылка)
	|			И ФизическиеЛица.Ссылка = ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников
	|		ПО (ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка)
	|ГДЕ
	|	ФизическиеЛица.Ссылка В(&МассивСотрудников)";
	
	Запрос.Выполнить();
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Организация;
	Если Подразделение <> Неопределено Тогда
		ПараметрыПолученияСотрудников.Подразделение = Подразделение;
	КонецЕсли;
	ПараметрыПолученияСотрудников.ОкончаниеПериода = Дата;
	ОбменСБанкамиПоЗарплатнымПроектамВнутренний.ДополнитьПараметрыПолученияСотрудников(ПараметрыПолученияСотрудников);
	
	Если СписокФизическихЛиц.Количество() <> 0 Тогда
		ПараметрыПолученияСотрудников.СписокФизическихЛиц = СписокФизическихЛиц;
	КонецЕсли;
	ПараметрыПолученияСотрудников.КадровыеДанные = "НомерЛицевогоСчета, ВидЗанятости";
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников, "ВТВсеСотрудникиОрганизации");
	
	ДанныеСотрудников = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСотрудниковДляОткрытияЛицевыхСчетов(
	Запрос.МенеджерВременныхТаблиц, Дата, Организация, ЗарплатныйПроект, , Ссылка);
	
	Запрос.УстановитьПараметр("ДанныеСотрудников", ДанныеСотрудников);
	
	ОписаниеФиксацииРеквизитов = Документы.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ПараметрыФиксацииВторичныхДанных().ОписаниеФиксацииРеквизитов;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,";
	Для каждого ОписаниеРеквизита Из ОписаниеФиксацииРеквизитов Цикл
		Запрос.Текст = Запрос.Текст + "
		|	ДанныеСотрудников." + ОписаниеРеквизита.Значение.ИмяРеквизита + " КАК " + ОписаниеРеквизита.Значение.ИмяРеквизита + ",";
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТВторичныеДанные
	|ИЗ
	|	&ДанныеСотрудников КАК ДанныеСотрудников
	|ГДЕ
	|	ДанныеСотрудников.ФизическоеЛицо В(&МассивСотрудников)";
	
	Запрос.Выполнить();
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, "Сотрудники");
	
КонецФункции

Функция ФизическиеЛицаНеИмеющиеЛицевыхСчетов(ДатаПолученияДанных)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОбменСБанкамиПоЗарплатнымПроектам.СоздатьВТСостоянияОткрытияЛицевыхСчетовФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц, Истина,
		Организация, ЗарплатныйПроект, ДатаПолученияДанных, 
		Подразделение, , Ссылка);
	
	ДанныеСотрудников = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСотрудниковДляОткрытияЛицевыхСчетов(
		Запрос.МенеджерВременныхТаблиц, ДатаПолученияДанных, Организация, ЗарплатныйПроект, , Ссылка, Истина);
	
	Возврат ДанныеСотрудников
	
КонецФункции

Процедура ЗаполнитьСтрокиТабличнойЧастиДаннымиДляОткрытияЛицевыхСчетов(ДатаПолученияДанных, СписокФизическихЛиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОбменСБанкамиПоЗарплатнымПроектам.СоздатьВТСостоянияОткрытияЛицевыхСчетовФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц, Истина,
		Организация, ЗарплатныйПроект, ДатаПолученияДанных, 
		Подразделение, СписокФизическихЛиц, Ссылка);
	
	ДанныеСотрудников = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСотрудниковДляОткрытияЛицевыхСчетов(
		Запрос.МенеджерВременныхТаблиц, ДатаПолученияДанных, Организация, ЗарплатныйПроект, СписокФизическихЛиц, Ссылка);
		
	Отбор = Новый Структура;

	Если ДанныеСотрудников.Количество() = 0 Тогда
		Для Каждого Колонка Из Сотрудники.ВыгрузитьКолонки() Цикл
			Если Колонка.Имя = "НомерСтроки" Или Колонка.Имя = "ФизическоеЛицо" Тогда
				Продолжить;
			КонецЕсли;
			Для Каждого ФизическоеЛицо Из СписокФизическихЛиц Цикл
				Отбор.Вставить("ФизическоеЛицо", ФизическоеЛицо);
				СтрокаТабличнойЧастиСотрудники = Сотрудники.НайтиСтроки(Отбор)[0];
				СтрокаТабличнойЧастиСотрудники[Колонка.Имя] = Неопределено;
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаДанных Из ДанныеСотрудников Цикл
			Отбор.Вставить("ФизическоеЛицо", СтрокаДанных.ФизическоеЛицо);
			СтрокаТабличнойЧастиСотрудники = Сотрудники.НайтиСтроки(Отбор)[0];
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧастиСотрудники, СтрокаДанных);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ОбъектЗафиксирован() Экспорт
	
	Если Не Проведен Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СостоянияДокументовОткрытияЛицевыхСчетов.ДокументОткрытияЛицевыхСчетов
	|ИЗ
	|	РегистрСведений.СостоянияДокументовОткрытияЛицевыхСчетов КАК СостоянияДокументовОткрытияЛицевыхСчетов
	|ГДЕ
	|	СостоянияДокументовОткрытияЛицевыхСчетов.ДокументОткрытияЛицевыхСчетов = &Ссылка
	|	И (СостоянияДокументовОткрытияЛицевыхСчетов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостояниеЗаявкиНаОткрытиеЛицевогоСчетаСотрудника.ЛицевойСчетНеОткрыт)
	|			ИЛИ СостоянияДокументовОткрытияЛицевыхСчетов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостояниеЗаявкиНаОткрытиеЛицевогоСчетаСотрудника.ЛицевыеСчетаОткрыты)
	|			ИЛИ СостоянияДокументовОткрытияЛицевыхСчетов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостояниеЗаявкиНаОткрытиеЛицевогоСчетаСотрудника.ЛицевыеСчетаОткрытыСОшибками))";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли