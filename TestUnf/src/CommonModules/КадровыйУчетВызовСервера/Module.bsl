////////////////////////////////////////////////////////////////////////////////
// КадровыйУчетВызовСервера: методы кадрового учета, работающие на стороне сервера.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ИсключитьПовторениеЗаписейТекущихДанныхСотрудников(ИмяРегистраТекущихСведений) Экспорт
	
	КадровыйУчет.ИсключитьПовторениеЗаписейТекущихДанныхСотрудников(ИмяРегистраТекущихСведений);
	
КонецПроцедуры

Процедура ИсключитьЗадвоениеОсновныхРабочихМестТекущихДанныхСотрудников() Экспорт
	
	КадровыйУчет.ИсключитьЗадвоениеОсновныхРабочихМестТекущихДанныхСотрудников();
	
КонецПроцедуры

Функция КадровыеДанныеСотрудника(Сотрудник, КадровыеДанные, Период) Экспорт
	
	Если ТипЗнч(КадровыеДанные) = Тип("Строка") Тогда
		КлючиСтруктуры = "Период,Сотрудник," + КадровыеДанные;
	Иначе
		КлючиСтруктуры = "Период,Сотрудник," + СтрСоединить(КадровыеДанные, ",");
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура(КлючиСтруктуры, Период, Сотрудник);
	
	МассивКадровыхДанных = КадровыеДанныеСотрудников(Сотрудник, КадровыеДанные, Период);
	Если МассивКадровыхДанных.Количество() > 0 Тогда
		Возврат МассивКадровыхДанных[0];
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(СтруктураВозврата);
	
КонецФункции

Функция КадровыеДанныеСотрудников(Сотрудники, КадровыеДанные, Период)
	
	Если ТипЗнч(КадровыеДанные) = Тип("Строка") Тогда
		КлючиСтруктуры = "Период,Сотрудник," + КадровыеДанные;
	Иначе
		КлючиСтруктуры = "Период,Сотрудник," + СтрСоединить(КадровыеДанные, ",");
	КонецЕсли;
	
	ВозвращаемыйМассив = Новый Массив;
	ТаблицаКадровыхДанных = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, Сотрудники, КадровыеДанные, Период);
	Для каждого СтрокаТаблицаКадровыхДанных Из ТаблицаКадровыхДанных Цикл
		
		СтруктураВозврата = Новый Структура(КлючиСтруктуры, Период);
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, СтрокаТаблицаКадровыхДанных);
		
		ВозвращаемыйМассив.Добавить(Новый ФиксированнаяСтруктура(СтруктураВозврата));
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ВозвращаемыйМассив);
	
КонецФункции

