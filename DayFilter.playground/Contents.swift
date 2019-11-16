import UIKit

//var dayNames = ["This Afternoon", "Monday", "Holiday", "Wednesday", "Thursday"]
//var dayPlusNight = ["Sunday", "Sunday Night", "Monday", "Monday Night", "Tuesday", "Tuesday Night", "Wednesday", "Holiday"]
//var dayPlusNight = ["Holiday", "Holiday", "Holiday", "Holiday", "Holiday", "Holiday", "Holiday", "Holiday"]
var nightNames = ["Tonight", "Holiday", "Tuesday Night", "Wednesday Night", "Thursday Night"]

// Mode values: Day, Night, Day+Night
func filterValid(days: [String], displayMode: String) -> [String] {
    
    var dayList: [String?] = []
    var isDayNil: Bool = false
    
    for day in days {
        switch day {
        case "Overnight", "Tonight", "Today", "This Afternoon": fallthrough
        case "Sunday", "Sunday Night": fallthrough
        case "Monday", "Monday Night": fallthrough
        case "Tuesday", "Tuesday Night": fallthrough
        case "Wednesday", "Wednesday Night": fallthrough
        case "Thursday", "Thursday Night": fallthrough
        case "Friday", "Friday Night": fallthrough
        case "Saturday", "Saturday Night": dayList.append(day)
        default:
            let dayItem = mapDay(item: day)
            dayList.append(dayItem)
            if dayItem == nil {
                isDayNil = true
            }
        }
    }
    
    if isDayNil == true {
        dayList = removeNilDay(list: dayList, mode: displayMode)
    }
 
    for (index, dayName) in dayList.enumerated() {
        dayList[index] = trim(day: dayName ?? "")
    }
    return dayList.compactMap({$0})
}

func trim(day: String) -> String? {
    
    var trimName: String? = nil
    
    switch(day) {
    case "Overnight", "Tonight": trimName = "Nite"
    case "Today" : trimName = "Today"
    case "This Afternoon" : trimName = "Noon"
    case "Sunday", "Sunday Night" : trimName = "Sun"
    case "Monday", "Monday Night" : trimName = "Mon"
    case "Tuesday", "Tuesday Night" : trimName = "Tues"
    case "Wednesday", "Wednesday Night" : trimName = "Wed"
    case "Thursday", "Thursday Night" : trimName = "Thurs"
    case "Friday", "Friday Night" : trimName = "Fri"
    case "Saturday", "Saturday Night" : trimName = "Sat"
    default:
        trimName = nil
    }
    return trimName
}

func mapDay(item: String) -> String? {
    
    var day: String? = String()
    
    switch item {
    case "Veterans Day": day = "Monday"
    case "Thanksgiving Day": day = "Thursday"
    default:
        day = nil
    }
    return day
}

func removeNilDay(list: [String?], mode: String) -> [String] {
    
    var noNilDays: [String?] = []
    
    // Create a mutable copy of dayNames array
    for day in list {
        noNilDays.append(day)
        if let weekday = day {
            print("weekDay: \(weekday)")
        } else {
            print("weekDayNil: nil")
        }
    }
    
   var index = noNilDays.startIndex
    while index < noNilDays.endIndex {
        print("index: \(index)")
        switch noNilDays[index] {
        case nil:
           // Check if index is the last index
            if index == noNilDays.endIndex - 1 {
                print("index == last index, index: \(index)")
                if isValid(day: noNilDays[index - 1]) {
                    let nextDay = next(day: noNilDays[index - 1], display: mode)
                    print("nextDay: \(nextDay ?? "")")
                    noNilDays[index] = nextDay
                    index = index + 1
                    continue
                } else {
                    // Exit while loop as no solution can be found
                    index = index + 1
                    continue
                }
            } else {
                // Go to the previous index and check if it is valid
               if index > noNilDays.startIndex && isValid(day: noNilDays[index - 1]) {
                    let nextDay = next(day: noNilDays[index - 1], display: mode)
                    if nextDay == nil {
                        index = index + 1
                        continue
                    } else {
                        print("nextDay: \(nextDay ?? "")")
                        noNilDays[index] = nextDay
                        index = 0
                        continue
                    }
                } else
                // Go to the next value and check if it is valid
                if index < noNilDays.endIndex - 1 && isValid(day: noNilDays[index + 1]) {
                    let previousDay = previous(day: noNilDays[index + 1], display: mode)
                    if previousDay == nil {
                        index = index + 1
                        continue
                    } else {
                        print("previousDay: \(previousDay ?? "")")
                        noNilDays[index] = previousDay
                        index = 0                              // Start over and check for nils
                        continue
                    }
                } else {
                    index = index + 1
                    continue
                }
            }
        default:
            index = index + 1
        }
    } // while
 
    return noNilDays.compactMap({$0})                      // Return non-optional array type
}

