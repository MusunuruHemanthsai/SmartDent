<?php
header('Content-Type: application/json');

// Include DB config
require_once 'config.php'; // Make sure config.php defines $conn

// Check DB connection
if (!$conn) {
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed"
    ]);
    exit;
}

// Query to fetch product info
$sql = "SELECT product_name, price, product_image_url FROM products";
$result = $conn->query($sql);

if (!$result) {
    echo json_encode([
        "status" => "error",
        "message" => "Query failed: " . $conn->error
    ]);
    exit;
}

$products = [];

while ($row = $result->fetch_assoc()) {
    $products[] = [
        "product_name" => $row["product_name"],
        "price" => (float)$row["price"],
        "image_url" => $row["product_image_url"]
    ];
}

// Send JSON response
echo json_encode([
    "status" => "success",
    "data" => $products
]);

$conn->close();
?>
