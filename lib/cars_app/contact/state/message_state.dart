import 'package:equatable/equatable.dart';

enum MessageStatus { initial, loading, success, failure }

class MessageState extends Equatable {
  final MessageStatus status;
  final String? successMessage;
  final String? errorMessage;

  const MessageState({
    required this.status,
    this.successMessage,
    this.errorMessage,
  });

  factory MessageState.initial() => const MessageState(status: MessageStatus.initial);

  MessageState copyWith({
    MessageStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return MessageState(
      status: status ?? this.status,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
