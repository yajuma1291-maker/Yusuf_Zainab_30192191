-- A separate performance table using the case's checkout.due_date type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."checkout" AS
SELECT "due_date", 0::bigint AS "lab_row_id" FROM portfolio."checkout" WITH NO DATA;
INSERT INTO query_lab."checkout" ("due_date", "lab_row_id")
SELECT (DATE '2030-01-01' + (g % 1000)::integer), g FROM generate_series(1, 20000) AS g;
ANALYZE query_lab."checkout";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."checkout" USING btree ("due_date");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "due_date"
FROM query_lab."checkout"
WHERE "due_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
