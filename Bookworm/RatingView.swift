//
//  RatingView.swift
//  Bookworm
//
//  Created by Steven Gustason on 4/23/23.
//

import SwiftUI

struct RatingView: View {
    // Create a binding property that will be bound to the rating in our AddBookView
    @Binding var rating: Int

    // What label should be placed before the rating
    var label = ""

    // Our maximum allowed rating
    var maximumRating = 5

    // Dictate the image to use when the star is highlighted or not
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    // Dictate the color to use when the star is highlighted or not
    var offColor = Color.gray
    var onColor = Color.yellow
    
    // Function for choosing our images
    func image(for number: Int) -> Image {
        // If the number passed in is greater than the current rating
        if number > rating {
            // Return the off image if it was set, otherwise return the on image
            return offImage ?? onImage
        } else {
            // If the number passed in is equal to or less than the current rating, return the on image
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            // If the label has any text, use it
            if label.isEmpty == false {
                Text(label)
            }

            // For each from 1 to our maximumRating
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                // Call our image(for:) function
                image(for: number)
                // If the number is greater than the rating, use the offColor, otherwise use the onColor
                    .foregroundColor(number > rating ? offColor : onColor)
                // Use a top gesture to set our rating to the number tapped
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        // Add a constant binding here, which won't change in the UI but will work for preview purposes
        RatingView(rating: .constant(4))
    }
}
