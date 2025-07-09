echo "Starting Python backend..."
cd flask_trash_classifier
python app.py &

echo "Starting Flutter app..."
cd ..
flutter run
