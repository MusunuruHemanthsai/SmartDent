<?php
header("Content-Type: application/json");
include 'config.php';

if (!$conn) {
    echo json_encode(["status" => "error", "message" => "Database connection failed."]);
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "GET" && isset($_GET['user_id'])) {
    $user_id = intval($_GET['user_id']);

    $stmt = $conn->prepare("SELECT user_id, name, email FROM profile WHERE user_id = ?");
    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result && $row = $result->fetch_assoc()) {
        echo json_encode([
            "status" => "success",
            "profile" => [
                "user_id" => $row['user_id'],
                "name" => $row['name'],
                "email" => $row['email']
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Profile not found."]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request."]);
}
?>
