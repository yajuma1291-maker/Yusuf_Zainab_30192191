# Federal University Lokoja Laboratory Checkout System — database design

My case study records laboratory, equipment, borrower, checkout.

## Users

- Laboratory staff managing equipment and checkout records
- Borrowers checking out and returning laboratory equipment

## Main operations

- Register equipment in a laboratory and record its category and service status
- Record equipment checkout and return dates for a borrower
- Find overdue active checkouts and summarize checkout activity by laboratory
- Benchmark a due-date filter separately using generated synthetic checkout rows

## Entities

| Entity | Information stored |
| --- | --- |
| laboratory | Stores a laboratory location used to organize equipment. |
| equipment | Stores laboratory equipment and its current service status. |
| borrower | Stores synthetic borrower keys and minimal non-identifying affiliation details. |
| checkout | Records equipment checkout, due, and return dates. |

## laboratory

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| lab_id | BIGINT | PK | Yes |
| lab_name | TEXT |  | Yes |
| building | TEXT |  | Yes |
| room | TEXT |  | Yes |
- Unique key: (building, room).

## equipment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| equipment_id | BIGINT | PK | Yes |
| lab_id | BIGINT | FK | Yes |
| asset_tag | TEXT | Unique | Yes |
| category | TEXT |  | Yes |
| acquired_date | DATE |  | Yes |
| in_service | BOOLEAN |  | Yes |
- lab_id → laboratory.lab_id
- Unique key: (asset_tag).

## borrower

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| borrower_id | BIGINT | PK | Yes |
| department | TEXT |  | Yes |
| borrower_role | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |


## checkout

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| checkout_id | BIGINT | PK | Yes |
| equipment_id | BIGINT | FK | Yes |
| borrower_id | BIGINT | FK | Yes |
| checkout_date | DATE |  | Yes |
| due_date | DATE |  | Yes |
| returned_at | TIMESTAMPTZ |  | No |
- equipment_id → equipment.equipment_id
- borrower_id → borrower.borrower_id

## Relationships and business rules

- A building and room combination identifies at most one laboratory.
- Each equipment asset tag is unique.
- A checkout due date must be on or after its checkout date, enforced with a row CHECK.
- At most one checkout per equipment_id may have returned_at null, enforced by a partial UNIQUE constraint on equipment_id for active checkouts.
- Every checkout equipment_id must reference an existing equipment row.
- Every checkout borrower_id must reference an existing borrower row.

## Assumptions

- All records and benchmark rows are synthetic; borrower records contain no names or student identifiers.
- A checkout is active exactly when returned_at is null; due_date is inclusive for determining whether a checkout is overdue.
- Each equipment item belongs to one laboratory, and each checkout refers to one equipment item and one borrower.
- Worked normalisation example: begin with an equipment record that repeats laboratory name, building, and room. Keep lab_id in equipment and store the laboratory attributes once in laboratory; equipment is the root entity and laboratory is its single ancestor in this example.

