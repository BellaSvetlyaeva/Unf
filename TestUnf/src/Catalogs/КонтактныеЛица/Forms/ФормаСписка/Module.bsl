
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.КонтактныеЛица);
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере(Метаданные.Справочники.КонтактныеЛица, НастройкиЗагрузкиДанных, ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	
	// УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	// Конец УНФ.ОтборыСписка
	
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Параметры.Свойство("ОткрытиеИзФормыКонтрагента",ОткрытиеИзФормыКонтрагента);
		Если ОткрытиеИзФормыКонтрагента Тогда
			Элементы.ФормаСоздать.Видимость = Ложь;
			Элементы.ФормаСкопировать.Видимость = Ложь;
			Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
			Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
		КонецЕсли;
	Иначе
		КлючНазначенияИспользования = "Список";
	КонецЕсли;
	
	ЗаполнитьКонтрагентаИзВладельца();
	
	Если Параметры.Отбор.Свойство("Контрагент") И ЗначениеЗаполнено(Параметры.Отбор.Контрагент) Тогда
		
		Элементы.Связи.Видимость = Параметры.Отбор.Свойство("ТекущийКонтакт");
		Элементы.ОтборСвязи.Видимость = Элементы.Связи.Видимость;
		Элементы.Контрагент.Видимость = Параметры.Отбор.Свойство("ТекущийКонтакт");
		Элементы.ОтборКонтрагент.Видимость = Элементы.Контрагент.Видимость;
		
		Если Параметры.Отбор.Свойство("ТекущийКонтакт") Тогда
			Элементы.Список.ТекущаяСтрока = Параметры.Отбор.ТекущийКонтакт;
			УстановитьМеткуИОтборСписка("Контрагент", "Контрагент", Параметры.Отбор.Контрагент);
		КонецЕсли;
		
		ОтборСвязи = "ЕстьСвязи";
		УстановитьОтборПоДействительнымСвязям();
		
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,,,
		Не Элементы.ПоказыватьНедействительных.Пометка);
		
	ПрочитатьИерархию();
	
	Если НЕ Элементы.Список.РежимВыбора Тогда
		ВариантОтборовФормы = "";
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список,,,Новый Структура("ОтборПериод", "ДатаСоздания"), ВариантОтборовФормы);
		ВосстановитьНастройкиОтборовПоСвязям();	
	Иначе
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Новый СтандартныйПериод);		
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		РаботаСОтборами.НастроитьПанельОтборовМобильныйКлиент(ЭтотОбъект,,,"ОтборСвязи,ОтборКонтрагент,ОтборТег,ОтборИсточник,ОтборОтветственный,ОтборИерархияТекущая",,Истина);
		Элементы.ОсновныеСведения.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	Иначе
		Элементы.ОсновныеСведения.КартинкаШапки = БиблиотекаКартинок.ОсновныеСведенияСписок;
	КонецЕсли;
	
	НастроитьКомандуЭкспортВАдреснуюКнигу();
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация", "СписокКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	//УНФ.ОтборыСписка
	Если НЕ Элементы.Список.РежимВыбора Тогда
		СохранитьНастройкиОтборов();
	КонецЕсли;
	//Конец УНФ.ОтборыСписка

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КонтактноеЛицоГруппа" Тогда
		
		НоваяГруппа = Неопределено;
		Если ТипЗнч(Параметр) = Тип("Массив") И Параметр.Количество() <> 0 Тогда
			НоваяГруппа = Параметр[0];
		ИначеЕсли ЗначениеЗаполнено(Параметр) Тогда
			НоваяГруппа = Параметр;
		КонецЕсли;
		
		ПрочитатьИерархию(НоваяГруппа);
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСвязейСКонтрагентами_КонтактноеЛицо" ИЛИ ИмяСобытия = "Запись_Контрагент" 
		ИЛИ ИмяСобытия = "Запись_КонтактноеЛицо" ИЛИ ИмяСобытия = "ИзменениеСвязейСКонтактами_Контрагент" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформацииСервер();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ОткрытиеИзФормыКонтрагента И Параметры.РежимВыбора Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Контакт",Значение);
	
	Оповестить("Выбор_КонтактноеЛицо",ПараметрыВыбора,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	КонтактнаяИнформацияПанельУНФКлиент.ПриАктивизацииДинамическогоСписка(ЭтотОбъект, Элемент, ТекущийКонтакт,
		"Ссылка");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "ДатаСоздания");
