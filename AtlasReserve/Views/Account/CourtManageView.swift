//
//  CourtManageView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/12/24.
//

import SwiftUI

struct CourtManageView: View {
    @EnvironmentObject var account: Account
    private var court: Court
    @State private var isDatePickerVisible = false
    @State private var hasAppeared = false
    private var timeFormatter: DateFormatter = DateFormatter()
    init(court: Court) {
        self.court = court
        timeFormatter.dateFormat = "HH:mm"
    }
    var body: some View {
        ScrollView {
            Text("Court Management").font(.largeTitle).fontDesign(.serif).bold()
            if account.responses["fieldFetch"] == 0 {
                ProgressView()
                    .onAppear {
                        account.getFieldsByCourtID(court: court.id)
                        hasAppeared = true
                    }
            } else if account.responses["courtFetch"] == 0 {
                ProgressView()
                    .onAppear {
                        account.getCourts()
                    }
            } else {
                NavigationLink (destination: CourtInformationManageView(courtIndex:    account.courts.firstIndex(where: { c in
                    return c.id == court.id
                })!).environmentObject(account)) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundStyle(.black)
                        .scaleEffect(1.2)
                    Text("Edit basic court information").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
                NavigationLink (destination: ReservationManageView(court: self.court).environmentObject(account)
                    .onAppear {
                        account.responses["reservationsByCourtIDFetch"] = 0
                    }) {
                    Image(systemName: "newspaper.fill")
                        .foregroundStyle(.gray)
                        .scaleEffect(1.2)
                    Text("Manage Reservations").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
                NavigationLink (destination: ReservationHistory(courtID: self.court.id).environmentObject(account)
                    .onAppear {
                        account.responses["archivedReservationsFetch"] = 0
                    }) {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.black)
                        .scaleEffect(1.2)
                    Text("View Past Reservations").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
                Text("Manage Fields").font(.title)
                HStack {
                    Image(systemName: "xmark").foregroundStyle(.red)
                    Button("Discard All Changes") {
                        account.responses["fieldFetch"] = 0
                    }.foregroundStyle(.red)
                    NavigationLink {
                        RequestResult(loadingText: "Modifying Field(s)", responseKey: "modifyField", successCode: 3, holdCodes: Array(4...4 + account.fieldsManage.count)) {code in
                            Text(code == 1 ? "local-error-unreasonable" : "An unhandled error occured")
                            }.environmentObject(account)
                            .onAppear {
                                account.modifyFields(fields: account.fieldsManage)
                            }
                    } label: {
                        Image(systemName: "checkmark").foregroundStyle(.green)
                        Text("Confirm Modification").foregroundStyle(.green)
                    }
                    NavigationLink {
                        FieldManageView(field: -1, courtID: self.court.id).environmentObject(account) // -1 will be processed as "create"
                    } label: {
                        Image(systemName: "plus")
                        Text("Add Field")
                    }
                }.padding()
                ForEach(account.fieldsManage.indices, id: \.self) {i in
                    FieldManageView(field: i, courtID: self.court.id).padding().environmentObject(account)
                    
                }
                    
            }
            
        }.onAppear {
            account.responses["fieldFetch"] = 0
        }
    }
}

#Preview {
    NavigationStack {
        CourtManageView(court:Court(id: 2, name: "A", owner: "B", address: "C", telephone: "1", previewImageURL: URL(string:"https://atlasreserve.ma/courtPrevImg/court2.png")!)).environmentObject(Account())
        //OwnerControlView().environmentObject(Account())
    }
}
