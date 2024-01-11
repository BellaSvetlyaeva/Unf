#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьИнформациюОПользователе(Прокси, ОбъектXDTO, СсылкаНаПотребитель) Экспорт
	
	Настройки = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера");
		Настройки = МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИспользоватьИнтеграцию();
	КонецЕсли;
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Настройки.ИспользоватьИнтеграциюДО2 Тогда
		ОбъектXDTO.user = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMUser",
			СсылкаНаПотребитель);
	ИначеЕсли Настройки.ИспользоватьИнтеграциюДО3 Тогда
		ОбъектXDTO.employee = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMEmployee",
			СсылкаНаПотребитель);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРуководителяПодразделения(Прокси, ОбъектXDTO, Подразделение) Экспорт
	
	Руководитель = РуководительПодразделения(Подразделение);
	
	Если Не ЗначениеЗаполнено(Руководитель) Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера");
		Настройки = МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИспользоватьИнтеграцию();
	КонецЕсли;
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбъекта = "";
	Если Настройки.ИспользоватьИнтеграциюДО2 Тогда
		ИмяОбъекта = "DMUser";
	ИначеЕсли Настройки.ИспользоватьИнтеграциюДО3 Тогда
		ИмяОбъекта = "DMEmployee";
	Иначе
		Возврат;
	КонецЕсли;
	
	ОбъектXDTO.head = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		ИмяОбъекта,
		Руководитель,
		Ложь);
	
	Если Настройки.ИспользоватьИнтеграциюДО2 Тогда
		ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Руководитель, "ФизическоеЛицо");
		ЗаполнитьФизическоеЛицо(ФизическоеЛицо, Прокси, ОбъектXDTO.head);
	ИначеЕсли Настройки.ИспользоватьИнтеграциюДО3 Тогда
		Справочники.Сотрудники.ИнтеграцияС1СДокументооборотЗаполнитьДанныеСотрудника(
			Прокси,
			ОбъектXDTO.head,
			Руководитель,
			Ложь,
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьФизическоеЛицо(ФизическоеЛицо, Прокси, ОбъектXDTO) Экспорт
	
	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		ОбъектXDTO.privatePerson = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMPrivatePerson",
			ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПодразделение(Подразделение, Прокси, ОбъектXDTO, ЗаполнятьПодразделение, ЗаполнятьРуководителя) Экспорт
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		
		ОбъектXDTO.subdivision = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMSubdivision",
			Подразделение,
			ЗаполнятьПодразделение);
		
		ЗаполнитьРуководителяИзПодразделения(
			Подразделение,
			Прокси,
			ОбъектXDTO,
			ЗаполнятьРуководителя,
			МодульИнтеграцияС1СДокументооборотБазоваяФункциональность);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПользователя(Пользователь, Прокси, ОбъектXDTO) Экспорт
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		ОбъектXDTO.user = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMUser",
			Пользователь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДолжность(Должность, Прокси, ОбъектXDTO) Экспорт
	
	Если Не ЗначениеЗаполнено(Должность) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		ОбъектXDTO.position = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			"DMPosition",
			Должность);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСозданииЮрЛицаПоСсылке(ОбъектИС, ОбъектXDTO, ЗаполняемыйОбъектИС, ИсточникXDTO = Неопределено) Экспорт
	
	ОбъектИС.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	ИсточникXDTO = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		
		Если (ОбъектXDTO.objectID.type = "DMParty" Или ОбъектXDTO.Тип().Имя = "DMParty") Тогда
			Если МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ОбъектXDTO, "correspondent") Тогда
				ИсточникXDTO = ОбъектXDTO.correspondent;
			ИначеЕсли МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ОбъектXDTO, "organization") Тогда
				ИсточникXDTO = ОбъектXDTO.organization;
			КонецЕсли;
		ИначеЕсли ОбъектXDTO.objectID.type = "DMCorrespondent" Или ОбъектXDTO.objectID.type = "DMOrganization" Тогда
			ИсточникXDTO = ОбъектXDTO;
		КонецЕсли;
	КонецЕсли;
	
	Если ИсточникXDTO = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектИС.ИНН = ИсточникXDTO.inn;
	ОбъектИС.КодПоОКПО = ИсточникXDTO.okpo;
	ОбъектИС.НаименованиеПолное = ИсточникXDTO.fullName;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.БазовыеСправочныеДанные.Контрагенты") Тогда
		ТипОбъектаКонтрагенты = "СправочникОбъект.Контрагенты";
		Если ТипЗнч(ОбъектИС) = Тип(ТипОбъектаКонтрагенты) Тогда
			ОбъектИС.КПП = ИсточникXDTO.kpp;
		КонецЕсли;
	КонецЕсли;
	
	Если МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ИсточникXDTO, "legalPrivatePerson") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера");
		Настройки = МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИспользоватьИнтеграцию();
		
		Если Настройки.ИспользоватьИнтеграциюДО2 Тогда
			Если ИсточникXDTO.legalPrivatePerson.objectID.ID = "ЮрЛицо" Тогда
				ОбъектИС.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
			ИначеЕсли ИсточникXDTO.legalPrivatePerson.objectID.ID = "ФизЛицо" Тогда
				ОбъектИС.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
			КонецЕсли;
		ИначеЕсли Настройки.ИспользоватьИнтеграциюДО3 Тогда
			Если ИсточникXDTO.legalPrivatePerson = "LglPerson" Тогда
				ОбъектИС.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
			ИначеЕсли ИсточникXDTO.legalPrivatePerson = "Individ" Тогда
				ОбъектИС.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СостояниеСогласованияДО(ЗначениеЗаполнения) Экспорт
	
	СостояниеДО = Неопределено;
	
	МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
		"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
	ИмяПеречисленияДО = "СостоянияСогласованияВДокументообороте";
	ИмяЗначенияСостоянияДО = "";
	
	Если ТипЗнч(ЗначениеЗаполнения) = Тип("ОбъектXDTO")
			И МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ЗначениеЗаполнения, "objectID")
			И ЗначениеЗаполнения.objectID.type = "DMDocumentStatus" Тогда
		
		ИмяЗначенияСостоянияДО = ЗначениеЗаполнения.objectID.ID;
		
	ИначеЕсли ТипЗнч(ЗначениеЗаполнения) = Тип("Структура")
			И ЗначениеЗаполнения.ТипXDTOОбъекта = "DMDocument"
			И ЗначениеЗаполнения.ИмяСвойства = "statusApproval" Тогда
		
		Если ЗначениеЗаполнения.ЗначениеСвойства = "Approved" Тогда
			ИмяЗначенияСостоянияДО = "Согласован";
			
		ИначеЕсли ЗначениеЗаполнения.ЗначениеСвойства = "NotApproved" Тогда
			ИмяЗначенияСостоянияДО = "НеСогласован";
			
		ИначеЕсли ЗначениеЗаполнения.ЗначениеСвойства = "AwaitingApproval" Тогда
			ИмяЗначенияСостоянияДО = "НаСогласовании";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяЗначенияСостоянияДО <> "" Тогда
		СостояниеДО = Перечисления[ИмяПеречисленияДО][ИмяЗначенияСостоянияДО];
	КонецЕсли;
	
	Возврат СостояниеДО;
	
