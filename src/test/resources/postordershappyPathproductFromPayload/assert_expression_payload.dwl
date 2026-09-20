%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "deliveryTime": "P4D",
  "orderId": "OD-ff4165",
  "totalOrderValue": 180000,
  "orderStatus": "pending",
  "userId": "B-467884",
  "transactionId": "PAY-ec1b7472",
  "paymentStatus": "pending",
  "deliveryPincode": "100001",
  "isCart": false,
  "listOfItems": [
    {
      "orderItemId": "OI-5299b0",
      "productId": "P-a8fb8c",
      "quantity": 3,
      "orderId": "OD-ff4165",
      "priceAtPurchase": 60000,
      "productName": "S25"
    }
  ]
})