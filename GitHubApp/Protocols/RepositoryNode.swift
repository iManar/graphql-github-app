//
//  RepositoryNode.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import Foundation
import Apollo

protocol RepositoryNode {
    var id: GraphQLID { get }
    var name: String { get }
    var description: String? { get }
    var stargazerCount: Int { get }
}
