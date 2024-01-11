
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтараяАвторизация = РаспознаваниеДокументов.ТекущиеПараметрыАвторизации();
	СтароеРазделение = РегистрыСведений.ПараметрыАвторизацииИскусственногоИнтеллекта.СохраненныеНастройки(
		Перечисления.СервисыИскусственногоИнтеллекта.РаспознаваниеДокументов
	);
	
	ЕстьАктивныеМобильные = Справочники.МобильныеПриложенияРаспознаванияДокументов.ЕстьАктивныеМобильныеПриложения();
	
	РаспознаваниеДокументовСлужебный.ЗаблокироватьСервисРаспознавания();
	
	// новые параметры
	НовоеРазделение = РаспознаваниеДокументовСлужебный.ТекущиеПараметрыАвторизацииИИ();
	
	РегистрыСведений.ПараметрыАвторизацииИскусственногоИнтеллекта.Установить(
		Перечисления.СервисыИскусственногоИнтеллекта.РаспознаваниеДокументов,
		НовоеРазделение
	);
	
	ПытатьсяПодключитьсяПриПроверке = Ложь;
	АвторизацияУспешна = РаспознаваниеДокументов.ПодключеноКСервисуРаспознавания(ПытатьсяПодключитьсяПриПроверке);
	НоваяАвторизация = РаспознаваниеДокументов.ТекущиеПараметрыАвторизации();
	
	РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязьОПереподключении(
		СтараяАвторизация,
		СтароеРазделение,
		НоваяАвторизация,
		НовоеРазделение,
		Истина, "", ""
	);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИмяФормыВладельца = ВладелецФормы.ИмяФормы;
	Если АвторизацияУспешна И Не ЕстьАктивныеМобильные Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Команда)
	
	СтандартнаяОбработка = Ложь;
	Обработчик = Новый ОписаниеОповещения("ПослеПроверкиПодключенияКСервисуРаспознавания", ЭтотОбъект);
	РаспознаваниеДокументовКлиент.ПоказатьАвторизациюИТС(Обработчик, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МобильныеПриложения(Команда)
	ОткрытьФорму("Справочник.МобильныеПриложенияРаспознаванияДокументов.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	ОтправитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПродолжить(Команда)
	
	Закрыть();
	Если АвторизацияУспешна Тогда
		ОткрытьФорму(ИмяФормыВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Если АвторизацияУспешна Тогда
		Если ЕстьАктивныеМобильные Тогда
			Элементы.СтраницыПодсказок.ТекущаяСтраница = Элементы.СтраницаМобильныеПриложения;
		Иначе
			Элементы.СтраницыПодсказок.ТекущаяСтраница = Элементы.ГруппаПодключеноУспешно;
		КонецЕсли;
	КонецЕсли;
	
	СброситьРазмерыИПоложениеОкна();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиПодключенияКСервисуРаспознавания(Результат, Контекст) Экспорт
	
	Если Результат Тогда
		АвторизацияУспешна = Истина;
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// новые параметры
	НоваяАвторизация = РаспознаваниеДокументов.ТекущиеПараметрыАвторизации();
	НовоеРазделение = РаспознаваниеДокументовСлужебный.ТекущиеПараметрыАвторизацииИИ();
	
	РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязьОПереподключении(
		СтараяАвторизация,
		СтароеРазделение,
		НоваяАвторизация,
		НовоеРазделение,
		Ложь,
		ТекстПользователя,
		КонтактПользователя
	);
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОтправлено;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()

	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ПолноеИмяФормы = Метаданные.Обработки.РаспознаваниеДокументов.Формы.ФормаБлокировкиСервиса.ПолноеИмя();
		ХранилищеСистемныхНастроек.Удалить(ПолноеИмяФормы, "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

