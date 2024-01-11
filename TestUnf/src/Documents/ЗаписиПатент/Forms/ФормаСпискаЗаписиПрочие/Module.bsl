#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация;
	Иначе
		Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = Справочники.Организации.ПредопределеннаяОрганизация();
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Патент) Тогда
		Патент = Параметры.Патент;
	ИначеЕсли ЗначениеЗаполнено(Организация) Тогда
		Патент = Справочники.Патенты.ПолучитьПатентПоУмолчанию(Организация, ТекущаяДатаСеанса());
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + ?(ПустаяСтрока(ЭтаФорма.Заголовок),"",": ")+НСтр("ru='Записи книги учета доходов (Патент)'");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Книга, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Книга, "Патент", Патент);
	ЗапуститьОбновлениеДанныхНаСервере();
	
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьКнопкиУдалить();
	ЖдатьЗавершенияФоновогоЗадания();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДобавитьРучнуюЗапись(Команда)
	ОткрытьФорму(
		"Документ.ЗаписиПатент.Форма.ФормаЗаписиДоходПатент",
		Новый Структура("ДокументыЗаПериод, Организация, Патент", ДокументыЗаПериод, Организация, Патент),
		Элементы.Книга, 
		ЭтаФорма.УникальныйИдентификатор,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура КнигаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура(
		"Ключ, НомерСтроки",
		Элементы.Книга.ТекущиеДанные.Регистратор,
		Элементы.Книга.ТекущиеДанные.НомерСтроки);
		
	ОткрытьФорму("Документ.ЗаписиПатент.Форма.ФормаЗаписиДоходПатент",ПараметрыФормы,Элементы.Книга);
	
КонецПроцедуры


&НаКлиенте
Процедура УдалитьЗапись(Команда)
	
	ТекущиеДанные = Элементы.Книга.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УдалитьЗаписьСервер(ТекущиеДанные.Регистратор,
		ТекущиеДанные.НомерСтроки);
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура КнигаПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКнопкиУдалить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКнигу(Команда)
	
	СписокЗаписейАктуален = Ложь;
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		ЖдатьЗавершенияФоновогоЗадания();
	Иначе
		ОповеститьОбИзменении(Тип("РегистрНакопленияКлючЗаписи.КнигаУчетаДоходовПатент"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Книга, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Книга, "Патент", Патент);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	Если ЗначениеЗаполнено(Организация) Тогда
		Патент = Справочники.Патенты.ПолучитьПатентПоУмолчанию(Организация, ТекущаяДатаСеанса());
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПатентПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Книга, "Патент", Патент);
	
	СписокЗаписейАктуален = Ложь;
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		ЖдатьЗавершенияФоновогоЗадания();
	Иначе
		ОповеститьОбИзменении(Тип("РегистрНакопленияКлючЗаписи.КнигаУчетаДоходовПатент"));
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура Сформировать(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура("Организация, Патент", Организация, Патент);
	
	ОткрытьФорму("Отчет.КнигаУчетаДоходовПатент.Форма.ФормаОтчета", ПараметрыОтчета);
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура УдалитьЗаписьСервер(Документ, НомерСтроки)
	
	Если Документ <> Неопределено Тогда
		Объект = Документ.ПолучитьОбъект();
		РабочаяСтрока = Объект.ЗаписиКнигаДоходовПатент[НомерСтроки-1];
		Объект.ЗаписиКнигаДоходовПатент.Удалить(РабочаяСтрока);
		Объект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопкиУдалить()
	
	Элементы.ФормаУдалитьЗапись.Доступность = (Элементы.Книга.ТекущиеДанные <> Неопределено);
	
КонецПроцедуры


&НаКлиенте
Процедура ЖдатьЗавершенияФоновогоЗадания()
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеДлительнойОперации",
			1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Запускает фоновое задание обновления Задач отчетности.
//
Функция ЗапуститьОбновлениеДанныхНаСервере()
	
	
	Если МонопольныйРежим() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		// Надо ждать
		Возврат Истина;
	КонецЕсли;
	
	ПараметрыФункции = Новый Структура();
	ПараметрыФункции.Вставить("Патент", Патент);
	
	НаименованиеЗадания = НСтр("ru = 'Обновление списка записей патента'");
	ИмяПроцедуры = "РегламентированнаяОтчетностьУСН.ВыполнитьФормированияЗаписейПатента_ФоновоеЗадание";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	Результат = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыФункции, ПараметрыВыполнения);
	
	ФоновоеЗаданиеЗадачИдентификатор   = Результат.ИдентификаторЗадания;
	
	Если Результат.Статус = "Выполнено" Тогда
		СписокЗаписейАктуален = Истина;
		УправлениеФормой(ЭтаФорма);
		Возврат Ложь;
	Иначе
		// Начнем ждать
		ФоновоеЗаданиеЗадачЗапущено = Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеДлительнойОперации()
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		
		Если ЗаданиеВыполнено(ФоновоеЗаданиеЗадачИдентификатор) Тогда
			
			ФоновоеЗаданиеЗадачЗапущено = Ложь;
			ОповеститьОбИзменении(Тип("РегистрНакопленияКлючЗаписи.КнигаУчетаДоходовПатент"));
			СписокЗаписейАктуален = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если ФоновоеЗаданиеЗадачЗапущено  Тогда
		// Продолжим ожидание
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьЗавершениеДлительнойОперации",
			1,
			Истина);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.СтраницаКнига.Видимость = Форма.СписокЗаписейАктуален;
	Элементы.СтраницаОжидание.Видимость = НЕ Форма.СписокЗаписейАктуален;
	
КонецПроцедуры

#КонецОбласти


