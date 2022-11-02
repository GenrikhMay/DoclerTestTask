/// Protocol used by presenters to support table view
protocol UITableViewSupportabble {

    /// New cell with index will be displayed
    /// - Parameter displayedMovieIndex: displayed movie index
    func willDisplayCell(at index: Int)

    /// Process tapping on cell
    /// - Parameter index: chosen movie index
    func tableViewCellWasTapped(at index: Int)
}
