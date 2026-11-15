-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. laboratory primary key rejection. Expected: pk_laboratory, SQLSTATE 23505.
INSERT INTO portfolio."laboratory" ("lab_id", "lab_name", "building", "room")
VALUES (101, 'Synthetic Lab', 'West', 'L-301');

-- 2. laboratory unique rejection. Expected: uq_laboratory_0, SQLSTATE 23505.
INSERT INTO portfolio."laboratory" ("lab_id", "lab_name", "building", "room")
VALUES (901, 'Duplicate Location Lab', 'North', 'L-101');

-- 3. equipment primary key rejection. Expected: pk_equipment, SQLSTATE 23505.
INSERT INTO portfolio."equipment" ("equipment_id", "lab_id", "asset_tag", "category", "acquired_date", "in_service")
VALUES (201, 102, 'EQ-101', 'Microscope', '2025-01-15', TRUE);

-- 4. equipment unique rejection. Expected: uq_equipment_0, SQLSTATE 23505.
INSERT INTO portfolio."equipment" ("equipment_id", "lab_id", "asset_tag", "category", "acquired_date", "in_service")
VALUES (902, 101, 'EQ-001', 'Microscope', '2025-01-15', TRUE);

-- 5. equipment foreign key rejection. Expected: fk_equipment_0, SQLSTATE 23503.
INSERT INTO portfolio."equipment" ("equipment_id", "lab_id", "asset_tag", "category", "acquired_date", "in_service")
VALUES (903, 99991, 'EQ-103', 'Microscope', '2025-01-15', TRUE);

-- 6. borrower primary key rejection. Expected: pk_borrower, SQLSTATE 23505.
INSERT INTO portfolio."borrower" ("borrower_id", "department", "borrower_role", "active")
VALUES (301, 'Physics', 'researcher', TRUE);

-- 7. borrower not null rejection. Expected: department, SQLSTATE 23502.
INSERT INTO portfolio."borrower" ("borrower_id", "department", "borrower_role", "active")
VALUES (904, NULL, 'researcher', TRUE);

-- 8. checkout primary key rejection. Expected: pk_checkout, SQLSTATE 23505.
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at")
VALUES (401, 202, 302, '2026-04-01', '2026-04-10', '2026-04-05T12:00:00Z');

-- 9. checkout equipment foreign key rejection. Expected: fk_checkout_0, SQLSTATE 23503.
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at")
VALUES (905, 99992, 301, '2026-04-01', '2026-04-10', '2026-04-05T12:00:00Z');

-- 10. checkout borrower foreign key rejection. Expected: fk_checkout_1, SQLSTATE 23503.
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at")
VALUES (906, 202, 99993, '2026-04-01', '2026-04-10', '2026-04-05T12:00:00Z');

-- 11. checkout date check rejection. Expected: checkout_dates_valid, SQLSTATE 23514.
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at")
VALUES (907, 202, 301, '2026-04-10', '2026-04-09', '2026-04-11T12:00:00Z');

-- 12. active checkout partial unique rejection. Expected: one_active_checkout_per_equipment, SQLSTATE 23505.
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at")
VALUES (908, 201, 302, '2026-04-01', '2026-04-10', NULL);
