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
                account.getCourts(clearImageCache: false)
            }
        } else if account.responses["reservationsByUserIDFetch"] == 0 {
            ProgressView("Loading Reservations").onAppear {
                account.getReservationsByUserID(userID: account.id)
            }
        }else{
            LazyVStack() {
                ForEach(account.reservations, id: \.id) { i in
                    if (i.date == account.currentDay) {
                        Divider()
                        NavigationLink {
                            ReservationManage(reservation: i, fieldID: i.field, courtID: i.courtID).environmentObject(account)
                        } label: {
                            HStack{
                                HStack{
                                    Text(account.courts[account.courts.firstIndex(where: { court in
                                        return court.id == i.courtID
                                    }) ?? 0].name)
                                }
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
