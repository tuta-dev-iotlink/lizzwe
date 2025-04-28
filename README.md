# lizzwe

> **Lightweight, Intuitive, Zero-overhead State Manager for Flutter**

---

## ✨ Giới thiệu
**lizzwe** là một giải pháp quản lý state cực kỳ nhẹ, đơn giản và hiệu quả cho Flutter.  
Không phụ thuộc vào các package phức tạp, chỉ sử dụng thuần Dart và Flutter để đảm bảo tốc độ, dễ học và dễ mở rộng.

**Với lizzwe, bạn có thể:**
- Theo dõi và cập nhật state dễ dàng.
- Chỉ rebuild đúng phần UI cần thiết.
- Lắng nghe thay đổi state mà không cần rebuild widget.
- Quản lý nhiều state phức tạp (nested object, array, map).
- Hỗ trợ cập nhật state đồng bộ và bất đồng bộ.

---

## 🚀 Tính năng chính
- `Observable<T>`: Quản lý và notify giá trị thay đổi.
- `StateBuilder<T>`: Rebuild UI theo Observable.
- `StateListener<T>`: Lắng nghe thay đổi mà không rebuild UI.
- `MultipleStateListener`: Lắng nghe nhiều Observable cùng lúc.
- `StateStore`: Tổ chức và quản lý nhiều Observable.

---

## 🛠️ Cài đặt

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  lizzwe: ^0.0.1
```

Sau đó chạy:
```bash
flutter pub get
```

---

## 📚 Hướng dẫn sử dụng

### 1. Tạo Observable
```dart
final counter = Observable<int>(0);
```

### 2. Sử dụng StateBuilder
```dart
StateBuilder(
  observable: counter,
  builder: (context, value) => Text('Count: $value'),
)
```

### 3. Sử dụng StateListener
```dart
StateListener(
  observable: counter,
  listener: (value) => print('Count changed to: $value'),
  child: YourWidget(),
)
```

### 4. Sử dụng StateStore
```dart
final store = StateStore();
final counter = store.create('counter', 0);
```

---

## 📝 Ví dụ

Xem thêm ví dụ trong thư mục `example/`.

---

## 🤝 Đóng góp

Mọi đóng góp đều được hoan nghênh! Vui lòng đọc [CONTRIBUTING.md](CONTRIBUTING.md) để biết thêm chi tiết.

---

## 📄 Giấy phép

MIT License - xem [LICENSE](LICENSE) để biết thêm chi tiết.
