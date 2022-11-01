struct ImageLinkBuilder {
    enum ImageSize {
        case preview
        case big
    }

    /// Get full link for image of exact size
    /// - Parameters:
    ///   - fileName: image name
    ///   - size: image size
    /// - Returns: Full image link
    func buildImageLink(fileName: String, size: ImageSize) -> String? {
        if let baseURL = MovieApiConfiguration.shared.properties[.imageBaseURL] {
            let sizeKey: ConfigKey
            switch size {
            case .preview:
                sizeKey = .previewPosterSize
            case .big:
                sizeKey = .fullPosterSize
            }
            if let imageSize = MovieApiConfiguration.shared.properties[sizeKey] {
                return "\(baseURL)\(imageSize)\(fileName)"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
