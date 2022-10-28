// 
// Created by Equaleyes Solutions Ltd
//

import UIKit

class AboutViewController: UIViewController {
    private lazy var aboutHeaderView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo_vertical")
        
        return logo
    }()
    
    private lazy var aboutFooterView: UILabel = {
        let aboutFooterView = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
        aboutFooterView.translatesAutoresizingMaskIntoConstraints = false
        aboutFooterView.textAlignment = .center
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            aboutFooterView.text = L10n.About.footer(version, build)
        }
        
        return aboutFooterView
    }()
    
    private lazy var privacy: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle: 1,
        NSAttributedString.Key.font: Fonts.Subtitle.two,
        NSAttributedString.Key.foregroundColor: LightColors.secondary]
        
        let attributedString = NSMutableAttributedString(string: L10n.About.privacy, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    private lazy var terms: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle: 1,
        NSAttributedString.Key.font: Fonts.Subtitle.two,
        NSAttributedString.Key.foregroundColor: LightColors.secondary]
        
        let attributedString = NSMutableAttributedString(string: L10n.About.terms, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L10n.About.title
        
        addSubviews()
        addConstraints()
        setActions()
        
        view.backgroundColor = .darkBackground
    }

    private func addSubviews() {
        view.addSubview(aboutHeaderView)
        view.addSubview(privacy)
        view.addSubview(terms)
        view.addSubview(aboutFooterView)
    }

    private func addConstraints() {
        aboutHeaderView.constrain([
            aboutHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewSizes.extraExtraHuge.rawValue),
            aboutHeaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutHeaderView.widthAnchor.constraint(equalToConstant: 213)])
        terms.constrain([
            terms.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.extraLarge.rawValue * 3),
            terms.topAnchor.constraint(equalTo: aboutHeaderView.bottomAnchor, constant: Margins.extraLarge.rawValue * 2)])
        privacy.constrain([
            privacy.topAnchor.constraint(equalTo: terms.topAnchor),
            privacy.leadingAnchor.constraint(equalTo: terms.trailingAnchor, constant: Margins.large.rawValue)])
        aboutFooterView.constrain([
            aboutFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.huge.rawValue),
            aboutFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.huge.rawValue),
            aboutFooterView.topAnchor.constraint(equalTo: privacy.bottomAnchor, constant: Margins.extraLarge.rawValue * 2)])
    }
    
    private func setActions() {
        privacy.tap = { [weak self] in
            self?.presentURL(string: C.privacyPolicy, title: self?.privacy.titleLabel?.text ?? "")
        }
        
        terms.tap = { [weak self] in
            self?.presentURL(string: C.termsAndConditions, title: self?.terms.titleLabel?.text ?? "")
        }
    }

    private func presentURL(string: String, title: String) {
        guard let url = URL(string: string) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: title))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController?.present(navController, animated: true)
    }
}
