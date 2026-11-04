# Stronger Muscles Administration Dashboard

A modern, high-performance administrative dashboard built with the **Flutter** framework for managing the **Stronger Muscles** sports supplements and fitness e-commerce ecosystem. The system is architected around **Clean Architecture**, **SOLID principles**, and is supercharged with **Google Gemini AI** for intelligent product cataloging and automated data extraction.

---

## Key Highlights & AI Capabilities

### Powered by Google Gemini AI
The dashboard features an integrated AI Assistant powered by **Google Gemini** (`gemini-3.5-flash`, `gemini-3.5-flash-lite`) designed to streamline product ingestion and eliminate manual data entry:
- **Intelligent Product Auto-Fill:** Enter a product name or an official manufacturer reference link (URL), and Gemini automatically extracts and formats comprehensive product details.
- **Bilingual Content Generation:** Automatically generates professional Arabic and English titles and marketing descriptions tailored for fitness consumers.
- **Metric Weight Standardization:** Enforces strict metric standards (`g` and `kg`), automatically converting imperial units (such as `lbs` and `oz`) to precise metric equivalents (e.g., `5 lbs -> 2.27kg`).
- **Strict Flavor Catalog Matching:** Restricts suggested flavors strictly to existing store flavors (`ProductFlavorHelper`), preventing catalog pollution.
- **Complete Nutritional & Technical Profiling:** Accurately catalogs nutritional facts (Calories, Protein, Carbs, Fat, Sugar, Allergens), servings per container, serving size, suggested sizes, and SKU codes.
- **Interactive Preview & Selective Application:** Administrators review, edit, and selectively apply generated sections before applying them to the form.
- **Live AI Settings & Testing:** Easily configure the Gemini API key, choose from available models, and run live diagnostic connection tests directly from the Settings page.

---

## Core Features

### Strategic Analytics & Reporting
- Real-time KPI tracking for revenue, orders, active users, and inventory status.
- Interactive data visualizations and charts powered by `fl_chart`.
- Sales performance monitoring and best-selling product analysis.

### Comprehensive Product & Catalog Management
- Multi-size and multi-variant pricing, discount calculations, and stock management.
- Hierarchical multi-level category navigation and brand directory.
- Image management with background isolation and multi-asset gallery uploads.
- Metric-first weight and unit management.

### Order Lifecycle & Fulfillment
- End-to-end order processing from placement to delivery.
- Status management (Pending, Processing, Shipped, Delivered, Cancelled).
- Invoicing and shipment tracking workflows.

### Live Support & Ticketing System
- Interactive customer support ticket management.
- Real-time chat interface with optimistic UI updates for instant messaging.

### User Management & Role-Based Access Control (RBAC)
- Multi-tier role permissions: `super_admin`, `admin`, and `customer_support`.
- Dynamic UI gating ensuring restricted sections are strictly accessible to authorized roles.

### Modern UI & Global Accessibility
- Soft UI / Neumorphism-inspired responsive layout adapted for Desktop, Tablet, and Mobile.
- Full bilingual localization (Arabic RTL and English LTR).
- Adaptive Light and Dark mode themes.

---

## Technical Architecture

The project strictly follows **Clean Architecture** and **SOLID principles**, separating concerns into distinct layers:

```
lib/
├── core/                         # Core utilities, theme, network client, and configs
│   ├── config/gemini_config.dart # Gemini AI configuration & API keys
│   ├── network/                  # Dio HTTP client and interceptors
│   ├── theme/                    # Neumorphic soft UI theme definitions
│   └── utils/                    # Weight helpers, feedback, and formatters
└── features/                     # Feature-first modular structure
    ├── auth/                     # Authentication & RBAC
    ├── brands/                   # Brand catalog management
    ├── categories/               # Category tree management
    ├── dashboard/                # KPIs, charts, and metrics
    ├── orders/                   # Order tracking and processing
    ├── products/                 # Product catalog & Gemini AI integration
    │   ├── data/                 # Gemini datasource, repositories, and models
    │   ├── domain/               # Product entities, repositories, and use cases
    │   └── presentation/         # Form sections, preview modals, and controllers
    ├── settings/                 # App settings & Gemini AI API configuration
    ├── support_chat/             # Support ticketing and chat system
    └── users/                    # User accounts and activity monitoring
```

---

## Tech Stack

- **Framework:** Flutter (Latest Stable)
- **Language:** Dart
- **AI Engine:** Google Gemini API (REST / `v1beta` models)
- **Networking:** `Dio` with custom interceptors and failure mapping
- **Architecture:** Clean Architecture + Feature-Driven Structure
- **Functional Programming:** `fpdart` (`Either<Failure, T>`)
- **State Management:** Mixin-based Clean Presentation Controllers with `ChangeNotifier`
- **Charts:** `fl_chart`
- **Local Storage:** `Hive` & `SharedPreferences`
- **Code Quality:** 100% test passing, 0 analyzer warnings

---

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Google Gemini API Key ([Google AI Studio](https://aistudio.google.com/))

### Installation & Run

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd stronger_muscles_dashboard
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (if applicable):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Launch the dashboard:
   ```bash
   flutter run -d chrome # or linux / windows / macos
   ```

5. Configure Gemini AI:
   - Navigate to **Settings (الإعدادات)** -> **Gemini AI Settings**.
   - Enter your API Key, select the model (`gemini-3.5-flash`), and click **Test Connection (فحص الاتصال)**.

---

## Testing

Execute the comprehensive test suite (200+ unit and widget tests):

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

