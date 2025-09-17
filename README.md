# ReelFaces

A Flutter app that showcases popular people from The Movie Database (TMDB) with beautiful image viewing and saving capabilities.

## Features

- 🎬 **Popular People Discovery** - Browse trending actors and celebrities from TMDB
- 🖼️ **High-Quality Image Viewer** - Full-screen image viewing with zoom and pan support
- 💾 **Image Saving** - Save images to your device with proper permission handling
- 📱 **Responsive Design** - Optimized for different screen sizes using ScreenUtil
- 🌙 **Dark Theme** - Beautiful dark theme optimized for media viewing
- 🔄 **Offline Caching** - Hive-based caching for better performance
- 🌍 **Internationalization** - Multi-language support ready
- ⚡ **Modern Architecture** - Clean architecture with BLoC pattern

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- TMDB API key

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd reelfaces
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure environment variables**

   ```bash
   # Copy the example environment file
   cp config/.env.example .env

   # Edit .env with your TMDB API credentials
   nano .env
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

The app requires TMDB API credentials to function. Create a `.env` file in the project root with the following variables:

```env
# The Movie Database (TMDB) API Key
TMDB_API_KEY=your_tmdb_api_key_here

# The Movie Database (TMDB) Access Token (v4)
TMDB_ACCESS_TOKEN=your_tmdb_access_token_here

# Default language for API responses (ISO 639-1 code, e.g., en, ar, fr)
DEFAULT_LANGUAGE=en
```

### Getting TMDB API Credentials

1. Visit [TMDB API](https://www.themoviedb.org/settings/api)
2. Create an account or log in
3. Request an API key
4. Copy your API key and access token to the `.env` file

## Usage

### Running the App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

### Building the App

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS (macOS only)
flutter build ios
```

### Key Features Usage

- **Browse People**: Scroll through the home screen to discover popular people
- **View Details**: Tap on any person to see their detailed information
- **View Images**: Tap on profile images to open the full-screen viewer
- **Save Images**: Use the save button to download images to your device
- **Zoom & Pan**: Pinch to zoom and drag to pan in the image viewer

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── db/                 # Database services (Hive)
│   ├── dependency_injection/ # DI setup
│   ├── domain/             # Domain entities
│   ├── network/            # Network services
│   ├── routing/            # App routing
│   ├── services/           # Core services
│   └── utils/              # Utilities and helpers
├── features/               # Feature modules
│   ├── home/               # Popular people listing
│   ├── person_details/     # Person detail view
│   └── image_viewer/       # Image viewing and saving
└── main.dart              # App entry point
```

## Dependencies

### Core Dependencies

- **flutter_bloc** - State management
- **dio** - HTTP client
- **hive** - Local database
- **get_it** - Dependency injection
- **permission_handler** - Device permissions
- **path_provider** - File system access

### UI Dependencies

- **flutter_screenutil** - Responsive design
- **flutter_localization** - Internationalization

## Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Add tests** (if applicable)
5. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Code Style

- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure all tests pass
- Follow the existing architecture patterns

### Pull Request Guidelines

- Provide a clear description of changes
- Include screenshots for UI changes
- Ensure the app builds and runs successfully
- Test on both Android and iOS (if possible)

## Development

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/db/hive_service_test.dart
```

### Code Generation

```bash
# Generate Hive adapters
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### Debugging

```bash
# Run in debug mode with verbose logging
flutter run --debug --verbose
```

## Troubleshooting

### Common Issues

1. **API Key Issues**

   - Ensure your `.env` file is in the project root
   - Verify your TMDB API key is valid
   - Check that the `.env` file is included in `pubspec.yaml`

2. **Permission Issues**

   - Grant storage permissions when prompted
   - Check device settings if images aren't saving

3. **Build Issues**
   - Run `flutter clean` and `flutter pub get`
   - Ensure you have the correct Flutter version

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [The Movie Database (TMDB)](https://www.themoviedb.org/) for providing the API
- [Flutter](https://flutter.dev/) for the amazing framework
- All contributors and the open-source community

---

**Made with ❤️ using Flutter**
