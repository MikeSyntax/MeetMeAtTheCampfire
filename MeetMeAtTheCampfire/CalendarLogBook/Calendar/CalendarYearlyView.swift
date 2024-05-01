//
//  CalendarYearlyView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 18.03.24.
//

import SwiftUI

struct CalendarYearlyView: View {
    
    @State private var year = Date().getFirstDateOfYear()
    @State private var scrollPosition: Int? = nil
    @State private var showInfoSheet: Bool = false
    @State private var isAnimating: Bool = false
    @AppStorage("infoButton") private var infoButtonIsActive: Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Divider()
                    WeekdayHeaderView()
                    ScrollView {
                        VStack{
                            ForEach(year.getAllMonths(), id:  \.self) { month in
                                CalendarMonthlyView(month: month)
                                    .id(month.get(.month))
                            }
                        }
                    }
                    Divider()
                }
                if infoButtonIsActive {
                    VStack{
                        Button{
                            showInfoSheet.toggle()
                        } label: {
                            CalendarInfoButtonView()
                        }
                        .rotationEffect(Angle(degrees: isAnimating ? -0 : 20))
                        .animation(Animation.easeInOut(duration: 0.3).repeatCount(7, autoreverses: true), value: isAnimating)
                    }
                    .offset(x: 130, y: 180)
                    .onAppear {
                        isAnimating = true
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    YearSwitcher(year: $year)
                }
            }
            .onAppear {
                scrollPosition = Int(Date().get(.month))
            }
            .scrollPosition(id: $scrollPosition)
            .navigationBarTitle("Mein Logbuch \(CalendarUtils.getYearCaption(year))", displayMode: .inline)
            .scrollContentBackground(.hidden)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.2)
                    .ignoresSafeArea(.all))
        }
        .onDisappear{
            isAnimating = false
        }
        .sheet(isPresented: $showInfoSheet, onDismiss: nil) {
            CalendarInfoSheetView(showInfoSheet: $showInfoSheet)
                .presentationDetents([.medium])
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview{
    CalendarYearlyView()
}

//MARK --------------------------------------------------------------------------------------------------------------------------------------------------

private struct WeekdayHeaderView: View {
    
    private var weekdays = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
            }
        }
    }
}

//MARK ---------------------------------------------------------------------------------------------------------------------------------------------------

private struct CalendarMonthlyView: View {
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var month: Date
    
    var body: some View {
        VStack {
            Text(CalendarUtils.getMonthCaption(month))
                .font(.title2)
                .padding(.leading, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(0..<month.getWeekday(), id: \.self) { _ in
                    Spacer()
                }
                ForEach(month.getAllDaysToNextMonth(), id: \.self){ day in
                    NavigationLink(destination: NavigationLazyView(destinationView(for: day))) {
                        CalendarDailyView(day: day)
                    }
                }
            }
        }
    }
    private func destinationView(for date: Date) -> some View {
        let calendarDetailItemVm = CalendarDetailItemViewModel(calendarItemModel: LogBookModel(userId: "1", formattedDate: "123", logBookText: "", latitude: 0.47586, longitude: 0.883626, imageUrl: "", containsLogBookEntry: false), date: date)
        return CalendarDetailItemView(calendarDetailItemVm: calendarDetailItemVm)
    }
}

//MARK ---------------------------------------------------------------------------------------------------------------------------------------------------

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

//MARK ----------------------------------------------------------------------------------------------------------------------------------------------------

private struct CalendarDailyView: View {
    
    var day: Date
    let weekendColor = Color.gray
    
    var body: some View {
        Text("\(day.get(.day))")
            .foregroundStyle(day.isWeekend() ? weekendColor : .primary)
            .background {
                if day.isToday() {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
            }
    }
}

//MARK ---------------------------------------------------------------------------------------------------------------------------------------------------

private struct YearSwitcher: View {
    
    @Binding var year: Date
    
    var body: some View {
        HStack {
            Button("-") {
                year = year.getPreviousYear()
            }
            Text(CalendarUtils.getYearCaption(year))
            Button("+") {
                year = year.getNextYear()
            }
        }
    }
}

//MARK ---------------------------------------------------------------------------------------------------------------------------------------------------

class CalendarUtils {
    
    //Month Formatter
    private static var monthFormatter = createMonthFormatter()
    
    static func getMonthCaption(_ date: Date) -> String {
        let result = monthFormatter.string(from: date)
        
        func getGermanMonth(_ result: String) -> String {
            switch result {
            case "January":
                return "Januar"
            case "February":
                return "Februar"
            case "March":
                return "März"
            case "April":
                return "April"
            case "May":
                return "Mai"
            case "June":
                return "Juni"
            case "July":
                return "Juli"
            case "August":
                return "August"
            case "September":
                return "September"
            case "October":
                return "Oktober"
            case "November":
                return "November"
            case "December":
                return "Dezember"
            default:
                return "Unknown"
            }
        }
        return getGermanMonth(result)
    }
    
    private static func createMonthFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    //Year Formatter
    private static var yearFormatter = createYearFormatter()
    
    static func getYearCaption(_ date: Date) -> String {
        return yearFormatter.string(from: date)
    }
    
    private static func createYearFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
        //Day Formatter
        private static var dayFormatter = createDayFormatter()
    
        static func getDayCaption(_ date: Date) -> String {
            return dayFormatter.string(from: date)
        }
    
        private static func createDayFormatter() -> DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "DD"
            return formatter
        }
}

