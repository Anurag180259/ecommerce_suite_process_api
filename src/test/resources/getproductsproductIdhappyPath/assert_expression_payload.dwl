%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "productName": "S25 ultra",
  "productId": "P-a8fb8c",
  "storeId": "ST-0143d3",
  "brand": "Samsung",
  "stock": 79,
  "price": 125000,
  "category": "Electronics",
  "subCategory": "Smartphone",
  "rating": 0,
  "noOfReviews": 0,
  "details": "This is the best android phone in the market. Comes with a cargable S-Pen"
})