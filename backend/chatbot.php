<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 1. DB Config
require_once("config.php");

// 2. Get user message
$message = $_POST['message'] ?? '';
if (!$message) {
    echo json_encode(["reply" => "❗️Message cannot be empty."]);
    exit;
}

$lowerMessage = strtolower(trim($message));

// 3. Search product DB
$matchedProduct = null;
$result = $conn->query("SELECT * FROM products");
while ($row = $result->fetch_assoc()) {
    if (strpos($lowerMessage, strtolower($row['product_name'])) !== false) {
        $matchedProduct = $row;
        break;
    }
}
$conn->close();

// 4. Return DB product match
if ($matchedProduct) {
    $reply = "🦷 *{$matchedProduct['product_name']}*\n\n";
    $reply .= "{$matchedProduct['description']}\n\n";
    $reply .= "💰 Price: ₹" . number_format($matchedProduct['price'], 2);
    echo json_encode([
        "reply" => $reply,
        "image_url" => $matchedProduct['image_url'] ?? null
    ]);
    exit;
}

// 5. Fallback: SambaNova AI
$apiKey = "68fa4744-f583-4b33-8e2f-23a04777e989";
$apiUrl = "https://api.sambanova.ai/v1/chat/completions";

$payload = [
    "model" => "Meta-Llama-3.3-70B-Instruct",
    "messages" => [
        ["role" => "system", "content" => "You are Chinnu, a friendly AI assistant for SmartDent, a dental e-commerce app. Help with product questions and dental advice. Respond concisely and kindly. Include image URL in 'image_url' if needed."],
        ["role" => "user", "content" => $message]
    ]
];

$ch = curl_init($apiUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer $apiKey",
    "Content-Type: application/json"
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($httpCode === 200) {
    $data = json_decode($response, true);
    $reply = $data['choices'][0]['message']['content'] ?? "⚠️ Chinnu replied but no content.";
    $image = $data['choices'][0]['message']['image_url'] ?? null;

    echo json_encode([
        "reply" => $reply,
        "image_url" => $image
    ]);
} else {
    echo json_encode([
        "reply" => "❌ Chinnu request failed. Please try again later.",
        "status_code" => $httpCode
    ]);
}
