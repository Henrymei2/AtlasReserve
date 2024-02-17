//
//  ReservationManageView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/17/24.
//

import SwiftUI

struct ReservationManageView: View {
    @EnvironmentObject var account: Account
    private var court: Court;
    init(court: Court) {
        self.court = court
    }
    var body: some View {
        if account.responses["reservationsByCourtIDFetch"] == 0 {
            ProgressView("Loading Reservations").onAppear {
                account.getReservationsByCourtID(courtID: self.court.id)
            }
        } else {
            List {
                ForEach(account.reservations, id:\.id) { reservation in
                    Text(String(reservation.id))
                }
            }
        }
        
    }
}

//#Preview {
//    //ReservationManageView().environmentObject(Account())
//}
