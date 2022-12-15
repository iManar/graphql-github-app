//
//  ErrorView.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryHandler: (() -> Void)
    
    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding(.bottom, 40).padding()
            Button(action: retryHandler, label: { Text("Retry").bold() })
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NSError(domain: "", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Repository has already been created!"]),
                  retryHandler: { })
    }
}
#endif
