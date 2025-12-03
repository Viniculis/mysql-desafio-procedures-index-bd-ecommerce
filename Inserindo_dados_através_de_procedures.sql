-- Atualizando as tabelas do processo de criação de orders através de procedures
CALL process_orders_data(3, 'Cartão Crédito', 0, '4 Parcelas', 5, 2);
CALL insert_card_payment_data(15, 3);
-- ------------------------------------------------------------------------------

SELECT * 
FROM vw_all_info_orders
ORDER BY id_order;