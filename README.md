# SwiftDropdown

A reusable single-selection dropdown component for UIKit, distributed as a Swift Package.

## Requirements

- iOS 15+
- Swift 5.9+
- Xcode 15+

## Add the package to an Xcode project

1. Open your app project in Xcode.
2. Select **File → Add Package Dependencies…**
3. Choose **Add Local…**
4. Select this `SwiftDropdown` folder.
5. Add the `SwiftDropdown` product to your app target.

You can also add the package from a Git URL after publishing this repository.

## Basic usage

```swift
import UIKit
import SwiftDropdown

final class ViewController: UIViewController {
    private let countryButton = UIButton(type: .system)
    private let dropdown = DropdownView()

    override func viewDidLoad() {
        super.viewDidLoad()

        countryButton.setTitle("Choose country", for: .normal)
        countryButton.frame = CGRect(x: 24, y: 140, width: 220, height: 48)
        view.addSubview(countryButton)

        dropdown.setItems([
            "India",
            "United States",
            "United Kingdom",
            "Canada",
            "Australia"
        ])

        dropdown.onSelect = { [weak self] item, index in
            self?.countryButton.setTitle(item.title, for: .normal)
            print("Selected \(item.title) at index \(index)")
        }

        countryButton.addTarget(
            self,
            action: #selector(showDropdown),
            for: .touchUpInside
        )
    }

    @objc private func showDropdown() {
        dropdown.show(from: countryButton, in: view)
    }
}
```

## Customization

```swift
var style = DropdownConfiguration()
style.rowHeight = 52
style.maximumVisibleRows = 6
style.cornerRadius = 12
style.backgroundColor = .secondarySystemBackground
style.textColor = .label
style.selectedTextColor = .systemBlue
style.preferredWidth = 260

dropdown.configuration = style
```

## Custom model values

```swift
dropdown.items = [
    DropdownItem(title: "Engineering", identifier: "eng"),
    DropdownItem(title: "Design", identifier: "design"),
    DropdownItem(title: "Product", identifier: "product")
]
```

## Notes

- The component uses `UITableView`, so rows are reused as the list scrolls.
- The dropdown is added to the container view supplied to `show(from:in:)`.
- Call `dismiss()` when you need to close it programmatically.
- The component currently supports single selection.
- For production use, consider adding a container-level outside-tap recognizer, keyboard navigation, VoiceOver focus management, and UI tests to match your app's requirements.
