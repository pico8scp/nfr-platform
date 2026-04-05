USE nfr_platform;

INSERT INTO users (email, username, password_hash, user_type) VALUES
('admin@nfr.com', 'Admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyDAj0tBTcPj7u', 'admin');

INSERT INTO categories (name, parent_id, level, sort_order) VALUES
('Women', NULL, 1, 1), ('Men', NULL, 1, 2), ('Kids', NULL, 1, 3), ('Beauty', NULL, 1, 4),
('Electronics', NULL, 1, 5), ('Home', NULL, 1, 6), ('Sports', NULL, 1, 7), ('Jewellery', NULL, 1, 8),
('Shoes', NULL, 1, 9), ('Bags', NULL, 1, 10);

INSERT INTO categories (name, parent_id, level, sort_order) VALUES
('Dresses', 1, 2, 1), ('Tops', 1, 2, 2), ('Pants', 1, 2, 3), ('Skirts', 1, 2, 4),
('T-Shirts', 2, 2, 1), ('Pants_Men', 2, 2, 2), ('Jackets', 2, 2, 3),
('Girls', 3, 2, 1), ('Boys', 3, 2, 2), ('Baby', 3, 2, 3),
('Audio', 5, 2, 1), ('Wearables', 5, 2, 2), ('Accessories', 5, 2, 3),
('Decor', 6, 2, 1), ('Kitchen', 6, 2, 2), ('Bedding', 6, 2, 3);

INSERT INTO products (category_id, name, description, retail_price, b2b_price, rating, sales_count, is_active) VALUES
(1, 'Women Boho Floral Maxi Dress — Summer Beach Casual Sundress', 'Beautiful bohemian style maxi dress perfect for summer beach days.', 12.99, 8.50, 4.80, 12500, TRUE),
(1, 'Women Summer T-Shirt — Oversized Cotton Loose Streetwear Graphic', 'Comfortable oversized t-shirt made from 100% organic cotton.', 9.99, 6.20, 4.50, 7800, TRUE),
(1, 'Women Platform Sneakers — Comfort Walking Shoes Casual Trendy', 'Trendy platform sneakers with comfortable cushioned sole.', 22.99, 15.00, 4.30, 3400, TRUE),
(1, 'Silk Hair Scrunchies — 12 Pack Mulberry Silk Scrunchie Set', 'Premium mulberry silk scrunchies that are gentle on hair.', 7.99, 4.50, 4.40, 6700, TRUE),
(1, 'Cotton Bikini Set Women — Lace Trim Swimwear Summer Beach', 'Beautiful lace trim bikini set for the beach or pool.', 10.99, 7.00, 4.30, 11200, TRUE),
(2, "Men's Athletic Joggers — Quick-Dry Sports Running Pants Harem", 'Athletic joggers with quick-dry technology.', 15.99, 10.50, 4.60, 8900, TRUE),
(2, 'Men Casual Shorts — Lightweight Athletic Running Gym Summer', 'Lightweight casual shorts with breathable fabric.', 11.99, 7.80, 4.40, 5600, TRUE),
(3, 'Kids Unisex Pajama Set — Soft Cotton Sleepwear 2pc Newborn', 'Super soft cotton pajama set for newborns.', 8.99, 5.50, 4.90, 21000, TRUE),
(3, 'Organic Cotton Baby Onesies — 5 Pack Newborn Romper Set Gift', 'Organic cotton onesies in a convenient 5-pack.', 12.99, 8.00, 4.80, 45000, TRUE),
(4, 'Gold Plated Jewelry Set — Necklace + Earrings + Bracelet Party', 'Elegant gold plated jewelry set.', 6.99, 4.00, 4.50, 48000, TRUE),
(4, 'Aromatherapy Candles Set — 6pcs Natural Soy Wax Scented Relax', 'Natural soy wax candles with relaxing scents.', 13.99, 9.00, 4.90, 34500, TRUE),
(5, 'TWS Bluetooth Earbuds — Active Noise Cancelling 5.3 Wireless', 'True wireless earbuds with active noise cancelling.', 18.99, 12.00, 4.70, 56000, TRUE),
(5, 'LED Ring Light 10" — Tripod Stand Selfie Live Stream Kit', 'Professional LED ring light with tripod stand.', 16.99, 11.00, 4.60, 12300, TRUE),
(5, 'Mini Projector — 1080P Portable Home Cinema Outdoor Movie', 'Portable mini projector supporting 1080P resolution.', 49.99, 35.00, 4.80, 23400, TRUE),
(6, 'Home Decor LED String Lights — Warm White 10m Waterproof', 'Warm white LED string lights, 10 meters long.', 5.99, 3.50, 4.40, 89000, TRUE),
(6, 'Waterproof Makeup Bag — Large Capacity Travel Organizer Cosmetic', 'Large capacity waterproof makeup bag.', 8.99, 5.50, 4.70, 8900, TRUE),
(7, 'Sports Yoga Mat — Non-Slip Exercise Mat 6mm Thick Fitness', 'Non-slip yoga mat with 6mm thickness.', 9.99, 6.00, 4.70, 32000, TRUE),
(7, 'Resistance Bands Set — 5 Levels Home Workout Fitness Elastic', 'Set of 5 resistance bands.', 7.99, 4.80, 4.60, 45000, TRUE),
(8, 'Portable Blender USB Rechargeable — 380ml Travel Blender Smoothie', 'Portable USB rechargeable blender.', 14.99, 9.50, 4.50, 21000, TRUE),
(8, 'Wireless Charging Pad — Fast Charge 15W Qi Compatible Phone', 'Fast wireless charging pad with 15W output.', 11.99, 7.50, 4.60, 18000, TRUE);

