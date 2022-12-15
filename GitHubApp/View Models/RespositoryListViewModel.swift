//
//  RespositoryListViewModel.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import Foundation
import Apollo

enum RepositoriesDisplay {
    case latest
    case top
}

// MARK: -
class RepositoryListViewModel: ObservableObject {
    
    enum State<Value> {
        case idle
        case loading
        case loaded(Value)
        case failed(Error)
    }
    
    @Published var repositoryDisplay: RepositoriesDisplay = .latest
    @Published private(set) var state: State<[RepositoryViewModel]> = .idle
    
    func getLatestRepositoriesForUser(_ username: String) {
        state = .loading
        
        Network.shared.apollo.fetch(query: GetRepositoriesByUserNameQuery(username: username), cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
            switch result {
            case .success(let graphQLResponse):
                
                guard let self = self,
                      let data = graphQLResponse.data,
                      let user = data.user,
                      let nodes = user.repositories.nodes else { return }
                
                DispatchQueue.main.async {
                    let repositories = nodes.compactMap { $0 }.map(RepositoryViewModel.init)
                    self.state = .loaded(repositories)
                }
            case.failure(let error):
                self?.state = .failed(error)
                debugPrint(error)
            }
        }
    }
    
    
    func getTopRepositoriesForUser(_ username: String) {
        state = .loading
        
        Network.shared.apollo.fetch(query: GetTopRepositoriesForUserQuery(username: username)) { [weak self]  result in
            switch result {
            case .success(let graphQLResponse):
                
                guard let self = self,
                      let data = graphQLResponse.data,
                      let user = data.user,
                      let nodes = user.repositories.nodes else { return }
                
                DispatchQueue.main.async {
                    let repositories = nodes.compactMap { $0 }.map(RepositoryViewModel.init)
                    self.state = .loaded(repositories)
                }
            case.failure(let error):
                self?.state = .failed(error)
                debugPrint(error)
            }
        }
    }
}

struct RepositoryViewModel {
    
    let node: RepositoryNode
    
    var hasRating: Bool {
        node.stargazerCount > 0
    }
    
    var id: GraphQLID {
        node.id
    }
    
    var name: String {
        node.name
    }
    
    var description: String {
        node.description ?? ""
    }
    
    var starCount: Int {
        node.stargazerCount
    }
}
