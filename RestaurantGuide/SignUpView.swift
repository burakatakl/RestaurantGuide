import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var agreedToTerms = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    // Validation states
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var isPasswordMatching = true
    @State private var isPhoneValid = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Logo ve başlık
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("create account".localized)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                
                // Form alanları
                VStack(spacing: 20) {
                    // Ad Soyad
                    VStack(alignment: .leading) {
                        Text("full name".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("full name".localized, text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.name)
                    }
                    
                    // Email
                    VStack(alignment: .leading) {
                        Text("email".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("email".localized, text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
                        
                        if !isEmailValid && !email.isEmpty {
                            Text("invalid email".localized)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Telefon
                    VStack(alignment: .leading) {
                        Text("phone number".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("phone number".localized, text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                            .onChange(of: phoneNumber) { _ in
                                validatePhone()
                            }
                        
                        if !isPhoneValid && !phoneNumber.isEmpty {
                            Text("invalid phone".localized)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Şifre
                    VStack(alignment: .leading) {
                        Text("password".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if showPassword {
                                TextField("password".localized, text: $password)
                                    .textContentType(.newPassword)
                            } else {
                                SecureField("password".localized, text: $password)
                                    .textContentType(.newPassword)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: password) { _ in
                            validatePassword()
                            validatePasswordMatch()
                        }
                        
                        if !isPasswordValid && !password.isEmpty {
                            Text("password length".localized)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Şifre Tekrar
                    VStack(alignment: .leading) {
                        Text("confirm password".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if showConfirmPassword {
                                TextField("confirm password".localized, text: $confirmPassword)
                                    .textContentType(.newPassword)
                            } else {
                                SecureField("confirm password".localized, text: $confirmPassword)
                                    .textContentType(.newPassword)
                            }
                            
                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: confirmPassword) { _ in
                            validatePasswordMatch()
                        }
                        
                        if !isPasswordMatching && !confirmPassword.isEmpty {
                            Text("password mismatch".localized)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Kullanım Koşulları
                    Toggle(isOn: $agreedToTerms) {
                        Text("terms of service".localized)
                            .font(.subheadline)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                }
                .padding(.horizontal)
                
                // Kayıt Ol butonu
                Button(action: {
                    Task {
                        await signUp()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("create account".localized)
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? Color.orange : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(!isFormValid || isLoading)
                
                // Giriş yap bağlantısı
                HStack {
                    Text("already have account".localized)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("sign in".localized)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    // Validation functions
    private func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
    
    private func validatePhone() {
        let phoneRegex = "^[0-9+]{10,}$" // En az 10 rakam
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        isPhoneValid = phonePredicate.evaluate(with: phoneNumber)
    }
    
    private func validatePassword() {
        isPasswordValid = password.count >= 6
    }
    
    private func validatePasswordMatch() {
        isPasswordMatching = password == confirmPassword
    }
    
    private var isFormValid: Bool {
        isEmailValid && isPasswordValid && isPasswordMatching &&
        isPhoneValid && !fullName.isEmpty && !email.isEmpty &&
        !password.isEmpty && !confirmPassword.isEmpty &&
        !phoneNumber.isEmpty && agreedToTerms
    }
    
    private func signUp() async {
        isLoading = true
        do {
            try await authManager.signUp(email: email, password: password)
            // Kullanıcı profil bilgilerini güncelle
            if let user = authManager.currentUser {
                // Firestore'a kullanıcı bilgilerini kaydet
                // Bu kısmı daha sonra Firestore entegrasyonunda yapacağız
                print("User created: \(user.uid)")
            }
            dismiss()
        } catch let error as AuthError {
            alertMessage = error.description
            showAlert = true
        } catch {
            alertMessage = "Beklenmeyen bir hata oluştu."
            showAlert = true
        }
        isLoading = false
    }
}

#Preview {
    SignUpView()
} 