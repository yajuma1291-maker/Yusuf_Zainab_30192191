# Portfolio 1 — Database Design and Modelling

I organised the data into laboratory, equipment, borrower, checkout. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| laboratory | 2 |
| equipment | 2 |
| borrower | 2 |
| checkout | 2 |

The 12 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Yusuf_Zainab_30192191_P1_Design.md)
- [ER diagram](Yusuf_Zainab_30192191_P1_ERDiagram.md)
- [Normalisation](Yusuf_Zainab_30192191_P1_Normalisation.md)
- [Schema](Yusuf_Zainab_30192191_P1_Schema.sql)
- [Sample data](Yusuf_Zainab_30192191_P1_SampleData.sql)
- [Constraint tests](Yusuf_Zainab_30192191_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Yusuf_Zainab_30192191_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

