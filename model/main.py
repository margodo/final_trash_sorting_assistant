import os
import tensorflow as tf
from tensorflow.keras import layers, models
from pathlib import Path

DATASET_DIR = "dataset/train"
MODEL_TFLITE_PATH = "model.tflite"
LABELS_PATH = "labels.txt"
IMG_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS = 10

dataset = tf.keras.utils.image_dataset_from_directory(
    DATASET_DIR,
    image_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    label_mode="categorical"
)

class_names = dataset.class_names


val_batches = tf.data.experimental.cardinality(dataset) // 5
val_dataset = dataset.take(val_batches)
train_dataset = dataset.skip(val_batches)

def preprocess(ds):
    return ds.map(lambda x, y: (tf.cast(x, tf.float32) / 255.0, y))

train_dataset = preprocess(train_dataset).cache().shuffle(1000).prefetch(buffer_size=tf.data.AUTOTUNE)
val_dataset = preprocess(val_dataset).cache().prefetch(buffer_size=tf.data.AUTOTUNE)

model = models.Sequential([
    layers.Input(shape=(*IMG_SIZE, 3)),
    layers.Conv2D(32, 3, activation='relu'),
    layers.MaxPooling2D(),
    layers.Conv2D(64, 3, activation='relu'),
    layers.MaxPooling2D(),
    layers.Conv2D(128, 3, activation='relu'),
    layers.MaxPooling2D(),
    layers.Flatten(),
    layers.Dense(128, activation='relu'),
    layers.Dense(len(class_names), activation='softmax')
])

model.compile(optimizer='adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

model.fit(train_dataset, validation_data=val_dataset, epochs=EPOCHS)

with open(LABELS_PATH, "w") as f:
    for label in class_names:
        f.write(label + "\n")

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open(MODEL_TFLITE_PATH, 'wb') as f:
    f.write(tflite_model)

print("\nTraining complete. Model saved as model.tflite and labels.txt")
