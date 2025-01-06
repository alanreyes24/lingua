import Foundation
import SwiftData

class CalendarManager: ObservableObject {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Ensures that Day objects for the "year-month" of `date` exist in the database.
    /// If none exist, generate them and save to SwiftData.
    func ensureMonthDataExists(for date: Date) {
        Task { @MainActor in
            do {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: date)
                
                guard let year = components.year, let month = components.month else {
                    throw NSError(domain: "CalendarDataManager",
                                  code: 1,
                                  userInfo: [NSLocalizedDescriptionKey: "Invalid year or month from Date()"])
                }
                
                // Check if we already have Day objects for this year-month
                let fetch = FetchDescriptor<Day>(
                    predicate: #Predicate { $0.year == year && $0.month == month }
                )
                let existingDays = try modelContext.fetch(fetch)
                
                // If none exist, create them
                if existingDays.isEmpty {
                    let newDays = try retrieveCurrentMonthDetails(for: date)
                    
                    // Insert into SwiftData
                    for dayObj in newDays {
                        modelContext.insert(dayObj)
                    }
                    
                    // Save changes
                    try modelContext.save()
                    print("Created new Day entries for \(year)-\(month).")
                } else {
                    print("Day entries for \(year)-\(month) already exist in SwiftData.")
                }
            } catch {
                print("Failed to ensure month data exists: \(error.localizedDescription)")
            }
        }
    }
    
    /// Generates an array of new Day objects (one for each day) for the given date's month.
    /// No SwiftData calls are here; it's just an in-memory builder.
    ///
    private func retrieveCurrentMonthDetails(for date: Date) throws -> [Day] {
        var monthArray: [Day] = []
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let year = components.year, let month = components.month else {
            throw NSError(domain: "CalendarDataManager",
                          code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid year or month from Date()"])
        }
        
        // Find how many days are in this month
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            throw NSError(domain: "CalendarDataManager",
                          code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to find number of days in month."])
        }
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale.current
        weekdayFormatter.dateFormat = "EEEE"
        
        // For each day in the month's range, build a Day object
        for dayNumber in range {
            var dayComponents = DateComponents()
            dayComponents.year = year
            dayComponents.month = month
            dayComponents.day = dayNumber
            
            if let exactDate = calendar.date(from: dayComponents) {
                let weekdayName = weekdayFormatter.string(from: exactDate)
                
                let newDay = Day(
                    year: year,
                    month: month,
                    day: dayNumber,
                    dayOfWeek: weekdayName
                )
                monthArray.append(newDay)
            }
        }
        
        return monthArray
    }
}
