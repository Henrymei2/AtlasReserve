//
//  Home.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/20/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var account: Account
    private var day = DateFormatter()
    private var month = DateFormatter()
    private var year = DateFormatter()
    init() {
        day.dateFormat = "dd"
        month.dateFormat = "MM"
        year.dateFormat = "YYYY"
    }
    var body: some View {
        ScrollView {
            HStack{
                HomeCard(startColor: HColor.hsv(h: 210, s: 50, v: 100), endColor: HColor.hsv(h: 210, s: 15, v: 98)) {
                    VStack {
                        HStack{
                            Text("Welcome,")
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Text(account.username)
                                .bold()
                                .font(.title2)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                    }.padding()
                }
                HomeCard(startColor: Color.white, endColor: Color.white) {
                    VStack{
                        HStack{
                            Text(month.string(from: Date()))
                                .foregroundStyle(.pink)
                                .font(.largeTitle)
                                .bold()
                            Text(day.string(from: Date()))
                                .foregroundStyle(.pink)
                                .font(.largeTitle)
                                .bold()
                            
                        }
                        Text(year.string(from: Date())).foregroundStyle(.black)
                        
                    }
                }
            }
            HomeCard(startColor: HColor.hsv(h: 50, s: 100, v: 95), endColor: HColor.hsv(h: 50, s: 30, v: 98)) {
                VStack {
                    HStack{
                        Text("Today's reservation")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    if account.responses["reservationsByUserIDFetch"] == 0 {
                        ProgressView("Fetching Reservations")
                    } else if !account.reservations.contains(where: { reservation in
                            reservation.date == DateFormatter.yearMonthDay.date(from: DateFormatter.yearMonthDay.string(from: Date()))
                        }) {
                           Text("No reservations for today")
                    }
                    
                    ReservationView().onAppear {
                        account.responses["reservationsByUserIDFetch"] = 0
                    }
                }.padding()
            }
            HStack{
                HomeCard(startColor: HColor.hsv(h: 210, s: 50, v: 100), endColor: HColor.hsv(h: 210, s: 15, v: 98)) {
                    VStack {
                        Text("Explore.")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                            .padding(.top)
                        if account.courts.isEmpty {
                            ProgressView("Loading Courts")
                        } else {
                            CourtCard(court: account.courts[0])
                        }
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(Account())
    }
}