INSERT INTO product_images (product_id, image_url, is_primary, sort_order) VALUES
(1, 'https://picsum.photos/seed/shein1/400/480', TRUE, 1),
(2, 'https://picsum.photos/seed/shein13/400/480', TRUE, 1),
(3, 'https://picsum.photos/seed/shein5/400/480', TRUE, 1),
(4, 'https://picsum.photos/seed/shein11/400/480', TRUE, 1),
(5, 'https://picsum.photos/seed/shein18/400/480', TRUE, 1),
(6, 'https://picsum.photos/seed/shein2/400/480', TRUE, 1),
(7, 'https://picsum.photos/seed/shein16/400/480', TRUE, 1),
(8, 'https://picsum.photos/seed/shein3/400/480', TRUE, 1),
(9, 'https://picsum.photos/seed/shein10/400/480', TRUE, 1),
(10, 'https://picsum.photos/seed/shein6/400/480', TRUE, 1),
(11, 'https://picsum.photos/seed/shein20/400/480', TRUE, 1),
(12, 'https://picsum.photos/seed/shein4/400/480', TRUE, 1),
(13, 'https://picsum.photos/seed/shein14/400/480', TRUE, 1),
(14, 'https://picsum.photos/seed/shein17/400/480', TRUE, 1),
(15, 'https://picsum.photos/seed/shein7/400/480', TRUE, 1),
(16, 'https://picsum.photos/seed/shein15/400/480', TRUE, 1),
(17, 'https://picsum.photos/seed/shein8/400/480', TRUE, 1),
(18, 'https://picsum.photos/seed/shein19/400/480', TRUE, 1),
(19, 'https://picsum.photos/seed/shein12/400/480', TRUE, 1),
(20, 'https://picsum.photos/seed/shein9/400/480', TRUE, 1);

INSERT INTO product_variants (product_id, sku, variant_name, retail_price, b2b_price, stock) VALUES
(1, 'D001-S', 'Dress / S', 12.99, 8.50, 500), (1, 'D001-M', 'Dress / M', 12.99, 8.50, 800),
(1, 'D001-L', 'Dress / L', 12.99, 8.50, 600), (1, 'D001-XL', 'Dress / XL', 13.99, 9.00, 300),
(2, 'TS01-S', 'T-Shirt / S', 9.99, 6.20, 1000), (2, 'TS01-M', 'T-Shirt / M', 9.99, 6.20, 1500),
(2, 'TS01-L', 'T-Shirt / L', 9.99, 6.20, 1200), (2, 'TS01-XL', 'T-Shirt / XL', 10.99, 6.80, 700),
(3, 'SN01-37', 'Sneakers / 37', 22.99, 15.00, 200), (3, 'SN01-38', 'Sneakers / 38', 22.99, 15.00, 300),
(3, 'SN01-39', 'Sneakers / 39', 22.99, 15.00, 400), (3, 'SN01-40', 'Sneakers / 40', 22.99, 15.00, 350),
(6, 'JP01-S', 'Joggers / S', 15.99, 10.50, 600), (6, 'JP01-M', 'Joggers / M', 15.99, 10.50, 900),
(6, 'JP01-L', 'Joggers / L', 15.99, 10.50, 700),
(8, 'PJ01-2T', 'Pajamas / 2T', 8.99, 5.50, 500), (8, 'PJ01-3T', 'Pajamas / 3T', 8.99, 5.50, 600),
(8, 'PJ01-4T', 'Pajamas / 4T', 8.99, 5.50, 400),
(12, 'EB01-W', 'Earbuds / White', 18.99, 12.00, 2000), (12, 'EB01-B', 'Earbuds / Black', 18.99, 12.00, 2000),
(17, 'YM01-G', 'Yoga Mat / Green', 9.99, 6.00, 3000), (17, 'YM01-B', 'Yoga Mat / Blue', 9.99, 6.00, 3000),
(17, 'YM01-P', 'Yoga Mat / Pink', 9.99, 6.00, 2000),
(19, 'BL01-W', 'Blender / White', 14.99, 9.50, 1500), (19, 'BL01-B', 'Blender / Black', 14.99, 9.50, 1500),
(20, 'WC01-B', 'Charger / Black', 11.99, 7.50, 2500), (20, 'WC01-W', 'Charger / White', 11.99, 7.50, 2500);

