%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "deliveryTime": "P6D",
  "orderId": "OD-924c55",
  "totalOrderValue": 180000,
  "orderStatus": "confirmed",
  "userId": "B-467884",
  "transactionId": "PAY-8454cc94",
  "paymentStatus": "success",
  "deliveryPincode": "100002",
  "isCart": true,
  "listOfItems": [
    {
      "orderItemId": "OI-febbd3",
      "productId": "P-a8fb8c",
      "quantity": 3,
      "orderId": "OD-924c55",
      "priceAtPurchase": 60000,
      "productName": "S25"
    }
  ]
})