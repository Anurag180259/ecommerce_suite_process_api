%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "jwtToken": "eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiAiSldUIn0.eyJ1c2VySWQiOiAiUy1mYzE0OTMiLCJpc3MiOiAiZWNvbW1lcmNlX3N1aXRlX2JhY2tlbmQiLCJhdWQiOiAiZWNvbW1lcmNlX2FwaSIsImlhdCI6IDE3ODkwMTg4MzEsImV4cCI6IDE3ODkwMjI0MzEsInJvbGUiOiAic2VsbGVyIn0.Lxl3afiskh6F2MOO23Qlp6nG3PXTDp9IW1zfYvnT5yM",
  "userId": "S-fc1493"
})