import 'package:flutter/material.dart';
import 'package:jtitechcamp_day4_chat_app/constants.dart';
import 'package:jtitechcamp_day4_chat_app/models/message.dart';
import 'package:jtitechcamp_day4_chat_app/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> profileCache = {};

  // @override
  // void initState() {
  //   final myUserId = supabase.auth.currentUser!.id;
  //   init();
  //   messageStream = supabase.from('messages').stream(primaryKey: ['id'])
  //       // .order('created_at')
  //       .map((maps) => maps
  //           .map((map) => Message.fromMap(map: map, myUserId: myUserId))
  //           .toList());
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  void initState() {
    final myUserId = supabase.auth.currentUser!.id;
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: myUserId))
            .toList());
    super.initState();
  }

  Future init() async {
    await supabase.from('profiles').select().single();
  }

  Future<void> loadProfileCache(String profileId) async {
    if (profileCache[profileId] != null) {
      return;
    }

    final data =
        await supabase.from('profiles').select().eq('id', profileId).single();

    final profile = Profile.fromMap(data);

    print("PRODILE $profile");

    setState(() {
      profileCache[profileId] = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat "),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                    child: messages.isEmpty
                        ? const Center(
                            child: Text("Start your conversation now :)"),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];

                              loadProfileCache(message.profileId);

                              return ChatBubble(
                                message: message,
                                profile: profileCache[message.profileId],
                              );
                            },
                          )),
                const MessageBar()
              ],
            );
          } else {
            return preLoader;
          }
        },
      ),
    );
  }
}

class MessageBar extends StatefulWidget {
  const MessageBar({super.key});

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade200,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _messageController,
                decoration: InputDecoration(hintText: 'Masukkan pesan disini'),
              ),
            ),
            TextButton(onPressed: submitMessage, child: Text("Send"))
          ],
        ),
      ),
    );
  }

  Future<void> submitMessage() async {
    final myUserId = supabase.auth.currentUser!.id;
    final text = _messageController.text;

    if (text.isEmpty) {
      return;
    }
    _messageController.clear();

    try {
      await supabase
          .from('messages')
          .insert({'profile_id': myUserId, 'content': text});
    } on PostgrestException catch (error) {
      context.showErrorSnackbar(message: error.message);
    } catch (_) {
      context.showErrorSnackbar(message: errorSupabase);
    }
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final Profile? profile;

  const ChatBubble({super.key, required this.message, this.profile});

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
            child: profile == null
                ? preLoader
                : Text(profile!.username.substring(0, 2))),
      const SizedBox(
        width: 12,
      ),
      Flexible(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            color: message.isMine ? Colors.blue : Colors.red,
            borderRadius: BorderRadius.circular(8)),
        child: Text(message.content),
      )),
      Text(format(message.createdAt, locale: 'en_short'))
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
