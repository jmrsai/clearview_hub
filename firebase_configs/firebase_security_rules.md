# Firebase Security Rules - ClearView Hub

These rules ensure that user data is strictly protected and only accessible by the authorized medical professional (the authenticated user).

## 1. Cloud Firestore Rules

Go to the [Firestore Rules Console](https://console.firebase.google.com/project/eyeconnect-65sog/firestore/rules) and paste the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if the user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }

    // Helper function to check if the document belongs to the authenticated user
    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    // User profiles
    match /users/{userId} {
      allow read, write: if isAuthenticated() && isOwner(userId);
      
      // Sub-collections (patients, tests)
      match /{allSubcollections=**} {
        allow read, write: if isAuthenticated() && isOwner(userId);
      }
    }

    // Audit Logs (Write-only for users, no update/delete for integrity)
    match /audit_logs/{logId} {
      allow create: if isAuthenticated();
      allow read: if false; // Only accessible via Admin SDK/Console for compliance
    }
  }
}
```

## 2. Firebase Storage Rules

Go to the [Storage Rules Console](https://console.firebase.google.com/project/eyeconnect-65sog/storage/rules) and paste the following:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Clinical reports
    match /reports/{userId}/{reportId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 3. Realtime Database Rules

Go to the [Realtime Database Rules Console](https://console.firebase.google.com/project/eyeconnect-65sog/database/rules) and paste the following:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "presence": {
      "$uid": {
        ".read": "auth != null",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

## 4. App Check (Crucial for Medical Apps)

1. Go to the [App Check Console](https://console.firebase.google.com/project/eyeconnect-65sog/appcheck).
2. Register your Android app with **Play Integrity**.
3. This prevents unauthorized scripts or modified apps from accessing your patient data.
