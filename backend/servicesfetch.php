<?php
require 'config.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET");

error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    // Optional: Filter by user ID if provided
    $userId = isset($_GET['user_id']) ? intval($_GET['user_id']) : null;

    if ($userId) {
        $stmt = $conn->prepare("SELECT id, name, contact, service_type, address, user_id FROM service_requests WHERE user_id = ?");
        $stmt->bind_param("i", $userId);
    } else {
        $stmt = $conn->prepare("SELECT id, name, contact, service_type, address, user_id FROM service_requests");
    }

    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
        exit;
    }

    $stmt->execute();
    $result = $stmt->get_result();

    $requests = [];
    while ($row = $result->fetch_assoc()) {
        $requests[] = $row;
    }

    echo json_encode(["status" => "success", "data" => $requests]);

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
