import Foundation

// Define NameType as a simple struct
struct NameType {
    var firstName: String
    var lastName: String
    
    init(firstName: String, lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    var description: String {
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}

// Define enums for AudioProduct and VideoProduct
enum GenreType: String {
    case BLUES = "Blues"
    case CLASSICAL = "Classical"
    case COUNTRY = "Country"
    case FOLK = "Folk"
    case JAZZ = "Jazz"
    case METAL = "Metal"
    case POP = "Pop"
    case RNB = "RnB"
    case ROCK = "Rock"
}

enum FilmRateType: String {
    case NOT_RATED = "NotRated"
    case G = "G"
    case PG = "PG"
    case PG_13 = "PG_13"
    case R = "R"
    case NC_17 = "NC_17"
}

// Abstract Product class
class Product {
    static var nextID = 1 // Class variable for generating unique product IDs
    
    var productID: Int
    var productName: String
    var price: Double
    var reviewRate: Double
    
    init(prodName: String = "!No Name Product!", price: Double = 0.0) {
        self.productID = Product.createNewID()
        self.productName = prodName.isEmpty ? "!No Name Product!" : prodName
        self.price = max(0.0, min(price, 1000.0)) // Price between 0 and 1000
        self.reviewRate = 0.0
    }
    
    // Static method to generate new product ID
    static func createNewID() -> Int {
        let currentID = nextID
        nextID += 1
        return currentID
    }
    
    func getProdID() -> Int { return productID }
    func getProdName() -> String { return productName }
    func getPrice() -> Double { return price }
    func getReviewRate() -> Double { return reviewRate }
    
    func setProdID(_ theID: Int) { productID = theID }
    func setProdName(_ name: String) { productName = name.isEmpty ? "!No Name Product!" : name }
    func setPrice(_ price: Double) { self.price = max(0.0, min(price, 1000.0)) }
    func setReviewRate(_ rate: Double) { reviewRate = rate }
    
    // Abstract methods
    func getProdTypeStr() -> String { fatalError("Must be overridden") }
    func displayContentsInfo() {
        fatalError("Must be overridden")
    }
    
    func displayProdInfo() {
        print("[\(getProdTypeStr())]")
        print("Product ID: \(productID)   Product Name: \(productName)")
        print(String(format: "Price: $%.2f", price))
        print("Product Review Rate: \(reviewRate)")
        displayContentsInfo()
    }
}

// AudioProduct class
class AudioProduct: Product {
    var singer: NameType
    var genre: GenreType
    
    init(prodName: String, price: Double, singer: NameType) {
        self.singer = singer
        self.genre = .POP // Default genre
        super.init(prodName: prodName, price: price)
    }
    
    func getSinger() -> NameType { return singer }
    func getGenre() -> GenreType { return genre }
    
    func setSinger(_ singer: NameType) { self.singer = singer }
    func setGenre(_ genre: GenreType) { self.genre = genre }
    
    override func getProdTypeStr() -> String {
        return "Music"
    }
    
    override func displayContentsInfo() {
        print("Singer Name: \(singer.description)")
        print("Genre: \(genre.rawValue)")
    }
}

// VideoProduct class
class VideoProduct: Product {
    var director: NameType
    var filmRate: FilmRateType
    var releaseYear: Int
    var runTime: Int
    
    init(prodName: String, price: Double, directorName: NameType, releaseYear: Int, runTime: Int) {
        self.director = directorName
        self.filmRate = .NOT_RATED // Default rating
        self.releaseYear = releaseYear
        self.runTime = runTime
        super.init(prodName: prodName, price: price)
    }
    
    func getDirector() -> NameType { return director }
    func getFilmRate() -> FilmRateType { return filmRate }
    func getReleaseYear() -> Int { return releaseYear }
    func getRunTime() -> Int { return runTime }
    
    func setDirector(_ director: NameType) { self.director = director }
    func setFilmRate(_ rate: FilmRateType) { self.filmRate = rate }
    func setReleaseYear(_ year: Int) { self.releaseYear = year }
    func setRunTime(_ runTime: Int) { self.runTime = runTime }
    
    func isNewRelease(_ theYear: Int) -> Bool {
        return self.releaseYear >= theYear
    }
    
    override func getProdTypeStr() -> String {
        return "Movie"
    }
    
    override func displayContentsInfo() {
        print("Release Year: \(releaseYear)")
        print("Film Rating: \(filmRate.rawValue)")
        print("Runtime: \(runTime) mins")
        print("Director Name: \(director.description)")
    }
}

// BookProduct class
class BookProduct: Product {
    var author: NameType
    var pages: Int
    
    init(prodName: String, price: Double, author: NameType, pageNum: Int) {
        self.author = author
        self.pages = pageNum
        super.init(prodName: prodName, price: price)
    }
    
    func getAuthor() -> NameType { return author }
    func getPages() -> Int { return pages }
    
    func setAuthor(_ author: NameType) { self.author = author }
    func setPages(_ pages: Int) { self.pages = pages }
    
    override func displayContentsInfo() {
        print("Author: \(author.description)")
        print("Pages: \(pages)")
    }
}

// EBook class
class EBook: BookProduct {
    override func getProdTypeStr() -> String {
        return "E book"
    }
}

// PaperBook class
class PaperBook: BookProduct {
    override func getProdTypeStr() -> String {
        return "Paper book"
    }
}

// Cart class
class Cart {
    static let MAX_ITEMS = 7
    var owner: NameType
    var itemNum: Int
    var purchasedItems: [Product]
    
    init(owner: NameType) {
        self.owner = owner
        self.itemNum = 0
        self.purchasedItems = []
    }
    
    func isCartFull() -> Bool {
        return itemNum >= Cart.MAX_ITEMS
    }
    
    func addItem(_ product: Product) -> Bool {
        if isCartFull() {
            return false
        }
        purchasedItems.append(product)
        itemNum += 1
        return true
    }
    
    func removeItem(_ productID: Int) -> Bool {
        if itemNum == 0 {
            return false
        }
        if let index = purchasedItems.firstIndex(where: { $0.getProdID() == productID }) {
            purchasedItems.remove(at: index)
            itemNum -= 1
            return true
        }
        return false
    }
    
    func displayCart() {
        print("My Cart")
        print("======")
        print("Cart Owner: \(owner.description)")
        print()
        for item in purchasedItems {
            item.displayProdInfo()
            print()
        }
        print("===== Summary of Purchase ======")
        let totalItems = itemNum
        let totalAmount = purchasedItems.reduce(0.0) { $0 + $1.getPrice() }
        let avgCost = totalItems > 0 ? totalAmount / Double(totalItems) : 0.0
        print("Total number of purchases: \(totalItems)")
        print(String(format: "Total purchasing amount: $%.2f", totalAmount))
        print(String(format: "Average cost: $%.2f", avgCost))
    }
}

// Main test driver
func main() {
    // Create product objects
    let aName = NameType(firstName: "Beetles")
    let music1 = AudioProduct(prodName: "Yesterday", price: 16.5, singer: aName)
    music1.setGenre(.POP)
    music1.setReviewRate(9.8)
    
    let music2 = AudioProduct(prodName: "We are the World", price: 13.75, singer: NameType(firstName: "Michael", lastName: "Jackson"))
    music2.setGenre(.COUNTRY)
    music2.setReviewRate(9.1)
    
    let music3 = AudioProduct(prodName: "Bohemian Rhapsody", price: 18.0, singer: NameType(firstName: "Queen"))
    music3.setGenre(.ROCK)
    music3.setReviewRate(9.9)
    
    let video1 = VideoProduct(prodName: "Sound of Music", price: 22.0, directorName: NameType(firstName: "Robert", lastName: "Wise"), releaseYear: 1965, runTime: 175)
    video1.setFilmRate(.G)
    video1.setReviewRate(9.2)
    
    let video2 = VideoProduct(prodName: "Star Wars", price: 22.0, directorName: NameType(firstName: "George", lastName: "Lucas"), releaseYear: 1977, runTime: 120)
    video2.setFilmRate(.PG)
    video2.setReviewRate(8.5)
    
    let ebook1 = EBook(prodName: "The Old Man and the Sea", price: 8.3, author: NameType(firstName: "Ernest", lastName: "Hemmingway"), pageNum: 127)
    ebook1.setReviewRate(9.5)
    
    let paperbook1 = PaperBook(prodName: "1984", price: 12.0, author: NameType(firstName: "George", lastName: "Orwell"), pageNum: 328)
    paperbook1.setReviewRate(9.7)
    
    let extraMusic = AudioProduct(prodName: "Imagine", price: 15.0, singer: NameType(firstName: "John", lastName: "Lennon"))
    extraMusic.setGenre(.FOLK)
    extraMusic.setReviewRate(9.3)
    
    // Create cart
    let cartOwner = NameType(firstName: "John", lastName: "Smith")
    let myCart = Cart(owner: cartOwner)
    
    // Add items to cart (up to 8 to test overflow)
    myCart.addItem(music1)
    myCart.addItem(music2)
    myCart.addItem(music3)
    myCart.addItem(video1)
    myCart.addItem(video2)
    myCart.addItem(ebook1)
    myCart.addItem(paperbook1)
    // Attempt to add 8th item (should fail)
    print(myCart.addItem(extraMusic)) // Should return false
    
    // Remove two items
    myCart.removeItem(paperbook1.getProdID())
    myCart.removeItem(music3.getProdID())
    
    // Display cart
    myCart.displayCart()
}

main()



//Note to Execute File
// execution Command  cd C:\Users\gupta\Downloads\TinyMart (Location of the file)
// swiftc TinyMart.swift -o TinyMart.exe (to create executable file)
//./TinyMart.exe (to run the executable file)