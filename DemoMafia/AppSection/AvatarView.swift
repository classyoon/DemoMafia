//
//  AvatarView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/14/25.
//

import SwiftUI


struct AvatarView: View {
    let avatar: Avatar = .init(name: "John", imageURL: "https://www.ecranlarge.com/content/uploads/2024/04/chris-hemsworth-thor-etait-un-peu-inutile-au-sein-des-avengers-et-cest-chris-hemsworth-qui-laffirme-1509660-630x380.png.webp")
    
    var body: some View {
        VStack {
            let url = URL(string: avatar.imageURL)
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(.secondary)
            }
            .shadow(radius: 6)
            Text(avatar.name)
        }
    }
}

#Preview {
    AvatarView()
}
