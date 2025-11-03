-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 14, 2025 at 08:21 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Smartdent1`
--

-- --------------------------------------------------------

--
-- Table structure for table `add_products`
--

CREATE TABLE `add_products` (
  `id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_category` varchar(255) NOT NULL,
  `product_image_url` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `add_products`
--

INSERT INTO `add_products` (`id`, `product_name`, `product_category`, `product_image_url`, `created_at`) VALUES
(1, 'DENTAL MIRROR', 'DIAGNOSTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6858fa575459c_dental mirror.png', '2025-06-23 12:25:19'),
(2, 'DENTAL EXPLORER', 'DIAGNOSTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6858fbc9d7094_dental explorer.png', '2025-06-23 12:31:29'),
(3, 'INTRAORAL CAMERA', 'DIAGNOSTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6858fc286e2f5_intronal camera.png', '2025-06-23 12:33:04'),
(4, 'X-RAY', 'DIAGNOSTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6858fc4e42157_x-ray.png', '2025-06-23 12:33:42'),
(5, 'CURING LIGHTS', 'TREATMENT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6859053c125a8_curing light.png', '2025-06-23 13:11:48'),
(6, 'LASER EQUIPMENT', 'TREATMENT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/68590587a0001_laser.png', '2025-06-23 13:13:03'),
(7, 'ULTRASONIC SCALER', 'TREATMENT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685905c6a10a2_ultrasonic.png', '2025-06-23 13:14:06'),
(8, 'AIR-DRIVEN HANDPIECES', 'TREATMENT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6859063203318_air driver.png', '2025-06-23 13:15:54'),
(9, 'DENTAL HANDPIECES', 'TREATMENT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/6859065c0ae05_dental handpieces.png', '2025-06-23 13:16:36'),
(10, 'DENTAL IMPRESSION', 'RESTORATIVE_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a16b175550_dentalimpression1.png', '2025-06-24 08:38:33'),
(11, 'MIXER AND DISPENSER', 'RESTORATIVE_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a16db4b90a_mixer and dispenser.png', '2025-06-24 08:39:15'),
(12, 'VACUUM FORMER', 'RESTORATIVE_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1704a3d5a_vacuumformer.png', '2025-06-24 08:39:56'),
(13, 'UV STERILIZERS', 'STERILIZATION_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1a54b13f3_uvsterilizer.png', '2025-06-24 08:54:04'),
(14, 'STERILIZERS MONITORING', 'STERILIZATION_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1a8eee64d_sterilizers monitoring.png', '2025-06-24 08:55:02'),
(15, 'ULTRASONIC CLEANER', 'STERILIZATION_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1af8d4c79_ultrasonic cleaner.png', '2025-06-24 08:56:48'),
(16, 'AUTOCLAVES', 'STERILIZATION_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1b1caa6e8_autoclave.png', '2025-06-24 08:57:24'),
(17, 'SUCTION DEVICES', 'PATIENT_COMFORT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1c59e4cac_SUCTIONDEVICES.png', '2025-06-24 09:02:41'),
(18, 'OPERATING LIGHT', 'PATIENT_COMFORT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1c88af373_OPERATINGLIGHT.png', '2025-06-24 09:03:28'),
(19, 'DENTAL CHAIRS', 'PATIENT_COMFORT_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1cb6bf2ef_dentalchair.png', '2025-06-24 09:04:14'),
(20, 'BONE GRAFTING INSTRUMENT', 'SURGICAL_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1db537e32_bone grafing.png', '2025-06-24 09:08:29'),
(21, 'SUTURES', 'SURGICAL_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1de219543_sutures.png', '2025-06-24 09:09:14'),
(22, 'ELEVATORS', 'SURGICAL_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1dfa07aeb_elevatoes.png', '2025-06-24 09:09:38'),
(23, 'SCALPEL', 'SURGICAL_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1e16cd9da_scalpel.png', '2025-06-24 09:10:06'),
(24, 'FORCEPS', 'SURGICAL_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a1e32882bb_forceps.png', '2025-06-24 09:10:34'),
(25, 'LIGATURES', 'ORTHODONTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/img_685e09f3754b18.80604903.png', '2025-06-24 09:17:56'),
(26, 'ELASTICS AND SPRINGS', 'ORTHODONTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a20520b495_elastics.png', '2025-06-24 09:19:38'),
(27, 'ARCHWIRES', 'ORTHODONTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a2068c08f0_archwires.png', '2025-06-24 09:20:00'),
(28, 'ENDODONTIC MOTORS', 'ENDODONTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a20ba40a69_endodonitc motors.png', '2025-06-24 09:21:22'),
(29, 'ROOT CANAL FILLING MATERIAL', 'ENDODONTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a20e44edea_root.png', '2025-06-24 09:22:04'),
(30, 'ENDODONTIC FILES', 'ENDODONTIC_EQUIPMENTS', 'http://localhost/smartdent1/uploads/685a214e27fa9_enodonitc files.png', '2025-06-24 09:23:50'),
(43, 'Danger', 'Restorative_Equipments', 'http://localhost/smartdent1/uploads/686607d7b0acd_product.jpg', '2025-07-03 10:02:23');

-- --------------------------------------------------------

--
-- Table structure for table `admin_login`
--

CREATE TABLE `admin_login` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_login`
--

