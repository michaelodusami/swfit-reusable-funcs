//
//  ContentView.swift
//  Ramdom
//
//  Created by Tishe on 2/16/25.
//

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

import SwiftUI

// MARK: - Advanced Carousel View

/// A carousel view that cycles through identifiable items using paging.
public struct CarouselView<Item: Identifiable, Content: View>: View {
    public var items: [Item]
    public var spacing: CGFloat
    public var showsIndicators: Bool
    public var content: (Item) -> Content

    public init(items: [Item],
                spacing: CGFloat = 16,
                showsIndicators: Bool = true,
                @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content
    }

    public var body: some View {
        TabView {
            ForEach(items) { item in
                content(item)
                    .padding(.horizontal, spacing)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: showsIndicators ? .always : .never))
    }
}

// MARK: - Draggable Bottom Sheet

/// A bottom sheet view that can be dragged interactively.
public struct DraggableBottomSheet<Content: View>: View {
    @Binding public var isOpen: Bool
    public var maxHeight: CGFloat
    public var minHeight: CGFloat
    public var content: Content

    @GestureState private var translation: CGFloat = 0

    public init(isOpen: Binding<Bool>,
                maxHeight: CGFloat,
                minHeight: CGFloat,
                @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.content = content()
    }

    private var currentOffset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var dragIndicator: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.secondary)
            .frame(width: 40, height: 6)
            .padding(5)
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                dragIndicator
                content
            }
            .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 5)
            .offset(y: max(currentOffset + translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    let snapDistance = maxHeight * 0.25
                    if value.translation.height < -snapDistance {
                        isOpen = true
                    } else if value.translation.height > snapDistance {
                        isOpen = false
                    }
                }
            )
        }
    }
}

// MARK: - Hexagon & Hexagon View

/// A shape that draws a hexagon.
public struct Hexagon: Shape {
    public func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        let xScale: CGFloat = 0.95
        let xOffset = (width * (1 - xScale)) / 2.0
        let adjustedWidth = width * xScale

        var path = Path()
        let points = [
            CGPoint(x: xOffset + adjustedWidth * 0.5, y: 0),
            CGPoint(x: xOffset + adjustedWidth, y: height * 0.25),
            CGPoint(x: xOffset + adjustedWidth, y: height * 0.75),
            CGPoint(x: xOffset + adjustedWidth * 0.5, y: height),
            CGPoint(x: xOffset, y: height * 0.75),
            CGPoint(x: xOffset, y: height * 0.25)
        ]
        path.move(to: points.first!)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

/// A view that renders a hexagon with fill and stroke, optionally overlaying custom content.
public struct HexagonView<Content: View>: View {
    public var fillColor: Color
    public var strokeColor: Color
    public var lineWidth: CGFloat
    public var content: Content?

    public init(fillColor: Color = .blue,
                strokeColor: Color = .black,
                lineWidth: CGFloat = 2,
                @ViewBuilder content: () -> Content? = { nil }) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.content = content()
    }

    public var body: some View {
        ZStack {
            Hexagon()
                .fill(fillColor)
            Hexagon()
                .stroke(strokeColor, lineWidth: lineWidth)
            if let content = content {
                content
            }
        }
    }
}

// MARK: - Line Chart View

/// A simple line chart view for an array of data points.
public struct LineChartView: View {
    public var dataPoints: [CGFloat]
    public var lineColor: Color
    public var lineWidth: CGFloat
    public var showPoints: Bool

    public init(dataPoints: [CGFloat],
                lineColor: Color = .blue,
                lineWidth: CGFloat = 2,
                showPoints: Bool = true) {
        self.dataPoints = dataPoints
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.showPoints = showPoints
    }

    public var body: some View {
        GeometryReader { geometry in
            let maxValue = dataPoints.max() ?? 1
            let minValue = dataPoints.min() ?? 0
            let range = maxValue - minValue
            let points: [CGPoint] = dataPoints.enumerated().map { index, value in
                let x = geometry.size.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
                let y: CGFloat = range > 0 ? geometry.size.height * (1 - (value - minValue) / range) : geometry.size.height / 2
                return CGPoint(x: x, y: y)
            }
            ZStack {
                // Draw the line
                Path { path in
                    guard points.count > 1 else { return }
                    path.move(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(lineColor, lineWidth: lineWidth)
                // Optionally draw data points
                if showPoints {
                    ForEach(0..<points.count, id: \.self) { index in
                        Circle()
                            .fill(lineColor)
                            .frame(width: lineWidth * 3, height: lineWidth * 3)
                            .position(points[index])
                    }
                }
            }
        }
    }
}

// MARK: - Lazy Grid View

/// A scrollable grid view using LazyVGrid.
public struct LazyGridView<Item: Identifiable, Content: View>: View {
    public var items: [Item]
    public var columns: [GridItem]
    public var spacing: CGFloat
    public var content: (Item) -> Content

    public init(items: [Item],
                columns: [GridItem]? = nil,
                spacing: CGFloat = 16,
                @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.spacing = spacing
        self.content = content
        if let cols = columns {
            self.columns = cols
        } else {
            // Default to a 2-column grid.
            self.columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 2)
        }
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(items) { item in
                    content(item)
                }
            }
            .padding(spacing)
        }
    }
}

