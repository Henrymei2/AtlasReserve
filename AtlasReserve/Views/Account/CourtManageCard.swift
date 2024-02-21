//
//  CourtManageCard.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/21/24.
//

import SwiftUI
import Kingfisher

struct CourtManageCard: View {
    @EnvironmentObject var account: Account
    private var court: Court;
    @State var confirmed: Bool = false
    init(court: Court) {
        self.court = court
    }
    
    var body: some View {
        VStack{
            NavigationLink {
                //EmptyView()
                CourtManageView(court: self.court).environmentObject(account)
            } label: {
                // Court Image as the background
                KFImage(self.court.previewImageURL)
                    .placeholder {
                    // Placeholder while downloading.
                    Image(systemName: "arrow.2.circlepath.circle")
                        .font(.largeTitle)
                        .opacity(0.3)
                    }
                    .resizable()
                    .onSuccess({ result in
                        self.court.previewImage = result.image
                    })
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color:.gray.opacity(0.5), radius: 5.0, x: 0, y: 2)
                    
                

            }
            HStack{
                Text(self.court.name)
                    .font(.headline)
                Spacer()
                if !self.confirmed {
                    Button {
                        self.confirmed = true
                    } label: {
                        Text("Delete").foregroundStyle(.red)
                    }.buttonStyle(.bordered)
                } else {
                    NavigationLink {
                        RequestResult(loadingText: "Deleting a Court", responseKey: "deleteCourt", successCode: 3) {code in
                            Text("An unhandled error occured")
                            }.environmentObject(account)
                            .onAppear {
                                account.deleteCourt(courtID: self.court.id)
                            }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.red).frame(width:150, height:30)
                            Text("Confirm Delete").foregroundStyle(.white)
                        }
                    }
                }
                
            }.padding(.horizontal)
        
        }
    }
}
#Preview {
    NavigationStack{
        CourtManageCard(court: Court(id: 2, name: "Name4", owner: "Owner2", address: "Address2", telephone: "6", previewImageURL: URL(string: "https://atlasreserve.ma/courtPrevImg/court2.png")!)).environmentObject(Account())
        
    }
}

