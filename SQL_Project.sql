--Q1(a): Find the list of employees whose salary ranges between 2L to 3L.

SELECT
    *
FROM    
    employeee
WHERE
    salary BETWEEN 200000 AND 300000;


--Q1(b): Write a query to retrieve the list of employees from the same city.

--Method1:

SELECT
    E1.empid,
    E1.empname,
    E1.city
FROM
    employeee AS E1
    ,
    employeee AS E2
WHERE
    E1.city = E2.city
    AND
    E1.empid != E2.empid

--Method2:

SELECT
    empid,
    empname,
    city
FROM
    employeee
WHERE
    city in(
        SELECT
        city
        FROM
        employeee
        GROUP BY
        city
        HAVING count(city) >1
    )


--Q1(c): Query to find the null values in the Employee table.

SELECT
    *
FROM
    Employeee
WHERE
    empid IS NULL
    OR
    empname IS NULL
    OR
    gender IS NULL
    OR
    salary IS NULL
    OR
    city IS NULL;


-- Q2(a): Query to find the cumulative sum of employee’s salary.

SELECT
    empname,
    salary,
    SUM(salary) OVER (ORDER BY salary) AS cumulative_sum
FROM
    employeee


-- Q2(b): What’s the male and female employees ratio.

--Method1:

WITH individual_count AS(
SELECT
    COUNT(*) AS total_count,
    SUM(CASE WHEN gender = 'M' THEN 1.0 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1.0 ELSE 0 END) AS female_count
FROM
    employeee)
SELECT
    ROUND((male_count/total_count)*100,2) AS male_ratio,
    ROUND((female_count/total_count)*100,2) AS female_ratio
FROM
    individual_count;

--Method2:

SELECT
    (COUNT(*) FILTER (WHERE gender = 'M') * 100 / COUNT(*)) AS male_ratio,
    (COUNT(*) FILTER (WHERE gender = 'F') * 100 / COUNT(*)) AS female_ratio
FROM
    employeee;


-- Q2(c): Write a query to fetch 50% records from the Employee table.

--Method1:

SELECT
    *
FROM
    employeee
WHERE
    empid <=(
        SELECT
            ROUND(COUNT(empid) / 2,0)
        FROM
            employeee
            )

--Method2:

SELECT
    *
FROM
    (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY empid) AS row_number
    FROM
        employeee) AS emp
    WHERE
        emp.row_number <= (
            SELECT
                COUNT(*)/2
            FROM
                employeee
        );

--Method3:

WITH EmployeeRanked AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY empid) AS row_number,
           COUNT(*) OVER() AS total_count
    FROM 
        employeee
)
SELECT 
    *
FROM 
    EmployeeRanked
WHERE 
    row_number <= total_count / 2;


-- Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
-- i.e 12345 will be 123XX

--Method1:

SELECT
    empname,
    salary,
    CONCAT(SUBSTRING(salary::text,1,LENGTH(salary::text)-2),'XX') AS salary_mask
FROM
    employeee;

--Method2:

SELECT
    empname,
    salary,
    CONCAT(LEFT(salary::text,LENGTH(salary::text)-2),'XX') AS salary_mask
FROM
    employeee;





-- Q4: Write a query to fetch even and odd rows from Employee table.

-- Method1:

-- For Even:
SELECT
    *
FROM
    employeee
WHERE
    MOD(empid,2) != 0;

-- For Odd:

SELECT
    *
FROM
    employeee
WHERE
    MOD(empid,2) != 0;


--Method2:

-- FOR Even:

SELECT
    *
FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER(ORDER BY empid) AS row_number
        FROM
            employeee
    ) AS emp
WHERE
    emp.row_number % 2 = 0;

-- For ODD:

SELECT
    *
FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER(ORDER BY empid) AS row_number
        FROM
            employeee
    ) AS emp
WHERE
    emp.row_number % 2 != 0;


--Method3:

-- For Even:

WITH emp_rownum AS(
SELECT
    *,
    ROW_NUMBER() OVER(ORDER BY empid) AS row_number
FROM
    employeee
)
SELECT
    *
FROM
    emp_rownum
WHERE   
    row_number % 2 = 0;

-- For Odd:

WITH emp_rownum AS(
SELECT
    *,
    ROW_NUMBER() OVER(ORDER BY empid) AS row_number
FROM
    employeee
)
SELECT
    *
FROM
    emp_rownum
WHERE   
    row_number % 2 != 0;


--Q5(a): Write a query to find all the Employee names whose name:

-- • Begin with ‘A’

SELECT
    *
FROM
    employeee
WHERE
    empname LIKE 'A%';

-- • Contains ‘A’ alphabet at second place

SELECT
    *
FROM
    employeee
WHERE
    empname LIKE '_a%';

-- • Contains ‘Y’ alphabet at second last place

SELECT
    *
FROM
    employeee
WHERE
    empname LIKE '%y_';
-- • Ends with ‘L’ and contains 4 alphabets

SELECT
    *
FROM
    employeee
WHERE
    empname LIKE '____l';

-- • Begins with ‘V’ and ends with ‘A’

SELECT
    *
FROM
    employeee
WHERE
    empname LIKE 'V%a';


-- Q5(b): Write a query to find the list of Employee names which is:

-- • starting with vowels (a, e, i, o, or u), without duplicates

--Method1:

SELECT  
    DISTINCT empname
FROM
    employeee
WHERE
    LOWER(empname) SIMILAR TO '[aeiou]%';

--Method2:

SELECT
    DISTINCT empname
FROM
    employeee
