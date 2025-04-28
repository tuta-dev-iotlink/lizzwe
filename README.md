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
  lizzwe:
    git:
      url: https://github.com/tuta-dev-iotlink/lizzwe.git
      ref: main
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

// Thêm listener
counter.addListener(() {
  print('Counter changed to: ${counter.value}');
});

// Cập nhật giá trị
counter.value = 1; // Listener sẽ được gọi
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
  listener: (previous, current) => print('Count changed from $previous to $current'),
  child: YourWidget(),
)
```

### 4. Sử dụng MultipleStateListener
```dart
MultipleStateListener(
  observables: {
    'counter': counter,
    'name': name,
  },
  listener: (values) {
    print('Counter: ${values['counter']}, Name: ${values['name']}');
  },
  child: YourWidget(),
)
```

### 5. Sử dụng StateStore
```dart
final store = StateStore();

// Tạo Observable
final counter = store.create(0);
final name = store.create('test');

// Lấy Observable
final sameCounter = store.get<int>(0);
```

---

## ⚡ Performance

**lizzwe** được thiết kế để tối ưu hiệu suất:**

- Không sử dụng code generation
- Không có overhead khi không có thay đổi
- Chỉ rebuild widget khi cần thiết
- Hỗ trợ buildWhen để kiểm soát rebuild

---

## 🔄 Migration Guide

### Từ setState
```dart
// Cũ
setState(() {
  _counter++;
});

// Mới
counter.value++;
```

### Từ Provider
```dart
// Cũ
final counter = Provider.of<int>(context);

// Mới
final counter = store.get<int>(0);
```

### Từ Bloc
```dart
// Cũ
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) => Text('${state.count}'),
)

// Mới
StateBuilder(
  observable: counter,
  builder: (context, value) => Text('$value'),
)
```

---

## 📝 Ví dụ

Xem thêm ví dụ trong thư mục `example/` của [GitHub repository](https://github.com/your-username/lizzwe).

---

## 🤝 Đóng góp

Mọi đóng góp đều được hoan nghênh! Vui lòng đọc [CONTRIBUTING.md](CONTRIBUTING.md) để biết thêm chi tiết.

---

## 📄 Giấy phép

MIT License - xem [LICENSE](LICENSE) để biết thêm chi tiết.
