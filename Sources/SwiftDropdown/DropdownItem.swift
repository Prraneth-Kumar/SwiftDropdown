import Foundation

/// A displayable dropdown option.
public struct DropdownItem: Hashable {
    public let title: String
    public let identifier: String

    public init(title: String, identifier: String? = nil) {
        self.title = title
        self.identifier = identifier ?? title
    }
}
