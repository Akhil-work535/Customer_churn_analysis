#  Customer Churn Analysis 

##  Business Problem
Subscription-based businesses lose significant revenue due to customer churn.  
The challenge is not just predicting churn, but identifying at-risk customers early so retention strategies can be applied effectively.

This project focuses on:
- Understanding why customers churn
- Building models that prioritize recall for churned customers
- Translating model results into business-actionable insights

##  Objective
- Analyze customer behavior to identify churn drivers  
- Build and evaluate machine learning models for churn prediction  
- Improve churn class recall, not just overall accuracy  
- Provide insights that can help reduce customer loss  

##  Dataset
- Source: Telco Customer Churn dataset (Kaggle)
- Size: ~7,000 customers
- Target Variable: Churn (Yes / No)
- Key Features:
  - Contract type
  - Monthly charges
  - Tenure
  - Payment method
  - Internet & service subscriptions

##  Key Challenges Identified
| Challenge | Why It Matters |
|---------|----------------|
| Class imbalance | Churned customers were a minority → accuracy was misleading |
| Low churn recall | Many churned customers were missed by baseline models |
| Feature dominance | Contract type & tenure heavily influenced predictions |

##  Approach & Solutions

### 1️⃣ Data Preprocessing
- Removed irrelevant identifiers
- Handled missing values
- Encoded categorical variables
- Scaled numerical features

### 2️⃣ Exploratory Data Analysis (EDA)
Key findings:
- Month-to-month customers churn significantly more
- Higher monthly charges correlate with higher churn
- Long-tenure customers are more loyal

##  Modeling & Evaluation

### Models Trained
- Logistic Regression
- Random Forest
- Gradient Boosting
- Random Forest + SMOTE

###  Why Accuracy Was Not Enough
Because churn is imbalanced, accuracy alone falsely favored non-churn predictions.  
Recall for churned customers was chosen as the primary metric.

##  Model Performance 

| Model | Recall (Churn) | Key Insight |
|------|---------------|------------|
| Logistic Regression | Low | Struggled with imbalance |
| Random Forest | Moderate | Better non-linear learning |
| Gradient Boosting | Improved | Captured complex patterns |
| Random Forest + SMOTE | Best | Significantly improved churn detection |

##  Business Impact
- Higher churn recall → more customers flagged before leaving
- Enables targeted retention strategies:
  - Discounts for month-to-month users
  - Incentives for high-charge customers
  - Long-term contract promotions

##  Visualization & Dashboard
An interactive Power BI dashboard was created to:
- Track churn trends
- Compare customer segments
- Support non-technical stakeholders

##  Tools & Technologies
- Python: pandas, numpy, scikit-learn, matplotlib, seaborn
- ML Techniques: SMOTE, Random Forest, Gradient Boosting
- Visualization: Power BI
- Environment: Jupyter Notebook

##  Key Takeaways
- Metric selection is critical in imbalanced problems
- Improving recall can be more valuable than improving accuracy
- Domain understanding combined with ML leads to better business outcomes

##  Future Improvements
- Hyperparameter tuning with cross-validation
- Cost-sensitive learning
- Model explainability using SHAP
- Deployment as a web application or API

## 👤 Author
Akhil  
Aspiring Data Analyst  
linkedin: http://www.linkedin.com/in/vankayalapati-akhil
