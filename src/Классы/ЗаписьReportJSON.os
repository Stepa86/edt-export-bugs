#Использовать json

Перем _Лог;
Перем _ФайлДжсон;


Процедура ПриСозданииОбъекта( Знач пФайлДжсон, Знач пЛог )
	
	_ФайлДжсон = пФайлДжсон;
	_Лог = пЛог;
	
КонецПроцедуры

Процедура Записать( Знач пТаблицаРезультатовПроверки ) Экспорт
	
	ошибки = Новый Массив;
	
	Для каждого цСтрока Из пТаблицаРезультатовПроверки Цикл
		
		структОшибка = Новый Структура;
		
		структОшибка.Вставить("engineId", ИсточникПроверки());
		структОшибка.Вставить("ruleId", ИдентификаторПравил(цСтрока) );
		структОшибка.Вставить("primaryLocation", МестонахождениеОшибки(цСтрока));
		структОшибка.Вставить("type", ТипОшибки(цСтрока));
		структОшибка.Вставить("severity", ВажностьОшибки(цСтрока));
		структОшибка.Вставить("effortMinutes", ЗатратыНаИсправление(цСтрока));
		структОшибка.Вставить("secondaryLocations", ВторостепенноеМестонахождение(цСтрока));
		
		ошибки.Добавить( структОшибка );

	КонецЦикла;
	
	структ = Новый Структура("issues", ошибки);
	
	ЗаписатьФайлJSON( структ );
	
КонецПроцедуры

Функция ИсточникПроверки()
	
	Возврат "edt";
	
КонецФункции

Функция ИдентификаторПравил( Знач пДанные )
	
	Возврат "edt";
	
КонецФункции

Функция МестонахождениеОшибки( Знач пДанные )
	
	структ = Новый Структура;
	
	структ.Вставить( "message", СообщениеОбОшибке( пДанные ));
	структ.Вставить( "filePath", ПутьКФайлу( пДанные ));
	структ.Вставить( "textRange", КоординатыОшибки( пДанные ));
	
	Возврат структ;
	
КонецФункции

Функция СообщениеОбОшибке( Знач пДанные )
	
	Возврат пДанные.Описание;
	
КонецФункции

Функция ПутьКФайлу( Знач пДанные )
	
	Возврат стрЗаменить( пДанные.Путь, "\", "/" );
	
КонецФункции

Функция КоординатыОшибки( Знач пДанные )
	
	структ = Новый Структура;
	
	структ.Вставить( "startLine", пДанные.НомерСтроки );
	//структ.Вставить( "endLine ", );
	//структ.Вставить( "startColumn ", );
	//структ.Вставить( "endColumn  ", );
	
	Возврат структ;
	
КонецФункции

Функция ТипОшибки( Знач пДанные )
	// BUG, VULNERABILITY, CODE_SMELL
	
	Если пДанные.Тип = "Ошибка" Тогда
		
		Возврат "BUG";
		
	Иначе
		
		Возврат "CODE_SMELL";
		
	КонецЕсли;
	
КонецФункции

Функция ВажностьОшибки( Знач пДанные )
	// BLOCKER, CRITICAL, MAJOR, MINOR, INFO
	
	Если пДанные.Тип = "Ошибка" Тогда
		
		Возврат "CRITICAL";
		
	Иначе
		
		Возврат "MINOR";
		
	КонецЕсли;
	
КонецФункции

Функция ЗатратыНаИсправление( Знач пДанные )
	
	Возврат 0;
	
КонецФункции

Функция ВторостепенноеМестонахождение( Знач пДанные )
	
	Возврат Новый Массив;
	
КонецФункции

Процедура ЗаписатьФайлJSON(Знач пЗначение)
	
	Запись = Новый ЗаписьТекста;
	Запись.Открыть(_ФайлДжсон);
	ПарсерJSON  = Новый ПарсерJSON();
	Запись.Записать(ПарсерJSON.ЗаписатьJSON(пЗначение));
	Запись.Закрыть();

	_Лог.Отладка( "Записан " + _ФайлДжсон );
	
КонецПроцедуры