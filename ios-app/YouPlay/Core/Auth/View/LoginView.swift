//
//  LoginView.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Spacer()

            // logo
            Image("SpotifyLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 32)

            // text fields
            VStack(spacing: 16) {
                TextField("Enter your email", text: $viewModel.email)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Enter your password", text: $viewModel.password)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .font(.subheadline)
            .padding(.horizontal)

            // forgot password
            Button {
                print("Forgot password") // TODO: password reset
            } label: {
                Text("Forgot password?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.top)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)

            .padding(.top, -8)

            // login button
            Button {
                Task {
                    try await viewModel.login()
                }
            } label: {
                Text("Login")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background(.green)
                    .cornerRadius(10)
            }
            .padding(.top)
            .padding(.horizontal)

            // divider
            HStack {
                Rectangle()
                    .frame(height: 0.3)

                Text("OR")
                    .font(.footnote)
                    .fontWeight(.semibold)

                Rectangle()
                    .frame(height: 0.3)
            }
            .foregroundStyle(.gray)
            .padding()

            // Google login
            Button {
                print("Login with Google") // TODO: Google login
            } label: {
                HStack {
                    Image("GoogleLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 20)

                    Text("Continue with Google")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            }

            Spacer()
            Divider()

            // sign up link
            NavigationLink {
                SignUpView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have an account?")

                    Text("Sign up")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
