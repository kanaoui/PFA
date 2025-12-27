# 🧠 Système de Reconnaissance Hybride pour Accès Sécurisé Multi-Niveaux

## 📌 Description du Projet

Ce projet s'inscrit dans le cadre du Projet de Fin d’Année (PFA).  
L’objectif est de concevoir un **système d’authentification multi-niveaux** combinant trois modalités biométriques :

- **Reconnaissance faciale**  
- **Reconnaissance vocale**  
- **Biométrie comportementale** (typing patterns)

L’idée principale est de créer une solution de sécurité avancée capable de vérifier l’identité d’un utilisateur à travers plusieurs sources biométriques, puis de fusionner ces informations pour prendre une décision finale plus fiable et robuste.

Ce système est conçu pour des environnements nécessitant un **niveau de sécurité élevé**, comme :
- systèmes d’accès sécurisés,
- entreprises industrielles ou financières,
- infrastructures gouvernementales,
- plateformes nécessitant authentification forte.

---

## 🎯 **Objectifs du PFA**

### 🔹 1. Reconnaissance Faciale — *Phase actuelle*
- Benchmark des applications utilisant la vision par ordinateur
- Benchmark des technologies (CNN, ArcFace, FaceNet, Haar Cascades, etc.)
- Benchmark des packages (OpenCV, DeepFace, InsightFace, face_recognition)
- Développement d’un prototype de détection faciale avec OpenCV
- Mise en place d’une application web Streamlit pour tester la détection

### 🔹 2. Reconnaissance Vocale (prochaine phase)
- Extraction d’empreintes vocales
- Modèles de vérification du locuteur (Speaker Verification)

### 🔹 3. Typing Biometrics (comportement de frappe)
- Mesure du temps de réaction, pression, cadence
- Construction d’un profil comportemental unique par utilisateur

### 🔹 4. Fusion des modalités & LLMs
- Analyse intelligente des signaux
- Orchestration via un modèle LLM ou multimodal
- Génération d’explications (“Explainable AI”)
- Décision finale d’accès ou refus

---

## 🧩 **Technologies & Outils**

### 🔧 Backend / IA
- **Python**
- **OpenCV**
- **DeepFace**
- **InsightFace (ArcFace)**
- **TensorFlow / PyTorch**
- **scikit-learn**

### 🌐 Frontend / Web App
- **Streamlit**
- (Toutes les étapes sont exécutables localement)

### 🧠 LLMs
- Intégration prévue pour traiter :
  - le contexte
  - la fusion des modalités
  - la logique explicative

---

## 🚀 **Livrables (Séance 1 & 2)**

- ✔ Benchmark complet des technologies  
- ✔ Notebook Jupyter modulaire (`.ipynb`) pour détection faciale  
- ✔ Application web Streamlit (détection via OpenCV)  
- ✔ README (ce fichier)  
- ✔ Code structuré et prêt pour évolution en système hybride multimodal  

---

## 💡 **Vision Finale**

Construire un **système d’accès intelligent** capable de combiner plusieurs biométries, contextes et analyses LLM pour produire une authentification :

- plus sûre,  
- plus expliquée,  
- plus difficile à contourner,  
- adaptée aux environnements critiques.

---

## 👩‍💻 Auteurs

**KANAOUI Aymane et EL HACHCHAD Abdelghaffar**  
5th Year MIAGE – EMSI  
Projet de Fin d’Année (PFA)

---

