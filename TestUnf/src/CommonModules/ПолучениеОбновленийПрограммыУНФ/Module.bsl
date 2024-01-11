
#Область ПрограммныйИнтерфейс

// Переопределяет параметры загружаемых и устанавливаемых исправлений (патчей).
//
// Параметры:
//  Настройки - Структура:
//    * ОтключитьНапоминания - Булево - Истина, если необходимо отключить создание задачи по включению автоматической
//        загрузки исправлений в подсистеме БСП.ТекущиеДела и не показывать оповещение пользователю при старте системы,
//        если подсистема БСП.ТекущиеДела отсутствует в конфигурации.
//    * Подсистемы - Массив из Структура - список программ, исправления которых необходимо загружать и устанавливать:
//        ** ИмяПодсистемы - Строка - имя подсистемы, например, "ИнтернетПоддержкиПользователей".
//        ** ИдентификаторИнтернетПоддержки - Строка - имя программы в сервисах Интернет-поддержки.
//        ** Версия - Строка - версия программы в формате из 4-х цифр, например, "2.1.3.1".
//
//@skip-warning
Процедура ПриОпределенииНастроекЗагрузкиИсправлений(Настройки) Экспорт
	
	Настройки.ОтключитьНапоминания = Истина;
	
КонецПроцедуры

#КонецОбласти
