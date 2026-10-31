import UIKit

/// Visual and behavioral configuration for a dropdown.
public struct DropdownConfiguration {
    public var rowHeight: CGFloat = 48
    public var maximumVisibleRows: Int = 5
    public var cornerRadius: CGFloat = 10
    public var borderWidth: CGFloat = 0.5
    public var borderColor: UIColor = .separator
    public var backgroundColor: UIColor = .systemBackground
    public var textColor: UIColor = .label
    public var selectedTextColor: UIColor = .systemBlue
    public var selectedBackgroundColor: UIColor = .secondarySystemBackground
    public var font: UIFont = .systemFont(ofSize: 16)
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.14
    public var shadowRadius: CGFloat = 10
    public var shadowOffset: CGSize = CGSize(width: 0, height: 4)
    public var verticalSpacing: CGFloat = 4
    public var preferredWidth: CGFloat? = nil

    public init() {}
}
