//
//  AddRepositoryViewModel.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import Foundation

class AddRepositoryViewModel: ObservableObject {
    
    var name = ""
    var description = ""
    var visibility: RepositoryVisibility = .public
    
    @Published var errors: [ErrorViewModel] = []
    
    func saveRepository(completion: @escaping () -> Void) {
        Network.shared.apollo.perform(mutation: CreateRepositoryMutation(name: name, description: description, visibility: visibility, clientMutationId: UUID().uuidString)) { result in
          
            switch result {
            case .success(let graphQlResult):
                if let errors = graphQlResult.errors {
                    DispatchQueue.main.async {
                        self.errors = errors.map {
                            ErrorViewModel(message: $0.message)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self.errors = [ErrorViewModel(message: error.localizedDescription)]
                }
            }
        }
        
    }
}
