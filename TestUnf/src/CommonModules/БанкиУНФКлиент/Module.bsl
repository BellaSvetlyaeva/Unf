#Область ПрограммныйИнтерфейс

// Задает текст состояние разделенного объекта, устанавливает доступность
// кнопок управления состоянием и флага ТолькоПросмотр формы
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
Процедура ОбработатьФлагРучногоИзменения(Знач Форма) Экспорт
	
	Элементы  = Форма.Элементы;
	
	Если Форма.РучноеИзменение = Неопределено Тогда
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Элемент создан вручную. Автоматическое обновление не возможно.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = Ложь;
		Элементы.Родитель.Доступность = Истина;
		Элементы.Код.Доступность      = Истина;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли Форма.РучноеИзменение = Истина Тогда
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Автоматическое обновление элемента отключено.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Истина;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = Ложь;
		Элементы.Родитель.Доступность = Ложь;
		Элементы.Код.Доступность      = Ложь;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Элемент обновляется автоматически.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = Истина;
		Форма.ТолькоПросмотр          = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Выдает пользователю вопрос об обновлении из общих данных.
// В случае утвердительного ответа, возвращает Истина.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ВыполнитьОбновление - Булево
Процедура ОбновитьЭлементИзКлассификатора(Знач Форма, ВыполнитьОбновление) Экспорт
	
	ТекстВопроса = НСтр("ru = 'Данные элемента будут заменены данными из классификатора.
							|Все ручные изменения будут потеряны. Продолжить?'");
							
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ВыполнитьОбновление", ВыполнитьОбновление);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОпределитьНеобходимостьОбновленияДанныхИзКлассификатора", Форма,
		ДополнительныеПараметры);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти
