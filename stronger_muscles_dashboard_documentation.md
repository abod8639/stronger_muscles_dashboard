## Stronger Muscles Dashboard Application: Technical Documentation

### Overview

The Stronger Muscles Dashboard is a Flutter application designed to provide an administrative interface for managing an e-commerce platform focused on fitness and muscle-building products. It offers functionalities for monitoring key business metrics, managing products, categories, orders, and user accounts. The application aims for a modern, responsive, and intuitive user experience across different screen sizes.

### Project Structure

The `lib` directory is organized into several logical folders, promoting separation of concerns and maintainability:

-   **[[config]]**: Contains configuration files for the application, such as theme definitions, API endpoints, and responsive layout helpers.
    -   `api_config.dart`: Defines API endpoints and a `GetxController` for managing the base URL.
    -   `responsive.dart`: Provides utility functions and an extension for `BuildContext` to handle responsive UI layouts based on screen size.
    -   `theme.dart`: Defines the application's color palette (`AppColors`) and light/dark theme data (`AppTheme`).
-   **[[components]]**: Houses reusable Flutter widgets used across different screens. These are generally stateless or manage their own ephemeral UI state, abstracting common UI patterns.
    -   `animated_category_card.dart`, `animated_order_list_tile.dart`, `animated_stat_card.dart`: Animated cards for displaying categories, orders, and statistics.
    -   `bar_chart_widget.dart`, `line_chart_widget.dart`, `pie_chart_widget.dart`: Widgets for displaying various types of charts using `fl_chart`.
    -   `categories_grid.dart`, `recent_orders_list.dart`: Layout widgets for displaying lists or grids of categories and recent orders.
    -   `confirm_dialog.dart`: A generic confirmation dialog.
    -   `connection_status.dart`, `enhanced_error_widget.dart`, `enhanced_loading_widget.dart`, `no_data_screen.dart`: Widgets for displaying connection status, error messages, loading indicators, and empty states.
    -   `image_gallery_editor.dart`: A widget for managing a list of image URLs with reordering and adding capabilities.
    -   `order_status_chart.dart`, `enhanced_status_chart.dart`: Widgets for visualizing order status distributions.
    -   `section_header.dart`, `statistic_card.dart`, `status_badge.dart`: Generic UI components for headers, static cards, and status indicators.
-   **[[controllers]]**: Implements the business logic and state management using GetX. Each controller is responsible for a specific domain (e.g., dashboard, products, users).
    -   `auth_controller.dart`: Handles user authentication (login, signup, logout) and manages authentication state.
    -   `categories_controller.dart`: Manages the state and logic related to product categories (fetching, adding, updating, deleting, searching).
    -   `dashboard_controller.dart`: Manages the overall dashboard data, statistics, and connection status.
    -   `orders_controller.dart`: Manages order data, filtering, and search.
    -   `products_controller.dart`: Manages product data (fetching, CRUD operations, image uploads, filtering, search).
    -   `users_controller.dart`: Manages user data and statistics.
-   **[[generated]]**: Contains auto-generated files for internationalization (localization) using the `intl` package.
-   **[[l10n]]**: Contains the Application Resource Bundle (ARB) files for localization.
-   **[[models]]**: Defines the data structures (Dart classes) for various entities within the application.
    -   `cart_item.dart`: Represents an item in a shopping cart.
    -   `category.dart`: Represents a product category.
    -   `dashboard_user_model.dart`: Models for user data displayed on the dashboard, including `DashboardResponse` and `DashboardUser`.
    -   `flavors_model.dart`: Simple model for product flavors.
    -   `order.dart`: Defines `OrderModel`, `OrderItemModel`, `OrderStatus` enum, and `PaymentStatus` enum.
    -   `product.dart`: Represents a product with various attributes.
    -   `user-address.dart`: Represents a user's address.
    -   `user.dart`: Represents a user's profile.
-   **[[repositories]]**: Acts as an abstraction layer between the controllers and data sources (APIs). Each repository handles data operations for a specific model.
    -   `category_repository.dart`: Handles CRUD operations for categories.
    -   `order_repository.dart`: Handles fetching order data.
    -   `product_repository.dart`: Handles CRUD operations for products.
    -   `user_repository.dart`: Handles fetching user statistics.
