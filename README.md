# Weather Forecast App 🌤️

A Flutter-based Weather Forecast Application that allows users to search for a city and view its current weather information and upcoming forecast. The application uses the OpenWeatherMap API to retrieve real-time weather data and GetX for reactive state management.

## 📱 App Screenshots

###  Home Screen
![Home Screen](screenshots/home_screen.png)

###  Forecast Screen
![Forecast Screen](screenshots/forecast_screen.png)



## ✨ Features

- Search for weather information by city name.
- Display current weather conditions.
- Show temperature in Celsius.
- View upcoming weather forecasts.
- Retrieve weather data using the OpenWeatherMap API.
- Display loading states while fetching data.
- Handle API errors and unavailable data.
- Update the UI reactively using GetX.

## 🛠️ Technologies and Packages

| Technology / Package | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| GetX | State management and reactive UI updates |
| Dio | HTTP requests and API communication |
| OpenWeatherMap API | Weather and forecast data |
| Gap | Spacing between UI elements |
| HugeIcons | Application icons |
| Cupertino Icons | iOS-style icons |

## 📂 Project Structure

```text
lib/
├── main.dart
└── modules/
    └── weather/
        ├── controllers/
        │   └── weather_controller.dart
        ├── models/
        │   ├── weather_model.dart
        │   └── forecast_model.dart
        ├── services/
        │   └── weather_service.dart
        └── views/
            ├── home_view.dart
            └── forecast_view.dart

pubspec.yaml
```

### Folder Description

- **controllers:** Manages application logic, loading states, weather data, and errors.
- **models:** Converts API JSON responses into structured Dart objects.
- **services:** Handles HTTP requests to the OpenWeatherMap API using Dio.
- **views:** Contains the Home and Forecast user interfaces.
- **main.dart:** Entry point of the application.

## 🚀 Installation and Setup

Follow these steps to run the project locally.

**1. Clone the repository**

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

**2. Navigate to the project directory**

```bash
cd YOUR_PROJECT_FOLDER
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Configure your API key**

Create an API key from [OpenWeatherMap](https://openweathermap.org/api).

**5. Run the application**

```bash
flutter run
```

## 🔑 API Key Configuration

This application uses the OpenWeatherMap API to retrieve current weather and forecast information.

For security, do not upload your personal API key to a public GitHub repository.

One simple approach is to pass the key through a Dart environment declaration.

Run the application using:

```bash
flutter run --dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY
```

In your Dart service file, read the value using:

```dart
  static const String _apiKey = "yourAPIKey"; // put your own key here
```

Make sure your API service uses this configuration instead of a hard-coded API key.

## 🔮 Future Improvements

- Add the option to save favorite cities.
- Add weather information for multiple locations.
- Improve the forecast UI with charts and visual representations.
- Add weather notifications and alerts.
- Improve network error handling and retry functionality.
- Add more comprehensive unit and widget tests.

## 👨‍💻 Author

**Mahesh Rawat**

Flutter & Dart Developer

---

⭐ If you find this project useful, consider giving it a star!