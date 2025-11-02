<?php
header("Content-Type: application/json");

// Include the database connection file
require_once "config.php";

// Define the upload directory
$uploadDir = "uploads/";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check if file and product name were provided
    if (isset($_FILES['image']) && $_FILES['image']['error'] == 0 && isset($_POST['product_name']) && !empty($_POST['product_name'])) {
        $fileName = uniqid("img_", true) . "." . pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
        $filePath = $uploadDir . $fileName;

        // Full URL to be saved in the DB
        $baseURL = "http://" . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']) . "/";
        $imageURL = $baseURL . $filePath;

        $productName = $_POST['product_name'];

        // Ensure the uploads directory exists
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        // Move the uploaded file
        if (move_uploaded_file($_FILES['image']['tmp_name'], $filePath)) {
            // Save the full image URL in the database
            $stmt = $conn->prepare("INSERT INTO images (product_name, image_name, image_path) VALUES (?, ?, ?)");
            $stmt->bind_param("sss", $productName, $fileName, $imageURL);

            if ($stmt->execute()) {
                echo json_encode([
                    "success" => true,
                    "message" => "Image uploaded and saved",
                    "image_url" => $imageURL
                ]);
            } else {
                echo json_encode(["success" => false, "message" => "Failed to save image details"]);
            }

            $stmt->close();
        } else {
            echo json_encode(["success" => false, "message" => "Failed to upload image"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Missing product name or file"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

$conn->close();
?>
