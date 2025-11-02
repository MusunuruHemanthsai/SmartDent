<?php
include 'config.php';
header("Content-Type: application/json");

// Allow only GET method
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method. Use GET."
    ]);
    exit();
}

// Check for user_id
if (!isset($_GET['user_id']) || !is_numeric($_GET['user_id'])) {
    echo json_encode([
        "status" => "error",
        "message" => "Missing or invalid user_id parameter."
    ]);
    exit();
}

$user_id = intval($_GET['user_id']);

// Full base URL for image prefix (change if hosting elsewhere)
$baseUrl = "http://localhost/smartdent1/";

// Query the cart for the given user
$sql = "
    SELECT
        product_id,
        product_name,
        price,
        product_image_url,
        quantity
    FROM cart
    WHERE user_id = ?
";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "error",
        "message" => "Database prepare failed: " . $conn->error
    ]);
    exit();
}

$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$cartItems = [];

while ($row = $result->fetch_assoc()) {
    $cartItems[] = [
        "product_id"        => (int)$row['product_id'],
        "product_name"      => $row['product_name'],
        "price"             => (float)$row['price'],
        "product_image_url" => $baseUrl . $row['product_image_url'],
        "quantity"          => (int)$row['quantity']
    ];
}

echo json_encode([
    "status" => "success",
    "data"   => $cartItems
]);

$stmt->close();
$conn->close();
?>
