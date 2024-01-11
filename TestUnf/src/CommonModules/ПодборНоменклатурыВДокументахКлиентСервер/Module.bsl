
#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает форматированную строку формата 00,00. Дробная часть выводить более мелким шрифтом.
//
// Сумма - Число. Число которое преобразовывается к строке
//
// Возвращает форматированную строку.
//
Функция СуммаФорматированнойСтрокой(Сумма) Экспорт
	
	Сумма = Формат(Сумма, "ЧЦ=15; ЧДЦ=2; ЧН=0,00");
	
	ПозицияРазделителя = СтрНайти(Сумма, ",");
	
	ЦелаяЧастьСуммы = Лев(Сумма, ПозицияРазделителя);
	ДробнаяЧасть	= СтрЗаменить(Сумма, ЦелаяЧастьСуммы, "");
	
	Шрифт14 = Новый Шрифт(,14);
	Шрифт10 = Новый Шрифт(,10);
	
	НадписьЦелаяЧасть = Новый ФорматированнаяСтрока(ЦелаяЧастьСуммы, Шрифт14);
	НадписьДробнаяЧасть = Новый ФорматированнаяСтрока(ДробнаяЧасть, Шрифт10);
	
	А = Новый Массив();
	А.Добавить(НадписьЦелаяЧасть);
	А.Добавить(НадписьДробнаяЧасть);
	
	Возврат Новый ФорматированнаяСтрока(А); 
	
КонецФункции // СуммаФорматированнойСтрокой()

#КонецОбласти 

