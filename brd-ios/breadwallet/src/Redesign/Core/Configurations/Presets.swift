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

// TODO: Unify with designs and use color / font enums
struct Presets {
    struct Background {
        struct Primary {
            static var normal = BackgroundConfiguration(backgroundColor: LightColors.primary,
                                                        tintColor: LightColors.Contrast.two,
                                                        border: Presets.Border.normalButtonFullRadius)
            
            static var selected = BackgroundConfiguration(backgroundColor: LightColors.secondary,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.selectedButtonFullRadius)
            
            static var disabled = BackgroundConfiguration(backgroundColor: LightColors.Disabled.one,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.disabledButtonFullRadius)
            
            static var error = BackgroundConfiguration(backgroundColor: LightColors.primary,
                                                       tintColor: .red,
                                                       border: Presets.Border.error)
        }
        
        struct Secondary {
            static var normal = BackgroundConfiguration(tintColor: LightColors.Text.one)
            static var selected = BackgroundConfiguration(tintColor: LightColors.Text.one)
            static var blue = BackgroundConfiguration(tintColor: LightColors.Text.two)
            static var disabled = BackgroundConfiguration(tintColor: LightColors.Disabled.two)
            static var error = BackgroundConfiguration(tintColor: .red)
        }
        
        static var transparent = BackgroundConfiguration(backgroundColor: .clear,
                                                         tintColor: LightColors.primary)
    }
    
    struct Border {
        static var zero = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var extraSmallPlain = BorderConfiguration(borderWidth: 0, cornerRadius: .extraSmall)
        static var commonPlain = BorderConfiguration(borderWidth: 0, cornerRadius: .common)
        static var error = BorderConfiguration(tintColor: LightColors.Error.one, borderWidth: 1, cornerRadius: .medium)
        static var accountVerification = BorderConfiguration(tintColor: LightColors.Outline.one, borderWidth: 1, cornerRadius: .small)
        
        static var normal = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var selected = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var disabled = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        
        static var normalButton = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var selectedButton = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var disabledButton = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        
        static var normalButtonFullRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        static var selectedButtonFullRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        static var disabledButtonFullRadius = BorderConfiguration(borderWidth: 0, cornerRadius: .fullRadius)
        
        static var normalTextField = BorderConfiguration(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall)
        static var selectedTextField = BorderConfiguration(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall)
        static var disabledTextField = BorderConfiguration(tintColor: LightColors.Outline.two, borderWidth: 1, cornerRadius: .extraSmall)
    }
    
    // TODO: add as needed
    struct Shadow {
        // TODO: the shadow color is not part of our Color config?
        
        static var zero = ShadowConfiguration(color: .clear,
                                              opacity: .zero,
                                              offset: .zero,
                                              shadowRadius: .small)
        
        static var normal = ShadowConfiguration(color: LightColors.Contrast.one,
                                                opacity: .low,
                                                offset: .init(width: 4, height: 10),
                                                shadowRadius: .small)
        
        static var light = ShadowConfiguration(color: LightColors.Contrast.one,
                                               opacity: .lowest,
                                               offset: .init(width: 0, height: 8),
                                               shadowRadius: .small)
    }
    
    struct Image {
        static var primary = BackgroundConfiguration(tintColor: LightColors.Text.one)
        static var secondary = BackgroundConfiguration(tintColor: LightColors.Text.two)
        static var tertiary = BackgroundConfiguration(tintColor: LightColors.Contrast.two)
    }
}

extension Presets {
    struct Button {
        static var primary = ButtonConfiguration(backgroundConfiguration: Presets.Background.Primary.normal,
                                                 selectedConfiguration: Presets.Background.Primary.selected,
                                                 disabledConfiguration: Presets.Background.Primary.disabled)
        
