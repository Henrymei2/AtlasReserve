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
    private var yearMonthDay: DateFormatter = DateFormatter.yearMonthDay
    init(court: Court) {
        self.court = court
    }
    var body: some View {
        ScrollView {
            HStack{
                Text("Reservation Management").font(.largeTitle).fontDesign(.serif).bold()
                Spacer()
            
            }.padding()
            NavigationLink (destination: CreateReservation(courtID: self.court.id).environmentObject(account)) {
                Text("Manually Create Reservation").font(.title2).foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.black)
            }.padding()
            if account.responses["reservationsByCourtIDFetch"] == 0 {
                ProgressView("Loading Reservations").onAppear {
                    account.getReservationsByCourtID(courtID: self.court.id)
                }
            } else if account.responses["fieldFetch"] == 0 {
                ProgressView("Loading Fields").onAppear {
                    account.getFieldsByCourtID(court: self.court.id)
                }
            } else {
                HStack{
                    Text("Date").frame(maxWidth: .infinity)
                    Text("Start Time").frame(maxWidth: .infinity)
                    Text("End Time").frame(maxWidth: .infinity)
                    Text("Field Type").frame(maxWidth: .infinity)
                    Text("Detail/Manage").frame(maxWidth:.infinity)
                    
                }.padding(.horizontal)
                    .background(Color(red: 0.8, green: 0.85, blue: 0.9))
                ForEach(account.reservations, id:\.id) { reservation in
                    NavigationLink {
                        ReservationDetailManage(reservation: reservation, field: account.fieldsManage.first(where: { f in
                            f.id == reservation.field
                        })!).environmentObject(account)
                    } label: {
                        HStack {
                            VStack{
                                Text(self.yearMonthDay.string(from: reservation.date))
                            }.frame(maxWidth: .infinity)
                            VStack{
                                Text(reservation.startTime)
                            }.frame(maxWidth: .infinity)
                            VStack{
                                Text(reservation.endTime)
                            }.frame(maxWidth: .infinity)
                            VStack{
                                Text(FieldType.convert[account.fieldsManage.first(where: { f in
                                    f.id == reservation.field
                                })!.type]!)
                            }.frame(maxWidth: .infinity)
                            
                            
                            Image(systemName: "chevron.right").foregroundStyle(.black).frame(maxWidth: .infinity)
                            
                        }.padding(.horizontal)
                        Divider()
                    }.foregroundStyle(.black)
                }
                
            }
            
        }.refreshable {
            account.responses["reservationsByCourtIDFetch"] = 0
        }
        
    }
}

#Preview {
    NavigationStack{
        ReservationManageView(court: Court(id: 10, name: "", owner: "", address: "", telephone: "1", previewImageURL: URL(fileURLWithPath: ""))).environmentObject(Account())
    }
}
