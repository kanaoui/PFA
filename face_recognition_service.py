"""
Face Recognition Service for AgroSense
This service handles face verification using the Siamese model
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import cv2
import base64
import os
from PIL import Image
import io
import tensorflow as tf
from tensorflow import keras

app = Flask(__name__)
CORS(app)

# Global variables
model = None
verification_images_path = None

def load_model():
    """Load the Siamese face recognition model"""
    global model
    if model is None:
        # Update this path to match your model location
        model_path = os.path.join('FaceRecognition', 'siamesemodelv2.h5')
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model not found at {model_path}")
        model = keras.models.load_model(model_path)
        print(f"Model loaded successfully from {model_path}")
    return model

def preprocess_image(image_bytes):
    """Preprocess image for model input - expects 250x250 face images"""
    # Decode image
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    if img is None:
        raise ValueError("Failed to decode image")
    
    # Convert BGR to RGB
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    
    # Image should already be 250x250 from Flutter face detection
    # But resize to ensure correct size (adjust if your model expects different size)
    img = cv2.resize(img, (250, 250))
    
    # Normalize
    img = img.astype('float32') / 255.0
    
    # Expand dimensions for batch
    img = np.expand_dims(img, axis=0)
    
    return img

def get_face_embedding(model, image):
    """Get face embedding from the model"""
    # Adjust this based on your model architecture
    # If your model is a Siamese network, you might need to extract embeddings
    embedding = model.predict(image, verbose=0)
    return embedding.flatten()

def cosine_similarity(embedding1, embedding2):
    """Calculate cosine similarity between two embeddings"""
    dot_product = np.dot(embedding1, embedding2)
    norm1 = np.linalg.norm(embedding1)
    norm2 = np.linalg.norm(embedding2)
    similarity = dot_product / (norm1 * norm2 + 1e-8)
    return similarity

def load_verification_images(verification_path):
    """Load all verification images and their embeddings"""
    verification_embeddings = []
    
    if not os.path.exists(verification_path):
        print(f"Verification path does not exist: {verification_path}")
        return verification_embeddings
    
    image_files = [f for f in os.listdir(verification_path) 
                   if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
    
    model = load_model()
    
    for img_file in image_files:
        img_path = os.path.join(verification_path, img_file)
        try:
            with open(img_path, 'rb') as f:
                img_bytes = f.read()
            preprocessed = preprocess_image(img_bytes)
            embedding = get_face_embedding(model, preprocessed)
            verification_embeddings.append(embedding)
        except Exception as e:
            print(f"Error processing {img_file}: {e}")
            continue
    
    print(f"Loaded {len(verification_embeddings)} verification images")
    return verification_embeddings

@app.route('/verify_face', methods=['POST'])
def verify_face():
    """Verify face against verification images"""
    try:
        data = request.json
        if 'image' not in data:
            return jsonify({'error': 'No image provided'}), 400
        
        # Decode base64 image
        image_base64 = data['image']
        image_bytes = base64.b64decode(image_base64)
        
        # Preprocess input image
        input_image = preprocess_image(image_bytes)
        
        # Load model
        model = load_model()
        
        # Get embedding for input image
        input_embedding = get_face_embedding(model, input_image)
        
        # Get verification images path
        # Update this path to match your setup
        global verification_images_path
        if verification_images_path is None:
            verification_images_path = os.path.join(
                'FaceRecognition', 
                'application_data', 
                'verification_images'
            )
        
        # Load verification embeddings
        verification_embeddings = load_verification_images(verification_images_path)
        
        if len(verification_embeddings) == 0:
            return jsonify({
                'verified': False,
                'error': 'No verification images found'
            }), 400
        
        # Compare with all verification images
        similarities = []
        for ver_embedding in verification_embeddings:
            similarity = cosine_similarity(input_embedding, ver_embedding)
            similarities.append(similarity)
        
        # Get maximum similarity
        max_similarity = max(similarities)
        
        # Threshold for verification (adjust based on your model)
        # Typical values: 0.7-0.9 for face recognition
        threshold = 0.75
        
        verified = max_similarity >= threshold
        
        return jsonify({
            'verified': verified,
            'similarity': float(max_similarity),
            'threshold': threshold,
            'num_verification_images': len(verification_embeddings)
        })
        
    except Exception as e:
        print(f"Error in verify_face: {e}")
        return jsonify({
            'verified': False,
            'error': str(e)
        }), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'ok', 'service': 'face_recognition'})

if __name__ == '__main__':
    print("Starting Face Recognition Service...")
    print("Make sure the model file is in FaceRecognition/siamesemodelv2.h5")
    print("Make sure verification images are in FaceRecognition/application_data/verification_images/")
    
    # Load model on startup
    try:
        load_model()
        print("Model loaded successfully!")
    except Exception as e:
        print(f"Warning: Could not load model on startup: {e}")
        print("Model will be loaded on first request")
    
    # Run the service
    app.run(host='0.0.0.0', port=8001, debug=True)

