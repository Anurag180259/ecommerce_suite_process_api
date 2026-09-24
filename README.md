# E-Commerce Integration Suite — Process API

## Overview

The **Process API** is the orchestration layer of the E-Commerce Integration Suite. It sits between the Experience API and the System APIs, handling all business logic, data orchestration, and integration with the Database API and Mock Payment API. It is never called directly by external consumers — all requests flow through the Experience API.

**Key responsibilities:**
- Business logic execution (JWT generation, password hashing, ownership checks, stock validation)
- Orchestration of calls to the Database API and Mock Payment API
- Payment status resolution via a background scheduler
- Data transformation and aggregation before returning responses to the Experience API

---

## Architecture

The Process API is the second layer in the API-led connectivity model:

```
    AI Agent (via MCP Server)
              ↓
    Experience API Layer
              ↓
    Process API (This Layer)
              ↓
    System APIs (Database API, Mock Payment API)
              ↓
    Data Layer (MySQL Database on Aiven Cloud)
```

**Role of Process API:**
- Receives requests from the Experience API and orchestrates the necessary System API calls
- Handles all business rules — ownership validation, stock checks, payment processing, JWT generation
- Returns structured responses back to the Experience API for final transformation and delivery

For the complete system architecture, deployment topology, and AI integration details, refer to the [main project repository](https://github.com/Anurag180259/ecommerce_suite).

---

## Prerequisites

- **Mule Runtime**: 4.4.0 or later
- **Java**: JDK 11 or higher
- **MuleSoft Connector Packs**:
  - HTTP Connector
  - APIKit
- **Database API**: Must be running and accessible at the configured host and port
- **Mock Payment API**: Must be running and accessible at the configured host and port

---

## Setup & Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Anurag180259/ecommerce_suite_process_api.git
cd ecommerce_suite_process_api
```

### 2. Configure Properties

Create a `configuration.properties` file in `src/main/resources/`:

1. Right-click on `src/main/resources/` folder
2. Select **New** → **File**
3. Name it `configuration.properties`
4. Copy the content from [`configuration.example.properties`](./src/main/resources/configuration.example.properties)
5. Update the values according to your environment

Refer to [`configuration.example.properties`](./src/main/resources/configuration.example.properties) for the complete structure and required properties.

The following properties must be configured:

```properties
# Process API Listener
http.port=PROCESS_API_HTTP_PORT_NUMBER

# Database API Connection
http.database.host=DATABASE_API_HOST_NAME
http.database.port=DATABASE_API_HTTP_PORT_NUMBER

# Mock Payment API Connection
http.payment.host=PAYMENT_API_HOST_NAME
http.payment.port=PAYMENT_API_HTTP_PORT_NUMBER

# JWT Secret Key (must match the Experience API)
jwt.secretKey=YOUR_SECRET_KEY
```

> **Important:** `jwt.secretKey` must be identical across both the Experience API and the Process API. The Experience API decodes tokens using this key, and the Process API generates them using the same key.

### 3. Build the Project

In Anypoint Studio:

1. Right-click on the project in **Package Explorer**
2. Select **Run As** → **Mule Application**

The project will automatically build and deploy to the embedded Mule Runtime.

### 4. Verify Deployment

Once deployed, the API will be running. Access the API Console:

```
http://localhost:<port>/console/
```

Replace `<port>` with your configured `http.port` value.

---

## API Endpoints

### Quick Reference

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/process/auth/login` | Validate credentials and generate JWT |
| `POST` | `/process/auth/register` | Register a new user and generate JWT |
| `POST` | `/process/admin/setup` | Set up the admin account |
| `POST` | `/process/stores` | Create a new store |
| `PATCH` | `/process/stores/{storeId}/verification` | Update store verification status |
| `GET` | `/process/stores/admin` | Get stores by verification status |
| `GET` | `/process/stores/seller` | Get all stores for a seller |
| `POST` | `/process/stores/{storeId}/products` | Add a new product to a store |
| `GET` | `/process/products` | Get products by filters |
| `GET` | `/process/products/{productId}` | Get a product by ID |
| `PATCH` | `/process/products/{productId}` | Update product details |
| `PATCH` | `/process/products/{productId}/restock` | Restock a product |
| `POST` | `/process/carts` | Add a product to cart |
| `GET` | `/process/carts` | Get cart items for a user |
| `PATCH` | `/process/carts/{cartItemId}/quantity` | Update cart item quantity |
| `DELETE` | `/process/carts/{cartItemId}` | Remove a specific item from cart |
| `DELETE` | `/process/carts` | Clear entire cart |
| `POST` | `/process/orders` | Place an order |
| `GET` | `/process/orders/buyer` | Get all orders for a buyer |
| `GET` | `/process/orders/seller` | Get all orders for a seller |
| `GET` | `/process/orders/{orderId}` | Get a specific order by ID |
| `PATCH` | `/process/orders/{orderId}/cancellation` | Cancel an order |

> This API is not intended to be called directly. All requests should flow through the Experience API.

---

### Authentication

#### Login
```
POST /process/auth/login
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "jwtToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": "B-a7d2c1"
}
```

**Business Logic:**
- Fetches user by email from the Database API
- Verifies password using BCrypt
- Generates a signed JWT with `userId`, `role`, `iss`, `aud`, `iat`, and `exp` claims
- Token expiry is set to 1 hour (3600 seconds)

**Error Responses:**
- `404 Not Found` — Email not found
- `401 Unauthorized` — Password mismatch

---

#### Register
```
POST /process/auth/register
Content-Type: application/json
```

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "newuser@example.com",
  "password": "securePassword123",
  "city": "Pune",
  "role": "buyer",
  "phoneNo": "9876543210"
}
```

**Response (200 OK):**
```json
{
  "jwtToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": "B-a7d2c1"
}
```

**Business Logic:**
- Generates a `userId` with role-based prefix — `B-` for buyer, `S-` for seller, followed by 6 hex characters from `uuid()`
- Hashes the password using BCrypt with a cost factor of 12
- Capitalizes `firstName` and `lastName`
- Stores the user in the Database API
- Generates and returns a signed JWT

**Error Responses:**
- `409 Conflict` — Email already registered

---

### Admin Setup

#### Setup Admin Account
```
POST /process/admin/setup
Content-Type: application/json
```

**Request Body:**
```json
{
  "firstName": "Admin",
  "lastName": "User",
  "email": "admin@example.com",
  "password": "adminPassword123",
  "city": "Pune",
  "phoneNo": "9876543210"
}
```

**Response (200 OK):**
```json
{
  "userId": "A-1c3d2f"
}
```

**Business Logic:**
- Checks if an admin already exists by querying users with `role=admin`
- If one exists, raises an error — only one admin is allowed
- Generates a `userId` with prefix `A-` followed by 6 hex characters from `uuid()`
- Hashes the password using BCrypt and stores the admin in the Database API

**Error Responses:**
- `403 Forbidden` — Admin already registered

---

### Store Management

#### Create Store
```
POST /process/stores
Content-Type: application/json
```

**Request Body:**
```json
{
  "storeName": "Electronics Plus",
  "gstin": "18AABCR5055K1Z0",
  "accountNumber": "1234567890123456",
  "accountHolderName": "John Doe",
  "userId": "S-78a3c4"
}
```

**Response (200 OK):**
```json
{
  "storeId": "ST-4f2a1c"
}
```

**Business Logic:**
- Generates a `storeId` with prefix `ST-` followed by 6 hex characters from `uuid()`
- Stores the store record in the Database API

**Error Responses:**
- `409 Conflict` — Store name already registered

---

#### Update Store Verification Status
```
PATCH /process/stores/{storeId}/verification
Content-Type: application/json
```

**Request Body:**
```json
{
  "status": "verified"
}
```

**Business Logic:**
- Passes the verification status to the Database API which updates the `storeData` table using the `updateStoreData` stored procedure

---

#### Get Stores by Verification Status (Admin)
```
GET /process/stores/admin?verificationStatus=verified
```

**Query Parameters:**
- `verificationStatus` (required): `verified`, `unverified`, or `rejected`

**Response (200 OK):**
```json
[
  {
    "storeId": "ST-4f2a1c",
    "storeName": "Electronics Plus",
    "gstin": "18AABCR5055K1Z0",
    "accountNumber": "1234567890123456",
    "accountHolderName": "John Doe",
    "userId": "S-78a3c4",
    "verificationStatus": "verified"
  }
]
```

---

#### Get Stores for a Seller
```
GET /process/stores/seller
x-user-id: S-78a3c4
```

**Response (200 OK):**
```json
[
  {
    "storeId": "ST-4f2a1c",
    "storeName": "Electronics Plus",
    "gstin": "18AABCR5055K1Z0",
    "accountNumber": "1234567890123456",
    "accountHolderName": "John Doe",
    "verificationStatus": "verified",
    "userId": "S-78a3c4"
  }
]
```

> The seller's `userId` is passed via the `x-user-id` header by the Experience API.

---

### Product Management

#### Add Product to Store
```
POST /process/stores/{storeId}/products
x-user-id: S-78a3c4
Content-Type: application/json
```

**Request Body:**
```json
{
  "productName": "Wireless Headphones",
  "brand": "AudioTech",
  "category": "Electronics",
  "subCategory": "Audio",
  "price": 5299,
  "stock": 50,
  "details": "High-quality wireless headphones with noise cancellation"
}
```

**Response (200 OK):**
```json
{
  "productId": "P-a4b231"
}
```

**Business Logic:**
- Fetches the store by `storeId` from the Database API
- Verifies the `userId` in `x-user-id` header matches the store owner — raises `APP:FORBIDDEN` with reason `notAllowed` if not
- Verifies the store `verificationStatus` is `verified` — raises `APP:UNVERIFIED` with reason `storeNotVerified` if not
- Generates a `productId` with prefix `P-` followed by 6 hex characters from `uuid()`
- Inserts the product into the Database API

**Error Responses:**
- `403 Forbidden` — Store belongs to a different seller (`reason: notAllowed`)
- `403 Forbidden` — Store is not verified (`reason: storeNotVerified`)

---

#### Get Products by Filters
```
GET /process/products?brand=AudioTech&category=Electronics
```

**Query Parameters (all optional):**
- `brand`, `category`, `subCategory`, `maxPrice`, `minPrice`, `inStock`, `minRatings`, `storeName`

**Response (200 OK):**
```json
[
  {
    "storeName": "Electronics Plus",
    "productName": "Wireless Headphones",
    "brand": "AudioTech",
    "productId": "P-a4b231",
    "storeId": "ST-4f2a1c",
    "stock": 50,
    "price": 5299,
    "category": "Electronics",
    "subCategory": "Audio",
    "rating": 0.0,
    "noOfReviews": 0,
    "details": "High-quality wireless headphones with noise cancellation"
  }
]
```

---

#### Get Product by ID
```
GET /process/products/{productId}
```

**Response (200 OK):**
```json
{
  "productId": "P-a4b231",
  "productName": "Wireless Headphones",
  "brand": "AudioTech",
  "price": 5299,
  "stock": 50,
  "category": "Electronics",
  "subCategory": "Audio",
  "rating": 0.0,
  "noOfReviews": 0,
  "details": "High-quality wireless headphones with noise cancellation",
  "storeId": "ST-4f2a1c"
}
```

---

#### Update Product Details
```
PATCH /process/products/{productId}
x-user-id: S-78a3c4
Content-Type: application/json
```

**Request Body:**
```json
{
  "productName": "Premium Wireless Headphones",
  "price": 5999,
  "details": "Updated description"
}
```

**Response (200 OK):**
```json
{
  "affectedRows": 1
}
```

**Business Logic:**
- Runs an ownership check via the `ownershipCheckForProductId` sub-flow before updating
- Fetches the product to get its `storeId`, then fetches the store to verify the `userId` matches `x-user-id`

---

#### Restock Product
```
PATCH /process/products/{productId}/restock
x-user-id: S-78a3c4
Content-Type: application/json
```

**Request Body:**
```json
{
  "quantity": 100
}
```

**Response (200 OK):**
```json
{
  "affectedRows": 1
}
```

**Business Logic:**
- Runs the same ownership check as update product
- The `updateProducts` stored procedure adds the provided quantity to the existing stock (`stock = stock + quantity`)

---

### Cart Management

#### Add Product to Cart
```
POST /process/carts
x-user-id: B-a7d2c1
Content-Type: application/json
```

**Request Body:**
```json
{
  "productId": "P-a4b231",
  "quantity": 2
}
```

**Response (200 OK) — New item:**
```json
{
  "value": "created",
  "cartItemId": "CT-a3f9b2"
}
```

**Response (200 OK) — Product already in cart:**
```json
{
  "value": "updated",
  "cartItemId": ["CT-a3f9b2"]
}
```

**Business Logic:**
- Checks if the product already exists in the user's cart
- If yes, updates the quantity of the existing cart item and returns `value: "updated"`
- If no, generates a `cartItemId` with prefix `CT-` followed by 6 hex characters from `uuid()`, inserts the new item, and returns `value: "created"`

---

#### Get Cart Items
```
GET /process/carts
x-user-id: B-a7d2c1
```

**Response (200 OK):**
```json
{
  "cart": [
    {
      "cartItemId": "CT-a3f9b2",
      "userId": "B-a7d2c1",
      "productId": "P-a4b231",
      "quantity": 2
    }
  ],
  "productDetails": [
    {
      "productId": "P-a4b231",
      "productName": "Wireless Headphones",
      "brand": "AudioTech",
      "price": 5299,
      "stock": 50,
      "category": "Electronics",
      "subCategory": "Audio",
      "rating": 0.0,
      "noOfReviews": 0,
      "details": "High-quality wireless headphones with noise cancellation",
      "storeId": "ST-4f2a1c"
    }
  ]
}
```

**Business Logic:**
- Fetches all cart items for the user from the Database API
- For each cart item, fetches full product details from the Database API
- Returns both the cart items and product details as separate arrays for the Experience API to merge

---

#### Update Cart Item Quantity
```
PATCH /process/carts/{cartItemId}/quantity
x-user-id: B-a7d2c1
Content-Type: application/json
```

**Request Body:**
```json
{
  "quantity": 5
}
```

**Response (200 OK):**
```json
{
  "affectedRows": 1
}
```

**Business Logic:**
- Runs an ownership check via the `ownershipCheckForCartItemId` sub-flow
- Verifies the `userId` on the cart item matches `x-user-id`
- Updates the cart item quantity in the Database API

---

#### Remove Cart Item
```
DELETE /process/carts/{cartItemId}
x-user-id: B-a7d2c1
```

**Response (200 OK):**
```json
{
  "affectedRows": 1
}
```

**Business Logic:**
- Runs ownership check before deletion
- Deletes the specific cart item from the Database API

---

#### Clear Entire Cart
```
DELETE /process/carts
x-user-id: B-a7d2c1
```

**Response (200 OK):**
```json
{
  "affectedRows": 1
}
```

**Business Logic:**
- Deletes all cart items for the user by passing `userId` to the `deleteCartByFilters` stored procedure in the Database API

---

### Order Management

#### Place Order
```
POST /process/orders
x-user-id: B-a7d2c1
Content-Type: application/json
```

**Request Body:**
```json
{
  "deliveryPincode": "100001",
  "product": {
    "productId": "P-a4b231",
    "quantity": 1
  }
}
```

**Response (200 OK):**
```json
{
  "deliveryTime": "P4D",
  "orderId": "OD-7c4e1a",
  "totalOrderValue": 5299,
  "orderStatus": "confirmed",
  "userId": "B-a7d2c1",
  "transactionId": "PAY-3f1a2b4c",
  "paymentStatus": "success",
  "deliveryPincode": "100001",
  "isCart": false,
  "listOfItems": [
    {
      "orderItemId": "OI-3a1b2c",
      "productId": "P-a4b231",
      "quantity": 1,
      "orderId": "OD-7c4e1a",
      "priceAtPurchase": 5299,
      "productName": "Wireless Headphones"
    }
  ]
}
```

**Business Logic:**
- Validates the `deliveryPincode` and maps it to a delivery period:
  - `100001` → `P4D` (4 days)
  - `100002` → `P6D` (6 days)
  - `100003` → `P7D` (7 days)
  - Any other pincode → `APP:NOT_DELIVERABLE`
- If `product` is omitted in the request, fetches all items from the user's cart — raises `APP:EMPTY_CART` if cart is empty
- For each item, validates stock availability — raises `APP:NOT_IN_STOCK` if stock is insufficient
- Calculates the total order value
- Calls the Mock Payment API with a `mock_payment_token` and the total amount
- Raises `APP:PAYMENT_FAILED` if payment status is `failure`
- Generates an `orderId` with prefix `OD-` followed by 6 hex characters from `uuid()`
- Generates an `orderItemId` with prefix `OI-` followed by 6 hex characters from `uuid()` for each item
- Persists the order, order items, and decrements stock in a single database transaction
- If the order was placed from the cart (`isCart: true`), clears the cart after successful order placement

**Error Responses:**
- `422 Unprocessable Entity` — Not in stock (`reason: notInStock`)
- `422 Unprocessable Entity` — Payment failed (`reason: paymentFailed`)
- `422 Unprocessable Entity` — Delivery not available (`reason: notDeliverable`)
- `422 Unprocessable Entity` — Cart is empty (`reason: cartIsEmpty`)
- `404 Not Found` — Product not found (`reason: productNotFound`)

---

#### Get Orders (Buyer)
```
GET /process/orders/buyer
x-user-id: B-a7d2c1
```

**Response (200 OK):**
```json
[
  {
    "orderId": "OD-7c4e1a",
    "orderDate": "2026-09-07",
    "orderStatus": "confirmed",
    "totalOrderValue": 5299,
    "userId": "B-a7d2c1",
    "deliveryPincode": "100001",
    "expDeliveryDate": "2026-09-11",
    "transactionId": "PAY-3f1a2b4c",
    "paymentStatus": "success",
    "orderItems": [
      {
        "orderItemId": "OI-3a1b2c",
        "orderId": "OD-7c4e1a",
        "productId": "P-a4b231",
        "storeId": "ST-4f2a1c",
        "priceAtPurchase": 5299,
        "quantity": 1,
        "productName": "Wireless Headphones"
      }
    ]
  }
]
```

**Business Logic:**
- Fetches all orders for the user from the Database API
- For each order, fetches order items, then fetches product name for each item
- Returns the full enriched order list

---

#### Get Orders (Seller)
```
GET /process/orders/seller
x-user-id: S-78a3c4
```

**Response (200 OK):**
```json
[
  {
    "storeId": "ST-4f2a1c",
    "storeName": "Electronics Plus",
    "gstin": "18AABCR5055K1Z0",
    "accountNumber": "1234567890123456",
    "accountHolderName": "John Doe",
    "verificationStatus": "verified",
    "userId": "S-78a3c4",
    "orderItems": [
      {
        "orderItemId": "OI-3a1b2c",
        "orderId": "OD-7c4e1a",
        "productId": "P-a4b231",
        "storeId": "ST-4f2a1c",
        "priceAtPurchase": 5299,
        "quantity": 1,
        "productName": "Wireless Headphones"
      }
    ]
  }
]
```

**Business Logic:**
- Fetches all stores owned by the seller from the Database API
- For each store, fetches order items by `storeId`, then fetches product name for each item
- Returns the full enriched store + order items list

---

#### Get Order by ID
```
GET /process/orders/{orderId}
x-user-id: B-a7d2c1
```

**Response (200 OK):**
```json
{
  "orderId": "OD-7c4e1a",
  "orderDate": "2026-09-07",
  "orderStatus": "confirmed",
  "totalOrderValue": 5299,
  "userId": "B-a7d2c1",
  "deliveryPincode": "100001",
  "expDeliveryDate": "2026-09-11",
  "transactionId": "PAY-3f1a2b4c",
  "paymentStatus": "success",
  "orderItems": [
    {
      "orderItemId": "OI-3a1b2c",
      "orderId": "OD-7c4e1a",
      "productId": "P-a4b231",
      "storeId": "ST-4f2a1c",
      "priceAtPurchase": 5299,
      "quantity": 1
    }
  ]
}
```

**Business Logic:**
- Runs an ownership check — verifies the `userId` on the order matches `x-user-id`
- Fetches order items by `orderId`
- Returns the full order with items

---

#### Cancel Order
```
PATCH /process/orders/{orderId}/cancellation
x-user-id: B-a7d2c1
```

**Response (200 OK):**
```json
{
  "affectedRows": 1
}
```

**Business Logic:**
- Runs ownership check on the order
- Calls the Mock Payment API to reverse the payment (`PATCH /payment/{transactionId}/reversePayment`)
- Updates the order status to `cancelled` and payment status to `reversed` in the Database API

---

## Background Jobs

### Payment Status Updater

The Process API includes a Quartz scheduler that runs every minute to resolve orders with a `pending` payment status.

**How it works:**
1. Fetches all orders where `paymentStatus = pending` from the Database API
2. For each order, calls the Mock Payment API to check the current payment status (`GET /payment/{transactionId}/status`)
3. Updates the order's `paymentStatus` and `orderStatus` in the Database API based on the response

**Payment Status Resolution:**
- `success` → `orderStatus` updated to `confirmed`, `paymentStatus` updated to `success`
- `pending` → no change

> This scheduler runs automatically on application startup and does not require any manual intervention. It exists because the Mock Payment API uses a round-robin mechanism that can return `pending` as a payment outcome, simulating real-world async payment flows.

---

## Sub-flows

The Process API uses reusable sub-flows for common validation logic:

**`ownershipCheckForProductId`**
- Fetches the product by `productId` to get its `storeId`
- Fetches the store by `storeId` to get its `userId`
- Raises `APP:FORBIDDEN` if the store's `userId` does not match the `x-user-id` header

**`ownershipCheckForCartItemId`**
- Fetches the cart item by `cartItemId`
- Raises `APP:FORBIDDEN` if the cart item's `userId` does not match the `x-user-id` header

**`ownerShipCheckForOrderId`**
- Fetches the order by `orderId`
- Raises `APP:NOT_FOUND` if the order does not exist
- Raises `APP:FORBIDDEN` if the order's `userId` does not match the `x-user-id` header

---

## Error Handling

| Status Code | Description |
|---|---|
| `200 OK` | Successful request |
| `400 Bad Request` | Invalid request format or missing required fields |
| `401 Unauthorized` | Password mismatch |
| `403 Forbidden` | Ownership check failed or admin already registered |
| `404 Not Found` | Resource not found |
| `405 Method Not Allowed` | HTTP method not supported |
| `406 Not Acceptable` | Content type not acceptable |
| `409 Conflict` | Duplicate resource (email, store name) |
| `415 Unsupported Media Type` | Request body media type not supported |
| `422 Unprocessable Entity` | Business rule violation (stock, payment, delivery, empty cart) |
| `500 Internal Server Error` | Unexpected server error |
| `501 Not Implemented` | Feature not yet implemented |

**Error Response Format:**
```json
{
  "message": "Descriptive error message"
}
```

---

## Logging

The Process API logs key events at `INFO` level:

- Incoming requests (endpoint, operation)
- Calls to the Database API and Mock Payment API
- Business logic decisions (stock checks, ownership validation, payment outcomes)
- Errors and exceptions

Logs are output to the Mule Runtime console and can be redirected to a file via Mule configuration.

---

## Deployment

1. Right-click on the project in **Package Explorer**
2. Select **Run As** → **Mule Application**
3. The embedded Mule Runtime will start and deploy the application
4. Access the API Console at `http://localhost:<http.port>/console/`

