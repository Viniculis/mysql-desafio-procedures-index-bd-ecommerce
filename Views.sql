CREATE OR REPLACE VIEW vw_all_info_orders AS
	SELECT o.id_order, p.id_Payment, p.Pay_method, p.Cash_payment, p.Installment_payment, p.Payment_price, oi.id_product, oi.Quantity 
    FROM orders o 
    JOIN payments p ON o.id_order = p.id_order
    JOIN order_itens oi ON o.id_order = oi.id_order;