КонецПроцедуры

&НаКлиенте
Процедура ОтборТегиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Теги.Тег", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборИсточникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	УстановитьМеткуИОтборСписка("ИсточникПривлечения", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОтборСвязиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОтборСвязи = ВыбранноеЗначение;
	УстановитьОтборПоДействительнымСвязям();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСвязиИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Если Текст = "" Тогда
		ОтборСвязи = "";
		УстановитьОтборПоДействительнымСвязям();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборСвязиОчистка(Элемент, СтандартнаяОбработка)
	ОтборСвязи = "";
	УстановитьОтборПоДействительнымСвязям();
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьОтборыНажатие(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборИерархия

&НаКлиенте
Процедура ОтборИерархияПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборПоИерархии(ЭтотОбъект);
	#Если МобильныйКлиент Тогда
		НастроитьПанельОтборовМобильныйКлиент();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);
	Если СтрокаИерархии = Неопределено
		Или СтрокаИерархии.ГруппаКонтактныхЛиц = "Все"
		Или СтрокаИерархии.ГруппаКонтактныхЛиц = "БезГруппы" Тогда
		
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Значение = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаИерархии.ГруппаКонтактныхЛиц);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Строка = Неопределено Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Строка);
	Если СтрокаИерархии = Неопределено Или СтрокаИерархии.ГруппаКонтактныхЛиц = "Все" Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.ДопустимыеДействия	= ДопустимыеДействияПеретаскивания.Перемещение;
	ПараметрыПеретаскивания.Действие			= ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИерархияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив")
		Или ПараметрыПеретаскивания.Значение.Количество() = 0
		Или ТипЗнч(ПараметрыПеретаскивания.Значение[0]) <> Тип("СправочникСсылка.КонтактныеЛица")Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаИерархии = ОтборИерархия.НайтиПоИдентификатору(Строка);
	Если СтрокаИерархии = Неопределено Или СтрокаИерархии.ГруппаКонтактныхЛиц = "Все" Тогда
		Возврат;
	КонецЕсли;
	
	НоваяГруппа = ?(СтрокаИерархии.ГруппаКонтактныхЛиц = "БезГруппы", ПредопределенноеЗначение("Справочник.КонтактныеЛица.ПустаяСсылка"), СтрокаИерархии.ГруппаКонтактныхЛиц);
	ИерархияПеретаскиваниеСервер(ПараметрыПеретаскивания.Значение, НоваяГруппа);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИерархияИзменить(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) <> Тип("СправочникСсылка.КонтактныеЛица")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияСоздатьГруппу(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	Если ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ЗначенияЗаполнения.Вставить("Родитель", Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаГруппы",
		Новый Структура("ЗначенияЗаполнения, ЭтоГруппа", ЗначенияЗаполнения, Истина),
		Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияСкопировать(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) <> Тип("СправочникСсылка.КонтактныеЛица")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) Тогда
		
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаГруппы",
		Новый Структура("ЗначениеКопирования, ЭтоГруппа", Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц, Истина),
		Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияУстановитьПометкуУдаления(Команда)
	
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) <> Тип("СправочникСсылка.КонтактныеЛица")
		Или Не ЗначениеЗаполнено(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) Тогда
		
		Возврат;
	КонецЕсли;
	
	ПометкаУдаления = ИзменитьПометкуУдаленияГруппыСервер(Элементы.ОтборИерархия.ТекущиеДанные.ПолучитьИдентификатор());
	
	ТекстОповещения = СтрШаблон(НСтр("ru='Пометка удаления %1'"),
		?(ПометкаУдаления, НСтр("ru='установлена'"), НСтр("ru='снята'")));
		
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц),
		Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц,
		БиблиотекаКартинок.Информация32);
		
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияВключаяВложенные(Команда)
	
	Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка = Не Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка;
	УстановитьОтборПоИерархии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура SMS(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		СоздатьСобытиеПоКонтакту("СообщениеSMS", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичнаяВстреча(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		СоздатьСобытиеПоКонтакту("ЛичнаяВстреча", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Прочее(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		СоздатьСобытиеПоКонтакту("Прочее", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Запись(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		СоздатьСобытиеПоКонтакту("Запись", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонныйЗвонок(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		СоздатьСобытиеПоКонтакту("ТелефонныйЗвонок", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектронноеПисьмо(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Ссылка) Тогда
		СоздатьСобытиеПоКонтакту("ЭлектронноеПисьмо", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортВАдреснуюКнигуСервисаРассылок(Команда)
	
	МассовыеРассылкиКлиент.ЭкспортКонтактовВСервисРассылок(ВыделенныеКонтакты());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьВыделенные(Команда)
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформацииИПанельСвязей();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииИПанельСвязей()
	ОбновитьПанельКонтактнойИнформацииСервер();
	ОбновитьПанельСвязей();
КонецПроцедуры

&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииСервер()
	
	КонтактнаяИнформацияПанельУНФ.ОбновитьДанныеПанели(ЭтотОбъект, ТекущийКонтакт);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийКонтакт);
	
КонецПроцедуры

#КонецОбласти

#Область Иерархия

&НаСервере
Процедура ПрочитатьИерархию(ГруппаТекущейСтроки = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА КонтактныеЛица.ПометкаУдаления
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ИндексПиктограммы,
		|	КонтактныеЛица.Ссылка КАК ГруппаКонтактныхЛиц,
		|	ПРЕДСТАВЛЕНИЕ(КонтактныеЛица.Ссылка) КАК ПредставлениеГруппы
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|ГДЕ
		|	КонтактныеЛица.ЭтоГруппа = ИСТИНА
		|
		|УПОРЯДОЧИТЬ ПО
		|	КонтактныеЛица.Ссылка ИЕРАРХИЯ
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(Дерево, "ОтборИерархия");
	
	ИдентификаторСтроки = Неопределено;
	Если ГруппаТекущейСтроки <> Неопределено Тогда
		ИдентификаторСтроки = ИдентификаторСтрокиДереваПоЗначению(ОтборИерархия, ГруппаТекущейСтроки);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		Элементы.ОтборИерархия.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
	ЭлементыКоллекции = ОтборИерархия.ПолучитьЭлементы();
	
	СтрокаДерева = ЭлементыКоллекции.Вставить(0);
	СтрокаДерева.ИндексПиктограммы = -1;
	СтрокаДерева.ГруппаКонтактныхЛиц = "Все";
	СтрокаДерева.ПредставлениеГруппы = НСтр("ru='<Все группы>'");
	
	СтрокаДерева = ЭлементыКоллекции.Добавить();
	СтрокаДерева.ИндексПиктограммы = -1;
	СтрокаДерева.ГруппаКонтактныхЛиц = "БезГруппы";
	СтрокаДерева.ПредставлениеГруппы = НСтр("ru='<Нет группы>'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИерархии(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ОтборИерархия.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоОтборПоГруппе = ТипЗнч(Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц) = Тип("СправочникСсылка.КонтактныеЛица");
	
	Элементы.ОтборИерархияКонтекстноеМенюИерархияИзменить.Доступность					= ЭтоОтборПоГруппе;
	Элементы.ОтборИерархияКонтекстноеМенюИерархияСкопировать.Доступность				= ЭтоОтборПоГруппе;
	Элементы.ОтборИерархияКонтекстноеМенюИерархияУстановитьПометкуУдаления.Доступность	= ЭтоОтборПоГруппе;
	
	ПравоеЗначение	= Неопределено;
	Сравнение		= ВидСравненияКомпоновкиДанных.Равно;
	Использование	= Истина;
	
	Если ЭтоОтборПоГруппе Тогда
		
		Если Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка Тогда
			Сравнение = ВидСравненияКомпоновкиДанных.ВИерархии;
		КонецЕсли;
		ПравоеЗначение = Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц;
		
	ИначеЕсли Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц = "Все" Тогда
		
		Использование = Ложь;
		
	ИначеЕсли Элементы.ОтборИерархия.ТекущиеДанные.ГруппаКонтактныхЛиц = "БезГруппы" Тогда
		
		ПравоеЗначение = ПредопределенноеЗначение("Справочник.КонтактныеЛица.ПустаяСсылка");
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список,
		"Родитель",
		ПравоеЗначение,
		Сравнение,
		,
		Использование);
	
	Форма.ОтборИерархияТекущая = ПравоеЗначение;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьПометкуУдаления(Контакт)
	
	КонтактОбъект = Контакт.ПолучитьОбъект();
	КонтактОбъект.УстановитьПометкуУдаления(Не КонтактОбъект.ПометкаУдаления, Истина);
	
	Возврат КонтактОбъект.ПометкаУдаления;
	
КонецФункции

&НаСервере
Функция ИзменитьПометкуУдаленияГруппыСервер(ИдентификаторТекущейСтроки)
	
	ТекущаяСтрокаДерева = ОтборИерархия.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	ПометкаУдаления = ИзменитьПометкуУдаления(ТекущаяСтрокаДерева.ГруппаКонтактныхЛиц);
	ИзменитьПиктограммуРекурсивно(ТекущаяСтрокаДерева, ПометкаУдаления);
	
	Возврат ПометкаУдаления;
	
КонецФункции

&НаСервере
Процедура ИзменитьПиктограммуРекурсивно(СтрокаДерева, ПометкаУдаления)
	
	СтрокаДерева.ИндексПиктограммы = ?(ПометкаУдаления, 1, 0);
	
	СтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
	Для Каждого СтрокаПодчиненная Из СтрокиДерева Цикл
		ИзменитьПиктограммуРекурсивно(СтрокаПодчиненная, ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИерархияПеретаскиваниеСервер(МассивКонтактов, НоваяГруппа)
	
	УстановитьНовуюГруппуКонтактов(МассивКонтактов, НоваяГруппа);
	
	Если МассивКонтактов[0].ЭтоГруппа Тогда
		
		ПрочитатьИерархию();
		
		ИдентификаторСтроки = 0;
		ОбщегоНазначенияКлиентСервер.ПолучитьИдентификаторСтрокиДереваПоЗначениюПоля("ГруппаКонтактныхЛиц",
			ИдентификаторСтроки,
			ОтборИерархия.ПолучитьЭлементы(),
			МассивКонтактов[0],
			Ложь);
		Элементы.ОтборИерархия.ТекущаяСтрока = ИдентификаторСтроки;
		
	Иначе
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьНовуюГруппуКонтактов(МассивКонтактов, НоваяГруппа)
	
	Для Каждого Контакт Из МассивКонтактов Цикл
		КонтактОбъект = Контакт.ПолучитьОбъект();
		КонтактОбъект.Родитель = НоваяГруппа;
		КонтактОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли;
		
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка,,Истина);
	ОбновитьПанельСвязей();
	
	Если ИмяПоляОтбораСписка = "Контрагент" Тогда
		ОтборСвязи = "ЕстьСвязи";
		УстановитьОтборПоДействительнымСвязям(Истина);
	КонецЕсли;

КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);
	УстановитьОтборПоДействительнымСвязям(Истина);
	ОбновитьПанельСвязей();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	ВариантОтборовФормы = ВариантОтбораДляНастроек();
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект,,,ВариантОтборовФормы);

	СохранитьНастройкиОтборовПоСвязям();
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(ИмяФормы,
		"ВключаяВложенные",
		Элементы.ОтборИерархияКонтекстноеМенюИерархияВключаяВложенные.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборовПоСвязям()
	
	ХранилищеСистемныхНастроек.Сохранить("ОтборСвязи", "ОтборСвязи_СписокКонтактныеЛица",ОтборСвязи);
	
КонецПроцедуры

&НаСервере
Функция ВариантОтбораДляНастроек()
	
	
	// //Отбор покупатель+поставщик, или без отбора
	ВариантОтборовФормы = "";
	Возврат ВариантОтборовФормы;
	
КонецФункции

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, "Список", "ДатаСоздания");
	СброситьВсеМеткиОтбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере()
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПанельСвязей()
	
	ТаблицаСвязей.Очистить();
	ОтборПоКонтрагентам = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор,"Контрагент");
	
	УстановленОтборПоОдномуКонтрагенту = ОтборПоКонтрагентам.Количество() <> 0 
		И ТипЗнч(ОтборПоКонтрагентам[0].ПравоеЗначение) = Тип("СписокЗначений") 
		И ОтборПоКонтрагентам[0].ПравоеЗначение.Количество() = 1
		И ОтборПоКонтрагентам[0].Использование;
		
	Если НЕ УстановленОтборПоОдномуКонтрагенту Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСвязиКонтакта", "Видимость", Ложь);
		Возврат;
	КонецЕсли;
	
	ТекущийКонтрагент = ОтборПоКонтрагентам[0].ПравоеЗначение[0].Значение;
	Отбор = Новый Структура("Контрагент",ТекущийКонтрагент);
	Выборка = РегистрыСведений.СвязиКонтрагентКонтакт.Выбрать(,,Отбор,"Убыв");
	Пока Выборка.Следующий() Цикл
		Если Выборка.Контакт <> ТекущийКонтакт Тогда
			Продолжить;
		КонецЕсли;
		НоваяСвязь = ТаблицаСвязей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСвязь,Выборка);
		Если НЕ ЗначениеЗаполнено(НоваяСвязь.Должность) Тогда
			НоваяСвязь.Должность = НСтр("ru = '<Не указана>'");
		КонецЕсли;
		Если Выборка.СвязьНедействительна Тогда
			НоваяСвязь.Картинка = 1;
		Иначе
			НоваяСвязь.Картинка = 3;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСвязиКонтакта", "Видимость", Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДействительнымСвязям(ЭтоОтборПоКонтрагенту = Ложь)
	
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "Контрагент");
	ОтборНеУстановлен = (ЭлементыОтбора.Количество() = 0 ИЛИ (ТипЗнч(ЭлементыОтбора[0].ПравоеЗначение) = Тип("Массив") 
		И ЭлементыОтбора[0].ПравоеЗначение.Количество() = 0)
		ИЛИ (ТипЗнч(ЭлементыОтбора[0].ПравоеЗначение) = Тип("СписокЗначений") 
		И ЭлементыОтбора[0].ПравоеЗначение.Количество() = 0)
		ИЛИ ЭлементыОтбора[0].Использование = Ложь);
		
	Если ОтборНеУстановлен И ЭтоОтборПоКонтрагенту Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ЕстьСвязи","");
		ОтборСвязи = "";
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОтборСвязи) И НЕ ОтборНеУстановлен Тогда
		ОтборСвязи = "ЕстьСвязи";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОтборСвязи) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ЕстьСвязи","");
		Возврат;
	КонецЕсли;
	
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить(ОтборСвязи = "ЕстьСвязи");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ЕстьСвязи", МассивОтбора,
			ВидСравненияКомпоновкиДанных.ВСписке);
	
	Если Не ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСОтборами.НастроитьПанельОтборовМобильныйКлиент(ЭтотОбъект, , ,
		"ОтборСвязи,ОтборКонтрагент,ОтборТег,ОтборИсточник,ОтборОтветственный,ОтборИерархияТекущая");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// 1. Недействительное контактное лицо выделяем серым
	НовоеУсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение 	= Истина;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиОтборовПоСвязям()
	
	ОтборСвязи = ХранилищеСистемныхНастроек.Загрузить("ОтборСвязи", "ОтборСвязи_СписокКонтактныеЛица");
	УстановитьОтборПоДействительнымСвязям(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСобытиеПоКонтакту(ИмяТипаСобытия, Контакт)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСобытия", ПредопределенноеЗначение("Перечисление.ТипыСобытий." + ИмяТипаСобытия));
	ЗначенияЗаполнения.Вставить("Контакт", Контакт);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.Событие.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПанельОтборовМобильныйКлиент()
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСОтборами.НастроитьПанельОтборовМобильныйКлиент(ЭтотОбъект,,, "ОтборСвязи,ОтборКонтрагент,ОтборТег,ОтборИсточник,ОтборОтветственный,ОтборИерархияТекущая");
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторСтрокиДереваПоЗначению(Коллекция, ИскомоеЗначение)
	
	КоллекцияЭлементов = Коллекция.ПолучитьЭлементы();
	
	Для каждого Элемент Из КоллекцияЭлементов Цикл
		
		Если Элемент.ГруппаКонтактныхЛиц = ИскомоеЗначение Тогда
			Возврат Элемент.ПолучитьИдентификатор();
		КонецЕсли;
		
		Идентификатор = ИдентификаторСтрокиДереваПоЗначению(Элемент, ИскомоеЗначение);
		
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура НастроитьКомандуЭкспортВАдреснуюКнигу()
	
	ИспользоватьМассовыеРассылкиИнтеграция = ПолучитьФункциональнуюОпцию("ИспользоватьМассовыеРассылкиИнтеграция")
		И ЗначениеЗаполнено(МассовыеРассылкиИнтеграция.ПодключенныйСервис());
	
	Элементы.ФормаЭкспортВАдреснуюКнигуСервисаРассылок.Видимость = ИспользоватьМассовыеРассылкиИнтеграция;
	Элементы.СписокКонтекстноеМенюЭкспортВАдреснуюКнигуСервисаРассылок.Видимость = ИспользоватьМассовыеРассылкиИнтеграция;
	
	Если Не ИспользоватьМассовыеРассылкиИнтеграция Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокКомандыЭкспорта = СтрШаблон(НСтр("ru='Экспорт в адресную книгу %1'"), МассовыеРассылкиИнтеграция.ПредставлениеСервиса());
	
	Элементы.ФормаЭкспортВАдреснуюКнигуСервисаРассылок.Заголовок = ЗаголовокКомандыЭкспорта;
	Элементы.СписокКонтекстноеМенюЭкспортВАдреснуюКнигуСервисаРассылок.Заголовок = ЗаголовокКомандыЭкспорта;
	
КонецПроцедуры

&НаКлиенте
Функция ВыделенныеКонтакты()
	
	ВыделенныеКонтакты = Новый Массив;
	Для каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ТекущаяСтрока = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено Тогда
			ВыделенныеКонтакты.Добавить(ТекущаяСтрока.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВыделенныеКонтакты;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКонтрагентаИзВладельца()
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		Если Не Параметры.Отбор.Свойство("Контрагент") Или Не ЗначениеЗаполнено(Параметры.Отбор.Контрагент) Тогда
			Параметры.Отбор.Вставить("Контрагент", Параметры.Отбор.Владелец);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
&НаКлиенте
Процедура ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
	
	НастройкиЗагрузкиДанных.Вставить("ИмяМакетаСШаблоном", "ЗагрузкаИзФайла");
	НастройкиЗагрузкиДанных.Вставить("ОписаниеСтрокиВыбора", Новый Структура("ПолноеИмяОбъектаМетаданных, Тип", "КонтактныеЛица", "ПрикладнаяЗагрузка"));
	
	ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточника(Команда)
	
	ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗагрузки) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатЗагрузки.ОписаниеДействия = "ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника" Тогда
	
		ЗагрузкаДанныхИзВнешнегоИсточника.ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
		ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
		
	ИначеЕсли РезультатЗагрузки.ОписаниеДействия = "ОбработатьПодготовленныеДанные" Тогда
		
		ДлительнаяОперация = ЗапуститьОбработкуПодготовленныхДанных(РезультатЗагрузки);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		
		ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
		ПараметрыОжидания.ОповещениеПользователя.Текст = НСтр("ru='Контакты'");
		ПараметрыОжидания.ОповещениеПользователя.Пояснение = НСтр("ru='Загрузка данных завершена.'");
		ПараметрыОжидания.ОповещениеПользователя.НавигационнаяСсылка = Окно.ПолучитьНавигационнуюСсылку();
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Новый ОписаниеОповещения("ЗавершениеОбработкиПодготовленныхДанных", ЭтотОбъект), ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьОбработкуПодготовленныхДанных(РезультатЗагрузки)
	
	ИмяПроцедуры = "Справочники.КонтактныеЛица.ОбработатьПодготовленныеДанные";
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиЗагрузкиДанных", РезультатЗагрузки.НастройкиЗагрузкиДанных);
	ПараметрыПроцедуры.Вставить("ТаблицаСопоставленияДанных", ДанныеФормыВЗначение(РезультатЗагрузки.ТаблицаСопоставленияДанных, Тип("ТаблицаЗначений")));
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подсистема ЗагрузкаДанныхИзВнешнегоИсточника: Выполнение серверного метода загрузки результата'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеОбработкиПодготовленныхДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
