from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from PIL import Image
from flask_cors import cross_origin

app = Flask(__name__)
CORS(app)

interpreter = tf.lite.Interpreter(model_path="model.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

with open("labels.txt", "r") as f:
    class_names = [line.strip() for line in f.readlines()]

IMG_HEIGHT = input_details[0]['shape'][1]
IMG_WIDTH = input_details[0]['shape'][2]
from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from PIL import Image
from flask_cors import cross_origin

app = Flask(__name__)
CORS(app)

interpreter = tf.lite.Interpreter(model_path="model.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

with open("labels.txt", "r") as f:
    class_names = [line.strip() for line in f.readlines()]

IMG_HEIGHT = input_details[0]['shape'][1]
IMG_WIDTH = input_details[0]['shape'][2]

@app.route('/predict', methods=['POST'])
def predict():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400

        image_file = request.files['image']
        image = Image.open(image_file).convert('RGB')
        image = image.resize((IMG_WIDTH, IMG_HEIGHT))

        input_data = np.expand_dims(
            np.array(image, dtype=np.float32) / 255.0, axis=0
        )

        interpreter.set_tensor(input_details[0]['index'], input_data)
        interpreter.invoke()
        output_data = interpreter.get_tensor(output_details[0]['index'])

        predicted_idx = int(np.argmax(output_data))
        confidence = float(np.max(output_data))
        predicted_label = class_names[predicted_idx]
        print("🧠 Raw prediction vector:", output_data.tolist())


        return jsonify({
            'label': predicted_label,
            'confidence': confidence
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
