//
//  ErrorView.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import SwiftUI

struct ErrorsView: View {
    
    let errors: [ErrorViewModel]
    
    var body: some View {
        VStack {
            ForEach(errors, id: \.id) { error in
                Text(error.message ?? "")
                    .foregroundColor(.red)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorsView(errors: [ErrorViewModel(message: "Repository has already been created!")])
    }
}
