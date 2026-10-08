
-- ============================================================
  
-- NYC 311 Operation Analysis
-- SQLite exploration, cleaning, validation, and transformation into an analytical dataset.

-- ============================================================

-- 1. INITIAL DATA EXPLORATION

-- ============================================================
  
  
-- Total Rows 

SELECT COUNT(*) AS total_rows
FROM nyc_311_raw;


-- Table Struture 

PRAGMA table_info(nyc_311_raw);


-- ============================================================
-- 2. DATA QUALITY AND DUPLICATE INVESTIGATION 
-- ============================================================
  
 -- Duplicated IDs 
 
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "Unique Key") AS unique_requests
FROM nyc_311_raw;


-- Missing Created Date 

SELECT COUNT(*) AS missing_created_date
FROM nyc_311_raw
WHERE "Created Date" IS NULL
   OR TRIM("Created Date") = '';
   
-- Missing Closed Date 

SELECT COUNT (*) AS missing_closed_date
FROM nyc_311_raw
WHERE ("Closed Date") IS NULL
				OR TRIM("Closed Date") = '';
				
				
-- Missing Agency or Problem 	
 

SELECT
    SUM(CASE WHEN "Agency" IS NULL OR TRIM("Agency") = '' THEN 1 ELSE 0 END) AS missing_agency,
    SUM(CASE WHEN "Problem (formerly Complaint Type)" IS NULL OR TRIM("Problem (formerly Complaint Type)") = '' THEN 1 ELSE 0 END) AS missing_problem
FROM nyc_311_raw;


-- Checking Date Range 

SELECT
    MIN("Created Date") AS earliest_created,
    MAX("Created Date") AS latest_created,
    MIN("Closed Date") AS earliest_closed,
    MAX("Closed Date") AS latest_closed
FROM nyc_311_raw;
				

-- Checking the Borough values 
				

SELECT DISTINCT 
   Borough,
   COUNT( "Borough") AS borough_name 
FROM nyc_311_raw
GROUP by "Borough";


SELECT
    Borough,
    COUNT(*) AS request_count
FROM nyc_311_raw
GROUP BY Borough
ORDER BY request_count DESC;


-- ============================================================
-- 3. DATE AND TIME TRANSFORMATION 
--    RESOLUTION TIME AND VALUE
-- ============================================================


-- Resolution time


SELECT
    COUNT(*) AS total_requests,
    SUM(
        CASE
            WHEN julianday("Closed Date") < julianday("Created Date")
            THEN 1
            ELSE 0
        END
    ) AS negative_resolution_time,
    MIN(
        julianday("Closed Date") - julianday("Created Date")
    ) AS min_resolution_days,
    MAX(
        julianday("Closed Date") - julianday("Created Date")
    ) AS max_resolution_days
FROM nyc_311_raw;


SELECT
    "Created Date",
    "Closed Date",
    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) AS created_date_converted
FROM nyc_311_raw
LIMIT 5;


SELECT
    "Created Date",
    "Closed Date",
    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2)  ||' '||
	  substr("Created Date", 12, 11)  AS created_date_converted
FROM nyc_311_raw
LIMIT 5;


--Isolating the hour

SELECT
    "Created Date",
    substr("Created Date", 12, 2) AS hour,
    substr("Created Date", 15, 2) AS minute,
    substr("Created Date", 18, 2) AS second,
    substr("Created Date", 21, 2) AS am_pm
FROM nyc_311_raw
LIMIT 10;



-- Converting to military time

SELECT
    "Created Date",
    substr("Created Date", 12, 2) AS hour,
    substr("Created Date", 15, 2) AS minute,
    substr("Created Date", 18, 2) AS second,
    substr("Created Date", 21, 2) AS am_pm,

    CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END AS hour_24

FROM nyc_311_raw
LIMIT 10 OFFSET 9000;


SELECT
    "Created Date",
    substr("Created Date", 12, 2) AS hour,
    substr("Created Date", 21, 2) AS am_pm,
    CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0
        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12
        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END AS hour_24
FROM nyc_311_raw
WHERE substr("Created Date", 12, 2) = '12'
LIMIT 20 OFFSET 2000;


