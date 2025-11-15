# Système de Reconnaissance Hybride pour Accès Sécurisé Multi-Niveaux
## Compte rendu – Séance 1 : Benchmark Reconnaissance Faciale

## 1. Contexte du projet

L’objectif global du projet est de concevoir un **système d’authentification multi-niveaux** combinant plusieurs biométries :

- reconnaissance **faciale**,  
- reconnaissance **vocale**,  
- biométrie **comportementale** (dynamique de frappe / typing patterns).

Ce document se concentre sur le premier livrable : **la reconnaissance faciale**, avec :

- un **benchmark global** (applications, technologies, packages),  
- des **pistes de combinaison avec les LLMs** pour un futur système hybride.

---

## 2. Benchmark global des applications de reconnaissance faciale

### 2.1. Principaux cas d’usage

La reconnaissance faciale est aujourd’hui utilisée dans plusieurs domaines :

### **Sécurité & surveillance**
- vidéosurveillance intelligente  
- détection de personnes, suivi d’objets  
- identification en temps réel via flux caméra  

**Sources :**  
- Labellerr – https://www.labellerr.com/blog/computer-vision-in-security-surveillance/

### **Contrôle d’accès & authentification**
- accès à des bâtiments (badges remplacés par visage)  
- contrôle aux frontières, aéroports, ports  
- Face ID, smartphones  

**Source :**  
- Unaligned – https://www.unaligned.io/p/ai-computer-vision-transforming-image-recognition

### **e-KYC et services financiers**
- vérification d'identité lors d’ouverture de compte  
- comparaison visage / carte d’identité  

**Source :**  
- Labellerr – https://www.labellerr.com/blog/computer-vision-in-security-surveillance/

### **Autres domaines**
- santé  
- retail (analyse flux clients)  
- smart cities  

**Source :**  
- Unaligned – https://www.unaligned.io/p/ai-computer-vision-transforming-image-recognition

---

## 3. Benchmark des technologies de reconnaissance faciale

La plupart des solutions suivent une **pipeline à 4 étapes** :
détection → alignement → extraction de caractéristiques → comparaison / décision.

**Source :**  
https://science.lpnu.ua/ictte/all-volumes-and-issues/volume-3-number-2-2024/state-art-deep-learning-techniques-face

---

### 3.1. Approches classiques

#### **Viola–Jones / Haar Cascades (OpenCV)**
- basé sur Haar features + AdaBoost  
- rapide et léger  
- très simple à intégrer  

**Limites :**
- sensible à la lumière, pose, angle  
- adapté plutôt à la **détection**, pas la reconnaissance

**Source :**  
https://opencv24-python-tutorials.readthedocs.io/en/latest/py_tutorials/py_objdetect/py_face_detection/py_face_detection.html

---

### 3.2. Modèles deep learning (SOTA)

#### **Détection de visages**
- RetinaFace  
- SCRFD  
- SSD-based detectors  

Très robustes aux poses et occlusions.

**Source :**  
https://github.com/deepinsight/insightface

#### **Reconnaissance / Embeddings**
- ArcFace  
- FaceNet  
- VGG-Face  
- OpenFace  
- DeepFace  
- DeepID  

**ArcFace & FaceNet** sont les plus recommandés pour les systèmes critiques.

**Source :**  
https://science.lpnu.ua/ictte/all-volumes-and-issues/volume-3-number-2-2024/state-art-deep-learning-techniques-face

#### **InsightFace Toolbox**
- détecteurs : SCRFD, RetinaFace  
- reconnaisseurs : ArcFace  
- entraînement + déploiement

**Source :**  
https://github.com/deepinsight/insightface

---

## 4. Benchmark des packages / frameworks (Focus Python)

### 4.1. OpenCV

**Type :** bibliothèque de vision (C++/Python)  
**Fonctions :** Haar cascades, DNN, traitement vidéo, images  

**Pourquoi utile ici :**  
→ parfait pour ton premier livrable (détection temps réel webcam)

**Source :**  
https://opencv24-python-tutorials.readthedocs.io/

---

### 4.2. DeepFace

Framework haut niveau intégrant 8+ modèles SOTA :

- VGG-Face  
- FaceNet  
- OpenFace  
- DeepFace  
- DeepID  
- ArcFace  
- Dlib  
- SFace  

**Points forts :**
- API simple : `DeepFace.verify()`, `DeepFace.analyze()`, `DeepFace.stream()`  
- idéal pour un PoC rapide  

**Limites :**
- dépendances lourdes (TensorFlow / PyTorch)

**Source :**  
https://pypi.org/project/deepface/

---

### 4.3. InsightFace

**Type :** toolbox deep learning  
**Contenu :** RetinaFace, SCRFD, ArcFace  
**Idéal pour :** performances avancées, GPU, production

**Source :**  
https://github.com/deepinsight/insightface

---

### 4.4. face_recognition (dlib)

- API simple  
- modèle 128D embeddings  
- ~99.38% accuracy sur LFW  

**Limites :**
- installation difficile (compilation dlib)

**Sources :**  
GitHub – https://github.com/ageitgey/face_recognition  
PyPI – https://pypi.org/project/face-recognition/

---

## 5. Combinaisons possibles avec les LLMs

Les systèmes modernes fusionnent **vision + langage** (VLM / MLLM).

**Sources :**  
Tryolabs – https://tryolabs.com/blog/llms-leveraging-computer-vision  
Chooch – https://www.chooch.com/blog/how-to-integrate-large-language-models-with-computer-vision

---

### 5.1. Rôle des LLMs dans un système biométrique

#### **1. Orchestrateur de décision multi-facteurs**
Il reçoit :  
- score visage  
- score voix  
- score typing pattern  
- contexte (time, location, device)

Le LLM peut :  
- agréger les signaux  
- générer une décision finale  
- expliquer la décision  

#### **2. Interaction naturelle avec l’administrateur**
Exemples :  
- “Montre les tentatives d’accès échouées aujourd’hui.”  
- “Explique pourquoi X a été refusé à 10h.”  

#### **3. Analyse contextuelle**
LLMs + vision permettent des rapports détaillés, surveillance intelligente.

---

## 5.3. Aspects éthiques & RGPD

La biométrie faciale est une donnée **hautement sensible**.  
Les recommandations incluent :

- minimisation des données  
- séparer données brutes / embeddings / logs  
- chiffrement  
- privacy by design  

**Source :**  
EDPB – https://edpb.europa.eu/

---

## 6. Conclusion

Le benchmark montre que :

- Pour ton **premier livrable**, OpenCV + Haar est parfait (simple, léger, démonstratif).  
- Pour la **reconnaissance avancée**, privilégier ArcFace / FaceNet via InsightFace ou DeepFace.  
- Pour le **système hybride**, les LLMs joueront le rôle d’orchestrateur explicatif et contextuel.

---
