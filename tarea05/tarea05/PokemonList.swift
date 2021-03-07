//
//  PokemonList.swift
//  tarea05
//
//  Created by Cristian Zuniga on 7/3/21.
//

import SwiftUI

struct PokemonList : Codable {
    
    struct Pokemon:  Identifiable, Codable {
        let id = UUID()
        let name: String
        let url: String
    }
    
    let results: [Pokemon]
}

struct PokemonDetail : Identifiable, Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}

struct Sprites : Codable
{
    let front_default: String
}
