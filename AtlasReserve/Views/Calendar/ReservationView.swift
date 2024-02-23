//
//  ReservationView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/11/24.
//

import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var account: Account
    private let timeFormatter = DateFormatter()
    private var onlyToday: Bool = false
    init(onlyToday: Bool = false) {
        timeFormatter.dateFormat = "HH:mm"
        self.onlyToday = onlyToday
    }
    var body: some View {
        if account.responses["courtFetch"] == 0 {
            ProgressView("Loading Courts").onAppear {
                account.getCourts(clearImageCache: false)
            }
        } else if account.responses["reservationsByUserIDFetch"] == 0 {
            ProgressView("Loading Reservations").onAppear {
                account.getReservationsByUserID(userID: account.id)
            }
        }else{
            LazyVStack() {
                ForEach(account.reservations, id: \.id) { i in
                    if !self.onlyToday || i.date == DateFormatter.yearMonthDay.date(from: DateFormatter.yearMonthDay.string(from:Date())) {
                        Divider()
                        NavigationLink {
                            ReservationManage(reservation: i, fieldID: i.field, courtID: i.courtID).environmentObject(account)
                        } label: {
                            HStack{
                                Text(DateFormatter.yearMonthDay.string(from: i.date))
                                Text(i.startTime + "-" + i.endTime)
                                
                                Image(systemName: "chevron.right").padding()
                                    .frame(alignment: .trailing)
                                    .foregroundStyle(.blue)
                            }.foregroundStyle(.black)
                        }
                        
                    }
                }
                
            }
            Divider()
            
        }
    }
}

#Preview {
    NavigationStack {
        ReservationView().environmentObject(Account())
    }
}
