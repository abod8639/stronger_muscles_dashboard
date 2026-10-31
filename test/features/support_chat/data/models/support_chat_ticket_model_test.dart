import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/data/models/support_chat_ticket_model.dart';

void main() {
  test('SupportChatTicketModel parses real Laravel JSON accurately', () {
    final json = {
      "id": 4,
      "ticket_number": "SM-TFAZBKKK",
      "user_id": 2,
      "name": "Abood",
      "email": "abot8639@gmail.com",
      "phone": null,
      "subject": "يتم صح مكتب لو",
      "category": "مشكلة تقنية في التطبيق",
      "priority": "normal",
      "status": "waiting_user",
      "order_id": null,
      "admin_id": null,
      "assigned_admin": null,
      "user": {
        "id": 2,
        "name": "Abood",
        "email": "abot8639@gmail.com",
        "phone_number": "01065055102",
        "photo_url": "https://lh3.googleusercontent.com/a/sample"
      },
      "order": null,
      "messages": [
        {
          "id": 11,
          "ticket_id": 4,
          "sender_type": "user",
          "sender_id": 2,
          "sender_name": "Abood",
          "message": "ربع سو معبرا ملفات تنقلها عايز ر",
          "attachments": [],
          "is_internal_note": false,
          "is_read": true,
          "created_at": "2026-10-29T05:20:28+00:00"
        },
        {
          "id": 59,
          "ticket_id": 4,
          "sender_type": "admin",
          "sender_id": 2,
          "sender_name": "ddadmin",
          "message": "تم تحويل البلاغ",
          "attachments": [],
          "is_internal_note": false,
          "is_read": false,
          "created_at": "2026-10-31T11:07:48+00:00"
        }
      ],
      "last_reply_at": "2026-10-31T11:07:48+00:00",
      "resolved_at": null,
      "closed_at": null,
      "created_at": "2026-10-29T05:20:28+00:00",
      "updated_at": "2026-10-31T11:07:48+00:00"
    };

    final model = SupportChatTicketModel.fromJson(json);
    expect(model.id, 4);
    expect(model.messages.length, 2);
    expect(model.messages.first.message, "ربع سو معبرا ملفات تنقلها عايز ر");

    final entity = model.toEntity();
    expect(entity.messages.length, 2);
    expect(entity.messages.first.senderName, "Abood");
  });
}

