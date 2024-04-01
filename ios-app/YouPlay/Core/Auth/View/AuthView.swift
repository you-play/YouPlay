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
            ZStack {
                LoginView(viewModel: viewModel)

                if viewModel.isLoading {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView()
                }
            }
        }
        .tint(.green)
    }
}

#Preview {
    AuthView()
}
