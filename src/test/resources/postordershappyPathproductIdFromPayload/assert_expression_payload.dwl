%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "deliveryTime": "P6D",
  "orderId": "OD-1fb88e",
  "totalOrderValue": 180000,
  "orderStatus": "pending",
  "userId": "B-467884",
  "transactionId": "PAY-da78663b",
  "paymentStatus": "pending",
  "deliveryPincode": "100002",
  "isCart": false,
  "listOfItems": [
    {
      "orderItemId": "OI-3ba145",
      "productId": "P-a8fb8c",
      "quantity": 3,
      "orderId": "OD-1fb88e",
      "priceAtPurchase": 60000,
      "productName": "S25"
    }
  ]
})