// MARK: - Parallax Header View

/// A view that creates a parallax scrolling header effect.
public struct ParallaxHeaderView<Content: View>: View {
    public var content: Content
    public var height: CGFloat

    public init(height: CGFloat, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width, height: height)
                .clipped()
                .offset(y: -geometry.frame(in: .global).minY / 2)
                .frame(height: height)
        }
        .frame(height: height)
    }
}

// MARK: - Custom Segmented Control

/// A custom segmented control with animated selection.
public struct CustomSegmentedControl: View {
    public var items: [String]
    @Binding public var selectedIndex: Int
    public var backgroundColor: Color
    public var selectedColor: Color
    public var textColor: Color

    public init(items: [String],
                selectedIndex: Binding<Int>,
                backgroundColor: Color = Color.gray.opacity(0.2),
                selectedColor: Color = .blue,
                textColor: Color = .black) {
        self.items = items
        self._selectedIndex = selectedIndex
        self.backgroundColor = backgroundColor
        self.selectedColor = selectedColor
        self.textColor = textColor
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedIndex = index
                    }
                }) {
                    Text(items[index])
                        .foregroundColor(selectedIndex == index ? .white : textColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedIndex == index ? selectedColor : backgroundColor)
                }
            }
        }
        .cornerRadius(8)
        .padding()
    }
}

struct CarouselDemo: View {
    struct DemoItem: Identifiable {
        let id = UUID()
        let color: Color
    }
    
    let items = [
        DemoItem(color: .red),
        DemoItem(color: .green),
        DemoItem(color: .blue)
    ]
    
    var body: some View {
        CarouselView(items: items) { item in
            RoundedRectangle(cornerRadius: 12)
                .fill(item.color)
                .frame(height: 200)
        }
        .frame(height: 220)
    }
}

struct BottomSheetDemo: View {
    @State private var isOpen = false

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            VStack {
                Button("Toggle Bottom Sheet") {
                    isOpen.toggle()
                }
                Spacer()
            }
            DraggableBottomSheet(isOpen: $isOpen,
                                 maxHeight: 400,
                                 minHeight: 100) {
                VStack {
                    Text("Drag me up or down!")
                        .padding()
                    Divider()
                    Text("Additional content goes here.")
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct LineChartDemo: View {
    let data: [CGFloat] = [3, 5, 2, 8, 6, 7, 4]

    var body: some View {
        LineChartView(dataPoints: data)
            .frame(height: 200)
            .padding()
    }
}


// MARK: - Wave Animation View

/// A sine wave shape that animates by shifting its phase.
public struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat

    public var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let midHeight = rect.height / 2
        let width = rect.width
        path.move(to: CGPoint(x: 0, y: midHeight))
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let y = amplitude * sin(2 * .pi * frequency * relativeX + phase) + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

/// A view that continuously animates a wave.
public struct WaveView: View {
    public var amplitude: CGFloat
    public var frequency: CGFloat
    public var speed: Double
    public var waveColor: Color

    @State private var phase: CGFloat = 0

    public init(amplitude: CGFloat = 20,
                frequency: CGFloat = 1,
                speed: Double = 0.5,
                waveColor: Color = .blue) {
        self.amplitude = amplitude
        self.frequency = frequency
        self.speed = speed
        self.waveColor = waveColor
    }

    public var body: some View {
        WaveShape(phase: phase, amplitude: amplitude, frequency: frequency)
            .fill(waveColor)
            .onAppear {
                withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }
    }
}

// MARK: - 3D Carousel View

/// A horizontally scrollable carousel that applies 3D rotation and scaling based on position.
public struct Carousel3DView<Item: Identifiable, Content: View>: View {
    public var items: [Item]
    public var spacing: CGFloat
    public var content: (Item) -> Content

    public init(items: [Item],
                spacing: CGFloat = 16,
                @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        GeometryReader { outerGeometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(items) { item in
                        GeometryReader { innerGeometry in
                            let midX = innerGeometry.frame(in: .global).midX
                            let distance = abs(outerGeometry.size.width / 2 - midX)
                            let scale = max(0.8, 1 - (distance / outerGeometry.size.width))
                            let angle = Angle(degrees: Double((outerGeometry.size.width / 2 - midX) / 10))
                            content(item)
                                .scaleEffect(scale)
                                .rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
                        }
                        .frame(width: 200, height: 300)
                    }
                }
                .padding(.horizontal, (outerGeometry.size.width - 200) / 2)
            }
        }
        .frame(height: 320)
    }
}

// MARK: - Radial Menu View

/// A single radial menu item.
public struct RadialMenuItem: Identifiable {
    public let id = UUID()
    public let icon: Image
    public let action: () -> Void

    public init(icon: Image, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
}

/// A radial menu that expands its child buttons in a circle.
public struct RadialMenuView: View {
    public var mainIcon: Image
    public var menuItems: [RadialMenuItem]
    public var radius: CGFloat

    @State private var isExpanded = false