-- Building the full created_datetime


SELECT
   "Created Date",
    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))
	AS created_datetime

FROM nyc_311_raw
LIMIT 10;



-- Building the full closed_datetime


SELECT
   "Closed Date",
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))
	AS closed_datetime

FROM nyc_311_raw
LIMIT 10;


-- Resolution Time


SELECT
      "Created Date",
	    "Closed Date",

round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2)
AS resolution_hours
FROM nyc_311_raw
LIMIT 10; 



-- Checking the entire dataset


SELECT

    COUNT(*) AS total_requests,
	
	SUM(
	               CASE
	                        WHEN resolution_hours < 0 THEN 1
							ELSE 0
	               END
	           ) AS negative_resolution,
	
	SUM(
	               CASE
	                        WHEN resolution_hours  = 0 THEN 1
							ELSE 0
	               END
	           ) AS zero_resolution,    

    ROUND(MIN(resolution_hours), 2) AS min_resolution_hours,

    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,

    ROUND(MAX(resolution_hours), 2) AS max_resolution_hours
	 
	
FROM (

SELECT
      
round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2)
AS resolution_hours
FROM nyc_311_raw 

) AS resolution_check;



--- Checking the negative_resolution

SELECT
    "Unique Key",
    "Created Date",
    "Closed Date"
FROM nyc_311_raw
WHERE
    round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2) < 0

LIMIT 10;




-- Percentage of negative resolutions compared to the total requests 


SELECT
				
				((SUM(
	               CASE
	                        WHEN  round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2) < 0 THEN 1
							ELSE 0
	               END
	           ) ) *100.0) / COUNT(*)	 AS percentage_of_negative_requests
			   
		   			   			   				
			
FROM nyc_311_raw;				



-- Percentage of zero resolutions compared to the total requests 				


SELECT
				
				((SUM(
	               CASE
	                        WHEN  round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2) =  0 THEN 1
							ELSE 0
	               END
	           ) ) *100.0) / COUNT(*)	 AS percentage_of_zero_requests
			   
			   
FROM nyc_311_raw;				


-- Largest resolution time


SELECT
    "Unique Key",
    "Created Date",
    "Closed Date"
	
FROM nyc_311_raw

ORDER BY 	   

round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2) DESC

LIMIT 10;



-- How many requests were closed on 2026


SELECT
    COUNT (*)

FROM nyc_311_raw

WHERE substr("Closed Date", 7, 4) = '2026';


-- min and max resoution hours in 2026


SELECT
   
MAX( round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2) ) AS  max_resolution_time_closed_in_2026,

