<?php
require 'config.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Read values from POST (form-data)
    $name = $_POST['name'] ?? '';
    $contact = $_POST['contact'] ?? '';
    $service_type = $_POST['service_type'] ?? '';
    $address = $_POST['address'] ?? '';
    $user_id = isset($_POST['user_id']) ? (int)$_POST['user_id'] : 0;

    // Validate input
    if (empty($name) || empty($contact) || empty($service_type) || empty($address)) {
        echo json_encode([
            "status" => "error",
            "message" => "All fields are required"
        ]);
        exit;
    }

    // Prepare the SQL statement
    $stmt = $conn->prepare("INSERT INTO service_requests (name, contact, service_type, address, user_id) VALUES (?, ?, ?, ?, ?)");

    if (!$stmt) {
        echo json_encode([
            "status" => "error",
            "message" => "Prepare failed: " . $conn->error
        ]);
        exit;
    }

    $stmt->bind_param("ssssi", $name, $contact, $service_type, $address, $user_id);

    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success",
            "message" => "Service request submitted successfully"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Execution failed: " . $stmt->error
        ]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}
?>
