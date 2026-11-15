// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("checkout_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("checkout_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "checkout_created",
                    "checkout_returned"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "checkout"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "checkout_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("checkout_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "checkout_created",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "checkout",
            "key": {
                "checkout_id": 401
            },
            "snapshot": {
                "checkout_id": 401,
                "equipment_id": 201,
                "borrower_id": 301,
                "checkout_date": "2026-03-01",
                "due_date": "2026-03-10",
                "returned_at": null
            }
        },
        "embedded": {
            "equipment": [
                {
                    "key": {
                        "equipment_id": 201
                    },
                    "snapshot": {
                        "equipment_id": 201,
                        "lab_id": 101,
                        "asset_tag": "EQ-001",
                        "category": "Microscope",
                        "acquired_date": "2024-02-15",
                        "in_service": true
                    },
                    "via": [
                        "checkout.equipment_id → equipment"
                    ]
                }
            ],
            "laboratory": [
                {
                    "key": {
                        "lab_id": 101
                    },
                    "snapshot": {
                        "lab_id": 101,
                        "lab_name": "North Science Lab",
                        "building": "North",
                        "room": "L-101"
                    },
                    "via": [
                        "checkout.equipment_id → equipment.lab_id → laboratory"
                    ]
                }
            ],
            "borrower": [
                {
                    "key": {
                        "borrower_id": 301
                    },
                    "snapshot": {
                        "borrower_id": 301,
                        "department": "Biology",
                        "borrower_role": "researcher",
                        "active": true
                    },
                    "via": [
                        "checkout.borrower_id → borrower"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "checkout_returned",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "checkout",
            "key": {
                "checkout_id": 401
            },
            "snapshot": {
                "checkout_id": 401,
                "equipment_id": 201,
                "borrower_id": 301,
                "checkout_date": "2026-03-01",
                "due_date": "2026-03-10",
                "returned_at": null
            }
        },
        "embedded": {
            "equipment": [
                {
                    "key": {
                        "equipment_id": 201
                    },
                    "snapshot": {
                        "equipment_id": 201,
                        "lab_id": 101,
                        "asset_tag": "EQ-001",
                        "category": "Microscope",
                        "acquired_date": "2024-02-15",
                        "in_service": true
                    },
                    "via": [
                        "checkout.equipment_id → equipment"
                    ]
                }
            ],
            "laboratory": [
                {
                    "key": {
                        "lab_id": 101
                    },
                    "snapshot": {
                        "lab_id": 101,
                        "lab_name": "North Science Lab",
                        "building": "North",
                        "room": "L-101"
                    },
                    "via": [
                        "checkout.equipment_id → equipment.lab_id → laboratory"
                    ]
                }
            ],
            "borrower": [
                {
                    "key": {
                        "borrower_id": 301
                    },
                    "snapshot": {
                        "borrower_id": 301,
                        "department": "Biology",
                        "borrower_role": "researcher",
                        "active": true
                    },
                    "via": [
                        "checkout.borrower_id → borrower"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "condition_note": "illustrative condition_note",
                "damage_note": "illustrative damage_note",
                "calibration_reading": "illustrative calibration_reading"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "checkout_created",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "checkout",
            "key": {
                "checkout_id": 402
            },
            "snapshot": {
                "checkout_id": 402,
                "equipment_id": 202,
                "borrower_id": 302,
                "checkout_date": "2026-03-02",
                "due_date": "2026-03-12",
                "returned_at": "2026-03-08T14:30:00Z"
            }
        },
        "embedded": {
            "equipment": [
                {
                    "key": {
                        "equipment_id": 202
                    },
                    "snapshot": {
                        "equipment_id": 202,
                        "lab_id": 102,
                        "asset_tag": "EQ-002",
                        "category": "Centrifuge",
                        "acquired_date": "2024-05-20",
                        "in_service": true
                    },
                    "via": [
                        "checkout.equipment_id → equipment"
                    ]
                }
            ],
            "laboratory": [
                {
                    "key": {
                        "lab_id": 102
                    },
                    "snapshot": {
                        "lab_id": 102,
                        "lab_name": "South Science Lab",
                        "building": "South",
                        "room": "L-201"
                    },
                    "via": [
                        "checkout.equipment_id → equipment.lab_id → laboratory"
                    ]
                }
            ],
            "borrower": [
                {
                    "key": {
                        "borrower_id": 302
                    },
                    "snapshot": {
                        "borrower_id": 302,
                        "department": "Chemistry",
                        "borrower_role": "student",
                        "active": true
                    },
                    "via": [
                        "checkout.borrower_id → borrower"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "checkout_returned",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "checkout",
            "key": {
                "checkout_id": 402
            },
            "snapshot": {
                "checkout_id": 402,
                "equipment_id": 202,
                "borrower_id": 302,
                "checkout_date": "2026-03-02",
                "due_date": "2026-03-12",
                "returned_at": "2026-03-08T14:30:00Z"
            }
        },
        "embedded": {
            "equipment": [
                {
                    "key": {
                        "equipment_id": 202
                    },
                    "snapshot": {
                        "equipment_id": 202,
                        "lab_id": 102,
                        "asset_tag": "EQ-002",
                        "category": "Centrifuge",
                        "acquired_date": "2024-05-20",
                        "in_service": true
                    },
                    "via": [
                        "checkout.equipment_id → equipment"
                    ]
                }
            ],
            "laboratory": [
                {
                    "key": {
                        "lab_id": 102
                    },
                    "snapshot": {
                        "lab_id": 102,
                        "lab_name": "South Science Lab",
                        "building": "South",
                        "room": "L-201"
                    },
                    "via": [
                        "checkout.equipment_id → equipment.lab_id → laboratory"
                    ]
                }
            ],
            "borrower": [
                {
                    "key": {
                        "borrower_id": 302
                    },
                    "snapshot": {
                        "borrower_id": 302,
                        "department": "Chemistry",
                        "borrower_role": "student",
                        "active": true
                    },
                    "via": [
                        "checkout.borrower_id → borrower"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "condition_note": "illustrative condition_note",
                "damage_note": "illustrative damage_note",
                "calibration_reading": "illustrative calibration_reading"
            }
        }
    }
]));
  await db.getCollection("checkout_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("checkout_events").find({"eventType":"checkout_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("checkout_events").find({"source.key.checkout_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("checkout_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("checkout_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("checkout_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "checkout_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "checkout",
        "key": {
            "checkout_id": 401
        },
        "snapshot": {
            "checkout_id": 401,
            "equipment_id": 201,
            "borrower_id": 301,
            "checkout_date": "2026-03-01",
            "due_date": "2026-03-10",
            "returned_at": null
        }
    },
    "embedded": {
        "equipment": [
            {
                "key": {
                    "equipment_id": 201
                },
                "snapshot": {
                    "equipment_id": 201,
                    "lab_id": 101,
                    "asset_tag": "EQ-001",
                    "category": "Microscope",
                    "acquired_date": "2024-02-15",
                    "in_service": true
                },
                "via": [
                    "checkout.equipment_id → equipment"
                ]
            }
        ],
        "laboratory": [
            {
                "key": {
                    "lab_id": 101
                },
                "snapshot": {
                    "lab_id": 101,
                    "lab_name": "North Science Lab",
                    "building": "North",
                    "room": "L-101"
                },
                "via": [
                    "checkout.equipment_id → equipment.lab_id → laboratory"
                ]
            }
        ],
        "borrower": [
            {
                "key": {
                    "borrower_id": 301
                },
                "snapshot": {
                    "borrower_id": 301,
                    "department": "Biology",
                    "borrower_role": "researcher",
                    "active": true
                },
                "via": [
                    "checkout.borrower_id → borrower"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("checkout_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "checkout_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "checkout",
        "key": {
            "checkout_id": 401
        },
        "snapshot": {
            "checkout_id": 401,
            "equipment_id": 201,
            "borrower_id": 301,
            "checkout_date": "2026-03-01",
            "due_date": "2026-03-10",
            "returned_at": null
        }
    },
    "embedded": {
        "equipment": [
            {
                "key": {
                    "equipment_id": 201
                },
                "snapshot": {
                    "equipment_id": 201,
                    "lab_id": 101,
                    "asset_tag": "EQ-001",
                    "category": "Microscope",
                    "acquired_date": "2024-02-15",
                    "in_service": true
                },
                "via": [
                    "checkout.equipment_id → equipment"
                ]
            }
        ],
        "laboratory": [
            {
                "key": {
                    "lab_id": 101
                },
                "snapshot": {
                    "lab_id": 101,
                    "lab_name": "North Science Lab",
                    "building": "North",
                    "room": "L-101"
                },
                "via": [
                    "checkout.equipment_id → equipment.lab_id → laboratory"
                ]
            }
        ],
        "borrower": [
            {
                "key": {
                    "borrower_id": 301
                },
                "snapshot": {
                    "borrower_id": 301,
                    "department": "Biology",
                    "borrower_role": "researcher",
                    "active": true
                },
                "via": [
                    "checkout.borrower_id → borrower"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("checkout_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
