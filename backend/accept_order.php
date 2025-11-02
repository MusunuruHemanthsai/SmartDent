<?php
header("Content-Type: application/json");
require 'config.php';

// Validate POST input
if (!isset($_POST['order_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing order_id"]);
    exit;
}

$orderId = intval($_POST['order_id']);

// Update the order status to 'accepted'
$query = "UPDATE orders SET status = 'accepted' WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $orderId);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Order accepted"]);
} else {
    echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
}

$stmt->close();
$conn->close();
?>
