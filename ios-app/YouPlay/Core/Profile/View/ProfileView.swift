//
//  ProfileView.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel(userService: UserServiceImpl.shared)

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to YouPlay!")
                .font(.title)
                .fontWeight(.bold)

            if let user = viewModel.user {
                Text("User: \(user.firstName) \(user.lastName)")
            } else {
                Text("No user found.")
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(userService: MockUserService()))
}