WHERE
    LOWER(empname) LIKE 'a%'
    OR
    LOWER(empname) LIKE 'e%'
    OR
    LOWER(empname) LIKE 'i%'
    OR 
    LOWER(empname) LIKE 'o%'
    OR  
    LOWER(empname) LIKE 'u%';

-- • ending with vowels (a, e, i, o, or u), without duplicates

--Method1:

SELECT
    DISTINCT empname
FROM
    employeee
WHERE
    LOWER(empname) SIMILAR TO '%[aeiou]';

--Method2:

SELECT
    DISTINCT empname
FROM
    employeee
WHERE
    LOWER(empname) LIKE '%a'
    OR
    LOWER(empname) LIKE '%e'
    OR
    LOWER(empname) LIKE '%i'
    OR 
    LOWER(empname) LIKE '%o'
    OR  
    LOWER(empname) LIKE '%u';

-- • starting & ending with vowels (a, e, i, o, or u), without duplicates

SELECT
    DISTINCT empname
FROM
    employeee
WHERE
    LOWER(empname) SIMILAR TO '[aeiou]%[aeiou]';

-- Q6: Find Nth highest salary from employee table with and without using the
-- TOP/LIMIT keywords. n is second highest.

--Using Top

SELECT
    *
FROM
    employeee
ORDER BY salary DESC
LIMIT 1
OFFSET 1;


--Without Top:

-- Method1:

SELECT
    *
FROM
    employeee AS T1
WHERE
    2 - 1 = (
        SELECT
            COUNT(DISTINCT(salary))
        FROM
            employeee AS T2
        WHERE
            T2.salary > T1.salary
    );

-- Method2:

SELECT
    *
FROM
    employeee AS T1
WHERE
    2 = (
        SELECT
            COUNT(DISTINCT(salary))
        FROM
            employeee AS T2
        WHERE
            t2.salary >= t1.salary
    );

-- Method 3: If some salaries are same.

SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM employeee
) AS T1
WHERE salary_rank = 2;


-- Q7(a): Write a query to find and remove duplicate records from a table.

-- Find Duplicates:

-- Method1:

WITH duplicate_row AS(
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY empid, empname, gender, salary, city)  AS row_num  
    FROM
        employeee
)
SELECT
    *
FROM
    duplicate_row
WHERE
    row_num >1;

-- Method2:

SELECT
    empid,
    empname,
    gender,
    salary,
    city,
    COUNT(*)
FROM
    employeee
GROUP BY
    empid,
    empname,
    gender,
    salary,
    city
HAVING
    COUNT(*) >1;

-- Remove Duplicates:

DELETE
FROM
    employeee
WHERE
    empid IN (
        SELECT
            empid
        FROM
            employeee
        GROUP BY
            empid
        HAVING
            COUNT(*)>1
    )


-- Q7(b): Query to retrieve the list of employees working in same project.

WITH CTE AS(
    SELECT
        T1.empid,
        T1.empname,
        T2.project
    FROM
        employeee AS T1 JOIN
        EmployeeDetail AS T2
        ON
        T1.empid = T2.empid
)

SELECT
    T3.empname,
    T4.empname,
    T3.project
FROM
    CTE AS T3,
    CTE AS T4
WHERE
    T3.project = T4.project
    AND
    T3.empid != T4.empid
    AND
    T3.empid > T4.empid;


-- Q8: Show the employee with the highest salary for each project

--Method1:

SELECT
    T1.empid,
    project,
    T1.empname,
    MAX(T1.salary) AS max_salary
FROM
    employeee AS T1
    JOIN
    EmployeeDetail AS T2
    ON
    T1.empid = T2.empid
GROUP BY
    project,T1.empid,T1.empname
ORDER BY
    project,max_salary DESC;


--METHOD2:

WITH highest_salary AS (
    SELECT 
        T1.empid,
        T1.empname,
        T2.project,
        T1.salary,
        DENSE_RANK() OVER(PARTITION BY PROJECT ORDER BY salary DESC) AS ranks
    FROM
        employeee AS T1
        JOIN
        EmployeeDetail AS T2
        ON
        T1.empid = T2.empid
)
SELECT 
    empid,
    empname,
    project,
    salary
FROM
    highest_salary
WHERE
    ranks = 1;


-- Q9: Query to find the total count of employees joined each year

SELECT
    EXTRACT(YEAR FROM doj) AS year,
    COUNT(T1.empid) AS total_count
FROM
    employeee AS T1
    JOIN
    EmployeeDetail AS T2
    ON
    T1.empid = T2.empid
GROUP BY
    year;


-- Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1 -
-- 2L is medium and above 2L is High

SELECT
    empid,
    empname,
    salary,
    CASE
        WHEN salary > 200000 THEN 'High'
        WHEN salary > 100000 THEN 'Medium'
        ELSE
            'Low' END AS salary_range
FROM
    employeee


-- 11: Query to pivot the data in the Employee table and retrieve the total
-- salary for each city.
-- The result should display the EmpID, EmpName, and separate columns for each city
-- (Mathura, Pune, Delhi), containing the corresponding total salary.

SELECT
    empid,
    empname,
    SUM(CASE WHEN city = 'Mathura' THEN salary END) AS mathura,
    SUM(CASE WHEN city = 'Pune' THEN salary END) AS pune,
    SUM(CASE WHEN city = 'Bangalore' THEN salary END) AS bangalore,
    SUM(CASE WHEN city = 'Delhi' THEN salary END) AS bangalore
FROM
    employeee
GROUP BY
    empid,empname;
