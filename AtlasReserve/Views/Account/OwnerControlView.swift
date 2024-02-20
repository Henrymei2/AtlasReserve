//
//  OwnerControlView.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/11/24.
//

import SwiftUI
import Kingfisher

struct OwnerControlView: View {
    @EnvironmentObject var account: Account
    @State var showAlert = false
    @State var navLinkActivated = false
    var body: some View {
        ScrollView {
            Text("Your Courts").font(.largeTitle).fontDesign(.serif).bold()
            if account.isOwner {
                if account.responses["courtFetch"] == 0 {
                    ProgressView("Fetching Courts").onAppear {
                        account.getCourts()
                    }
                } else {
                    ForEach(account.courts, id: \.id) { i in
                        if (i.ownerID == account.id) {
                            
                            NavigationLink(destination: CourtManageView(court: i).environmentObject(account)
                            ) {
                                // Court Image as the background
                                KFImage(i.previewImageURL)
                                    .placeholder {
                                    // Placeholder while downloading.
                                    Image(systemName: "arrow.2.circlepath.circle")
                                        .font(.largeTitle)
                                        .opacity(0.3)
                                    }
                                    .resizable()
                                    .onSuccess({ result in
                                        i.previewImage = result.image
                                    })
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color:.gray.opacity(0.5), radius: 5.0, x: 0, y: 2)
                                    
                                

                            }
                            HStack{
                                Text(i.name)
                                    .font(.headline)
                                Spacer()
                                Button {
                                    showAlert = true
                                } label: {
                                    Text("Delete").foregroundStyle(.red)
                                }.alert("Confirm Delete. Note: Deleting the court will result in all past and present reservations associated with this court to be deleted!", isPresented: $showAlert) {
                                    Button (role: .cancel) {
                                        showAlert = false
                                    } label: {
                                        Text("Cancel")
                                    }
                                    Button ("Delete", role: .destructive) {
                                        let group = DispatchGroup()
                                        group.enter()
                                        DispatchQueue.global(qos:.default).async {
                                            account.deleteCourt(courtID: i.id)
                                            group.leave()
                                        }
                                        group.notify(queue: DispatchQueue.main) {
                                            account.responses["courtFetch"] = 0
                                        }
                                    }
                                    
                                    
                                }.buttonStyle(.bordered)
                                
                            }
                        }
                    }
                }
                HStack {
                    Spacer()
                    NavigationLink {
                        CourtInformationManageView(courtIndex: -1).environmentObject(account) // -1 will be processed as "create"
                    } label: {
                        Text("Add Court")
                        Image(systemName: "plus")
                    }
                }.padding()

            } else {
                Text("This account is not registered as an owner account, Please send an email to info@atlasreserve.ma to request your account for verification to be an owner account")
            }
        }.padding()
            .refreshable {
            account.responses["courtFetch"] = 0
        }
    }
}

#Preview {
    NavigationStack{
        OwnerControlView().environmentObject(Account())
    }
}
