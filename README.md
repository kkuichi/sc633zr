# Názov práce
## **_Prognóza ochorenia COVID-19 pomocou dátovej analytiky_**

---
# Popis
Tento repozitár obsahuje praktickú časť bakalárskej práce, cieľom ktorej je vybrať vhodné modely strojového učenia na predpovedanie závažnosti priebehu ochorenia COVID-19 na základe poskytnutých dát o pacientoch.

Použitý dátaset obsahuje údaje o hospitalizovaných pacientoch **z Kliniky infektológie a cestovnej medicíny (KICM) Univerzitnej nemocnice Louisa Pasteura (UNLP)** v Košiciach.
Údaje pokrývajú **štyri vlny pandémie**, čo umožnilo porovnať význam prediktorov v čase.
Z dôvodu ochrany osobných údajov a citlivosti zdravotných informácií **pôvodný súbor údajov nebol pridaný**.

V rámci riešenia bol navrhnutý **dvojúrovňový klasifikačný prístup**:
- **Prvá úroveň** predikuje riziko úmrtia pacienta:
  -	Prežil
  -	Zomrel
- **Druhá úroveň** klasifikuje závažnosť priebehu ochorenia u preživších pacientov:
  - Prepustený do domáceho liečenia, eventuálne sociálneho zariadenia
  - Preložený na iné oddelenie
---
# Postup práce zahŕňal tieto kroky:
- **Exploratívna analýza dát** - získanie základných štatistík a vizualizácií na pochopenie štruktúry a rozdelenia atribútov.
- **Predspracovanie dát** - čistenie údajov, transformácia premenných a príprava vstupov pre modely.
- **Trénovanie modelov strojového učenia** - implementácia klasifikačných algoritmov:
  - Logistic Regression
  - XGBoost
  - SVM
  - Random Forest
- **Optimalizácia hyperparametrov** -  pomocou **GridSearchCV** s 5-násobnou krížovou validáciou.
- **Hodnotenie výkonnosti modelu** - pomocou metrík **hierarchical precision (hP)**, **hierarchical recall (hR)** a **hierarchical F-score (hF)**.
- **Interpretácia modelov** - analýza dôležitosti príznakov pomocou **SHAP hodnôt** a **koeficientov logistickej regresie**.
- **Vizuálna prezentácia výsledkov SHAP** - vytvorenie interaktívneho dashboardu v **R Shiny** na lepšie pochopenie vplyvu príznakov a získanie predikcie závažnosti ochorenia na základe údajov zadaných používateľom.
---
#### 👉 Aplikácia je dostupná online: [https://shinyapps.io/covid-19](https://chystiakova.shinyapps.io/covid-19_shap/ )

---
# Štruktúra projektu
```
.
├── dashboard/
│   ├── predictions/                   # Python-backend predikčnej funkcionality (založený na dátach zo 4. vlny pandémie)
│   │   ├── app.py                     # Flask aplikácia s REST API na získavanie predpovedí
│   │   ├── mortality_model.joblib     # Model na predikciu rizika úmrtia
│   │   ├── preprocesor.joblib         # Pipeline pre predspracovanie vstupných údajov
│   │   ├── requirements.txt           # Zoznam závislostí Python-projektu
│   │   ├── severity_model.joblib      # Model na predikciu závažnosti ochorenia
│   │   └── shap_background_df.joblib  # Dáta pre výpočet SHAP hodnôt
│   │
│   ├── shap_values.csv                # Vypočítané SHAP hodnoty pre interpretáciu modelov
│   └── app.r                          # RShiny aplikácia s vizualizáciami a predikciou
│
├── notebooks/                         # Jupyter notebooky pre vývoj a porovnanie rôznych modelov
│   ├── Logistic_regression.ipynb      # Logistická regresia
│   ├── Random_forest.ipynb            # Náhodný les
│   ├── SVM.ipynb                      # Metóda podporných vektorov 
│   └── XGBoost.ipynb                  # Gradientný boosting 
│
├── pochopenie_dat/                 
│   └── pochopenie_dat.ipynb           # Exploratívna a štatistická analýza dát
│
├── README.md                          # Tento súbor s popisom projektu

```
---
# Použité knižnice
### Jupyter Notebook: strojové učenie a analýza dát
| Knižnica            | Verzia  | Popis                                                |
|---------------------|---------|------------------------------------------------------|
| pandas              | 2.2.3   | Práca s dátovými štruktúrami a manipulácia s dátami. |
| numpy               | 2.1.3   | Výpočty a manipulácia s poľami                       |
| scipy               | 1.15.2  | Štatistické výpočty                                  |
| seaborn             | 0.13.2  | Vizualizácia dát                                     |
| matplotlib          | 3.10.0  | Tvorba grafov                                        |
| scikit-learn        | 1.6.1   | Algoritmy strojového učenia                          |
| shap                | 0.46.0  | Interpretácia modelov strojového učenia              |
| imbalanced-learn    | 0.13.0  | Práca s nevyváženými dátami                          |
| xgboost             | 2.1.4   | Implementácia algoritmu XGBoost                      |
| hiclass             | v5.0.4  | Metriky pre hierarchickú klasifikáciu                |



### Python: API a backend

| Knižnica | Verzia   | Popis                                       |
|----------|----------|---------------------------------------------|
| flask    | 3.0.3    | Webový framework na tvorbu REST API         |
| fastapi  | 0.115.12 | Framework API                               |
| uvicorn  | 0.34.2   | ASGI server na spustenie FastAPI aplikácií  |
| joblib   | 1.4.2    | Serializácia a ukladanie modelov            |


### R: knižnice pre dashboard (Shiny)

| Knižnica   | Verzia  | Popis                                                                      |
|------------|---------|----------------------------------------------------------------------------|
| shiny      | 1.10.0  | Framework pre tvorbu interaktívnych webových aplikácií v R                 |
| readr      | 2.1.5   | Import dát z rôznych formátov                                              |
| ggplot2    | 3.5.2   | Flexibilná vizualizácia dát                                                |
| dplyr      | 1.1.4   | Manipulácia s dátovými rámcami                                             |
| tidyr      | 1.3.1   | Čistenie a transformácia dát                                               |
| htmltools  | 0.5.8.1 | Vytváranie HTML obsahu pre aplikácie Shiny                                 |
| writexl    | 1.5.3   | Export dát do Excel súborov                                                |
| gt         | 1.0.0   | Tvorba tabuliek                                                            |
| DT         | 0.33    | Generovanie interaktívnych tabuliek s možnosťou filtrovania a stránkovania |
| plotly     | 4.10.4  | Interaktívne grafy                                                         |
| httr       | 1.4.7   | Posielanie HTTP požiadaviek                                                |