КонецФункции

Функция СостояниеСогласованияБЗК(ТипРеквизита, СостояниеДО) Экспорт
	
	Результат = Неопределено;
	
	ИмяПеречисленияДО = "СостоянияСогласованияВДокументообороте";
	ИндексЗначенияПеречисленияДО = Перечисления[ИмяПеречисленияДО].Индекс(СостояниеДО);
	МетаданныеПеречисленияДО = Метаданные.Перечисления[ИмяПеречисленияДО];
	ИмяЗначенияСостоянияДО = МетаданныеПеречисленияДО.ЗначенияПеречисления[ИндексЗначенияПеречисленияДО].Имя;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.БазовыеСправочныеДанныеРасширенная") Тогда
		ИмяТипаПеречисления = "ПеречислениеСсылка.СостоянияСогласования";
		Если ТипРеквизита = Тип(ИмяТипаПеречисления) Тогда
			ИмяПеречисления = "СостоянияСогласования";
			МодульСостоянияСогласования = Перечисления[ИмяПеречисления];
			Результат = МодульСостоянияСогласования.СостояниеСогласованияБЗК(ТипРеквизита, ИмяЗначенияСостоянияДО);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.СамообслуживаниеСотрудников") Тогда
		ИмяТипаПеречисления = "ПеречислениеСсылка.СтатусыЗаявокСотрудников";
		Если ТипРеквизита = Тип(ИмяТипаПеречисления) Тогда
			ИмяПеречисления = "СтатусыЗаявокСотрудников";
			МодульСтатусыЗаявокСотрудников = Перечисления[ИмяПеречисления];
			Результат = МодульСтатусыЗаявокСотрудников.СостояниеСогласованияБЗК(ТипРеквизита, ИмяЗначенияСостоянияДО);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РуководительПодразделения(Подразделение)
	
	ТипПодразделения = Подразделение.Метаданные().ПолноеИмя();
	
	Если ТипПодразделения = "Справочник.СтруктураПредприятия" Тогда
		
		МестоВСтруктуреПредприятия = Подразделение;
		
	ИначеЕсли ТипПодразделения = "Справочник.ПодразделенияОрганизаций"
			И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		
		МодульОрганизационнаяСтруктура = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		МестоВСтруктуреПредприятия = МодульОрганизационнаяСтруктура.ПодразделениеВСтруктуреПредприятия(Подразделение);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоВСтруктуреПредприятия)
			И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РуководителиПодразделений") Тогда
		
		МодульРуководителиПодразделений = ОбщегоНазначения.ОбщийМодуль("РуководителиПодразделений");
		ПозицияРуководителя = МодульРуководителиПодразделений.ПозицияРуководителя(МестоВСтруктуреПредприятия);
		
		Возврат МодульРуководителиПодразделений.СотрудникНаПозицииРуководителя(ПозицияРуководителя);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьРуководителяИзПодразделения(Подразделение, Прокси, ОбъектXDTO, ЗаполнятьРуководителя,
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность)
	
	Если Не МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоСуществует(ОбъектXDTO, "manager") Тогда
		Возврат;
	КонецЕсли;
	
	Руководитель = РуководительПодразделения(Подразделение);
	
	Если Не ЗначениеЗаполнено(Руководитель) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектXDTO.manager = МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		"DMEmployee",
		Руководитель,
		Ложь);
	Если ЗаполнятьРуководителя Тогда
		Справочники.Сотрудники.ИнтеграцияС1СДокументооборотЗаполнитьДанныеСотрудника(
			Прокси,
			ОбъектXDTO.manager,
			Руководитель,
			Ложь,
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