    public init(mainIcon: Image,
                menuItems: [RadialMenuItem],
                radius: CGFloat = 100) {
        self.mainIcon = mainIcon
        self.menuItems = menuItems
        self.radius = radius
    }

    public var body: some View {
        ZStack {
            ForEach(menuItems.indices, id: \.self) { index in
                let angle = Angle(degrees: Double(index) / Double(menuItems.count) * 360)
                let xOffset = isExpanded ? radius * CGFloat(cos(angle.radians)) : 0
                let yOffset = isExpanded ? radius * CGFloat(sin(angle.radians)) : 0
                Button(action: menuItems[index].action) {
                    menuItems[index].icon
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .offset(x: xOffset, y: yOffset)
                .opacity(isExpanded ? 1 : 0)
                .animation(.easeInOut.delay(Double(index) * 0.05), value: isExpanded)
            }
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                mainIcon
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .shadow(radius: 3)
            }
        }
    }
}

// MARK: - Expandable List View

/// A section that can be expanded or collapsed.
public struct ExpandableSection<Content: View>: View {
    public var header: String
    public var content: Content
    @State private var isExpanded: Bool = false

    public init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(header)
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
            }
            if isExpanded {
                content
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .slide))
            }
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.vertical, 4)
    }
}

/// A list view with expandable sections.
public struct ExpandableListView<Item: Identifiable, Content: View>: View {
    public var sections: [String: [Item]]
    public var rowContent: (Item) -> Content

    public init(sections: [String: [Item]],
                @ViewBuilder rowContent: @escaping (Item) -> Content) {
        self.sections = sections
        self.rowContent = rowContent
    }

    public var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(sections.keys.sorted()), id: \.self) { key in
                    if let items = sections[key] {
                        ExpandableSection(header: key) {
                            ForEach(items) { item in
                                rowContent(item)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Flow Layout View

/// A custom flow (wrap) layout that positions its child views.
public struct FlowLayout<Content: View>: View {
    public var spacing: CGFloat
    public var alignment: HorizontalAlignment
    public var content: () -> Content

    public init(spacing: CGFloat = 8,
                alignment: HorizontalAlignment = .leading,
                @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            content()
                .padding(.all, 0)
                .alignmentGuide(.leading, computeValue: { dimension in
                    if width + dimension.width > geometry.size.width {
                        width = 0
                        height -= dimension.height + spacing
                    }
                    let result = width
                    width += dimension.width + spacing
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = height
                    return result
                })
        }
    }
}

/// A view that lays out items in a flowing grid.
public struct FlowLayoutView<Item: Identifiable, Content: View>: View {
    public var items: [Item]
    public var spacing: CGFloat
    public var content: (Item) -> Content

    public init(items: [Item],
                spacing: CGFloat = 8,
                @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        FlowLayout(spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
        .padding()
    }
}



struct WaveDemo: View {
    var body: some View {
        WaveView(amplitude: 30, frequency: 2, speed: 1, waveColor: .purple)
            .frame(height: 150)
            .clipped()
    }
}

struct FlowLayoutDemo: View {
    struct Tag: Identifiable {
        let id = UUID()
        let name: String
    }
    
    let tags = [
        Tag(name: "SwiftUI"), Tag(name: "iOS"), Tag(name: "Xcode"),
        Tag(name: "Programming"), Tag(name: "Development"), Tag(name: "Mobile")
    ]
    
    var body: some View {
        FlowLayoutView(items: tags, spacing: 8) { tag in
            Text(tag.name)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(16)
        }
    }
}


struct ExpandableListDemo: View {
    struct DemoItem: Identifiable {
        let id = UUID()
        let name: String
    }
    
    let sections = [
        "Fruits": [DemoItem(name: "Apple"), DemoItem(name: "Banana")],
        "Vegetables": [DemoItem(name: "Carrot"), DemoItem(name: "Lettuce")]
    ]
    
    var body: some View {
        ExpandableListView(sections: sections) { item in
            Text(item.name)
                .padding()
                .background(Color(UIColor.systemGray5))
                .cornerRadius(8)
        }
    }
}


struct RadialMenuDemo: View {
    var body: some View {
        RadialMenuView(
            mainIcon: Image(systemName: "plus"),
            menuItems: [
                RadialMenuItem(icon: Image(systemName: "pencil"), action: { print("Edit") }),
                RadialMenuItem(icon: Image(systemName: "trash"), action: { print("Delete") }),
                RadialMenuItem(icon: Image(systemName: "square.and.arrow.up"), action: { print("Share") })
            ],
            radius: 80
        )
    }
}


struct Carousel3DDemo: View {
    struct DemoItem: Identifiable {
        let id = UUID()
        let color: Color
    }
    
    let items = [
        DemoItem(color: .red),
        DemoItem(color: .green),
        DemoItem(color: .blue),
        DemoItem(color: .orange)
    ]
    
    var body: some View {
        Carousel3DView(items: items) { item in
            RoundedRectangle(cornerRadius: 12)
                .fill(item.color)
        }
    }
}


/// NOTE: LINE HERE


struct ContentView: View {
    var body: some View {
        Carousel3DDemo()
    }
}

#Preview {
    ContentView()
}
