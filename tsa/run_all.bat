@echo off
echo Starting Flask API...
start cmd /k "cd flask_trash_classifier && python app.py"

echo Starting Flutter App...
flutter run