INSERT INTO `admin_login` (`id`, `email`, `password`) VALUES
(1, 'admin@gmail.com', '$2y$10$pyAZATv7Xdgiv2y3ffWE7.FgY3QSojyrfg1oM0DBIe7kmzU9zWkh2');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_image_url` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `product_id`, `product_name`, `product_image_url`, `quantity`, `price`) VALUES
(52, 1, 25, 'Bone Grafting Instrument', 'http://localhost/smartdent1/uploads/685a1db537e32_bone grafing.png', 1, 2500.00),
(53, 1, 9, 'Curing Lights', 'http://localhost/smartdent1/uploads/6859053c125a8_curing light.png', 3, 14999.00);

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `image_name` varchar(255) NOT NULL,
  `image_path` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `product_name`, `image_name`, `image_path`) VALUES
(15, 'dentalequipment', 'img_6858e20fa994b1.29348473.png', 'http://localhost/smartdent1/uploads/img_6858e20fa994b1.29348473.png'),
(16, 'dentalequipment1', 'img_6858e227bd0814.22531322.png', 'http://localhost/smartdent1/uploads/img_6858e227bd0814.22531322.png'),
(18, 'DIAGNOSTIC EQUIPMENTS', 'img_6858e280a402d1.13608616.png', 'http://localhost/smartdent1/uploads/img_6858e280a402d1.13608616.png'),
(21, 'TREATMENT EQUIPMENTS', 'img_6858e37561f5d7.47071400.png', 'http://localhost/smartdent1/uploads/img_6858e37561f5d7.47071400.png'),
(22, 'RESTORATIVE EQUIPMENTS', 'img_6858e398e57689.11540302.png', 'http://localhost/smartdent1/uploads/img_6858e398e57689.11540302.png'),
(23, 'STERILIZATION EQUIPMENTS', 'img_6858e3bb3f8628.07323842.png', 'http://localhost/smartdent1/uploads/img_6858e3bb3f8628.07323842.png'),
(24, 'PATIENT COMFORT EQUIPMENTS', 'img_6858e3f7151a40.96914992.png', 'http://localhost/smartdent1/uploads/img_6858e3f7151a40.96914992.png'),
(25, 'SURGICAL EQUIPMENTS', 'img_6858e4189609d8.82409855.png', 'http://localhost/smartdent1/uploads/img_6858e4189609d8.82409855.png'),
(26, 'ORTHODONTIC EQUIPMENTS', 'img_6858e4530ba0c1.78859275.png', 'http://localhost/smartdent1/uploads/img_6858e4530ba0c1.78859275.png'),
(27, 'ENDODONTIC EQUIPMENTS', 'img_6858e46c1a1215.84083412.png', 'http://localhost/smartdent1/uploads/img_6858e46c1a1215.84083412.png'),
(28, 'Ligatures', 'img_685e09f3754b18.80604903.png', 'http://localhost/smartdent1/uploads/img_685e09f3754b18.80604903.png');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `login_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`login_id`, `user_id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 1, 'hemanthsai', 'chinnu121@gmail.com', '$2y$10$7QM0WoUSTR85GKF/tmSCYOeQS4Yj.UjqV6ACsW/UF1dI6ycy7OZ4G', '2025-06-25 04:18:47'),
(2, 2, 'chinnu', 'hemanthsai0602@gmail.com', '$2y$10$tYwajDrNhEJ3PcSQqDdB2.h/ZswVb068q0WJPKrc9sauDBj8xfKre', '2025-06-25 05:23:13'),
(3, 3, 'chinnu', 'chinnu21@gmail.com', '$2y$10$fN4WoWTGchTbuu6xpY3yjOo2DSlF1KXUh7qA/YA2z3i2s25Aki8bm', '2025-06-27 04:19:05'),
(4, 4, 'hemanth', 'chiin212@gmail.com', '$2y$10$dZmUgzpEUt4.G73hB.DujODPwSPXxltyJiEjvecHfmtqRYBSyomOu', '2025-07-01 05:31:22');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `address` text NOT NULL,
  `payment_method` varchar(100) NOT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `product_id`, `product_name`, `quantity`, `address`, `payment_method`, `order_date`, `status`, `total_price`) VALUES
(1, 3, 9, 'Curing Lights', 2, 'Chinnu, 9100800764, Sainager,sullurpata, Nellore, Andhra Pradesh - 524121', 'Cash on Delivery', '2025-07-03 14:34:41', 'accepted', 29998.00),
(2, 3, 19, 'Operating Light', 1, 'Chinnu, 9100800764, Sainager,sullurpata, Nellore, Andhra Pradesh - 524121', 'Cash on Delivery', '2025-07-03 14:34:41', 'accepted', 70000.00);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_image_url` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `product_name`, `product_image_url`, `description`, `price`, `created_at`) VALUES
(1, 'Dental Mirror', 'http://localhost/smartdent1/uploads/6858fa575459c_dental mirror.png', 'Overview\nA dental mirror is an essential diagnostic tool used by dentists to view areas of the mouth that are difficult to see directly. It provides clear visibility of the teeth, gums, and other oral structures by reflecting light and offering a magnified view. This tool helps in detecting cavities, plaque buildup, and other oral health issues. Its ergonomic design allows for easy maneuvering and patient comfort during examinations. Dental mirrors are crucial for accurate diagnosis and effective dental treatment planning.', 299.00, '2025-06-25 06:40:57'),
(2, 'Dental Explorer', 'http://localhost/smartdent1/uploads/6858fbc9d7094_dental explorer.png', 'Overview\nA dental explorer is a sharp, pointed dental instrument used primarily for detecting irregularities in tooth surfaces, diagnosing cavities (caries), and assessing the health of the gums and other oral tissues. It is one of the most commonly used tools in dental practices, often paired with a dental mirror for effective diagnosis and examination.', 249.00, '2025-06-25 08:04:44'),
(3, 'Intraoral Camera', 'http://localhost/smartdent1/uploads/6858fc286e2f5_intronal camera.png', 'Overview\nAn intraoral camera is a small, handheld device used in dentistry to capture detailed images inside the mouth. It helps dentists detect issues like cavities, cracks, and gum disease with high accuracy. The real-time images are displayed on a screen, allowing patients to see their dental condition clearly. It enhances diagnosis, patient education, and treatment planning. Intraoral cameras are non-invasive and improve overall dental care quality.', 1599.00, '2025-06-26 05:08:42'),
(4, 'X-Ray Machine', 'http://localhost/smartdent1/uploads/6858fc4e42157_x-ray.png', 'Overview\nX-ray machines are essential tools in modern dentistry, enabling clinicians to obtain high-resolution images of the teeth and jaw structure. These diagnostic devices assist in detecting cavities, assessing bone density, and planning treatments with precision. Their integration into routine dental practice ensures thorough examinations and enhances patient trust by providing visual insights into their oral health.', 28999.00, '2025-06-26 05:16:23'),
(5, 'Dental Handpieces', 'http://localhost/smartdent1/uploads/6859065c0ae05_dental handpieces.png', 'Overview\nDental handpieces are essential instruments in dentistry, used for cutting, drilling, polishing, and cleaning during various procedures. They are available in high-speed and low-speed types, each serving specific clinical purposes—high-speed for cutting hard tissues and low-speed for finishing and polishing. Modern handpieces often feature ergonomic designs, built-in LED lighting for better visibility, and are autoclavable to maintain strict hygiene standards. Their precision, efficiency, and versatility make them indispensable tools in both routine dental care and complex treatments.', 12999.00, '2025-06-26 05:20:04'),
(6, 'Air Driven Handpieces', 'http://localhost/smartdent1/uploads/6859063203318_air driver.png', 'Overview\nAir driven dental handpieces are versatile and reliable tools widely used in dental practices. They operate using compressed air, providing excellent speed and torque for procedures like cavity preparation, polishing, and finishing. These handpieces are lightweight, cost-effective, and compatible with various burs, making them a standard choice in routine dental care.', 13999.00, '2025-06-26 05:22:07'),
(7, 'Ultrasonic Scaler', 'http://localhost/smartdent1/uploads/685905c6a10a2_ultrasonic.png', 'Overview\nUltrasonic scalers are essential dental devices used for removing plaque, calculus, and stains from teeth surfaces through high-frequency vibrations. These tools are preferred for their efficiency, comfort, and ability to reach below the gumline with minimal discomfort. They typically come with interchangeable tips and water spray features for cooling and debris removal during procedures.', 15999.00, '2025-06-26 05:35:40'),
(8, 'Laser Equipment', 'http://localhost/smartdent1/uploads/68590587a0001_laser.png', 'Overview\nLaser dental equipment utilizes concentrated light energy to perform a variety of dental procedures with high precision and minimal discomfort. It is commonly used for treatments such as cavity removal, gum contouring, and teeth whitening. This advanced technology reduces the need for anesthesia, minimizes bleeding, and promotes faster healing, making it a preferred option for both patients and practitioners. Lasers are effective on both soft and hard tissues, enhancing accuracy while reducing the risk of infection and post-operative pain.', 21999.00, '2025-06-26 05:38:33'),
(9, 'Curing Lights', 'http://localhost/smartdent1/uploads/6859053c125a8_curing light.png', 'Overview\nCuring lights are essential in dental procedures for polymerizing light-cured resin-based composites. They offer consistent, high-intensity light output and are crucial in procedures like restorative treatments and sealant applications. With ergonomic designs and cordless options, these devices enhance accessibility and ease of use during treatments.', 14999.00, '2025-06-26 05:40:21'),
(11, 'Vacuum Former', 'http://localhost/smartdent1/uploads/685a1704a3d5a_vacuumformer.png', 'Overview\nThe Vacuum Former is a vital tool in dental laboratories used to create custom-fit trays, mouthguards, and bleaching trays. It operates by heating a thermoplastic sheet and molding it over dental models using suction. This process ensures high precision and adaptability for patient-specific applications. Its compact design and ease of use make it suitable for both clinics and labs. The Vacuum Former enhances productivity and consistency in dental appliance fabrication.', 23000.00, '2025-06-26 05:44:45'),
(12, 'Mixer and Dispenser', 'http://localhost/smartdent1/uploads/685a16db4b90a_mixer and dispenser.png', 'Overview\nA Mixer and Dispenser is an essential dental device used for accurately combining and delivering materials such as impression pastes, cements, and silicones. It ensures precise mixing ratios, which enhances the consistency and quality of dental applications while reducing material waste. These systems often support hands-free, hygienic operation, minimizing the risk of cross-contamination in clinical settings. Their efficiency and ease of use make them especially valuable in high-volume practices where speed and accuracy are critical. Overall, they contribute to improved workflow and more reliable dental restorations.', 5500.00, '2025-06-26 05:47:10'),
(13, 'Dental impression', 'http://localhost/smartdent1/uploads/685a16b175550_dentalimpression1.png', 'Overview\nDental impression trays are essential tools used in dentistry to capture accurate impressions of a patient\'s teeth and surrounding oral structures. These trays are typically made of metal or plastic and are available in various sizes and shapes to fit different mouths. They serve as carriers for impression materials like alginate or silicone, which record the detailed anatomy of the dental arches. Impression trays are used in procedures such as creating dentures, crowns, bridges, and orthodontic appliances. Proper selection and handling of the tray ensure precise results, which are critical for successful dental treatments.', 1500.00, '2025-06-26 05:51:23'),
(14, 'autoclaves', 'http://localhost/smartdent1/uploads/685a1b1caa6e8_autoclave.png', 'Overview\nAutoclaves are vital sterilization devices used in dental and medical settings to eliminate bacteria, viruses, and spores from instruments and equipment. They operate using high-pressure saturated steam at temperatures typically around 121–134°C. This process ensures complete sterilization, making instruments safe for reuse on patients. Autoclaves come in various sizes and are essential for maintaining infection control standards. Regular maintenance and monitoring are necessary to ensure their effectiveness and compliance with health regulations.', 75000.00, '2025-06-26 05:54:43'),
(15, 'Ultrasonic Cleaner', 'http://localhost/smartdent1/uploads/685a1af8d4c79_ultrasonic cleaner.png', 'Overview\nThe Ultrasonic Cleaner is a crucial device in dental settings used for cleaning instruments through high-frequency sound waves. This process removes debris and contaminants even from hard-to-reach areas. It offers superior cleaning efficiency compared to manual methods. Ultrasonic cleaners reduce the risk of cross-contamination and improve sterilization outcomes. Their reliable performance makes them a staple in dental clinics and laboratories.', 17500.00, '2025-06-26 05:58:38'),
(16, 'sterilizers monitoring', 'http://localhost/smartdent1/uploads/685a1a8eee64d_sterilizers monitoring.png', 'Overview\nSterilizer monitoring is a critical process in dental and medical settings to ensure the effectiveness of sterilization equipment. It involves using biological, chemical, and mechanical indicators to verify that sterilizers are functioning properly and achieving complete microbial elimination. Regular monitoring helps maintain patient safety by preventing cross-contamination and infection. It also supports compliance with health regulations and quality assurance protocols. By detecting failures early, sterilizer monitoring protects both healthcare providers and patients from potential risks.', 5000.00, '2025-06-26 06:01:59'),
(17, 'uv sterilizers', 'http://localhost/smartdent1/uploads/685a1a54b13f3_uvsterilizer.png', 'Overview\nA UV sterilizer is a device that uses ultraviolet (UV-C) light to disinfect and eliminate bacteria, viruses, and other pathogens from dental tools and surfaces. It provides a chemical-free, efficient method of sterilization, making it ideal for quick disinfection cycles in clinical environments. UV sterilizers are compact, easy to operate, and suitable for items sensitive to heat or moisture. They help maintain a high standard of hygiene and reduce the risk of cross-contamination. Widely used in dental clinics, UV sterilizers complement traditional sterilization methods for added safety.', 7000.00, '2025-06-26 06:05:22'),
(18, 'dental chairs', 'http://localhost/smartdent1/uploads/685a1cb6bf2ef_dentalchair.png', 'Overview\nA dental chair is a key component of any dental clinic, designed to provide comfort for patients and efficiency for practitioners. With ergonomic support, adjustable settings, and integrated features, dental chairs aid in smooth treatment delivery. These chairs allow precise positioning during procedures, improving visibility and access. Built for both functionality and hygiene, they are vital for safe, effective dental care. A reliable dental chair is indispensable in creating a productive clinical environment.', 65000.00, '2025-06-26 06:08:16'),
(19, 'Operating Light', 'http://localhost/smartdent1/uploads/685a1c88af373_OPERATINGLIGHT.png', 'Overview\nAn operating light, also known as a surgical or dental light, is a crucial fixture in treatment rooms to provide clear, shadow-free illumination during procedures. It ensures optimal visibility of the oral cavity or surgical area, enhancing precision and safety for practitioners. These lights are typically adjustable in intensity and position, with modern versions using LED technology for brightness and energy efficiency. They help reduce eye strain and improve accuracy during detailed work. Proper positioning and maintenance of the light are essential for effective clinical performance.', 70000.00, '2025-06-26 06:11:02'),
(20, 'Suction Devices', 'http://localhost/smartdent1/uploads/685a1c59e4cac_SUCTIONDEVICES.png', 'Overview\nA suction device is an essential dental tool used to remove saliva, blood, and debris from the patient\'s mouth during procedures. It helps maintain a clear working area, improving visibility and hygiene for the dentist. Suction devices come in high-volume and low-volume types, each serving different purposes in treatment. Modern systems are designed to be quiet, efficient, and easy to sterilize. Their continuous use ensures patient comfort and reduces the risk of contamination.', 30000.00, '2025-06-26 06:13:44'),
(21, 'Forceps', 'http://localhost/smartdent1/uploads/685a1e32882bb_forceps.png', 'Overview\nForceps are essential dental instruments used for the extraction of teeth with precision and control. Designed with beak-like ends, they provide a firm grip on the tooth during removal. Each type of forceps is crafted to match the shape and location of specific teeth. They minimize trauma to surrounding tissues and enhance procedural safety. Dental forceps are a vital part of surgical procedures in both general and specialized dentistry.', 2500.00, '2025-06-26 06:16:39'),
(22, 'Scalpel', 'http://localhost/smartdent1/uploads/685a1e16cd9da_scalpel.png', 'Overview\nA scalpel is a small, extremely sharp surgical instrument used in dentistry for precise cutting of soft tissues. It plays a crucial role in procedures like gum surgeries, biopsies, and flap operations. The fine blade allows for clean incisions with minimal tissue trauma, promoting faster healing. Scalpels come in various shapes and sizes to suit different surgical needs. Proper sterilization and handling are essential to ensure patient safety and procedural effectiveness.', 300.00, '2025-06-26 06:20:21'),
(23, 'Elevators', 'http://localhost/smartdent1/uploads/685a1dfa07aeb_elevatoes.png', 'Overview\nElevators are dental instruments used primarily for loosening teeth before extraction. They work by applying leverage between the tooth and surrounding bone to gently elevate the tooth from its socket. Elevators come in various shapes and sizes, tailored for different tooth positions and angles. Their use reduces trauma to the surrounding tissues and aids in easier tooth removal. Proper technique with elevators ensures efficient, safe extractions with minimal discomfort.', 1500.00, '2025-06-26 08:04:40'),
(24, 'Sutures', 'http://localhost/smartdent1/uploads/685a1de219543_sutures.png', 'Overview\nSutures in dentistry are specialized surgical threads used to close wounds or surgical incisions within the oral cavity. They help in stabilizing tissues, promoting proper healing, and reducing the risk of postoperative infections. Depending on the procedure, dentists use absorbable or non-absorbable sutures tailored to the patient’s needs. These sutures play a vital role in oral surgeries such as tooth extractions, gum surgeries, and implant placements. Proper selection and technique in suturing ensure optimal recovery and long-term success of dental procedures.', 300.00, '2025-06-26 08:06:50'),
(25, 'Bone Grafting Instrument', 'http://localhost/smartdent1/uploads/685a1db537e32_bone grafing.png', 'Overview\nBone grafting instruments are essential tools in oral and maxillofacial surgery. These instruments are used to handle, pack, and shape bone graft materials during reconstructive dental procedures. They assist in promoting bone regeneration and stability in implantology and periodontal treatments. Bone grafting plays a vital role in enhancing bone volume and supporting dental implants. Their precision design ensures safety and efficiency in complex procedures.', 2500.00, '2025-06-26 08:18:01'),
(26, 'archwires', 'http://localhost/smartdent1/uploads/685a2ebf896c7_archwires.png', 'Overview\nAn archwire is a key component in orthodontic treatment, used in braces to guide teeth into proper alignment. It fits into the brackets attached to each tooth and applies consistent pressure to shift them gradually. Made from materials like stainless steel or nickel-titanium, archwires come in various shapes and thicknesses. Their flexibility and strength allow for controlled tooth movement over time. Archwires play a crucial role in achieving a straight, functional, and aesthetically pleasing smile.', 550.00, '2025-06-27 02:54:20'),
(27, 'Elastics and Springs', 'http://localhost/smartdent1/uploads/685a2e913dbe3_elastics.png', 'Overview\nElastics and springs are critical components in orthodontic treatment, used to apply continuous force to guide teeth into their desired positions. Elastics, often patient-worn rubber bands, help correct bite alignment and jaw positioning. Springs, including coil and separator types, are used within braces to create space or move teeth. Both tools work in coordination with brackets and archwires to improve treatment efficiency. Their proper use enhances overall dental alignment and accelerates orthodontic outcome', 425.00, '2025-06-27 02:56:50'),
(28, 'Ligatures', 'http://localhost/smartdent1/uploads/685a2eaf30cab_ligatures.png', 'Overview\nLigatures are small elastic or wire components used in orthodontics to secure the archwire to braces brackets. They help maintain consistent pressure on the teeth, guiding them into the correct position over time. Available in various colors, elastic ligatures are often changed during each dental visit. Wire ligatures offer a stronger hold and are used in cases requiring more precise control. Overall, ligatures play a vital role in the effectiveness and stability of orthodontic treatment.', 350.00, '2025-06-27 02:59:37'),
(29, 'Endodontic Files', 'http://localhost/smartdent1/uploads/685a214e27fa9_enodonitc files.png', 'Overview\nEndodontic files are specialized dental instruments used primarily during root canal treatments. They help clean and shape the root canals by removing infected pulp tissue and debris. These files come in various sizes and designs to navigate complex root canal structures with precision. Their flexibility and strength allow dentists to maintain the natural shape of the canal while ensuring thorough cleaning. Overall, endodontic files are crucial for the success and long-term outcome of endodontic procedures.', 800.00, '2025-06-27 03:07:20'),
(30, 'root canal filling material', 'http://localhost/smartdent1/uploads/685a20e44edea_root.png', 'Overview\nRoot canal filling materials are essential in endodontic therapy to seal the cleaned and shaped root canal space effectively. They prevent bacterial re-infiltration by creating a tight seal within the canal. Commonly used materials include gutta-percha and bioceramic sealers, known for their biocompatibility and durability. These materials support the long-term preservation of the treated tooth. Proper selection and application are critical to the success of root canal treatment.', 1400.00, '2025-06-27 03:09:21'),
(31, 'Endodontic Motors', 'http://localhost/smartdent1/uploads/685a20ba40a69_endodonitc motors.png', 'Overview\nEndodontic motors are advanced dental devices used to automate root canal procedures with greater precision and efficiency. These tools provide controlled speed and torque for cleaning and shaping root canals, enhancing patient safety and clinician accuracy. Most modern motors offer adjustable settings and compatibility with various endodontic files. They reduce manual effort and improve procedural consistency. As a result, they are vital for successful endodontic therapy in modern dentistry.', 10000.00, '2025-06-27 03:11:22');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image_url`) VALUES
(1, 1, 'http://localhost/smartdent1/uploads/1750833657_dental mirror.png'),
(2, 1, 'http://localhost/smartdent1/uploads/1750833657_dentalmirror 1.png'),
(3, 1, 'http://localhost/smartdent1/uploads/1750833657_dentalmirror 2.png'),
(4, 2, 'http://localhost/smartdent1/uploads/1750838684_Dentalexplorer 1.png'),
(5, 2, 'http://localhost/smartdent1/uploads/1750838684_Dentalexplorer 2.png'),
(6, 2, 'http://localhost/smartdent1/uploads/1750838684_Dentalexplorer.png'),
(7, 3, 'http://localhost/smartdent1/uploads/1750914522_IntraoralCamera.png'),
(8, 3, 'http://localhost/smartdent1/uploads/1750914522_IntraoralCamera 2.png'),
(9, 3, 'http://localhost/smartdent1/uploads/1750914522_IntraoralCamera 1.png'),
(10, 4, 'http://localhost/smartdent1/uploads/1750914983_x-ray.png'),
(11, 4, 'http://localhost/smartdent1/uploads/1750914983_x-ray.png'),
(12, 4, 'http://localhost/smartdent1/uploads/1750914983_x-ray1.png'),
(13, 5, 'http://localhost/smartdent1/uploads/1750915204_handpiece.png'),
(14, 5, 'http://localhost/smartdent1/uploads/1750915204_handpiece1.png'),
(15, 5, 'http://localhost/smartdent1/uploads/1750915204_handpiece2.png'),
(16, 6, 'http://localhost/smartdent1/uploads/1750915327_air.png'),
(17, 6, 'http://localhost/smartdent1/uploads/1750915327_air1.png'),
(18, 6, 'http://localhost/smartdent1/uploads/1750915327_air2.png'),
(19, 7, 'http://localhost/smartdent1/uploads/1750916140_ultrasonicscaler.png'),
(20, 7, 'http://localhost/smartdent1/uploads/1750916140_ultrasonicscaler1.png'),
(21, 7, 'http://localhost/smartdent1/uploads/1750916140_ultrasonicscaler2.png'),
(22, 8, 'http://localhost/smartdent1/uploads/1750916313_laser equipment.png'),
(23, 8, 'http://localhost/smartdent1/uploads/1750916313_laserequipment1.png'),
(24, 8, 'http://localhost/smartdent1/uploads/1750916313_laserequipment2.png'),
(25, 9, 'http://localhost/smartdent1/uploads/1750916421_curinglight.png'),
(26, 9, 'http://localhost/smartdent1/uploads/1750916421_curinglight1.png'),
(27, 9, 'http://localhost/smartdent1/uploads/1750916421_curinglight2.png'),
(31, 11, 'http://localhost/smartdent1/uploads/1750916685_vacuumformer.png'),
(32, 11, 'http://localhost/smartdent1/uploads/1750916685_vacuumformer1.png'),
(33, 11, 'http://localhost/smartdent1/uploads/1750916685_vacuumformer2.png'),
(34, 12, 'http://localhost/smartdent1/uploads/1750916830_mixer.png'),
(35, 12, 'http://localhost/smartdent1/uploads/1750916830_mixer1.png'),
(36, 12, 'http://localhost/smartdent1/uploads/1750916830_mixer2.png'),
(37, 13, 'http://localhost/smartdent1/uploads/1750917083_dentalimpression2.png'),
(38, 13, 'http://localhost/smartdent1/uploads/1750917083_dentalimpression1.png'),
(39, 13, 'http://localhost/smartdent1/uploads/1750917083_dentalimpression12.png'),
(40, 14, 'http://localhost/smartdent1/uploads/1750917283_autoclave.png'),
(41, 14, 'http://localhost/smartdent1/uploads/1750917283_autoclave1.png'),
(42, 14, 'http://localhost/smartdent1/uploads/1750917283_autoclave2.png'),
(43, 15, 'http://localhost/smartdent1/uploads/1750917518_ultrasoniccleaner.png'),
(44, 15, 'http://localhost/smartdent1/uploads/1750917518_ultrasoniccleaner1.png'),
(45, 15, 'http://localhost/smartdent1/uploads/1750917518_ultrasoniccleaner2.png'),
(46, 16, 'http://localhost/smartdent1/uploads/1750917719_sterilizermonitoring.png'),
(47, 16, 'http://localhost/smartdent1/uploads/1750917719_sterilizermonitoring 1.png'),
(48, 16, 'http://localhost/smartdent1/uploads/1750917719_sterilizermonitoring 2.png'),
(49, 17, 'http://localhost/smartdent1/uploads/1750917922_uvsterilizer.png'),
(50, 17, 'http://localhost/smartdent1/uploads/1750917922_uvsterilizer 1.png'),
(51, 17, 'http://localhost/smartdent1/uploads/1750917922_uvsterilizer 2.png'),
(52, 18, 'http://localhost/smartdent1/uploads/1750918096_dentalchair.png'),
(53, 18, 'http://localhost/smartdent1/uploads/1750918096_dentalchair1.png'),
(54, 18, 'http://localhost/smartdent1/uploads/1750918096_dentalchair2.png'),
(55, 19, 'http://localhost/smartdent1/uploads/1750918262_OPERATINGLIGHT.png'),
(56, 19, 'http://localhost/smartdent1/uploads/1750918262_OPERATINGLIGHT1.png'),
(57, 19, 'http://localhost/smartdent1/uploads/1750918262_OPERATINGLIGHT2.png'),
(58, 20, 'http://localhost/smartdent1/uploads/1750918424_SUCTIONDEVICES.png'),
(59, 20, 'http://localhost/smartdent1/uploads/1750918424_SUCTIONDEVICES1.png'),
(60, 20, 'http://localhost/smartdent1/uploads/1750918424_SUCTIONDEVICES2.png'),
(61, 21, 'http://localhost/smartdent1/uploads/1750918599_forceps.png'),
(62, 21, 'http://localhost/smartdent1/uploads/1750918599_forceps1.png'),
(63, 21, 'http://localhost/smartdent1/uploads/1750918599_forceps2.png'),
(64, 22, 'http://localhost/smartdent1/uploads/1750918821_scalpel 1.png'),
(65, 22, 'http://localhost/smartdent1/uploads/1750918821_scalpel 2.png'),
(66, 22, 'http://localhost/smartdent1/uploads/1750918821_scalpel.png'),
(67, 23, 'http://localhost/smartdent1/uploads/1750925080_elevatoes.png'),
(68, 23, 'http://localhost/smartdent1/uploads/1750925080_elevatoes1.png'),
(69, 23, 'http://localhost/smartdent1/uploads/1750925080_elevatoes2.png'),
(70, 24, 'http://localhost/smartdent1/uploads/1750925210_Sutures.png'),
(71, 24, 'http://localhost/smartdent1/uploads/1750925210_Sutures1.png'),
(72, 24, 'http://localhost/smartdent1/uploads/1750925210_Sutures2.png'),
(73, 25, 'http://localhost/smartdent1/uploads/1750925881_bone.png'),
(74, 25, 'http://localhost/smartdent1/uploads/1750925881_bone1.png'),
(75, 25, 'http://localhost/smartdent1/uploads/1750925881_bone2.png'),
(76, 26, 'http://localhost/smartdent1/uploads/1750992860_archwire1.png'),
(77, 26, 'http://localhost/smartdent1/uploads/1750992860_archwire2.png'),
(78, 26, 'http://localhost/smartdent1/uploads/1750992860_archwire3.png'),
(79, 27, 'http://localhost/smartdent1/uploads/1750993010_elastics1.png'),
(80, 27, 'http://localhost/smartdent1/uploads/1750993010_elastics2.png'),
(81, 27, 'http://localhost/smartdent1/uploads/1750993010_elastics3.png'),
(82, 28, 'http://localhost/smartdent1/uploads/1750993177_ligatures1.png'),
(83, 28, 'http://localhost/smartdent1/uploads/1750993177_ligatures2.png'),
(84, 28, 'http://localhost/smartdent1/uploads/1750993177_ligatures3.png'),
(85, 29, 'http://localhost/smartdent1/uploads/1750993640_enodonitc files1.png'),
(86, 29, 'http://localhost/smartdent1/uploads/1750993640_enodonitc files2.png'),
(87, 29, 'http://localhost/smartdent1/uploads/1750993640_enodonitc files3.png'),
(88, 30, 'http://localhost/smartdent1/uploads/1750993761_root.png'),
(89, 30, 'http://localhost/smartdent1/uploads/1750993761_root1.png'),
(90, 30, 'http://localhost/smartdent1/uploads/1750993761_root2.png'),
(91, 31, 'http://localhost/smartdent1/uploads/1750993882_endodonitcmotors1.png'),
(92, 31, 'http://localhost/smartdent1/uploads/1750993882_endodonitcmotors2.png'),
(93, 31, 'http://localhost/smartdent1/uploads/1750993882_endodonitcmotors3.png');

-- --------------------------------------------------------

--
-- Table structure for table `profile`
--

CREATE TABLE `profile` (
  `profile_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `profile_image` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profile`
--

INSERT INTO `profile` (`profile_id`, `user_id`, `name`, `email`, `created_at`, `profile_image`) VALUES
(1, 1, 'hemanthsai', 'chinnu121@gmail.com', '2025-06-25 04:18:47', NULL),
(2, 2, 'chinnu', 'hemanthsai0602@gmail.com', '2025-06-25 05:23:13', NULL),
(3, 3, 'chinnu', 'chinnu21@gmail.com', '2025-06-27 04:19:05', 'http://localhost/smartdent1/uploads/profile_images/3_1752462734.jpg'),
(4, 4, 'hemanth', 'chiin212@gmail.com', '2025-07-01 05:31:22', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `service_requests`
--

CREATE TABLE `service_requests` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `service_type` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_requests`
--

