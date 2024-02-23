//
//  FieldView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/2/24.
//

import SwiftUI

struct FieldView: View {
    @EnvironmentObject var account: Account
    var currentDay: String = "Monday"
    var nextDate: Date = Date()
    var field: Field;
    let timeFormatter: DateFormatter = DateFormatter()
    let dateFormatter: DateFormatter = DateFormatter.yearMonthDay
    init(field : Field) {
        self.field = field
        self.timeFormatter.dateFormat = "HH:mm"
        var curr = Calendar.current.component(.weekday, from: Date()) - 2
        if curr < 0 { // Sunday would be -1
            curr = 6 // while it should be 6
        }
        currentDay = (field.availability == curr) ? "Today" : DayOfWeek.convert(from: field.availability)
        var dateComponents = DateComponents()
        dateComponents.day = self.field.availability < curr ? self.field.availability + 7 - curr : (self.field.availability - curr)
        nextDate = Calendar.current.date(byAdding: dateComponents, to: Calendar.current.startOfDay(for: Date())) ?? Date()
    
    }
    var body: some View {
        NavigationStack{
            Divider()
            HStack{
                if (!(account.responses["fieldAvailableFetch"] == 1)) {
                    LoadingView()
                } else {
                    VStack{
                        HStack{
                            Text(FieldType.convert[field.type]!)
                            Spacer()
                        }
                        HStack{
                            Text(LocalizedStringKey(currentDay))
                            Text(timeFormatter.string(from: field.startTime)).font(.callout).foregroundStyle(.gray)
                            Text("-")
                            Text(timeFormatter.string(from: field.endTime)).font(.callout).foregroundStyle(.gray)
                            Spacer()
                        }
                        HStack {
                            Text(dateFormatter.string(from: nextDate))
                            Spacer()
                        }
                    }
                    Spacer()
                    if (field.isAvailableNow) {
                        NavigationLink(destination:     RequestResult(
                            loadingText: "Trying to make a reservation...", responseKey: "reserve", successCode: 3, fail: { code in
                                //print(code);
                                return Text(code == 1 ? "This field becomes full as you are reserving or you have already reserved this field at this date" : "An error occured while updating the database")
                            }
                        ).environmentObject(account).onAppear {
                            account.reserveCourt(fieldID: field.id, date: nextDate)
                        }) {
                            Button("Reserve"){}.disabled(true)
                                .foregroundStyle(.blue)
                                .buttonStyle(.borderedProminent)
                        }
                    } else {
                        Text("Full")
                            .foregroundStyle(.gray)
                    }
                }
            }.padding(.horizontal)
        }.padding(.horizontal)
            .onAppear {
                // Get the availability status of the current Field
                let group2 = DispatchGroup() // This group is for fetching the reserve status of the court
                var availableFieldCount = 0
                let availableFieldUrl = URL(string: "https://atlasreserve.ma/index.php")!
                var availableFieldRequest = URLRequest(url: availableFieldUrl)
                let availableFieldParameters: String = "type=GETFIELDAVAILABILITY&date=\(dateFormatter.string(from: nextDate))&fieldID=\(self.field.id)"
                availableFieldRequest.httpMethod = "POST"
                availableFieldRequest.httpBody = availableFieldParameters.data(using:.utf8)
                group2.enter()
                DispatchQueue.global(qos:.default).async {
                    account.getFieldAvailability(withRequest: availableFieldRequest) {
                        data in
                        availableFieldCount = data ?? 0
                        group2.leave()
                    }
                }
                group2.notify(queue: DispatchQueue.main) {
                    self.field.isAvailableNow = availableFieldCount > 0
                    account.responses["fieldAvailableFetch"] = 1
                }
            }
        
    }
}

#Preview {
    FieldView(field: Field(id: 3, type: 5, startTime: "12:12:12", endTime: "12:34:12", availability: 5, count: 1, courtID: 1)).environmentObject(Account())
}
