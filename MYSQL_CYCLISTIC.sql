--Union 5 excel files

CREATE TABLE full_dataset1 AS
SELECT *
FROM table_1
UNION
SELECT *
FROM table_2
UNION
SELECT *
FROM table_3
UNION
SELECT *
FROM table_4
UNION 
SELECT *
FROM table_5;

USE full_table;
SELECT COUNT(*)
FROM table_1;

ALTER TABLE full_dataset1 MODIFY COLUMN TIME_DIFF DECIMAL(10,2) ;
SELECT TIME_DIFF
FROM full_dataset1 ;

select TIME_DIFF, START_DATE,END_DATE
FROM full_dataset1
where TIME_DIFF <0 ; 

SELECT *
FROM full_dataset1;

ALTER TABLE full_dataset1
ADD RIDE_TIME_MINS int;

UPDATE full_dataset1

-- Creating a new column RIDE_TIME to get rid of negative values in the TIME_DIFF calculated column
SET RIDE_TIME_MINS =CASE 
             WHEN TIME_DIFF < 0 AND  LEFT(END_TIME,2) =0  THEN  (1440 + (TIME_TO_SEC(STR_TO_DATE(END_TIME,'%H:%i:%s')))/60)-
             ((TIME_TO_SEC(STR_TO_DATE(START_TIME,'%H:%i:%s')))/60)
             WHEN TIME_DIFF <0 AND LEFT(END_TIME,2) !=0 THEN (1440 - (TIME_TO_SEC(STR_TO_DATE(START_TIME,'%H:%i:%s')))/60)+
             ((TIME_TO_SEC(STR_TO_DATE(END_TIME,'%H:%i:%s')))/60)
             ELSE TIME_DIFF
             END ;
 
DESC full_dataset1 ;

SELECT START_TIME,END_TIME,RIDE_TIME_mins,TIME_DIFF,LEFT(END_TIME,2),(TIME_TO_SEC(STR_TO_DATE(START_TIME,'%H:%i:%s')))/60
FROM full_dataset1
WHERE RIDE_TIME_mins = 1440;


/* Checking to see if it worked */
SELECT *
FROM full_dataset1
WHERE  TIME_DIFF < 0 AND  LEFT(END_TIME,2) =0 ; 

/* The following codes mainly involve carrying out data aggregation to leverage useful insights*/

-- Average ride length grouped by Ride type
SELECT AVG(RIDE_TIME_mins) AS AVGRide_Time_mins,RIDEABLE_TYPE
FROM full_dataset1
group by RIDEABLE_TYPE
ORDER BY AVGRide_Time_mins DESC;

-- Average ride length grouped by user type (member,casual),Ride type
SELECT MEMBER_CASUAL,RIDEABLE_TYPE ,AVG(RIDE_TIME_mins) AS AVG_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,AVG_Ride_Time DESC;

-- Total ride length grouped by user type (member,casual),Ride type
SELECT MEMBER_CASUAL,RIDEABLE_TYPE ,SUM(RIDE_TIME_mins) AS Total_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,Total_Ride_Time DESC;

-- Minimum ride length grouped by user type (member,casual)and Ride type
SELECT MEMBER_CASUAL,RIDEABLE_TYPE ,MIN(RIDE_TIME_mins) AS Minimal_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,Minimal_Ride_Time DESC;

-- Average ride length grouped by user type (member,casual) and Season
SELECT MEMBER_CASUAL,SEASON ,AVG(RIDE_TIME_mins) AS AVG_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, SEASON
ORDER BY MEMBER_CASUAL,AVG_Ride_Time DESC;

-- Average ride length grouped by user type (member,casual),Season and Rideable_type
SELECT MEMBER_CASUAL,SEASON,RIDEABLE_TYPE ,AVG(RIDE_TIME_mins) AS AVG_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, SEASON,RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,SEASON,AVG_Ride_Time DESC;

-- Total ride length grouped by user type (member,casual) and Season 
SELECT MEMBER_CASUAL,SEASON ,SUM(RIDE_TIME_mins) AS TOTAL_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, SEASON
ORDER BY MEMBER_CASUAL,SEASON,TOTAL_Ride_Time DESC;

-- Total ride length grouped by user type (member,casual) and Season 
SELECT MEMBER_CASUAL,SEASON,RIDEABLE_TYPE ,SUM(RIDE_TIME_mins) AS TOTAL_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, SEASON,RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,SEASON,TOTAL_Ride_Time DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK ,SUM(RIDE_TIME_mins) AS TOTAL_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK
ORDER BY MEMBER_CASUAL, TOTAL_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK ,RIDEABLE_TYPE,SUM(RIDE_TIME_mins) AS TOTAL_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK, RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,DAY_OF_WEEK ,TOTAL_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK ,AVG(RIDE_TIME_mins) AS AVERAGE_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK
ORDER BY MEMBER_CASUAL, AVERAGE_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK, RIDEABLE_TYPE ,AVG(RIDE_TIME_mins) AS AVERAGE_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK, RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,DAY_OF_WEEK ,AVERAGE_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK ,MAX(RIDE_TIME_mins) AS MAX_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK
ORDER BY MEMBER_CASUAL, MAX_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK,RIDEABLE_TYPE ,MAX(RIDE_TIME_mins) AS MAX_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK,RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,DAY_OF_WEEK ,MAX_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK ,MIN(RIDE_TIME_mins) AS MIN_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK
ORDER BY MEMBER_CASUAL, MIN_Ride_Time  DESC;

SELECT MEMBER_CASUAL,DAY_OF_WEEK,RIDEABLE_TYPE ,MIN(RIDE_TIME_mins) AS MIN_Ride_Time
FROM full_dataset1
group by MEMBER_CASUAL, DAY_OF_WEEK,RIDEABLE_TYPE
ORDER BY MEMBER_CASUAL,DAY_OF_WEEK ,MIN_Ride_Time  DESC;















DESC full_dataset1; 

-- 1) adjusting max packet size to allow large files to run

SET GLOBAL max_allowed_packet = 1073741824;


-- 2) adjusting your SQL mode to allow invalid dates and use a smarter GROUP BY setting

SET GLOBAL SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES,ONLY_FULL_GROUP_BY';


-- 3) adjusting your timeout settings to run longer queries

SET GLOBAL connect_timeout=28800;

SET GLOBAL wait_timeout=28800;

SET GLOBAL interactive_timeout=28800;
