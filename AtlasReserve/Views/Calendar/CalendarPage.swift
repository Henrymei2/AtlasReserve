//
//  CalendarPage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/23/23.
//

import SwiftUI

struct CalendarPage: View {
    @EnvironmentObject var account: Account
    var body: some View {
        VStack{
            HStack {
                Text("Calendar")
                    .font(.largeTitle).bold()
                    .fontDesign(.serif)
                Spacer()
            }.padding(.horizontal)
            RootView(reservationDates: account.resDates).environmentObject(account)
            
        ScrollView {
            
            Text("Reservations on ").font(.largeTitle)
            Text(DateFormatter.yearMonthDay.string(from: account.currentDay)).font(.title)
            Text("Pull Down to refresh")
            ReservationView().environmentObject(account)
        }.refreshable {
            account.responses["reservationsByUserIDFetch"] = 0
        }
            
        }.padding(.horizontal)
    }
}

struct CalendarPage_Previews: PreviewProvider {
    static var previews: some View {
        CalendarPage().environmentObject(Account())
    }
}
