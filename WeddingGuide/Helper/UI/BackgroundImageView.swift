//
//  BackgroundImageView.swift
//  WeddingGuide
//
//  Created by Robin Burkard on 17.12.23.
//

import SwiftUI

struct BackgroundImageView: View {
    let imageNameTop = "background_top"
    let imageNameBottom = "background_bottom"
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
            Image(imageNameTop)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
        }.ignoresSafeArea(.keyboard)
        
        ZStack(alignment: .bottom) {
            Image(imageNameBottom)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(CGSize(width: 0.0, height: 35.0))
            Color.clear
        }.ignoresSafeArea(.keyboard)
    }
}
