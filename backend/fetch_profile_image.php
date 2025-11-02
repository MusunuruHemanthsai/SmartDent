<?php
header("Content-Type: application/json");
require 'config.php';

$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
 echo json_encode(["status" => "error", "message" => "User ID required"]);
 exit;
}

$sql = "SELECT profile_image FROM profile WHERE user_id = '$user_id'";
$result = mysqli_query($conn, $sql);

if ($row = mysqli_fetch_assoc($result)) {
 echo json_encode([
 "status" => "success",
 "image_url" => $row['profile_image'] ?? ""
 ]);
} else {
     echo json_encode(["status" => "error", "message" => "Profile not found"]);
}
?>
