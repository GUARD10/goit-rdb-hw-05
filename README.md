# Домашнє завдання №5 — Вкладені запити. Повторне використання коду

Репозиторій містить розв’язання п’яти завдань: підзапити в `SELECT`, `WHERE` і `FROM`, спільний табличний вираз (`WITH`) та користувацьку функцію в MySQL. Використовується набір даних із ДЗ №3 — база `goit_rdb_hw_03`.

Репозиторій: [GUARD10/goit-rdb-hw-05](https://github.com/GUARD10/goit-rdb-hw-05).

## Структура

```text
goit-rdb-hw-05/
├── database/
│   ├── csv/                              # 8 CSV із даними ДЗ №3
│   ├── init/                             # Автоматична ініціалізація MySQL
│   │   ├── 01_hw03_schema.sql            # Створення восьми таблиць і зв’язків
│   │   └── 02_hw03_seed.sql              # Завантаження CSV
│   └── queries/                          # Розв’язання завдань
│       ├── task_1_select_subquery.sql
│       ├── task_2_where_subquery.sql
│       ├── task_3_from_subquery.sql
│       ├── task_4_with_cte.sql
│       └── task_5_divide_function.sql
├── screenshots/
│   ├── task_1/task_1_select_subquery_result.png
│   ├── task_2/task_2_where_subquery_result.png
│   ├── task_3/task_3_from_subquery_result.png
│   ├── task_4/task_4_with_cte_result.png
│   └── task_5/task_5_divide_function_result.png
├── goit-rdb.compose.yaml                  # MySQL 8.4, порт і том даних
└── README.md
```

Кожен файл завдання містить власний `USE goit_rdb_hw_03`, тому його можна виконувати окремо. Скриншоти мають назви відповідних SQL-файлів із постфіксом `_result`. Префікси `01` і `02` в `init` визначають порядок ініціалізації.

## Запуск

Команди виконуйте з кореня проєкту із запущеним Docker Desktop:

```powershell
docker compose -f goit-rdb.compose.yaml up -d
docker compose -f goit-rdb.compose.yaml logs -f mysql
```

Дочекайтеся завершення init-скриптів і повідомлення `ready for connections` із портом `3306`. Вийти з перегляду логів можна через Ctrl+C.

Під час першого запуску з порожнім томом автоматично створюються та заповнюються таблиці `categories`, `customers`, `employees`, `shippers`, `suppliers`, `products`, `orders` і `order_details`. Схему, seed-скрипт і вісім CSV взято з ДЗ №4 без частини `LibraryManagement`. Схема використовує InnoDB, `utf8mb4` та зовнішні ключі; seed завантажує CSV через `LOAD DATA INFILE` у порядку залежностей таблиць. За наявності ініціалізованого тому init-скрипти повторно не виконуються, тому нова схема застосовується лише до порожнього тому.

Перегляд стану сервісу:

```powershell
docker compose -f goit-rdb.compose.yaml ps
```

## Підключення в MySQL Workbench

Створіть підключення з методом **Standard (TCP/IP)**:

| Параметр | Значення |
| --- | --- |
| Hostname | `127.0.0.1` |
| Port | `3309` |
| Username | `goit_hw_05` |
| Password | `goit_hw_05_local` |
| Default Schema | `goit_rdb_hw_03` |

Контейнер `goit-rdb-hw-05-mysql` і том `goit-rdb-hw-05_mysql_data` належать цьому завданню. Порт `3309` дозволяє працювати поряд із ДЗ №3 та №4. Облікові дані відповідають локальній навчальній конфігурації в `goit-rdb.compose.yaml`.

Параметр `--log-bin-trust-function-creators=1` дозволяє навчальному користувачу створити функцію із завдання 5 за ввімкненого бінарного журналу. Параметр `--secure-file-priv=/var/lib/mysql-files` задає каталог імпорту, до якого змонтовано `database/csv`.

Змінні користувача й паролів застосовуються під час першої ініціалізації порожнього тому. Якщо база вже запускалася зі старою конфігурацією, наявні облікові записи автоматично не зміняться.

Відкрийте потрібний файл із `database/queries/`, виконайте його та перегляньте результат у **Result Grid**.

Також можна запустити клієнт MySQL у контейнері:

```powershell
docker compose -f goit-rdb.compose.yaml exec mysql mysql -u goit_hw_05 -p
```

Після введення пароля виконайте потрібні файли:

```sql
SOURCE /queries/task_1_select_subquery.sql;
SOURCE /queries/task_2_where_subquery.sql;
SOURCE /queries/task_3_from_subquery.sql;
SOURCE /queries/task_4_with_cte.sql;
SOURCE /queries/task_5_divide_function.sql;
```

Зупинка зі збереженням даних:

```powershell
docker compose -f goit-rdb.compose.yaml down
```

## Завдання та SQL-запити

### 1. Підзапит у SELECT

Для кожного рядка `order_details` корельований підзапит знаходить `customer_id` у таблиці `orders` за відповідним `order_id`.

[SQL-файл](database/queries/task_1_select_subquery.sql) · [Скриншот](screenshots/task_1/task_1_select_subquery_result.png)

### 2. Підзапит у WHERE

Підзапит вибирає ідентифікатори замовлень із `shipper_id = 3`. Зовнішній запит повертає їхні позиції з `order_details` через умову `IN`.

[SQL-файл](database/queries/task_2_where_subquery.sql) · [Скриншот](screenshots/task_2/task_2_where_subquery_result.png)

### 3. Підзапит у FROM

Вкладений запит залишає позиції з `quantity > 10`. Зовнішній запит групує їх за `order_id` та обчислює `AVG(quantity)` для кожного замовлення.

[SQL-файл](database/queries/task_3_from_subquery.sql) · [Скриншот](screenshots/task_3/task_3_from_subquery_result.png)

### 4. Спільний табличний вираз WITH

Вибірка позицій із `quantity > 10` винесена в CTE з назвою `temp`. Основний запит обчислює середню кількість за замовленням, як у завданні 3.

[SQL-файл](database/queries/task_4_with_cte.sql) · [Скриншот](screenshots/task_4/task_4_with_cte_result.png)

### 5. Користувацька функція

Функція `divide_float(dividend FLOAT, divisor FLOAT) RETURNS FLOAT` ділить перший аргумент на другий. Запит застосовує її до `quantity` з дільником `3`. Перед створенням виконується `DROP FUNCTION IF EXISTS`, що дозволяє повторно запускати файл.

[SQL-файл](database/queries/task_5_divide_function.sql) · [Скриншот](screenshots/task_5/task_5_divide_function_result.png)

## Очікувані результати

Для наданого набору даних:

| Завдання | Результат | Кількість рядків |
| --- | --- | --- |
| 1 | Позиції замовлень із `customer_id` | 518 |
| 2 | Позиції замовлень із `shipper_id = 3` | 181 |
| 3 | Середня кількість за замовленням після фільтрації | 175 |
| 4 | Та сама агрегація через CTE `temp` | 175 |
| 5 | Позиції замовлень із результатом `quantity / 3` | 518 |
