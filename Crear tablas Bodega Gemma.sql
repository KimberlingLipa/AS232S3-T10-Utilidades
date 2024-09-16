-- Cambiar el contexto a la base de datos BodegaGemma
CREATE DATABASE BodegaGemma;
USE BodegaGemma;
GO

-- Crear las tablas

-- 01 Tabla: category_product (categoría producto)
CREATE TABLE category_product (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60),
    description VARCHAR(90),
    active CHAR(1) DEFAULT 'A'
);
GO

-- 02 Tabla: payment_method (método de pago)
CREATE TABLE payment_method (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(90),
    description VARCHAR(100),
    active CHAR(1) DEFAULT 'A'
);
GO

-- 03 Tabla: person (persona)
CREATE TABLE person (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    rol_person CHAR(1),
    type_document CHAR(3),
    number_document VARCHAR(20) UNIQUE,
    names VARCHAR(60),
    last_name VARCHAR(90),
    cell_phone CHAR(9),
    email VARCHAR(80),
    birthdate DATE,
    salary DECIMAL(8,2),
    seller_rol VARCHAR(20),
    seller_user VARCHAR(100),
    seller_password VARCHAR(130),
    active CHAR(1) DEFAULT 'A',
    CONSTRAINT type_document_ck CHECK (type_document IN ('DNI', 'CNE')),
    CONSTRAINT email_ck CHECK (email LIKE '%@%.%')
);
GO

-- 04 Tabla: product (producto)
CREATE TABLE product (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60) UNIQUE NOT NULL,
    category_product_id BIGINT NOT NULL,
    price_unit DECIMAL(8,2) NOT NULL,
    unit_sale VARCHAR(10) NOT NULL,
    date_expiry DATE,
    stock DECIMAL(8,2) NOT NULL,
    active CHAR(1) DEFAULT 'A',
    CONSTRAINT unit_sale_options CHECK (unit_sale IN ('Unidad', 'Kilo')),
    FOREIGN KEY (category_product_id) REFERENCES category_product(id)
);
GO

-- 05 Tabla: supplier (proveedor)
CREATE TABLE supplier (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    ruc CHAR(11),
    name_company VARCHAR(90),
    type_document CHAR(3),
    number_document VARCHAR(20) UNIQUE,
    names VARCHAR(60),
    last_name VARCHAR(80),
    email VARCHAR(90),
    cell_phone CHAR(9),
    active CHAR(1) DEFAULT 'A',
    CONSTRAINT type_document_supplier_ck CHECK (type_document IN ('DNI', 'CNE')),
    CONSTRAINT email_supplier_ck CHECK (email LIKE '%@%.%')
);
GO