MIN(
round((
  (julianday(
 
    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Closed Date", 12, 2) = '12'
             AND substr("Closed Date" ,21, 2) = 'AM'
        THEN 0

        WHEN substr("Closed Date", 12, 2) != '12'
             AND substr("Closed Date" ,21, 2) = 'PM'
        THEN CAST(substr("Closed Date" ,12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Closed Date" ,12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

)
-
julianday(

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) ||' '||
 
  printf(
        '%02d',
  CASE
        WHEN substr("Created Date", 12, 2) = '12'
             AND substr("Created Date", 21, 2) = 'AM'
        THEN 0

        WHEN substr("Created Date", 12, 2) != '12'
             AND substr("Created Date", 21, 2) = 'PM'
        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
    END) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) ||':'||
 printf(
        '%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

)
) * 24), 2)) AS  min_resolution_time_closed_in_2026
   

FROM nyc_311_raw

WHERE substr("Closed Date", 7, 4) = '2026';




-- Creating the cleaned datetime fields


SELECT

    "Unique Key",

    "Created Date",

    substr("Created Date", 7, 4) || '-' ||
    substr("Created Date", 1, 2) || '-' ||
    substr("Created Date", 4, 2) || ' ' ||

    printf(
        '%02d',
        CASE
            WHEN substr("Created Date", 12, 2) = '12'
                 AND substr("Created Date", 21, 2) = 'AM'
            THEN 0

            WHEN substr("Created Date", 12, 2) != '12'
                 AND substr("Created Date", 21, 2) = 'PM'
            THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

            ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
        END
    ) || ':' ||

    printf('%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) || ':' ||

    printf('%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

    AS created_datetime,

    "Closed Date",

    substr("Closed Date", 7, 4) || '-' ||
    substr("Closed Date", 1, 2) || '-' ||
    substr("Closed Date", 4, 2) || ' ' ||

    printf(
        '%02d',
        CASE
            WHEN substr("Closed Date", 12, 2) = '12'
                 AND substr("Closed Date", 21, 2) = 'AM'
            THEN 0

            WHEN substr("Closed Date", 12, 2) != '12'
                 AND substr("Closed Date", 21, 2) = 'PM'
            THEN CAST(substr("Closed Date", 12, 2) AS INTEGER) + 12

            ELSE CAST(substr("Closed Date", 12, 2) AS INTEGER)
        END
    ) || ':' ||

    printf('%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) || ':' ||

    printf('%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))

    AS closed_datetime
	
	
FROM nyc_311_raw

LIMIT 5;




-- Resolution Hours using the aliases



SELECT 

				           "Unique Key",
                  "Created Date",
				           created_datetime,
                   "Closed Date",
                   closed_datetime,
				   
				 round(
				  (julianday(closed_datetime) 
				  -
				  julianday(created_datetime) 
				  ) *24 , 2
				  ) AS resolution_hours

FROM (

				SELECT

								"Unique Key",

								"Created Date",

								substr("Created Date", 7, 4) || '-' ||
								substr("Created Date", 1, 2) || '-' ||
								substr("Created Date", 4, 2) || ' ' ||

								printf(
									'%02d',
									CASE
										WHEN substr("Created Date", 12, 2) = '12'
											 AND substr("Created Date", 21, 2) = 'AM'
										THEN 0

										WHEN substr("Created Date", 12, 2) != '12'
											 AND substr("Created Date", 21, 2) = 'PM'
										THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

										ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
									END
								) || ':' ||

								printf('%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) || ':' ||

								printf('%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

								AS created_datetime,

								"Closed Date",

								substr("Closed Date", 7, 4) || '-' ||
								substr("Closed Date", 1, 2) || '-' ||
								substr("Closed Date", 4, 2) || ' ' ||

								printf(
									'%02d',
									CASE
										WHEN substr("Closed Date", 12, 2) = '12'
											 AND substr("Closed Date", 21, 2) = 'AM'
										THEN 0

										WHEN substr("Closed Date", 12, 2) != '12'
											 AND substr("Closed Date", 21, 2) = 'PM'
										THEN CAST(substr("Closed Date", 12, 2) AS INTEGER) + 12

										ELSE CAST(substr("Closed Date", 12, 2) AS INTEGER)
									END
								) || ':' ||

								printf('%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) || ':' ||

								printf('%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))


                              AS closed_datetime
	
	
                    FROM nyc_311_raw
					)

	LIMIT 5;




	-- Resolution Status
	
	
	
	SELECT 

				   "Unique Key",
           "Created Date",
				    created_datetime,
            "Closed Date",
            closed_datetime,
				    resolution_hours,

				   CASE 
									WHEN resolution_hours < 0  THEN 'Invalid - Closed Before Created'
									ELSE 'Valid'
					END AS resolution_status
									
									
	FROM 
					(SELECT 

				   "Unique Key",
                  "Created Date",
				   created_datetime,
                  "Closed Date",
                   closed_datetime,
				   
				 round(
				  (julianday(closed_datetime) 
				  -
				  julianday(created_datetime) 
				  ) *24 , 2
				  ) AS resolution_hours

					FROM (

									SELECT

													"Unique Key",

													"Created Date",

													substr("Created Date", 7, 4) || '-' ||
													substr("Created Date", 1, 2) || '-' ||
													substr("Created Date", 4, 2) || ' ' ||

													printf(
														'%02d',
														CASE
															WHEN substr("Created Date", 12, 2) = '12'
																 AND substr("Created Date", 21, 2) = 'AM'
															THEN 0

															WHEN substr("Created Date", 12, 2) != '12'
																 AND substr("Created Date", 21, 2) = 'PM'
															THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

															ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
														END
													) || ':' ||

													printf('%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) || ':' ||

													printf('%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))

													AS created_datetime,

													"Closed Date",

													substr("Closed Date", 7, 4) || '-' ||
													substr("Closed Date", 1, 2) || '-' ||
													substr("Closed Date", 4, 2) || ' ' ||

													printf(
														'%02d',
														CASE
															WHEN substr("Closed Date", 12, 2) = '12'
																 AND substr("Closed Date", 21, 2) = 'AM'
															THEN 0

															WHEN substr("Closed Date", 12, 2) != '12'
																 AND substr("Closed Date", 21, 2) = 'PM'
															THEN CAST(substr("Closed Date", 12, 2) AS INTEGER) + 12

															ELSE CAST(substr("Closed Date", 12, 2) AS INTEGER)
														END
													) || ':' ||

													printf('%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) || ':' ||

													printf('%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))


												  AS closed_datetime
						
						
										FROM nyc_311_raw
										))
		LIMIT 5;			
					
					
					
-- Validating the count of resolution status					
					
SELECT
    resolution_status,
    COUNT(*) AS request_count
FROM (
    SELECT
        resolution_hours,

        CASE
            WHEN resolution_hours < 0
                THEN 'Invalid - Closed Before Created'
            ELSE 'Valid'
        END AS resolution_status

    FROM (
        SELECT
            ROUND(
                (
                    julianday(closed_datetime)
                    -
                    julianday(created_datetime)
                ) * 24,
                2
            ) AS resolution_hours

        FROM (
            SELECT

                substr("Created Date", 7, 4) || '-' ||
                substr("Created Date", 1, 2) || '-' ||
                substr("Created Date", 4, 2) || ' ' ||

                printf(
                    '%02d',
                    CASE
                        WHEN substr("Created Date", 12, 2) = '12'
                             AND substr("Created Date", 21, 2) = 'AM'
                        THEN 0

                        WHEN substr("Created Date", 12, 2) != '12'
                             AND substr("Created Date", 21, 2) = 'PM'
                        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

                        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
                    END
                ) || ':' ||

                printf('%02d', CAST(substr("Created Date", 15, 2) AS INTEGER)) || ':' ||
                printf('%02d', CAST(substr("Created Date", 18, 2) AS INTEGER))
                AS created_datetime,

                substr("Closed Date", 7, 4) || '-' ||
                substr("Closed Date", 1, 2) || '-' ||
                substr("Closed Date", 4, 2) || ' ' ||

                printf(
                    '%02d',
                    CASE
                        WHEN substr("Closed Date", 12, 2) = '12'
                             AND substr("Closed Date", 21, 2) = 'AM'
                        THEN 0

                        WHEN substr("Closed Date", 12, 2) != '12'
                             AND substr("Closed Date", 21, 2) = 'PM'
                        THEN CAST(substr("Closed Date", 12, 2) AS INTEGER) + 12

                        ELSE CAST(substr("Closed Date", 12, 2) AS INTEGER)
                    END
                ) || ':' ||

                printf('%02d', CAST(substr("Closed Date", 15, 2) AS INTEGER)) || ':' ||
                printf('%02d', CAST(substr("Closed Date", 18, 2) AS INTEGER))
                AS closed_datetime

            FROM nyc_311_raw
        )
    )
)
GROUP BY resolution_status;					
	

-- ============================================================
-- 4. CREATE CLEAN DATASET
-- ============================================================


-- Creating the clean analytical table 


CREATE TABLE nyc_311_clean AS

SELECT
    "Unique Key" AS unique_key,
    "Created Date" AS created_date,
    created_datetime,
    "Closed Date" AS closed_date,
    closed_datetime,
    "Agency" AS agency,
    "Agency Name" AS agency_name,
    "Problem (formerly Complaint Type)" AS problem,
    "Problem Detail (formerly Descriptor)" AS problem_detail,
    "Location Type" AS location_type,
    "Incident Zip" AS incident_zip,
    "Borough" AS borough,
    "Latitude" AS latitude,
    "Longitude" AS longitude,
    resolution_hours,
    resolution_status

FROM (
    SELECT
        "Unique Key",
        "Created Date",
        created_datetime,
        "Closed Date",
        closed_datetime,
        "Agency",
        "Agency Name",
        "Problem (formerly Complaint Type)",
        "Problem Detail (formerly Descriptor)",
        "Location Type",
        "Incident Zip",
        "Borough",
        "Latitude",
        "Longitude",

        resolution_hours,

        CASE
            WHEN resolution_hours < 0
                THEN 'Invalid - Closed Before Created'
            ELSE 'Valid'
        END AS resolution_status

    FROM (
        SELECT
            "Unique Key",
            "Created Date",
            created_datetime,
            "Closed Date",
            closed_datetime,

            "Agency",
            "Agency Name",
            "Problem (formerly Complaint Type)",
            "Problem Detail (formerly Descriptor)",
            "Location Type",
            "Incident Zip",
            "Borough",
            "Latitude",
            "Longitude",

            ROUND(
                (
                    julianday(closed_datetime)
                    -
                    julianday(created_datetime)
                ) * 24,
                2
            ) AS resolution_hours

        FROM (
            SELECT
                "Unique Key",
                "Created Date",

                substr("Created Date", 7, 4) || '-' ||
                substr("Created Date", 1, 2) || '-' ||
                substr("Created Date", 4, 2) || ' ' ||

                printf(
                    '%02d',
                    CASE
                        WHEN substr("Created Date", 12, 2) = '12'
                             AND substr("Created Date", 21, 2) = 'AM'
                        THEN 0

                        WHEN substr("Created Date", 12, 2) != '12'
                             AND substr("Created Date", 21, 2) = 'PM'
                        THEN CAST(substr("Created Date", 12, 2) AS INTEGER) + 12

                        ELSE CAST(substr("Created Date", 12, 2) AS INTEGER)
                    END
                ) || ':' ||

                printf(
                    '%02d',
                    CAST(substr("Created Date", 15, 2) AS INTEGER)
                ) || ':' ||

                printf(
                    '%02d',
                    CAST(substr("Created Date", 18, 2) AS INTEGER)
                ) AS created_datetime,

                "Closed Date",

                substr("Closed Date", 7, 4) || '-' ||
                substr("Closed Date", 1, 2) || '-' ||
                substr("Closed Date", 4, 2) || ' ' ||

                printf(
                    '%02d',
                    CASE
                        WHEN substr("Closed Date", 12, 2) = '12'
                             AND substr("Closed Date", 21, 2) = 'AM'
                        THEN 0

                        WHEN substr("Closed Date", 12, 2) != '12'
                             AND substr("Closed Date", 21, 2) = 'PM'
                        THEN CAST(substr("Closed Date", 12, 2) AS INTEGER) + 12

                        ELSE CAST(substr("Closed Date", 12, 2) AS INTEGER)
                    END
                ) || ':' ||

                printf(
                    '%02d',
                    CAST(substr("Closed Date", 15, 2) AS INTEGER)
                ) || ':' ||

                printf(
                    '%02d',
                    CAST(substr("Closed Date", 18, 2) AS INTEGER)
                ) AS closed_datetime,

                "Agency",
                "Agency Name",
                "Problem (formerly Complaint Type)",
                "Problem Detail (formerly Descriptor)",
                "Location Type",
                "Incident Zip",
                "Borough",
                "Latitude",
                "Longitude"

            FROM nyc_311_raw
        )
    )
);


-- Validating new table nyc_311_clean 


PRAGMA table_info(nyc_311_clean);


SELECT COUNT(*) AS total_rows
FROM nyc_311_clean;



SELECT
    resolution_status,
    COUNT(*) AS request_count
FROM nyc_311_clean
GROUP BY resolution_status;



SELECT
    COUNT(*) AS total_requests
FROM nyc_311_clean;



SELECT
    borough,
    COUNT(*) AS request_count
FROM nyc_311_clean
GROUP BY borough
ORDER BY request_count DESC;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================
