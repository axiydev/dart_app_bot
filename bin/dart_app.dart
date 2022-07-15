import 'package:hive/hive.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:uuid/uuid.dart';
import 'consts/consts.dart';
import 'models/book_model.dart';
import 'service/hive_db/database_service.dart';

void main(List<String> arguments) async {
  final Telegram telegram = Telegram(MyConsts.botToken);
  final User user = await telegram.getMe();
  final TeleDart teledart = TeleDart(MyConsts.botToken, Event(user.username!));
  //database setup
  await HiveDB.setupHive();

  final box = Hive.box('data_db');
  //database ga malumot qoshish
  await box.put('data', [for (var item in MyConsts.myBookList) item.toJson]);
  String currentSector = "";

  ///botni ishga tushurdik
  teledart.start();
  print("bot is working.....");

  //menu button
  teledart.setMyCommands([
    BotCommand(command: 'start', description: 'botni ishga tushurish'),
    BotCommand(command: 'info', description: 'bot haqida')
  ]);

  //start komandasi uchun
  teledart.onCommand("start").listen((message) async {
    await message.replyPhoto(
        'https://yandex.uz/images/search?pos=0&from=tabbar&img_url=https%3A%2F%2Fimages.robotworld.sk%2Ftexts%2F1400%2F1468%2Fmip-outdoor.jpg&text=robot&rpt=simage&lr=10335',
        caption: "Simple botga husk kelibsiz",
        reply_markup: ReplyKeyboardMarkup(keyboard: [
          [
            KeyboardButton(text: MyConsts.book),
            KeyboardButton(text: MyConsts.addBook)
          ],
        ]));
  });

  ///xabarni tinglash
  teledart.onMessage().listen((message) async {
    if (message.text is String) {
      switch (message.text) {
        case MyConsts.book:
          currentSector = MyConsts.book;
          print("BOOK " + message.text.toString());

          List lt = await box.get('data');
          print(lt);
          List updatedList = lt.map((e) => Book.fromJson(e)).toList();
          if (updatedList.isNotEmpty) {
            for (Book book in updatedList) {
              await message.replyDocument(book.link);
            }
          }
          break;
        case MyConsts.addBook:
          currentSector = MyConsts.addBook;
          await message.reply('next',
              reply_markup: ReplyKeyboardMarkup(keyboard: [
                [
                  KeyboardButton(text: MyConsts.link),
                  KeyboardButton(text: 'Ortga'),
                ]
              ]));
          break;
        case MyConsts.link:
          currentSector = MyConsts.link;
          await message.reply('Kitob linkini jo`nating');
          break;
        case "Ortga":
          currentSector = "Ortga";
          await message.reply('Ortga',
              reply_markup: ReplyKeyboardMarkup(keyboard: [
                [
                  KeyboardButton(text: MyConsts.book),
                  KeyboardButton(text: MyConsts.addBook)
                ],
              ]));
          break;
        default:
          print(message.text);
      }
    }
  });

  teledart.onUrl().listen((message) async {
    if (currentSector == MyConsts.link) {
      //id for books
      final uuid = Uuid();
      Book myNewBook = Book(
          name: 'unknown',
          author: 'unknown',
          id: uuid.v1(),
          link: message.text!);
      MyConsts.myBookList.add(myNewBook);
      await box.delete('data');
      await box
          .put('data', [for (var item in MyConsts.myBookList) item.toJson]);
      await message.reply('Kitob muvofaqqiyatli qoshildi');
    }
  });

  ///kitoblar service
  // teledart.onCallbackQuery().listen((message) async {
  //   print("BOOK " + message.data.toString());
  //   switch (message.teledartMessage!.text) {
  //     case MyConsts.book:
  //       print("BOOK " + message.data.toString());
  //       break;
  //     case MyConsts.addBook:
  //       print("ADD BOOK +" + message.data.toString());
  //       break;
  //   }
  // });
}
