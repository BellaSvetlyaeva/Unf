#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыНумерации(Объект) Экспорт 
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЧисловойНомер", 	Объект.ЧисловойНомер);
	СтруктураПараметров.Вставить("Организация", 	Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДоговора", 	Объект.ДатаДоговора);
	СтруктураПараметров.Вставить("Ссылка", 			Объект.Ссылка);
	Возврат СтруктураПараметров;
	
КонецФункции	

#КонецОбласти
