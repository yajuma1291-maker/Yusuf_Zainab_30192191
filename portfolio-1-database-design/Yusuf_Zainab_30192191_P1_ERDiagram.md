# Federal University Lokoja Laboratory Checkout System — ER diagram

```mermaid
erDiagram
    direction LR
    laboratory {
        bigint lab_id PK
        text lab_name
        text building
        text room
    }
    equipment {
        bigint equipment_id PK
        bigint lab_id FK
        text asset_tag UK
        text category
        date acquired_date
        boolean in_service
    }
    borrower {
        bigint borrower_id PK
        text department
        text borrower_role
        boolean active
    }
    checkout {
        bigint checkout_id PK
        bigint equipment_id FK
        bigint borrower_id FK
        date checkout_date
        date due_date
        timestamptz returned_at "Optional"
    }
    laboratory ||--o{ equipment : "lab_id"
    equipment ||--o{ checkout : "equipment_id"
    borrower ||--o{ checkout : "borrower_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Yusuf_Zainab_30192191_ERDiagram.png)
