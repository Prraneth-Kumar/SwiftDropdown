import UIKit

/// A lightweight, reusable single-selection dropdown built with UITableView.
public final class DropdownView: UIView {

    // MARK: Public API

    public var items: [DropdownItem] = [] {
        didSet { tableView.reloadData() }
    }

    public var configuration = DropdownConfiguration() {
        didSet { applyConfiguration() }
    }

    /// Called with the selected item and its index.
    public var onSelect: ((DropdownItem, Int) -> Void)?

    public private(set) var selectedIndex: Int?

    /// Convenience API for string-based dropdowns.
    public func setItems(_ titles: [String]) {
        items = titles.map { DropdownItem(title: $0) }
    }

    /// Presents the dropdown relative to an anchor view, inside the supplied container.
    public func show(from anchorView: UIView, in containerView: UIView) {
        dismiss()

        guard !items.isEmpty, let window = containerView.window ?? anchorView.window else {
            return
        }

        let anchorFrame = anchorView.convert(anchorView.bounds, to: containerView)
        let safeBounds = containerView.bounds.inset(
            by: containerView.safeAreaInsets
        )

        let width = configuration.preferredWidth ?? anchorFrame.width
        let rowCount = min(items.count, max(1, configuration.maximumVisibleRows))
        let height = CGFloat(rowCount) * configuration.rowHeight

        let spaceBelow = safeBounds.maxY - anchorFrame.maxY
        let spaceAbove = anchorFrame.minY - safeBounds.minY
        let shouldShowAbove = spaceBelow < height + configuration.verticalSpacing
            && spaceAbove > spaceBelow

        let x = min(
            max(anchorFrame.minX, safeBounds.minX),
            max(safeBounds.minX, safeBounds.maxX - width)
        )

        let y: CGFloat
        if shouldShowAbove {
            y = max(safeBounds.minY, anchorFrame.minY - height - configuration.verticalSpacing)
        } else {
            y = min(safeBounds.maxY - height, anchorFrame.maxY + configuration.verticalSpacing)
        }

        frame = CGRect(x: x, y: y, width: width, height: height)
        containerView.addSubview(self)
        containerView.bringSubviewToFront(self)
        isHidden = false
        accessibilityViewIsModal = true
        accessibilityLabel = "Options"
        accessibilityViewIsModal = true

        // Keep the dropdown attached to the same coordinate space as the anchor.
        if window !== containerView.window {
            removeFromSuperview()
        }
    }

    public func dismiss() {
        removeFromSuperview()
    }

    // MARK: Private

    private let tableView = UITableView(frame: .zero, style: .plain)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.masksToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.register(
            DropdownCell.self,
            forCellReuseIdentifier: DropdownCell.reuseIdentifier
        )
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        applyConfiguration()
        isHidden = true
    }

    private func applyConfiguration() {
        backgroundColor = configuration.backgroundColor
        layer.cornerRadius = configuration.cornerRadius
        layer.borderWidth = configuration.borderWidth
        layer.borderColor = configuration.borderColor.cgColor
        layer.shadowColor = configuration.shadowColor.cgColor
        layer.shadowOpacity = configuration.shadowOpacity
        layer.shadowRadius = configuration.shadowRadius
        layer.shadowOffset = configuration.shadowOffset
        layer.masksToBounds = false

        tableView.backgroundColor = configuration.backgroundColor
        tableView.rowHeight = configuration.rowHeight
        tableView.separatorColor = configuration.borderColor.withAlphaComponent(0.5)
        tableView.reloadData()
    }
}

extension DropdownView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: DropdownCell.reuseIdentifier,
            for: indexPath
        ) as! DropdownCell

        cell.configure(
            with: items[indexPath.row],
            configuration: configuration,
            isSelected: selectedIndex == indexPath.row
        )
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let item = items[indexPath.row]
        tableView.reloadData()
        onSelect?(item, indexPath.row)
        dismiss()
    }
}
