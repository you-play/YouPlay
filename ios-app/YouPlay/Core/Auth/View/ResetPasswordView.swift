//
//  ResetPasswordView.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reset password")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Reset your password by entering your email address")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                Spacer()
            }
            .padding(.horizontal)

            VStack(spacing: 16) {
                TextField("Enter your email", text: $viewModel.email)
                    .padding(15)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button {
                    Task {
                        try await viewModel.resetPassword()
                        viewModel.reset()
                        dismiss()
                    }
                } label: {
                    Text("Send")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(.green)
                        .cornerRadius(10)
                }
            }
            .padding()

            Spacer()
        }
    }
}

#Preview {
    ResetPasswordView(viewModel: AuthViewModel())
}
