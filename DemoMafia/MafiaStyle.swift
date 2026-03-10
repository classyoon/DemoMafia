//
//  MafiaStyle.swift
//  DemoMafia
//
//  Centralized UI tuning knobs for quick iteration.
//

import SwiftUI

enum MafiaUI {
    enum Layout {
        static let maxContentWidth: CGFloat = 560
        static let screenPadding: CGFloat = 20
        static let cardPadding: CGFloat = 14
        static let cardCornerRadius: CGFloat = 14
        static let rowCornerRadius: CGFloat = 8
        static let buttonCornerRadius: CGFloat = 14
    }

    enum Colors {
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.94)
        static let textMuted = Color.white.opacity(0.84)
        static let cardFill = Color.black.opacity(0.44)
        static let cardFillSoft = Color.white.opacity(0.14)
        static let cardStroke = Color.white.opacity(0.24)
        static let selectedFill = Color.green.opacity(0.30)
        static let selectedStroke = Color.green.opacity(0.80)
    }

    enum Gradients {
        static let menu = LinearGradient(
            colors: [Color.black, Color(red: 0.08, green: 0.04, blue: 0.20), Color(red: 0.20, green: 0.05, blue: 0.10)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let setup = LinearGradient(
            colors: [Color.black, Color(red: 0.06, green: 0.08, blue: 0.24), Color(red: 0.12, green: 0.03, blue: 0.19)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let night = LinearGradient(
            colors: [Color.black, Color(red: 0.09, green: 0.03, blue: 0.25), Color(red: 0.17, green: 0.05, blue: 0.11)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let day = LinearGradient(
            colors: [Color(red: 0.06, green: 0.05, blue: 0.12), Color(red: 0.15, green: 0.13, blue: 0.06), Color(red: 0.25, green: 0.12, blue: 0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let end = LinearGradient(
            colors: [Color.black, Color(red: 0.15, green: 0.04, blue: 0.11), Color(red: 0.08, green: 0.10, blue: 0.21)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct MafiaPrimaryButtonStyle: ButtonStyle {
    let fill: Color
    var textColor: Color = .white
    var font: Font = .headline.weight(.bold)
    var cornerRadius: CGFloat = MafiaUI.Layout.buttonCornerRadius

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fill.opacity(configuration.isPressed ? 0.76 : 0.94))
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct MafiaMenuButtonStyle: ButtonStyle {
    let fill: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.black))
            .foregroundColor(.black.opacity(0.82))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(fill.opacity(configuration.isPressed ? 0.70 : 0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.20), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

private struct MafiaCardModifier: ViewModifier {
    let fill: Color
    let stroke: Color
    let cornerRadius: CGFloat
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(stroke, lineWidth: 1)
                    )
            )
    }
}

extension View {
    func mafiaContentFrame() -> some View {
        frame(maxWidth: MafiaUI.Layout.maxContentWidth)
            .padding(MafiaUI.Layout.screenPadding)
    }

    func mafiaCard(
        fill: Color = MafiaUI.Colors.cardFill,
        stroke: Color = MafiaUI.Colors.cardStroke,
        cornerRadius: CGFloat = MafiaUI.Layout.cardCornerRadius,
        padding: CGFloat = MafiaUI.Layout.cardPadding
    ) -> some View {
        modifier(MafiaCardModifier(fill: fill, stroke: stroke, cornerRadius: cornerRadius, padding: padding))
    }
}
