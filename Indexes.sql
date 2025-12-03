-- Indexes para todas as foreign keys, para maior velocidade nos JOINs. As que não estão definidas abaixo, o SGBD já criou automaticamente.
CREATE INDEX idx_fk_id_client ON address_clients(id_client);
CREATE INDEX idx_fk_id_address ON address_clients(id_address);
CREATE INDEX idx_fk_id_client ON client_cards(id_client);
CREATE INDEX idx_fk_id_order ON payments(id_order);
CREATE INDEX idx_fk_id_order ON order_itens(id_order);
CREATE INDEX idx_fk_id_product ON order_itens(id_product);
CREATE INDEX idx_id_client ON evaluations(id_client);
CREATE INDEX idx_id_product ON evaluations(id_product);

-- Indexes FULLTEXT, pois é utilizado para buscas textuais avançadas.
CREATE FULLTEXT INDEX idxfull_name_desc ON products(Product_name, Desc_product);