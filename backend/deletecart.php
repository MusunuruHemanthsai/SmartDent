<?php
include 'config.php';
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
    exit();
}

if (!isset($_POST['user_id']) || !isset($_POST['product_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing user_id or product_id."]);
    exit();
}

$user_id = intval($_POST['user_id']);
$product_id = intval($_POST['product_id']);

$sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
    exit();
}

$stmt->bind_param("ii", $user_id, $product_id);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(["status" => "success", "message" => "Item deleted successfully."]);
} else {
    echo json_encode(["status" => "error", "message" => "Item not found or already deleted."]);
}

$stmt->close();
$conn->close();
?>
