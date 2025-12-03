DELIMITER \\
CREATE PROCEDURE process_orders_data(
	IN id_client_p INT,
    IN pay_method_p ENUM('Cartão Crédito', 'Dois Cartões Crédito', 'Cartão Débito', 'Pix', 'Boleto'),
    IN Cash_payment_p BOOLEAN,
    IN Installment_payment_p ENUM('1 Parcela', '2 Parcelas', '3 Parcelas', '4 Parcelas', '5 Parcelas', '6 Parcelas', '7 Parcelas', '8 Parcelas', '9 Parcelas', '10 Parcelas', '11 Parcelas', '12 Parcelas'),
    IN id_product_p INT,
    IN Quantity_p INT
)
	BEGIN
		DECLARE Payment_price_p DECIMAL(8,2);
		DECLARE id_order_p INT;
        
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
		END;
		
		START TRANSACTION;
		
			-- Pegando preço
			SELECT Product_value * Quantity_p INTO Payment_price_p
			FROM products_by_stock
			WHERE id_product = id_product_p;
			
			-- Inserindo dados em orders
			INSERT INTO orders(id_client)
			VALUES (id_client_p);
            
			-- Pegando id de orders.
			SET id_order_p = LAST_INSERT_ID();
			
			-- Inserindo dados em payments
			INSERT INTO payments(Pay_method, Cash_payment, Installment_payment, Payment_price, id_order)
			VALUES (Pay_method_p, Cash_payment_p, Installment_payment_p, Payment_price_p, id_order_p);
			
			-- Inserindo dados em order_itens
			INSERT INTO order_itens(id_order, id_product, Quantity)
			VALUES (id_order_p, id_product_p, Quantity_p);
			
			-- Atualizando products_by_stock
			UPDATE products_by_stock
			SET Quantity = Quantity - Quantity_p
			WHERE id_product = id_product_p;
		COMMIT;
	END \\;

DELIMITER ;
-- ---------------------------------------------------------
DELIMITER \\
CREATE PROCEDURE insert_order_data(
	IN id_client_p INT
)
	BEGIN
		INSERT orders(id_client)
        VALUES(id_client_p);
    END;
\\
DELIMITER ;
-- ---------------------------------------------------------
DELIMITER \\
CREATE PROCEDURE insert_payments_data(
	IN Pay_method_p ENUM('Cartão Crédito','Dois Cartões Crédito','Cartão Débito','Pix','Boleto'),
	IN Pay_method_p BOOLEAN,
	IN Installment_payment_p ENUM('1 Parcela','2 Parcelas','3 Parcelas','4 Parcelas','5 Parcelas','6 Parcelas','7 Parcelas','8 Parcelas','9 Parcelas','10 Parcelas','11 Parcelas','12 Parcelas'),
	IN Payment_price_p DECIMAL(8,2),
	IN id_order_p INT
)
	BEGIN
		INSERT payments(Pay_method, Pay_method, Installment_payment, Payment_price ,id_order)
        VALUES (Pay_method_p, Pay_method_p, Installment_payment_p, Payment_price_p, id_order_p);
    END;
\\
DELIMITER ;
-- ---------------------------------------------------------
DELIMITER \\
CREATE PROCEDURE insert_card_payment_data(
	IN id_payment_p INT,
	IN id_card_p INT
)
	BEGIN
        DECLARE Payment_price_p DECIMAL(8,2);
		
        -- Pegando Payment_price
        SELECT Payment_price INTO Payment_price_p
        FROM payments
        WHERE id_payment = id_payment_p;
        
        -- Inserindo na tabela card_payment
        INSERT INTO card_payment(id_payment, id_card, Payment_price)
        VALUES (id_payment_p, id_card_p, Payment_price_p);
        
    END;
\\
DELIMITER ;
-- ---------------------------------------------------------
DELIMITER \\
CREATE PROCEDURE insert_order_itens_data(
	IN id_order_p INT,
    IN id_product_p INT,
    IN Quantity_p INT
)
	BEGIN
		INSERT order_itens(id_order, id_product, Quantity)
        VALUES(id_order_p, id_product_p, Quantity_p);
    END;
\\
DELIMITER ;

