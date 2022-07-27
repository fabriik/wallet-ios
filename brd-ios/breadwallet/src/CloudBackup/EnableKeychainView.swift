// 
//  EnableKeychainView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-08-03.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

struct EnableKeychainView: View {
    
    @SwiftUI.State private var isKeychainToggleOn: Bool = false
    
    var completion: () -> Void
    
    var body: some View {
        VStack {
            TitleText(L10n.CloudBackup.enableTitle)
                .padding(.bottom)
            VStack(alignment: .leading) {
                BodyText(L10n.CloudBackup.enableBody1, style: .primary)
                    .padding(.bottom, 8.0)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                ForEach(0..<steps.count, id: \.self) { i in
                    HStack(alignment: .top) {
                        BodyText("\(i + 1).", style: .primary)
                            .frame(width: 14.0)
                        BodyText(steps[i], style: .primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                    }
                }
                BodyText(L10n.CloudBackup.enableBody2, style: .primary)
                    .padding(.top, 8.0)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            Image("Keychain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 24.0)
            HStack {
                RadioButton(isOn: self.$isKeychainToggleOn)
                    .frame(width: 44.0, height: 44.0)
                BodyText(L10n.CloudBackup.understandText, style: .primary)
            }.padding()
            Button(action: self.completion, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4.0)
                        .fill(Color(self.isKeychainToggleOn ? Theme.accent : UIColor.secondaryButton))
                    Text(L10n.CloudBackup.enableButton)
                        .font(Font(Theme.body1))
                        .foregroundColor(Color(Theme.primaryText))
                }
            })
            .frame(height: 44.0)
            .disabled(!self.isKeychainToggleOn)
            .padding([.leading, .trailing, .bottom])
        }.padding()
    }
}

struct EnableKeychainView_Previews: PreviewProvider {
    static var previews: some View {
        EnableKeychainView(completion: {})
    }
}

private let steps = [
    L10n.CloudBackup.step1,
    L10n.CloudBackup.step2,
    L10n.CloudBackup.step3,
    L10n.CloudBackup.step4
]
