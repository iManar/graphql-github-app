//
//  RepositoriesListScreen.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import SwiftUI
import Combine

struct RepositoriesListScreen: View {
    
    @State private var repositoriesDisplay: String = "latest"
    @State private var isPresented: Bool = false
    @StateObject private var repositoryListVM = RepositoryListViewModel()
    
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            
            Picker("Select", selection: $repositoryListVM.repositoryDisplay, content: {
                Text("Latest").tag(RepositoriesDisplay.latest)
                Text("Top").tag(RepositoriesDisplay.top)
            }).pickerStyle(SegmentedPickerStyle())
            
            switch repositoryListVM.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .centerlize()
            case let .loaded(repos):
                List(repos, id: \.id) { repository in
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
            case let .failed(error):
                ErrorView(error: error, retryHandler: loadRepositories)
                    .centerlize()
            }
        }
        .padding()
        .onAppear {
            cancellable = repositoryListVM.$repositoryDisplay.sink { display in
                switch display {
                case .latest:
                    repositoryListVM.getLatestRepositoriesForUser(Constants.User.username)
                case .top:
                    repositoryListVM.getTopRepositoriesForUser(Constants.User.username)
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            isPresented = true
        }, label: {
            Image(systemName: "plus")
        }))
        .sheet(isPresented: $isPresented, onDismiss: {
            repositoryListVM.getLatestRepositoriesForUser(Constants.User.username)
        }, content: {
            AddRepositoryScreen()
        })
        .navigationTitle("Repositories")
        .embedInNavigationView()
    }
    
    private func loadRepositories() {
        switch repositoryListVM.repositoryDisplay {
        case .latest:
            repositoryListVM.getLatestRepositoriesForUser(Constants.User.username)
        case .top:
            repositoryListVM.getTopRepositoriesForUser(Constants.User.username)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesListScreen()
    }
}


// MARK: -
struct Centerlized: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
      }
}


extension View{
    func centerlize() -> some View{
         return self.modifier(Centerlized())
   }
}
