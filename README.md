# 🏡 My DreamHome – Flutter Property App

A Flutter-based real estate application that allows users to browse, search, filter, and list properties with full authentication and session management.

---

## 📌 Project Overview

**My DreamHome** is a mobile application built with Flutter that connects to a live backend API to:

- Authenticate users
- Display property listings
- Filter/search properties
- View property details
- Upload new properties
- Contact property agents

---

## 🔐 Demo Credentials

Use the following credentials to test the application:

- **Email:** [rurblist@gmail.com](mailto:rurblist@gmail.com)
- **Password:** Omozuas123\*

> ⚠️ Note: These credentials are for testing purposes only.

## 🌐 Backend API

Base URL:

```
https://rurblist-backend.onrender.com/api
```

---

## 📱 Features Implemented

### 🔐 Authentication

- Login with email & password
- JWT-based authentication
- Automatic token refresh
- Session persistence

---

### 🏠 Property Listing

- Fetch properties from API
- Display in scrollable list
- Pull-to-refresh support
- Loading shimmer UI

---

### 🔍 Search & Filtering

Supports:

- Search text
- Min / Max price
- Bedrooms
- Bathrooms
- Location (city/state)

---

### 📄 Property Details

- Image gallery (carousel)
- Cached images
- Property price & agent fee
- Location details
- Description with "Read More"
- Amenities display
- Owner/Agent info
- Contact agent (phone call)

---

### ➕ Add Property

- Upload property with images
- Multipart form submission
- Add:
  - Title
  - Description
  - Price
  - Bedrooms / Bathrooms
  - Location
  - Amenities

---

## 🧱 Architecture & Tech Stack

### 🔧 Technologies Used

- **Flutter**
- **Dart**
- **Riverpod** → State Management
- **Dio** → API Communication
- **GetIt** → Dependency Injection
- **CachedNetworkImage** → Image caching
- **JWT Decoder** → Token validation
- **Shimmer** → Loading UI

---

### 🧠 State Management (Riverpod)

Used for:

- Property list
- Property detail
- Filters
- Authentication state

Example:

```dart
final properties = ref.watch(propertyListProvider);
```

---

### 🌐 API Handling

Implemented using **Dio** with:

- Interceptors
- Automatic token injection
- Auto refresh on `401`
- Retry failed requests

---

### 🔐 Token Management

Flow:

1. User logs in → receives `accessToken` & `refreshToken`
2. Access token is attached to every request
3. If request returns `401`:
   - Refresh token is used
   - New tokens are stored
   - Original request is retried

4. If refresh fails → user is logged out

---

### 🖼️ Image Caching

Images are cached using a custom cache manager:

```dart
cacheManager: cacheService.manager
```

Config:

- Cache duration: 3 days
- Max objects: 500

Improves:

- Performance
- Reduced network usage

---

## 🚀 Setup Instructions

### 1. Clone Repository

```bash
git clone https://github.com/your-username/dreamhome.git
cd dreamhome
```

---

### 2. Install Dependencies

```bash
flutter pub get
```

---

### 3. Run Application

```bash
flutter run
```

---

## ⚠️ Important Notes

- For Android Emulator:
  - Use production API (already configured)

- Ensure internet connection is available

---

## 📁 Project Structure

```
lib/
 ├── app/
 │   ├── apis/                # API models & services
 │   ├── services/            # Core services (auth, session, navigation)
 │   ├── views/               # UI screens
 │   ├── common/              # Shared widgets/styles
 │   ├── utils/               # Helpers
 │   └── providers/           # Riverpod providers
```

---

## 🧪 Challenges & Solutions

### 1. Token Refresh Not Triggering

**Issue:**

- Refresh endpoint not called on `401`

**Solution:**

- Implemented Dio interceptor
- Handled `401` in `onResponse`
- Added retry logic

---

### 2. Emulator Networking

**Issue:**

- `localhost` not working

**Solution:**

- Used hosted backend API

---

### 3. Multipart Upload Errors

**Issue:**

- Image upload failing

**Solution:**

- Removed forced `Content-Type`
- Used `FormData` properly

---

### 4. API Response Structure

**Issue:**

- Tokens nested inside `data`

**Solution:**

- Updated parsing:

```dart
response['data']['accessToken']
```

---

## 🔥 Improvements (Future Work)

- Favorites / Wishlist
- Pagination (infinite scroll)
- Map integration
- Push notifications
- Offline caching

---

## 👤 Author

Developed by **[Omozua Judah]**

---

## 📄 Submission Notes

This project demonstrates:

- Clean architecture
- Proper state management
- Scalable API handling
- Real-world authentication flow
- Production-ready patterns

---

## ✅ Status

✔ Completed
✔ Fully functional
✔ Connected to live backend
✔ Ready for review
