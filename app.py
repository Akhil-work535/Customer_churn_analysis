import streamlit as st
import pandas as pd
import numpy as np
import pickle

# Load saved artifacts
with open("churn_artifacts.pkl", "rb") as f:
    artifacts = pickle.load(f)

model = artifacts["model"]
scaler = artifacts["scaler"]
num_cols = artifacts["num_cols"]
train_cols = artifacts["columns"]

st.title("📉 Customer Churn Prediction App")

st.write("Enter customer details to predict churn probability")

# -------- INPUT FORM -------- #
gender = st.selectbox("Gender", ["Male", "Female"])
SeniorCitizen = st.selectbox("Senior Citizen", [0, 1])
Partner = st.selectbox("Partner", ["Yes", "No"])
Dependents = st.selectbox("Dependents", ["Yes", "No"])
PhoneService = st.selectbox("Phone Service", ["Yes", "No"])
MultipleLines = st.selectbox("Multiple Lines", ["Yes", "No", "No phone service"])
InternetService = st.selectbox("Internet Service", ["DSL", "Fiber optic", "No"])
OnlineSecurity = st.selectbox("Online Security", ["Yes", "No", "No internet service"])
OnlineBackup = st.selectbox("Online Backup", ["Yes", "No", "No internet service"])
DeviceProtection = st.selectbox("Device Protection", ["Yes", "No", "No internet service"])
TechSupport = st.selectbox("Tech Support", ["Yes", "No", "No internet service"])
StreamingTV = st.selectbox("Streaming TV", ["Yes", "No", "No internet service"])
StreamingMovies = st.selectbox("Streaming Movies", ["Yes", "No", "No internet service"])
Contract = st.selectbox("Contract", ["Month-to-month", "One year", "Two year"])
PaperlessBilling = st.selectbox("Paperless Billing", ["Yes", "No"])
PaymentMethod = st.selectbox("Payment Method", 
                             ["Electronic check", "Mailed check", "Bank transfer (automatic)", "Credit card (automatic)"])

tenure = st.slider("Tenure (months)", 0, 72)
MonthlyCharges = st.number_input("Monthly Charges", 0.0, 200.0)
TotalCharges = st.number_input("Total Charges", 0.0, 10000.0)

# -------- PREDICT BUTTON -------- #
if st.button("Predict Churn"):
    
    raw_input = {
        "gender": gender,
        "SeniorCitizen": SeniorCitizen,
        "Partner": Partner,
        "Dependents": Dependents,
        "PhoneService": PhoneService,
        "MultipleLines": MultipleLines,
        "InternetService": InternetService,
        "OnlineSecurity": OnlineSecurity,
        "OnlineBackup": OnlineBackup,
        "DeviceProtection": DeviceProtection,
        "TechSupport": TechSupport,
        "StreamingTV": StreamingTV,
        "StreamingMovies": StreamingMovies,
        "Contract": Contract,
        "PaperlessBilling": PaperlessBilling,
        "PaymentMethod": PaymentMethod,
        "tenure": tenure,
        "MonthlyCharges": MonthlyCharges,
        "TotalCharges": TotalCharges
    }

    df = pd.DataFrame([raw_input])

    # Feature engineering (same as training)
    df["AvgMonthlySpend"] = df["TotalCharges"] / (df["tenure"] + 1)
    df["tenure_group"] = pd.cut(df["tenure"], bins=[0,6,12,24,48,72,np.inf],
                                labels=['0-5','6-11','12-23','24-47','48-71','72+'])
    df["Payment_Electronic"] = df["PaymentMethod"].apply(lambda x: 1 if "electronic" in x.lower() else 0)

    # One-hot encoding
    df = pd.get_dummies(df, drop_first=True)

    # Align with training columns
    df = df.reindex(columns=train_cols, fill_value=0)

    # Scale numeric features
    df[num_cols] = scaler.transform(df[num_cols])

    # Predict
    prob = model.predict_proba(df)[0][1]

    st.metric("Churn Probability", f"{prob:.2%}")

    if prob > 0.5:
        st.error("⚠️ Customer is likely to churn")
    else:
        st.success("✅ Customer is likely to stay")
