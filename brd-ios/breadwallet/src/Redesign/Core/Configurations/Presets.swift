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
                                                        border: Presets.Border.normal)
            
            static var selected = BackgroundConfiguration(backgroundColor: LightColors.InteractionPrimary.pressed,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.selected)
            
            static var disabled = BackgroundConfiguration(backgroundColor: LightColors.InteractionPrimary.disabled,
                                                          tintColor: LightColors.Contrast.two,
                                                          border: Presets.Border.disabled)
            
            static var error = BackgroundConfiguration(backgroundColor: LightColors.primary,
                                                       tintColor: .red,
                                                       border: Presets.Border.error)
        }
        
        struct Secondary {
            static var normal = BackgroundConfiguration(tintColor: LightColors.Link.one)
            static var selected = BackgroundConfiguration(tintColor: LightColors.Link.one)
            static var blue = BackgroundConfiguration(tintColor: LightColors.Link.two)
            static var disabled = BackgroundConfiguration(tintColor: LightColors.InteractionPrimary.disabled)
            static var error = BackgroundConfiguration(tintColor: .red)
        }
        
        static var transparent = BackgroundConfiguration(backgroundColor: .clear,
                                                         tintColor: LightColors.primary)
    }
    
    struct Border {
        static var zero = BorderConfiguration(borderWidth: 0, cornerRadius: .medium)
        static var small = BorderConfiguration(tintColor: LightColors.Outline.one, borderWidth: 0, cornerRadius: .small)
        static var normal = BorderConfiguration(tintColor: LightColors.Outline.one, borderWidth: 1, cornerRadius: .medium)
        static var selected = BorderConfiguration(tintColor: LightColors.primary, borderWidth: 1, cornerRadius: .medium)
        static var disabled = BorderConfiguration(tintColor: .lightGray, borderWidth: 1, cornerRadius: .medium)
        static var cardDetails = BorderConfiguration(borderWidth: 0, cornerRadius: .extraSmall)
        static var error = BorderConfiguration(tintColor: LightColors.error, borderWidth: 1, cornerRadius: .medium)
        static var accountVerification = BorderConfiguration(tintColor: LightColors.Outline.one, borderWidth: 1, cornerRadius: .small)
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
        
        static var secondary = ButtonConfiguration(backgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selected),
                                                   selectedConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normal),
                                                   disabledConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabled))
        
        static var blue = ButtonConfiguration(backgroundConfiguration: Presets.Background.Secondary.blue.withBorder(border: Presets.Border.selected),
                                                   selectedConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normal))
        
        static var icon = ButtonConfiguration(backgroundConfiguration: .init(tintColor: LightColors.Contrast.two),
                                              selectedConfiguration: .init(tintColor: LightColors.Icons.one),
                                              disabledConfiguration: .init(tintColor: LightColors.InteractionPrimary.disabled))
        
        static var link = ButtonConfiguration(backgroundConfiguration: .init(tintColor: LightColors.Link.one),
                                              selectedConfiguration: .init(tintColor: LightColors.Link.two),
                                              disabledConfiguration: .init(tintColor: LightColors.InteractionPrimary.disabled))
        
        static var blackIcon = ButtonConfiguration(backgroundConfiguration: .init(tintColor: LightColors.Contrast.one),
                                                   selectedConfiguration: .init(tintColor: LightColors.Icons.one),
                                                   disabledConfiguration: .init(tintColor: LightColors.InteractionPrimary.disabled))
    }
}

