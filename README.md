# Warehouse Accounting (PostgreSQL + Python)

Проект переведен на PostgreSQL и Python-клиент.

## Запуск

```bash
docker compose up --build
```

После запуска:
- UI: http://localhost:8000
- PostgreSQL: localhost:5432

## Что внутри

- `db/init/01_schema.sql` — схема и стартовые данные PostgreSQL.
- `client/app.py` — Python-клиент (Flask) с операциями прихода/расхода.
- `docker/db/Dockerfile` — контейнер БД.
- `docker/client/Dockerfile` — контейнер клиента.