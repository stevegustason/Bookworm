//
//  DetailView.swift
//  Bookworm
//
//  Created by Steven Gustason on 4/24/23.
//

import CoreData
import SwiftUI

struct DetailView: View {
    // Pass our book from the main view
    let book: Book
    
    // Environment property to hold or moc
    @Environment(\.managedObjectContext) var moc
    // Environment property to hold our dismiss action
    @Environment(\.dismiss) var dismiss
    // State property to track whether we're showing our delete alert
    @State private var showingDeleteAlert = false
    
    // Function to delete the book from the moc and then dismiss our view
    func deleteBook() {
        // Delete the book from the managed object context
        moc.delete(book)

        // Save the deletion
        try? moc.save()
        
        // Dismiss our view
        dismiss()
    }
    
    var body: some View {
        // ScrollView to make sure the user review will fit no matter the screen size, etc.
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                // Have our genre image (unwrapped) underneath
                Image(book.genre ?? "Mystery")
                    .resizable()
                    .scaledToFit()

                // The text displaying the genre (unwrapped) with some styling, in the bottom right of the image
                Text(book.genre?.uppercased() ?? "MYSTERY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            // Add our author (unwrapped)
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)

            // User review (unwrapped)
            Text(book.review ?? "No review")
                .padding()

            // And our rating view showing the book's rating, using a constant binding so the user can't adjust the rating from this view
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        // Delete book alert, which shows when our showingDeleteAlert variable is true
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            // Delete button with a role of destructive for automatic styling, which will call our deleteBook function
            Button("Delete", role: .destructive, action: deleteBook)
            // Cancel button with a role of cancel for automatic styling, which will dismiss the alert
            Button("Cancel", role: .cancel) { }
        } message: {
            // Message to make sure the user is absolutely sure before deleting the book
            Text("Are you sure?")
        }
        .toolbar {
            // Toolbar button, which flips our showingDeleteAlert variable to true to display our delete alert
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    // Temporary managed object context
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        // Mock up a book for preview use
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            DetailView(book: book)
        }
    }
}