-   **[[screens]]**: Contains the UI implementation for different sections of the application. Each sub-folder represents a major screen or feature.
    -   `auth`: Contains `login_screen.dart` and `signup_screen.dart` for user authentication.
    -   `Categories_Screen`: `categories_screen.dart` for displaying and managing categories, and widgets like `CategoryFormSheet.dart`, `CategoryGridItem.dart`, `CategoryListItem.dart`.
    -   `Dashboard_Screen`: `dashboard_screen.dart` for displaying overall statistics and charts, and widgets like `PeriodButton.dart`, `buildAppBar.dart`, `buildDashboardScreenPeriodSelector.dart`, `buildDashboardScreenStatsCards.dart`.
    -   `orders_screen`: `orders_screen.dart` for listing orders and `order_details_screen.dart` for individual order details.
    -   `Products_Screen`: `products_screen.dart` for listing products and `ProductFormPage.dart` (and `ProductFormSheet.dart`) for adding/editing products. Includes widgets like `CategoryItem.dart`, `FlavorMultiSelect.dart`, `ProductCard.dart`, `ProductListItem.dart`, `ProductsCategoriesScreen.dart`, `availability_switch.dart`, `buildActionButtons.dart`, `buildModernDropdown.dart`, `buildModernTextField.dart`, `product_size_selector.dart`.
    -   `Settings_Screen`: `settings_screen.dart` for application settings, including API configuration.
    -   `Users_Screen`: `users_screen.dart` for displaying and managing users.
    -   `widgets`: General-purpose UI widgets like `drawer.dart`, `my_bottomnavigationbar.dart`, `sidebar.dart`, and shared form field helpers.
-   **[[services]]**: Provides core services like API communication and authentication.
    -   `api_service.dart`: Handles all HTTP requests to the backend API, including authentication headers, error handling, and file uploads.
    -   `auth_service.dart`: Manages user authentication state (token, user data) using `GetStorage`.

### Data Flow

The application follows a clean architecture pattern, primarily leveraging the MVVM (Model-View-ViewModel) approach with GetX for state management.

1.  **User Interaction (View/Screens)**: Users interact with widgets defined in the [[screens]] and [[components]] folders.
2.  **Event Handling (Controllers)**: User actions (e.g., button taps, text input) trigger methods in the corresponding [[controllers]]. For example, a button to fetch products would call `ProductsController.fetchData()`.
3.  **Business Logic (Controllers)**: Controllers contain the core business logic, manipulating data, performing validations, and updating observable states.
4.  **Data Request (Repositories)**: When data is needed from a remote source (like an API), the controller calls a method on the relevant [[repositories]]. The repository acts as an abstraction, hiding the data source details.
5.  **API Communication (Services)**: The repository, in turn, uses the [[ApiService]] to make actual HTTP requests to the backend API. The `ApiService` handles:
    -   Constructing the correct API endpoint using [[ApiConfig]].
    -   Adding authentication headers via [[AuthService]].
    -   Handling network requests (GET, POST, PUT, DELETE).
    -   Parsing JSON responses.
    -   Handling API-specific errors (e.g., 401 Unauthorized, 403 Forbidden) by redirecting to the login screen or showing snackbars.
    -   Handling file uploads (e.g., product images).
6.  **Data Processing (Models)**: Raw JSON data received from the API is parsed into strongly-typed Dart objects (e.g., `ProductModel`, `CategoryModel`) defined in the [[models]] folder. This ensures type safety and easier manipulation of data.
7.  **State Update (Controllers)**: Once data is retrieved and processed by the repository and service, it is passed back to the controller. The controller updates its observable (`Rx`) variables.
8.  **UI Re-render (View/Screens)**: Widgets wrapped in `Obx` (from GetX) automatically rebuild when the observable variables they depend on change, reflecting the latest state to the user.

**Example Data Flow: Fetching Products**

-   A `ProductsScreen` (View) needs to display a list of products.
-   It uses `Get.put(ProductsController())` to instantiate/retrieve the [[ProductsController]] (ViewModel).
-   The `ProductsController`'s `onInit` or an explicit call to `fetchData()` is made.
-   `ProductsController.fetchData()` calls `_productRepository.getProducts()`.
-   `ProductRepository.getProducts()` calls `_apiService.fetchProducts()`.
-   `ApiService.fetchProducts()` makes an HTTP GET request to the `/admin/products` endpoint.
-   The API responds with product data (JSON).
-   `ApiService` parses the JSON and returns it to `ProductRepository`.
-   `ProductRepository` maps the JSON data to `ProductModel` objects and returns the list to `ProductsController`.
-   `ProductsController` updates its `products.assignAll(fetchedProducts)` observable list.
-   The `Obx` widget in `ProductsScreen` rebuilds the `ListView.builder` with the new `filteredProducts` (which is derived from `products`), displaying them to the user.

### State Management

The application exclusively uses **[[GetX]]** for state management, dependency injection, and routing.

**Key GetX Concepts Used:**

-   **`GetxController`**: Base class for controllers that manage state and logic.
-   **`Rx` Variables (Observables)**: Variables declared with `.obs` (e.g., `final isLoading = true.obs;`) automatically become observable. When their value changes, any widget observing them will rebuild.
-   **`Obx` Widget**: A lightweight widget that rebuilds only when its observable dependencies change. It's used in the UI to react to state updates from controllers.
-   **Dependency Injection**: `Get.put(Controller())` is used to create and register controllers, making them globally accessible. `Get.find<Controller>()` retrieves an existing instance. This avoids passing controllers down the widget tree manually.
-   **Routing**: `Get.toNamed('/route')`, `Get.offAllNamed('/route')`, `Get.back()` are used for navigation.

