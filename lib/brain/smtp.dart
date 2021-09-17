import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void mail(email, orderid,type) async {
  // Use the SmtpServer class to configure an SMTP server:
  String username = "info@stackx.online";
  final smtpServer = SmtpServer("stackx.online",
      ignoreBadCertificate: true,
      username: username,
      password: "StackX@123",
      allowInsecure: true);

  // Create our message.
  final message = Message()
    ..from = Address(username, "StackX-AstroDrishti")
    ..recipients.add(email)
    ..subject = 'Your order is placed with id $orderid'
    ..text =
        "We are happy to inform you that we have recieved your order with Order-ID $orderid.\nYour data will be sent to our astrologers for analysis and we will be updating the report in orders section in 1-2 days.\nThank You,\nFor choosing us and being so awesome all at once.\nAstrology is our prime service & to make it even better for you, we have the best team of astrologers with us.\nYou can depend on us for anything.\nWishing you all the success.";

  final order_up = Message()
    ..from = Address(username, "StackX-AstroDrishti")
    ..recipients.add('StackX1617@gmail.com')
    ..subject = 'New Order With with id $orderid'
    ..text =
        "Type of order is $type";

  try {
    final sendReport = await send(message, smtpServer);
    await send(order_up, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print(e);
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
