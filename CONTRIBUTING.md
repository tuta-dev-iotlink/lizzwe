# Hướng dẫn đóng góp

Cảm ơn bạn đã quan tâm đến việc đóng góp cho lizzwe! Dưới đây là một số hướng dẫn để giúp bạn bắt đầu.

## Quy trình đóng góp

1. Fork repository
2. Tạo branch mới cho feature/fix của bạn
3. Commit các thay đổi
4. Push lên branch của bạn
5. Tạo Pull Request

## Quy tắc code

- Tuân thủ [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Viết test cho mọi tính năng mới
- Cập nhật tài liệu khi cần thiết
- Giữ code đơn giản và dễ hiểu

## Cấu trúc dự án

```
lib/
  ├── src/
  │   ├── core/      # Core functionality
  │   └── widgets/   # Flutter widgets
  └── lizzwe.dart    # Main library file
test/                # Unit tests
example/             # Example app
```

## Chạy test

```bash
flutter test
```

## Tạo tài liệu

```bash
dart doc
```

## Báo cáo lỗi

Khi báo cáo lỗi, vui lòng cung cấp:
- Phiên bản Flutter và Dart
- Mô tả chi tiết về lỗi
- Các bước để tái tạo lỗi
- Mã nguồn ví dụ nếu có thể

## Yêu cầu tính năng

Khi yêu cầu tính năng mới, vui lòng:
- Mô tả chi tiết tính năng
- Giải thích lý do tại sao nó hữu ích
- Cung cấp ví dụ về cách sử dụng

## Liên hệ

Nếu bạn có bất kỳ câu hỏi nào, vui lòng mở issue trên GitHub. 