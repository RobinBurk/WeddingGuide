import SwiftUI

struct TimeLineItemView: View {
    @Binding var timeLineItem: TimeLineItem

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedTime(timeLineItem.startTime))
                    .font(.custom("Lustria-Regular", size: 16))
                
                if timeLineItem.startTime != timeLineItem.endTime {
                    Text(formattedTime(timeLineItem.endTime))
                        .font(.custom("Lustria-Regular", size: 16))
                }
            }

            Rectangle()
                .fill(Color(hex: 0xB8C7B9))
                .frame(width: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(timeLineItem.title)
                    .font(.custom("Lustria-Regular", size: 18))
                
                if !timeLineItem.extra.isEmpty {
                    Text(timeLineItem.extra)
                        .lineLimit(2)
                        .minimumScaleFactor(0.4)
                        .font(.custom("Lustria-Regular", size: 13))
                        .foregroundColor(Color.gray)
                        .fontWeight(.thin)
                }
            }
            Spacer()
        }
    }

    private func formattedTime(_ minutesSinceMidnight: Int) -> String {
        let hours = minutesSinceMidnight / 60
        let minutes = minutesSinceMidnight % 60

        return String(format: "%02d:%02d", hours, minutes)
    }
}

struct TimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = TimeLineItem(
            title: "Sample Event",
            extra: "In der Kirche",
            startTime: 120,
            endTime: 240
        )

        return TimeLineItemView(timeLineItem: .constant(sampleItem))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
