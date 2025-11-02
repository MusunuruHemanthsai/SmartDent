<?php
// Enable error reporting (for debugging only, disable in production)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');
include 'config.php';

// Check for GET request and user_id
$userId = $_GET['user_id'] ?? null;

if (!$userId || !is_numeric($userId)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Valid user_id is required'
    ]);
    exit;
}

// Fetch all orders for the user (no total_price)
$query = "SELECT id, address, order_date, status FROM orders WHERE user_id = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Query preparation failed: ' . $conn->error
    ]);
    exit;
}

$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();

$orders = [];
while ($row = $result->fetch_assoc()) {
    $orders[] = $row;
}

// Return orders
echo json_encode([
    'status' => 'success',
    'orders' => $orders
]);

$stmt->close();
$conn->close();
?>
