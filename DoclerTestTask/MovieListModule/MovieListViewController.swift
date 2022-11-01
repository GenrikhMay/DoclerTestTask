import UIKit

protocol MovieListViewProtocol: AnyObject {
    /// Update movie list table
    func updateMovieList()
}

final class MovieListViewController: UIViewController {
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var safeAreaBackground: UIView!

    var presenter: MovieListPresenterProtocol?

    private let navigationBarTitleString = "🍿 Movies"
    private let cornerRadius: CGFloat = 10.0
    private let cellHeight: CGFloat = 100.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        overrideUserInterfaceStyle = .dark

        safeAreaBackground.backgroundColor = UIColor.navigationBackground

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.navigationBackground
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.backButtonTitle = navigationBarTitleString
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: navigationBarTitleString,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backButtonDisplayMode = .generic
        self.title = navigationBarTitleString

        searchBar.delegate = self
        let liveTextImage = UIImage(systemName: "mic.fill")
        searchBar.setImage(liveTextImage, for: .bookmark, state: [])
        searchBar.showsBookmarkButton = true

        let movieCell = UINib(
            nibName: "MovieTableViewCell",
            bundle: nil
        )
        self.tableView.register(
            movieCell,
            forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = cornerRadius

        presenter?.setupView()
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.movieList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movie = presenter?.movieList[indexPath.row],
           let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseIdentifier
           ) as? MovieTableViewCell {
            cell.configure(movie: movie)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        presenter?.loadMoviesIfNeeded(displayedMovieIndex: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.movieWasTapped(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchQueryChanged(query: searchText)
    }
}

extension MovieListViewController: MovieListViewProtocol {
    func updateMovieList() {
        tableView.reloadData()
    }
}