extension Presets {
    struct TextField {
        static var primary = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Icons.two),
                                                    titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    selectedTitleConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                    textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                    hintConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                    backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normal),
                                                    selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selected),
                                                    disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabled),
                                                    errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error))
        
        static var two = TextFieldConfiguration(titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                selectedTitleConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                hintConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                trailingImageConfiguration: .init(tintColor: LightColors.Text.two),
                                                backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normal),
                                                selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selected),
                                                disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabled),
                                                errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error))
        
        static var email = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Icons.two),
                                                  titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  selectedTitleConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                  textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                  hintConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                  backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normal),
                                                  selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selected),
                                                  disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabled),
                                                  errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error),
                                                  autocapitalizationType: UITextAutocapitalizationType.none,
                                                  autocorrectionType: .no,
                                                  keyboardType: .emailAddress)
        
        static var number = TextFieldConfiguration(leadingImageConfiguration: .init(backgroundColor: .clear, tintColor: LightColors.Icons.two),
                                                   titleConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   selectedTitleConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                   textConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   placeholderConfiguration: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                   hintConfiguration: .init(font: Fonts.caption, textColor: LightColors.Text.two),
                                                   backgroundConfiguration: Presets.Background.Secondary.normal.withBorder(border: Presets.Border.normal),
                                                   selectedBackgroundConfiguration: Presets.Background.Secondary.selected.withBorder(border: Presets.Border.selected),
                                                   disabledBackgroundConfiguration: Presets.Background.Secondary.disabled.withBorder(border: Presets.Border.disabled),
                                                   errorBackgroundConfiguration: Presets.Background.Secondary.error.withBorder(border: Presets.Border.error),
                                                   keyboardType: .numberPad)
    }
}

extension Presets {
    struct InfoView {
        static var verification = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                        headerTitle: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                        headerTrailing: Presets.Button.icon,
                                                        status: VerificationView.resubmit.status,
                                                        title: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                        description: .init(font: Fonts.Subtitle.two, textColor: LightColors.Contrast.two),
                                                        button: Presets.Button.primary.withBorder(normal: Presets.Border.small,
                                                                                                  selected: Presets.Border.selected,
                                                                                                  disabled: Presets.Border.disabled),
                                                        background: .init(backgroundColor: LightColors.secondary,
                                                                          tintColor: LightColors.Contrast.two,
                                                                          border: Presets.Border.small),
                                                        shadow: Presets.Shadow.normal)
        