Функция ДокументыПоИностраннымГражданам(ВидУведомления, Основание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидУведомления", ВидУведомления);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УведомлениеОСпецрежимахНалогообложения.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.УведомлениеОСпецрежимахНалогообложения КАК УведомлениеОСпецрежимахНалогообложения
		|ГДЕ
		|	УведомлениеОСпецрежимахНалогообложения.ВидУведомления = &ВидУведомления
		|	И УведомлениеОСпецрежимахНалогообложения.Основание = &Основание
		|	И НЕ УведомлениеОСпецрежимахНалогообложения.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция ДанныеЗаполненияДокументовПоИностраннымГражданам(ВидУведомления, Основание) Экспорт
	
	ОтчетУведомлениеРаботаИностранцев = "РегламентированноеУведомлениеРаботаИностранцев";
	Если Метаданные.Отчеты.Найти(ОтчетУведомлениеРаботаИностранцев) = Неопределено Тогда
		ДанныеОтчета = ИнтеграцияБЗКБУНФ.КонтейнерЗаполненияУведомленияПоИностранцам();
	Иначе
		ДанныеОтчета = Отчеты[ОтчетУведомлениеРаботаИностранцев].КонтейнерЗаполнения(ВидУведомления);
	КонецЕсли;
	
	ДанныеДляЗаполнения = Новый Структура("Организация");
	ДанныеДляЗаполнения.Вставить("ДанныеЗаполнения", ДанныеОтчета);
	ДанныеДляЗаполнения.ДанныеЗаполнения.Основание = Основание;
	
	ДанныеДокумента = Новый Структура(
		"Организация,
		|ДатаСведений,
		|Сотрудник,
		|Должность,
		|ТрудовойДоговор,
		|ДоговорГПХ,
		|РазрешениеНаРаботу");
	
	Если Не КадровыйУчет.ЗаполнитьДанныеДокументовПоИностраннымГражданам(
		ДанныеДокумента, Основание) Тогда
		
		Возврат ДанныеДляЗаполнения;
	КонецЕсли;
	
	ИменаКадровыхДанных = "Фамилия,Имя,Отчество,ДатаРождения,Страна,МестоРождения,Пол,"
		+ "ДокументВид,ДокументСерия,ДокументНомер,ДокументДатаВыдачи,ДокументКемВыдан,"
		+ "Страна,ПриказОПриеме,ПриказОПриемеДата, Должность";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.КадровыйУчетРасширенная.КонтрактыДоговорыСотрудников") Тогда
		ИменаКадровыхДанных = ИменаКадровыхДанных + ",ДатаДоговораКонтракта";
	КонецЕсли;
	
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудника(ДанныеДокумента.Сотрудник, ИменаКадровыхДанных, ДанныеДокумента.ДатаСведений);
	
	Если КадровыеДанныеСотрудника.Страна = Справочники.СтраныМира.Россия Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = '%1 не является иностранным гражданином'"), ДанныеДокумента.Сотрудник);
	КонецЕсли;
	
	ДанныеДляЗаполнения.Вставить("Организация", ДанныеДокумента.Организация);
	
	Данные = ДанныеДляЗаполнения.ДанныеЗаполнения.Данные.Титульная;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Описание32п") Тогда
		Данные.Описание32п = Строка(ДанныеДокумента.Должность);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "ДокументРазр") Тогда
		Данные.ДокументРазр = ДанныеДокумента.РазрешениеНаРаботу;
	КонецЕсли;
	
	Если ДанныеДокумента.ТрудовойДоговор = Истина Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Флаг9") Тогда
			Данные.Флаг9 = "X";
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеДокумента.ДоговорГПХ = Истина Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Флаг10") Тогда
			Данные.Флаг10 = "X";
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Фамилия") Тогда
		Данные.Фамилия = КадровыеДанныеСотрудника.Фамилия;
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "ФамилияРус") Тогда
		Данные.ФамилияРус = КадровыеДанныеСотрудника.Фамилия;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Имя") Тогда
		Данные.Имя = КадровыеДанныеСотрудника.Имя;
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "ИмяРус") Тогда
		Данные.ИмяРус = КадровыеДанныеСотрудника.Имя;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Отчество") Тогда
		Данные.Отчество = КадровыеДанныеСотрудника.Отчество;
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "ОтчествоРус") Тогда
		Данные.ОтчествоРус = КадровыеДанныеСотрудника.Отчество;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Пол") Тогда
		Данные.Пол = Строка(КадровыеДанныеСотрудника.Пол);
	ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ОбязательстваВыплатаЗП Тогда
		Если КадровыеДанныеСотрудника.Пол = Перечисления.ПолФизическогоЛица.Женский Тогда
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Флаг17") Тогда
				Данные.Флаг17 = "V";
			КонецЕсли;
		Иначе
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Флаг16") Тогда
				Данные.Флаг16 = "V";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Данные.ДатаРождения = КадровыеДанныеСотрудника.ДатаРождения;
	Данные.Гражданство = Строка(КадровыеДанныеСотрудника.Страна);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "МестоРождения") Тогда
		Данные.МестоРождения = ПредставлениеМестаРождения(КадровыеДанныеСотрудника.МестоРождения);
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "МестоРожденияГосударство") Тогда
		Данные.МестоРожденияГосударство = ГосударствоМестаРождения(КадровыеДанныеСотрудника.МестоРождения);
	КонецЕсли;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "МестоРожденияНаселенныйПункт") Тогда
		Данные.МестоРожденияНаселенныйПункт = НаселенныйПунктМестаРождения(КадровыеДанныеСотрудника.МестоРождения);
	КонецЕсли;
		
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "Документ") Тогда
		Данные.Документ = Строка(КадровыеДанныеСотрудника.ДокументВид);
	КонецЕсли;
	
	Данные.Серия = КадровыеДанныеСотрудника.ДокументСерия;
	Данные.Номер = КадровыеДанныеСотрудника.ДокументНомер;
	Данные.ДатаВыдачи = КадровыеДанныеСотрудника.ДокументДатаВыдачи;
	Данные.КемВыдан = КадровыеДанныеСотрудника.ДокументКемВыдан;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Данные, "ДатаДоговора") Тогда
		Если ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.РасторжениеТрудовогоДоговора Тогда
			Данные.ДатаДоговора = ДанныеДокумента.ДатаСведений;
		Иначе
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(КадровыеДанныеСотрудника, "ДатаДоговораКонтракта") Тогда
				Данные.ДатаДоговора = КадровыеДанныеСотрудника.ДатаДоговораКонтракта;
			Иначе
				Данные.ДатаДоговора = КадровыеДанныеСотрудника.ПриказОПриемеДата;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеДляЗаполнения;
	
КонецФункции

Функция ПредставлениеМестаРождения(МестоРождения)
	
	ДанныеОМестеРождения = ПерсонифицированныйУчетКлиентСервер.РазложитьМестоРождения(МестоРождения, Ложь);
	Если ЗначениеЗаполнено(ДанныеОМестеРождения.Страна) Тогда
		Если ЗначениеЗаполнено(ДанныеОМестеРождения.НаселенныйПункт) Тогда
			Возврат СтрШаблон("%1, %2", ДанныеОМестеРождения.Страна, ДанныеОМестеРождения.НаселенныйПункт)
		Иначе
			Возврат ДанныеОМестеРождения.Страна;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеОМестеРождения.НаселенныйПункт;
	
КонецФункции

Функция ГосударствоМестаРождения(МестоРождения)
	
	ДанныеОМестеРождения = ПерсонифицированныйУчетКлиентСервер.РазложитьМестоРождения(МестоРождения, Ложь);
	Возврат ДанныеОМестеРождения.Страна;
	
КонецФункции

Функция НаселенныйПунктМестаРождения(МестоРождения)
	
	ДанныеОМестеРождения = ПерсонифицированныйУчетКлиентСервер.РазложитьМестоРождения(МестоРождения, Ложь);
	Возврат ДанныеОМестеРождения.НаселенныйПункт;
	
КонецФункции

#КонецОбласти
