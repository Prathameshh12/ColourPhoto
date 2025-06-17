import SwiftUI

class ColorManager: ObservableObject {
    @Published var todayColor: Color = .clear

    private let colorKey = "dailyColor"
    private let dateKey = "colorDate"

    init() {
        loadTodayColor()
    }

    func loadTodayColor() {
        let today = Self.dateString(for: Date())
        let savedDate = UserDefaults.standard.string(forKey: dateKey)

        if today != savedDate {
            let newColor = Self.generateRandomColor()
            todayColor = newColor
            saveColor(newColor)
            UserDefaults.standard.set(today, forKey: dateKey)
        } else if let data = UserDefaults.standard.data(forKey: colorKey),
                  let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor {
            todayColor = Color(uiColor)
        }
    }

    private func saveColor(_ color: Color) {
        let uiColor = UIColor(color)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: colorKey)
        }
    }

    private static func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func generateRandomColor() -> Color {
        Color(red: .random(in: 0.3...0.9),
              green: .random(in: 0.3...0.9),
              blue: .random(in: 0.3...0.9))
    }
}
