# Federal University Lokoja Laboratory Checkout System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| lab_id | equipment records (list) |
| --- | --- |
| 101 | [201] |
| 102 | [202] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| equipment.equipment_id | equipment.lab_id | equipment.asset_tag | laboratory.lab_id | laboratory.lab_name |
| --- | --- | --- | --- | --- |
| 201 | 101 | EQ-001 | 101 | North Science Lab |
| 202 | 102 | EQ-002 | 102 | South Science Lab |

Key: equipment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## equipment_example

| equipment.equipment_id | equipment.lab_id | equipment.asset_tag | laboratory.lab_id | laboratory.lab_name |
| --- | --- | --- | --- | --- |
| 201 | 101 | EQ-001 | 101 | North Science Lab |
| 202 | 102 | EQ-002 | 102 | South Science Lab |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## laboratory

| lab_id | lab_name | building | room |
| --- | --- | --- | --- |
| 101 | North Science Lab | North | L-101 |
| 102 | South Science Lab | South | L-201 |

## equipment

| equipment_id | lab_id | asset_tag | category | acquired_date | in_service |
| --- | --- | --- | --- | --- | --- |
| 201 | 101 | EQ-001 | Microscope | 2024-02-15 | true |
| 202 | 102 | EQ-002 | Centrifuge | 2024-05-20 | true |

## borrower

| borrower_id | department | borrower_role | active |
| --- | --- | --- | --- |
| 301 | Biology | researcher | true |
| 302 | Chemistry | student | true |

## checkout

| checkout_id | equipment_id | borrower_id | checkout_date | due_date | returned_at |
| --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | 2026-03-01 | 2026-03-10 | NULL |
| 402 | 202 | 302 | 2026-03-02 | 2026-03-12 | 2026-03-08T14:30:00+00:00 |

## Dependencies

- laboratory: (lab_id) → lab_name, building, room
- equipment: (equipment_id) → lab_id, asset_tag, category, acquired_date, in_service
- borrower: (borrower_id) → department, borrower_role, active
- checkout: (checkout_id) → equipment_id, borrower_id, checkout_date, due_date, returned_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
