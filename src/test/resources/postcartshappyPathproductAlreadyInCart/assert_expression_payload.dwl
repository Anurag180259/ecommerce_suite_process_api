%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "value": "updated",
  "cartItemId": [
    "CT-2abc12"
  ]
})