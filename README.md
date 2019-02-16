# edt-export
Экспорт диагностик 1С: EDT для SonarQube 1C (BSL) Community Plugin

# Получение отчета о проверке от EDT

[Пример батника](test/export-edt.bat)

# Получение джсон файла для сонара по отчету о проверке EDT

[Пример батника](test/convert.bat)

# Пример настроек проекта Сонара

```
sonar.host.url=http://localhost:9000
sonar.projectKey=UNF
sonar.projectVersion=1.16
sonar.sources=src
sonar.sourceEncoding=UTF-8
sonar.inclusions=**/*.bsl
sonar.bsl.languageserver.reportPaths=bsl-json.json
sonar.externalIssuesReportPaths=edt-json.json
```