        static var verificationPrompt = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                              headerTitle: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                              headerTrailing: Presets.Button.icon,
                                                              status: VerificationView.resubmit.status,
                                                              title: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                              description: .init(font: Fonts.Subtitle.two, textColor: LightColors.Contrast.two),
                                                              button: Presets.Button.primary.withBorder(normal: Presets.Border.small,
                                                                                                        selected: Presets.Border.selected,
                                                                                                        disabled: Presets.Border.disabled),
                                                              background: .init(backgroundColor: LightColors.secondary,
                                                                                tintColor: LightColors.Contrast.two,
                                                                                border: Presets.Border.small),
                                                              shadow: Presets.Shadow.normal)
        
        static var pending = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                   headerTitle: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                   headerTrailing: Presets.Button.icon,
                                                   status: VerificationView.pending.status,
                                                   title: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                   description: .init(font: Fonts.Subtitle.two, textColor: LightColors.Contrast.two),
                                                   button: Presets.Button.primary.withBorder(normal: Presets.Border.small,
                                                                                             selected: Presets.Border.selected,
                                                                                             disabled: Presets.Border.disabled),
                                                   background: .init(backgroundColor: LightColors.secondary,
                                                                     tintColor: LightColors.Contrast.two,
                                                                     border: Presets.Border.small),
                                                   shadow: Presets.Shadow.normal)
        
        static var verified = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                    headerTitle: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                    headerTrailing: Presets.Button.icon,
                                                    status: VerificationView.verified.status,
                                                    title: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                    description: .init(font: Fonts.Subtitle.two, textColor: LightColors.Contrast.two),
                                                    button: Presets.Button.primary.withBorder(normal: Presets.Border.small,
                                                                                              selected: Presets.Border.selected,
                                                                                              disabled: Presets.Border.disabled),
                                                    background: .init(backgroundColor: LightColors.secondary,
                                                                      tintColor: LightColors.Contrast.two,
                                                                      border: Presets.Border.small),
                                                    shadow: Presets.Shadow.normal)
        
        static var declined = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                    headerTitle: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                    headerTrailing: Presets.Button.icon,
                                                    status: VerificationView.resubmit.status,
                                                    title: .init(font: Fonts.overline, textColor: LightColors.Contrast.two),
                                                    description: .init(font: Fonts.Subtitle.two, textColor: LightColors.Contrast.two),
                                                    button: Presets.Button.primary.withBorder(normal: Presets.Border.small,
                                                                                              selected: Presets.Border.selected,
                                                                                              disabled: Presets.Border.disabled),
                                                    background: .init(backgroundColor: LightColors.secondary,
                                                                      tintColor: LightColors.Contrast.two,
                                                                      border: Presets.Border.small),
                                                    shadow: Presets.Shadow.normal)
        
        static var primary = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                   headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                   headerTrailing: Presets.Button.icon,
                                                   title: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                   description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                   button: Presets.Button.primary,
                                                   background: .init(backgroundColor: LightColors.secondary,
                                                                     tintColor: LightColors.Contrast.two,
                                                                     border: Presets.Border.zero),
                                                   shadow: Presets.Shadow.normal)
        
        static var error = InfoViewConfiguration(headerLeadingImage: Presets.Image.tertiary,
                                                 headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                 headerTrailing: Presets.Button.icon,
                                                 title: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                 description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                 button: Presets.Button.primary,
                                                 background: .init(backgroundColor: LightColors.secondary,
                                                                   tintColor: LightColors.Contrast.two,
                                                                   border: Presets.Border.zero),
                                                 shadow: Presets.Shadow.normal)
        
        static var swapError = InfoViewConfiguration(headerTitle: .init(font: Fonts.Title.six, textColor: LightColors.Contrast.two),
                                                     description: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                                     background: .init(backgroundColor: LightColors.error,
                                                                       tintColor: LightColors.Contrast.two,
                                                                       border: Presets.Border.zero),
                                                     shadow: Presets.Shadow.zero)
    }
}

