<?php
include 'config.php';
header('Content-Type: application/json');

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Connection failed']);
    exit;
}

$sql = "SELECT id, name, image, price, stock FROM stock";
$result = $conn->query($sql);

$products = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $products[] = [
            'id' => (int)$row['id'],
            'name' => $row['name'],
            'image' => $row['image'],
            'price' => (float)$row['price'],
            'stock' => (int)$row['stock']
        ];
    }

    echo json_encode(['status' => 'success', 'products' => $products]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No products found']);
}

$conn->close();
?>