func next(day: String?, display: String) -> String? {
    
    var next: String? = String()
    
    if display == "Day" {
        switch day {
        case "Sunday": next = "Monday"
        case "Monday": next = "Tuesday"
        case "Tuesday": next = "Wednesday"
        case "Wednesday": next =  "Thursday"
        case "Thursday": next = "Friday"
        case "Friday": next = "Saturday"
        case "Saturday": next = "Sunday"
        default:
            next = nil
        }
    }
    else if display == "Night" {
        switch day {
        case "Saturday Night": next = "Sunday Night"
        case "Sunday Night": next = "Monday Night"
        case "Monday Night": next = "Tuesday Night"
        case "Tuesday Night": next =  "Wednesday Night"
        case "Wednesday Night": next = "Thursday Night"
        case "Thursday Night": next = "Friday Night"
        case "Friday Night": next = "Saturday Night"
        default:
            next = nil
        }
    }
    else if display == "Day+Night" {
        switch day {
        case "Sunday": next = "Sunday Night"
        case "Monday": next = "Monday Night"
        case "Tuesday": next = "Tuesday Night"
        case "Wednesday": next =  "Wednesday Night"
        case "Thursday": next = "Thursday Night"
        case "Friday": next = "Friday Night"
        case "Saturday": next = "Saturday Night"
        case "Sunday Night": next = "Monday"
        case "Monday Night": next = "Tuesday"
        case "Tuesday Night": next = "Wednesday"
        case "Wednesday Night": next =  "Thursday"
        case "Thursday Night": next = "Friday"
        case "Friday Night": next = "Saturday"
        case "Saturday Night": next = "Sunday"
        default:
            next = nil
        }
    }
    return next
}

func previous(day: String?, display: String) -> String? {
    
    var previous: String? = String()
    
    if display == "Day" {
        switch day {
        case "Sunday": previous = "Saturday"
        case "Monday": previous = "Sunday"
        case "Tuesday": previous = "Monday"
        case "Wednesday": previous =  "Tuesday"
        case "Thursday": previous = "Wednesday"
        case "Friday": previous = "Thursday"
        case "Saturday": previous = "Friday"
        default: previous = nil
        }
    }
    else if display == "Night" {
        switch day {
        case "Sunday Night": previous = "Saturday Night"
        case "Monday Night": previous = "Sunday Night"
        case "Tuesday Night": previous = "Monday Night"
        case "Wednesday Night": previous =  "Tuesday Night"
        case "Thursday Night ": previous = "Wednesday Night"
        case "Friday Night": previous = "Thursday Night"
        case "Saturday Night": previous = "Friday Night"
        default: previous = nil
        }
    }
    else if display == "Day+Night" {
        switch day {
        case "Sunday": previous = "Saturday Night"
        case "Monday": previous = "Sunday Night"
        case "Tuesday": previous = "Monday Night"
        case "Wednesday": previous =  "Tuesday Night"
        case "Thursday": previous = "Wednesday Night"
        case "Friday": previous = "Thursday Night"
        case "Saturday": previous = "Friday Night"
        case "Sunday Night": previous = "Sunday"
        case "Monday Night": previous = "Monday"
        case "Tuesday Night": previous = "Tuesday"
        case "Wednesday Night": previous = "Wednesday"
        case "Thursday Night": previous = "Thursday"
        case "Friday Night": previous = "Friday"
        case "Saturday Night": previous = "Saturday"
        default:
            previous = nil
        }
    }
    return previous
}

func isValid(day: String?) -> Bool {
    
    var validDay: Bool = false
    
    switch day {
    case "Sunday", "Sunday Night": fallthrough
    case "Monday", "Monday Night": fallthrough
    case "Tuesday", "Tuesday Night": fallthrough
    case "Wednesday", "Wednesday Night": fallthrough
    case "Thursday", "Thursday Night": fallthrough
    case "Friday", "Friday Night": fallthrough
    case "Saturday", "Saturday Night": validDay = true
    default:
        validDay = false
    }
    return validDay
}

let filtered = filterValid(days: nightNames, displayMode: "Night")

// Display final list of valid days
for day in filtered {
    print("day: \(day)")
}