INSERT INTO `service_requests` (`id`, `name`, `contact`, `service_type`, `address`, `user_id`) VALUES
(1, 'M.Hemanth sai', '9100800764', 'Dental chair service', 'Sainager,sullurupata, Nellore, Andhra Pradesh - 524121', 123),
(2, 'chinnu', '9100800764', 'dental chair', 'sainager,sullurpata,nellore dist,A.P', 1),
(3, 'Hemanth', '8489465', 'Watergate', 'Are harden, Nelloire, Andhra Pradesh - 524121', 3);

-- --------------------------------------------------------

--
-- Table structure for table `signup`
--

CREATE TABLE `signup` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `signup`
--

INSERT INTO `signup` (`user_id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 'hemanthsai', 'chinnu121@gmail.com', '$2y$10$7QM0WoUSTR85GKF/tmSCYOeQS4Yj.UjqV6ACsW/UF1dI6ycy7OZ4G', '2025-06-25 04:18:47'),
(2, 'chinnu', 'hemanthsai0602@gmail.com', '$2y$10$tYwajDrNhEJ3PcSQqDdB2.h/ZswVb068q0WJPKrc9sauDBj8xfKre', '2025-06-25 05:23:13'),
(3, 'chinnu', 'chinnu21@gmail.com', '$2y$10$fN4WoWTGchTbuu6xpY3yjOo2DSlF1KXUh7qA/YA2z3i2s25Aki8bm', '2025-06-27 04:19:05'),
(4, 'hemanth', 'chiin212@gmail.com', '$2y$10$dZmUgzpEUt4.G73hB.DujODPwSPXxltyJiEjvecHfmtqRYBSyomOu', '2025-07-01 05:31:22');

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`id`, `product_id`, `name`, `image`, `price`, `stock`) VALUES
(1, 1, 'Dental Mirror', 'http://localhost/smartdent1/uploads/6858fa575459c_dental mirror.png', 299.00, 20),
(2, 2, 'Dental Explorer', 'http://localhost/smartdent1/uploads/6858fbc9d7094_dental explorer.png', 249.00, 20),
(3, 3, 'Intraoral Camera', 'http://localhost/smartdent1/uploads/6858fc286e2f5_intronal camera.png', 1599.00, 20),
(4, 4, 'X-Ray Machine', 'http://localhost/smartdent1/uploads/6858fc4e42157_x-ray.png', 28999.00, 20),
(5, 5, 'Dental Handpieces', 'http://localhost/smartdent1/uploads/6859065c0ae05_dental handpieces.png', 12999.00, 20),
(6, 6, 'Air Driven Handpieces', 'http://localhost/smartdent1/uploads/6859063203318_air driver.png', 13999.00, 20),
(7, 7, 'Ultrasonic Scaler', 'http://localhost/smartdent1/uploads/685905c6a10a2_ultrasonic.png', 15999.00, 20),
(8, 8, 'Laser Equipment', 'http://localhost/smartdent1/uploads/68590587a0001_laser.png', 21999.00, 20),
(9, 9, 'Curing Lights', 'http://localhost/smartdent1/uploads/6859053c125a8_curing light.png', 14999.00, 20),
(11, 11, 'Vacuum Former', 'http://localhost/smartdent1/uploads/685a1704a3d5a_vacuumformer.png', 23000.00, 20),
(12, 12, 'Mixer and Dispenser', 'http://localhost/smartdent1/uploads/685a16db4b90a_mixer and dispenser.png', 5500.00, 20),
(13, 13, 'Dental impression', 'http://localhost/smartdent1/uploads/685a16b175550_dentalimpression1.png', 1500.00, 20),
(14, 14, 'autoclaves', 'http://localhost/smartdent1/uploads/685a1b1caa6e8_autoclave.png', 75000.00, 20),
(15, 15, 'Ultrasonic Cleaner', 'http://localhost/smartdent1/uploads/685a1af8d4c79_ultrasonic cleaner.png', 17500.00, 20),
(16, 16, 'sterilizers monitoring', 'http://localhost/smartdent1/uploads/685a1a8eee64d_sterilizers monitoring.png', 5000.00, 20),
(17, 17, 'uv sterilizers', 'http://localhost/smartdent1/uploads/685a1a54b13f3_uvsterilizer.png', 7000.00, 20),
(18, 18, 'Dental Chair', 'http://localhost/smartdent1/uploads/685a1cb6bf2ef_dentalchair.png', 65000.00, 20),
(19, 19, 'Operating Light', 'http://localhost/smartdent1/uploads/685a1c88af373_OPERATINGLIGHT.png', 70000.00, 20),
(20, 20, 'Suction Devices', 'http://localhost/smartdent1/uploads/685a1c59e4cac_SUCTIONDEVICES.png', 30000.00, 20),
(21, 21, 'Forceps', 'http://localhost/smartdent1/uploads/685a1e32882bb_forceps.png', 2500.00, 20),
(22, 22, 'Scalpel', 'http://localhost/smartdent1/uploads/685a1e16cd9da_scalpel.png', 300.00, 20),
(23, 23, 'Elevators', 'http://localhost/smartdent1/uploads/685a1dfa07aeb_elevatoes.png', 1500.00, 20),
(24, 24, 'Sutures', 'http://localhost/smartdent1/uploads/685a1de219543_sutures.png', 300.00, 20),
(25, 25, 'Bone Grafting Instrument', 'http://localhost/smartdent1/uploads/685a1db537e32_bone grafing.png', 2500.00, 20),
(26, 26, 'Archwire', 'http://localhost/smartdent1/uploads/685a2ebf896c7_archwires.png', 550.00, 20),
(27, 27, 'Elastics and Springs', 'http://localhost/smartdent1/uploads/685a2e913dbe3_elastics.png', 425.00, 20),
(28, 28, 'Ligatures', 'http://localhost/smartdent1/uploads/685a2eaf30cab_ligatures.png', 350.00, 20),
(29, 29, 'Endodontic Files', 'http://localhost/smartdent1/uploads/685a214e27fa9_enodonitc files.png', 800.00, 20),
(30, 30, 'Root Canal Filling', 'http://localhost/smartdent1/uploads/685a20e44edea_root.png', 1400.00, 20),
(31, 31, 'Endodontic Motors', 'http://localhost/smartdent1/uploads/685a20ba40a69_endodonitc motors.png', 10000.00, 20);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `add_products`
--
ALTER TABLE `add_products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_login`
--
ALTER TABLE `admin_login`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cart` (`user_id`,`product_id`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`login_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `profile`
--
ALTER TABLE `profile`
  ADD PRIMARY KEY (`profile_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `service_requests`
--
ALTER TABLE `service_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `signup`
--
ALTER TABLE `signup`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `add_products`
--
ALTER TABLE `add_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `admin_login`
--
ALTER TABLE `admin_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `login_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `profile`
--
ALTER TABLE `profile`
  MODIFY `profile_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `service_requests`
--
ALTER TABLE `service_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `signup`
--
ALTER TABLE `signup`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=302;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `signup` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `profile`
--
ALTER TABLE `profile`
  ADD CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `signup` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
