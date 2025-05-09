//
//  ContentView.swift
//  RestaurantGuide
//
//  Created by BURAK on 30/04/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var showSignUp = false
    @State private var showSignIn = false
    @State private var showPreferences = false
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationStack {
            Group {
                if authManager.isAuthenticated {
                    // Ana uygulama içeriği
                    PreferenceView()
                        .environmentObject(authManager)
                } else {
                    // Giriş ekranı
                    ZStack {
                        // Arka plan gradyanı
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.8),
                                Color.orange.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        // Ana içerik
                        VStack(spacing: 30) {
                            // Logo ve başlık
                            VStack(spacing: 10) {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white)
                                
                                Text("welcome title".localized)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("welcome subtitle".localized)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 50)
                            
                            // Butonlar
                            VStack(spacing: 15) {
                                Button(action: {
                                    showSignUp = true
                                }) {
                                    Text("create account".localized)
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(15)
                                }
                                
                                Button(action: {
                                    showSignIn = true
                                }) {
                                    Text("sign in".localized)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(15)
                                }
                                
                                Button(action: {
                                    showPreferences = true
                                }) {
                                    Text("continue as guest".localized)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
                    .environmentObject(authManager)
            }
            .navigationDestination(isPresented: $showSignIn) {
                LoginView()
                    .environmentObject(authManager)
            }
            .navigationDestination(isPresented: $showPreferences) {
                PreferenceView()
                    .environmentObject(authManager)
            }
        }
        .languageAware()
    }
}

#Preview {
    ContentView()
}
