import SwiftUI

// MARK: - Custom Button

/// A customizable button with configurable colors, title, and corner radius.
public struct CustomButton: View {
    public var title: String
    public var backgroundColor: Color
    public var foregroundColor: Color
    public var cornerRadius: CGFloat
    public var action: () -> Void

    public init(title: String,
                backgroundColor: Color = .blue,
                foregroundColor: Color = .white,
                cornerRadius: CGFloat = 8,
                action: @escaping () -> Void) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}

// MARK: - Card View

/// A card-styled container that can optionally display a title and arbitrary content.
public struct CardView<Content: View>: View {
    public var title: String?
    public var content: Content
    public var padding: CGFloat

    public init(title: String? = nil,
                padding: CGFloat = 16,
                @ViewBuilder content: () -> Content) {
        self.title = title
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.headline)
            }
            content
        }
        .padding(padding)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

// MARK: - Badge View

/// A simple badge view displaying text within a capsule shape.
public struct BadgeView: View {
    public var text: String
    public var backgroundColor: Color
    public var foregroundColor: Color

    public init(text: String,
                backgroundColor: Color = .red,
                foregroundColor: Color = .white) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        Text(text)
            .font(.caption)
            .padding(8)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
    }
}

// MARK: - Loading Spinner

/// A circular progress view styled as a spinner.
public struct LoadingSpinner: View {
    public var color: Color

    public init(color: Color = .blue) {
        self.color = color
    }

    public var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
    }
}

// MARK: - Input Text Field

/// A reusable text field with a custom border.
public struct InputTextField: View {
    public var placeholder: String
    @Binding public var text: String
    public var borderColor: Color

    public init(placeholder: String,
                text: Binding<String>,
                borderColor: Color = .gray) {
        self.placeholder = placeholder
        self._text = text
        self.borderColor = borderColor
    }

    public var body: some View {
        TextField(placeholder, text: $text)
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding(.horizontal)
    }
}

// MARK: - Modal View

/// A simple modal container view that appears as an overlay.
public struct ModalView<Content: View>: View {
    public var isPresented: Binding<Bool>
    public var content: Content

    public init(isPresented: Binding<Bool>,
                @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented
        self.content = content()
    }

    public var body: some View {
        ZStack {
            if isPresented.wrappedValue {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
                VStack {
                    content
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 8)
            }
        }
        .animation(.easeInOut, value: isPresented.wrappedValue)
    }
}

// MARK: - Toggle Switch

/// A styled toggle with a title.
public struct ToggleSwitch: View {
    public var title: String
    @Binding public var isOn: Bool

    public init(title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
        }
        .padding()
    }
}

// MARK: - Alert View

/// A custom alert view with configurable title, message, and buttons.
public struct AlertView: View {
    public var title: String
    public var message: String
    public var primaryButtonTitle: String
    public var secondaryButtonTitle: String?
    public var primaryAction: () -> Void
    public var secondaryAction: (() -> Void)?

    public init(title: String,
                message: String,
                primaryButtonTitle: String,
                secondaryButtonTitle: String? = nil,
                primaryAction: @escaping () -> Void,
                secondaryAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text(title).font(.headline)
            Text(message).font(.subheadline)
            HStack {
                if let secondaryTitle = secondaryButtonTitle,
                   let secondaryAction = secondaryAction {
                    Button(secondaryTitle, action: secondaryAction)
                        .frame(maxWidth: .infinity)
                }
                Button(primaryButtonTitle, action: primaryAction)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}

// MARK: - List View

/// A generic list view that renders rows for identifiable items.
public struct ListView<Item: Identifiable, Content: View>: View {
    public var items: [Item]
    public var rowContent: (Item) -> Content

    public init(items: [Item],
                @ViewBuilder rowContent: @escaping (Item) -> Content) {
        self.items = items
        self.rowContent = rowContent
    }

    public var body: some View {
        List(items) { item in
            rowContent(item)
        }
    }
}

// MARK: - Navigation Bar View

/// A container view that embeds content within a NavigationView with a title.
public struct NavigationBarView<Content: View>: View {
    public var title: String
    public var content: Content

    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
        }
    }
}

// MARK: - Section Header View

/// A header view for sections, suitable for list or form headers.
public struct SectionHeaderView: View {
    public var title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.vertical, 4)
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
    }
}

// MARK: - Divider View

/// A stylized divider with configurable color and thickness.
public struct DividerView: View {
    public var color: Color
    public var thickness: CGFloat

    public init(color: Color = .gray, thickness: CGFloat = 1) {
        self.color = color
        self.thickness = thickness
    }

    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

// MARK: - Rating View

/// A star-based rating view.
public struct RatingView: View {
    public var rating: Int
    public var maximumRating: Int
    public var onImage: Image
    public var offImage: Image
    public var onColor: Color
    public var offColor: Color

    public init(rating: Int,
                maximumRating: Int = 5,
                onImage: Image = Image(systemName: "star.fill"),
                offImage: Image = Image(systemName: "star"),
                onColor: Color = .yellow,
                offColor: Color = .gray) {
        self.rating = rating
        self.maximumRating = maximumRating
        self.onImage = onImage
        self.offImage = offImage
        self.onColor = onColor
        self.offColor = offColor
    }

    public var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { number in
                if number <= rating {
                    onImage.foregroundColor(onColor)
                } else {
                    offImage.foregroundColor(offColor)
                }
            }
        }
    }
}

// MARK: - Progress Bar View

/// A linear progress bar view.
public struct ProgressBarView: View {
    /// Expected range: 0.0 to 1.0.
    public var progress: CGFloat
    public var barColor: Color
    public var backgroundColor: Color

    public init(progress: CGFloat,
                barColor: Color = .blue,
                backgroundColor: Color = Color.gray.opacity(0.3)) {
        self.progress = progress
        self.barColor = barColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(height: 10)
                Rectangle()
                    .fill(barColor)
                    .frame(width: geometry.size.width * progress, height: 10)
            }
            .cornerRadius(5)
        }
        .frame(height: 10)
    }
}

// MARK: - Circular Progress Bar

/// A circular progress bar view.
public struct CircularProgressBar: View {
    /// Expected range: 0.0 to 1.0.
    public var progress: CGFloat
    public var lineWidth: CGFloat
    public var progressColor: Color
    public var backgroundColor: Color

    public init(progress: CGFloat,
                lineWidth: CGFloat = 10,
                progressColor: Color = .blue,
                backgroundColor: Color = Color.gray.opacity(0.3)) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
    }
}
