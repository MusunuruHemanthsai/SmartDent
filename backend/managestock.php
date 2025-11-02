<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include 'config.php';

// Check DB connection
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $conn->connect_error
    ]);
    exit;
}

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Check if form-data fields are set
    if (!isset($_POST['id']) || !isset($_POST['stock'])) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Missing form fields: id or stock'
        ]);
        exit;
    }

    $id = intval($_POST['id']);
    $stock = intval($_POST['stock']);

    // Validate values
    if ($id <= 0 || $stock < 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Invalid values: ID must be > 0 and stock >= 0'
        ]);
        exit;
    }

    // Prepare update statement
    $stmt = $conn->prepare("UPDATE stock SET stock = ? WHERE id = ?");
    if (!$stmt) {
        echo json_encode([
            'status' => 'error',
            'message' => 'SQL prepare failed: ' . $conn->error
        ]);
        exit;
    }

    $stmt->bind_param("ii", $stock, $id);

    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Stock updated successfully.'
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Update failed: ' . $stmt->error
        ]);
    }

    $stmt->close();
    $conn->close();

} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request method. Use POST.'
    ]);
}
?>
