//
//  CourtCard.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/20/23.
//

import SwiftUI
import Kingfisher

struct CourtCard: View {
    var court: Court
    @EnvironmentObject var account:Account;
    init(court: Court) {
        self.court = court
    }
    var body: some View {
        VStack {
            NavigationLink(destination: CourtDetailsView(court: court).environmentObject(account).onAppear {
                account.responses["fieldFetch"] = 0
            }
            ) {
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color:.gray.opacity(0.5), radius: 5.0, x: 0, y: 2)
                    
            }
                HStack{
                    Text(court.name)
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                .padding(.bottom)
                .frame(width:350, height:50)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(Color.white)
                
                
            }
            .padding()
            .frame(height: 230)

    }
}
//#Preview {
//    CourtCard(court: Court(id: 1, name: "Test", owner: "Test", address: "Test", courtNumber: 1, previewImage: UIImage(systemName: "a")!)).environmentObject(Account())
//}
