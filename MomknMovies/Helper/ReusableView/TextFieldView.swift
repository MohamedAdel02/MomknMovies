//
//  TextFieldView.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 17/08/2026.
//

import SwiftUI

struct TextFieldView: View {
    
    let label: LocalizedStringKey
    let placeholder: String
    
    @Binding var text: String
    
    var isSecured = false
    var submitLabel: SubmitLabel = .done
    var labelSize: CGFloat = 15
    var isInvalid: Bool = false
    var isDisabled: Bool = false
    
    @AppStorage("selectedLanguage")
    private var selectedLanguage: String?
    
    @Environment(\.layoutDirection)
    private var layoutDirection
    
    @State private var isPasswordVisible = false
    
    private var localizedPlaceholder: String {
        
        let languageCode = selectedLanguage ?? "en"
        
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
            let languageBundle = Bundle(path: path)
        else {
            return placeholder
        }
        
        return languageBundle.localizedString(
            forKey: placeholder,
            value: placeholder,
            table: nil
        )
    }
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            Text(label)
                .padding(.leading, 4)
                .fontWeight(.bold)
                .font(.system(size: labelSize))
                .foregroundStyle(.customGray)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            
            RTLTextField(
                text: $text,
                isPasswordVisible: $isPasswordVisible,
                placeholder: localizedPlaceholder,
                isSecured: isSecured,
                isRTL: layoutDirection == .rightToLeft,
                textColor: isDisabled ? UIColor.white.withAlphaComponent(0.5) : .white

            )
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .submitLabel(submitLabel)
            .disabled(isDisabled)
            .padding([.leading, .trailing], 14)
            .frame(height: 50)
            .background(Color.textField.opacity(isDisabled ? 0.5 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    TextFieldView(
        label: "Password",
        placeholder: "Enter your password",
        text: .constant(""),
        isSecured: true
    )
}
