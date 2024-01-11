#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьПереданныеПараметры(Отказ);
	МаршрутыПодписанияБЭД.УстановитьУсловноеОформлениеДереваМаршрута(ЭтотОбъект, "СписокПодписантов", 
		Ложь, Ложь);
	
	Если Параметры.Свойство("ВидПодписи", ВидПодписи) Тогда
		Элементы.СписокПодписантовСертификат.Видимость = Параметры.ВидПодписи <> Перечисления.ВидыЭлектронныхПодписей.Простая;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПодписантов

&НаКлиенте
Процедура СписокПодписантовПодписантПриИзменении(Элемент)
	
	СтрокаПодписанта = Элементы.СписокПодписантов.ТекущиеДанные;
	ЗаполнитьСлужебныеРеквизитыСтрокиСписка(СтрокаПодписанта);
	
	Если Не ОтборСертификатовКорректный(СтрокаПодписанта.Сертификат, СтрокаПодписанта.ОтборСертификатов,
		ДоступныеДляВыбораСертификаты) Тогда
		СтрокаПодписанта.Сертификат = ПредопределенноеЗначение("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПодписантовСертификатПриИзменении(Элемент)
	
	СтрокаПодписанта = Элементы.СписокПодписантов.ТекущиеДанные;
	ЗаполнитьСлужебныеРеквизитыСтрокиСписка(СтрокаПодписанта);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ДанныеЗаполненыКорректно() Тогда
		АдресХраненияНастроек = ПолучитьАдресХраненияНастроекВыбораМаршрута(ВладелецФормы.УникальныйИдентификатор);
		Закрыть(АдресХраненияНастроек);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПодписанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВыборМаршрутаЗавершение", ЭтотОбъект);
	
	Отбор = МаршрутыПодписанияБЭДКлиент.НовыйОтборМаршрутовПодписания();
	Отбор.Организация = Организация;
	Если ВидПодписи <> ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.Простая") Тогда
		Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.ОднойДоступнойПодписью"));
	КонецЕсли;
	Отбор.СхемыПодписания.Добавить(ПредопределенноеЗначение("Перечисление.СхемыПодписанияЭД.ПоПравилам"));
	Отбор.ВидПодписи = ВидПодписи; 
	
	МаршрутыПодписанияБЭДКлиент.ВыбратьМаршрутПодписания(Отбор, Маршрут,
		ЭтотОбъект.УникальныйИдентификатор, Оповещение); 
		
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПодписанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборМаршрутаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Маршрут = Результат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ОтборСертификатовКорректный(Сертификат, СписокПодписантовДляОтбора, ДоступныеСертификаты)

	Возврат СписокПодписантовДляОтбора.НайтиПоЗначению(Сертификат.Пользователь) <> Неопределено
		И ДоступныеСертификаты.НайтиПоЗначению(Сертификат) <> Неопределено;

КонецФункции 

&НаСервере
Процедура ПрочитатьПереданныеПараметры(Отказ)

	Если Не ЗначениеЗаполнено(Параметры.ПараметрыМаршрута) Тогда
		Отказ = Истина;
		СтрокаОшибки = НСтр("ru = 'Не заданы параметры открытия формы'");
	Иначе 
	    ПараметрыМаршрута = ПолучитьИзВременногоХранилища(Параметры.ПараметрыМаршрута);
		УдалитьИзВременногоХранилища(Параметры.ПараметрыМаршрута);
		
		Если ТипЗнч(ПараметрыМаршрута) <> Тип("Структура") Тогда
			Отказ = Истина;
			СтрокаОшибки = НСтр("ru = 'Неверный тип параметров открытия формы'");
		ИначеЕсли Не Параметры.Свойство("Организация", Организация) ИЛИ Не ЗначениеЗаполнено(Организация) Тогда
			Отказ = Истина;
			СтрокаОшибки = НСтр("ru = 'В параметрах открытия формы не передана организация'");
		Иначе
			ДоступныеДляВыбораСертификаты.ЗагрузитьЗначения(ПараметрыМаршрута.ДоступныеДляВыбораСертификаты);
			
			Если ПараметрыМаршрута.ЗадаватьМаршрутВручную Тогда
				СпособУказанияМаршрута = "ЗадатьВручную";
				Маршрут = Справочники.МаршрутыПодписания.ОднойДоступнойПодписью;
			Иначе
				СпособУказанияМаршрута = "ВыбратьСуществующий";
				Маршрут = ПараметрыМаршрута.Маршрут;
			КонецЕсли;
			
			Для Каждого Подписант Из ПараметрыМаршрута.Подписанты Цикл
				СтрокаПодписанта = СписокПодписантов.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПодписанта, Подписант);
				ЗаполнитьСлужебныеРеквизитыСтрокиСписка(СтрокаПодписанта);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаОшибки) Тогда
		ВызватьИсключение СтрокаОшибки;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьАдресХраненияНастроекВыбораМаршрута(УникальныйИдентификаторФормыВладельца)

	ЗадаватьМаршрутВручную = СпособУказанияМаршрута = "ЗадатьВручную";
	Подписанты = СписокПодписантов.Выгрузить();
	
	Возврат МаршрутыПодписанияБЭД.СохранитьНастройкиВыбораМаршрута(УникальныйИдентификаторФормыВладельца,
		ЗадаватьМаршрутВручную, Подписанты, Маршрут);

