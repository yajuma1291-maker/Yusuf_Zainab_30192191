-- Show related checkout, equipment, laboratory, borrower records (up to 20).
SELECT t0."checkout_id" AS "checkout_checkout_id",
       t0."checkout_date" AS "checkout_checkout_date",
       t1."equipment_id" AS "equipment_equipment_id",
       t1."asset_tag" AS "equipment_asset_tag",
       t2."lab_id" AS "laboratory_lab_id",
       t2."lab_name" AS "laboratory_lab_name",
       t3."borrower_id" AS "borrower_borrower_id",
       t3."department" AS "borrower_department"
FROM portfolio."checkout" t0
JOIN portfolio."equipment" t1 ON t0."equipment_id" = t1."equipment_id"
JOIN portfolio."laboratory" t2 ON t1."lab_id" = t2."lab_id"
JOIN portfolio."borrower" t3 ON t0."borrower_id" = t3."borrower_id"
ORDER BY t0."checkout_id", t1."equipment_id", t2."lab_id", t3."borrower_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."checkout_id" AS "checkout_checkout_id",
       t0."checkout_date" AS "checkout_checkout_date",
       t1."equipment_id" AS "equipment_equipment_id",
       t1."asset_tag" AS "equipment_asset_tag",
       t2."lab_id" AS "laboratory_lab_id",
       t2."lab_name" AS "laboratory_lab_name",
       t3."borrower_id" AS "borrower_borrower_id",
       t3."department" AS "borrower_department"
FROM portfolio."checkout" t0
JOIN portfolio."equipment" t1 ON t0."equipment_id" = t1."equipment_id"
JOIN portfolio."laboratory" t2 ON t1."lab_id" = t2."lab_id"
JOIN portfolio."borrower" t3 ON t0."borrower_id" = t3."borrower_id"
ORDER BY t0."checkout_id", t1."equipment_id", t2."lab_id", t3."borrower_id"
LIMIT 20;

-- Find checkout records where due_date matches "2026-03-10" (up to 20).
SELECT * FROM portfolio."checkout"
WHERE "due_date" IS NOT DISTINCT FROM '2026-03-10'
ORDER BY "checkout_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."checkout"
WHERE "due_date" IS NOT DISTINCT FROM '2026-03-10'
ORDER BY "checkout_id"
LIMIT 20;

-- Count checkout records for each equipment_id (up to 20 groups).
SELECT "equipment_id", count(*) AS record_count
FROM portfolio."checkout"
GROUP BY "equipment_id"
ORDER BY record_count DESC, "equipment_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "equipment_id", count(*) AS record_count
FROM portfolio."checkout"
GROUP BY "equipment_id"
ORDER BY record_count DESC, "equipment_id" NULLS LAST
LIMIT 20;
