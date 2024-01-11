#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ТекстСообщения = НСтр("ru = 'Внимание, выполнение полного обмена может занять длительное время. Продолжить?'");

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрКоманды", ПараметрКоманды);
	ДополнительныеПараметры.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);

	ПоказатьВопрос(Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, ДополнительныеПараметры),
		ТекстСообщения, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ПараметрКоманды = ДополнительныеПараметры.ПараметрКоманды;
	ПараметрыВыполненияКоманды = ДополнительныеПараметры.ПараметрыВыполненияКоманды;

	Ответ = Результат;

	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	УзелОбмена = ПараметрКоманды;

	Если УзелОбмена = ОбменССайтомПовтИсп.ПолучитьЭтотУзелПланаОбмена("ОбменУправлениеНебольшойФирмойСайт") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр(
			"ru = 'Узел соответствует этой информационной базе и не может использоваться в обмене с сайтом. Используйте другой узел обмена или создайте новый.'"));
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыФормы.Вставить("ВыгружатьТолькоИзменения", Ложь);

	ОткрытьФорму("ПланОбмена.ОбменУправлениеНебольшойФирмойСайт.Форма.ФормаВыполнениеОбмена", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, УзелОбмена);

КонецПроцедуры

#КонецОбласти