КонецФункции
	
&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	
	Элементы.МаршрутПодписания.Доступность = СпособУказанияМаршрута = "ВыбратьСуществующий";
	Элементы.СписокПодписантов.Доступность = СпособУказанияМаршрута = "ЗадатьВручную";

КонецПроцедуры

&НаКлиенте
Процедура СпособУказанияМаршрутаПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеЗаполненыКорректно()
	
	Отказ = Ложь;
	Если СпособУказанияМаршрута = "ВыбратьСуществующий" Тогда
		Если Не ЗначениеЗаполнено(Маршрут) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран маршрут'"),, "Маршрут",, Отказ);
		КонецЕсли;
	Иначе
	    Если СписокПодписантов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указаны подписанты'"),, 
				"СписокПодписантов",, Отказ);
		Иначе
			МассивПодписантов = Новый Массив;
			МассивСертификатов = Новый Массив;
			
			Сч = 0;
			Для Каждого СтрокаПодписанта Из СписокПодписантов Цикл
				Если Не ЗначениеЗаполнено(СтрокаПодписанта.Подписант) Тогда
					СообщениеОбОшибке = СтрШаблон(НСтр("ru = 'Не выбран подписант в строке %1'"), Сч + 1);
					Поле = СтрШаблон("СписокПодписантов[%1].Подписант", Сч);
					ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,, Поле,, Отказ);
				ИначеЕсли МассивПодписантов.Найти(СтрокаПодписанта.Подписант) = Неопределено Тогда
					МассивПодписантов.Добавить(СтрокаПодписанта.Подписант);
				Иначе
					СообщениеОбОшибке = СтрШаблон(НСтр("ru = 'Подписант ""%1"" задублирован в строке %2'"), 
						СтрокаПодписанта.Подписант, Сч + 1);
					Поле = СтрШаблон("СписокПодписантов[%1].Подписант", Сч);
					ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,, Поле,, Отказ);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаПодписанта.Сертификат) Тогда
					Если МассивСертификатов.Найти(СтрокаПодписанта.Сертификат) = Неопределено Тогда
						МассивСертификатов.Добавить(СтрокаПодписанта.Сертификат);
					Иначе
						СообщениеОбОшибке = СтрШаблон(НСтр("ru = 'Сертификат ""%1"" задублирован в строке %2'"), 
							СтрокаПодписанта.Сертификат, Сч + 1);
						Поле = СтрШаблон("СписокПодписантов[%1].Сертификат", Сч);
						ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,, Поле,, Отказ);
					КонецЕсли;
				КонецЕсли;
				
				Сч = Сч + 1;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСлужебныеРеквизитыСтрокиСписка(СтрокаПодписанта)

	Если ЗначениеЗаполнено(СтрокаПодписанта.Сертификат) Тогда
		СтрокаПодписанта.ИндексКартинки 	= 1;
	Иначе
		СтрокаПодписанта.ИндексКартинки 	= 0;
	КонецЕсли;
	
	СписокПодписантовДляОтбора = Новый СписокЗначений;
	СписокПодписантовДляОтбора.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
	Если ЗначениеЗаполнено(СтрокаПодписанта.Подписант) Тогда
		СписокПодписантовДляОтбора.Добавить(СтрокаПодписанта.Подписант);
	КонецЕсли;
	СтрокаПодписанта.ОтборСертификатов = СписокПодписантовДляОтбора;

КонецПроцедуры


#КонецОбласти
