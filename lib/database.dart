import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:math";

String generateRandomNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(12) + 1;
  return randomNumber.toString();
}

String randomStatus() {
  List<String> user_statuses = [
    "Living life with a touch of chaos and a pinch of serendipity.",
    "Exploring the world one adventure at a time. Wanderlust forever!",
    "Embracing imperfections and finding beauty in the unconventional.",
    "Chasing dreams, coffee in hand, and a smile on my face.",
    "Spreading positivity and sprinkling kindness wherever I go. Join the movement!",
    "Dancing through life, even when the rhythm feels a bit offbeat.",
    "Dreaming big, working hard, and refusing to settle for anything less.",
    "Collecting memories, not things. Living life in full color.",
    "Unleashing creativity, one wild idea at a time. Embrace the madness!",
    "Finding joy in the simplest moments. Gratitude is my daily mantra.",
    "Bridging gaps with laughter and building connections through shared experiences.",
    "Embracing the unknown and writing my own story, one chapter at a time.",
    "Celebrating the beauty of everyday chaos and finding humor in the absurd.",
    "Seeking adventures and creating unforgettable stories with every step.",
    "Spreading smiles and sunshine, because life's too short for frowns.",
    "Breaking free from the ordinary and diving into the extraordinary.",
    "Navigating life's twists and turns with resilience and a touch of humor.",
    "Unapologetically authentic. Embracing quirks and celebrating individuality.",
    "Embracing the journey of self-discovery, one messy yet marvelous step at a time.",
    "Living by the motto: work hard, laugh often, and never forget to dance."
  ];
  var rng = Random();
  String status = user_statuses[rng.nextInt(user_statuses.length)];
  return status;
}

class Database {
  var db = FirebaseFirestore.instance;

  Future<void> createNewUser({
    required String name,
    required String email,
  }) async {
    await db.collection("users").doc(email).set({
      "name": name,
      "email": email,
      "status": randomStatus(),
      "avatar_number": generateRandomNumber(),
    });
  }

  Future<void> updateStatus({
    required String email,
    required String status,
  }) async {
    await db.collection("users").doc(email).update({
      "status": status,
    });
  }

  Future<String> getStatus({
    required String email,
  }) async {
    var data = await db.collection("users").doc(email).get();
    return data["status"];
  }

  Future<String> getName({
    required String email,
  }) async {
    var data = await db.collection("users").doc(email).get();
    return data["name"];
  }

  Future<String> getAvatarNumber({
    required String email,
  }) async {
    var data = await db.collection("users").doc(email).get();
    return data["avatar_number"];
  }
}
