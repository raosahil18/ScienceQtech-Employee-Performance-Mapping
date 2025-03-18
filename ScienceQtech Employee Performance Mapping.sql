-- 1.Create a database named employee, then import data_science_team.csv proj_table.csv
--   and emp_record_table.csv into the employee database from the given resources.
CREATE DATABASE EMPLOYEE;
USE EMPLOYEE;

SHOW TABLES;
-- 2.Create an ER diagram for the given employee database.


-- 3.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
-- and make a list of employees and details of their department.
SELECT EMP_ID , FIRST_NAME , LAST_NAME , LAST_NAME , GENDER , DEPT FROM EMPLOYEE_DTL;

/*4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
● less than two
● greater than four 
● between two and four.
*/
SELECT * FROM EMPLOYEE_DTL;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM EMPLOYEE_DTL
WHERE EMP_RATING < 2 OR 
      EMP_RATING > 4 OR 
      EMP_RATING between 2 AND 4;
      
SELECT * FROM EMPLOYEE_DTL;

-- 5.Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 
--   from the employee table and then give the resultant column alias as NAME.
SELECT 
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME_OF_EMPLOYEE
FROM
    EMPLOYEE_DTL;

-- 6. Write a query to list only those employees who have someone reporting to them. 
--    Also, show the number of reporters (including the President).
SELECT e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE, COUNT(r.EMP_ID) AS NUM_OF_REPORTERS
FROM EMPLOYEE_DTL e
JOIN EMPLOYEE_DTL r ON e.EMP_ID = r.MANAGER_ID
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE
ORDER BY NUM_OF_REPORTERS DESC;

SELECT * FROM EMPLOYEE_DTL;

-- 7.Write a query to list down all the employees from the healthcare and finance departments using union. 
--   Take data from the employee record table.
SELECT * 
FROM EMPLOYEE_DTL
WHERE DEPT = 'Healthcare' 

UNION

SELECT * 
FROM EMPLOYEE_DTL
WHERE DEPT = 'Finance';

-- 8.Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, 
--  and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the
--  department.

SELECT DEPT , MAX(EMP_RATING) AS MAX_EMP_RATING
FROM employee_dtl
GROUP BY DEPT;
    
-- 9.Write a query to calculate the minimum and the maximum salary of the employees in each role.
--   Take data from the employee record table.
SELECT ROLE , MIN(SALARY) AS MINI_SALARY , MAX(SALARY) AS MAX_SALARY FROM EMPLOYEE_DTL
GROUP BY ROLE;

-- 10.Write a query to assign ranks to each employee based on their experience. 
--    Take data from the employee record table.
SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP, DENSE_RANK() OVER( ORDER BY EXP DESC ) AS RANK_OF_EMPLOYEE FROM EMPLOYEE_DTL;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP, RANK() OVER( ORDER BY EXP DESC ) AS RANK_OF_EMPLOYEE FROM EMPLOYEE_DTL;

-- IN RANK IT SKIP THE RANK 
-- IN DENSE RANK IT DOESNOT SKIP THE RANKS 

SELECT * FROM EMPLOYEE_DTL;


-- 11.Write a query to create a view that displays employees in various countries 
--    whose salary is more than six thousand. Take data from the employee record table.
CREATE OR REPLACE VIEW EMPLOYEE_VIEW AS 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY  FROM EMPLOYEE_DTL
WHERE SALARY > 6000;

SELECT * FROM EMPLOYEE_VIEW;

-- 12.Write a nested query to find employees with experience of more than ten years.
--    Take data from the employee record table.

SELECT * FROM EMPLOYEE_DTL 
WHERE EMP_ID IN (SELECT EMP_ID FROM EMPLOYEE_DTL 
WHERE EXP > 10);

SELECT * FROM EMPLOYEE_DTL;

-- 13.Write a query to create a stored procedure to retrieve the details of the employees 
--    whose experience is more than three years.Take data from the employee record table

USE `employee`;
DROP procedure IF EXISTS `proc_1`;

DELIMITER $$
USE `employee`$$
CREATE PROCEDURE `proc_1` ()
BEGIN
select * from employee_dtl
where exp > 3;
END$$

DELIMITER ;

call proc_1();


-- 14.Write a query using stored functions in the project table to check whether the job profile assigned to each 
--    employee in the data science team matches the organization’s set standard.
--    The standard being:
--    For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
--    For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
--    For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
--    For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
--    For an employee with the experience of 12 to 16 years assign 'MANAGER'.
DELIMITER //

CREATE FUNCTION Get_Job_Profile(exp INT) 
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE job_title VARCHAR(50);

    IF exp <= 2 THEN
        SET job_title = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET job_title = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET job_title = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET job_title = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET job_title = 'MANAGER';
    ELSE
        SET job_title = 'OTHER';
    END IF;

    RETURN job_title;
END //

DELIMITER ;

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    ROLE AS Assigned_Job_Profile, 
    EXP AS Experience,
    Get_Job_Profile(EXP) AS Expected_Job_Profile,
    CASE 
        WHEN ROLE = Get_Job_Profile(EXP) THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS Status
FROM data_science_team;

-- 15.Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ 
--    in the employee table after checking the execution plan.
CREATE INDEX EMPLOYEE_INDEX ON EMPLOYEE_DTL
(FIRST_NAME(100));

SELECT FIRST_NAME FROM EMPLOYEE_DTL
WHERE FIRST_NAME = 'ERIC';

-- 16.Write a query to calculate the bonus for all the employees,
--    based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, SALARY, EMP_RATING,(0.05 * SALARY * EMP_RATING) AS BONUS 
FROM EMPLOYEE_DTL;

-- 17.Write a query to calculate the average salary distribution based on the continent and country. 
--    Take data from the employee record table.
SELECT COUNTRY, CONTINENT,ROUND(AVG(SALARY),2) AS AVG_SALARY FROM EMPLOYEE_DTL
GROUP BY COUNTRY, CONTINENT
ORDER BY AVG_SALARY DESC; 




