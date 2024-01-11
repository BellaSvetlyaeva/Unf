#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПредставлениеЗаписи(Запись) Экспорт

	ОграничениеОтключено = НСтр("ru = 'Ограничение выгрузки остатков не установлено'");
	ТекстОграничения1 = НСтр("ru = 'Остаток недоступен к выгрузке'");
	ТекстОграничения2 = НСтр("ru = 'К выгрузке доступно %1 % от учетного количества остатка номенклатуры'");
	ТекстОграничения3 = НСтр("ru = 'Из выгружаемого остатка номенклатуры исключается страховой запас в количестве %1'");
	ТекстОграничения4 = НСтр("ru = 'К выгрузке доступно %1 % от учетного количества остатка номенклатуры, но с обеспечением страхового запаса в количестве %2 остатка номенклатуры'");

	Если Не Запись.Используется Тогда
		ПредставлениеОграничения = ОграничениеОтключено;
	ИначеЕсли Запись.ПроцентОстатка = 100 И ЗначениеЗаполнено(Запись.СтраховойЗапас) Тогда
		СклоненноеЧисло = ПолучитьСклоненияСтрокиПоЧислу(НСтр("ru = 'единица'"), Запись.СтраховойЗапас,,, "ПД=Родительный;");
		ПредставлениеОграничения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОграничения3, СклоненноеЧисло[0]);
	ИначеЕсли ЗначениеЗаполнено(Запись.ПроцентОстатка) И ЗначениеЗаполнено(Запись.СтраховойЗапас) Тогда
		СклоненноеЧисло = ПолучитьСклоненияСтрокиПоЧислу(НСтр("ru = 'единица'"), Запись.СтраховойЗапас,,, "ПД=Родительный;");
		ПредставлениеОграничения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОграничения4, Запись.ПроцентОстатка, СклоненноеЧисло[0]);
	ИначеЕсли ЗначениеЗаполнено(Запись.ПроцентОстатка) Тогда
		ПредставлениеОграничения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОграничения2, Запись.ПроцентОстатка);
	Иначе
		ПредставлениеОграничения = ТекстОграничения1;
	КонецЕсли;

	Запись.ПредставлениеОграничения = ПредставлениеОграничения;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