---

## Troubleshooting

### Database API Connection Failed
- **Error:** "Connection refused" or "Host unreachable"
- **Solution:** Ensure the Database API is running and `http.database.host` and `http.database.port` are correctly configured

### Mock Payment API Connection Failed
- **Error:** "Connection refused" or "Host unreachable"
- **Solution:** Ensure the Mock Payment API is running and `http.payment.host` and `http.payment.port` are correctly configured

### JWT Secret Key Mismatch
- **Error:** JWT tokens generated by the Process API are rejected by the Experience API
- **Solution:** Ensure `jwt.secretKey` is identical in both the Process API and Experience API `configuration.properties` files

### Order Always Has Pending Payment
- **Note:** This is expected behavior — the Mock Payment API uses round-robin to return `success`, `failure`, or `pending`. Pending payments are resolved automatically by the background scheduler within one minute.

### Ownership Check Failure
- **Error:** `APP:FORBIDDEN` on product, cart, or order operations
- **Solution:** Ensure the `x-user-id` header passed by the Experience API matches the owner of the resource being accessed

---

## Related Documentation

- **RAML Specification:** [`ecommercesuiteprocessapi.raml`](./src/main/resources/api)
- **API Console:** Available at `/console/` path after deployment
- **Main Project Repository:** [ecommerce_suite](https://github.com/Anurag180259/ecommerce_suite) — Contains overall architecture, deployment guide, and project scope

---

## Support

For issues, questions, or contributions, please refer to the main project repository.

---

**Last Updated:** September 2026
**Version:** 1.0
**Maintained by:** Anurag Ninave
