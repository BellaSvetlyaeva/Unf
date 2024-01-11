#Область ПрограммныйИнтерфейс

// Устарела. Будет удалена в следующих версиях
//
// Процедура записывает в базу данных дисконтную карту на основании
// переданной структуры с данными дисконтной карты.
//
// Параметры
//  СтруктураДанныхКарты - Структура с данными дисконтной карты
//
// Возвращаемое значение
//  СправочникСсылка.ДисконтныеКарты
//
Функция ЗарегистрироватьДисконтнуюКарту(СтруктураДанныхКарты) Экспорт
	
	ДисконтныеКартыУНФСервер.ЗарегистрироватьДисконтнуюКарту(СтруктураДанныхКарты);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ПолучитьСтруктуруДанныхДисконтнойКарты
//
// Функция возвращает пустую структуру данных дисконтных карт 
//
// Параметры
//  Нет
//
// Возвращаемое значение
//  Структура - Данные дисконтной карты
//
Функция ПолучитьСтруктуруДанныхДисконтнойКарты() Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.ПолучитьСтруктуруДанныхДисконтнойКарты();
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ПолучитьОсновнойТипКодаДисконтнойКарты
//
// Функция возвращает тип кода дисконтной карты, если только он
// используется в видах дисконтных карт.
//
// Параметры
//  Нет
//
// Возвращаемое значение
//  Перечисление.ТипыКодовКарт / Неопределено
//
Функция ПолучитьОсновнойТипКодаДисконтнойКарты() Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.ПолучитьОсновнойТипКодаДисконтнойКарты();
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ТекстЗапросаПродажиПоДисконтнойКарте
//
Функция ТекстЗапросаПродажиПоДисконтнойКарте(ИмяДокумента) Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.ТекстЗапросаПродажиПоДисконтнойКарте(ИмяДокумента);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ПроверитьИСоздатьУсловиеПоДисконтнойКарте
//
Процедура ПроверитьИСоздатьУсловиеПоДисконтнойКарте() Экспорт
	
	ДисконтныеКартыУНФСервер.ПроверитьИСоздатьУсловиеПоДисконтнойКарте();
	
КонецПроцедуры

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ЕстьСкидкиПоВидуКарт
//
// Проверяет, есть ли для указанного вида дисконтных карт действующие скидки
//
// Параметры
//  ВидДисконтнойКарты - Справочник.ВидыДисконтныхКарт
//
// Возвращаемое значение
//  Булево
//
Функция ЕстьСкидкиПоВидуКарт(ВидДисконтнойКарты) Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.ЕстьСкидкиПоВидуКарт(ВидДисконтнойКарты);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ПолучитьЕдинственноеУсловиеПоДисконтнымКартам
//
Функция ПолучитьЕдинственноеУсловиеПоДисконтнымКартам() Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.ПолучитьЕдинственноеУсловиеПоДисконтнымКартам();
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.ПроверитьИУстановитьОпциюАвтоматическиеСкидки
//
Процедура ПроверитьИУстановитьОпциюАвтоматическиеСкидки() Экспорт
	
	ДисконтныеКартыУНФСервер.ПроверитьИУстановитьОпциюАвтоматическиеСкидки();
	
КонецПроцедуры

#Область ПоискДисконтныхКарт

// Устарела.Будет удалена в следующих версиях
//
// Функция возвращает дисконтную карту партнера, если она у него одна.
//
// Параметры
//  Партнер - СправочникСсылка.Партнеры
//
// Возвращаемое значение
//  СправочникСсылка.ДисконтныеКарты / Неопределено
//
Функция ПолучитьКартуПоУмолчаниюДляПартнера(Контрагент) Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.ПолучитьКартуПоУмолчаниюДляПартнера(Контрагент);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.НайтиДисконтныеКарты
//
// Функция выполняет поиск дисконтных карт
//
// Параметры
//  КодКарты - Строка
//  ТипКода - Перечисление.ТипыКодовКарт
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиДисконтныеКарты(КодКарты, ТипКода, Шаблон = Неопределено) Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.НайтиДисконтныеКарты(КодКарты, ТипКода, Шаблон);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФСервер.НайтиДисконтныеКартыПоМагнитномуКоду
//
// Функция выполняет поиск дисконтных карт по магнитному коду
//
// Параметры
//  Магнитный код - Строка
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиДисконтныеКартыПоМагнитномуКоду(МагнитныйКод) Экспорт
	
	Возврат ДисконтныеКартыУНФСервер.НайтиДисконтныеКартыПоМагнитномуКоду(МагнитныйКод);
	
КонецФункции

#КонецОбласти

#КонецОбласти