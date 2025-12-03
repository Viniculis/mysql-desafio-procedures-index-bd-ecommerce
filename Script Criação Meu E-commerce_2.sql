SHOW DATABASES;
CREATE DATABASE meu_ecommerce;
USE meu_ecommerce;

CREATE TABLE address(
	id_address INT PRIMARY KEY AUTO_INCREMENT,
    Street VARCHAR(45),
    Complement VARCHAR(25),
    Neighb VARCHAR(20),
    CEP CHAR(8),
    City VARCHAR(20),
    State CHAR(2),
    Country VARCHAR(20),
    CONSTRAINT unique_address_id_address UNIQUE (id_address)
);

CREATE TABLE clients(
	id_client INT PRIMARY KEY AUTO_INCREMENT,
    Fname VARCHAR(15) NOT NULL,
    Mname VARCHAR(5),
    Lname VARCHAR(15) NOT NULL,
    Birthdate DATE NOT NULL,
    Email VARCHAR(45) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Phone_number CHAR(11) NOT NULL,
    Create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_clients_id_client UNIQUE (id_Client),
    CONSTRAINT unique_clients_email UNIQUE (Email),
    CONSTRAINT unique_clients_cpf UNIQUE (CPF)
);

CREATE TABLE address_clients(
	id_client INT,
    id_address INT,
    Address_name VARCHAR(20),
    CONSTRAINT pk_composed_address_clients PRIMARY KEY (id_client, id_address),
    CONSTRAINT fk_addressClients_client_id 
    FOREIGN KEY (id_client) 
    REFERENCES clients(id_client)
    ON DELETE CASCADE,
    CONSTRAINT fk_addressClients_address_id 
    FOREIGN KEY (id_address) 
    REFERENCES address(id_address)
    ON DELETE CASCADE
);

CREATE TABLE client_cards(
	id_card INT AUTO_INCREMENT,
    Card_name VARCHAR(35) NOT NULL,
    Printed_name VARCHAR(35) NOT NULL,
    Expiration_date DATE NOT NULL,
    Security_code CHAR(3) NOT NULL,
    Card_flag VARCHAR(15) NOT NULL,
    Card_type ENUM('Crédito', 'Débito') NOT NULL,
    id_client INT NOT NULL,
    CONSTRAINT unique_clientCards_id_card UNIQUE (id_card),
    CONSTRAINT pk_composed_clients_cards PRIMARY KEY (id_card, id_client),
    CONSTRAINT fk_clientCard_client_id 
    FOREIGN KEY (id_client) 
    REFERENCES clients(id_client)
    ON DELETE CASCADE
);

CREATE TABLE orders(
	id_order INT PRIMARY KEY AUTO_INCREMENT,
    Order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Order_status ENUM('Em Processamento', 'Separando Pedido', 'Preparado para Envio', 'Enviado', 'Entregue', 'Cancelado', 'Em Devolução', 'Devolvido') DEFAULT 'Em Processamento' DEFAULT 'Em Processamento',
    id_client INT,
    CONSTRAINT fk_orders_id_client
    FOREIGN KEY (id_client)
    REFERENCES clients(id_client)
    ON DELETE SET NULL
);

CREATE TABLE payments(
	id_payment INT PRIMARY KEY AUTO_INCREMENT,
    Pay_method ENUM('Cartão Crédito', 'Dois Cartões Crédito', 'Cartão Débito', 'Pix', 'Boleto') NOT NULL,
    Cash_payment BOOLEAN,
    Installment_payment ENUM('1 Parcela', '2 Parcelas', '3 Parcelas', '4 Parcelas', '5 Parcelas', '6 Parcelas', '7 Parcelas', '8 Parcelas', '9 Parcelas', '10 Parcelas', '11 Parcelas', '12 Parcelas'),
    Payment_price DECIMAL(8,2) NOT NULL,
    Payment_day DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_order INT,
    CONSTRAINT unique_payments_id_payment UNIQUE (id_payment),
    CONSTRAINT fk_payments_id_order
    FOREIGN KEY (id_order)
    REFERENCES orders(id_order)
    ON DELETE CASCADE
);