**How it Works in Practice:**

1.  **Initialization**: In `main.dart`, `GetMaterialApp` is used, which is GetX's entry point for routing and state management.
2.  **Controller Creation**: In screens, `Get.put(MyController())` is called once to create and register a controller. For example, `final controller = Get.put(DashboardController());`
3.  **State Declaration**: Inside controllers, reactive variables are declared using `.obs`, e.g., `final isLoading = false.obs;` or `final products = <ProductModel>[].obs;`.
4.  **UI Consumption**: In the UI, `Obx(() => ...)` widgets are used to wrap parts of the UI that need to react to state changes. For instance, `Obx(() { if (controller.isLoading.value) return LoadingWidget(); ... })`.
5.  **State Modification**: Methods within controllers modify these `.obs` variables (e.g., `isLoading.value = true;`, `products.assignAll(newProducts);`).
6.  **Automatic Updates**: When an `.obs` variable changes, `Obx` widgets observing it automatically rebuild, updating the UI efficiently.

### Key Components

#### 1. Main Application Entry ([[main.dart]])

-   `StrongerMusclesDashboard` is the root widget, configured with `GetMaterialApp` for GetX integration.
-   It sets up light and dark themes using `AppTheme`.
-   The `initialRoute` is `/dashboard`, pointing to `MainNavigationScreen`.
-   `MainNavigationScreen` handles the overall layout, including `Sidebar` (for desktop) or `MyBottomNavigationBar` (for mobile) and a dynamic content area using `IndexedStack` to switch between different screens based on the `NavigationController`'s `selectedIndex`.

#### 2. Authentication Flow ([[auth_controller.dart]], [[auth_service.dart]], [[login_screen.dart]], [[signup_screen.dart]])

-   `AuthService`: Manages user authentication state, including saving/retrieving JWT tokens and user data using `GetStorage`. It provides methods for `login`, `signup`, and `logout`.
-   `AuthController`: A `GetxController` that orchestrates the authentication process. It handles text field controllers, observable states (`isLoading`, `isPasswordVisible`, `rememberMe`, `acceptTerms`), validation logic, and calls `AuthService` for actual API interaction. It also manages error messages specific to authentication.
-   `LoginScreen` and `SignupScreen`: Provide the UI for user authentication, interacting with `AuthController` to handle user input and display feedback.

#### 3. API Communication ([[api_service.dart]], [[api_config.dart]])

-   `ApiService`: A central class for all HTTP requests to the backend. It wraps `http` package calls, adds authentication headers using `AuthService`, handles network timeouts, and standard API error responses (e.g., redirecting on 401).
-   `ApiConfig`: Defines static string constants for all API endpoints, ensuring consistency and ease of management. `ApiConfigController` (a `GetxController`) allows dynamic configuration of the base URL (e.g., for local development, emulator, or production).

#### 4. Data Models (e.g., [[product.dart]], [[category.dart]], [[order.dart]])

-   These classes define the structure of data entities. They typically include:
    -   Properties for each field (e.g., `id`, `name`, `price`).
    -   `fromJson` factory constructor for converting JSON data to Dart objects.
    -   `toJson` method for converting Dart objects back to JSON.
    -   Enums like `OrderStatus` and `PaymentStatus` for clear state representation.

#### 5. Data Repositories (e.g., [[product_repository.dart]], [[category_repository.dart]])

-   Classes like `ProductRepository`, `CategoryRepository`, `OrderRepository`, and `UserRepository` provide an abstract interface for accessing and managing data.
-   They encapsulate the logic of interacting with the `ApiService` and transforming raw API responses into application-specific models. This layer separates data access logic from business logic in controllers.

#### 6. Dashboard and Analytics ([[dashboard_controller.dart]], [[dashboard_screen.dart]], various chart widgets)

-   `DashboardController`: Fetches and aggregates data from `OrderRepository`, `ProductRepository`, `CategoryRepository`, and `UserRepository` to calculate key performance indicators (KPIs) and populate charts. It manages `isLoading`, `isConnected`, `errorMessage`, and various statistical `Rx` variables.
-   `DashboardScreen`: The main overview screen that displays animated statistic cards (`AnimatedStatCard`), recent orders (`RecentOrdersList`), categories (`CategoriesGrid`), and various charts (`PieChartWidget`, `BarChartWidget`, `LineChartWidget`) to visualize business data. It reacts to changes in `DashboardController`'s observable data.

#### 7. Product Management ([[products_controller.dart]], [[products_screen.dart]], [[ProductFormPage.dart]])

