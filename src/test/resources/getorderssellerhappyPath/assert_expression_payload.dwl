%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo([
  {
    "storeName": "Tom electronics",
    "storeId": "ST-0143d3",
    "accountNumber": "8957946325",
    "verificationStatus": "unverified",
    "gstin": "24GIOCD7483H9Z9",
    "accountHolderName": "Tom Cruise",
    "userId": "S-fc1493",
    "orderItems": [
      {
        "orderItemId": "OI-34d6d4",
        "orderId": "OD-924c55",
        "productId": "P-a8fb8c",
        "storeId": "ST-0143d3",
        "priceAtPurchase": 60000,
        "quantity": 3,
        "productName": "S25"
      },
      {
        "orderItemId": "OI-7aba37",
        "orderId": "OD-f05408",
        "productId": "P-a8fb8c",
        "storeId": "ST-0143d3",
        "priceAtPurchase": 60000,
        "quantity": 2,
        "productName": "S25"
      },
      {
        "orderItemId": "OI-929e13",
        "orderId": "OD-bb3379",
        "productId": "P-a8fb8c",
        "storeId": "ST-0143d3",
        "priceAtPurchase": 60000,
        "quantity": 3,
        "productName": "S25"
      },
      {
        "orderItemId": "OI-94c0d5",
        "orderId": "OD-1fb88e",
        "productId": "P-a8fb8c",
        "storeId": "ST-0143d3",
        "priceAtPurchase": 60000,
        "quantity": 3,
        "productName": "S25"
      },
      {
        "orderItemId": "OI-ad1756",
        "orderId": "OD-006e92",
        "productId": "P-a8fb8c",
        "storeId": "ST-0143d3",
        "priceAtPurchase": 125000,
        "quantity": 1,
        "productName": "S25"
      },
      {
        "orderItemId": "OI-adcb27",
        "orderId": "OD-ff4165",
        "productId": "P-a8fb8c",
        "storeId": "ST-0143d3",
        "priceAtPurchase": 60000,
        "quantity": 3,
        "productName": "S25"
      }
    ]
  }
])