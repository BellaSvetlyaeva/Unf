#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ДоступнаНастройкаРежима() Тогда
		ОткрытьФорму("Обработка.ПомощникНастройкиОбменаУРМК.Форма.НастройкаРежима",,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	Иначе
		ОткрытьФорму("Обработка.ПомощникНастройкиОбменаУРМК.Форма.ПомощникНастройкиОбменаДанными",,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	КонецЕсли;
		
КонецПроцедуры

Функция ДоступнаНастройкаРежима()
	Возврат ИнтеграцияУРМКПереопределяемый.РазрешенРасширенныйРежимНастройкиОбменаУРМК();
КонецФункции

#КонецОбласти