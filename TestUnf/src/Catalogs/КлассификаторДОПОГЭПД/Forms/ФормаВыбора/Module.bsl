
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.КлассификаторДОПОГЭПД) Тогда
		Элементы.ФормаПодборИзКлассификатора.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторДОПОГЭПД.Форма.ДобавлениеЭлементовВКлассификатор", , ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", Элемент.ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("НаименованиеИНаписание", Элемент.ТекущиеДанные.НаименованиеИНаписание);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать опасный груз из классификатора.
		|Подобрать?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодборИзКлассификатора(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.КлассификаторДОПОГЭПД.ФормаОбъекта", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

