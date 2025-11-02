<?php
header('Content-Type: application/json');
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

$productName = $_POST['name'] ?? '';
$description = $_POST['description'] ?? '';
$price = $_POST['price'] ?? '';

if (empty($productName) || empty($description) || empty($price)) {
    echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
    exit;
}

if (!is_numeric($price)) {
    echo json_encode(['status' => 'error', 'message' => 'Price must be numeric']);
    exit;
}

if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    echo json_encode(['status' => 'error', 'message' => 'Image is required']);
    exit;
}

// Upload image
$uploadDir = 'uploads/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

$uniqueName = uniqid() . '_' . basename($_FILES['image']['name']);
$imagePath = $uploadDir . $uniqueName;

if (!move_uploaded_file($_FILES['image']['tmp_name'], $imagePath)) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to upload image']);
    exit;
}

$baseUrl = 'http://' . $_SERVER['SERVER_NAME'] . dirname($_SERVER['SCRIPT_NAME']) . '/';
$imageUrl = $baseUrl . $imagePath;

// Insert into database
$query = "INSERT INTO products (product_name, product_image_url, description, price, created_at)
          VALUES (?, ?, ?, ?, NOW())";

$stmt = $conn->prepare($query);
$stmt->bind_param("sssd", $productName, $imageUrl, $description, $price);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Product added successfully',
        'data' => [
            'id' => $stmt->insert_id,
            'name' => $productName,
            'description' => $description,
            'price' => $price,
            'image_url' => $imageUrl,
            'created_at' => date('Y-m-d H:i:s')
        ]
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Database insert failed']);
}

$stmt->close();
$conn->close();
?>
