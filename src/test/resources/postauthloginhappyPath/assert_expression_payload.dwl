%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "jwtToken": "eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJ1c2VySWQiOiAiUy1mYzE0OTMiLCJpc3MiOiAiZWNvbW1lcmNlX3N1aXRlX2JhY2tlbmQiLCJhdWQiOiAiZWNvbW1lcmNlX2FwaSIsImlhdCI6IDE3ODkwMTg0NDIsImV4cCI6IDE3ODkwMjIwNDIsInJvbGUiOiAic2VsbGVyIn0.HlJL621daNbaryxbvkCHh8uMN1-e92S5gGDnQzN5o0o",
  "userId": "S-fc1493"
})