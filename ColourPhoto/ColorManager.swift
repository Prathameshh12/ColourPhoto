//
//  ColorManager.swift
//  ColourPhoto
//
//  Created by Prathamesh Ahire on 12/6/2025.
//


//
//  ColorManager.swift
//  colourLook
//
//  Created by Prathamesh Ahire on 29/5/2025.
//


import SwiftUI

class ColorManager: ObservableObject {
    @Published var todayColor: Color = .clear
    private let colorKey = "dailyColor"
    private let dateKey = "colorDate"

    init() {
        loadTodayColor()
    }

    func loadTodayColor() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let savedDate = UserDefaults.standard.string(forKey: dateKey)

        if today != savedDate {
            let newColor = generateRandomColor()
            todayColor = newColor
            saveColor(newColor)
            UserDefaults.standard.set(today, forKey: dateKey)
        } else {
            if let colorData = UserDefaults.standard.data(forKey: colorKey),
               let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                todayColor = Color(uiColor)
            }
        }
    }

    private func saveColor(_ color: Color) {
        let uiColor = UIColor(color)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: colorKey)
        }
    }

    private func generateRandomColor() -> Color {
        Color(red: Double.random(in: 0.3...1),
              green: Double.random(in: 0.3...1),
              blue: Double.random(in: 0.3...1))
    }
}
