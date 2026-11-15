-- Federal University Lokoja Laboratory Checkout System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."laboratory" (
  "lab_id" bigint NOT NULL,
  "lab_name" text NOT NULL,
  "building" text NOT NULL,
  "room" text NOT NULL,
  CONSTRAINT "pk_laboratory" PRIMARY KEY ("lab_id"),
  CONSTRAINT "uq_laboratory_0" UNIQUE ("building", "room")
);
CREATE TABLE portfolio."equipment" (
  "equipment_id" bigint NOT NULL,
  "lab_id" bigint NOT NULL,
  "asset_tag" text NOT NULL,
  "category" text NOT NULL,
  "acquired_date" date NOT NULL,
  "in_service" boolean NOT NULL,
  CONSTRAINT "pk_equipment" PRIMARY KEY ("equipment_id"),
  CONSTRAINT "uq_equipment_0" UNIQUE ("asset_tag")
);
CREATE TABLE portfolio."borrower" (
  "borrower_id" bigint NOT NULL,
  "department" text NOT NULL,
  "borrower_role" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_borrower" PRIMARY KEY ("borrower_id")
);
CREATE TABLE portfolio."checkout" (
  "checkout_id" bigint NOT NULL,
  "equipment_id" bigint NOT NULL,
  "borrower_id" bigint NOT NULL,
  "checkout_date" date NOT NULL,
  "due_date" date NOT NULL,
  "returned_at" timestamptz,
  CONSTRAINT "pk_checkout" PRIMARY KEY ("checkout_id")
);
ALTER TABLE portfolio."equipment" ADD CONSTRAINT "fk_equipment_0" FOREIGN KEY ("lab_id") REFERENCES portfolio."laboratory" ("lab_id");
ALTER TABLE portfolio."checkout" ADD CONSTRAINT "fk_checkout_0" FOREIGN KEY ("equipment_id") REFERENCES portfolio."equipment" ("equipment_id");
ALTER TABLE portfolio."checkout" ADD CONSTRAINT "fk_checkout_1" FOREIGN KEY ("borrower_id") REFERENCES portfolio."borrower" ("borrower_id");
ALTER TABLE portfolio."checkout" ADD CONSTRAINT "checkout_dates_valid" CHECK ("due_date" > "checkout_date");
CREATE UNIQUE INDEX "one_active_checkout_per_equipment" ON portfolio."checkout" ("equipment_id") WHERE ("returned_at" IS NULL);
COMMIT;