CREATE TABLE card_payment(
	id_card_payment INT PRIMARY KEY AUTO_INCREMENT,
	id_payment INT,
    id_card INT,
    Payment_price DECIMAL(8,2),
    CONSTRAINT fk_cardPayment_id_payment
    FOREIGN KEY (id_payment)
    REFERENCES payments(id_payment)
    ON DELETE CASCADE,
    CONSTRAINT fk_cardPayment_id_card
    FOREIGN KEY (id_card)
    REFERENCES client_cards(id_card)
    ON DELETE SET NULL
);

CREATE TABLE products(
	id_product INT PRIMARY KEY AUTO_INCREMENT,
    Product_name VARCHAR(45) NOT NULL,
	Desc_product VARCHAR(255) NOT NULL,
    Category ENUM('Infantil','Móveis','Eletrônicos','Automovel','Ferramentas','Escritório','Alimento','Casa e Jardim','Decoração','Livros','Música','Instrumentos','Acessórios para Instrumentos','Cuidado Íntimo','Utilidades Dia a Dia','Moda','Casa'),
    Size VARCHAR(45),
    Product_brand VARCHAR(25),
    Content VARCHAR(15),
    CONSTRAINT unique_products_id_product UNIQUE (id_product)
);

CREATE TABLE product_delivery(
	Tracking_code VARCHAR(25) NOT NULL,
    Delivery_time VARCHAR(20),
    Estimated_delivery VARCHAR(20),
    Carrier ENUM('Própria', 'Terceirizada') DEFAULT 'Própria',
    Delivery_status ENUM('Em Processamento', 'Separando Pedido', 'Preparado para Envio', 'Enviado', 'Entregue', 'Cancelado', 'Em Devolução') DEFAULT 'Em Processamento',
	Delivered_date DATE,
    id_order INT,
    CONSTRAINT unique_productDelivery_tracking_code UNIQUE (Tracking_code),
    CONSTRAINT pk_composed_productDelivery PRIMARY KEY (Tracking_code, id_order),
    CONSTRAINT fk_productDelivery_id_order
    FOREIGN KEY (id_order)
    REFERENCES orders(id_order)
);

CREATE TABLE delivery_by_address(
	Tracking_code VARCHAR(25),
    id_address INT,
    Delivery_fee DECIMAL(5,2) NOT NULL,
	Delivery_type ENUM('Padrão', 'Rápida'),
    CONSTRAINT pk_composed_deliveryByAddress PRIMARY KEY (Tracking_code, id_address),
    CONSTRAINT fk_deliveryByAddress_tracking_code
    FOREIGN KEY (Tracking_code)
    REFERENCES product_delivery(Tracking_code),
    CONSTRAINT fk_deliveryByAddress_id_address
    FOREIGN KEY (id_address)
    REFERENCES address(id_address)
);

CREATE TABLE evaluations(
	id_evaluation INT PRIMARY KEY AUTO_INCREMENT,
    Evaluation_title VARCHAR(25),
    Evaluation VARCHAR(255),
    Score ENUM('1', '2', '3', '4', '5'),
    id_client INT,
    id_product INT,
    CONSTRAINT fk_evaluations_id_client
    FOREIGN KEY (id_client)
    REFERENCES clients(id_client)
    ON DELETE CASCADE,
    CONSTRAINT fk_evaluations_id_product
    FOREIGN KEY (id_product)
    REFERENCES products(id_product)
);

CREATE TABLE order_itens(
	id_order INT,
    id_product INT,
    Quantity INT DEFAULT '1',
    CONSTRAINT pk_composed_orderItens PRIMARY KEY (id_order, id_product),
    CONSTRAINT fk_orderItens_id_order
    FOREIGN KEY (id_order)
    REFERENCES orders(id_order)
    ON DELETE CASCADE,
    CONSTRAINT fk_orderItens_id_product
    FOREIGN KEY (id_product)
    REFERENCES products(id_product)
    ON DELETE CASCADE
);

