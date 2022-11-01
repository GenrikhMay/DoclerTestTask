import SDWebImage
import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    @IBOutlet private var ratingProgress: UIProgressView!
    @IBOutlet private var ratingLabel: UILabel!

    static let reuseIdentifier: String = "MovieTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(
            ofSize: UIFont.labelFontSize,
            weight: .bold
        )
        genresLabel.textColor = UIColor.textTetriary
        ratingLabel.textColor = UIColor.textTetriary
        ratingProgress.tintColor = UIColor.accentColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImage.sd_cancelCurrentImageLoad()
    }

    func configure(movie: MovieViewModel) {
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = UIColor.backgroundSecondary
        titleLabel.text = movie.title
        genresLabel.text = movie.genres
        ratingLabel.text = "\(movie.voteAverage)"
        ratingProgress.progress = Float(movie.voteAverage) / 10.0
        if let urlString = movie.previewPosterPath {
            posterImage.sd_setImage(with: URL(string: urlString))
        }
    }
}
