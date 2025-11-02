<?php
header("Content-Type: application/json");
require 'config.php';

// Fetch all orders (grouped by order ID, supporting multiple products per order)
$query = "
    SELECT 
        id AS order_id,
        user_id,
        address,
        payment_method,
        order_date,
        product_name,
        quantity,
        total_price
    FROM orders
    ORDER BY order_id DESC
";

$result = $conn->query($query);

if (!$result) {
    echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
    exit;
}

$ordersMap = [];

// Organize orders with product details
while ($row = $result->fetch_assoc()) {
    $orderId = (int)$row['order_id'];

    if (!isset($ordersMap[$orderId])) {
        $ordersMap[$orderId] = [
            "id" => $orderId,
            "userId" => (int)$row["user_id"],
            "address" => $row["address"],
            "totalPrice" => 0,
            "orderDate" => $row["order_date"],
            "products" => []
        ];
    }

    $ordersMap[$orderId]["totalPrice"] += (float)$row["total_price"];

    $ordersMap[$orderId]["products"][] = [
        "productName" => $row["product_name"],
        "quantity" => (int)$row["quantity"]
    ];
}

$orders = array_values($ordersMap);

echo json_encode(["status" => "success", "orders" => $orders]);
$conn->close();
?>
