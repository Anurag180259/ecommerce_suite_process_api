%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo([
  {
    "storeName": "Deepika Fashion",
    "productName": "Ethnic saree:908",
    "brand": "Mohey",
    "productId": "P-042dfb",
    "storeId": "ST-179ca4",
    "stock": 89,
    "price": 5600,
    "category": "Clothes",
    "subCategory": "Saree",
    "rating": 0,
    "noOfReviews": 0,
    "details": "This is a great ethnic saree for festive and weeding season"
  }
])