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
from keras.layers import Layer

app = Flask(__name__)
CORS(app)

class L1Dist(Layer):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def call(self, input_embedding, validation_embedding):
        return tf.math.abs(input_embedding - validation_embedding)
# Global variables
model = None
feature_extractor = None
verification_images_path = None

def load_model():
    """Load the Siamese face recognition model and extract feature extractor"""
    global model, feature_extractor
    if model is None:
        model_path = os.path.join('FaceRecognition', 'siamesemodelv2.h5')
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model not found at {model_path}")

        model = keras.models.load_model(
            model_path,
            custom_objects={"L1Dist": L1Dist}
        )

        print(f"Model loaded successfully from {model_path}")
        
        # Extract the feature extraction layers from the Siamese model
        # Siamese networks have shared layers that can process a single image
        feature_extractor = None
        try:
            if len(model.inputs) == 2:
                # Find the L1Dist layer
                l1_layer = None
                for layer in model.layers:
                    if isinstance(layer, L1Dist):
                        l1_layer = layer
                        break
                
                if l1_layer is not None:
                    # The L1Dist layer takes two inputs (embeddings from both branches)
                    # We need to find which layer produces these embeddings
                    # Get the input tensor(s) to L1Dist
                    l1_inputs = l1_layer.input if isinstance(l1_layer.input, list) else [l1_layer.input]
                    
                    if len(l1_inputs) >= 1:
                        # Get the first embedding (from first input branch)
                        embedding_tensor = l1_inputs[0]
                        
                        # Create a model that takes the first input and outputs the embedding
                        feature_extractor = keras.Model(
                            inputs=model.inputs[0],
                            outputs=embedding_tensor
                        )
                        print("Feature extractor created successfully from L1Dist input")
                    else:
                        # Try alternative: find the layer that outputs to L1Dist
                        # Get layers connected to L1Dist
                        for layer in model.layers:
                            if layer != l1_layer:
                                try:
                                    # Try to create a model with this layer's output
                                    feature_extractor = keras.Model(
                                        inputs=model.inputs[0],
                                        outputs=layer.output
                                    )
                                    # Test if it works
                                    test_input = np.random.random((1, 100, 100, 3))
                                    _ = feature_extractor.predict(test_input, verbose=0)
                                    print(f"Feature extractor created using layer: {layer.name}")
                                    break
                                except:
                                    continue
                else:
                    print("Warning: L1Dist layer not found in model")
            else:
                print(f"Warning: Model has {len(model.inputs)} inputs, expected 2")
        except Exception as e:
            print(f"Warning: Could not extract feature extractor: {e}")
            import traceback
            traceback.print_exc()
            feature_extractor = None
        
        if feature_extractor is None:
            print("Warning: Feature extractor not available. Model will be used for direct comparison.")
    
    return model, feature_extractor


def preprocess_image(image_bytes):
    """Preprocess image for model input - resizes to 100x100 as expected by the Siamese model"""
    # Decode image
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    if img is None:
        raise ValueError("Failed to decode image")
    
    # Convert BGR to RGB
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    
    # Resize to 100x100 as required by the Siamese model (from notebook)
    img = cv2.resize(img, (100, 100))
    
    # Normalize pixel values to range [0, 1]
    img = img.astype('float32') / 255.0
    
    # Expand dimensions for batch: (100, 100, 3) -> (1, 100, 100, 3)
    img = np.expand_dims(img, axis=0)
    
    return img

def get_face_embedding(model, image, feature_extractor=None):
    """Get face embedding from the Siamese model"""
    if feature_extractor is None:
        raise ValueError(
            "Feature extractor is not available. "
            "The Siamese model requires 2 inputs, so a feature extractor must be created. "
            "Please check model loading."
        )
    
    try:
        embedding = feature_extractor.predict(image, verbose=0)
        return embedding.flatten()
    except Exception as e:
        print(f"Error extracting embedding: {e}")
        raise ValueError(f"Failed to extract embedding: {e}")

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
    
    model, feature_extractor = load_model()
    
    for img_file in image_files:
        img_path = os.path.join(verification_path, img_file)
        try:
            with open(img_path, 'rb') as f:
                img_bytes = f.read()
            preprocessed = preprocess_image(img_bytes)
            embedding = get_face_embedding(model, preprocessed, feature_extractor)
            verification_embeddings.append(embedding)
        except Exception as e:
            print(f"Error processing {img_file}: {e}")
            continue
    
    print(f"Loaded {len(verification_embeddings)} verification images")
    return verification_embeddings

def save_input_image(image_bytes):
    """Save input image to FaceRecognition/application_data/input_image"""
    input_image_dir = os.path.join(
        'FaceRecognition',
        'application_data',
        'input_image'
    )
    
    # Create directory if it doesn't exist
    os.makedirs(input_image_dir, exist_ok=True)
    
    # Save image with timestamp
    import time
    timestamp = int(time.time() * 1000)
    input_image_path = os.path.join(input_image_dir, f'input_{timestamp}.jpg')
    
    with open(input_image_path, 'wb') as f:
        f.write(image_bytes)
    
    print(f"Input image saved to: {input_image_path}")
    return input_image_path

