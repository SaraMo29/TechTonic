# TechTonic - E-Learning Platform

[TechTonic Logo] <img src="src/assets/images/logo.png" alt="TechTonic Logo" width="200" /> <!-- Optional: add your logo here -->

---

## 🚀 About TechTonic

TechTonic is a modern e-learning platform designed to deliver high-quality courses with an intuitive Flutter frontend and a powerful Node.js backend. It supports course browsing, progress tracking, certificate generation, and in-app purchases, all wrapped in a smooth user experience.

---

## 🛠️ Features

- User Registration & Login (Email only)  
- Course Catalog with filtering and search  
- Interactive Lesson Content (Video, PDF)  
- Progress Tracking & Certificates by Email  
- Secure Transactions for course purchases  
- Built-in Code Editor (Flutter frontend)  
- Responsive Design for multiple devices  

---

## 🏗️ Tech Stack

| Frontend        | Backend         | Database       | Other Tools               |
|-----------------|-----------------|----------------|---------------------------|
| Flutter         | Node.js (Express) | MongoDB       | Cloudinary, JWT          |

---

# 🔧 Getting Started

## Prerequisites

Before you begin, ensure your system meets the following requirements and that you have installed the necessary software dependencies:

### System Requirements

- **Operating System**  
  - Windows 10 or later  
  - macOS 11 (Big Sur) or later  
  - Linux distributions (Ubuntu 18.04+, Fedora 32+, etc.)

- **Hardware**  
  - CPU: 64-bit dual-core or better  
  - RAM: Minimum 4 GB (8 GB+ recommended)  
  - Disk Space: At least 2 GB free for code and dependencies (plus media storage for Cloudinary uploads)  
  - Internet connection (for downloading dependencies and connecting to remote services)

### Software Dependencies

- **Git** (for cloning the repository)  
- **Node.js** v14 or later  
- **npm** (bundled with Node.js)  
- **Flutter SDK** v3.x or later  
- **Dart SDK** (comes with Flutter)  
- **MongoDB** 4.x or 5.x (local or hosted instance)  
- **Cloudinary** account (for media storage; you’ll need cloud name, API key & secret)  

### Optional Tools

- **Postman** or **Insomnia** (for API testing)  
- **VS Code**, **WebStorm**, or another IDE/text editor of your choice  
- **Homebrew** (macOS) or **Chocolatey** (Windows) for simplified package management  

---

## Installation

### Clone & Setup
```bash 
# 1. Clone the backend repo
git clone https://github.com/Faresaymann/techtonic-backend.git
# This creates a folder named `techtonic-backend`

# 2. Clone the frontend repo
git clone https://github.com/SaraMo29/TechTonic.git Techtonic
# The `TechTonic` folder will contain your Flutter code
```

### Setup Backend

#### Windows (PowerShell)
```bash
cd backend
npm install
Copy-Item .env.example .env
# Edit .env with Notepad or VS Code
notepad .env
npm run dev
```

#### macOS / Linux
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your credentials
nano .env
npm run dev
```

### Setup Frontend

#### macOS / Linux
```bash
cd frontend
flutter pub get
flutter run
```

#### Windows (PowerShell)
```bash 
cd frontend
flutter pub get
flutter run
```

---
## Configuration 
  Your .env file (located in /backend) must include the following variables:
```bash
# MongoDB connection
MONGO_URI=mongodb://localhost:27017/techtonic

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# (optional) Server port
PORT=3000
```
---

## 📚 Documentation
 Full documentation is available at our [GitBook site](https://faresayman.gitbook.io/techtonic/).


---

## 🤝 Contributing
 Contributions are welcome! Please fork the repo, create a feature branch, and submit a pull request.

---

## 📄 License
 This project is licensed under the MIT License.

---

## 📞 Contact
 For questions or support, reach out to faressaymann@gmail.com.


