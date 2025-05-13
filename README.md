# Názov práce
### **Prognóza ochorenia COVID-19 pomocou dátovej analytiky**
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

# Postup práce zahŕňal tieto kroky:
- **Exploratívna analýza dát** - získanie základných štatistík a vizualizácií na pochopenie štruktúry a rozdelenia atribútov.
- **Predspracovanie dát** - čistenie údajov, transformácia premenných a príprava vstupov pre modely.
- **Trénovanie modelov strojového učenia** - implementácia klasifikačných algoritmov:
  - Logistic Regression
  - XGBoost
  - SVM
  - Random Forest
- **Optimalizácia hyperparametrov** -  pomocou **GridSearchCV** s 5-násobnou krížovou validáciou.
- **Hodnotenie výkonnosti modelu** - pomocou metrík **h-precision**, **h-recall** a **h-F1-score**, ktoré sú určené pre hierarchickú klasifikáciu.
- **Interpretácia modelov** - analýza dôležitosti príznakov pomocou **SHAP hodnôt** a **koeficientov logistickej regresie**.
- **Vizuálna prezentácia výsledkov SHAP** - vytvorenie interaktívneho dashboardu v **R Shiny** na lepšie pochopenie vplyvu príznakov a získanie predikcie závažnosti ochorenia na základe údajov zadaných používateľom.
