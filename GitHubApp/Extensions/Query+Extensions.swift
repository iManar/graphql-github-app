//
//  Query+Extensions.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import Foundation
import Apollo

extension GetTopRepositoriesForUserQuery.Data.User.Repository.Node: RepositoryNode {}
extension GetRepositoriesByUserNameQuery.Data.User.Repository.Node: RepositoryNode {}