def compare_with_model_direct(model, input_image, verification_image):
    """Compare two images directly using the Siamese model
    
    The model outputs a sigmoid value (0-1) where:
    - Higher values (closer to 1) = more similar/match
    - Lower values (closer to 0) = less similar/no match
    
    Returns the prediction score (0-1)
    """
    try:
        # The model expects 2 inputs: [input_image, verification_image]
        # Both should be batched: (1, 100, 100, 3)
        prediction = model.predict([input_image, verification_image], verbose=0)
        
        # Model outputs sigmoid: shape (1, 1) -> extract the value
        # Higher value = more similar
        score = float(prediction[0][0] if len(prediction.shape) > 1 else prediction[0])
        return score
    except Exception as e:
        print(f"Error in direct model comparison: {e}")
        import traceback
        traceback.print_exc()
        raise

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
        
        # Save input image to the correct folder
        try:
            save_input_image(image_bytes)
        except Exception as e:
            print(f"Warning: Could not save input image: {e}")
        
        # Preprocess input image
        input_image = preprocess_image(image_bytes)
        
        # Load model
        model, feature_extractor = load_model()
        
        # Get verification images path
        global verification_images_path
        if verification_images_path is None:
            verification_images_path = os.path.join(
                'FaceRecognition', 
                'application_data', 
                'verification_images'
            )
        
        # Check if verification images directory exists
        if not os.path.exists(verification_images_path):
            return jsonify({
                'verified': False,
                'error': f'Verification images directory not found: {verification_images_path}'
            }), 400
        
        # Get list of verification image files
        verification_image_files = [
            f for f in os.listdir(verification_images_path)
            if f.lower().endswith(('.jpg', '.jpeg', '.png'))
        ]
        
        if len(verification_image_files) == 0:
            return jsonify({
                'verified': False,
                'error': 'No verification images found in verification_images folder'
            }), 400
        
        # Compare input image with verification images
        if feature_extractor is not None:
            # Method 1: Use feature extractor (extract embeddings and compare)
            try:
                input_embedding = get_face_embedding(model, input_image, feature_extractor)
                
                # Load and compare with each verification image
                similarities = []
                for img_file in verification_image_files:
                    img_path = os.path.join(verification_images_path, img_file)
                    try:
                        with open(img_path, 'rb') as f:
                            ver_img_bytes = f.read()
                        ver_image = preprocess_image(ver_img_bytes)
                        ver_embedding = get_face_embedding(model, ver_image, feature_extractor)
                        similarity = cosine_similarity(input_embedding, ver_embedding)
                        similarities.append(similarity)
                    except Exception as e:
                        print(f"Error processing verification image {img_file}: {e}")
                        continue
                
                if len(similarities) == 0:
                    return jsonify({
                        'verified': False,
                        'error': 'Failed to process verification images'
                    }), 500
                
                max_similarity = max(similarities)
                threshold = 0.75
                verified = max_similarity >= threshold
                
                return jsonify({
                    'verified': verified,
                    'similarity': float(max_similarity),
                    'threshold': threshold,
                    'num_verification_images': len(verification_image_files),
                    'method': 'embedding_extraction'
                })
            except Exception as e:
                print(f"Error using feature extractor: {e}")
                print("Falling back to direct model comparison...")
        
        # Method 2: Direct model comparison (fallback)
        # Compare input image directly with each verification image using the model
        # The model outputs sigmoid scores (0-1) where higher = more similar
        scores = []
        for img_file in verification_image_files:
            img_path = os.path.join(verification_images_path, img_file)
            try:
                with open(img_path, 'rb') as f:
                    ver_img_bytes = f.read()
                ver_image = preprocess_image(ver_img_bytes)
                score = compare_with_model_direct(model, input_image, ver_image)
                scores.append(score)
                print(f"Comparison with {img_file}: score = {score:.4f}")
            except Exception as e:
                print(f"Error comparing with {img_file}: {e}")
                continue
        
        if len(scores) == 0:
            return jsonify({
                'verified': False,
                'error': 'Failed to compare with verification images'
            }), 500
        
        # Get maximum score (most similar)
        max_score = max(scores)
        
        # Threshold for verification (based on notebook: uses 0.3 for detection_threshold)
        # Higher threshold = stricter verification
        # The notebook uses 0.3, but you can adjust based on your needs
        threshold = 0.3
        
        verified = max_score >= threshold
        
        return jsonify({
            'verified': verified,
            'score': float(max_score),
            'threshold': threshold,
            'num_verification_images': len(verification_image_files),
            'method': 'direct_comparison'
        })
        
    except Exception as e:
        print(f"Error in verify_face: {e}")
        import traceback
        traceback.print_exc()
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
        model, feature_extractor = load_model()
        if feature_extractor is not None:
            print("Model and feature extractor loaded successfully!")
        else:
            print("Model loaded, but feature extractor could not be created.")
            print("This may cause issues. Please check the model architecture.")
    except Exception as e:
        print(f"Warning: Could not load model on startup: {e}")
        print("Model will be loaded on first request")
    
    # Run the service
    app.run(host='0.0.0.0', port=8001, debug=True)

