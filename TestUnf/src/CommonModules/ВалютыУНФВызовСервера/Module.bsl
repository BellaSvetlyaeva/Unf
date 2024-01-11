#Область ПрограммныйИнтерфейс

// Устарела. Будет удалена в следующей версии программы.
// См. ВалютыУНФ.ДополнитьЗаголовокКлиентскогоПриложения
Процедура ДополнитьЗаголовокКлиентскогоПриложения(ЗаголовокПриложения) Экспорт
	ВалютыУНФ.ДополнитьЗаголовокКлиентскогоПриложения(ЗаголовокПриложения);
КонецПроцедуры

// Служит для вызова серверной процедуры ПриДобавленииПараметровРаботыКлиентаПриЗапуске с клиента
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	ВалютыУНФ.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
КонецПроцедуры

// Проверяет актуальность курсов валют
//
// Возвращаемое значение: 
//  Булево - признак актуальности курсов валют.
//
Функция КурсыВалютАктуальны() Экспорт
	Возврат ВалютыУНФ.КурсыВалютАктуальны();
КонецФункции

#КонецОбласти