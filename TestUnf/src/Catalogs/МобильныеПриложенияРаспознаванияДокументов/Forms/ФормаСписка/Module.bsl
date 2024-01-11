#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРаспознаваниеДокументов") Тогда
		ВызватьИсключение НСтр("ru = 'Функциональная опция ИспользоватьРаспознаваниеДокументов отключена.'");
	КонецЕсли;
	
	ПытатьсяПодключитьсяПриПроверке = Ложь;
	ПодключеноКСервисуРаспознавания = РаспознаваниеДокументов.ПодключеноКСервисуРаспознавания(ПытатьсяПодключитьсяПриПроверке);
	АккаунтАктивирован = РаспознаваниеДокументов.АккаунтАктивирован();
	ТекущиеНастройки = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.ТекущиеНастройки();
	
	АдресЭлПочты = ТекущиеНастройки.АдресЭлПочты;
	
	ОбновитьПодключенныеМобильныеПриложения();
	
	ОткрытьФормуБлокировкиСервиса = РаспознаваниеДокументовСлужебный.ТребуетсяЗаблокироватьСервисРаспознавания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОткрытьФормуБлокировкиСервиса Тогда
		РаспознаваниеДокументовСлужебныйКлиент.ПоказатьФормуБлокировки(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПерерисоватьПоСостоянию();
	
	Если Не ПодключеноКСервисуРаспознавания Тогда
		ВыполнитьАвторизацию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресЭлПочтыИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Ошибка = Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Текст);
	Элементы.ТекстНеверныйАдресЭлПочты.Видимость = Ошибка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодключенныеМобильныеПриложения

&НаКлиенте
Процедура ПодключенныеМобильныеПриложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	
	Обработчик = Новый ОписаниеОповещения("ПослеДобавленияИзмененияМобильногоПриложения", ЭтотОбъект);
	
	ОткрытьФорму(
		"Справочник.МобильныеПриложенияРаспознаванияДокументов.Форма.ФормаЭлемента",
		ПараметрыОткрытия,
		ЭтотОбъект,
		Элемент.ТекущиеДанные.Идентификатор,
		,
		,
		Обработчик
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключенныеМобильныеПриложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Обработчик = Новый ОписаниеОповещения("ПослеДобавленияИзмененияМобильногоПриложения", ЭтотОбъект);
	
	ОткрытьФорму(
		"Справочник.МобильныеПриложенияРаспознаванияДокументов.Форма.ФормаЭлемента",
		,
		ЭтотОбъект,
		Новый УникальныйИдентификатор,
		,
		,
		Обработчик
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключенныеМобильныеПриложенияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Авторизация(Команда)
	
	ВыполнитьАвторизацию();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьАдресЭлПочты(Команда)
	
	Ошибка = Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлПочты);
	Если Ошибка Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		СохранитьАдресЭлПочтыНаСервере();
		
		ПараметрыВопроса = РаспознаваниеДокументовСлужебныйКлиент.ПараметрыВопросаПользователю();
		ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
		ПараметрыВопроса.Картинка = БиблиотекаКартинок.УспешнаяОтправка;
		ПараметрыВопроса.Заголовок = НСтр("ru = 'Подписка оформлена'");
		
		РаспознаваниеДокументовСлужебныйКлиент.ПоказатьВопросПользователю(
			Неопределено,
			НСтр("ru = 'Адрес электронной почты подписан на уведомления'"),
			РежимДиалогаВопрос.ОК,
			ПараметрыВопроса
		);
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьПодключенныеМобильныеПриложения();
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОткрытьФорму("Справочник.МобильныеПриложенияРаспознаванияДокументов.Форма.ФормаЗагрузки");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КомандыДействий

&НаКлиенте
Процедура ВыполнитьАвторизацию()
	
	Обработчик = Новый ОписаниеОповещения("ПослеПроверкиПодключенияКСервисуРаспознавания", ЭтотОбъект);
	РаспознаваниеДокументовКлиент.ПоказатьАвторизациюИТС(Обработчик, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерерисоватьПоСостоянию()
	
	Если Не ПодключеноКСервисуРаспознавания Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ПроверкаАвторизации;
		Возврат;
	КонецЕсли;
	
	Если Не АккаунтАктивирован Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ОжиданиеАктивации;
		Возврат;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.МобильныеПриложения;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПодключенныеМобильныеПриложения()
	
	ПодключенныеМобильныеПриложения.Очистить();
	
	Справочники.МобильныеПриложенияРаспознаванияДокументов.АктуализироватьДанные();
	
	Для Каждого МобильноеПриложение Из Справочники.МобильныеПриложенияРаспознаванияДокументов.ПолучитьСписок() Цикл
		ЗаполнитьЗначенияСвойств(ПодключенныеМобильныеПриложения.Добавить(), МобильноеПриложение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеОбработчикиСобытий

&НаКлиенте
Процедура ПослеПроверкиПодключенияКСервисуРаспознавания(Результат, Контекст) Экспорт
	
	Если Результат Тогда 
		ПодключеноКСервисуРаспознавания = РаспознаваниеДокументовСлужебныйВызовСервера.ПодключеноКСервисуРаспознавания();
		ПерерисоватьПоСостоянию();
		Оповестить("РаспознанныйДокумент_ОбновитьПредставлениеБаланса");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеДобавленияИзмененияМобильногоПриложения(Результат, Контекст) Экспорт
	
	ОбновитьПодключенныеМобильныеПриложения();
	ПерерисоватьПоСостоянию();
	
КонецПроцедуры

#КонецОбласти

#Область БизнесЛогика

&НаСервере
Процедура СохранитьАдресЭлПочтыНаСервере()
	
	РаспознаваниеДокументовSDK.УстановитьАдресЭлектроннойПочты(АдресЭлПочты);
	
	МенеджерЗаписи = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.АдресЭлПочты = АдресЭлПочты;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти