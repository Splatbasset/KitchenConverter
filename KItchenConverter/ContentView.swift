//
//  ContentView.swift
//  KItchenConverter
//
//  Created by David L. Couch on 12/11/25.
//

import SwiftUI

// MARK: - Glass Card Modifier
/// A custom view modifier that creates a glassmorphic card effect
/// This modifier applies a frosted glass appearance with rounded corners,
/// subtle borders, and shadows to create a modern, translucent design
struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20) // Add internal padding for content spacing
            .background(
                // Create a semi-transparent white background layer
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        // Add a subtle border around the card
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    // Add a soft shadow for depth
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .background(
                // Apply iOS blur material for glassmorphic effect
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
    }
}

/// Extension to easily apply the glass card effect to any view
extension View {
    func glassCard() -> some View {
        self.modifier(GlassCard())
    }
}

struct ContentView: View {
    // MARK: - Models
    
    /// Defines the two main categories of cooking measurements
    /// - volume: Liquid measurements (cups, teaspoons, milliliters, etc.)
    /// - mass: Weight measurements (ounces, pounds, grams, etc.)
    enum UnitCategory: String, CaseIterable, Identifiable {
        case volume = "Volume"
        case mass = "Mass"

        var id: String { rawValue }
    }

    /// Represents a single unit of measurement with conversion information
    /// Each unit stores its conversion factor relative to a base unit:
    /// - For volume: base unit is milliliters (ml)
    /// - For mass: base unit is grams (g)
    struct UnitItem: Identifiable, Hashable {
        let id: String // Unique identifier for the unit
        let name: String // Full name (e.g., "Teaspoon")
        let abbreviation: String // Short form (e.g., "tsp")
        /// Conversion factor to base unit
        /// Example: 1 cup = 236.588 ml, so factorToBase = 236.588
        let factorToBase: Double
    }

    // MARK: - Unit data
    
    /// All available volume units with their conversion factors to milliliters (base unit)
    /// Includes both metric (ml, L) and US customary units (tsp, tbsp, cup, etc.)
    /// All factors are scientifically accurate for cooking measurements
    let volumeUnits: [UnitItem] = [
        UnitItem(id: "ml", name: "Milliliter", abbreviation: "ml", factorToBase: 1),
        UnitItem(id: "l", name: "Liter", abbreviation: "L", factorToBase: 1000),
        UnitItem(id: "tsp", name: "Teaspoon", abbreviation: "tsp", factorToBase: 4.92892),
        UnitItem(id: "tbsp", name: "Tablespoon", abbreviation: "tbsp", factorToBase: 14.7868),
        UnitItem(id: "floz", name: "Fluid Ounce", abbreviation: "fl oz", factorToBase: 29.5735),
        UnitItem(id: "cup", name: "Cup (US)", abbreviation: "cup", factorToBase: 236.588),
        UnitItem(id: "pint", name: "Pint (US)", abbreviation: "pt", factorToBase: 473.176),
        UnitItem(id: "quart", name: "Quart (US)", abbreviation: "qt", factorToBase: 946.353),
        UnitItem(id: "gallon", name: "Gallon (US)", abbreviation: "gal", factorToBase: 3785.41)
    ]

    /// All available mass/weight units with their conversion factors to grams (base unit)
    /// Includes both metric (g, kg) and imperial units (oz, lb)
    let massUnits: [UnitItem] = [
        UnitItem(id: "g", name: "Gram", abbreviation: "g", factorToBase: 1),
        UnitItem(id: "kg", name: "Kilogram", abbreviation: "kg", factorToBase: 1000),
        UnitItem(id: "oz", name: "Ounce", abbreviation: "oz", factorToBase: 28.3495),
        UnitItem(id: "lb", name: "Pound", abbreviation: "lb", factorToBase: 453.592)
    ]

    // MARK: - State
    
    /// The currently selected measurement category (volume or mass)
    @State private var category: UnitCategory = .volume
    
    /// The raw text input from the user (the amount to convert)
    @State private var inputValue: String = ""
    
    /// The unit to convert FROM (e.g., "cup")
    @State private var fromUnit: UnitItem
    
    /// The unit to convert TO (e.g., "ml")
    @State private var toUnit: UnitItem
    
    /// Optional error message to display when input validation fails
    @State private var showError: String? = nil

    // MARK: - Init
    /// Initializes the view with default units
    /// Sets up the initial conversion: cup → ml (common cooking conversion)
    init() {
        // Set default volume units (cup → milliliter is a common cooking conversion)
        let defaultFrom = volumeUnits[5] // cup
        let defaultTo = volumeUnits[0]   // ml
        // Initialize @State properties using the underscore prefix
        _fromUnit = State(initialValue: defaultFrom)
        _toUnit = State(initialValue: defaultTo)
    }

    // MARK: - View
    /// The main view displaying the converter interface with glassmorphic design
    /// Layout: gradient background → scrollable content with glass cards
    var body: some View {
        ZStack {
            // Background: Purple-blue gradient that extends to screen edges
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.45),
                    Color(red: 0.3, green: 0.15, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Title
                    Text("Kitchen Converter")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Category Picker Card
                    VStack(spacing: 16) {
                        Picker("Category", selection: $category) {
                            ForEach(UnitCategory.allCases) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: category) { oldValue, newValue in
                            // Reset the from/to units to sensible defaults for the new category
                            switch newValue {
                            case .volume:
                                fromUnit = volumeUnits.first(where: { $0.id == fromUnit.id }) ?? volumeUnits[5]
                                toUnit = volumeUnits.first(where: { $0.id == toUnit.id }) ?? volumeUnits[0]
                            case .mass:
                                fromUnit = massUnits.first(where: { $0.id == fromUnit.id }) ?? massUnits[0]
                                toUnit = massUnits.first(where: { $0.id == toUnit.id }) ?? massUnits[1]
                            }
                        }
                    }
                    .glassCard()
                    
                    // CARD 2: Input field for entering the amount to convert
                    // Validates input in real-time, showing errors for invalid/negative numbers
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Input")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        HStack {
                            // Text field with decimal keyboard and live validation
                            TextField("Amount", text: $inputValue)
                                .keyboardType(.decimalPad)
                                .onChange(of: inputValue) { oldValue, newValue in validateInput() }
                                .accessibilityLabel("Amount to convert")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.15))
                                )
                            
                            Text(currentFrom.abbreviation)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.leading, 8)
                        }
                        
                        if let err = showError {
                            Text(err)
                                .foregroundColor(.red.opacity(0.9))
                                .font(.caption)
                                .padding(.top, 4)
                        }
                    }
                    .glassCard()
                    
                    // CARD 3: Unit selection (From → To) with swap button
                    // Allows user to choose source and destination units, plus quick swap
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Units")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        VStack(spacing: 12) {
                            // FROM unit picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("From")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                Picker("From", selection: $fromUnit) {
                                    ForEach(currentUnits) { unit in
                                        Text("\(unit.name) (\(unit.abbreviation))").tag(unit)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.white)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.15))
                                )
                            }
                            
                            // SWAP button: Exchanges From and To units for quick reverse conversion
                            Button(action: swapUnits) {
                                HStack {
                                    Spacer()
                                    Image(systemName: "arrow.up.arrow.down")
                                        .font(.system(size: 18, weight: .semibold))
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                )
                            }
                            
                            // TO unit picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("To")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                Picker("To", selection: $toUnit) {
                                    ForEach(currentUnits) { unit in
                                        Text("\(unit.name) (\(unit.abbreviation))").tag(unit)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.white)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.15))
                                )
                            }
                        }
                    }
                    .glassCard()
                    
                    // CARD 4: Result display showing the converted value
                    // Displays large, bold result text with the destination unit abbreviation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Result")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(resultText)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 20)
                    }
                    .glassCard()
                    
                    // FOOTER: Disclaimer and copyright information
                    VStack(spacing: 8) {
                        Text("All conversions are approximate. Units cover common cooking measurements.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        
                        Text("© 2025 Splatbasset. All rights reserved.")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear { validateInput() }
    }

    // MARK: - Helpers
    
    /// Returns the list of units for the currently selected category
    /// - Returns: volumeUnits if category is .volume, massUnits if .mass
    var currentUnits: [UnitItem] {
        category == .volume ? volumeUnits : massUnits
    }

    /// Convenience accessor for the current "from" unit
    var currentFrom: UnitItem { fromUnit }
    
    /// Convenience accessor for the current "to" unit
    var currentTo: UnitItem { toUnit }

    /// Swaps the from and to units, allowing quick reverse conversion
    /// For example, if converting cup → ml, swap makes it ml → cup
    func swapUnits() {
        let tmp = fromUnit
        fromUnit = toUnit
        toUnit = tmp
        validateInput() // Re-validate after swap
    }

    /// Validates the user's input text field
    /// Checks for: empty input, invalid numbers, negative values
    /// Sets showError to display an inline error message when validation fails
    func validateInput() {
        showError = nil
        // Allow empty input (no error shown)
        guard !inputValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // Check if input can be parsed as a number
        guard let parsed = parseNumber(inputValue) else {
            showError = "Enter a valid number"
            return
        }
        // Reject negative numbers (can't have negative cooking measurements)
        if parsed < 0 {
            showError = "Enter a non-negative amount"
        }
    }

    /// Parses a string into a Double using the user's locale settings
    /// This ensures correct handling of decimal separators (. vs ,) based on region
    /// - Parameter string: The text to parse
    /// - Returns: The parsed number, or nil if parsing fails
    func parseNumber(_ string: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue
    }

    /// Converts a value from one unit to another using base unit conversion
    /// Algorithm: value → base unit (ml or g) → destination unit
    /// Example: 2 cups → 473.176 ml → 0.473176 L
    /// - Parameters:
    ///   - value: The amount to convert
    ///   - from: The source unit
    ///   - to: The destination unit
    /// - Returns: The converted value
    func convert(value: Double, from: UnitItem, to: UnitItem) -> Double {
        // Step 1: Convert input value to base unit (ml for volume, g for mass)
        let valueInBase = value * from.factorToBase
        // Step 2: Convert from base unit to destination unit
        let result = valueInBase / to.factorToBase
        return result
    }

    /// Computed property that generates the result text to display
    /// Returns "—" if input is invalid, otherwise returns the formatted conversion result
    var resultText: String {
        guard let parsed = parseNumber(inputValue), showError == nil else {
            return "—" // Em dash indicates no valid result
        }
        let converted = convert(value: parsed, from: fromUnit, to: toUnit)
        return formatNumber(converted) + " \(toUnit.abbreviation)"
    }

    /// Formats a number for display with appropriate decimal precision
    /// Adapts the number of decimal places based on magnitude:
    /// - Large numbers (≥1000): No decimals
    /// - Medium (10-999): 2 decimals
    /// - Small (1-9.99): 3 decimals
    /// - Tiny (<1): 4 decimals
    /// - Parameter value: The number to format
    /// - Returns: Formatted string with appropriate precision
    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        // Adjust decimal places based on magnitude for readability
        if abs(value) >= 1000 {
            formatter.maximumFractionDigits = 0
        } else if abs(value) >= 10 {
            formatter.maximumFractionDigits = 2
        } else if abs(value) >= 1 {
            formatter.maximumFractionDigits = 3
        } else {
            formatter.maximumFractionDigits = 4
        }
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}

#Preview {
    ContentView()
}