        static var secondary = ButtonConfiguration(backgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selectedButton),
                                                   selectedConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normalButton),
                                                   disabledConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabledButton))
        
        static var popupActionButton = ButtonConfiguration(backgroundConfiguration: .init(tintColor: LightColors.Contrast.two),
                                                           selectedConfiguration: .init(tintColor: LightColors.Text.one),
                                                           disabledConfiguration: .init(tintColor: LightColors.Disabled.one))
        
        static var verificationActionButton = ButtonConfiguration(backgroundConfiguration: .init(tintColor: LightColors.Text.three),
                                                                  selectedConfiguration: .init(tintColor: LightColors.Text.two),
                                                                  disabledConfiguration: .init(tintColor: LightColors.Disabled.two))
        
        static var blackIcon = ButtonConfiguration(backgroundConfiguration: .init(tintColor: LightColors.Contrast.one),
                                                   selectedConfiguration: .init(tintColor: LightColors.Text.one),
                                                   disabledConfiguration: .init(tintColor: LightColors.Disabled.one))
    }
}

extension Presets {
    struct TextField {
        static var primary = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Text.two),
                                                    titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                    textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                    backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normalTextField),
                                                    selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selectedTextField),
                                                    disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabledTextField),
                                                    errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error))
        
        static var two = TextFieldConfiguration(titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                trailingImageConfiguration: .init(tintColor: LightColors.Text.two),
                                                backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normalTextField),
                                                selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selectedTextField),
                                                disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabledTextField),
                                                errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error))
        
        static var email = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Text.two),
                                                  titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                  textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                  backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normalTextField),
                                                  selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selectedTextField),
                                                  disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabledTextField),
                                                  errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error),
                                                  autocapitalizationType: UITextAutocapitalizationType.none,
                                                  autocorrectionType: .no,
                                                  keyboardType: .emailAddress)
        
        static var number = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Text.two),
                                                   titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   selectedTitleConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                   textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   hintConfiguration: .init(font: Fonts.Body.three, textColor: LightColors.Text.two),
                                                   backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normalTextField),
                                                   selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selectedTextField),
                                                   disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabledTextField),
                                                   errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error),
                                                   keyboardType: .numberPad)
    }
}

extension Presets {
    struct InfoView {
        static var verification = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                        headerTitle: .init(font: Fonts.Subtitle.three, textColor: LightColors.Text.three),
                                                        headerTrailing: Presets.Button.verificationActionButton,
                                                        title: .init(font: Fonts.Subtitle.three, textColor: LightColors.Text.one),
                                                        description: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                        button: Presets.Button.primary.withBorder(normal: Presets.Border.normal,
                                                                                                  selected: Presets.Border.selectedButton,
                                                                                                  disabled: Presets.Border.disabledButton),
                                                        background: .init(backgroundColor: LightColors.Background.three,
                                                                          border: Presets.Border.commonPlain),
                                                        shadow: Presets.Shadow.zero)
        
        static var primary = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                   headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                   headerTrailing: Presets.Button.verificationActionButton,
                                                   title: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                   description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                   button: Presets.Button.primary,
                                                   background: .init(backgroundColor: LightColors.secondary,
                                                                     tintColor: LightColors.Contrast.two,
                                                                     border: Presets.Border.zero),
                                                   shadow: Presets.Shadow.normal)
        
        static var error = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                 headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                 headerTrailing: Presets.Button.verificationActionButton,
                                                 title: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                 description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                 button: Presets.Button.primary,
                                                 background: .init(backgroundColor: LightColors.secondary,
                                                                   tintColor: LightColors.Contrast.two,
                                                                   border: Presets.Border.zero),
                                                 shadow: Presets.Shadow.normal)
        
        static var redAlert = InfoViewConfiguration(headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                    description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                    background: .init(backgroundColor: LightColors.Error.one,
                                                                      tintColor: LightColors.Contrast.two,
                                                                      border: Presets.Border.zero),
                                                    shadow: Presets.Shadow.zero)
    }
}

extension Presets {
    struct Alert {
        static var one = AlertConfiguration(titleConfiguration: .init(font: Fonts.Title.six, textColor: LightColors.Text.one),
                                            descriptionConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                            imageConfiguration: Presets.Image.primary,
                                            buttonConfigurations: [
                                                Presets.Button.primary,
                                                Presets.Button.secondary
                                            ])
    }
}

