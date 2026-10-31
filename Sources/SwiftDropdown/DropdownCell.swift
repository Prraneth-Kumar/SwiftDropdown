import UIKit

final class DropdownCell: UITableViewCell {
    static let reuseIdentifier = "DropdownCell"

    func configure(
        with item: DropdownItem,
        configuration: DropdownConfiguration,
        isSelected: Bool
    ) {
        var content = defaultContentConfiguration()
        content.text = item.title
        content.textProperties.font = configuration.font
        content.textProperties.color = isSelected
            ? configuration.selectedTextColor
            : configuration.textColor
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0, leading: 16, bottom: 0, trailing: 16
        )
        contentConfiguration = content
        backgroundColor = isSelected
            ? configuration.selectedBackgroundColor
            : configuration.backgroundColor
        selectionStyle = .none
        accessibilityTraits = isSelected ? [.button, .selected] : [.button]
    }
}
