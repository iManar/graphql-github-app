//
//  View+Extensions.swift
//  GitHubApp
//
//  Created by Manar Magdy on 24/09/2022.
//

import Foundation
import SwiftUI

extension View {
    
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
}
