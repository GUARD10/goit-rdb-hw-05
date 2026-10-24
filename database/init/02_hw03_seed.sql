USE goit_rdb_hw_03;

LOAD DATA INFILE '/var/lib/mysql-files/categories.csv'
INTO TABLE categories
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, description);

LOAD DATA INFILE '/var/lib/mysql-files/customers.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, contact, address, city, @postal_code, country)
SET postal_code = NULLIF(@postal_code, '');

LOAD DATA INFILE '/var/lib/mysql-files/employees.csv'
INTO TABLE employees
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, last_name, first_name, birthdate, photo, notes);

LOAD DATA INFILE '/var/lib/mysql-files/shippers.csv'
INTO TABLE shippers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, phone);

LOAD DATA INFILE '/var/lib/mysql-files/suppliers.csv'
INTO TABLE suppliers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, contact, address, city, postal_code, country, phone);

LOAD DATA INFILE '/var/lib/mysql-files/products.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, supplier_id, category_id, unit, price);

LOAD DATA INFILE '/var/lib/mysql-files/orders.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, customer_id, employee_id, `date`, shipper_id);

LOAD DATA INFILE '/var/lib/mysql-files/order_details.csv'
INTO TABLE order_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, order_id, product_id, quantity);

