//
//  ContentView.swift
//  DogPics
//
//  Created by Francesca MACDONALD on 2023-08-28.
//

import SwiftUI
import AVFAudio

enum Breed: String, Equatable, CaseIterable {
    case boxer, bulldog, chihuahua, labradddoodle, poodle, pug, retriever
}
struct ContentView: View {
    
    @StateObject var dogVM = DogViewModel()
    
    @State var breedSelected: Breed = .boxer
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack {
            Text("🐶 Dog Pics!")
                .font(.custom("Avenire Next Condensed", fixedSize: 60))
                .bold()
                .foregroundColor(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            AsyncImage(url: URL(string: dogVM.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
                    .animation(.easeIn, value: image)

            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()

            }

            Spacer()
            
            Button("Any Random Dog") {
                getImage(randomDog: true)
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .padding(.bottom)
            HStack {
                Button("Show Breed") {
                    getImage(randomDog: false)
                }
                .bold()
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .padding(.bottom)
                Picker(selection: $breedSelected) {
                    ForEach(Breed.allCases, id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                } label: {
                    
                }
            }
        }
        .padding()
        .onAppear{
            playSound(soundName: "bark")
        }
    }
    func getImage(randomDog: Bool) {
        //    var randomDogUrl =
        //    var "https://dog.ceo/api/breed/pug/image/random"
        dogVM.urlString = "https://dog.ceo/api/breeds/image/random"
        if !randomDog {
            dogVM.urlString =  "https://dog.ceo/api/breed/\(breedSelected.rawValue)/images/random"
        }
        Task {
            await dogVM.getData()
        }
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 Error: \(error.localizedDescription) creating audioPlayer")
        }
        
    }

    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dogVM: DogViewModel())
    }
}
