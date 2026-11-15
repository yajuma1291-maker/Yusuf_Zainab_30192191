# Federal University Lokoja Laboratory Checkout System — SQL queries

## 1. Show related checkout, equipment, laboratory, borrower records (up to 20).

```sql
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
```

| checkout_checkout_id | checkout_checkout_date | equipment_equipment_id | equipment_asset_tag | laboratory_lab_id | laboratory_lab_name | borrower_borrower_id | borrower_department |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 2026-03-01 | 201 | EQ-001 | 101 | North Science Lab | 301 | Biology |
| 402 | 2026-03-02 | 202 | EQ-002 | 102 | South Science Lab | 302 | Chemistry |

## 2. Find checkout records where due_date matches "2026-03-10" (up to 20).

```sql
SELECT * FROM portfolio."checkout"
WHERE "due_date" IS NOT DISTINCT FROM '2026-03-10'
ORDER BY "checkout_id"
LIMIT 20;
```

| checkout_id | equipment_id | borrower_id | checkout_date | due_date | returned_at |
| --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | 2026-03-01 | 2026-03-10 | NULL |

## 3. Count checkout records for each equipment_id (up to 20 groups).

```sql
SELECT "equipment_id", count(*) AS record_count
FROM portfolio."checkout"
GROUP BY "equipment_id"
ORDER BY record_count DESC, "equipment_id" NULLS LAST
LIMIT 20;
```

| equipment_id | record_count |
| --- | --- |
| 201 | 1 |
| 202 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.973 | 0.973, 1.232, 0.827 | Sort → Seq Scan | 112 |
| After index | 0.167 | 0.195, 0.167, 0.164 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.973 ms to 0.167 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.944..0.946 rows=20 loops=1)
  Seq Scan on checkout (actual time=0.015..0.909 rows=20 loops=1)
Planning Time: 0.348 ms
Execution Time: 0.973 ms
```

### Before index, run 2

```text
Sort (actual time=1.193..1.196 rows=20 loops=1)
  Seq Scan on checkout (actual time=0.014..1.159 rows=20 loops=1)
Planning Time: 0.319 ms
Execution Time: 1.232 ms
```

### Before index, run 3

```text
Sort (actual time=0.802..0.804 rows=20 loops=1)
  Seq Scan on checkout (actual time=0.015..0.755 rows=20 loops=1)
Planning Time: 0.304 ms
Execution Time: 0.827 ms
```

### After index, run 1

```text
Sort (actual time=0.112..0.114 rows=20 loops=1)
  Bitmap Heap Scan on checkout (actual time=0.028..0.078 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.503 ms
Execution Time: 0.195 ms
```

### After index, run 2

```text
Sort (actual time=0.116..0.118 rows=20 loops=1)
  Bitmap Heap Scan on checkout (actual time=0.028..0.082 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.51 ms
Execution Time: 0.167 ms
```

### After index, run 3

```text
Sort (actual time=0.114..0.115 rows=20 loops=1)
  Bitmap Heap Scan on checkout (actual time=0.027..0.08 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.524 ms
Execution Time: 0.164 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Yusuf_Zainab_30192191_P2_Queries.sql, then Yusuf_Zainab_30192191_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Yusuf_Zainab_30192191_P2_QueryResults.png) · [Index comparison](screenshots/Yusuf_Zainab_30192191_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