INSERT INTO product_attributes (product_id, attr_name, attr_value) VALUES
(1, 'Material', 'Polyester'), (1, 'Material', 'Cotton Blend'), (1, 'Style', 'Bohemian'), (1, 'Size', 'S'), (1, 'Size', 'M'), (1, 'Size', 'L'), (1, 'Size', 'XL'),
(2, 'Material', 'Cotton'), (2, 'Style', 'Oversized'), (2, 'Size', 'S'), (2, 'Size', 'M'), (2, 'Size', 'L'), (2, 'Size', 'XL'),
(3, 'Material', 'Leather'), (3, 'Style', 'Platform'), (3, 'Size', '37'), (3, 'Size', '38'), (3, 'Size', '39'), (3, 'Size', '40'),
(4, 'Material', 'Silk'), (4, 'Color', 'Multicolor'), (4, 'Quantity', '12 Pack'),
(5, 'Material', 'Polyester'), (5, 'Style', 'Bikini Set'),
(6, 'Material', 'Polyester'), (6, 'Style', 'Athletic'), (6, 'Size', 'S'), (6, 'Size', 'M'), (6, 'Size', 'L'),
(7, 'Material', 'Cotton'), (7, 'Style', 'Casual Shorts'),
(8, 'Material', 'Cotton'), (8, 'Style', 'Pajama Set'),
(9, 'Material', 'Organic Cotton'), (9, 'Style', 'Onesies'),
(10, 'Material', 'Gold Plated'), (10, 'Style', 'Jewelry Set'),
(11, 'Material', 'Soy Wax'), (11, 'Style', 'Aromatherapy'),
(12, 'Material', 'Plastic'), (12, 'Color', 'White'), (12, 'Color', 'Black'),
(13, 'Material', 'LED'), (13, 'Size', '10 inch'),
(14, 'Material', 'Plastic'), (14, 'Resolution', '1080P'),
(15, 'Material', 'LED'), (15, 'Length', '10m'), (15, 'Color', 'Warm White'),
(16, 'Material', 'Waterproof Fabric'), (16, 'Style', 'Travel Organizer'),
(17, 'Material', 'TPE'), (17, 'Color', 'Green'), (17, 'Color', 'Blue'), (17, 'Color', 'Pink'),
(18, 'Material', 'Latex'), (18, 'Resistance', '5 Levels'),
(19, 'Material', 'Plastic'), (19, 'Color', 'White'), (19, 'Color', 'Black'),
(20, 'Material', 'ABS'), (20, 'Color', 'Black'), (20, 'Color', 'White');

INSERT INTO activity_types (name, code, description) VALUES
('砍价', 'bargain', 'Bargain price - invite friends to lower the price'),
('限时秒杀', 'flash_sale', 'Limited time flash sale at discounted price'),
('满减', 'full_reduction', 'Spend X get Y off'),
('拼团', 'group_buy', 'Group purchase at lower price');

INSERT INTO activities (activity_type_id, name, start_time, end_time, is_active) VALUES
(1, 'Summer Bargain Sale', '2026-01-01 00:00:00', '2027-12-31 23:59:59', TRUE),
(3, '满50减5', '2026-01-01 00:00:00', '2027-12-31 23:59:59', TRUE),
(4, 'Group Buy - Summer Collection', '2026-01-01 00:00:00', '2027-12-31 23:59:59', TRUE),
(2, 'Weekend Flash Sale', '2026-01-01 00:00:00', '2027-12-31 23:59:59', TRUE);

INSERT INTO product_activity (product_id, activity_id) VALUES
(1, 1), (2, 2), (3, 1), (4, 4), (5, 2), (6, 2), (7, 1), (8, 4), (10, 2), (12, 1), (13, 1), (14, 1), (15, 1), (17, 2), (18, 1), (19, 4), (20, 4);
