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
                    }
            } else {
                NavigationLink (destination: CourtInformationManageView(courtIndex:    account.courts.firstIndex(where: { c in
                    return c.id == court.id
                })!).environmentObject(account)) {
                    Text("Edit basic court information").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
                NavigationLink (destination: ReservationManageView(court: self.court).environmentObject(account)
                    .onAppear {
                        account.responses["reservationsByCourtIDFetch"] = 0
                    }) {
                    Text("Manage Reservations").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
                NavigationLink (destination: ReservationHistory(courtID: self.court.id).environmentObject(account)
                    .onAppear {
                        account.responses["archivedReservationsFetch"] = 0
                    }) {
                    Text("View Past Reservations").font(.title2).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.black)
                }.padding()
                Text("Manage Fields").font(.title)
                Button("Discard All Changes") {
                    account.responses["fieldFetch"] = 0
                }.buttonStyle(.bordered)
                ForEach(account.fieldsManage.indices, id: \.self) {i in
                    FieldManageView(field: i, courtID: self.court.id).padding().environmentObject(account)
                    
                }
                HStack {
                    NavigationLink {
                        RequestResult(loadingText: "Modifying Field(s)", responseKey: "modifyField", successCode: 3, holdCodes: Array(4...4 + account.fieldsManage.count)) {code in
                            Text(code == 1 ? "Unreasonable data detected: make sure that the start time is earlier than the end time" : "An unhandled error occured")
                            }.environmentObject(account)
                            .onAppear {
                                account.modifyFields(fields: account.fieldsManage)
                            }
                    } label: {
                        Text("Confirm Modification")
                    }
                    Spacer()
                    NavigationLink {
                        FieldManageView(field: -1, courtID: self.court.id).environmentObject(account) // -1 will be processed as "create"
                    } label: {
                        Text("Add Field")
                        Image(systemName: "plus")
                    }
                }.padding()
            }
            
        }.refreshable {
            account.responses["fieldFetch"] = 0
        }.onAppear {
            account.responses["fieldFetch"] = 0
        }
    }
}

#Preview {
    NavigationStack {
        //CourtManageView(court:Court(id: 1, name: "A", owner: "B", address: "C", courtNumber: 1, previewImage: UIImage())).environmentObject(Account())
        OwnerControlView().environmentObject(Account())
    }
}
