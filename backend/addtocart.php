<?php
include 'config.php';
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Only POST requests allowed."]);
    exit();
}

$user_id    = $_POST['user_id'] ?? null;
$product_id = $_POST['product_id'] ?? null;
$quantity   = $_POST['quantity'] ?? null;

if (!$user_id || !$product_id || !$quantity) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit();
}

$user_id    = intval($user_id);
$product_id = intval($product_id);
$quantity   = intval($quantity);

// Fetch product details from stock
$stmt = $conn->prepare("SELECT name, price, image, stock FROM stock WHERE product_id = ?");
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Product not found"]);
    exit();
}

$product = $result->fetch_assoc();
$product_name  = $product['name'];
$product_price = floatval($product['price']);
$product_image = $product['image'];
$product_stock = intval($product['stock']);

if ($quantity > $product_stock) {
    echo json_encode(["status" => "error", "message" => "Not enough stock"]);
    exit();
}

// Insert or update cart with full product details
$insert = $conn->prepare("
    INSERT INTO cart (user_id, product_id, product_name, price, product_image_url, quantity)
    VALUES (?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)
");

$insert->bind_param("iisdsi", $user_id, $product_id, $product_name, $product_price, $product_image, $quantity);

if ($insert->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Item added to cart",
        "data" => [
            "product_id" => $product_id,
            "product_name" => $product_name,
            "price" => $product_price,
            "image" => $product_image,
            "quantity_added" => $quantity
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
}

$conn->close();
?>
