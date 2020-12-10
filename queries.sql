--AWS Real-time analytics

--Create state with Fº and likelihood .
CREATE OR REPLACE STREAM "State_stream" 
            ( 
            "name"     varchar(255), 
            "temp_air"   decimal,
            "humidity_air"  decimal
            );


CREATE OR REPLACE PUMP "State_Pump" AS 
    INSERT INTO "State_stream"
    SELECT STREAM "name", (1.8 * "temp_air" + 32), ("humidity_air" / 100)
    FROM   "SOURCE_SQL_STREAM_001";


CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
            "name"  varchar(255),
            "heat_index" decimal
            );


CREATE OR REPLACE PUMP "Output_Pump" AS 
INSERT INTO "DESTINATION_SQL_STREAM"
SELECT STREAM "name", 
        CASE
            WHEN (1.1 * "temp_air" - 10.3 + 0.047 * "humidity_air") < 80 
            THEN (1.1 * "temp_air" - 10.3 + 0.047 * "humidity_air")
            
            WHEN (80.0 <= "temp_air") AND ("temp_air" <= 112.0) AND ("humidity_air" <= 0.13)
            THEN (
                - 42.379 + 2.04901523 * "temp_air" + 10.14333127 * "humidity_air"
                - 0.22475541 * "temp_air" * "humidity_air" 
                - POWER(6.83783, -3) * POWER("temp_air", 3)
                - POWER(5.481717, -2) * POWER("humidity_air", 2)
                + POWER(1.22874, -5) * POWER("temp_air", 2) * "humidity_air"
                - POWER(8.5282, -4) * "temp_air" * POWER("humidity_air", 2)
                - POWER(1.99, -6) * POWER("temp_air", 2) * POWER("humidity_air", 2)
                ) - (3.25 - 0.25 * "humidity_air") * ((17 - abs("temp_air"-95)) / 17) * 0.5
            
            WHEN (80 <= "temp_air") AND ("temp_air" <= 87) AND "humidity_air" > 0.85
            THEN (
                - 42.379 + 2.04901523 * "temp_air" + 10.14333127 * "humidity_air"
                - 0.22475541 * "temp_air" * "humidity_air" 
                - POWER(6.83783, -3) * POWER("temp_air", 3)
                - POWER(5.481717, -2) * POWER("humidity_air", 2)
                + POWER(1.22874, -5) * POWER("temp_air", 2) * "humidity_air"
                - POWER(8.5282, -4) * "temp_air" * POWER("humidity_air", 2)
                - POWER(1.99, -6) * POWER("temp_air", 2) * POWER("humidity_air", 2)
                ) + (0.02 * ("humidity_air" - 85) * (87 - "temp_air"))
        ELSE (
                - 42.379 + 2.04901523 * "temp_air" + 10.14333127 * "humidity_air"
                - 0.22475541 * "temp_air" * "humidity_air" 
                - POWER(6.83783, -3) * POWER("temp_air", 3)
                - POWER(5.481717, -2) * POWER("humidity_air", 2)
                + POWER(1.22874, -5) * POWER("temp_air", 2) * "humidity_air"
                - POWER(8.5282, -4) * "temp_air" * POWER("humidity_air", 2)
                - POWER(1.99, -6) * POWER("temp_air", 2) * POWER("humidity_air", 2)
                )
        END
FROM "State_stream";
