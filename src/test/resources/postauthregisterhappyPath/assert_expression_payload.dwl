%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "jwtToken": "eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJ1c2VySWQiOiAiQi0wMDBhZjIiLCJpc3MiOiAiZWNvbW1lcmNlX3N1aXRlX2JhY2tlbmQiLCJhdWQiOiAiZWNvbW1lcmNlX2FwaSIsImlhdCI6IDE3ODkwMjAyOTgsImV4cCI6IDE3ODkwMjM4OTgsInJvbGUiOiAiYnV5ZXIifQ.LksHngGYw3m5roljJjAsicr92O8QQ4aHQN4rCTf636Y",
  "userId": "B-000af2"
})