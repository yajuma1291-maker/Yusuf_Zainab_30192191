-- Fictional sample records for Federal University Lokoja Laboratory Checkout System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."laboratory" ("lab_id", "lab_name", "building", "room") VALUES (101, 'North Science Lab', 'North', 'L-101');
INSERT INTO portfolio."laboratory" ("lab_id", "lab_name", "building", "room") VALUES (102, 'South Science Lab', 'South', 'L-201');
INSERT INTO portfolio."borrower" ("borrower_id", "department", "borrower_role", "active") VALUES (301, 'Biology', 'researcher', TRUE);
INSERT INTO portfolio."borrower" ("borrower_id", "department", "borrower_role", "active") VALUES (302, 'Chemistry', 'student', TRUE);
INSERT INTO portfolio."equipment" ("equipment_id", "lab_id", "asset_tag", "category", "acquired_date", "in_service") VALUES (201, 101, 'EQ-001', 'Microscope', '2024-02-15', TRUE);
INSERT INTO portfolio."equipment" ("equipment_id", "lab_id", "asset_tag", "category", "acquired_date", "in_service") VALUES (202, 102, 'EQ-002', 'Centrifuge', '2024-05-20', TRUE);
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at") VALUES (401, 201, 301, '2026-03-01', '2026-03-10', NULL);
INSERT INTO portfolio."checkout" ("checkout_id", "equipment_id", "borrower_id", "checkout_date", "due_date", "returned_at") VALUES (402, 202, 302, '2026-03-02', '2026-03-12', '2026-03-08T14:30:00Z');
COMMIT;
