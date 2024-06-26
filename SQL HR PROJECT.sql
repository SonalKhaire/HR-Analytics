CREATE DATABASE HR_ANALYTICS;

USE HR_ANALYTICS;

CREATE TABLE HR_1 (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20)
);

desc HR_1;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_1.csv"
INTO TABLE HR_1 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE HR_2 (
    EmployeeID INT PRIMARY KEY,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

desc HR_2 ;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_2.csv"
INTO TABLE HR_2 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


Select * from HR_1;
Select * from HR_2;

-------------------------------------------------------------------------------------------------------------------

-- #KPI's 1: Average Attrition rate for all Departments

create view vw_Average_Attrition_rate_for_all_Departments as

SELECT Department,
CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2), '%') AS AverageAttritionRate
from HR_1
group by Department;

SELECT * FROM hr_analytics.vw_avg_attrition_rate_for_all_dept;

 --------------------------------------------------------------------------------------------------------
 -- #KPI's 2 Average Hourly rate of Male Research Scientist
 
create view vw_Average_Hourly_rate_of_Male_Research_Scientist as

select avg(HourlyRate) HourlyRate
 from HR_1
 where jobRole = "Research Scientist" and Gender = "Male";
 
 SELECT * FROM hr_analytics.vw_average_hourly_rate_of_male_research_scientist;
 
 -----------------------------------------------------------------------------------------------------------
 
 -- #KPI's 3 Attrition rate Vs Monthly income stats
 create view vw_Attrition_rate_Vs_Monthly_income_stats as
 select case 
 when MonthlyIncome between 1000 AND 10000 then "1K-10K"
 when MonthlyIncome between 11000 AND 20000 then "11K-20K"
 when MonthlyIncome between 21000 AND 30000 then "21K-30K"
 when MonthlyIncome between 31000 AND 40000 then "31K-40K"
 when MonthlyIncome between 41000 AND 50000 then "41K-50K"
 when MonthlyIncome > 50000 then "over 50K"
 else "over 50K"
 end as MonthlyIncomeBin,
 count(*) as employee, 
 sum(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
 CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2), '%') AS AverageAttritionRate
 from HR_2 join HR_1 on HR_1.EmployeeNumber = HR_2.EmployeeId
 group by MonthlyIncomeBin
 order by MonthlyIncomeBin;
 
 SELECT * FROM hr_analytics.vw_attrition_rate_vs_monthly_income_stats;
 
 ---------------------------------------------------------------------------------------------------------
 
 -- #KPI's 4 Average working years for each Department
 
 create view vw_Average_working_years_for_each_Department as
  SELECT
			HR_1.Department,
			ROUND(AVG(hr_2.TotalWorkingYears),2) AS Avg_Working_Years
	 FROM
			HR_1
	 INNER JOIN
			HR_2 ON HR_2.`EmployeeID` = HR_1.EmployeeNumber
	 GROUP BY
			Department
	 ORDER BY 
			Department;
            
SELECT * FROM hr_analytics.vw_average_working_years_for_each_department;

------------------------------------------------------------------------------------------------------------

-- #KPI's 5 Job Role Vs Work life balance
create view vw_Job_Role_Vs_Work_life_balance as 

SELECT
			HR_1.JobRole,
			SUM(CASE WHEN HR_2.WorkLifeBalance = 4 THEN 1 ELSE 0 END) AS Excellent,
			SUM(CASE WHEN HR_2.WorkLifeBalance = 3 THEN 1 ELSE 0 END) AS Good,
			SUM(CASE WHEN HR_2.WorkLifeBalance = 2 THEN 1 ELSE 0 END) AS Average,
			SUM(CASE WHEN HR_2.WorkLifeBalance = 1 THEN 1 ELSE 0 END) AS Poor
	FROM
			HR_1
	INNER JOIN
			HR_2 ON HR_2.`EmployeeID` = HR_1.EmployeeNumber
	GROUP BY
			JobRole
	ORDER BY
			JobRole;
            
SELECT * FROM hr_analytics.vw_job_role_vs_work_life_balance;
            
-------------------------------------------------------------------------------------------------------------------------
            
-- #KPI's 6 Attrition rate Vs Year since last promotion relation
create view vw_Attrition_rate_Vs_Year_since_last_promotion_relation as 

     SELECT 
			HR_2.YearsSinceLastPromotion,
            CONCAT(ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2), '%') AS AverageAttritionRate   
	 FROM
			HR_1
	 JOIN
			HR_2 ON HR_2.`EmployeeID` = HR_1.EmployeeNumber
	 GROUP BY 
			1
	 ORDER BY 
			1;

SELECT * FROM hr_analytics.vw_attrition_rate_vs_year_since_last_promotion_relation;




 
 
 
 
 

 
 



