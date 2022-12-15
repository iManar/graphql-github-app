//
//  RepositoriesListScreen.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var repositoriesDisplay: String = "latest"
    @State private var isPresented: Bool = false
    @StateObject private var repositoryListVM = RepositoryListViewModel()
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            
            Picker("Select", selection: $repositoryListVM.repositoriesDisplay, content: {
                Text("Latest").tag(RepositoriesDisplay.latest)
                Text("Top").tag(RepositoriesDisplay.top)
            }).pickerStyle(SegmentedPickerStyle())
            
            
            List(repositoryListVM.respositories, id: \.id) { repository in
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(repository.name)
                            .font(.headline)
                        Text(repository.description)
                    }
                    Spacer()
                    
                    if repository.hasRating {
                        HStack {
                            Text("\(repository.starCount)")
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                }
            }.listStyle(PlainListStyle())
        }
        .padding()
        .onAppear(perform: {
            
            self.cancellable = repositoryListVM.$repositoriesDisplay.sink { (display) in
                switch display {
                    case .latest:
                        repositoryListVM.getLatestRepositoriesForUser(username: Constants.User.username)
                    case .top:
                        repositoryListVM.getTopRepositoriesForUser(username: Constants.User.username)
                }
            }
           
        })
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }, label: {
            Image(systemName: "plus")
        }))
        .sheet(isPresented: $isPresented, onDismiss: {
            repositoryListVM.getLatestRepositoriesForUser(username: Constants.User.username)
        }, content: {
            AddRepositoryScreen()
        })
        .navigationTitle("Repositories")
        .embedInNavigationView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
