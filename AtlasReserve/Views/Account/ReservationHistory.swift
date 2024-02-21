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
    private var asOwner: Bool
    init(courtID: Int) {
        self.courtID = courtID // courtID can be -1 -> user
        self.asOwner = courtID >= 0
    }
    var body: some View {
        if account.responses["archivedReservationsFetch"] == 0 {
            ProgressView("Fetching Archived Reservations").onAppear {
                if self.courtID >= 0 {
                    account.getArchivedReservations(isCourtOwner: true, id: self.courtID)
                } else {
                    account.getArchivedReservations(isCourtOwner: false, id: account.id)
                }
            }
        } else {
            ScrollView{
                if account.archives.count > 0 {
                    ForEach(account.archives, id: \.resID) { archive in
                        Divider()
                        if self.courtID >= 0 || archive.userID == account.id {
                            NavigationLink {
                                ArchiveView(archive: archive, asOwner: asOwner).environmentObject(account)
                                    .onAppear {
                                        account.responses["fieldFetch"] = 0
                                        account.responses["courtFetch"] = 0
                                    }
                            } label: {
                                HStack{
                                    Text(DateFormatter.yearMonthDay.string(from: archive.date))
                                    Text(archive.state == 1 ? "Completed" : "Canceled")
                                        .foregroundStyle(archive.state == 1 ? .green : .red)
                                    Image(systemName: archive.state == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundStyle(archive.state == 1 ? .green : .red)
                                    Image(systemName: "chevron.right")
                                }
                            }
                            
                        }
                    }
                    Divider()
                } else {
                    Text("No past reservations found")
                }
                
            }.refreshable {
                account.responses["archivedReservationsFetch"] = 0
            }
            
        }
    }
}

#Preview {
    NavigationStack{
        ReservationHistory(courtID: -1).environmentObject(Account())
        
    }
}

