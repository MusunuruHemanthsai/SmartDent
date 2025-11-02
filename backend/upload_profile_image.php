<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
require 'config.php';

$user_id = $_POST['user_id'] ?? null;

if (!$user_id || !isset($_FILES['profile_image'])) {
 echo json_encode(["status" => "error", "message" => "Invalid input"]);
 exit;
}

$uploadDir = "uploads/profile_images/";
if (!file_exists($uploadDir)) {
 mkdir($uploadDir, 0777, true);
}

$fileTmpPath = $_FILES['profile_image']['tmp_name'];
$fileName = $user_id . "_" . time() . ".jpg";
$filePath = $uploadDir . $fileName;

if (move_uploaded_file($fileTmpPath, $filePath)) {
 $url = "http://localhost/smartdent1/" . $filePath;

 $sql = "UPDATE profile SET profile_image = '$url' WHERE user_id = '$user_id'";
 if (mysqli_query($conn, $sql)) {
 echo json_encode(["status" => "success", "image_url" => $url]); } else {
     echo json_encode(["status" => "error", "message" => "Database update failed"]);
     }
} else {
     echo json_encode(["status" => "error", "message" => "Upload failed"]);
}
?>
