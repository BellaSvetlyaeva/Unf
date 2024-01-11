///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура Base64ВШтрихкод(Base64Штрихкод, Штрихкод) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.Base64ВШтрихкод(Base64Штрихкод, Штрихкод, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
			Штрихкод = МодульВызова.Base64ВШтрихкод(Base64Штрихкод);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыПодтверждениеКМ() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ПараметрыПодтвержденияКМ = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПараметрыПодтверждениеКМ(ПараметрыПодтвержденияКМ, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиентСервер");
			ПараметрыПодтвержденияКМ = МодульВызова.ПараметрыПодтверждениеКМ();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыПодтвержденияКМ;
	
КонецФункции

Функция ПараметрыЗапросКМ() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ПараметрыЗапросКМ = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПараметрыЗапросКМ(ПараметрыЗапросКМ, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
			ПараметрыЗапросКМ = МодульВызова.ПараметрыЗапросКМ();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыЗапросКМ;
	
КонецФункции

Функция СистемаНалогообложенияККТПоКоду(КодСНО) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	СНО = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.СистемаНалогообложенияККТПоКоду(КодСНО, СНО, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиентСервер");
			СНО = МодульВызова.СистемаНалогообложенияККТПоКоду(КодСНО);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СНО;
	
КонецФункции

Функция ДополнительныеПараметрыОперации(СохранитьПодключениеККМ) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ДополнительныеПараметрыОперации = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ДополнительныеПараметрыОперации(СохранитьПодключениеККМ, ДополнительныеПараметрыОперации, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
			ДополнительныеПараметрыОперации = МодульВызова.ДополнительныеПараметрыОперации(СохранитьПодключениеККМ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДополнительныеПараметрыОперации;
	
КонецФункции

Функция ШтрихкодВBase64(Штрихкод) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	Base64Штрихкод = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ШтрихкодВBase64(Штрихкод, Base64Штрихкод, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
			Base64Штрихкод = МодульВызова.ШтрихкодВBase64(Штрихкод);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Base64Штрихкод;
	
КонецФункции

Функция КодСистемыНалогообложенияККТ(СНО) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	КодСистемыНалогообложенияККТ = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.КодСистемыНалогообложенияККТ(СНО, КодСистемыНалогообложенияККТ, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиентСервер");
			КодСистемыНалогообложенияККТ = МодульВызова.КодСистемыНалогообложенияККТ(СНО);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КодСистемыНалогообложенияККТ;
	
КонецФункции

Функция ПараметрыОткрытияЗакрытияСмены() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ПараметрыОперации = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПараметрыОткрытияЗакрытияСмены(ПараметрыОперации, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиентСервер");
			ПараметрыОперации = МодульВызова.ПараметрыОткрытияЗакрытияСмены();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыОперации;
	
КонецФункции

Функция ПараметрыВыполненияЭквайринговойОперации() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ПараметрыОперации = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПараметрыВыполненияЭквайринговойОперации(ПараметрыОперации, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("ОборудованиеПлатежныеСистемыКлиентСервер");
			ПараметрыОперации = МодульВызова.ПараметрыВыполненияЭквайринговойОперации();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыОперации;
	
КонецФункции

Функция ЭтоОСН(СистемаНалогообложения) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ЭтоОСН = Ложь;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ЯвляетсяОСН(ЭтоОСН, СистемаНалогообложения, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиентСервер");
			МодульВызова.ЯвляетсяОСН(ЭтоОСН, СистемаНалогообложения);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЭтоОСН;
	
КонецФункции

Функция ОпределитьТипШтрихкода(Штрихкод) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ТипШтрихкода = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ОпределитьТипШтрихкода(Штрихкод, ТипШтрихкода, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
			ТипШтрихкода = МодульВызова.ОпределитьТипШтрихкода(Штрихкод);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТипШтрихкода;
	
КонецФункции

Функция РазобратьШтриховойКодТовара(Штрихкод) Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ДанныеМаркировки = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.РазобратьШтриховойКодТовара(Штрихкод, ДанныеМаркировки, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияМаркировкаКлиентСервер");
			ДанныеМаркировки = МодульВызова.РазобратьШтриховойКодТовара(Штрихкод);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеМаркировки;
	
КонецФункции

Функция РазделительGS1() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	Разделитель = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПолучитьРазделительGS1(Разделитель, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияМаркировкаКлиентСервер");
			Разделитель = МодульВызова.РазделительGS1();
		КонецЕсли;
	КонецЕсли;
	
	Возврат Разделитель;
	
КонецФункции

Функция ЭкранированныйСимволGS1() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ЭкранированныйСимвол = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПолучитьЭкранированныйСимволGS1(ЭкранированныйСимвол, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияМаркировкаКлиентСервер");
			ЭкранированныйСимвол = МодульВызова.ЭкранированныйСимволGS1();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЭкранированныйСимвол;
	
КонецФункции

Функция ПараметрыТипыОборудования() Экспорт
	
	МодульИсполнения = МодульКлиентСервер();
	ПараметрыТипыОборудования = Неопределено;
	СтандартнаяОбработка = Истина;
	МенеджерОборудованияРМККлиентСерверПереопределяемый.ПараметрыТипыОборудования(ПараметрыТипыОборудования, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ИспользуетсяБПО() И МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
			МодульВызова = МодульИсполнения.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
			ПараметрыТипыОборудования = МодульВызова.ПараметрыТипыОборудования();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыТипыОборудования;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИспользуетсяБПО() Экспорт
	МодульИсполнения = МодульКлиентСервер();
	Возврат МодульИсполнения.ПодсистемаСуществует("ПоддержкаОборудования");
КонецФункции

Функция МодульКлиентСервер()
	
	МодульИсполнения = Неопределено;
	#Если Сервер Тогда
		МодульИсполнения = ОбщегоНазначения;
	#Иначе
		МодульИсполнения = ОбщегоНазначенияКлиент;
	#КонецЕсли
	
	Возврат МодульИсполнения;
	
КонецФункции

#КонецОбласти