-- 06 Tabla: purchase (compra)
CREATE TABLE purchase (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    supplier_id BIGINT,
    seller_id BIGINT,
    payment_method_id BIGINT,
    total_purchase DECIMAL(8,2),
    date_time DATETIME DEFAULT GETDATE(),
    active CHAR(1) DEFAULT 'A',
    FOREIGN KEY (supplier_id) REFERENCES supplier(id),
    FOREIGN KEY (seller_id) REFERENCES person(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(id)
);
GO

-- 07 Tabla: purchase_detail (detalle de compra)
CREATE TABLE purchase_detail (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    purchase_id BIGINT,
    product_id BIGINT,
    price_unit DECIMAL(8,2),
    amount DECIMAL(8,2),
    subtotal_purchase DECIMAL(8,2),
    FOREIGN KEY (purchase_id) REFERENCES purchase(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);
GO

-- 08 Tabla: sale (venta)
CREATE TABLE sale (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    seller_id BIGINT,
    client_id BIGINT,
    payment_method_id BIGINT,
    total_sale DECIMAL(8,2),
    date_time DATETIME DEFAULT GETDATE(),
    active CHAR(1) DEFAULT 'A',
    FOREIGN KEY (seller_id) REFERENCES person(id),
    FOREIGN KEY (client_id) REFERENCES person(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(id)
);
GO

-- 09 Tabla: sale_detail (detalle de venta)
CREATE TABLE sale_detail (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    sale_id BIGINT,
    product_id BIGINT,
    amount DECIMAL(8,2),
    subtotal_sale DECIMAL(8,2),
    FOREIGN KEY (sale_id) REFERENCES sale(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);
GO

-- Crear índices para mejorar el rendimiento de las consultas
CREATE INDEX idx_product_category_product_id ON product (category_product_id);
CREATE INDEX idx_purchase_supplier_id ON purchase (supplier_id);
CREATE INDEX idx_purchase_seller_id ON purchase (seller_id);
CREATE INDEX idx_purchase_payment_method_id ON purchase (payment_method_id);
CREATE INDEX idx_purchase_detail_purchase_id ON purchase_detail (purchase_id);
CREATE INDEX idx_purchase_detail_product_id ON purchase_detail (product_id);
CREATE INDEX idx_sale_seller_id ON sale (seller_id);
CREATE INDEX idx_sale_client_id ON sale (client_id);
CREATE INDEX idx_sale_payment_method_id ON sale (payment_method_id);
CREATE INDEX idx_sale_detail_sale_id ON sale_detail (sale_id);
CREATE INDEX idx_sale_detail_product_id ON sale_detail (product_id);
GO


--complementos-- esta desordenado--

SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    d.name AS DefaultConstraintName
FROM 
    sys.default_constraints AS d
JOIN 
    sys.columns AS c
    ON d.parent_column_id = c.column_id
    AND d.parent_object_id = c.object_id
JOIN 
    sys.tables AS t
    ON c.object_id = t.object_id
WHERE 
    c.name = 'active';


-- Eliminar las restricciones predeterminadas existentes
ALTER TABLE category_product
DROP CONSTRAINT DF__category___activ__37A5467C;

ALTER TABLE payment_method
DROP CONSTRAINT DF__payment_m__activ__3A81B327;

ALTER TABLE person
DROP CONSTRAINT DF__person__active__3E52440B;

ALTER TABLE product
DROP CONSTRAINT DF__product__active__440B1D61;

ALTER TABLE supplier
DROP CONSTRAINT DF__supplier__active__49C3F6B7;

ALTER TABLE purchase
DROP CONSTRAINT DF__purchase__active__4F7CD00D;

ALTER TABLE sale
DROP CONSTRAINT DF__sale__active__59FA5E80;


-- Agregar nuevas restricciones predeterminadas para cada tabla
ALTER TABLE category_product
ADD CONSTRAINT DF_category_product_active
DEFAULT 'A' FOR active;

ALTER TABLE payment_method
ADD CONSTRAINT DF_payment_method_active
DEFAULT 'A' FOR active;

ALTER TABLE person
ADD CONSTRAINT DF_person_active
DEFAULT 'A' FOR active;

ALTER TABLE product
ADD CONSTRAINT DF_product_active
DEFAULT 'A' FOR active;

ALTER TABLE supplier
ADD CONSTRAINT DF_supplier_active
DEFAULT 'A' FOR active;

ALTER TABLE purchase
ADD CONSTRAINT DF_purchase_active
DEFAULT 'A' FOR active;

ALTER TABLE sale
ADD CONSTRAINT DF_sale_active
DEFAULT 'A' FOR active;


ALTER TABLE category_product DROP CONSTRAINT DF_category_product_active;
ALTER TABLE payment_method DROP CONSTRAINT DF_payment_method_active;




-- Eliminar la restricción CHECK sobre type_document
ALTER TABLE person DROP CONSTRAINT type_document_ck;

-- Eliminar la restricción CHECK sobre email
ALTER TABLE person DROP CONSTRAINT email_ck;


SELECT name
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('purchase') AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('purchase'), 'active', 'ColumnId');

ALTER TABLE purchase DROP CONSTRAINT DF_purchase_active;
ALTER TABLE purchase ALTER COLUMN active CHAR(1);
-- Paso 3: Volver a agregar la restricción de valor predeterminado (si es necesario)
ALTER TABLE purchase ADD CONSTRAINT DF_purchase_active DEFAULT 'A' FOR active;

SELECT 
    name AS ConstraintName
FROM 
    sys.default_constraints
WHERE 
    parent_object_id = OBJECT_ID('purchase') 
    AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('purchase'), 'active', 'ColumnId');


ALTER TABLE purchase DROP CONSTRAINT DF_purchase_active;

SELECT 
    COLUMN_DEFAULT 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'purchase' 
    AND COLUMN_NAME = 'active';



select*from sale_detail;