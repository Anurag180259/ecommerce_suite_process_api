%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "cart": [
    {
      "cartItemId": "CT-2abc12",
      "userId": "B-467884",
      "productId": "P-a8fb8c",
      "quantity": 3
    }
  ],
  "productDetails": [
    {
      "productName": "S25",
      "productId": "P-a8fb8c",
      "storeId": "ST-0143d3",
      "brand": "Samsung",
      "stock": 83,
      "price": 60000,
      "category": "Electronics",
      "subCategory": "Smartphone",
      "rating": 0,
      "noOfReviews": 0,
      "details": "Best Flagship phone in a compact size"
    }
  ]
})