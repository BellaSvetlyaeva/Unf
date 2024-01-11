#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ПриемИПередачаВРемонт") Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыВыполненияКоманды.Источник, "Объект") Тогда
			ВариантРемонта = ПараметрыВыполненияКоманды.Источник.Объект.ВариантРемонта;
		Иначе
			// ввод на основании из списка
			ВариантРемонта = ПараметрыВыполненияКоманды.Источник.ТекущийЭлемент.ТекущиеДанные.ВариантРемонта;
		КонецЕсли;

		Если ВариантРемонта = ПредопределенноеЗначение("Перечисление.ВариантыРемонта.НашаМастерскаяМногоэтапныйРемонт") Тогда
			ПоказатьПредупреждение( , НСтр(
				"ru = 'Для выбранного варианта ремонта указывайте оплаты в подчиненных документах - Заказ-наряд, Расходная накладная, Акт'"));
			Возврат;
		КонецЕсли;

	КонецЕсли;
	ОткрытьФорму("Документ.ОперацияПоПлатежнымКартам.ФормаОбъекта", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.ОплатаПлатежнойКартой", ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти
