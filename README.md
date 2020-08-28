# iOS-GatewayAPISMS
[GatewayAPI](https://gatewayapi.com) is a SMS service provider. This repository will guide to use Gateway SMS service in your iOS project using Swift

## General Usage
To send sms, an instance of ``GatewayAPIWrapper`` class along the provided token by [GatewayAPI](https://gatewayapi.com)
``` swift
let gatewayApi = GatewayAPIWrapper.init(token: "Insert Your Token")
```
Add Sender, Receivers, Message to that created instance
``` swift
gatewayApi.sender = "Sender Name"
gatewayApi.recipients = ["Phone Number"]
gatewayApi.message = "Message to be sent"
```
For sending the SMS, call the following method of created instance
``` swift
gatewayApi.sendSMS()
```
## Checking Status
Being acknowledged about the sent messsage, there is a delegate called ``GatewayAPIWrapperDelegate``. To conform this delegate two method must be implemented. One will be called on success, other will be in error

For Success
``` swift
func sendSMSResponse(result: [String : Any]) {
  print(result)
}
```
For Error
``` swift
func sendSMSError(error: String) {
  print(error.description)
}
```
---
For more information read their [documentation](https://gatewayapi.com/docs/)
