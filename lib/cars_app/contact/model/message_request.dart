class MessageRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String subject;
  final String message;

  MessageRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "subject": subject,
    "message": message,
  };
}
