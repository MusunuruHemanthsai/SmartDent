<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
include("config.php");

// ✅ Check if user_id is provided
if (!isset($_GET['user_id'])) {
    echo json_encode(["error" => "Missing user_id"]);
    exit();
}

$user_id = intval($_GET['user_id']);

// ✅ Query the user from the signup table
$sql = "SELECT id, name, email FROM signup WHERE id = $user_id";
$result = $conn->query($sql);

// ✅ Check if user exists and return data
if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode($user);
} else {
    echo json_encode(["error" => "User not found"]);
}
?>
