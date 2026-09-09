//
//  RTLTextField.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 19/08/2026.
//

import SwiftUI
import UIKit

struct RTLTextField: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isPasswordVisible: Bool
    
    var placeholder: String
    var isSecured: Bool = false
    var isRTL: Bool
    var textColor: UIColor = .white
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textColor = textColor
        textField.tintColor = textColor
        
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange(_:)),
            for: .editingChanged
        )
        
        configureTextField(textField, context: context)
        return textField
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        context.coordinator.parent = self
        
        if !context.coordinator.isEditing && textField.text != text {
            textField.text = text
        }
        
        if textField.textColor != textColor {
            textField.textColor = textColor
        }
        if textField.tintColor != textColor {
            textField.tintColor = textColor
        }
        
        let targetAlignment: NSTextAlignment = isRTL ? .right : .left
        if textField.textAlignment != targetAlignment {
            textField.textAlignment = targetAlignment
        }
        
        let targetSemantic: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        if textField.semanticContentAttribute != targetSemantic {
            textField.semanticContentAttribute = targetSemantic
        }
        
        let shouldSecure = isSecured && !isPasswordVisible
        if textField.isSecureTextEntry != shouldSecure {
            setSecureTextEntry(textField, secure: shouldSecure)
        }
        
        let placeholderString = placeholder
        if textField.placeholder != placeholderString {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderString,
                attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
            )
        }
        
        updateEyeButtonImage(textField, context: context)
    }
        
    private func setSecureTextEntry(_ textField: UITextField, secure: Bool) {
        let currentText = textField.text ?? ""
        let cursorOffset: Int
        
        if let selectedRange = textField.selectedTextRange {
            cursorOffset = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        } else {
            cursorOffset = currentText.count
        }
        
        textField.isSecureTextEntry = secure
        
        if textField.isFirstResponder {
            textField.text = ""
            textField.insertText(currentText)
        }
        
        DispatchQueue.main.async {
            guard
                textField.window != nil,
                let position = textField.position(
                    from: textField.beginningOfDocument,
                    offset: min(cursorOffset, textField.text?.count ?? 0)
                )
            else {
                return
            }
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }
    
    
    private func configureTextField(_ tf: UITextField, context: Context) {
        tf.textAlignment = isRTL ? .right : .left
        tf.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )
        
        setupEyeButtonIfNeeded(tf, context: context)
    }
    
    private func setupEyeButtonIfNeeded(_ tf: UITextField, context: Context) {
        guard isSecured else {
            tf.rightView = nil
            tf.rightViewMode = .never
            return
        }
        
        let button: UIButton
        if let existingButton = context.coordinator.eyeButton {
            button = existingButton
        } else {
            button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            button.tintColor = UIColor.white.withAlphaComponent(0.65)
            button.semanticContentAttribute = .forceLeftToRight
            button.addTarget(context.coordinator, action: #selector(Coordinator.togglePassword), for: .touchUpInside)
            context.coordinator.eyeButton = button
        }
        
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        button.setImage(UIImage(systemName: imageName), for: .normal)
        
        tf.rightView = button
        tf.rightViewMode = .always
    }
    
    private func updateEyeButtonImage(_ tf: UITextField, context: Context) {
        guard isSecured, let button = context.coordinator.eyeButton else { return }
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .customGray
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: RTLTextField
        weak var eyeButton: UIButton?
        var isEditing: Bool = false
        
        init(_ parent: RTLTextField) {
            self.parent = parent
        }
        
        @objc func togglePassword() {
            parent.isPasswordVisible.toggle()
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            let newText = textField.text ?? ""
            if parent.text != newText {
                DispatchQueue.main.async { [weak self] in
                    self?.parent.text = newText
                }
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            isEditing = true
            
            // FIX: When returning to focus on a secure text field, iOS drops
            // the internal typing buffer cache.
            if parent.isSecured {
                let existingText = textField.text ?? ""
                if !existingText.isEmpty {
                    textField.text = ""
                    textField.insertText(existingText)
                }
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            isEditing = false
            let final = textField.text ?? ""
            let previousParentText = parent.text
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                // Only apply this if nothing else (e.g. a manual clear()) changed
                // the bound text in the meantime — otherwise this would clobber it.
                if self.parent.text == previousParentText {
                    self.parent.text = final
                }
            }
        }
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextField, context: Context) -> CGSize? {
        let width = proposal.width ?? uiView.intrinsicContentSize.width
        let height = uiView.font?.lineHeight ?? 20
        return CGSize(width: width, height: height + 16) // adjust padding to taste
    }
}
