<?php
header("Content-Type: application/json");

// Enable debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Include DB connection
include 'config.php';

// Check DB connection
if (!$conn) {
    echo json_encode(["status" => "error", "message" => "Database connection failed."]);
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // ✅ Read form-data using $_POST
    $name = isset($_POST['name']) ? trim($_POST['name']) : null;
    $email = isset($_POST['email']) ? trim($_POST['email']) : null;
    $password = isset($_POST['password']) ? trim($_POST['password']) : null;
    $confirmPassword = isset($_POST['confirmPassword']) ? trim($_POST['confirmPassword']) : null;

    // 🔍 Validate inputs
    if (empty($name) || empty($email) || empty($password) || empty($confirmPassword)) {
        echo json_encode(["status" => "error", "message" => "All fields are required."]);
        exit;
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(["status" => "error", "message" => "Invalid email format."]);
        exit;
    }

    if ($password !== $confirmPassword) {
        echo json_encode(["status" => "error", "message" => "Passwords do not match."]);
        exit;
    }

    // Check if email already exists
    $stmt = $conn->prepare("SELECT user_id FROM signup WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Email already exists."]);
        $stmt->close();
        exit;
    }
    $stmt->close();

    // Hash password
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

    // Begin transaction
    $conn->begin_transaction();

    try {
        // Insert into signup table
        $stmtSignup = $conn->prepare("INSERT INTO signup (name, email, password) VALUES (?, ?, ?)");
        $stmtSignup->bind_param("sss", $name, $email, $hashedPassword);
        $stmtSignup->execute();
        $user_id = $stmtSignup->insert_id;
        $stmtSignup->close();

        // Insert into login table
        $stmtLogin = $conn->prepare("INSERT INTO login (user_id, name, email, password) VALUES (?, ?, ?, ?)");
        $stmtLogin->bind_param("isss", $user_id, $name, $email, $hashedPassword);
        $stmtLogin->execute();
        $stmtLogin->close();

        // Insert into profile table
        $stmtProfile = $conn->prepare("INSERT INTO profile (user_id, name, email) VALUES (?, ?, ?)");
        $stmtProfile->bind_param("iss", $user_id, $name, $email);
        $stmtProfile->execute();
        $stmtProfile->close();

        // Commit all inserts
        $conn->commit();

        echo json_encode(["status" => "success", "message" => "User registered successfully.", "user_id" => $user_id]);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => "Error: " . $e->getMessage()]);
    }

    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}
?>
