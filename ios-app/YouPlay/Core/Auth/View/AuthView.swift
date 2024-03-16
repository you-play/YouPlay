//
//  AuthView.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            LoginView(viewModel: viewModel)
        }
        .tint(.green)
    }
}

#Preview {
    AuthView()
}
