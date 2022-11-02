import UIKit
import SDWebImage

protocol MovieDetailsViewProtocol: AnyObject {
    /// Set cast info
    /// - Parameter cast: cast
    func updateCastInfo(cast: String)
}

class MovieDetailsViewController: UIViewController {
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var overviewTitleLabel: UILabel!
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
        appearance.backgroundColor = AppColors.navigationBackground
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.Text.primary
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = presenter?.movie.title

        self.navigationController?.navigationBar.tintColor = AppColors.accentColor

        let voteAverageLabel = UILabel()
        if let voteAvg = presenter?.movie.voteAverage {
            voteAverageLabel.text = String(voteAvg) + " " + voteTitle
            voteAverageLabel.font = UIFont.systemFont(
                ofSize: UIFont.labelFontSize,
                weight: .regular
            )
            voteAverageLabel.textColor = AppColors.Text.secondary
            let voteAverageBarItem = UIBarButtonItem(customView: voteAverageLabel)
            navigationItem.rightBarButtonItem = voteAverageBarItem
        }

        if let urlString = presenter?.movie.fullPosterPath {
            posterImage.sd_setImage(with: URL(string: urlString))
        }

        overviewTitleLabel.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
            weight: .bold
        )
        overviewTitleLabel.text = overviewTitle

        overviewContentLabel.textColor = AppColors.Text.secondary
        overviewContentLabel.text = presenter?.movie.overview

        castTitleLabel.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
            weight: .bold
        )
        castTitleLabel.text = castTitle

        castContentLabel.textColor = AppColors.Text.secondary
        castContentLabel.text = ""

        presenter?.viewDidLoad()
    }
}

extension MovieDetailsViewController: MovieDetailsViewProtocol {
    func updateCastInfo(cast: String) {
        castContentLabel.text = cast
    }
}
