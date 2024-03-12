//
//  SplashView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 07.03.2024.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isActivity = false
    @State private var opasity = 0.4
    
    var body: some View {
        
        if isActivity {
            ContentView()
        } else {
            VStack{
                ZStack{
                    Image("finexBg")
                        .resizable()
                        .ignoresSafeArea()
                    VStack(spacing: -50){
                        Image("finex")
                            .resizable()
                            .frame(width: 330, height: 300)
                        Text("Finex")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .scaleEffect(1.4)
                    }
                    .opacity(opasity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1)){
                            opasity = 1.0
                        }
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.bouncy){
                        isActivity = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
