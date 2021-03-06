#Использовать logos

Перем _Лог;
Перем _РезультатПроверки;
Перем _ФайлДжсон;
Перем _КаталогИсходников;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("EDT_VALIDATION_RESULT", "" ,"Путь к файлу с результатом проверки edt. Например ./edt-result.out")
        .ТСтрока()
        .ВОкружении("EDT_VALIDATION_RESULT");

	Команда.Аргумент("EDT_VALIDATION_JSON", "" ,"Путь к файлу результату. Например ./edt-json.json")
        .ТСтрока()
        .ВОкружении("EDT_VALIDATION_JSON");

    Команда.Аргумент("SRC", "" ,"Путь к каталогу с исходниками. Например ./src")
        .ТСтрока()
        .ВОкружении("SRC");
		
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

    ИнициализацияПараметров(Команда);

    таблицаРезультатов = ТаблицаПоФайлуРезультата();

	ЗаполнитьВТаблицеРезультатовИсходныеПути( таблицаРезультатов );
	ЗаполнитьВТаблицеРезультатовНомераСтрок( таблицаРезультатов );

	записьВДжсон = Новый ЗаписьReportJSON( _ФайлДжсон, _Лог );
	записьВДжсон.Записать( таблицаРезультатов );

КонецПроцедуры

Процедура ИнициализацияПараметров(Знач Команда)

	результатПроверки = Команда.ЗначениеАргумента("EDT_VALIDATION_RESULT");
	_лог.Отладка( "EDT_VALIDATION_RESULT = " + результатПроверки );
	путьКРезультату = Команда.ЗначениеАргумента("EDT_VALIDATION_JSON");
	_лог.Отладка( "EDT_VALIDATION_JSON = " + путьКРезультату );
	путьККаталогуИсходников = Команда.ЗначениеАргумента("SRC");
	_лог.Отладка( "SRC = " + путьККаталогуИсходников );
	
    _РезультатПроверки = ОбщегоНазначения.АбсолютныйПуть( результатПроверки );
	_лог.Отладка( "Файл с результатом проверки EDT = " + _РезультатПроверки );
	
    Если Не ОбщегоНазначения.ФайлСуществует(_РезультатПроверки) Тогда
		
		_лог.Ошибка( СтрШаблон("Файл с результатом проверки <%1> не существует.", результатПроверки) );
		ЗавершитьРаботу(1);

    КонецЕсли;

	_КаталогИсходников = ОбщегоНазначения.АбсолютныйПуть(путьККаталогуИсходников);
	каталогИсходников = Новый Файл(_КаталогИсходников);
	_лог.Отладка( "Каталог исходников = " + _КаталогИсходников );
	
    Если Не каталогИсходников.Существует()
        Или Не каталогИсходников.ЭтоКаталог() Тогда
		
		_лог.Ошибка( СтрШаблон("Каталог исходников <%1> не существует.", путьККаталогуИсходников) );
		ЗавершитьРаботу(1);

    КонецЕсли;
    
    _ФайлДжсон = ОбщегоНазначения.АбсолютныйПуть( путьКРезультату );    
    _лог.Отладка( "Файл результат = " + _ФайлДжсон );
    
КонецПроцедуры

Функция ТаблицаПоФайлуРезультата()
	
	_Лог.Отладка( "Чтение файла результата %1", _РезультатПроверки );
	
	тз = Новый ТаблицаЗначений;
	тз.Колонки.Добавить( "ДатаОбнаружения" );
	тз.Колонки.Добавить( "Тип" );
	тз.Колонки.Добавить( "Проект" );
	тз.Колонки.Добавить( "Метаданные" );
	тз.Колонки.Добавить( "Положение" );
	тз.Колонки.Добавить( "Описание" );
	
	ЧтениеТекста = Новый ЧтениеТекста( _РезультатПроверки, КодировкаТекста.UTF8 );
	
	ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	
	Пока Не ПрочитаннаяСтрока = Неопределено Цикл
		
		Если ПустаяСтрока( ПрочитаннаяСтрока ) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		компонентыСтроки = СтрРазделить( ПрочитаннаяСтрока, "	" );
		
		положение = компонентыСтроки[4];

		Если Не ЗначениеЗаполнено( положение )
			ИЛИ Не СтрНачинаетсяС( ВРег( положение ), "СТРОКА" ) Тогда
            // Нас интересуют только ошибки в модулях, а у них есть положение.
            ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
            Продолжить;
        КонецЕсли;

		новСтрока = тз.Добавить();
		
		Для ц = 0 По 4 Цикл
			
			новСтрока[ц] = компонентыСтроки[ц];
			
		КонецЦикла;
		
		// В описании могут быть и табы, по которым делим
		
		Для ц = 5 По компонентыСтроки.ВГраница() Цикл
			
			Если ЗначениеЗаполнено( новСтрока.Описание ) Тогда
				
				новСтрока.Описание = новСтрока.Описание + "	";
				
			Иначе
				
				новСтрока.Описание = "";
				
			КонецЕсли;
			
			новСтрока.Описание = новСтрока.Описание + компонентыСтроки[ц];
			
		КонецЦикла;
		
		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
		
	КонецЦикла;
	
	ЧтениеТекста.Закрыть();
	
	_Лог.Отладка("Из файла %1 прочитано %2 строк", _РезультатПроверки, тз.Количество());
	
	// В отчете могут быть дубли

	тз.Свернуть("Тип,Метаданные,Положение,Описание");

	Возврат тз;
	
КонецФункции

Процедура ЗаполнитьВТаблицеРезультатовИсходныеПути( таблицаРезультатов )
    
    генераторПутей = Новый Путь1СПоМетаданным( _КаталогИсходников, _лог );

    таблицаРезультатов.Колонки.Добавить("Путь");

    Для каждого цСтрока Из таблицаРезультатов Цикл

        цСтрока.Путь = генераторПутей.Путь(цСтрока.Метаданные);

        генераторПутей.ПроверитьПуть( цСтрока.Путь, цСтрока.Метаданные );

    КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьВТаблицеРезультатовНомераСтрок( таблицаРезультатов )

	таблицаРезультатов.Колонки.Добавить("НомерСтроки");

	Для каждого цСтрока Из таблицаРезультатов Цикл

		цСтрока.НомерСтроки = СтрЗаменить( ВРег( цСтрока.Положение ), "СТРОКА ", "" );

	КонецЦикла;
	
КонецПроцедуры

Функция ИмяЛога() Экспорт
	Возврат "oscript.app.edtExport";
КонецФункции

_Лог = Логирование.ПолучитьЛог(ИмяЛога());