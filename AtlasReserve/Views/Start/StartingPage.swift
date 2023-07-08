//
//  LoginPage.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/1/23.
//

import Foundation
import SwiftUI

func redirectSetting(){
	UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}
struct StartingPage: View {
	
    var body: some View {
		
		VStack{
			ChangeLanguage()
			VStack(spacing:20){
				Text("reserve-a-court")
					.font(.title)
					.fontDesign(.rounded)
					.bold()
				Text("play-football")
					.lineSpacing(2.0)
					.font(.subheadline)
					.fontDesign(.serif)
				Image("fff").resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 50.0))
					.padding(3)
				
					NavigationLink(destination:
								   RegisterPage()){
						
						Text("sign-up").foregroundColor(Color.white).padding().font(.title3).bold()
						
					}.background(Color.yellow)
						.clipShape(Capsule())
					NavigationLink(destination:
								   LoginPage()){
						HStack{
							Text("already-have-account").font(.title3).foregroundColor(Color.gray)
							Text("log-in").bold().foregroundColor(Color.gray)
								.font(.title3)
						}
						
				}
				
				
			}.padding()
		}
		
    }
}

struct StartingPage_Previews: PreviewProvider {
    static var previews: some View {
		
		NavigationStack{
			StartingPage()
		}
    }
}