CREATE TABLE stock(
	id_stock INT PRIMARY KEY AUTO_INCREMENT,
    Stock_name VARCHAR(45) NOT NULL,
    Address VARCHAR(150) NOT NULL,
    CONSTRAINT unique_stock_id_stock UNIQUE (id_stock)
);

CREATE TABLE products_by_stock(
	id_stock INT,
    id_product INT,
    Quantity INT,
    Product_value DECIMAL(8,2),
    CONSTRAINT pk_composed_prod_stock PRIMARY KEY (id_stock, id_product),
    CONSTRAINT fk_productsByStock_id_stock
    FOREIGN KEY (id_stock)
    REFERENCES stock(id_stock)
    ON DELETE CASCADE,
    CONSTRAINT fk_productsByStock_id_product
    FOREIGN KEY (id_product)
    REFERENCES products(id_product)
    ON DELETE CASCADE
);

CREATE TABLE suppliers(
	id_supplier INT PRIMARY KEY AUTO_INCREMENT,
    CNPJ VARCHAR(14) NOT NULL,
    Trade_name VARCHAR(35) NOT NULL,
    Address VARCHAR(150) NOT NULL,
    Contact_phone VARCHAR(11) NOT NULL,
    Create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_suppliers_id_supplier UNIQUE (id_supplier),
    CONSTRAINT unique_suppliers_CNPJ UNIQUE (CNPJ)
);

CREATE TABLE supply_batch(
	id_batch INT PRIMARY KEY AUTO_INCREMENT,
    Quantity INT NOT NULL,
    Cost_value DECIMAL(8,2) NOT NULL,
    Delivery_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Manufacture_date DATE,
    id_supplier INT,
    id_product INT,
    id_stock INT,
    CONSTRAINT unique_supplyBatch_id_batch UNIQUE (id_batch),
    CONSTRAINT fk_supplyBatch_id_supplier
    FOREIGN KEY (id_supplier)
    REFERENCES suppliers(id_supplier)
    ON DELETE SET NULL,
    CONSTRAINT fk_supplyBatch_id_product
    FOREIGN KEY (id_product)
    REFERENCES products(id_product),
    CONSTRAINT fk_supplyBatch_id_stock
    FOREIGN KEY (id_stock)
    REFERENCES stock(id_stock)
);

CREATE TABLE third_party_seller(
	id_third_seller INT PRIMARY KEY AUTO_INCREMENT,
    Trade_name VARCHAR(35) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    Address VARCHAR(60) NOT NULL,
    Create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Email VARCHAR(45) NOT NULL,
    CONSTRAINT unique_thirdSeller_id_third_seller UNIQUE (id_third_seller),
    CONSTRAINT unique_thirdSeller_CNPJ UNIQUE (CNPJ)
);

CREATE TABLE third_seller_stock(
	id_third_seller INT,
    id_product INT,
    Product_value DECIMAL(8,2) NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT pk_composed_thirdSellerStock PRIMARY KEY (id_third_seller, id_product),
    CONSTRAINT fk_thirdSellerStock_id_third_seller
    FOREIGN KEY (id_third_seller)
    REFERENCES third_party_seller(id_third_seller)
    ON DELETE CASCADE,
    CONSTRAINT fk_thirdSellerStock_id_product
    FOREIGN KEY (id_product)
    REFERENCES products(id_product)
    ON DELETE CASCADE
);

CREATE TABLE third_order_itens(
	id_product INT,
    id_order INT,
    Quantity INT DEFAULT '1',
    CONSTRAINT pk_composed_thirdOrderItens PRIMARY KEY (id_product, id_order),
    CONSTRAINT fk_thirdOrderItens_id_product
    FOREIGN KEY (id_product)
    REFERENCES products(id_product),
    CONSTRAINT fk_thirdOrderItens_id_order
    FOREIGN KEY (id_order)
    REFERENCES orders(id_order)
    ON DELETE CASCADE
);

SHOW TABLES;