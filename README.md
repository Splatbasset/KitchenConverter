# Kitchen Converter

A beautiful, modern iOS app for converting cooking measurements between metric and imperial units. Built with SwiftUI and featuring a stunning glassmorphic design.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Overview

Kitchen Converter is a utility app designed to make cooking easier by providing quick, accurate conversions between different measurement units. Whether you're following a recipe from another country or scaling ingredients, this app handles both volume and mass conversions with ease.

## Features

### 📏 Comprehensive Unit Support

**Volume Units:**
- Milliliter (ml)
- Liter (L)
- Teaspoon (tsp)
- Tablespoon (tbsp)
- Fluid Ounce (fl oz)
- Cup (US)
- Pint (US)
- Quart (US)
- Gallon (US)

**Mass Units:**
- Gram (g)
- Kilogram (kg)
- Ounce (oz)
- Pound (lb)

### 🌟 Key Features 🚀

- **⚡ Real-time Conversion**: Results update instantly ⏱️ as you type ⌨️
- **✅ Input Validation**: Smart error handling 🛡️ for invalid or negative numbers 🚫
- **🌍 Locale-Aware**: Respects your region's decimal separator 🔢 (. or ,)
- **🔄 Quick Swap**: One-tap button 👆 to reverse conversion direction ↔️
- **🎯 Adaptive Precision**: Result formatting adjusts 📊 based on magnitude for optimal readability 👓
- **✨ Glassmorphic UI**: Modern, translucent design 💎 with beautiful gradient background 🌈
- **🔀 Category Switching**: Easily toggle 🔛 between volume 💧 and mass ⚖️ measurements

## 📸 Screenshots

*Coming soon*

## 🔧 Technical Details

### 🏗️ Architecture

- **Framework**: SwiftUI
- **Minimum iOS Version**: iOS 17.0+
- **Language**: Swift 5.9+
- **Design Pattern**: MVVM-inspired with declarative UI

### 🧮 Conversion Algorithm

The app uses a two-step conversion process:

1. **Convert to Base Unit**: Input value × source unit factor → base unit (ml for volume, g for mass)
2. **Convert to Target Unit**: Base unit value ÷ target unit factor → result

Example: 2 cups → milliliters → liters
```
2 cups × 236.588 ml/cup = 473.176 ml
473.176 ml ÷ 1000 ml/L = 0.473176 L
```

### 💎 Code Highlights

- **📝 Comprehensive Comments**: Every function, property, and complex section is thoroughly documented
- **🔒 Type Safety**: Strong typing with `UnitItem` struct and `UnitCategory` enum
- **⚡ State Management**: Reactive UI updates with `@State` properties
- **♿ Accessibility**: Proper labels and semantic structure
- **🌐 Localization Ready**: Uses `NumberFormatter` with locale awareness

## 📦 Installation

### ✅ Requirements

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS Sonoma or later (for development)

### 🚀 Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/KitchenConverter.git
```

2. Open the project in Xcode:
```bash
cd KitchenConverter
open KItchenConverter.xcodeproj
```

3. Select your target device or simulator

4. Press `⌘ + R` to build and run

## 📱 Usage

1. **📂 Select Category**: Choose between Volume or Mass measurements
2. **⌨️ Enter Amount**: Type the quantity you want to convert
3. **🎚️ Choose Units**: Select your source unit (From) and destination unit (To)
4. **👀 View Result**: The conversion appears instantly below
5. **🔄 Swap Units**: Tap the swap button (↕) to reverse the conversion direction

## 📁 Project Structure

```
KItchenConverter/
├── KItchenConverter/
│   ├── ContentView.swift          # Main app view with all conversion logic
│   ├── KItchenConverterApp.swift  # App entry point
│   └── Assets.xcassets/           # App icons and colors
├── KItchenConverter.xcodeproj/    # Xcode project files
└── README.md                      # This file
```

## 💻 Code Example

```swift
// Define a unit with conversion factor to base unit
UnitItem(id: "cup", name: "Cup (US)", abbreviation: "cup", factorToBase: 236.588)

// Convert function uses two-step process
func convert(value: Double, from: UnitItem, to: UnitItem) -> Double {
    let valueInBase = value * from.factorToBase
    let result = valueInBase / to.factorToBase
    return result
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines

- Maintain comprehensive code comments
- Follow Swift style guidelines
- Test on multiple iOS versions and device sizes
- Ensure accessibility compliance

## Future Enhancements

Potential features for future versions:

- [ ] Add temperature conversions (Fahrenheit, Celsius, Kelvin)
- [ ] Support for ingredient-specific conversions (e.g., cups of flour → grams)
- [ ] Conversion history
- [ ] Favorite unit pairs
- [ ] Widget support for quick conversions
- [ ] iPad optimization with larger layouts
- [ ] Dark mode variants of gradient backgrounds
- [ ] Unit search/filter for easier selection
- [ ] Imperial cup (UK) support

## License

Copyright © 2025 Splatbasset. All rights reserved.

This project is available for personal and educational use. For commercial use, please contact the author.

## Acknowledgments

- Conversion factors sourced from NIST (National Institute of Standards and Technology)
- UI inspired by modern glassmorphism design trends
- Built with Apple's SwiftUI framework

## Contact

For questions, suggestions, or bug reports, please open an issue on GitHub.

---

**Made with ❤️ for home cooks everywhere**
