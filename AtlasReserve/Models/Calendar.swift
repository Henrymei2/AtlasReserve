//  Reference: https://gist.github.com/mecid/f8859ea4bdbd02cf5d440d58e936faec#file-calendar-swift
//  Author: mecid
import SwiftUI

extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    static var yearMonthDay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date) -> DateView

    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let showHeader: Bool
    let content: (Date) -> DateView

    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return Text(formatter.string(from: month))
            .font(.title)
            .padding(.horizontal)
    }

    var body: some View {
        VStack {
            if showHeader {
                header
            }

            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date) -> DateView
    let yearMonthDayFormatter = DateFormatter.yearMonthDay
    let timeFormatter = DateFormatter()
    @State var selectedDay: Date = Date()
    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
        self.timeFormatter.dateFormat = "HH:mm"
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
                
                ScrollView(.vertical, showsIndicators: true) {
                    HStack {
                        Circle().frame(width: 15, height:15).foregroundStyle(.blue)
                        Text("Selected Day")
                        Circle().frame(width: 15, height:15).foregroundStyle(.green)
                        Text("Day that has reservation")
                    }
                    VStack {
                        ForEach(months, id: \.self) { month in
                            MonthView(month: month, content: self.content)
                        }
                    }
                    Divider()
                }.frame(height: UIScreen.main.bounds.height / 3)
                    .scrollIndicators(.visible)
                
            
        

    }
}

struct RootView: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var account: Account
    private var year: DateInterval {
        return DateInterval(start: Date(), end: Date().advanced(by: 3600 * 24 * 31))
    }
    private var reservationDates: [Date]
    init(reservationDates: [Date]) {
        self.reservationDates = reservationDates
    }

    var body: some View {
        CalendarView(interval: year) { date in
            if account.currentDay == date {
                Text("30")
                    .hidden()
                    .padding(8)
                    .background(Color.red)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.blue, lineWidth: 3))
                    .overlay(Circle().foregroundStyle(.blue)
                        .shadow(color:.gray, radius: 2, x:2, y:1))
                    .padding(.vertical, 4)
                    .overlay(
                        Button(action: {account.currentDay = date}){
                            Text(String(self.calendar.component(.day, from: date)))
                        }.foregroundColor(.white)
                        
                    )
            }
            else if reservationDates.contains(date) {
                Text("30")
                    .hidden()
                    .padding(8)
                    .background(Color.red)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.blue, lineWidth: 5))
                    .overlay(Circle().foregroundStyle(.green)
                        .shadow(color:.gray, radius: 2, x:2, y:1))
                    .padding(.vertical, 4)
                    .overlay(
                        Button(action: {account.currentDay = date}){
                            Text(String(self.calendar.component(.day, from: date)))
                        }.foregroundColor(.white)
                        
                    )
            } else {
                Text("30")
                    .hidden()
                    .padding(8)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.blue, lineWidth: 3))
                    .overlay(Circle().foregroundStyle(.white)
                        .shadow(color:.gray, radius: 2, x:2, y:1))
                    .padding(.vertical, 4)
                    .overlay(
                        Button(action: {account.currentDay = date}){
                            Text(String(self.calendar.component(.day, from: date)))
                        }.foregroundColor(.blue)
                        
                    )
            }
        }
    }
}
struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        RootView(reservationDates: Account().resDates).environmentObject(Account())
    }
}
