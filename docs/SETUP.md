# Setup & Installation Guide

Follow these steps to get the HapoPay mobile application running on your local machine.

## Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| Flutter SDK | 3.22.0+ | Install via [flutter.dev](https://flutter.dev) |
| Dart | 3.4.0+ | Bundled with Flutter SDK |
| Android Studio | Hedgehog+ | For Android emulator & SDK manager |
| Xcode | 15+ | macOS only — required for iOS builds |
| Django Backend | Running | API layer on `http://localhost:8000/api` |

## Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/HapoTV/hapo-pay.git
   cd hapo-pay/mobile
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   Create a `.env.dev` file from the example:
   ```bash
   cp .env.example .env.dev
   ```
   Fill in your credentials:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `API_BASE_URL`

4. **Run Code Generation**
   HapoPay uses Riverpod with code generation. Run this command to generate the necessary files:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Running the App

```bash
# Verify environment health
flutter doctor

# Run on a connected device or emulator
flutter run --dart-define-from-file=.env.dev
```

## Troubleshooting

- **Android Emulator connection**: If `localhost` doesn't work, use `10.0.2.2`.
- **Realtime issues**: Ensure Supabase Replication is enabled for your tables.
- **Keystore errors**: Check `android/key.properties` exists for release builds.
