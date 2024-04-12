//
//  DemoAccountView.swift
//  YouPlay
//
//  Created by Sebastian on 4/11/24.
//

import SwiftUI

struct DemoAccountView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Demo Account")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("You can set up this account to have some default playlists to explore")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Button {
                        Task {
                            if let uid = viewModel.currentUser?.uid {
                                print("DEBUG: setting up demo account")
                                viewModel.isLoading = true
                                await UserServiceImpl.shared.setupDemoAccount(uid: uid)
                                viewModel.isLoading = false
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Setup")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .background(.green)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                Spacer()
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView()
            }
        }
    }
}

#Preview {
    DemoAccountView(viewModel: ProfileViewModel())
}
