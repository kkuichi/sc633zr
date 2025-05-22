from flask import Flask, request, jsonify
import joblib
import pandas as pd
import shap
import traceback

app = Flask(__name__)


mort_model = joblib.load("mortality_model.joblib")
severity_model = joblib.load("severity_model.joblib")
preprocessor = joblib.load("preprocessor.joblib")
background_df = joblib.load("shap_background_df.joblib")

preprocessor.fit(background_df)
background_transformed = preprocessor.transform(background_df)
classifier = mort_model.named_steps["classifier"]
explainer = shap.LinearExplainer(classifier, background_transformed)

@app.route("/predict", methods=["POST"])
def predict():
    try:
        input_data = request.get_json()
        df = pd.DataFrame([input_data])

        if 'Pohlavie_Žena' in df.columns:
            df['Pohlavie_Žena'] = df['Pohlavie_Žena'].map({'Muž': 0, 'Žena': 1})
        X_transformed = preprocessor.transform(df)

        
        mortality_pred = int(mort_model.predict(df)[0])
        result = {"mortality_prediction": mortality_pred}

        if mortality_pred == 0:
            severity_pred = int(severity_model.predict(df)[0])
            result["severity_prediction"] = severity_pred

        
        shap_values = explainer.shap_values(X_transformed)
        result["shap_values"] = {
            feature: float(value)
            for feature, value in zip(df.columns, shap_values[0])
        }

        return jsonify(result)

    except Exception as e:
        print("Prediction Error:", traceback.format_exc())
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=8000)
