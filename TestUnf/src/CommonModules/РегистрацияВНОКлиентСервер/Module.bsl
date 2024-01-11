
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредставлениеПодписанта(ТекущиеДанные) Экспорт
	
	ТекущиеДанные.ПредставлениеПодписанта = ПредставлениеПодписанта(ТекущиеДанные);
	
КонецПроцедуры

Функция ПредставлениеПодписанта(ТекущиеДанные) Экспорт
	
	Если ТипЗнч(ТекущиеДанные.Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
		ИЛИ НЕ ЗначениеЗаполнено(ТекущиеДанные.УполномоченноеЛицоПредставителя) Тогда
		ПредставлениеПодписанта = Строка(ТекущиеДанные.Представитель);
	Иначе
		Шаблон = НСтр("ru = '%1 (%2)'");
		ПредставлениеПодписанта = СтрШаблон(
			Шаблон, 
			Строка(ТекущиеДанные.Представитель), 
			ТекущиеДанные.УполномоченноеЛицоПредставителя);
	КонецЕсли;
		
	Возврат ПредставлениеПодписанта;
	
КонецФункции

Процедура ОчиститьПредставителя(Приемник) Экспорт
	
	Приемник.Представитель   = Неопределено;
	Приемник.Доверенность    = Неопределено;
	Приемник.ДокументПредставителя = "";
	Приемник.УполномоченноеЛицоПредставителя = "";
	
КонецПроцедуры

Процедура ИзменитьОформлениеПодписантов(Форма, Объект) Экспорт

	Элементы = Форма.Элементы;
	
	Если Форма.ОтчетностьПодписываетПредставитель = 1 Тогда
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительГиперссылка;
	Иначе
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительНеВыбран;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		Форма.ПредставлениеПредставителя = НСтр("ru = 'Заполнить'");
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
		ИЛИ НЕ ЗначениеЗаполнено(Объект.УполномоченноеЛицоПредставителя) Тогда
		Форма.ПредставлениеПредставителя = Объект.Представитель;
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.Контрагенты") Тогда
		Форма.ПредставлениеПредставителя = Объект.УполномоченноеЛицоПредставителя + " (" + Объект.Представитель + ")";
	КонецЕсли;

	НесколькоПодписантов = Форма.ОтчетностьПодписываетПредставитель = 2;
	Элементы.ГруппаПодписанты.Доступность     = НесколькоПодписантов;
	Элементы.ПодсказкаПоПодписантам.Видимость = НесколькоПодписантов;
		
КонецПроцедуры

Функция ПараметрыПодписанта() Экспорт

	Ключи = КлючиПодписанта();
	ЗначенияЗаполнения = Новый Структура(Ключи);
	ЗначенияЗаполнения.НесколькоПодписантов = Ложь;
	ЗначенияЗаполнения.ЭтоДобавление = Ложь;
	
	Возврат ЗначенияЗаполнения;

КонецФункции

Функция КлючиПодписанта() Экспорт

	Ключи = НовыйСведенияОПредставителяхСтрока() + "," + 
	"Владелец,
	|Код,
	|Пользователь,
	|НесколькоПодписантов,
	|ЭтоДобавление,
	|ВыбраннаяСтрока";
	
	Возврат Ключи;

КонецФункции

Функция НовыйСведенияОПредставителяхСтрока() Экспорт
	
	СведенияОПредставителях = "Представитель,Доверенность,ДокументПредставителя,УполномоченноеЛицоПредставителя";
	
	Возврат СведенияОПредставителях;
	
КонецФункции

#КонецОбласти