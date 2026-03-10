import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    static var detailsSystemBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .systemBackground)
#elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
#else
        .white
#endif
    }

    static var detailsSecondaryGroupedBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemGroupedBackground)
#elseif canImport(AppKit)
        Color(nsColor: .underPageBackgroundColor)
#else
        .gray.opacity(0.2)
#endif
    }

    static var detailsQuaternaryLabel: Color {
#if canImport(UIKit)
        Color(uiColor: .quaternaryLabel)
#elseif canImport(AppKit)
        Color(nsColor: .tertiaryLabelColor)
#else
        .gray
#endif
    }
}
