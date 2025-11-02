<?php
header("Content-Type: application/json");
require 'config.php';

// Validate user_id
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

if ($user_id <= 0) {
    echo json_encode([
        "status" => "error",
        "message" => "Missing or invalid user_id"
    ]);
    exit;
}

// Prepare SQL query
$query = $conn->prepare("
    SELECT id AS order_id, product_name, quantity, total_price 
    FROM orders 
    WHERE user_id = ? 
    ORDER BY order_date DESC
");

if (!$query) {
    echo json_encode([
        "status" => "error",
        "message" => "Database query error: " . $conn->error
    ]);
    exit;
}

$query->bind_param("i", $user_id);
$query->execute();
$result = $query->get_result();

// Format result
$orders = [];
while ($row = $result->fetch_assoc()) {
    $orders[] = [
        "order_id"     => (int)$row['order_id'],
        "product_name" => $row['product_name'],
        "quantity"     => (int)$row['quantity'],
        "total_price"  => (float)$row['total_price']
    ];
}

$query->close();
$conn->close();

// Return response
if (empty($orders)) {
    echo json_encode([
        "status" => "empty",
        "message" => "No orders found"
    ]);
} else {
    echo json_encode([
        "status" => "success",
        "orders" => $orders
    ]);
}
?>
