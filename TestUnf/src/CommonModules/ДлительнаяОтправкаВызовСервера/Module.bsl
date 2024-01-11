#Область ПрограммныйИнтерфейс

Функция ОшибкиСервер() Экспорт
	
	ПараметрыОтправки = ДлительнаяОтправкаКлиентСервер.ЗначенияПараметровДлительнойОтправки();
	Возврат ПараметрыОтправки["Ошибки"];
	
КонецФункции

Процедура ИзменитьПараметрыДлительнойОтправкиСервер(КлючПараметра, НовоеЗначение) Экспорт
	
	ДлительнаяОтправкаКлиентСервер.ИзменитьПараметрыДлительнойОтправки(КлючПараметра, НовоеЗначение);
	
КонецПроцедуры

Процедура ОчиститьПараметрыДлительнойОтправкиСервер() Экспорт

	ДлительнаяОтправкаКлиентСервер.ОчиститьПараметрыДлительнойОтправки();

КонецПроцедуры

Функция ПолучитьОшибкиПоследнегоОбмена(ИмяПользователя = Неопределено) Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("ДокументооборотСКонтролирующимиОрганами_ОшибкиПоследнегоОбмена", , , ИмяПользователя);

КонецФункции

Процедура СохранитьОшибкиПоследнегоОбмена(СведенияПоОшибкам, ИмяПользователя = Неопределено) Экспорт
	
	ХранилищеОбщихНастроек.Сохранить("ДокументооборотСКонтролирующимиОрганами_ОшибкиПоследнегоОбмена",, СведенияПоОшибкам, , ИмяПользователя);

КонецПроцедуры

Функция ТекущийЭтапОтправки(ОтчетСсылка, НаименованиеКонтролирующегоОргана = "") Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	// Получение параметров прорисовки
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПолучатьДаты", Ложь);
	ДополнительныеПараметры.Вставить("ПолучатьОшибкиОтправки", Истина);
	
	Орган = ?(ЗначениеЗаполнено(НаименованиеКонтролирующегоОргана), НаименованиеКонтролирующегоОргана, "ФНС");
	
	ТекущееСостояниеОтправки = КонтекстЭДОСервер.ТекущееСостояниеОтправки(
		ОтчетСсылка, 
		Орган, 
		ДополнительныеПараметры);
		
	Возврат ТекущееСостояниеОтправки.ТекущийЭтапОтправки;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти