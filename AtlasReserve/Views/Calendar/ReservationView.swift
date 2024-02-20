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
    init() {
        timeFormatter.dateFormat = "HH:mm"
    }
    var body: some View {
        if account.responses["courtFetch"] == 0 {
            ProgressView("Loading Courts").onAppear {
                account.getCourts()
            }
        } else if account.responses["reservationsByUserIDFetch"] == 0 {
            ProgressView("Loading Reservations").onAppear {
                account.getReservationsByUserID(userID: account.id)
            }
        } else {
            LazyVStack() {
                ForEach(account.reservations, id: \.id) { i in
                    if (i.date == account.currentDay) {
                        Divider()
                        HStack{
                            Text(account.courts[account.courts.firstIndex(where: { court in
                                return court.id == i.courtID
                            }) ?? 0].name)
                            Text(String(i.resType))
                        }
                        HStack{
                            Text(i.startTime + "-" + i.endTime)
                        }
                    }
                }
            }
            Divider()
            
        }
    }
}

#Preview {
    ReservationView().environmentObject(Account())
}
