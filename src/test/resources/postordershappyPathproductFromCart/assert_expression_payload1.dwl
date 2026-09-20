%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "deliveryTime": "P4D",
  "orderId": "OD-f05408",
  "totalOrderValue": 120000,
  "orderStatus": "confirmed",
  "userId": "B-467884",
  "transactionId": "PAY-9a138c1a",
  "paymentStatus": "success",
  "deliveryPincode": "100001",
  "isCart": true,
  "listOfItems": [
    {
      "orderItemId": "OI-cdd684",
      "productId": "P-a8fb8c",
      "quantity": 2,
      "orderId": "OD-f05408",
      "priceAtPurchase": 60000,
      "productName": "S25"
    }
  ]
})