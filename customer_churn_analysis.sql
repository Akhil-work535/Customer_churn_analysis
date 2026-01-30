create table customer_churn_raw
(
customerID text,
gender text,
SeniorCitizen text,
Partner text,
Dependents text,
tenure text,
PhoneService text,
MultipleLines text,
InternetService text,
OnlineSecurity text,
OnlineBackup text,
DeviceProtection text,
TechSupport text,
StreamingTV text,
StreamingMovies text,
Contract text ,
PaperlessBilling text,
PaymentMethod text,
MonthlyCharges text ,
TotalCharges text,
Churn text
);


load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer_churn.csv'
into table customer_churn_raw
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * 
from customer_churn_raw;


select count(*)
from customer_churn_raw
where TotalCharges = ' ' ;

update  customer_churn_raw
set TotalCharges=null
where TotalCharges =' ';


ALTER TABLE customer_churn_raw
MODIFY tenure INT,
MODIFY MonthlyCharges DECIMAL(10,2),
MODIFY TotalCharges DECIMAL(10,2),
MODIFY SeniorCitizen INT;


SELECT COUNT(DISTINCT customerID) AS total_customers
FROM customer_churn_raw;


SELECT
  Churn,
  COUNT(*) AS customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customer_churn_raw
GROUP BY Churn;

SELECT
  Contract,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate
FROM customer_churn_raw
GROUP BY Contract
ORDER BY churn_rate DESC;

SELECT
  Churn,
  ROUND(AVG(tenure), 1) AS avg_tenure
FROM customer_churn_raw
GROUP BY Churn;


SELECT
  CASE
    WHEN tenure < 12 THEN '0-12 months'
    WHEN tenure BETWEEN 12 AND 24 THEN '12-24 months'
    ELSE '24+ months'
  END AS tenure_group,
  COUNT(*) AS customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate
FROM customer_churn_raw
GROUP BY tenure_group
ORDER BY churn_rate DESC;

SELECT
  Churn,
  ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue
FROM customer_churn_raw
GROUP BY Churn;

SELECT
  Contract,
  ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END),
    2
  ) AS churned_revenue
FROM customer_churn_raw
GROUP BY Contract
ORDER BY churned_revenue DESC;

SELECT
  InternetService,
  COUNT(*) AS customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate
FROM customer_churn_raw
GROUP BY InternetService
ORDER BY churn_rate DESC;

SELECT
  TechSupport,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate
FROM customer_churn_raw
GROUP BY TechSupport
ORDER BY churn_rate DESC;

WITH churn_summary AS (
  SELECT
    Contract,
    ROUND(
      SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
      2
    ) AS churn_rate
  FROM customer_churn_raw
  GROUP BY Contract
)
SELECT
  Contract,
  churn_rate,
  RANK() OVER (ORDER BY churn_rate DESC) AS risk_rank
FROM churn_summary;


UPDATE customer_churn_raw
SET Churn = TRIM(Churn);


SELECT
  Churn,
  LENGTH(Churn) AS length
FROM customer_churn_raw
GROUP BY Churn;


SELECT
  Churn,
  LENGTH(Churn) AS len,
  HEX(Churn) AS hex_value
FROM customer_churn_raw
GROUP BY Churn;


UPDATE customer_churn_raw
SET Churn = REPLACE(REPLACE(Churn, '\r', ''), '\n', '');




