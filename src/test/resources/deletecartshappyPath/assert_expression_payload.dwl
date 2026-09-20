%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo("b3JnLm11bGUuZGIuY29tbW9ucy5zaGFkZWQuaW50ZXJuYWwucmVzdWx0LnN0YXRlbWVudC5DbG9zZWFibGVNYXBAMzIxMzc3NDM=" as Binary {base: "64"})