extension Presets {
    struct Popup {
        static var normal = PopupConfiguration(background: .init(backgroundColor: LightColors.secondary,
                                                                 tintColor: LightColors.Contrast.two,
                                                                 border: Presets.Border.zero),
                                               title: .init(font: Fonts.Title.four, textColor: LightColors.Contrast.two),
                                               body: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                               buttons: [ Presets.Button.primary.withBorder(normal: Presets.Border.zero,
                                                                                            selected: Presets.Border.selectedButton,
                                                                                            disabled: Presets.Border.disabledButton),
                                                          Presets.Button.secondary ],
                                               closeButton: Presets.Button.popupActionButton)
        
        static var white = PopupConfiguration(background: .init(backgroundColor: LightColors.Background.one,
                                                                tintColor: LightColors.Contrast.two,
                                                                border: Presets.Border.zero),
                                              title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                              body: .init(font: Fonts.Body.one, textColor: LightColors.Text.one, textAlignment: .left),
                                              buttons: [ Presets.Button.primary.withBorder(normal: Presets.Border.zero,
                                                                                           selected: Presets.Border.selectedButton,
                                                                                           disabled: Presets.Border.disabledButton),
                                                         Presets.Button.secondary ],
                                              closeButton: Presets.Button.blackIcon)
        
        static var whiteDimmed = PopupConfiguration(background: .init(backgroundColor: LightColors.Background.one,
                                                                      tintColor: LightColors.Contrast.two,
                                                                      border: Presets.Border.zero),
                                                    title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                    body: .init(font: Fonts.Body.one, textColor: LightColors.Text.one, textAlignment: .center),
                                                    
                                                    buttons: [ Presets.Button.primary.withBorder(normal: Presets.Border.zero,
                                                                                                 selected: Presets.Border.selectedButton,
                                                                                                 disabled: Presets.Border.disabledButton),
                                                               Presets.Button.secondary ],
                                                    closeButton: Presets.Button.blackIcon)
    }
}

extension Presets {
    struct Animation {
        static var duration = 0.25
    }
}

extension Presets {
    struct VerificationView {
        static var resubmitAndDeclined = VerificationConfiguration(shadow: Presets.Shadow.zero,
                                                                   background: .init(backgroundColor: LightColors.Background.one,
                                                                                     tintColor: LightColors.Outline.two,
                                                                                     border: Presets.Border.zero),
                                                                   title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                                   status: .init(title: .init(font: Fonts.Body.two,
                                                                                              textColor: LightColors.Contrast.two,
                                                                                              textAlignment: .center),
                                                                                 background: .init(backgroundColor: LightColors.Error.one,
                                                                                                   tintColor: LightColors.Contrast.two,
                                                                                                   border: Presets.Border.extraSmallPlain)),
                                                                   infoButton: .init(backgroundConfiguration: Presets.Background.Secondary.normal,
                                                                                     selectedConfiguration: Presets.Background.Secondary.selected,
                                                                                     disabledConfiguration: Presets.Background.Secondary.disabled),
                                                                   description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                                   benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
        
        static var pending = VerificationConfiguration(shadow: Presets.Shadow.zero,
                                                       background: .init(backgroundColor: LightColors.Background.one,
                                                                         tintColor: LightColors.Outline.two,
                                                                         border: Presets.Border.zero),
                                                       title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                       status: .init(title: .init(font: Fonts.Body.two,
                                                                                  textColor: LightColors.Contrast.one,
                                                                                  textAlignment: .center),
                                                                     background: .init(backgroundColor: LightColors.Pending.one,
                                                                                       tintColor: LightColors.Contrast.one,
                                                                                       border: Presets.Border.extraSmallPlain)),
                                                       infoButton: .init(backgroundConfiguration: Presets.Background.Secondary.normal,
                                                                         selectedConfiguration: Presets.Background.Secondary.selected,
                                                                         disabledConfiguration: Presets.Background.Secondary.disabled),
                                                       description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                       benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
        
        static var verified = VerificationConfiguration(shadow: Presets.Shadow.zero,
                                                        background: .init(backgroundColor: LightColors.Background.one,
                                                                          tintColor: LightColors.Outline.two,
                                                                          border: Presets.Border.zero),
                                                        title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                        status: .init(title: .init(font: Fonts.Body.two,
                                                                                   textColor: LightColors.Contrast.two,
                                                                                   textAlignment: .center),
                                                                      background: .init(backgroundColor: LightColors.Success.one,
                                                                                        tintColor: LightColors.Contrast.two,
                                                                                        border: Presets.Border.extraSmallPlain)),
                                                        infoButton: .init(backgroundConfiguration: Presets.Background.Secondary.normal,
                                                                          selectedConfiguration: Presets.Background.Secondary.selected,
                                                                          disabledConfiguration: Presets.Background.Secondary.disabled),
                                                        description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                        benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
    }
}

extension Presets {
    struct Order {
        static var small = OrderConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center, numberOfLines: 1),
                                              copyableValue: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .center, numberOfLines: 1,
                                                                   lineBreakMode: .byTruncatingTail),
                                              regularValue: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .center, numberOfLines: 1),
                                              shadow: Presets.Shadow.light,
                                              background: .init(backgroundColor: LightColors.Background.one,
                                                                tintColor: LightColors.Text.one,
                                                                border: Presets.Border.zero),
                                              contentBackground: .init(tintColor: LightColors.Text.one,
                                                                       border: .init(tintColor: LightColors.Text.one,
                                                                                     borderWidth: BorderWidth.minimum.rawValue,
                                                                                     cornerRadius: .medium)))
        
