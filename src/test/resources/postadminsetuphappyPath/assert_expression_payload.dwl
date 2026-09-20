%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "firstName": "Anurag",
  "lastName": "Ninave",
  "password": "\$2a\$12\$383irD4q4dPgZsMG.E2Dwe98/id33eEFQp3ZpQTfgY7hSfK75dZZa",
  "city": "Jaipur",
  "email": "anuragninave@gmail.com",
  "phoneNo": "9404079128",
  "role": "admin",
  "userId": "A-877f34"
})