# edt-export

Репозиторий устарел. Актуальное приложение теперь тут https://github.com/Stepa86/stebi

Экспорт диагностик 1С: EDT для SonarQube 1C (BSL) Community Plugin.

Покажет проверки от 1С: EDT в Сонаре.

## Что это?

Это приложение, которое возьмет результаты валидации проекта от 1С: EDT и сконвертирует их в файл json, который умеет читать Sonar.

## Вам потребуется

1. [1С: EDT](https://releases.1c.ru/project/DevelopmentTools10)
2. [Oscript](http://oscript.io/)
3. [Sonar](https://www.sonarqube.org/downloads/)
4. BSL Language Server https://github.com/1c-syntax/bsl-language-server
5. Плагин для SonarQube https://github.com/1c-syntax/sonar-bsl-plugin-community
6. Sonar Scanner https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

## Установка

1. Скачайте *.ospx файл из релизов
2. Выполните команду `opm install -f путь/к/ospx/файлу`

ИЛИ

opm install edt-export-bugs

## Получение отчета о проверке от EDT

[Пример батника](test/export-edt.bat)

## Получение джсон файла для сонара по отчету о проверке EDT

`edt-export-bugs c ./edt-result.out ./edt-json.json ./src`

`c` или `convert` - команда конвертации  
`EDT_VALIDATION_RESULT` - Путь к файлу с результатом проверки edt. Например ./edt-result.out  
`EDT_VALIDATION_JSON` - Путь к файлу результату. Например ./edt-json.json. Его нужно указать в `sonar-project.properties`.  
`SRC` - Путь к каталогу с исходниками. Например ./src. Лучше указывать относительный путь. Абсолютный путь сонар может и не воспринять.  

Аргументы можно так же задать через одноименные параметры окружения.

## Пример настроек проекта Сонара

```
sonar.host.url=http://localhost:9000
sonar.projectKey=UNF
sonar.projectVersion=1.6.17
sonar.sources=src
sonar.sourceEncoding=UTF-8
sonar.inclusions=**/*.bsl
sonar.externalIssuesReportPaths=edt-json.json,acc-generic-issue.json,bsl-generic-json.json
```

## Переопределение файла с ошибками

Приложение позволяет создать файл настроек по существующим выгрузкам формата [generic-issue](https://docs.sonarqube.org/latest/analysis/generic-issue/) и применить эти настройки к указанным файлам generic-issue.

Таким образом возможно указать effortMinutes, переопределить type и severity.

### Файл настроек

Для создания файла используется команда `p` или `prepare`.  
`GENERIC_ISSUE_SETTINGS_JSON` - Путь к файлу настроек. Если файл существует, то он будет обновлен.  
`GENERIC_ISSUE_JSON` - Путь к файлам generic-issue.json, на основе которых будет создан файл настроек.

Пример команды `edt-export-bugs prepare ./test/settigs.json ./test/acc-generic-issue.json,./test/edt-json.json`

Будет создан файл json с массивом настроек. В каждой настройке есть ключевые поля: `ruleId`, `message`, `filePath` и значения для переопределения `severity`, `type` и `effortMinutes`.

Ошибка соответствует ключевому полю, если значения совпадают, ключевое поле пустое или поле ошибки соответствует ключевому полю с учетом регулярного выражения.

Если все ключевые поля соответствуют ошибке, то в ошибке подменяются заполненные значения для переопределения.

Например, файл настроек с таким содержимым:

```json
[
{
"ruleId": "",
"message": "",
"filePath": ".*Documents.*",
"severity": null,
"type": null,
"effortMinutes": 500
}
]
```
Установит всем документам effortMinutes = 500.

Настройки проверяются и применяются по очереди, поэтому могут друг друга переопределять.

## Применение настроек и удаление файлов на поддержке

Для применения файла настроек к файлам используется команда `t` или `transform`.

Аргумент `GENERIC_ISSUE_JSON` - путь к отчетам через запятую. Может быть задан через переменную окружения.

Опция `s settings` - путь к файлу настроек. Может быть задан через переменную окружения `GENERIC_ISSUE_SETTINGS_JSON`.

Опция `src` - путь к каталогу исходных файлов. Используется для получения информации о поддержке.

Опция `r remove_support` - уровень удаляемой поддержки.  
    0 - удалить файлы на замке,  
	1 - удалить файлы на замке и на поддержке  
	2 - удалить файлы на замке, на поддержке и снятые с поддержки  

Пример команды:

```bat
@set GENERIC_ISSUE_SETTINGS_JSON=%1conf\settigs.json
@set GENERIC_ISSUE_JSON=%1acc-generic-issue.json,%1bsl-generic-json.json,%1edt-json.json
@set SRC=%1src

@call edt-export-bugs convert "%1temp\edt-result.out" "%1edt-json.json" 

@call edt-export-bugs transform -r=1
```
