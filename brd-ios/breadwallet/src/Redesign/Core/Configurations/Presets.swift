// 
//  Presets.swift
//  breadwallet
//
//  Created by Rok on 11/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

// TODO: unify with designs and use color / font enums
struct Presets {
    // TODO: prolly each BG has to have a "borderConfig"
    struct Background {
        struct Primary {
            static func normal(withBorder: Bool = false) -> BackgroundConfiguration {
                var border: BorderConfiguration?
                if withBorder {
                    border = Presets.Border.normal
                }
                return .init(backgroundColor: LightColors.primary, tintColor: LightColors.Contrast.secondary, border: border)
            }
            
            static func selected(withBorder: Bool = false) -> BackgroundConfiguration {
                var border: BorderConfiguration?
                if withBorder {
                    border = Presets.Border.selected
                }
                return .init(backgroundColor: LightColors.InteractionPrimary.pressed, tintColor: LightColors.Contrast.secondary, border: border)
            }
            
            static func disabled(withBorder: Bool = false) -> BackgroundConfiguration {
                var border: BorderConfiguration?
                if withBorder {
                    border = Presets.Border.normal
                }
                return .init(backgroundColor: LightColors.InteractionPrimary.disabled, tintColor: LightColors.Contrast.secondary, border: border)
            }
            
            static func error(withBorder: Bool = false) -> BackgroundConfiguration {
                var border: BorderConfiguration?
                if withBorder {
                    border = Presets.Border.error
                }
                return .init(backgroundColor: LightColors.primary, tintColor: LightColors.error, border: border)
            }
        }
        
        struct Secondary {
            static var normal = BackgroundConfiguration(tintColor: LightColors.Link.primary)
            static var normalWithBorder = BackgroundConfiguration(tintColor: LightColors.Link.primary, border: Presets.Border.normal)
            static var selected = BackgroundConfiguration(tintColor: LightColors.primary, border: Presets.Border.selected)
            static var disabled = BackgroundConfiguration(tintColor: LightColors.InteractionPrimary.disabled)
            static var error = BackgroundConfiguration(tintColor: LightColors.error, border: Presets.Border.error)
        }
    }
    
    struct Border {
        static var normal = BorderConfiguration(tintColor: LightColors.Outline.primary, borderWidth: 1, cornerRadius: .small)
        static var selected = BorderConfiguration(tintColor: LightColors.primary, borderWidth: 1, cornerRadius: .small)
        static var error = BorderConfiguration(tintColor: LightColors.error, borderWidth: 1, cornerRadius: .small)
        static var zero = BorderConfiguration(borderWidth: 0, cornerRadius: .small)
    }
    
    // TODO: add as needed
    struct Shadow {
        // TODO: the shadow color is not part of our Color config?
        static var normal = ShadowConfiguration(color: LightColors.Contrast.primary,
                                                opacity: .low,
                                                offset: .init(width: 4, height: 10),
                                                cornerRadius: .small)
        static var zero = ShadowConfiguration(color: .clear, opacity: .zero, offset: .zero, cornerRadius: .small)
    }
    
    struct Label {
        // TODO: fonts
        static var primary = LabelConfiguration(font: .systemFont(ofSize: 14), textColor: LightColors.Text.primary)
        static var secondary = LabelConfiguration(font: .systemFont(ofSize: 12), textColor: LightColors.Text.secondary)
        static var tertiary = LabelConfiguration(font: .boldSystemFont(ofSize: 16), textColor: LightColors.Contrast.secondary)
        static var contrast = LabelConfiguration(font: .systemFont(ofSize: 14), textColor: LightColors.Contrast.secondary)
    }
    
    struct Image {
        static var primary = ImageViewConfiguration(tintColor: LightColors.Text.primary)
        static var secondary = ImageViewConfiguration(tintColor: LightColors.Text.secondary)
        static var tertiary = ImageViewConfiguration(tintColor: LightColors.Contrast.secondary)
    }
}

// TODO: unify presets with designs
extension Presets {
    struct Button {
        static var primary = ButtonConfiguration(backgroundConfiguration: Presets.Background.Primary.normal(withBorder: true),
                                                 selectedConfiguration: Presets.Background.Primary.selected(withBorder: true),
                                                 disabledConfiguration: Presets.Background.Primary.disabled(withBorder: true))
        
        static var secondary = ButtonConfiguration(backgroundConfiguration: Presets.Background.Secondary.selected,
                                                   selectedConfiguration: Presets.Background.Secondary.normal,
                                                   disabledConfiguration: Presets.Background.Secondary.disabled)
    }
    
    struct TexxtField {
        static var primary = TextFieldConfiguration(leadingImageConfiguration: .init(tintColor: LightColors.Icons.secondary),
                                                    titleConfiguration: .init(font: Fonts.overline, textColor: LightColors.Text.secondary),
                                                    textConfiguration: Presets.Label.primary,
                                                    placeholderConfiguration: Presets.Label.primary,
                                                    hintConfiguration: Presets.Label.secondary,
                                                    backgroundConfiguration: Presets.Background.Secondary.normalWithBorder,
                                                    selectedBackgroundConfiguration: Presets.Background.Secondary.selected,
                                                    disabledBackgroundConfiguration: Presets.Background.Secondary.disabled,
                                                    errorBackgroundConfiguration: Presets.Background.Secondary.error)
    }
    
    struct InfoView {
        static var primary = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                   headerTitle: Presets.Label.tertiary,
                                                   headerTrailingImage: Presets.Image.tertiary,
                                                   title: Presets.Label.tertiary,
                                                   description: Presets.Label.contrast,
                                                   button: Presets.Button.primary,
                                                   background: .init(backgroundColor: LightColors.secondary,
                                                                     tintColor: LightColors.Contrast.secondary),
                                                   shadow: Presets.Shadow.normal)
    }
}
