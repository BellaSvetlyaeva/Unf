#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиКомпоновки = Неопределено;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресНастроекКомпоновки) Тогда
		
		НастройкиКомпоновки = ПолучитьИзВременногоХранилища(Параметры.АдресНастроекКомпоновки);
		
	КонецЕсли;
		
	ИнициализироватьКомпоновщикСервер(НастройкиКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Закрыть(ПолучитьНастройкиКомпоновкиСервер());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкиКомпоновки)
	
	СхемаВыгрузкиТоваров = ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.ПолучитьМакет("СхемаВыгрузкиТоваров");
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаВыгрузкиТоваров, УникальныйИдентификатор);
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
	
	Если НастройкиКомпоновки = Неопределено Тогда
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаВыгрузкиТоваров.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НастройкиКомпоновки);
		КомпоновщикНастроекКомпоновкиДанных.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиКомпоновкиСервер()
	
	Возврат КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки();
	
КонецФункции

#КонецОбласти