-   `ProductsController`: Manages the lifecycle of product data. It fetches, filters, searches, adds, updates, and deletes products. It also handles image uploads using `ApiService`.
-   `ProductsScreen`: Displays a searchable and filterable list of products. It leverages `ProductListItem` (which uses `ProductCard`) and `ProductsCategoriesScreen` for filtering.
-   `ProductFormPage` (and `ProductFormSheet`): Provides a detailed form for creating or editing product information, including image galleries (`ImageGalleryEditor`), flavor and size selectors (`ProductFlavorSelector`, `ProductSizeSelector`), and availability toggles (`AvailabilitySwitch`).

#### 8. Category Management ([[categories_controller.dart]], [[categories_screen.dart]], [[CategoryFormSheet.dart]])

-   `CategoriesController`: Similar to `ProductsController`, it handles CRUD operations, searching, and state for product categories.
-   `CategoriesScreen`: Displays categories either as a list (`CategoryListItem`) or a grid (`CategoryGridItem`), offering edit and delete functionalities.
-   `CategoryFormSheet`: A modal bottom sheet for adding or editing category details.

#### 9. Order Management ([[orders_controller.dart]], [[orders_screen.dart]], [[order_details_screen.dart]])

-   `OrdersController`: Manages fetching, searching, and filtering of customer orders.
-   `OrdersScreen`: Displays a list of orders (`AnimatedOrderListTile`) with filtering by status and search capabilities.
-   `OrderDetailsScreen`: Shows a comprehensive view of a single order, including customer info, shipping address, ordered items, and payment status.

#### 10. User Management ([[users_controller.dart]], [[users_screen.dart]])

-   `UsersController`: Fetches and manages a list of registered users, providing search and display capabilities.
-   `UsersScreen`: Displays user statistics and a detailed list of users, using expandable tiles to show more information like addresses and order counts.

### Obsidian Wiki-Links

-   [[api_config.dart]]
-   [[responsive.dart]]
-   [[theme.dart]]
-   [[animated_category_card.dart]]
-   [[animated_order_list_tile.dart]]
-   [[animated_stat_card.dart]]
-   [[bar_chart_widget.dart]]
-   [[line_chart_widget.dart]]
-   [[pie_chart_widget.dart]]
-   [[categories_grid.dart]]
-   [[recent_orders_list.dart]]
-   [[confirm_dialog.dart]]
-   [[connection_status.dart]]
-   [[enhanced_error_widget.dart]]
-   [[enhanced_loading_widget.dart]]
-   [[no_data_screen.dart]]
-   [[image_gallery_editor.dart]]
-   [[order_status_chart.dart]]
-   [[enhanced_status_chart.dart]]
-   [[section_header.dart]]
-   [[statistic_card.dart]]
-   [[status_badge.dart]]
-   [[auth_controller.dart]]
-   [[categories_controller.dart]]
-   [[dashboard_controller.dart]]
-   [[orders_controller.dart]]
-   [[products_controller.dart]]
-   [[users_controller.dart]]
-   [[cart_item.dart]]
-   [[category.dart]]
-   [[dashboard_user_model.dart]]
-   [[flavors_model.dart]]
-   [[order.dart]]
-   [[product.dart]]
-   [[user-address.dart]]
-   [[user.dart]]
-   [[category_repository.dart]]
-   [[order_repository.dart]]
-   [[product_repository.dart]]
-   [[user_repository.dart]]
-   [[login_screen.dart]]
-   [[signup_screen.dart]]
-   [[categories_screen.dart]]
-   [[CategoryFormSheet.dart]]
-   [[CategoryGridItem.dart]]
-   [[CategoryListItem.dart]]
-   [[dashboard_screen.dart]]
-   [[PeriodButton.dart]]
-   [[buildAppBar.dart]]
-   [[buildDashboardScreenPeriodSelector.dart]]
-   [[buildDashboardScreenStatsCards.dart]]
-   [[orders_screen.dart]]
-   [[order_details_screen.dart]]
-   [[products_screen.dart]]
-   [[ProductFormPage.dart]]
-   [[ProductFormSheet.dart]]
-   [[CategoryItem.dart]]
-   [[FlavorMultiSelect.dart]]
-   [[ProductCard.dart]]
-   [[ProductListItem.dart]]
-   [[ProductsCategoriesScreen.dart]]
-   [[availability_switch.dart]]
-   [[buildActionButtons.dart]]
-   [[buildModernDropdown.dart]]
-   [[buildModernTextField.dart]]
-   [[product_size_selector.dart]]
-   [[settings_screen.dart]]
-   [[users_screen.dart]]
-   [[drawer.dart]]
-   [[my_bottomnavigationbar.dart]]
-   [[sidebar.dart]]
-   [[api_service.dart]]
-   [[auth_service.dart]]
-   [[GetX]]