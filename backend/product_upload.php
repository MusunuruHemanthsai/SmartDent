<?php
include 'config.php'; // Include your database connection

// Set headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Only process POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Read and sanitize form inputs
    $product_name = trim($_POST['product_name'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $price = floatval($_POST['price'] ?? 0);

    // Validate required fields
    if (empty($product_name) || empty($description) || $price <= 0) {
        echo json_encode([
            "status" => "error",
            "message" => "Please fill in all fields correctly."
        ]);
        exit;
    }

    // Image upload handling
    $image_url = null;
    $upload_dir = "uploads/";

    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        $tmp_name = $_FILES['image']['tmp_name'];
        $original_name = basename($_FILES['image']['name']);
        $extension = pathinfo($original_name, PATHINFO_EXTENSION);
        $unique_name = time() . '_' . uniqid() . '.' . $extension;
        $target_path = $upload_dir . $unique_name;

        if (move_uploaded_file($tmp_name, $target_path)) {
            $image_url = "http://localhost/smartdent1/" . $target_path;
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Failed to upload image."
            ]);
            exit;
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Image file is required."
        ]);
        exit;
    }

    // Insert into products table
    $stmt = $conn->prepare("
        INSERT INTO products (product_name, product_image_url, description, price)
        VALUES (?, ?, ?, ?)
    ");

    if (!$stmt) {
        echo json_encode([
            "status" => "error",
            "message" => "Database prepare failed: " . $conn->error
        ]);
        exit;
    }

    $stmt->bind_param("sssd", $product_name, $image_url, $description, $price);

    if ($stmt->execute()) {
        echo json_encode([
            "status" => "success",
            "message" => "Product uploaded successfully."
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
        "message" => "Invalid request method."
    ]);
}
?>
