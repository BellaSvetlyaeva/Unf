#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ИзвещениеФСС, ПараметрыВыполненияКоманды)
	Форма = ОбщегоНазначенияБЗККлиентСервер.ЗначениеСвойства(ПараметрыВыполненияКоманды, "Источник");
	ИдентификаторФормы = ОбщегоНазначенияБЗККлиентСервер.ЗначениеСвойства(Форма, "УникальныйИдентификатор");
	Обработчик = Новый ОписаниеОповещения("ПослеПолученияДанных", ЭтотОбъект);
	СЭДОФССКлиент.ПолучитьДанныеФайлаИзвещенияФСС(Обработчик, ИзвещениеФСС, ИдентификаторФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПолученияДанных(ДанныеФайла, ПустойПараметр) Экспорт
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
КонецПроцедуры

#КонецОбласти