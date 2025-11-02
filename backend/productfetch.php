<?php
header('Content-Type: application/json');
include 'config.php'; // database connection file

// Get product ID from query string
$product_id = isset($_GET['product_id']) ? intval($_GET['product_id']) : 0;

if ($product_id <= 0) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid product ID'
    ]);
    exit;
}

// Fetch product details
$product_query = "SELECT id, product_name, description, price FROM products WHERE id = ?";
$stmt = $conn->prepare($product_query);
$stmt->bind_param("i", $product_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Product not found'
    ]);
    exit;
}

$product = $result->fetch_assoc();

// Fetch product images
$image_query = "SELECT image_url FROM product_images WHERE product_id = ?";
$stmt = $conn->prepare($image_query);
$stmt->bind_param("i", $product_id);
$stmt->execute();
$image_result = $stmt->get_result();

$images = [];
while ($row = $image_result->fetch_assoc()) {
    $images[] = $row['image_url'];
}

// Add images to product data
$product['images'] = $images;

// Return as JSON
echo json_encode([
    'status' => 'success',
    'data' => $product
]);
