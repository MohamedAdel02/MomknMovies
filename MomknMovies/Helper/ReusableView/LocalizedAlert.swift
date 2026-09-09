//
//  LocalizedAlert.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 07/09/2026.
//

import SwiftUI
import UIKit

private final class DirectionalAlertController: UIAlertController {

    var isArabic: Bool = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyDirection(to: view, isArabic: isArabic)
    }

    private func applyDirection(to view: UIView, isArabic: Bool) {
        view.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight

        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textAlignment = isArabic ? .right : .left
                label.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
            }
            if let textField = subview as? UITextField {
                textField.textAlignment = isArabic ? .right : .left
                textField.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
            }
            applyDirection(to: subview, isArabic: isArabic)
        }
    }
}

/// A single button in a LocalizedAlert.
struct LocalizedAlertButton {
    enum Role {
        case cancel
        case destructive
        case `default`

        var uiKitStyle: UIAlertAction.Style {
            switch self {
            case .cancel: return .cancel
            case .destructive: return .destructive
            case .default: return .default
            }
        }
    }

    let title: String
    let role: Role
    let action: () -> Void

    init(_ title: String, role: Role = .default, action: @escaping () -> Void = {}) {
        self.title = title
        self.role = role
        self.action = action
    }
}

/// A UIKit-backed alert that correctly respects the app's own
/// language/direction setting (selectedLanguage), independent of the
/// device's system language — unlike SwiftUI's native `.alert(...)`,
/// which derives its layout direction from the system locale and
/// ignores `.environment(\.layoutDirection, ...)`.
///
/// Supports multiple buttons with roles, and an optional secure text
/// field (e.g. for password re-entry prompts).
struct LocalizedAlert: UIViewControllerRepresentable {

    @Binding var isPresented: Bool

    let title: String
    let message: String
    let buttons: [LocalizedAlertButton]
    let isArabic: Bool

    /// Optional secure text field. When provided, a password-style
    /// field is added to the alert, bound to this value.
    var secureFieldPlaceholder: String? = nil
    var secureFieldText: Binding<String>? = nil

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(
        _ viewController: UIViewController,
        context: Context
    ) {
        guard isPresented else { return }

        // Don't present it more than once
        guard viewController.presentedViewController == nil else {
            return
        }

        let alert = DirectionalAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.isArabic = isArabic

        if let placeholder = secureFieldPlaceholder, let textBinding = secureFieldText {
            alert.addTextField { textField in
                textField.placeholder = placeholder
                textField.isSecureTextEntry = true
                textField.text = textBinding.wrappedValue
                textField.textAlignment = isArabic ? .right : .left
                textField.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
            }
        }

        for button in buttons {
            let action = UIAlertAction(
                title: button.title,
                style: button.role.uiKitStyle
            ) { _ in
                if let textBinding = secureFieldText,
                   let field = alert.textFields?.first {
                    textBinding.wrappedValue = field.text ?? ""
                }
                isPresented = false
                button.action()
            }
            alert.addAction(action)
        }

        viewController.present(alert, animated: true)
    }
}
