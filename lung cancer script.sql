-- Age distribution of Patients

select Age, count(Age) AS Age_Distribution
from `lung cancer trends`
group by Age
Order by Age_Distribution DESC;

-- how many male and female patients in the dataset


select Gender, count(Gender)
from `lung cancer trends`
group by Gender;

-- Patient Distribution by Region


select Region, count(Region) AS Patient_Distribution
from `lung cancer trends`
group by Region
order by Patient_Distribution;

-- The most common smoking statuses

select Smoking_Status, count(Smoking_Status) AS Most_Common_Smoking_Status
from `lung cancer trends`
group by Smoking_Status
order by Most_Common_Smoking_Status;

-- Average number of years smoking and cigarettes per day by gender

select Gender, ROUND(AVG(Years_Smoking)), ROUND(AVG(Cigarettes_Per_Day))
from `lung cancer trends`
group by gender;

-- how many patients have a family  history of lung cancer or positive genetic markers?

select Family_History, Genetic_Markers_Positive, count(*) AS Total_Count
from `lung cancer trends`
where
Family_History = 'Yes'
or
Genetic_Markers_Positive = 'Yes'
group by Family_History, Genetic_Markers_Positive;

-- How has the number of lung cancer diagnoses changed over time?

select Diagnosis_Year, count(Diagnosis_Year) AS Total_Number_of_Diagnosis
from `lung cancer trends`
where Lung_Cancer_Stage != 'None'
group by Diagnosis_Year
order by Diagnosis_Year;


-- What is the average age of diagnosis per year

select Diagnosis_Year, Round(AVG(Age)) AS Avg_Age
from `lung cancer trends`
where Lung_Cancer_Stage != 'None'
group by Diagnosis_Year
order by Diagnosis_Year;

-- What is the average BMI of patients grouped by lung cancer stage?

select Lung_Cancer_Stage, Round(AVG(BMI))
from `lung cancer trends` 
where Lung_Cancer_Stage != 'None'
group by Lung_Cancer_Stage;

-- What is the relationship between chronic lung disease and lung cancer stage?

select Lung_Cancer_Stage, count(*) AS Total_Count_of_Chronic_Lung_Disease
from `lung cancer trends`
where Lung_Cancer_Stage != 'None' AND Chronic_Lung_Disease = 'Yes'
group by Lung_Cancer_Stage, Chronic_Lung_Disease
order by Lung_Cancer_Stage;

-- how does physical activity level relate to lung cancer diagnosis?

select Physical_Activity_Level, count(Lung_Cancer_Stage) AS Total_Cancer_Diagnosis
from `lung cancer trends`
where Lung_Cancer_Stage != 'None'
group by Physical_Activity_Level;

-- Lung cancer screening frequency by education level

select Education_Level, count(Screening_Frequency) AS Freq_of_Screening
from `lung cancer trends`
group by Education_Level;

-- Lung cancer screening by income level

select Income_Level, count(Screening_Frequency) AS Freq_of_Screening
from `lung cancer trends`
group by Income_Level;



-- relationship between occupational exposure type and lung cancer diagnosis

select Occupation_Exposure, count(Lung_Cancer_Stage) AS Total_Cancer_Cases
from `lung cancer trends`
where Lung_Cancer_Stage != 'None'
group by Occupation_Exposure;

-- relationship between air pollution level and lung cancer diagnosis

select Air_Pollution_Level, count(Lung_Cancer_Stage) AS Total_Cases
from `lung cancer trends`
where Lung_Cancer_Stage != 'None'
group by Air_Pollution_Level 
order by Air_Pollution_Level desc;

-- relationship between air pollution level and chronic lung disease

select Air_Pollution_Level, count(Chronic_Lung_Disease) AS Total_Cases
from `lung cancer trends`
where Chronic_Lung_Disease = 'Yes'
group by Air_Pollution_Level 
order by Air_Pollution_Level desc;

-- How does alcohol intake relate to survival for lung cancer and non-lung cancer patients?

select
Alcohol_Consumption, 
CASE
when Lung_Cancer_Stage in ('Stage II','Stage I','Stage III','Stage IV') THEN 'Diseased'
when Lung_Cancer_Stage = 'None' THEN 'Not Diseased'
END AS Lung_Cancer_Diagnosis,
Survival_Status, count(*) AS  Total_survival_status
from `lung cancer trends`
group by Alcohol_Consumption, Lung_Cancer_Diagnosis, Survival_Status
order by Alcohol_Consumption;

-- Distribution of screening across education levels

select Education_Level, Screening_Frequency, count(*) AS Count_of_Screening
from `lung cancer trends`
group by Education_Level, Screening_Frequency
order by Education_Level;

-- Are patients with regular screening likely to survive lung cancer?

select Survival_Status, Count(Survival_Status) AS Count_of_Survival_Status
from `lung cancer trends`
where Screening_Frequency = 'Regularly'
and
Lung_Cancer_Stage != 'None'
group by Survival_Status;

-- Combination of risk factors appearing in most deceased patients

WITH risk_combinations AS (
  SELECT 
    Smoking_Status,
    Family_History,
    Air_Pollution_Level,
    COUNT(*) AS combo_count,
    RANK() OVER (
      ORDER BY COUNT(*) DESC
    ) AS Rank_Of
  FROM `lung cancer trends`
  WHERE Survival_Status = 'Deceased'
  GROUP BY Smoking_Status, Family_History, Air_Pollution_Level
)
SELECT * FROM risk_combinations
WHERE Rank_Of <= 5;


-- Common patient profiles of lung cancer diagnosed patients by age group, gender and smoking status

WITH grouped_profiles AS (
  SELECT
    CASE 
      WHEN Age < 40 THEN 'Under 40'
      WHEN Age BETWEEN 40 AND 59 THEN '40-59'
      WHEN Age BETWEEN 60 AND 79 THEN '60-79'
      ELSE '80+'
    END AS Age_Group,
    Gender,
    Smoking_Status,
    count(*) AS profile_count
  FROM `lung cancer trends`
  WHERE Lung_Cancer_Stage != 'None'
  GROUP BY Age_Group, Gender, Smoking_Status
),
ranked_profiles AS (
  SELECT *,
    RANK() OVER (ORDER BY profile_count DESC) AS Rank_of
  FROM grouped_profiles
)
SELECT *
FROM ranked_profiles
WHERE Rank_of <= 5;


-- Common patient profiles of diagnosed patients by Age group, Occupation exposure, alcohol consumption, diet quality
WITH grouped_profiles AS (
  SELECT
    CASE 
      WHEN Age < 40 THEN 'Under 40'
      WHEN Age BETWEEN 40 AND 59 THEN '40-59'
      WHEN Age BETWEEN 60 AND 79 THEN '60-79'
      ELSE '80+'
    END AS Age_Group,
    Occupation_Exposure,Alcohol_Consumption, Diet_Quality,
    count(*) AS profile_count
  FROM `lung cancer trends`
  WHERE Lung_Cancer_Stage != 'None'
  GROUP BY Age_Group,Occupation_Exposure,Alcohol_Consumption, Diet_Quality
),
ranked_profiles AS (
  SELECT *,
    RANK() OVER (ORDER BY profile_count DESC) AS Rank_of
  FROM grouped_profiles
)
SELECT *
FROM ranked_profiles
WHERE Rank_of <= 5;





