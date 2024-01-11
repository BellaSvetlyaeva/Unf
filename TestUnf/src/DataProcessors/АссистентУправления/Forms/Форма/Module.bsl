
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если МобильныйКлиентУНФ.ФункциональностьВременноНедоступна(Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	АссистентПодключен = АссистентУправления.Подключен();
	ИнформационнаяБазаПодключена = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	ТекущийЭлемент = Элементы.ИзмениСостояниеПриОплате;
	ТекущаяСтраница = "ИзмениСостояниеЗаказа";

	ОтображатьЗадачиПроизводства = ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуПроизводство");
	ОтображатьЗадачиБонусов      = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы");
	ОтображатьЗадачиПоНалогам    = ПолучитьФункциональнуюОпцию("ИспользоватьОтчетность");
	ИспользоватьЖурналЗаписи     = ПолучитьФункциональнуюОпцию("ПланироватьЗагрузкуРесурсовПредприятияЖурналЗаписи");
	ПланироватьЗагрузкуРесурсов  = ПолучитьФункциональнуюОпцию("ПланироватьЗагрузкуРесурсовПредприятияРаботы");
	ОтображатьЗадачиКонтроляОстатков = ПолучитьФункциональнуюОпцию("УчетПотребностиПоСкладам");
	
	УстановитьПризнакиВРаботе();
	УправлениеФормой();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//ЗадачиАссистента
&НаКлиенте
Процедура ИзмениСостояниеПриОплате(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ИзменениеСостоянияЗаказаПриОплате");
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеПриОплатеИОтгрузке(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ИзменениеСостоянияЗаказаПриОплатеИОтгрузке");
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеПриОтгрузке(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ИзменениеСостоянияЗаказаПриОтгрузке");
КонецПроцедуры

&НаКлиенте
Процедура СообщиПриОплатеЗаказа(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяПриОплатеЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура СообщиПриОтгрузкеЗаказа(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяПриОтгрузкеЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура СообщиПриОтгрузкеИОплате(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяПриОтгрузкеИОплатеЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПокупателяПоЗаказамПоставщикам(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПокупателяПоСостояниюЗаказовПоставщикам";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПокупателяПоЗаказамНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПокупателяПоСостояниюЗаказовНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаПоставщикуПриОплате(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПриОплате";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаПоставщикуПриПоставке(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПриПоставке";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаПоставщикуПриОплатеИПоставке(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПриОплатеИПоставке";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриОплатеЗаказаПоставщику(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриОплатеЗаказаПоставщику";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриПоставкеЗаказаПоставщику(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриПоставкеЗаказаПоставщику";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриОплатеИПоставкеЗаказаПоставщику(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриОплатеИПоставкеЗаказаПоставщику";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПриОплатеИПоставке", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПокупателяПоЗаказамПоставщикамНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПокупателяПоСостояниюЗаказовПоставщикамИНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПокупателяПоЗаказамПоставщикам(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказуПокупателяПоСостояниюЗаказовПоставщикам";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПокупателяПоЗаказамНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказуПокупателяПоСостояниюЗаказовНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПокупателяПоЗаказамПоставщикамИНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказуПокупателяПоСостояниюЗаказовПоставщикамИНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПокупателяПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказПоставщикуПоЗаказамПокупателей(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаПоставщикуПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуПоставщикуПоЗаказамПокупателей(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказаПоставщикуПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомПоставщикуПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаНаПроизводствоПриВыполнении(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаНаПроизводствоПриВыполнении";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПриВыполнении", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмениСостояниеЗаказаНаПроизводствоПоЗаказуПокупателя(Команда)
	
	ИдентификаторГруппы = "ИзменениеСостоянияЗаказаНаПроизводствоПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяПриВыполненииЗаказаНаПроизводство(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователюПриВыполненииЗаказаНаПроизводство";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПриВыполнении", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиЗаказуНаПроизводствоПоЗаказамПокупателей(Команда)
	
	ИдентификаторГруппы = "ОповещениеЗаказаНаПроизводствоПоСостояниюЗаказовПокупателей";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ДействияСЗаказомНаПроизводствоПоСостояниюСвязанныхЗаказов", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОБонусахПриУсловиях(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеКлиентаОБонусахПриУсловиях");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОБонусахПриПродаже(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеКлиентаОБонусахПриПродаже");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиСотрудникаОбИзмененииБонусовПриПродаже(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяОбИзмененииНачисленияСписанияБаллов");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОбИзмененииСостоянияЗаказа(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеКлиентаОбИзмененииСостоянияЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОНачисленныхНалогах(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.РасчетИОповещениеПользователяОНачисленныхНалогах");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОбОтчетности(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ФормированиеИОповещениеПользователяОНеобходимостиСдачиОтчетности");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиентаОЗаписиНаУслугу(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеКлиентаНаВсехЭтапахЗаписи");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиОбИзмененииСостоянияЗаказаПокупателя(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователяОбИзмененииСостоянияЗаказаПокупателя";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяОбИзмененииСостоянияЗП", ИдентификаторГруппы);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщиПользователюПриИзмененииОтветственного(Команда)
	
	ИдентификаторГруппы = "ОповещениеПользователяОбИзмененииОтветственногоЗаказПокупателя";
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяОбИзмененииОтветственного");
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиОМинимальномУровнеОстатков(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяОбОстатках");
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователяОбИзмененииПоказателя(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяОбИзмененииПоказателя");
КонецПроцедуры

&НаКлиенте
Процедура РегулярноОповещайПользователяОПоказателе(Команда)
	ОткрытьФормуЗадачи("Обработка.АссистентУправления.Форма.ОповещениеПользователяОПоказателе");
КонецПроцедуры
// Конец ЗадачиАссистента

&НаКлиенте
Процедура ИзмениСостояниеЗаказа(Команда)
	
	ТекущаяСтраница = "ИзмениСостояниеЗаказа";
	
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = Истина;
	Элементы.Группа_ОповещениеПользователя.Видимость = Ложь;
	Элементы.Группа_ОповещениеКлиента.Видимость = Ложь;
	Элементы.Группа_РекомендацииДаши.Видимость = Ложь;
	Элементы.Группа_ОповещениеОНалогах.Видимость = Ложь;
	Элементы.Группа_ОповещениеОБизнесе.Видимость = Ложь;
	
	Элементы.ИзмениСостояниеЗаказа.ЦветФона = Новый Цвет(252,231,81);
	Элементы.ОповестиПользователя.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиКлиента.ЦветФона = Новый Цвет(255,255,255);
	Элементы.РекомендацииОтДаши.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиСНалогами.ЦветФона = Новый Цвет(255,255,255); 
	Элементы.ПомогиКонтролировать.ЦветФона = Новый Цвет(255,255,255);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиПользователя(Команда)
	ТекущаяСтраница = "ОповестиПользователя";
	
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = Ложь;
	Элементы.Группа_ОповещениеПользователя.Видимость = Истина;
	Элементы.Группа_ОповещениеКлиента.Видимость = Ложь;
	Элементы.Группа_РекомендацииДаши.Видимость = Ложь;
	Элементы.Группа_ОповещениеОНалогах.Видимость = Ложь;
	Элементы.Группа_ОповещениеОБизнесе.Видимость = Ложь;

	Элементы.ИзмениСостояниеЗаказа.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиПользователя.ЦветФона = Новый Цвет(252,231,81);
	Элементы.ОповестиКлиента.ЦветФона = Новый Цвет(255,255,255);
	Элементы.РекомендацииОтДаши.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиСНалогами.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиКонтролировать.ЦветФона = Новый Цвет(255,255,255);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповестиКлиента(Команда)
	ТекущаяСтраница = "ОповестиКлиента";
	
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = Ложь;
	Элементы.Группа_ОповещениеПользователя.Видимость = Ложь;
	Элементы.Группа_ОповещениеКлиента.Видимость = Истина;
	Элементы.Группа_РекомендацииДаши.Видимость = Ложь;
	Элементы.Группа_ОповещениеОНалогах.Видимость = Ложь;
	Элементы.Группа_ОповещениеОБизнесе.Видимость = Ложь;
	
	Элементы.ИзмениСостояниеЗаказа.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиПользователя.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиКлиента.ЦветФона = Новый Цвет(252,231,81);
	Элементы.РекомендацииОтДаши.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиСНалогами.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиКонтролировать.ЦветФона = Новый Цвет(255,255,255);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомогиСНалогами(Команда)
	
	ТекущаяСтраница = "ПомогиСНалогами";
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = Ложь;
	Элементы.Группа_ОповещениеПользователя.Видимость = Ложь;
	Элементы.Группа_ОповещениеКлиента.Видимость = Ложь;
	Элементы.Группа_РекомендацииДаши.Видимость = Ложь;
	Элементы.Группа_ОповещениеОНалогах.Видимость = Истина;
	Элементы.Группа_ОповещениеОБизнесе.Видимость = Ложь;
	
	Элементы.ИзмениСостояниеЗаказа.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиПользователя.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиКлиента.ЦветФона = Новый Цвет(255,255,255);
	Элементы.РекомендацииОтДаши.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиСНалогами.ЦветФона = Новый Цвет(252,231,81);
	Элементы.ПомогиКонтролировать.ЦветФона = Новый Цвет(255,255,255);
	
КонецПроцедуры

&НаКлиенте
Процедура РекомендацииОтДаши(Команда)
	
	ТекущаяСтраница = "РекомендацииДаши";
	
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = Ложь;
	Элементы.Группа_ОповещениеПользователя.Видимость = Ложь;
	Элементы.Группа_ОповещениеКлиента.Видимость = Ложь;
	Элементы.Группа_РекомендацииДаши.Видимость = Истина;
	Элементы.Группа_ОповещениеОНалогах.Видимость = Ложь;
	Элементы.Группа_ОповещениеОБизнесе.Видимость = Ложь;

	Элементы.ИзмениСостояниеЗаказа.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиПользователя.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиКлиента.ЦветФона = Новый Цвет(255,255,255);
	Элементы.РекомендацииОтДаши.ЦветФона = Новый Цвет(252,231,81);
	Элементы.ПомогиСНалогами.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиКонтролировать.ЦветФона = Новый Цвет(255,255,255);

КонецПроцедуры

&НаКлиенте
Процедура ПомогиКонтролировать(Команда)
	
	ТекущаяСтраница = "ПомогиКонтролировать";
	
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = Ложь;
	Элементы.Группа_ОповещениеПользователя.Видимость = Ложь;
	Элементы.Группа_ОповещениеКлиента.Видимость = Ложь;
	Элементы.Группа_РекомендацииДаши.Видимость = Ложь;
	Элементы.Группа_ОповещениеОНалогах.Видимость = Ложь;
	Элементы.Группа_ОповещениеОБизнесе.Видимость = Истина;
	
	Элементы.ИзмениСостояниеЗаказа.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиПользователя.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ОповестиКлиента.ЦветФона = Новый Цвет(255,255,255);
	Элементы.РекомендацииОтДаши.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиСНалогами.ЦветФона = Новый Цвет(255,255,255);
	Элементы.ПомогиКонтролировать.ЦветФона = Новый Цвет(252,231,81);

	
КонецПроцедуры

&НаКлиенте
Процедура КурсОперУправление(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://1c.ru/rus/partners/training/uc1/course.jsp?id=286");
КонецПроцедуры

&НаКлиенте
Процедура ЭкзаменСпециалист(Команда)
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://1c.ru/rus/partners/training/uc1/course.jsp?id=657");
КонецПроцедуры

&НаКлиенте
Процедура ИсторияВыполненияЗадач(Команда)
	
	ОткрытьФорму("РегистрСведений.ВыполненныеЗадачиАссистентаУправления.Форма.ВыполненныеЗадачи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПодключитьОбсужденияНажатие(Элемент)
	НачатьПодключениеОбсуждений();
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиПодключениеНажатие(Элемент)
	ПодключитьАссистента();
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиОбсуждениеНажатие(Элемент)
	СоздатьОбсуждение();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключитьАссистента()
	
	Если АссистентПодключен Тогда
		Возврат;
	КонецЕсли;

	ПодключитьАссистентаНаСервере();
	АссистентУправленияКлиент.Подключить();
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьАссистентаНаСервере()
	
	Если АссистентПодключен Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправления.Подключить();
	
	АссистентПодключен = АссистентУправления.Подключен();
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиВРаботе(ИдентификаторГруппы = Неопределено)
	
	ОтборПоГруппе = Ложь;
	
	Если ИдентификаторГруппы = Неопределено Тогда
		ОтборПоГруппе = Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачиАссистента.Родитель КАК Родитель,
	|	ЗадачиАссистента.Используется КАК Используется
	|ПОМЕСТИТЬ ИспользуемыеГруппыЗадач
	|ИЗ
	|	Справочник.ЗадачиАссистентаУправления КАК ЗадачиАссистента
	|ГДЕ
	|	ЗадачиАссистента.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадачиАссистента.Родитель,
	|	ЗадачиАссистента.Используется
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗадачиАссистента.ИдентификаторГруппы КАК ИдентификаторГруппы,
	|	ИспользуемыеГруппыЗадач.Используется КАК Используется
	|ИЗ
	|	ИспользуемыеГруппыЗадач КАК ИспользуемыеГруппыЗадач
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗадачиАссистентаУправления КАК ЗадачиАссистента
	|		ПО ИспользуемыеГруппыЗадач.Родитель = ЗадачиАссистента.Ссылка
	|ГДЕ
	|	(&ОтборПоГруппе
	|			ИЛИ ЗадачиАссистента.ИдентификаторГруппы = &ИдентификаторГруппы)";
	
	Запрос.УстановитьПараметр("ОтборПоГруппе", ОтборПоГруппе);
	Запрос.УстановитьПараметр("ИдентификаторГруппы", ИдентификаторГруппы);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		
		ЭлементВРаботе = Элементы.Найти("ВРаботе_"+Выборка.ИдентификаторГруппы);
		
		Если ЭлементВРаботе = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементВРаботе.Видимость = Выборка.Используется;
		
	КонецЦикла;
	
	УстановитьПризнакиВРаботеЗадачПоНалогам(ОтборПоГруппе, ИдентификаторГруппы);
	Элементы.ВРаботе_ОповещениеКлиентаОЗаписиНаУслугу.Видимость =
		Справочники.ЗадачиАссистентаПоНапоминаниямОЗаписи.ЕстьЗадачиВРаботе();
	Элементы.ВРаботе_ОповещениеПользователяОМинимальномУровнеОстатков.Видимость =
		Справочники.ЗадачиАссистентаПоРаботеСОстатками.ЕстьЗадачиВРаботе();
	Элементы.ВРаботе_ОповещениеПользователяОПоказателе.Видимость = 
		Справочники.ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ЕстьЗадачиВРаботе(Истина);
	Элементы.ВРаботе_ОповещениеПользователяОбИзмененииПоказателя.Видимость = 
		Справочники.ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ЕстьЗадачиВРаботе(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиВРаботеЗадачПоНалогам(ОтборПоГруппе, ИдентификаторГруппы) 
	
	Если (ИдентификаторГруппы <> "РасчетИОповещениеПользователяОНачисленныхНалогах"
		И ИдентификаторГруппы <> "ФормированиеИОповещениеПользователяОНеобходимостиСдачиОтчетности") И НЕ ОтборПоГруппе Тогда
		Возврат;
	КонецЕсли;
	
	ВключенныеЗадачиНалогов = Справочники.ЗадачиАссистентаПоРасчетуНалогов.ИдентификаторыВключенныхЗадач();
	
	Если ВключенныеЗадачиНалогов.Найти(ИдентификаторГруппы) = Неопределено Тогда
		
		ЭлементВРаботе = Элементы.Найти("ВРаботе_"+ИдентификаторГруппы);
		
		Если ЭлементВРаботе <> Неопределено Тогда
			ЭлементВРаботе.Видимость = Ложь;
		КонецЕсли;

	КонецЕсли;
	
	Для Каждого ИдентификаторЗадачи Из ВключенныеЗадачиНалогов Цикл 
		
		ЭлементВРаботе = Элементы.Найти("ВРаботе_"+ИдентификаторЗадачи);
		
		Если ЭлементВРаботе = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементВРаботе.Видимость = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОбсуждений()
	
	Продолжение = Новый ОписаниеОповещения("ЗавершитьПодключениеОбсуждений", ЭтотОбъект);
	ОбсужденияКлиент.ПоказатьПодключение(Продолжение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодключениеОбсуждений(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	РазрешеноИзменятьЗадачи      = Обработки.АссистентУправления.РазрешеноИзменятьЗадачи();
	ИнформационнаяБазаПодключена = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	Элементы.ИмяОбсуждения.Видимость        = ИнформационнаяБазаПодключена ИЛИ НЕ РазрешеноИзменятьЗадачи;
	Элементы.ПодключитьОбсуждения.Видимость = НЕ ИнформационнаяБазаПодключена И РазрешеноИзменятьЗадачи;
	
	ОбсуждениеСоздано            = АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено;
	ЕстьОшибкиПодключения        = ЕстьОшибкиПодключения();
	ЕстьОшибкиСозданияОбсуждения = ЕстьОшибкиСозданияОбсуждения();
	
	Элементы.ПанельОшибки.Видимость      = (ЕстьОшибкиПодключения ИЛИ ЕстьОшибкиСозданияОбсуждения) И РазрешеноИзменятьЗадачи;
	Элементы.ОшибкаОбсуждения.Видимость  = ЕстьОшибкиСозданияОбсуждения И НЕ ЕстьОшибкиПодключения И РазрешеноИзменятьЗадачи;
	Элементы.ОшибкаПодключения.Видимость = ЕстьОшибкиПодключения И РазрешеноИзменятьЗадачи;
	
	Элементы.Группа_ИзменениеСостоянияЗаказа.Видимость = ТекущаяСтраница = "ИзмениСостояниеЗаказа";
	Элементы.Группа_ОповещениеПользователя.Видимость   = ТекущаяСтраница = "ОповестиПользователя";
	Элементы.Группа_ОповещениеКлиента.Видимость        = ТекущаяСтраница = "ОповестиКлиента";
	Элементы.Группа_РекомендацииДаши.Видимость         = ТекущаяСтраница = "РекомендацииДаши";
	Элементы.Группа_ОповещениеОНалогах.Видимость       = ТекущаяСтраница = "ПомогиСНалогами";
	Элементы.Группа_ОповещениеОБизнесе.Видимость       = ТекущаяСтраница = "ПомогиКонтролировать";

	Элементы.ИзменениеСостоянияЗаказПокупателяЗаказНаПроизводство.Видимость             = ОтображатьЗадачиПроизводства;
	Элементы.ИзменениеСостоянияЗаказыПокупателяЗаказПоставщикуИНаПроизводство.Видимость = ОтображатьЗадачиПроизводства;
	Элементы.ИзменениеСостоянияЗаказаНаПроизводство.Видимость                           = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеПользователяОСтатусеЗаказаНаПроизводство.Видимость               = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеЗаказаПокупателяПоЗаказамНаПроизводство.Видимость                = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеЗаказаПокупателяПоЗаказамПоставщикамИНаПроизводство.Видимость    = ОтображатьЗадачиПроизводства;
	Элементы.ОповещениеПользователяОМинимальномУровнеОстатков.Видимость                 = ОтображатьЗадачиКонтроляОстатков;
	
	Элементы.ОповещениеКлиентаОЗаписиНаУслугу.Видимость = ИспользоватьЖурналЗаписи ИЛИ ПланироватьЗагрузкуРесурсов;
	Элементы.ПомогиСНалогами.Видимость                  = ОтображатьЗадачиПоНалогам;
	Элементы.ОповещениеКлиентаОБонусах.Видимость        = ОтображатьЗадачиБонусов;
	
	РазмерыЭкрана = ПолучитьИнформациюЭкрановКлиента();
	
	Если РазмерыЭкрана = Неопределено ИЛИ (ТипЗнч(РазмерыЭкрана) = Тип("ФиксированныйМассив") И РазмерыЭкрана.Количество() = 0) Тогда
		Возврат;
	КонецЕсли;
	
	ШиринаЭкрана = 1280;
	ВысотаЭкрана = 1024;
	
	Если РазмерыЭкрана[0].Ширина > ШиринаЭкрана И РазмерыЭкрана[0].Высота > ВысотаЭкрана Тогда
		Элементы.Переместить(Элементы.ОповестиКлиента, Элементы.Строка_1);
	Иначе
		Элементы.Переместить(Элементы.ОповестиКлиента, Элементы.Строка_2, Элементы.ПомогиСНалогами);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьОбсуждение()
	
	Если АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправления.СоздатьОбсуждениеЖурналРаботыАссистента();
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗадачи(ИмяФормы, ИдентификаторГруппы = "")
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыЗадачи",ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторГруппы", ИдентификаторГруппы);
	ОткрытьФорму(ИмяФормы, ПараметрыФормы ,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыЗадачи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьЗакрытиеФормыЗадачиСервер(Результат);
	
	Если НЕ ИнформационнаяБазаПодключена Тогда
		Возврат;
	КонецЕсли;
	
	Если АссистентПодключен Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьАссистента();
	
КонецПроцедуры 

&НаСервере
Процедура ОбработатьЗакрытиеФормыЗадачиСервер(Результат)
	
	ИнформационнаяБазаПодключена = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ИзмененПризнакВРаботе Тогда
		УстановитьПризнакиВРаботе(Результат.ГруппаЗадач);
		ОпределитьИспользованиеЗадачАссистентаУправления();
	КонецЕсли;
	
	Если НЕ ИнформационнаяБазаПодключена Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ АссистентПодключен Тогда
		Возврат;
	КонецЕсли;
	
	ОбсуждениеСоздано = АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено;
	
	Если НЕ ОбсуждениеСоздано Тогда
		Попытка
			СоздатьОбсуждение();
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	УправлениеФормой();
	
	Если ЗначениеЗаполнено(Результат.АвторИзменений) И Результат.НужноДобавитьВОбсуждение Тогда
		Попытка
			АссистентУправления.ОбновитьУчастниковЖурналРаботыАссистента(Результат.АвторИзменений);
		Исключение
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЕстьОшибкиПодключения()
	
	Возврат НЕ АссистентУправления.Подключен() И ПолучитьФункциональнуюОпцию("ИспользованиеЗадачАссистентаУправления");
	
КонецФункции

&НаСервере
Функция ЕстьОшибкиСозданияОбсуждения()
	
	ОбсуждениеСоздано = АссистентУправления.ПолучитьОбсуждениеЖурналРаботыАссистента() <> Неопределено;
	
	Возврат НЕ ОбсуждениеСоздано И ПолучитьФункциональнуюОпцию("ИспользованиеЗадачАссистентаУправления");
	
КонецФункции

&НаСервере
Процедура ОпределитьИспользованиеЗадачАссистентаУправления()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗадачиАссистентаУправления.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗадачиАссистентаУправления КАК ЗадачиАссистентаУправления
	|ГДЕ
	|	НЕ ЗадачиАссистентаУправления.ПометкаУдаления
	|	И ЗадачиАссистентаУправления.Используется
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.Ссылка
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоРаботеСПоказателямиБизнеса КАК ЗадачиАссистентаПоРаботеСПоказателямиБизнеса
	|ГДЕ
	|	НЕ ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.ПометкаУдаления
	|	И ЗадачиАссистентаПоРаботеСПоказателямиБизнеса.Используется";
	
	Константы.ИспользованиеЗадачАссистентаУправления.Установить(Запрос.Выполнить().Выбрать().Количество() <> 0);
	
КонецПроцедуры

#Область БольшеВозможностей

&НаКлиенте
Процедура ПредложитьВозможностьНажатие(Элемент)
	
	ТекстПисьма = НСтр("ru = 'Опишите, каких навыков не хватает ассистенту управления:'");
	Тег = НСтр("ru = 'Ассистент управления'");
	
	УправлениеНебольшойФирмойКлиент.ПредложитьВозможностьНажатие(Тег, ТекстПисьма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
