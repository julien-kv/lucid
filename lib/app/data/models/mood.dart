enum Mood {
  happy,
  sad,
  angry,
  anxious,
  neutral,
}

extension MoodExtension on Mood {
  String get displayName {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.sad:
        return 'Sad';
      case Mood.angry:
        return 'Angry';
      case Mood.anxious:
        return 'Anxious';
      case Mood.neutral:
        return 'Neutral';
    }
  }

  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.sad:
        return '🙁';
      case Mood.angry:
        return '😠';
      case Mood.anxious:
        return '😰';
      case Mood.neutral:
        return '😐';
    }
  }

  String get icon {
    switch (this) {
      case Mood.happy:
        return 'assets/icons/mood_happy.svg';
      case Mood.sad:
        return 'assets/icons/mood_sad.svg';
      case Mood.angry:
        return 'assets/icons/mood_angry.svg';
      case Mood.anxious:
        return 'assets/icons/mood_anxious.svg';
      case Mood.neutral:
        return 'assets/icons/mood_neutral.svg';
    }
  }
}
