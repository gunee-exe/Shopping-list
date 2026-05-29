# 🛒 Grocer — Flutter Shopping List

A clean, modern grocery list app built with **Flutter** and **Firebase Realtime Database**. Items are stored in the cloud via Firebase's REST API — no SDK required.

---

## 📹 Demo

<p align="center">
  <img src="untitled2.gif" alt="App Demo" width="320"/>
</p>

---

## 📱 Features

- Add grocery items with a name, quantity, and category
- Swipe left to delete with automatic cloud cleanup
- 10 colour-coded categories
- Error handling with a retry button
- Clean dark UI with animated transitions

---

## 🔥 How Firebase Realtime Database Is Used

This app talks to Firebase **entirely over HTTP** using the Firebase REST API — no `firebase_core` or `firebase_database` SDK packages needed. Every operation is a plain HTTP request to your Realtime Database URL.

Appending `.json` to any database node path exposes it via the REST API:

```
https://<your-project>.firebaseio.com/shopping-list.json
```

---

### Reading items — `GET`

On startup, `_loadItems()` fetches all items:

```dart
final response = await http.get(url);
```

Firebase returns a JSON object where each key is an auto-generated ID:

```json
{
  "-NxAbc123": { "name": "Spinach", "quantity": 2, "category": "Vegetables" },
  "-NxDef456": { "name": "Milk",    "quantity": 1, "category": "Dairy"      }
}
```

The app maps each entry back to a `GroceryItem` by resolving the category string against the local `categories` map.

---

### Writing an item — `POST`

On save, `_saveItem()` posts the new item as JSON:

```dart
final response = await http.post(url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'name': _enteredName,
    'quantity': _enteredQuantity,
    'category': _selectedCategory.title,
  }),
);
```

Firebase returns a unique push ID:

```json
{ "name": "-NxGhi789" }
```

This ID is stored on the `GroceryItem` immediately so it can be deleted later without re-fetching.

---

### Deleting an item — `DELETE`

Swiping fires a `DELETE` to the specific item node:

```dart
// targets: shopping-list/<item.id>.json
final response = await http.delete(url);
```

The item is removed from the UI optimistically. If the request fails, it's re-inserted and an error is shown.

---

### Database schema

```
shopping-list/
├── -NxAbc123/
│   ├── name:      "Spinach"
│   ├── quantity:  2
│   └── category:  "Vegetables"
└── -NxDef456/
    ├── name:      "Milk"
    ├── quantity:  1
    └── category:  "Dairy"
```

---

### Security rules

Currently open for development. Lock down before shipping:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

Set these in **Firebase Console → Realtime Database → Rules**.

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── data/
│   └── categories.dart        # Category map with colours
├── models/
│   ├── category.dart          # Category model + enum
│   └── grocery_item.dart      # GroceryItem model
└── widgets/
    ├── grocery_list.dart      # Main screen — GET + DELETE
    └── new_item.dart          # Add screen — POST
```

---

## 🚀 Getting Started

### 1. Clone

```bash
git clone https://github.com/gunee-exe/Shopping-list.git
cd Shopping-list
```

### 2. Set up Firebase

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Realtime Database**
3. Replace the placeholder URLs in `grocery_list.dart` and `new_item.dart` with your own database URL

### 3. Run

```bash
flutter pub get
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
```

No Firebase SDK — just the `http` package.

---

## 📄 License

MIT
