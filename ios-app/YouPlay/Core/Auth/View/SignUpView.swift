//
//  SignUpView.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
                
            // logo
            Image("YouPlayLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 32)
                
            // text fields
            VStack(spacing: 16) {
                TextField("Enter your email", text: $viewModel.email)
                    .padding(15)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                SecureField("Enter your password", text: $viewModel.password)
                    .padding(15)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .font(.subheadline)
            .padding(.horizontal)
                
            // sign up button
            Button {
                Task {
                    try await viewModel.signUp()
                    viewModel.reset()
                }
            } label: {
                Text("Sign up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
            .padding(.horizontal)
                
            Spacer()
            Divider()
                
            // login link
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                        
                    Text("Log in")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
            }
            .padding(.vertical)
            .tint(.white)
        }
    }
}

#Preview {
    SignUpView(viewModel: AuthViewModel())
}
