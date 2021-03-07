//
//  ContentView.swift
//  tarea05
//
//  Created by Cristian Zuniga on 7/3/21.
//

import SwiftUI

struct PokemonDetailView: View {
    let name: String
    @ObservedObject var pkmVM = PokemonViewModel()
    
    var body: some View {
        VStack{
            HStack{
                if let imageURL = URL(string: self.pkmVM.pokemonDetails.sprites.front_default) {
                    Image(systemName: "square.fill").data(url: imageURL)
                        .frame(width: 150.0, height: 200.0)
                }
            }
            HStack{
                Text("Pokemon id: \(self.pkmVM.pokemonDetails.id)")
            }
            HStack{
                Text("Pokemon name: \(self.pkmVM.pokemonDetails.name.capitalizingFirstLetter())")
            }
            HStack{
                Text("Pokemon height: \(self.pkmVM.pokemonDetails.height)")
            }
            HStack{
                Text("Pokemon weight: \(self.pkmVM.pokemonDetails.weight)")
                    .onAppear{
                        self.pkmVM.fetchPokemonDetail(name: name)
                    }
            }
            
        }
    }
}

extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            guard let image = UIImage(data: data) else {
                return Image(systemName: "square.fill")
            }
            return Image(uiImage: image)
                .resizable()
        }
        return self
            .resizable()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class PokemonViewModel: ObservableObject {
    
    @Published var listOfPokemon: [PokemonList.Pokemon] = []
    @Published var pokemonDetails: PokemonDetail = .init(id:0, name:"", height:0, weight: 0, sprites: .init(front_default:""))
    
    func fetchPokemon(){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {
            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)
        // The shared singleton session object.
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response = try? JSONDecoder().decode(PokemonList.self, from: data) {
                    DispatchQueue.main.async {
                        self.listOfPokemon = response.results
                    }
                    return
                }
            }
            
        }.resume()
    }
    
    func fetchPokemonDetail(name: String){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else {
            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)
        // The shared singleton session object.
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response = try? JSONDecoder().decode(PokemonDetail.self, from: data) {
                    DispatchQueue.main.async {
                        self.pokemonDetails = response
                    }
                    return
                }
            }
            
        }.resume()
    }
}

struct ContentView: View {
    
    @ObservedObject var pkmVM = PokemonViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Text("Pokemon")
                        .font(.largeTitle)
                }
                HStack{
                    List(self.pkmVM.listOfPokemon){ pkm in
                        NavigationLink(destination: PokemonDetailView(name: pkm.name)) {
                            Text(String(pkm.name.capitalizingFirstLetter()))
                        }
                    }.onAppear{
                        self.pkmVM.fetchPokemon()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
