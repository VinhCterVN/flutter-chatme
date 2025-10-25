# Notifications (FCM) setup and sending

This document explains how to deliver system notifications to users when new chat messages arrive.

1. Overview

-   The app uses `firebase_messaging` to receive push messages and `flutter_local_notifications` to display local notifications when the app is in the foreground.

2. How notifications are triggered
   You have two common options:

-   Cloud Function: Write a Firebase Cloud Function that listens to new message documents in Firestore and calls FCM to send a notification to the recipient's device token.
-   Server: If you run your own backend, send an HTTP POST to FCM v1 API with the appropriate token when a message is created.

3. Cloud Function example (Node.js)

```js
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onMessageCreate = functions.firestore
	.document("conversations/{convId}/messages/{messageId}")
	.onCreate(async (snap, context) => {
		const message = snap.data();
		const recipientToken = message.recipientFcmToken; // you must store tokens per user

		const payload = {
			notification: {
				title: message.senderName,
				body: message.text || "New message",
			},
			data: {
				conversationId: context.params.convId,
			},
		};

		if (!recipientToken) return null;
		return admin.messaging().sendToDevice(recipientToken, payload);
	});
```

4. Client: storing FCM token

-   Call `NotificationService().getFcmToken()` after login and save the token to the user's Firestore document so backend / cloud function can read it.

5. Testing

-   Run the app on a physical device or emulator with Google Play services.
-   Use Firebase Console (Cloud Messaging) to send test messages to a token.

6. Notes & edge cases

-   For iOS, ensure proper APNs setup and upload certificates or use APNs key.
-   Handle token refreshes (listen to `onTokenRefresh`) and update the stored token.
-   For high-volume systems, consider topic subscriptions or server-side fanout.
