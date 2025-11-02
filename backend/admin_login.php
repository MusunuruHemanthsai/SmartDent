<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include("config.php");

// Default admin setup
$defaultEmail = "admin@gmail.com";
$defaultPlainPassword = "admin";

$checkQuery = $conn->prepare("SELECT id FROM admin_login WHERE email = ?");
$checkQuery->bind_param("s", $defaultEmail);
$checkQuery->execute();
$checkQuery->store_result();

if ($checkQuery->num_rows === 0) {
    $hashedPassword = password_hash($defaultPlainPassword, PASSWORD_DEFAULT);
    $insertQuery = $conn->prepare("INSERT INTO admin_login (email, password) VALUES (?, ?)");
    $insertQuery->bind_param("ss", $defaultEmail, $hashedPassword);
    $insertQuery->execute();
}

// Validate request using POST form-data
if (!isset($_POST['email'], $_POST['password'])) {
    echo json_encode(["status" => "error", "message" => "Missing email or password."]);
    exit();
}

$email = $_POST['email'];
$password = $_POST['password'];

// Get user info
$loginQuery = $conn->prepare("SELECT id, email, password FROM admin_login WHERE email = ?");
$loginQuery->bind_param("s", $email);
$loginQuery->execute();
$loginQuery->store_result();

if ($loginQuery->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Email not registered."]);
    exit();
}

$loginQuery->bind_result($id, $dbEmail, $hashedPassword);
$loginQuery->fetch();

if (password_verify($password, $hashedPassword)) {
    echo json_encode([
        "status" => "success",
        "message" => "Admin login successful.",
        "user" => [
            "id" => $id,
            "email" => $dbEmail
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Incorrect password."]);
}

$conn->close();
?>
