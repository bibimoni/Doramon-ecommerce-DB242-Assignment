USE shopee;

# Khoa ngoai cua address
ALTER TABLE Address
ADD CONSTRAINT fk_addr_username FOREIGN KEY (username) REFERENCES Person(username);

# Khoa ngoai cua banking account
ALTER TABLE Banking_account
ADD CONSTRAINT fk_bank_username FOREIGN KEY (username) REFERENCES Person(username);

# Khoai ngoai cua SOCIAL
ALTER TABLE Social
ADD CONSTRAINT fk_social_username FOREIGN KEY (username) REFERENCES Person(username);

# Khoa ngoai...
ALTER TABLE Sending_message
ADD CONSTRAINT fk_social_snd FOREIGN KEY (snd_username) REFERENCES Person(username);
ALTER TABLE Sending_message
ADD CONSTRAINT fk_social_recv FOREIGN KEY (recv_username) REFERENCES Person(username);

# Khoa ngoai...
ALTER TABLE Buyer
ADD CONSTRAINT fk_buyer_username FOREIGN KEY (username) REFERENCES Person(username);

# Khoa ngoai...
ALTER TABLE Seller
ADD CONSTRAINT fk_seller_username FOREIGN KEY (username) REFERENCES Person(username);
ALTER TABLE Seller
ADD CONSTRAINT fk_seller_bid FOREIGN KEY (business_id) REFERENCES Shop(business_id);

# Khoa ngoai...
ALTER TABLE Admin
ADD CONSTRAINT fk_admin_username FOREIGN KEY (username) REFERENCES Person(username);

# Khoa ngoai...
ALTER TABLE Voucher
ADD CONSTRAINT fk_voucher_sellusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);

# Khoa ngoai...
ALTER TABLE Comment
ADD CONSTRAINT fk_cmt_sellusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);
ALTER TABLE Comment
ADD CONSTRAINT fk_cmt_buyusr FOREIGN KEY (buyer_usr) REFERENCES Buyer(username);
ALTER TABLE Comment
ADD CONSTRAINT fk_cmt_prod FOREIGN KEY (product_id) REFERENCES Product(product_id);

# Khoa ngoai...
ALTER TABLE Product
ADD CONSTRAINT fk_prod_bid FOREIGN KEY (business_id) REFERENCES Shop(business_id);
ALTER TABLE Product
ADD CONSTRAINT fk_prod_admusr FOREIGN KEY (admin_usr) REFERENCES Admin(username);

# Khoa ngoai...
ALTER TABLE Product_attachments
ADD CONSTRAINT fk_prodattch FOREIGN KEY (product_id) REFERENCES Product(product_id);

# Khoa ngoai...
ALTER TABLE Variation
ADD CONSTRAINT fk_variation_prod FOREIGN KEY (product_id) REFERENCES Product(product_id);

# Khoa ngoai
ALTER TABLE Info_variation
ADD CONSTRAINT fk_infovar_pvid FOREIGN KEY (product_id, variation_id) REFERENCES Variation(product_id, variation_id);

# Khoa ngoai
ALTER TABLE `Order`
ADD CONSTRAINT fk_order_buyusr FOREIGN KEY (buyer_usr) REFERENCES Buyer(username);
ALTER TABLE `Order`
ADD CONSTRAINT fk_order_delivery FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id);
# tham chieu den dia chi cua shop
# ALTER TABLE `Order`
# ADD CONSTRAINT fk_order_shopaddr FOREIGN KEY (shop_addr) REFERENCES Shop(address);

# ...
ALTER TABLE Transaction
ADD CONSTRAINT fk_trans_buyusr FOREIGN KEY (buyer_usr) REFERENCES Buyer(username);
ALTER TABLE Transaction
ADD CONSTRAINT fk_trans_sellusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);
ALTER TABLE Transaction
ADD CONSTRAINT fl_trans_order FOREIGN KEY (order_id) REFERENCES `Order`(order_id);

# ...
ALTER TABLE Cart
ADD CONSTRAINT fk_cart_sellusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);


# ...
ALTER TABLE Create_voucher
ADD CONSTRAINT fk_cvoucher_admusr FOREIGN KEY (admin_usr) REFERENCES Admin(username);
ALTER TABLE Create_voucher
ADD CONSTRAINT fk_cvoucher_vid FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id);

#
ALTER TABLE Voucher_category
ADD CONSTRAINT fk_vcategory_vid FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id);

#
ALTER TABLE Use_voucher
ADD CONSTRAINT fk_uvoucher_vid FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id);
ALTER TABLE Use_voucher
ADD CONSTRAINT fk_uvoucher_sellusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);

#
ALTER TABLE Report
ADD CONSTRAINT fk_report_sellusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);
ALTER TABLE Report
ADD CONSTRAINT fk_report_bid FOREIGN KEY (business_id) REFERENCES Shop(business_id);

#
ALTER TABLE Ban_buyer
ADD CONSTRAINT fk_banbuy_buyusr FOREIGN KEY (buyer_usr) REFERENCES Buyer(username);
ALTER TABLE Ban_buyer
ADD CONSTRAINT fk_banbuy_admusr FOREIGN KEY (admin_usr) REFERENCES Admin(username);

#
ALTER TABLE Ban_seller
ADD CONSTRAINT fk_bansell_buyusr FOREIGN KEY (seller_usr) REFERENCES Seller(username);
ALTER TABLE Ban_seller
ADD CONSTRAINT fk_bansell_admusr FOREIGN KEY (admin_usr) REFERENCES Admin(username);

#
ALTER TABLE Cart_has_variations
ADD CONSTRAINT fk_cartvar_cid FOREIGN KEY (cart_id) REFERENCES Cart(cart_id);
ALTER TABLE Cart_has_variations
ADD CONSTRAINT fk_cartvar_pid FOREIGN KEY (product_id) REFERENCES Product(product_id);
ALTER TABLE Cart_has_variations
ADD CONSTRAINT fk_cartvar_vid FOREIGN KEY (variation_id) REFERENCES Variation(variation_id);

#
ALTER TABLE Apply_voucher
ADD CONSTRAINT fk_avoucher_vid FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id);
ALTER TABLE Apply_voucher
ADD CONSTRAINT fk_avoucher_oid FOREIGN KEY (order_id) REFERENCES `Order`(order_id);

#
ALTER TABLE Order_has_variations
ADD CONSTRAINT fk_ordvar_pid FOREIGN KEY (product_id) REFERENCES Product(product_id);
ALTER TABLE Order_has_variations
ADD CONSTRAINT fk_ordvar_vid FOREIGN KEY (variation_id) REFERENCES Variation(variation_id);
ALTER TABLE Order_has_variations
ADD CONSTRAINT fk_ordvar_oid FOREIGN KEY (order_id) REFERENCES `Order`(order_id);
