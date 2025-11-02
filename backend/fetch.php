<?php
// Include your database connection file
include 'config.php';

// Set header for JSON output
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Optional category from query string
    $category = $_GET['category'] ?? null;

    // Sanitize category input
    if ($category) {
        $category = preg_replace('/[^a-zA-Z0-9_]/', '_', $category);
    }

    // Build query dynamically
    $query = "SELECT * FROM add_products";
    if ($category) {
        $query .= " WHERE product_category = ?";
    }
    $query .= " ORDER BY created_at DESC";

    // Prepare statement
    $stmt = $conn->prepare($query);

    if (!$stmt) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to prepare query'
        ]);
        exit;
    }

    // Bind category if applicable
    if ($category) {
        $stmt->bind_param("s", $category);
    }

    // Execute and fetch
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        $products = [];

        while ($row = $result->fetch_assoc()) {
            $products[] = $row;
        }

        // Check if empty or valid
        if (empty($products)) {
            echo json_encode([
                'status' => 'error',
                'message' => 'No products found for this category.'
            ]);
        } else {
            echo json_encode([
                'status' => 'success',
                'data' => $products
            ]);
        }

    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to execute query'
        ]);
    }

    $stmt->close();
}
?>