extension Presets {
    struct Alert {
        // TODO: not styled yet
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
                                               title: .init(font: Fonts.Title.seven, textColor: LightColors.Contrast.two),
                                               body: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two),
                                               buttons: [ Presets.Button.primary.withBorder(normal: Presets.Border.zero,
                                                                                            selected: Presets.Border.selected,
                                                                                            disabled: Presets.Border.disabled),
                                                          Presets.Button.secondary ],
                                               closeButton: Presets.Button.icon)
        
        static var white = PopupConfiguration(background: .init(backgroundColor: LightColors.Background.one,
                                                                tintColor: LightColors.Contrast.two,
                                                                border: Presets.Border.zero),
                                              title: .init(font: Fonts.Title.five, textColor: LightColors.Icons.one),
                                              body: .init(font: Fonts.Body.one, textColor: LightColors.Icons.one, textAlignment: .left),
                                              buttons: [ Presets.Button.primary.withBorder(normal: Presets.Border.zero,
                                                                                           selected: Presets.Border.selected,
                                                                                           disabled: Presets.Border.disabled),
                                                         Presets.Button.secondary ],
                                              closeButton: Presets.Button.blackIcon)
        
        static var whiteDimmed = PopupConfiguration(background: .init(backgroundColor: LightColors.Background.one,
                                                                      tintColor: LightColors.Contrast.two,
                                                                      border: Presets.Border.zero),
                                                    title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                    body: .init(font: Fonts.Body.one, textColor: LightColors.Text.one, textAlignment: .center),
                                                    
                                                    buttons: [ Presets.Button.primary.withBorder(normal: Presets.Border.zero,
                                                                                                 selected: Presets.Border.selected,
                                                                                                 disabled: Presets.Border.disabled),
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
        static var none = VerificationConfiguration(shadow: Presets.Shadow.light,
                                                    background: .init(backgroundColor: LightColors.secondary,
                                                                      tintColor: LightColors.Contrast.two,
                                                                      border: Presets.Border.zero),
                                                    title: .init(font: Fonts.Title.five, textColor: LightColors.Contrast.two),
                                                    infoButton: .init(backgroundConfiguration: .init(tintColor: LightColors.Contrast.two),
                                                                      selectedConfiguration: Presets.Background.Secondary.normal,
                                                                      disabledConfiguration: Presets.Background.Secondary.disabled),
                                                    description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                    benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
        
        static var resubmit = VerificationConfiguration(shadow: Presets.Shadow.light,
                                                        background: .init(backgroundColor: LightColors.Background.one,
                                                                          tintColor: LightColors.Outline.two,
                                                                          border: Presets.Border.zero),
                                                        title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                        status: .init(title: .init(font: Fonts.Body.two,
                                                                                   textColor: LightColors.Contrast.two,
                                                                                   textAlignment: .center),
                                                                      background: .init(backgroundColor: LightColors.error,
                                                                                        tintColor: LightColors.Contrast.two,
                                                                                        border: Presets.Border.small)),
                                                        infoButton: .init(backgroundConfiguration: Presets.Background.Secondary.normal,
                                                                          selectedConfiguration: Presets.Background.Secondary.selected,
                                                                          disabledConfiguration: Presets.Background.Secondary.disabled),
                                                        description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                        benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
        
        static var pending = VerificationConfiguration(shadow: Presets.Shadow.light,
                                                       background: .init(backgroundColor: LightColors.Background.one,
                                                                         tintColor: LightColors.Outline.two,
                                                                         border: Presets.Border.small),
                                                       title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                       status: .init(title: .init(font: Fonts.Body.two,
                                                                                  textColor: LightColors.Contrast.one,
                                                                                  textAlignment: .center),
                                                                     background: .init(backgroundColor: LightColors.pending,
                                                                                       tintColor: LightColors.Contrast.one,
                                                                                       border: Presets.Border.small)),
                                                       infoButton: .init(backgroundConfiguration: Presets.Background.Secondary.normal,
                                                                         selectedConfiguration: Presets.Background.Secondary.selected,
                                                                         disabledConfiguration: Presets.Background.Secondary.disabled),
                                                       description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                       benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
        
        static var verified = VerificationConfiguration(shadow: Presets.Shadow.light,
                                                        background: .init(backgroundColor: LightColors.Background.one,
                                                                          tintColor: LightColors.Outline.two,
                                                                          border: Presets.Border.zero),
                                                        title: .init(font: Fonts.Title.five, textColor: LightColors.Text.one),
                                                        status: .init(title: .init(font: Fonts.Body.two,
                                                                                   textColor: LightColors.Contrast.two,
                                                                                   textAlignment: .center),
                                                                      background: .init(backgroundColor: LightColors.success,
                                                                                        tintColor: LightColors.Contrast.two,
                                                                                        border: Presets.Border.small)),
                                                        infoButton: .init(backgroundConfiguration: Presets.Background.Secondary.normal,
                                                                          selectedConfiguration: Presets.Background.Secondary.selected,
                                                                          disabledConfiguration: Presets.Background.Secondary.disabled),
                                                        description: .init(font: Fonts.Body.two, textColor: LightColors.Text.two),
                                                        benefits: .init(font: Fonts.Body.two, textColor: LightColors.Contrast.two, textAlignment: .center))
    }
}

extension Presets {
    struct VerificationInfoView {
        static var none = InfoViewModel(kyc: .levelOne, headerTitle: .text(L10n.Account.accountLimits),
                                        headerTrailing: .init(image: "help"),
                                        status: VerificationStatus.none,
                                        description: .text(L10n.Account.fullAccess),
                                        button: .init(title: L10n.Account.accountVerify),
                                        dismissType: .persistent)
        
        static var nonePrompt = InfoViewModel(kyc: .levelOne, headerTitle: .text(L10n.Account.accountLimits),
                                              headerTrailing: .init(image: "CloseModern"),
                                              status: VerificationStatus.none,
                                              description: .text(L10n.Account.fullAccess),
                                              button: .init(title: L10n.Account.accountVerify),
                                              dismissType: .persistent)
        
        static var verified = InfoViewModel(kyc: .levelOne, headerTitle: .text(L10n.Account.accountLimits),
                                            headerTrailing: .init(image: "help"),
                                            status: VerificationStatus.levelOne,
                                            description: .text(L10n.Account.currentLimit),
                                            button: .init(title: L10n.Account.upgradeLimits),
                                            dismissType: .persistent)
        
        static var pending = InfoViewModel(kyc: .levelOne, headerTitle: .text(L10n.Account.accountLimits),
                                           headerTrailing: .init(image: "help"),
                                           status: VerificationStatus.emailPending,
                                           description: .text(L10n.Account.verifiedAccountMessage),
                                           dismissType: .persistent)
        
        static var verifiedLevelTwo = InfoViewModel(kyc: .levelTwo, headerTitle: .text(L10n.Account.accountLimits),
                                                    headerTrailing: .init(image: "help"),
                                                    status: VerificationStatus.levelTwo(.levelTwo),
                                                    description: .text(L10n.Account.swapAndBuyLimit),
                                                    dismissType: .persistent)
        
        static var resubmit = InfoViewModel(kyc: .levelTwo, headerTitle: .text(L10n.Account.accountLimits),
                                            headerTrailing: .init(image: "help"),
                                            status: VerificationStatus.levelTwo(.resubmit),
                                            description: .text(L10n.Account.dataIssues),
                                            button: .init(title: L10n.Account.verificationDeclined),
                                            dismissType: .persistent)
        
        static var declined = InfoViewModel(kyc: .levelTwo, headerTitle: .text(L10n.Account.accountLimits),
                                            headerTrailing: .init(image: "help"),
                                            status: VerificationStatus.levelTwo(.declined),
                                            description: .text(L10n.Account.dataIssues),
                                            button: .init(title: L10n.Account.verificationDeclined),
                                            dismissType: .persistent)
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
                                             copyableValue: .init(font: Fonts.Body.two, textColor: LightColors.Link.two, textAlignment: .center, numberOfLines: 0),
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
                                               imageConfig: .init(backgroundColor: LightColors.pending,
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
    
    struct StatusView {
        static var pending = AssetViewModel(icon: UIImage(named: "pendingIcon"), title: L10n.Staking.statusPending)
        static var complete = AssetViewModel(icon: UIImage(named: "completeIcon"), title: L10n.Transaction.complete)
        static var failed = AssetViewModel(icon: UIImage(named: "errorIcon")?.withRenderingMode(.alwaysOriginal), title: L10n.Transaction.failed)
        static var refunded = AssetViewModel(icon: UIImage(named: "refundedIcon")?.withRenderingMode(.alwaysOriginal), title: L10n.Transaction.refunded)
        static var manuallySettled = AssetViewModel(icon: UIImage(named: "completeIcon")?.withRenderingMode(.alwaysOriginal), title: L10n.Transaction.manuallySettled)
    }
}

extension Presets {
    struct TitleValue {
        static var horizontal = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, numberOfLines: 1),
                                                        value: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var vertical = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, numberOfLines: 1),
                                                      value: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var verticalSmall = TitleValueConfiguration(title: .init(font: Fonts.caption, textColor: LightColors.Text.one, numberOfLines: 1),
                                                           value: .init(font: Fonts.caption, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var subtitle = TitleValueConfiguration(title: .init(font: Fonts.Subtitle.one, textColor: LightColors.Text.one, numberOfLines: 1),
                                                      value: .init(font: Fonts.Subtitle.one, textColor: LightColors.Text.one, textAlignment: .right))
    }
}

extension Presets {
    struct Timer {
        static var one = TimerConfiguration(background: .init(tintColor: LightColors.primary), font: Fonts.Body.two)
    }
}
