import UIKit
import SDWebImage

protocol MovieDetailsViewProtocol: AnyObject {
    /// Set cast info
    /// - Parameter cast: cast
    func updateCastInfo(cast: String)
}

class MovieDetailsViewController: UIViewController {
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var overviewTtileLabel: UILabel!
    @IBOutlet private var overviewContentLabel: UILabel!
    @IBOutlet private var castTitleLabel: UILabel!
    @IBOutlet private var castContentLabel: UILabel!

    var presenter: MovieDetailsPresenterProtocol?

    private let overviewTitle = "Overview"
    private let castTitle = "Cast"
    private let voteTitle = "🏆"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        overrideUserInterfaceStyle = .dark

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.navigationBackground
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = presenter?.movie.title

        self.navigationController?.navigationBar.tintColor = UIColor.accentColor

        let voteAverageLabel = UILabel()
        if let voteAvg = presenter?.movie.voteAverage {
            voteAverageLabel.text = String(voteAvg) + " " + voteTitle
            voteAverageLabel.font = UIFont.systemFont(
                ofSize: UIFont.labelFontSize,
                weight: .regular
            )
            voteAverageLabel.textColor = UIColor.textSecondary
            let voteAverageBarItem = UIBarButtonItem(customView: voteAverageLabel)
            navigationItem.rightBarButtonItem = voteAverageBarItem
        }

        if let urlString = presenter?.movie.fullPosterPathURL {
            posterImage.sd_setImage(with: URL(string: urlString))
        }

        overviewTtileLabel.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
            weight: .bold
        )
        overviewTtileLabel.text = overviewTitle

        overviewContentLabel.textColor = UIColor.textSecondary
        overviewContentLabel.text = presenter?.movie.overview

        castTitleLabel.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
            weight: .bold
        )
        castTitleLabel.text = castTitle

        castContentLabel.textColor = UIColor.textSecondary
        castContentLabel.text = ""

        presenter?.setupView()
    }
}

extension MovieDetailsViewController: MovieDetailsViewProtocol {
    func updateCastInfo(cast: String) {
        castContentLabel.text = cast
    }
}
