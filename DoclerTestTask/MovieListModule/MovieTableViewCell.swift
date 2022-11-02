import SDWebImage
import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    @IBOutlet private var ratingProgress: UIProgressView!
    @IBOutlet private var ratingLabel: UILabel!

    private var placeholderImage = UIImage(systemName: "camera.metering.matrix")

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(
            ofSize: UIFont.labelFontSize,
            weight: .bold
        )
        genresLabel.textColor = AppColors.Text.tetriary
        ratingLabel.textColor = AppColors.Text.tetriary
        ratingProgress.tintColor = AppColors.accentColor
        posterImage.tintColor = AppColors.accentColor
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
        self.backgroundColor = AppColors.backgroundSecondary
        titleLabel.text = movie.title
        genresLabel.text = movie.genres
        ratingLabel.text = "\(movie.voteAverage)"
        ratingProgress.progress = Float(movie.voteAverage) / 10.0
        if let urlString = movie.previewPosterPath {
            posterImage.sd_setImage(
                with: URL(string: urlString),
                placeholderImage: placeholderImage
            )
        } else {
            posterImage.image = placeholderImage
        }
    }
}
