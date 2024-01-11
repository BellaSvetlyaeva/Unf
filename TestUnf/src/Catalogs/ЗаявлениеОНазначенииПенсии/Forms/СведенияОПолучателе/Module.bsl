
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметры(Параметры);
	ИнициализироватьЗначенияСервер();
	ИзменитьОформлениеФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнициализироватьЗначенияКлиент();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МестоПроживанияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ИзменитьОформлениеАдресов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ПриИзмененииТекстаРедактированияТелефона(Элемент.ТекстРедактирования, Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПриИзмененииТекстаРедактированияТелефона(Текст, Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаЖительстваНажатие(Элемент)
	
	ВидАдреса = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица");
	РедактироватьАдрес(Элемент, ВидАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаПребыванияНажатие(Элемент)
	
	ВидАдреса = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица");
	РедактироватьАдрес(Элемент, ВидАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФактическийНажатие(Элемент)
	
	ВидАдреса = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица");
	РедактироватьАдрес(Элемент, ВидАдреса);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	ДанныеКорректны = Истина;
	СведенияОПолучателеУказаныКорректно(ЭтотОбъект, ДанныеКорректны);
	
	Если ДанныеКорректны Тогда
		ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
		ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы); 
		ДополнительныеПараметры.Вставить("ПараметрыФормы",     ПараметрыФормы);
		ДополнительныеПараметры.Вставить("Модифицированность", Модифицированность);
		
		Модифицированность = Ложь;
		
		Закрыть(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СведенияОПолучателеУказаныКорректно(Форма, МастерДалее = Истина)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.СведенияОПолучателеУказаныКорректно(Форма, МастерДалее, Истина);
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьАдрес(Элемент, ВидАдреса)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АдресМестаЖительстваНажатие_Завершение", 
		ЭтотОбъект, 
		Элемент);
		
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(ВидАдреса, ЭтотОбъект[Элемент.Имя]);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", ЗапретитьИзменение);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаЖительстваНажатие_Завершение(Результат, Элемент) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Адрес         = Результат.КонтактнаяИнформация;
	Представление = Результат.Представление;
	
	Если Представление <> Элемент.Заголовок Тогда
		Модифицированность      = Истина;
		Элемент.Заголовок       = Представление;
		ЭтотОбъект[Элемент.Имя] = Результат.КонтактнаяИнформация;
		ИзменитьОформлениеАдресов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	
	ЗапретитьИзменение = Параметры.ЗапретитьИзменение;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьЗначенияСервер()
	
	// Адреса
	Если НЕ ЗначениеЗаполнено(МестоПроживания) Тогда
		
		Если ЗначениеЗаполнено(АдресМестаЖительства)
			ИЛИ ЗначениеЗаполнено(АдресМестаПребывания)
			ИЛИ ЗначениеЗаполнено(АдресФактический) Тогда
			
			МестоПроживания = Перечисления.МестоПроживанияПолучателяПенсии.ПроживаетВРФ;
			
		ИначеЕсли ЗначениеЗаполнено(АдресЗаПределамиРФНаРусском)
			ИЛИ ЗначениеЗаполнено(АдресЗаПределамиРФНаИностранном) Тогда
			
			МестоПроживания = Перечисления.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьЗначенияКлиент()
	
	// Телефоны
	Элемент = Элементы.Телефон;
	Элемент.ОбновитьТекстРедактирования();
	ПриИзмененииТекстаРедактированияТелефона(Элемент.ТекстРедактирования, Элемент, Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеФормы(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ЗапретитьИзменение Тогда
		Элементы.Телефон.ТолькоПросмотр                         = Истина;
		Элементы.ЭлектроннаяПочта.ТолькоПросмотр                = Истина;
		Элементы.МестоПроживания.ТолькоПросмотр                 = Истина;
		Элементы.АдресЗаПределамиРФНаРусском.ТолькоПросмотр     = Истина;
		Элементы.АдресЗаПределамиРФНаИностранном.ТолькоПросмотр = Истина;
		Элементы.ГруппаУдостоверение.ТолькоПросмотр             = Истина;
		Элементы.ГруппаПрочее.ТолькоПросмотр                    = Истина;
		// Обход ошибки платформы 10196698 Элемент длиннее на пол кнопки
		Элементы.МестоПроживания.Ширина                         = 25;
		Элементы.ВидДокумента.Ширина                            = 27;
	КонецЕсли;
	
	ИзменитьОформлениеАдресов(Форма);
	
	Форма.Заголовок = СтрШаблон(НСтр("ru = 'Контакты, паспорт и др. (%1)'"), Форма.Сотрудник);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдресов(Форма)
	
	ИзменитьОформлениеМестаПроживания(Форма);
	ИзменитьОформлениеАдресаМестаЖительства(Форма);
	ИзменитьОформлениеАдресаМестаПребывания(Форма);
	ИзменитьОформлениеАдресаФактический(Форма);
	ИзменитьОформлениеИностранногоАдреса(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеМестаПроживания(Форма)
	
	Элементы            = Форма.Элементы;
	Пенсионеру          = ПредопределенноеЗначение("Перечисление.ВидыПолучателейПенсии.Пенсионер");
	ЗаполненВид         = ЗначениеЗаполнено(Форма.МестоПроживания);
	ЭтоИностранныйАдрес = Форма.МестоПроживания = ПредопределенноеЗначение("Перечисление.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ");
	ОтображатьАдресаРФ  = ЗаполненВид И НЕ ЭтоИностранныйАдрес;
	
	ДоставлятьПенсионеру = Форма.КомуДоставлятьПенсию = Пенсионеру;
	ДоставлятьПенсионеруДоЗаключенияДоговора = Форма.КомуДоставлятьПенсиюДоЗаключенияДоговора = Пенсионеру;
	
	СпособыПолученияПенсии = Новый Массив;
	СпособыПолученияПенсии.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуЖительства"));
	СпособыПолученияПенсии.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуПребывания"));
	СпособыПолученияПенсии.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуФактическому"));
	
	// Ошибка будет когда указано доставлять на иностранный адрес, либо значение не заполнено
	ЕстьОшибка = ЭтоИностранныйАдрес И Форма.ЭтоЗаявлениеОДоставкеПенсии
		И (СпособыПолученияПенсии.Найти(Форма.СпособПолученияПенсии) <> Неопределено И ДоставлятьПенсионеру 
		ИЛИ СпособыПолученияПенсии.Найти(Форма.СпособПолученияПенсииДоЗаключенияДоговора) <> Неопределено И ДоставлятьПенсионеруДоЗаключенияДоговора)
		ИЛИ НЕ ЗначениеЗаполнено(Форма.МестоПроживания);
		
	Элементы.МестоПроживания.АвтоОтметкаНезаполненного = НЕ ЕстьОшибка;
	Элементы.МестоПроживания.ОтметкаНезаполненного = ЕстьОшибка;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдресаМестаЖительства(Форма)
	
	Элементы            = Форма.Элементы;
	Пенсионеру          = ПредопределенноеЗначение("Перечисление.ВидыПолучателейПенсии.Пенсионер");
	ПоМестуПребывания   = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуПребывания");
	ЗаполненВид         = ЗначениеЗаполнено(Форма.МестоПроживания);
	ЭтоИностранныйАдрес = Форма.МестоПроживания = ПредопределенноеЗначение("Перечисление.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ");
	ОтображатьАдресаРФ  = ЗаполненВид И НЕ ЭтоИностранныйАдрес;
	
	ДоставлятьПенсионеру = Форма.КомуДоставлятьПенсию = Пенсионеру;
	ДоставлятьПенсионеруДоЗаключенияДоговора = Форма.КомуДоставлятьПенсиюДоЗаключенияДоговора = Пенсионеру;
	
	// Адрес места пребывания
	Параметры = ПараметрыПроцедурыИзменитьОформлениеАдреса();
	Параметры.Имя       = "АдресМестаПребывания";
	Параметры.Видимость = ОтображатьАдресаРФ;
	Параметры.Подсказка = НСтр("ru = 'Полный адрес места жительства'");
	ИзменитьОформлениеАдреса(Форма, Параметры);
	
	ЕстьОшибка = ОтображатьАдресаРФ И Форма.ЭтоЗаявлениеОДоставкеПенсии И НЕ ЗначениеЗаполнено(Форма.АдресМестаПребывания)
		И (Форма.СпособПолученияПенсии = ПоМестуПребывания И ДоставлятьПенсионеру
		ИЛИ Форма.СпособПолученияПенсииДоЗаключенияДоговора = ПоМестуПребывания И ДоставлятьПенсионеруДоЗаключенияДоговора); 
		
	ВыделитьКрасным(ЕстьОшибка, Элементы.АдресМестаПребывания);
		
	ВыделитьКрасным(ЕстьОшибка, Элементы.АдресМестаЖительства);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдресаМестаПребывания(Форма)
	
	Элементы            = Форма.Элементы;
	Пенсионеру          = ПредопределенноеЗначение("Перечисление.ВидыПолучателейПенсии.Пенсионер");
	ПоМестуЖительства   = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуЖительства");
	ЗаполненВид         = ЗначениеЗаполнено(Форма.МестоПроживания);
	ЭтоИностранныйАдрес = Форма.МестоПроживания = ПредопределенноеЗначение("Перечисление.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ");
	ОтображатьАдресаРФ  = ЗаполненВид И НЕ ЭтоИностранныйАдрес;
	
	ДоставлятьПенсионеру = Форма.КомуДоставлятьПенсию = Пенсионеру;
	ДоставлятьПенсионеруДоЗаключенияДоговора = Форма.КомуДоставлятьПенсиюДоЗаключенияДоговора = Пенсионеру;
	
	Параметры = ПараметрыПроцедурыИзменитьОформлениеАдреса();
	Параметры.Имя       = "АдресМестаЖительства";
	Параметры.Видимость = ОтображатьАдресаРФ;
	Параметры.Подсказка = НСтр("ru = 'Заполняется при наличии подтвержденного регистрацией места пребывания'");
	ИзменитьОформлениеАдреса(Форма, Параметры);
	
	ЕстьОшибка = ОтображатьАдресаРФ И Форма.ЭтоЗаявлениеОДоставкеПенсии И НЕ ЗначениеЗаполнено(Форма.АдресМестаЖительства)
		И (Форма.СпособПолученияПенсии = ПоМестуЖительства И ДоставлятьПенсионеру
		ИЛИ Форма.СпособПолученияПенсииДоЗаключенияДоговора = ПоМестуЖительства И ДоставлятьПенсионеруДоЗаключенияДоговора); 
		
	ВыделитьКрасным(ЕстьОшибка, Элементы.АдресМестаЖительства);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдресаФактический(Форма)
	
	Элементы            = Форма.Элементы;
	Пенсионеру          = ПредопределенноеЗначение("Перечисление.ВидыПолучателейПенсии.Пенсионер");
	ПоМестуФактическому = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуФактическому");
	ЗаполненВид         = ЗначениеЗаполнено(Форма.МестоПроживания);
	ЭтоИностранныйАдрес = Форма.МестоПроживания = ПредопределенноеЗначение("Перечисление.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ");
	ОтображатьАдресаРФ  = ЗаполненВид И НЕ ЭтоИностранныйАдрес;
	
	ДоставлятьПенсионеру = Форма.КомуДоставлятьПенсию = Пенсионеру;
	ДоставлятьПенсионеруДоЗаключенияДоговора = Форма.КомуДоставлятьПенсиюДоЗаключенияДоговора = Пенсионеру;
	
	Параметры = ПараметрыПроцедурыИзменитьОформлениеАдреса();
	Параметры.Имя       = "АдресФактический";
	Параметры.Видимость = ОтображатьАдресаРФ;
	Параметры.Подсказка = НСтр("ru = 'Заполняется, если адрес места фактического проживания не совпадает с местом жительства или пребывания либо нет подтвержденного регистрацией места жительства и пребывания'");
	ИзменитьОформлениеАдреса(Форма, Параметры);
	
	// Место факт. проживания
	ЕстьОшибка = ОтображатьАдресаРФ И Форма.ЭтоЗаявлениеОДоставкеПенсии И НЕ ЗначениеЗаполнено(Форма.АдресФактический)
		И (Форма.СпособПолученияПенсии = ПоМестуФактическому И ДоставлятьПенсионеру
		ИЛИ Форма.СпособПолученияПенсииДоЗаключенияДоговора = ПоМестуФактическому И ДоставлятьПенсионеруДоЗаключенияДоговора); 
		
	ВыделитьКрасным(ЕстьОшибка, Элементы.АдресФактический);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеИностранногоАдреса(Форма)
	
	ЗаполненВид         = ЗначениеЗаполнено(Форма.МестоПроживания);
	ЭтоИностранныйАдрес = Форма.МестоПроживания = ПредопределенноеЗначение("Перечисление.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ");
	
	// Видимость иностранных адресов
	ОтображатьИностранныйАдрес  = ЗаполненВид И ЭтоИностранныйАдрес;
	
	// Адрес места жительства за пределами РФ (на русском)
	Параметры = ПараметрыПроцедурыИзменитьОформлениеАдреса();
	Параметры.Имя        = "АдресЗаПределамиРФНаРусском";
	Параметры.Видимость  = ОтображатьИностранныйАдрес;
	Параметры.Подсказка  = НСтр("ru = 'Адрес места жительства на территории другого государства на русском языке'");
	Параметры.ЭтоАдресРФ = Ложь;
	ИзменитьОформлениеАдреса(Форма, Параметры);
	
	// Адрес места жительства за пределами РФ (на иностранном)
	Параметры = ПараметрыПроцедурыИзменитьОформлениеАдреса();
	Параметры.Имя        = "АдресЗаПределамиРФНаИностранном";
	Параметры.Видимость  = ОтображатьИностранныйАдрес;
	Параметры.Подсказка  = НСтр("ru = 'Адрес места жительства на территории другого государства на иностранном языке'");
	Параметры.ЭтоАдресРФ = Ложь;
	ИзменитьОформлениеАдреса(Форма, Параметры);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВыделитьКрасным(УсловиеОшибки, Элемент)
	
	Если УсловиеОшибки Тогда
		Элемент.ЦветТекста = Новый Цвет(178, 34, 34);
	Иначе
		Элемент.ЦветТекста = Новый Цвет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПроцедурыИзменитьОформлениеАдреса()
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Имя",        "");
	ДополнительныеПараметры.Вставить("Видимость",  Ложь);
	ДополнительныеПараметры.Вставить("Подсказка",  "");
	ДополнительныеПараметры.Вставить("ЭтоАдресРФ", Истина);
	
	Возврат ДополнительныеПараметры;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдреса(Форма, ВходящийКонтекст)

	Имя        = ВходящийКонтекст.Имя;
	Видимость  = ВходящийКонтекст.Видимость;
	Подсказка  = ВходящийКонтекст.Подсказка;
	ЭтоАдресРФ = ВходящийКонтекст.ЭтоАдресРФ;
	
	Элементы                                     = Форма.Элементы;
	Элементы[Имя].Видимость                      = Видимость;
	Элементы[Имя].РасширеннаяПодсказка.Заголовок = Подсказка;
	Элементы[Имя].ОтображениеПодсказки           = ОтображениеПодсказки.Кнопка;
	Элементы[Имя + "Заголовок"].Видимость        = Видимость;
	
	Если ЭтоАдресРФ Тогда
		ДополнитьПодсказкуДляПроживавшихВРФ(Форма, Элементы[Имя].РасширеннаяПодсказка.Заголовок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма[Имя]) И ЭтоАдресРФ Тогда
		Элементы[Имя].Заголовок = ПредставлениеКонтактнойИнформации(Форма[Имя]);
	ИначеЕсли ЗначениеЗаполнено(Форма[Имя]) И НЕ ЭтоАдресРФ Тогда
		Элементы[Имя].Заголовок = Форма[Имя];
	ИначеЕсли Форма.ЗапретитьИзменение И ТипЗнч(Элементы[Имя]) = Тип("ДекорацияФормы") Тогда
		Элементы[Имя].Гиперссылка = Ложь;
		Элементы[Имя].Заголовок = НСтр("ru = 'Не указан'");
	Иначе
		Элементы[Имя].Заголовок = НСтр("ru = 'Заполнить'");
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеКонтактнойИнформации(ЗначениеАдреса)
	
	Возврат УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(ЗначениеАдреса);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ДополнитьПодсказкуДляПроживавшихВРФ(Форма, Заголовок)
	
	ПроживалВРФ = Форма.МестоПроживания = ПредопределенноеЗначение("Перечисление.МестоПроживанияПолучателяПенсии.ПроживалВРФ");
	
	Если ПроживалВРФ Тогда
		Заголовок = СокрЛП(НСтр("ru = 'Указывается адрес до выезда за пределы Российской Федерации.'") + Символы.ПС + Заголовок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииТекстаРедактированияТелефона(Текст, Элемент, ИзмененоВручную = Ложь)
	
	Если ИзмененоВручную Тогда
		Пауза = 1.5;
	Иначе
		Пауза = 0.1;
	КонецЕсли;
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	
	// Обновляем фактичекое значение
	Если ЗначениеЗаполнено(Представление) Тогда
		// Устанавливаем телефон в виде +7 ХХХ ХХХ-ХХ-ХХ
		Телефон = Представление;
	Иначе
		// В противном случае, устанавливаем то, что ввел пользователь
		Телефон = Текст;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефон");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТелефон", Пауза, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТелефон()
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Телефон);
	
	// Меняем отображение на форме
	Если ЗначениеЗаполнено(Представление) Тогда
		Элементы.Телефон.ОбновитьТекстРедактирования();
	КонецЕсли;
	Элементы.Телефон.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(Представление);
	
КонецПроцедуры

#КонецОбласти

