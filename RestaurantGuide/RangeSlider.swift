import SwiftUI

struct RangeSlider: View {
    @Binding var value: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    let step: Double
    var accentColor: Color = .orange
    
    init(value: Binding<ClosedRange<Double>>, in bounds: ClosedRange<Double>, step: Double = 1) {
        self._value = value
        self.bounds = bounds
        self.step = step
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                
                // Selected Range
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor)
                    .frame(width: CGFloat((value.upperBound - value.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width,
                           height: 4)
                    .offset(x: CGFloat((value.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width)
                
                // Lower Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(radius: 4)
                    .overlay(
                        Circle()
                            .stroke(accentColor, lineWidth: 2)
                    )
                    .offset(x: CGFloat((value.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * (geometry.size.width - 24))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let ratio = gesture.location.x / geometry.size.width
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(ratio)
                                let steppedValue = round(newValue / step) * step
                                if steppedValue >= bounds.lowerBound && steppedValue <= value.upperBound - step {
                                    value = steppedValue...value.upperBound
                                }
                            }
                    )
                
                // Upper Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(radius: 4)
                    .overlay(
                        Circle()
                            .stroke(accentColor, lineWidth: 2)
                    )
                    .offset(x: CGFloat((value.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * (geometry.size.width - 24))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let ratio = gesture.location.x / geometry.size.width
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(ratio)
                                let steppedValue = round(newValue / step) * step
                                if steppedValue <= bounds.upperBound && steppedValue >= value.lowerBound + step {
                                    value = value.lowerBound...steppedValue
                                }
                            }
                    )
            }
            .frame(height: 24)
        }
        .frame(height: 24)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var range: ClosedRange<Double> = 2...4
        
        var body: some View {
            RangeSlider(value: $range, in: 0...5, step: 0.5)
                .padding()
        }
    }
    
    return PreviewWrapper()
} 