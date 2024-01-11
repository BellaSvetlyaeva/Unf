
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц) Экспорт
	ОтражениеЗарплатыВБухучетеБазовый.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц);
КонецПроцедуры

Процедура УстановитьСписокВыбораОтношениеКЕНВД(ЭлементФормы, ИмяЭлемента) Экспорт
	
	// В базовой реализации не устанавливается.
	
КонецПроцедуры

Функция ДанныеДляОтраженияЗарплатыВБухучете(Организация, ПериодРегистрации) Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.ДанныеДляОтраженияЗарплатыВБухучете(Организация, ПериодРегистрации);
	
КонецФункции

Процедура ДополнитьСведенияОВзносахДаннымиБухучета(Движения, Организация, ПериодРегистрации, Ссылка, МенеджерВременныхТаблиц, ИмяВременнойТаблицы) Экспорт
	
	// В базовой реализации не переопределяется.
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыДляРасчетаОценочныхОбязательствОтпусков(Организация, ПериодРегистрации, ПараметрыДляРасчета, Сотрудники) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.ЗаполнитьПараметрыДляРасчетаОценочныхОбязательствОтпусков(Организация, ПериодРегистрации, ПараметрыДляРасчета, Сотрудники);
	
КонецПроцедуры

Процедура ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Организация, Период, КоллекцияНачисленныйНДФЛ) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Организация, Период, КоллекцияНачисленныйНДФЛ);
	
КонецПроцедуры

Процедура УдалитьРольОтражениеЗарплатыВБухгалтерскомУчете() Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.УдалитьРольОтражениеЗарплатыВБухгалтерскомУчете();
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыПолученияФОТОрганизацийДляОценочныхОбязательствОтпусков(Организации, Период, ТаблицаПараметров) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.ЗаполнитьПараметрыПолученияФОТОрганизацийДляОценочныхОбязательствОтпусков(Организации, Период, ТаблицаПараметров);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыПолученияФОТСотрудниковДляОценочныхОбязательствОтпусков(СотрудникиДляОбработки, Период, ПараметрыПолученияФОТ) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.ЗаполнитьПараметрыПолученияФОТСотрудниковДляОценочныхОбязательствОтпусков(СотрудникиДляОбработки, Период, ПараметрыПолученияФОТ);
	
КонецПроцедуры

Процедура ЗаполнитьСведенияОбОтпускахСотрудниковДляОценочныхОбязательств(СведенияОбОтпусках, СотрудникиДляОбработки, Организация, Период) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.ЗаполнитьСведенияОбОтпускахСотрудниковДляОценочныхОбязательств(СведенияОбОтпусках, СотрудникиДляОбработки, Организация, Период);
	
КонецПроцедуры

Функция ИспользуетсяЕНВД() Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.ИспользуетсяЕНВД();
	
КонецФункции

Процедура ИсключитьСтрокиНеОблагаемыеВзносами(БухучетНачислений) Экспорт
	
	// В базовой реализации не переопределяется.
	
КонецПроцедуры

Функция ТребуетсяРегистрацияПроцентаЕНВД(МенеджерВТ, ИмяИсходнойВТ, Организация, Период) Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.ТребуетсяРегистрацияПроцентаЕНВД(МенеджерВТ, ИмяИсходнойВТ, Организация, Период);
	
КонецФункции

Процедура СоздатьВТНачисленияСДаннымиЕНВД(Организация, МесяцНачисления, МенеджерВременныхТаблиц, НачисленияПоСотрудникам) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.СоздатьВТНачисленияСДаннымиЕНВД(Организация, МесяцНачисления, МенеджерВременныхТаблиц, НачисленияПоСотрудникам);
	
КонецПроцедуры

Процедура РаспределитьВзносыПоБазеПоУмолчанию(КоллекцияСтрокВзносов, Организация, Период) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.РаспределитьВзносыПоБазеПоУмолчанию(КоллекцияСтрокВзносов, Организация, Период);
	
КонецПроцедуры

Процедура РаспределитьСведенияОДоходахПоСтатьямиПоБазеПоУмолчанию(СведенияОДоходах, РезультатРаспределения) Экспорт
	
	// В базовой реализации не переопределяется.
	
КонецПроцедуры

Процедура СоздатьВТНачисленияСДаннымиЕНВДПоЕжемесячнойДоле(МенеджерВТ, Организация, МесяцНачисления) Экспорт
	
	ОтражениеЗарплатыВБухучетеБазовый.СоздатьВТНачисленияСДаннымиЕНВДПоЕжемесячнойДоле(МенеджерВТ, Организация, МесяцНачисления);
	
КонецПроцедуры

Функция БухучетБазовыхНачисленийОценочныхОбязательств(Организация, Сотрудники, НачалоПериода, КонецПериода, ОбязательстваПоОтпускам, БазовыеНачисления) Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.БухучетБазовыхНачисленийОценочныхОбязательств(Организация, Сотрудники, НачалоПериода, КонецПериода, ОбязательстваПоОтпускам, БазовыеНачисления);
	
КонецФункции

Функция ИсчисленныеВзносыДляРасчетаОценочныхОбязательств(Организация, Период, Сотрудники, ОбязательстваПоОтпускам, БазовыеНачисления) Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.ИсчисленныеВзносыДляРасчетаОценочныхОбязательств(Организация, Период, Сотрудники, ОбязательстваПоОтпускам, БазовыеНачисления);
	
КонецФункции

Функция НастройкиБухучетаДляРасчетаОбязательств(ТаблицаСотрудников, Организация, Период) Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.НастройкиБухучетаДляРасчетаОбязательств(ТаблицаСотрудников, Организация, Период);
	
КонецФункции

Функция БазовыеНачисленияОплатаТруда() Экспорт
	
	Возврат ОтражениеЗарплатыВБухучетеБазовый.БазовыеНачисленияОплатаТруда()
	
КонецФункции

#КонецОбласти