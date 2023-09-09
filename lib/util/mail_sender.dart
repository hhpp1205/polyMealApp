import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:poly_meal/const/mail.dart';
import 'package:get/get.dart';

class MailSender {

  void sendMail() async {
    Email email = makeEmail();
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      showErrorAlert();
    }
  }

  Email makeEmail() {
    final Email email = Email(
      body: makeEmailBody(),
      subject: '[급식폴리스 문의]',
      recipients: [MAIL_ADDRESS],
      cc : [],
      bcc : [],
      attachmentPaths: [],
      isHTML: false,
    );
    return email;
  }

  String makeEmailBody() {
    String emailBody = "=================\n";
    emailBody += "아래 내용을 함께 보내주시면 큰 도움이 됩니다.\n";
    emailBody += "캠퍼스 : \n";
    emailBody += "OS버전(IOS, Android) : \n";
    emailBody += "기기 : \n";
    emailBody += "=================\n";
    return emailBody;
  }

  void showErrorAlert() {
    Get.dialog(
      AlertDialog(
        content: Text("기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기  어려운 상황입니다. 아래 이메일로 연락주시면 친절하게 답변해드리겠습니다 :)\n" + MAIL_ADDRESS),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}