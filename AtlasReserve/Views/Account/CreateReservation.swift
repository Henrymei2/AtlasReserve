//
//  CreateReservation.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/20/24.
//

import SwiftUI

struct CreateReservation: View {
    @EnvironmentObject var account: Account
    @State var selectedField: Int = 0;
    @State var selectedDate: Date = Date();
    private var courtID: Int;
    init(courtID: Int) {
        self.courtID = courtID
    }
    var body: some View {
        VStack{
            if account.responses["fieldFetch"] == 0 {
                ProgressView("Fetching Fields").onAppear{
                    account.getFieldsByCourtID(court: courtID)
                }
            } else if account.fieldsManage.count > 0 {
                HStack {
                    DatePicker("Date: ", selection: $selectedDate, displayedComponents: .date)
                }
                HStack{
                    Text("Field: ")
                    Picker("Select Field", selection: $selectedField) {
                        ForEach(account.fieldsManage, id: \.id) { field in
                            Text(String(field.id))
                        }
                    }.onAppear {
                        selectedField = account.fieldsManage[0].id
                    }
                    
                }
                FieldManageView(field: account.fieldsManage.firstIndex(where: { field in
                    field.id == selectedField
                }) ?? 0, readOnly: true)
                .foregroundStyle(.black)
                NavigationLink {
                    RequestResult(loadingText: "Creating a Reservation", responseKey: "reserve", successCode: 3) {code in
                        Text("An unhandled error occured")
                    }.environmentObject(account)
                        .onAppear {
                            print(String(self.selectedField))
                            account.reserve(fieldID: self.selectedField, date: self.selectedDate, type: 2)
                        }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.blue).frame(width:80, height:35)
                        Text("Create").foregroundStyle(.white)
                    }
                }.padding()
                
            } else {
                Text("no-fields")
            }
        }.padding()
    }
}
