import Foundation

struct ServiceAPI {
    static let Base_URL = "http://localhost/smartdent1/"
    static let loginURL = "\(Base_URL)login.php"
    static let signupURL = "\(Base_URL)signup.php"
    static let admin_loginURL = "\(Base_URL)admin_login.php"
    static let productDetails = "\(Base_URL)productfetch.php"
    static let fetchAllProducts = "\(Base_URL)productsfetch.php"
    static let addToCart = "\(Base_URL)addtocart.php"
    static let cart = "\(Base_URL)cart_fetch.php"
    static let orders = "\(Base_URL)orders.php"
    static let chatBotURL = "\(Base_URL)chatbot.php"
    static let addProduct = "\(Base_URL)add_products.php"
    static let deleteFromCart = "\(Base_URL)deletecart.php"
    static let checkout = "\(Base_URL)checkout.php"
    static let fetchOrders = "\(Base_URL)fetchOrders.php"
    static let acceptOrder = "\(Base_URL)acceptOrder.php"
    static let ordersHistory = "\(Base_URL)orderhistory.php"
    static let submitServiceRequest = "\(Base_URL)serviceRequestURL.php"
    static let stockUpdate = "\(Base_URL)stockUpdate.php"
    static let stockFetch = "\(Base_URL)stockFetch.php"
    static let uploadProfileImage = "\(Base_URL)upload_profile_image.php"
    static func fetchProfileImage(for userId: Int) -> String {
        return "\(Base_URL)fetch_profile_image.php?user_id=\(userId)"
    }
    static func productDetailURL(for productId: Int) -> String {
        return "\(productDetails)?product_id=\(productId)"
    }
    static func ordersHistory(for userId: Int) -> String {
        return "\(ordersHistory)?user_id=\(userId)"
    }
    static func serviceRequestsURL(for userId: Int?) -> String {
        if let userId = userId {
            return "\(Base_URL)servicesfetch.php?user_id=\(userId)"
        } else {
            return "\(Base_URL)servicesfetch.php"
        }
    }
}
