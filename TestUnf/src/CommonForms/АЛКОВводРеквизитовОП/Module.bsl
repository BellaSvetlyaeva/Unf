
////////////////////////////////////////////////////////////////////////////////
//
// Параметры формы
// 		Заголовок 			- Строка - Заголовок формы.
//
//		СведенияОбОП 		- Структура данных, со свойствами:
//			* Наименование 			- Наимкенование ОП.
//			* КПП					- КПП ОП.
//			Адресные поля:
//			
//			* УникальныйНомерФИАС	- Необязательный. Уникальный идентификатор адреса в системе ФИАС.
//			* ДополнительныеКоды	- Необязательный. Структура, может быть пустой.
//
//			* АдресXML				- Необязательный.
//			* АдресJSON				- Необязательный.
//									XML представление адреса подсистемы УправлениеКонтактнойИнформацией
//			Должны быть заполнены хотя бы одно из:
//			либо АдресXML, либо поля
//			* КодСтраны				- Необязательный.
//			* Страна				- Необязательный.
//			* Индекс				- Необязательный.
//			* КодРегиона			- Необязательный.
//			* Регион				- Необязательный.
//			* Район					- Необязательный.
//			* Город					- Необязательный.
//			* НаселенныйПункт		- Необязательный.
//			* Улица					- Необязательный.
//			* Дом					- Необязательный.
//			* Корпус				- Необязательный.
//			* Литера				- Необязательный.
//			* Квартира				- Необязательный.
//			* ПредставлениеАдреса	- Необязательный.
//
//		ЭтоПБОЮЛ			- Булево - Истина, если организация владелей ОП - ИП.
// 
//  
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Перем СтартовыйКПП, СтартовоеНаименование, СтартовыйАдрес;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
	    Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	ОбрабатываемыеДанные = РегламентированнаяОтчетностьАЛКО.ПолучитьПустуюСтруктуруСведенийОбОП();
	
	Если ТипЗнч(Параметры.СведенияОбОП) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, Параметры.СведенияОбОП);		
		ОбрабатываемыеДанные.Вставить("Регион", РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(Параметры.СведенияОбОП.КодРегиона));
	КонецЕсли;

	ОбрабатываемыеДанные = РегламентированнаяОтчетностьАЛКО.ОбновитьСтруктуруАдресаИзСтрокиJSONилиXMLСтруктурыАдреса(
													ОбрабатываемыеДанные, Ложь);
	Наименование = ОбрабатываемыеДанные.Наименование;
	
	ЭтоВиноградная = Параметры.ЭтоВиноградная;
	ЕстьДобавитьВиноградник = Параметры.ЕстьДобавитьВиноградник; 
	
	ПараметрыИзФормы = Параметры.ПараметрыИзФормы;
	ЕстьПараметрыИзФормы = РегламентированнаяОтчетностьАЛКОКлиентСервер.ЭтоСтруктура(ПараметрыИзФормы);
	
	НаименованиеНеОбязательно = (ЭтоВиноградная И (НЕ ЕстьДобавитьВиноградник));
	
	Если Параметры.ЭтоПБОЮЛ Тогда
		
		КПП = "";
		Элементы.КПП.Видимость = Ложь;
		
		Если ЭтоВиноградная Тогда
			Заголовок = "Реквизиты виноградника";
		Иначе	
		    Заголовок = "Реквизиты объекта торговли";
		КонецЕсли;
		
	Иначе
		
		КПП = ОбрабатываемыеДанные.КПП;
		
		Если ЭтоВиноградная Тогда
			Заголовок = "Реквизиты виноградника";
		Иначе
			Заголовок = "Реквизиты обособленного подразделения";
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
	    Заголовок = Параметры.Заголовок;	
	КонецЕсли;
	
	НаименованиеВиноградной = Наименование; 
	
	УникальностьФормы = Параметры.УникальностьФормы;
	
	Если ЕстьПараметрыИзФормы Тогда
	
		Если ПараметрыИзФормы.Свойство("НаименованиеНеОбязательно") Тогда
		
			НаименованиеНеОбязательно = ПараметрыИзФормы["НаименованиеНеОбязательно"];
		
		КонецЕсли;
		
		Если ПараметрыИзФормы.Свойство("Заголовок") Тогда
		
			Заголовок = ПараметрыИзФормы["Заголовок"];
		
		КонецЕсли;
		
		Если ПараметрыИзФормы.Свойство("ЦветСтиляНезаполненныйРеквизит") Тогда
		
			ЦветСтиляНезаполненныйРеквизит = ПараметрыИзФормы["ЦветСтиляНезаполненныйРеквизит"];
		
		КонецЕсли;
		Если ПараметрыИзФормы.Свойство("ЦветСтиляЦветГиперссылкиБРО") Тогда
		
			ЦветСтиляЦветГиперссылкиБРО = ПараметрыИзФормы["ЦветСтиляЦветГиперссылкиБРО"];
		
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Наименование.Видимость = НЕ НаименованиеНеОбязательно;
	Элементы.НаименованиеВиноградной.Видимость = НаименованиеНеОбязательно;
		
	
		
	АдресПредставление = ВывестиПредставлениеАдреса(ОбрабатываемыеДанные);
	
	ОбновитьЦветаСсылок();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
	    Отказ = Истина;
		ТекстПредупреждения = НСтр("ru='Данная форма вспомогательная, предназначена для редактирования данных
										|из форм регламентированных отчетов!'");
		ПоказатьПредупреждение(, ТекстПредупреждения, , НСтр("ru='Форма ввода реквизитов ОП.'"));
		Возврат;	
	КонецЕсли;
	
	СправочникиВидыКонтактнойИнформацииФактАдресОрганизации = ВладелецФормы.СтруктураРеквизитовФормы.СправочникиВидыКонтактнойИнформации.ТолькоНациональныйАдрес;
	
	СтартовыйКПП			= СокрЛП(КПП);
	СтартовоеНаименование	= ?(Элементы.Наименование.Видимость, СокрЛП(Наименование), СокрЛП(НаименованиеВиноградной));
	СтартовыйАдрес			= СокрЛП(АдресПредставление);	
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормы") Тогда			
		    Модифицированность = Ложь;
			Закрыть();			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗаголовокФормыВвода = "Ввод адреса";
	ВидКонтактнойИнформации = СправочникиВидыКонтактнойИнформацииФактАдресОрганизации;
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуКонтактнойИнформацииЗавершение", ЭтаФорма);
	
	РегламентированнаяОтчетностьАЛКОКлиент.ВызватьФормуВводаАдресаАЛКО(
							ОбрабатываемыеДанные, ЗаголовокФормыВвода, Оповещение, ВидКонтактнойИнформации);
	
КонецПроцедуры


&НаКлиенте
Процедура КППОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Текст = СтрЗаменить(Текст, " ", "");
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	ПроверкаМодифицированности();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	ПроверкаМодифицированности();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеВинограднойПриИзменении(Элемент)
	ПроверкаМодифицированности();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(РезультатВвода());

КонецПроцедуры


&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();

КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ВывестиПредставлениеАдреса(СтруктураАдреса)
		
	ПредставлениеБезЗапятых = СтрЗаменить(СтруктураАдреса.ПредставлениеАдреса, ",", "");
	Если ЗначениеЗаполнено(ПредставлениеБезЗапятых) Тогда
		Результат = СтруктураАдреса.ПредставлениеАдреса;
		
	ИначеЕсли СтруктураАдреса.Свойство("ЕстьJSON") И СтруктураАдреса.ЕстьJSON Тогда
		
		Результат = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(СтруктураАдреса.АдресJSON);
		Если ЗначениеЗаполнено(Результат) Тогда
		    СтруктураАдреса.ПредставлениеАдреса = Результат;
		Иначе	
		    Результат = "Ввести адрес";
		КонецЕсли;
		
	ИначеЕсли СтруктураАдреса.Свойство("ЕстьXML") И СтруктураАдреса.ЕстьXML Тогда
		
		Результат = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(СтруктураАдреса.АдресXML);
		Если ЗначениеЗаполнено(Результат) Тогда
		    СтруктураАдреса.ПредставлениеАдреса = Результат;
		Иначе	
		    Результат = "Ввести адрес";
		КонецЕсли;
		
	Иначе		
		Результат = "Ввести адрес";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПроверкаМодифицированности()
	
	ИзменяемоеНаименование = ?(Элементы.Наименование.Видимость, Наименование, НаименованиеВиноградной);
	
	Модифицированность = 						(СтартовыйКПП			<> СокрЛП(КПП));
	Модифицированность = Модифицированность или (СтартовоеНаименование	<> СокрЛП(ИзменяемоеНаименование));
	Модифицированность = Модифицированность или (СтартовыйАдрес			<> СокрЛП(АдресПредставление));

КонецПроцедуры
 

&НаСервере
Процедура ОбновитьЦветаСсылок()
		
	Элементы.Адрес.ЦветТекста = ?(АдресПредставление = "Ввести адрес", 
										ЦветСтиляНезаполненныйРеквизит, 
										ЦветСтиляЦветГиперссылкиБРО);
										
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(Адрес, ПроверитьАдрес = Ложь)

	Возврат РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(Адрес, ПроверитьАдрес);
	
КонецФункции


&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
	    Возврат;	
	КонецЕсли;
		
	СтруктураАдреса = Неопределено;
	
	Если НЕ (ТипЗнч(Результат) = Тип("Структура")) Тогда
		Возврат;	
	КонецЕсли;
		
		
	АдресXML				=  Результат.КонтактнаяИнформация;  // формат XML
	АдресJSON				=  Результат.Значение;				// формат JSON
	ПредставлениеАдреса		=  Результат.Представление;
	
	Если ЗначениеЗаполнено(АдресJSON) Тогда
	
		СтруктураАдреса = 
			ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(АдресJSON, Истина);	
			
	Иначе
			
		СтруктураАдреса = 
			ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(АдресXML, Истина);	
			
	КонецЕсли; 
	
	Для каждого КлючЗначение Из СтруктураАдреса Цикл
		
		Если НЕ ОбрабатываемыеДанные.Свойство(КлючЗначение.Ключ) Тогда
			ОбрабатываемыеДанные.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);			
		КонецЕсли; 
	
	КонецЦикла;
		
	ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, СтруктураАдреса);
	
	АдресПредставление = ВывестиПредставлениеАдреса(ОбрабатываемыеДанные);
	
	ПроверкаМодифицированности();
	
	ОбновитьЦветаСсылок();
	
КонецПроцедуры


&НаКлиенте
Функция РезультатВвода()
	
	ИзменяемоеНаименование = ?(Элементы.Наименование.Видимость, Наименование, НаименованиеВиноградной);
	
	ОбрабатываемыеДанные.Наименование = ИзменяемоеНаименование;
		
	ОбрабатываемыеДанные.КПП = КПП;
	
	Возврат ОбрабатываемыеДанные;
	
КонецФункции


#КонецОбласти