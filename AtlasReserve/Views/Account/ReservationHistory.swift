//
//  ReservationHistory.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/20/24.
//

import SwiftUI

struct ReservationHistory: View {
    @EnvironmentObject var account: Account
    private var courtID: Int
    init(courtID: Int) {
        self.courtID = courtID
    }
    var body: some View {
        if account.responses["archivedReservationsFetch"] == 0 {
            ProgressView("Fetching Archived Reservations").onAppear {
                // TODO: add functionality
            }
        } else {
            
        }
    }
}
/*
#Preview {
    ReservationHistory()
}
*/
