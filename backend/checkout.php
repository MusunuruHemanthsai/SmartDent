<?php
header("Content-Type: application/json");
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
    exit;
}

$user_id = $_POST['user_id'] ?? null;
$address = $_POST['address'] ?? '';
$payment_method = $_POST['payment_method'] ?? '';

if (!$user_id || empty($address) || empty($payment_method)) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit;
}

// Sanitize
$user_id = intval($user_id);
$address = $conn->real_escape_string(trim($address));
$payment_method = $conn->real_escape_string(trim($payment_method));

// Fetch cart items for the user
$cartQuery = $conn->prepare("SELECT product_id, product_name, quantity, price FROM cart WHERE user_id = ?");
$cartQuery->bind_param("i", $user_id);
$cartQuery->execute();
$cartResult = $cartQuery->get_result();

if ($cartResult->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Cart is empty"]);
    exit;
}

$ordersPlaced = 0;
while ($row = $cartResult->fetch_assoc()) {
    $product_id = intval($row['product_id']);
    $product_name = $conn->real_escape_string($row['product_name']);
    $quantity = intval($row['quantity']);
    $price = floatval($row['price']);
    $total_price = $price * $quantity;

    $insert = $conn->prepare("
        INSERT INTO orders (user_id, product_id, product_name, quantity, address, payment_method, order_date, total_price)
        VALUES (?, ?, ?, ?, ?, ?, NOW(), ?)
    ");
    $insert->bind_param("iissssd", $user_id, $product_id, $product_name, $quantity, $address, $payment_method, $total_price);

    if ($insert->execute()) {
        $ordersPlaced++;
    }

    $insert->close();
}

$cartQuery->close();

// Clear the cart if orders placed
if ($ordersPlaced > 0) {
    $clearCart = $conn->prepare("DELETE FROM cart WHERE user_id = ?");
    $clearCart->bind_param("i", $user_id);
    $clearCart->execute();
    $clearCart->close();

    echo json_encode(["status" => "success", "message" => "$ordersPlaced order(s) placed successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to place orders"]);
}

$conn->close();
?>
