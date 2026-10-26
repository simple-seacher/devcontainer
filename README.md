# Search Service Dev Container

Самостоятельный инфраструктурный репозиторий. Подключается в `search-service/.devcontainer` через Git submodule; конкретный коммит окружения зафиксирован основным репозиторием.

## Основа подхода

Из загруженного примера `default-project-devcontainer` сохраняем ключевой паттерн: отдельный репозиторий с `devcontainer.json`, Compose и Dockerfile и монтирование исходников из родительского каталога. PHP, Traefik, Mailhog, Adminer и прочие зависимости CS-Cart не переносим.

Сейчас включены только Go workspace, PostgreSQL 17 + pgvector 0.8.7, `pg_trgm`, локальный том БД и линтер. Нет Go-кода приложения, API, Kafka, объектного хранилища, inference или production Dockerfile.

## Запуск

Из корня `search-service` после подключения submodule:

```bash
cp .devcontainer/.env.example .devcontainer/.env
cd .devcontainer
docker compose -f compose.yaml config --quiet
cd ..
```

Открыть корень `search-service` в VS Code и выбрать **Dev Containers: Reopen in Container**.

Проверки внутри контейнера:

```bash
go version
golangci-lint version
psql -h postgres -U search -d search -c 'SELECT extname, extversion FROM pg_extension;'
```

Базовый Go-образ привязан к ветке 1.26; при создании `go.mod` нужно выбрать и синхронизировать версию Go в окружении. `golangci-lint` зафиксирован как v2.15.0 (совпадает с GitHub Actions приложения).

## CI

Инфраструктурный workflow проверяет JSON/Compose, собирает dev-образ и выполняет smoke-test расширений PostgreSQL. Код Go-приложения здесь не создаётся и не тестируется.

## Безопасность

- `.env` не коммитится; пароль из `.env.example` — только для изолированной локальной разработки.
- Порт PostgreSQL на хосте доступен лишь через `127.0.0.1`.
- Обычные stop/down сохраняют данные volume; не выполняй `down -v` без явного разрешения.
- Для использования изменения из этого репозитория нужно отдельно обновить указатель submodule в приложении.
