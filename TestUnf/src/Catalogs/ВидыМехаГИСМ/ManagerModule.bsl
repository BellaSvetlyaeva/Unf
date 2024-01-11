#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает полные данные классификатора видов меха.
//
// Возвращаемое значение:
//     ТаблицаЗначений - данные классификатора с колонками:
//         * Код          - Строка - Код элемента классификатора
//         * Наименование - Строка - Наименование вида меха
//         * КодТНВЭД     - Строка - Код ТНВЭД.
//
// Таблица значений проиндексирована по полям "Код", "Наименование".
//
Функция ТаблицаКлассификатора() Экспорт
	
	Макет = ПолучитьМакет("ДанныеКлассификатора");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	
	Возврат СериализаторXDTO.ПрочитатьXML(Чтение);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаСоответствийВидовМехаПриПереходеНаФорматОбмена2_41() Экспорт
	
	ОписаниеТипаСтрока2 = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(2, ДопустимаяДлина.Переменная));
	ОписаниеТипаСтрока150 = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная));
	
	ТаблицаСоответствий = Новый ТаблицаЗначений;
	ТаблицаСоответствий.Колонки.Добавить("КодНовый", ОписаниеТипаСтрока2);
	ТаблицаСоответствий.Колонки.Добавить("НаименованиеНовый", ОписаниеТипаСтрока150);
	ТаблицаСоответствий.Колонки.Добавить("КодСтарый", ОписаниеТипаСтрока2);
	ТаблицаСоответствий.Колонки.Добавить("НаименованиеСтарый", ОписаниеТипаСтрока150);
	
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "1",  НСтр("ru = 'ондатра'"), "74", НСтр("ru = 'ондатра'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "2",  НСтр("ru = 'шкура молодого теленка до 3-х месяцев (опойка)'"), "37", НСтр("ru = 'опоек (теленок)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "3",  НСтр("ru = 'соболь'"), "10", НСтр("ru = 'соболь'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "4",  НСтр("ru = 'шиншила'"), "77", НСтр("ru = 'шиншилла (вискача)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "5",  НСтр("ru = 'бобр, бобер'"), "73", НСтр("ru = 'бобр'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "6",  НСтр("ru = 'рысь'"), "19", НСтр("ru = 'рысь, рысевидная кошка'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "7",  НСтр("ru = 'козлик, козел, козленок'"), "43", НСтр("ru = 'козлик'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "9",  НСтр("ru = 'морской котик'"), "61", НСтр("ru = 'морской котик'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "10", НСтр("ru = 'кенгуру'") , "54", НСтр("ru = 'кенгуру, валлаби'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "11", НСтр("ru = 'олень'") , "45", НСтр("ru = 'олень'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "12", НСтр("ru = 'овчина'"), "08", НСтр("ru = 'овчина (любых пород)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "13", НСтр("ru = 'лисица'"), "03", НСтр("ru = 'лисица (в том числе красная, крестовка, корсак, серебристо-черная, черно-бурая, снежная, фенек)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "14", НСтр("ru = 'хорек'"), "72", НСтр("ru = 'хорь'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "16", НСтр("ru = 'ласка'"), "17", НСтр("ru = 'ласка'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "17", НСтр("ru = 'лама'"), "39", НСтр("ru = 'лама, гуанако, альпака, викунья'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "18", НСтр("ru = 'койот'"), "32", НСтр("ru = 'койот'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "19", НСтр("ru = 'скунс'"), "80", НСтр("ru = 'скунс'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "20", НСтр("ru = 'куница'"), "11", НСтр("ru = 'куница'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "21", НСтр("ru = 'волк'"), "30", НСтр("ru = 'волк'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "22", НСтр("ru = 'сурок'"), "65", НСтр("ru = 'сурок (тарбаган и прочие)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "23", НСтр("ru = 'орилаг (кролик)'"), "06", НСтр("ru = 'кролик (в том числе рекс-реббит, орилаг и прочие)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "24", НСтр("ru = 'белка'"), "63", НСтр("ru = 'белка'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "25", НСтр("ru = 'ягненок'"), "09", НСтр("ru = 'каракуль, каракульча, ягненок (любых пород)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "27", НСтр("ru = 'мех пекана'"), "18", НСтр("ru = 'фишер (илка, пекан)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "28", НСтр("ru = 'бычья шкура'"), "36", НСтр("ru = 'КРС (крупный рогатый скот: коровы, быки, буйволы, волы и т.д)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "29", НСтр("ru = 'енотовидная собака'"), "07", НСтр("ru = 'енот (енот полоскун, енотовидная собака)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "32", НСтр("ru = 'каракуль'"), "09", НСтр("ru = 'каракуль, каракульча, ягненок (любых пород)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "33", НСтр("ru = 'опоссум'"), "79", НСтр("ru = 'опоссум'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "34", НСтр("ru = 'альпака'"), "39", НСтр("ru = 'лама, гуанако, альпака, викунья'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "35", НСтр("ru = 'оцелот'"), "21", НСтр("ru = 'оцелот'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "36", НСтр("ru = 'хомяк'"), "70", НСтр("ru = 'хомяк'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "37", НСтр("ru = 'нерпа'"), "60", НСтр("ru = 'нерпа (тюленевые)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "38", НСтр("ru = 'мех пони'"), "42", НСтр("ru = 'пони'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "39", НСтр("ru = 'мех кошки домашней'"), "28", НСтр("ru = 'домашняя кошка'"));
	
	Возврат ТаблицаСоответствий;
	
КонецФункции

Процедура ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, КодНовый, НаименованиеНовый, КодСтарый, НаименованиеСтарый)
	
	НоваяСтрока = ТаблицаСоответствий.Добавить();
	НоваяСтрока.КодНовый           = КодНовый;
	НоваяСтрока.НаименованиеНовый  = НаименованиеНовый;
	НоваяСтрока.КодСтарый          = КодСтарый;
	НоваяСтрока.НаименованиеСтарый = НаименованиеСтарый;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли