import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_project/cars_app/contact/model/message_request.dart';
import 'package:studio_project/cars_app/contact/model/messages_api.dart';
import 'package:studio_project/cars_app/contact/state/message_state.dart';


class MessageCubit extends Cubit<MessageState> {
  final MessagesApi api;

  MessageCubit({required this.api}) : super(MessageState.initial());

  Future<void> send(MessageRequest dto) async {
    emit(state.copyWith(status: MessageStatus.loading, errorMessage: null, successMessage: null));

    try {
      await api.sendMessage(dto);
      emit(state.copyWith(
        status: MessageStatus.success,
        successMessage: "Message sent successfully ✅",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MessageStatus.failure,
        errorMessage: e.toString().replaceFirst("Exception: ", ""),
      ));
    }
  }

  void reset() {
    emit(MessageState.initial());
  }
}
