//
//  ArchiveView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/21/24.
//

import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var account: Account
    private var timeFormatter: DateFormatter = DateFormatter()
    private var archive: Archive
    private var asOwner: Bool
    @State var court: Court = Court(id: 0, name: "", owner: "", address: "", telephone: "0", previewImageURL: URL(string: "https://atlasreserve.ma")!)
    @State var field: Field = Field(id: 0, type: 0, startTime: "", endTime: "", availability: 0, count: 0, courtID: 0)
    @State var user: User = User(id: 1, username: "", telephone: "")
    init(archive: Archive, asOwner: Bool) {
        self.archive = archive
        self.asOwner = asOwner
        timeFormatter.dateFormat = "HH:mm"
    }
    var body: some View {
        if account.responses["courtFetch"] == 0 {
            ProgressView("Fetching court").onAppear {
                account.getCourts(clearImageCache: false)
            }
        } else if account.responses["fieldFetch"] == 0 {
            ProgressView("Fetching field").onAppear {
                account.getFieldsByCourtID(court: self.archive.courtID)
            }
        } else if asOwner && account.responses["userByUserIDFetch"] == 0 {
            ProgressView("Fetching User").onAppear {
                account.getUserByUserID(userID: self.archive.userID)
            }
        } else {
            HStack{
                Text("Archived Reservation Information").font(.largeTitle).bold().fontDesign(.serif)
                Spacer()
            }.padding()
            VStack{
                HStack {
                    Text("Court Information").font(.title2)
                    Spacer()
                }
                // Court Information
                VStack {
                    HStack{
                        Text("Court Name: ")
                        Text(court.name)
                        Spacer()
                    }
                    HStack{
                        Text("Owner: ")
                        Text(court.owner)
                        Spacer()
                    }
                    HStack{
                        Text("Address: ")
                        Text(court.address)
                        Spacer()
                    }
                    HStack{
                        Text("Telephone: ")
                        Text(court.telephone)
                        Spacer()
                    }
                }
                Spacer()
                // Field Information
                HStack {
                    Text("Field Information").font(.title2)
                    Spacer()
                }
                VStack {
                    HStack{
                        Text("Start Time: ")
                        Text(timeFormatter.string(from:field.startTime))
                        Spacer()
                    }
                    HStack{
                        Text("End Time: ")
                        Text(timeFormatter.string(from:field.endTime))
                        Spacer()
                    }
                }
                Spacer()
                // Reservation Information
                HStack {
                    Text("Reservation Information").font(.title2)
                    Spacer()
                }
                VStack {
                    HStack{
                        Text("Date")
                        Text(DateFormatter.yearMonthDay.string(from:archive.date))
                        Spacer()
                    }
                    HStack{
                        Text("State: ")
                        if archive.state == 1 {
                            Text("Marked as complete").foregroundStyle(.green)
                        } else if archive.state == 2 {
                            Text("Canceled by User").foregroundStyle(.red)
                        } else {
                            Text("Canceled by Court").foregroundStyle(.red)
                        }
                        Spacer()
                    }
                    
                    if archive.state != 1 {
                        HStack{
                            Text("Reason: ")
                            Text(archive.reason)
                            Spacer()
                        }
                    }
                }
                Spacer()
                if asOwner {
                    HStack {
                        Text("User(Reserver) Information").font(.title2)
                        Spacer()
                    }
                    VStack {
                        HStack{
                            Text("ID: ")
                            Text(String(user.id))
                            Spacer()
                        }
                        HStack{
                            Text("Username: ")
                            Text(user.username)
                            Spacer()
                        }
                        HStack{
                            Text("Telephone: ")
                            Text(user.telephone)
                            Spacer()
                        }
                    }
                }
                
            }.padding()
                .onAppear {
                    self.court = account.courts.first(where: { court in
                        court.id == self.archive.courtID
                    }) ?? self.court
                    self.field = account.fields.first(where: { field in
                        field.id == self.archive.fieldID
                    }) ?? self.field
                    self.user = account.fetchedUser
                }
            Spacer()
        }
    }
}

#Preview {
    ArchiveView(
        archive: Archive(resID: 1, userID: 10031, courtID: 2, fieldID: 11, date: "2024-02-21", state: 1, reason: ""), asOwner: true
    ).environmentObject(Account())
}