        static var full = OrderConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center, numberOfLines: 1),
                                             copyableValue: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center, numberOfLines: 0),
                                             regularValue: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .center, numberOfLines: 1),
                                             shadow: Presets.Shadow.light,
                                             background: .init(backgroundColor: LightColors.Background.one,
                                                               tintColor: LightColors.Text.one,
                                                               border: Presets.Border.zero),
                                             contentBackground: .init(tintColor: LightColors.Text.one,
                                                                      border: .init(borderWidth: 0, cornerRadius: .zero)))
    }
}

extension Presets {
    struct Asset {
        static var header = AssetConfiguration(topConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one),
                                               bottomConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two),
                                               topRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .right),
                                               bottomRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two, textAlignment: .right),
                                               backgroundConfiguration: .init(backgroundColor: LightColors.tertiary,
                                                                              tintColor: LightColors.Text.one,
                                                                              border: Presets.Border.zero),
                                               imageConfig: .init(backgroundColor: LightColors.Pending.one,
                                                                  tintColor: .white,
                                                                  border: .init(borderWidth: 0,
                                                                                cornerRadius: .medium)),
                                               imageSize: .small)
        
        static var enabled = AssetConfiguration(topConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one),
                                                bottomConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two),
                                                topRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .right),
                                                bottomRightConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two, textAlignment: .right))
        
        static var disabled = AssetConfiguration(topConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one.withAlphaComponent(0.5)),
                                                 bottomConfiguration: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.two.withAlphaComponent(0.5)),
                                                 topRightConfiguration: .init(font: Fonts.Subtitle.two,
                                                                              textColor: LightColors.Text.one.withAlphaComponent(0.5),
                                                                              textAlignment: .right),
                                                 bottomRightConfiguration: .init(font: Fonts.Subtitle.two,
                                                                                 textColor: LightColors.Text.two.withAlphaComponent(0.5),
                                                                                 textAlignment: .right),
                                                 imageAlpha: 0.5)
    }
}

extension Presets {
    struct TitleValue {
        static var horizontal = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, numberOfLines: 1),
                                                        value: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var vertical = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, numberOfLines: 1),
                                                      value: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var verticalSmall = TitleValueConfiguration(title: .init(font: Fonts.Body.three, textColor: LightColors.Text.one, numberOfLines: 1),
                                                           value: .init(font: Fonts.Body.three, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var subtitle = TitleValueConfiguration(title: .init(font: Fonts.Subtitle.one, textColor: LightColors.Text.one, numberOfLines: 1),
                                                      value: .init(font: Fonts.Subtitle.one, textColor: LightColors.Text.one, textAlignment: .right))
    }
}

extension Presets {
    struct Timer {
        static var one = TimerConfiguration(background: .init(tintColor: LightColors.primary), font: Fonts.Body.two)
    }
}
