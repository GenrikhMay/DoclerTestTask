/// Protocol used by presenters to support search bar
protocol UISearchBarSupportabble {

    /// Querry string has changed
    /// - Parameter query: search query
    func searchQueryChanged(query: String)
}
