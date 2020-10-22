class Event {
  String kind;
  String etag;
  DateTime updated;
  String timeZone;
  List<Item> items;

  Event({
    this.kind,
    this.etag,
    this.updated,
    this.timeZone,
    this.items,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        kind: json["kind"],
        etag: json["etag"],
        updated: DateTime.parse(json["updated"]),
        timeZone: json["timeZone"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "updated": updated.toIso8601String(),
        "timeZone": timeZone,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String kind;
  String summary;
  String description;
  String location;
  Creator creator;
  Start start;
  End end;
  Recurrence recurrence;

  Item(
      {this.kind,
      this.summary,
      this.description,
      this.location,
      this.creator,
      this.start,
      this.end,
      this.recurrence});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: json["kind"],
        summary: json["summary"],
        description: json["description"],
        location: json["location"],
        creator: (json["creator"] != null)
            ? Creator.fromJson(json["creator"])
            : null,
        start: (json["start"] != null) ? Start.fromJson(json["start"]) : null,
        end: (json["end"] != null) ? End.fromJson(json["end"]) : null,
        recurrence: (json["recurrence"] != null)
            ? Recurrence.fromJson(json["recurrence"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "summary": summary,
        "description": description,
        "location": location,
        "creator": creator.toJson(),
        "start": start.toJson(),
        "end": end.toJson(),
        "recurrence": recurrence.toJson()
      };
}

class Recurrence {
  var conditions;

  Recurrence(
    this.conditions,
  );

  factory Recurrence.fromJson(json) {
    List valuekeys = ['FREQ', 'UNTIL', 'BYDAY', 'COUNT'];
    Map conditions = {};
    // 文字列から必要なvalueを取り出すために煩雑な文字列操作を行っている
    // "RRULE:FREQ=WEEKLY;WKST=MO;UNTIL=20200930T145959Z;BYDAY=SU,WE"
    // -> {FREQ: WEELLY, UNTIL: 20200930T145959Z, BYDAY:SU,WE}
    valuekeys.forEach((element) {
      if (json.toString().contains(element)) {
        conditions[element] = json
            .toString()
            .split(element)[1]
            .split(';')[0]
            .replaceAll("=", '')
            .replaceAll("]", '');
      }
    });
    return Recurrence(
      conditions,
    );
  }

  Map<String, dynamic> toJson() => {
        "conditions": conditions,
      };
}

class Creator {
  String email;

  Creator({
    this.email,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}

class Start {
  DateTime dateTime;

  Start({
    this.dateTime,
  });

  factory Start.fromJson(Map<String, dynamic> json) {
    String DateToParse;
    if (json["dateTime"] == null) {
      DateToParse = json["date"];
    } else {
      // より良い記述があるかも
      // 2020-08-13T10:00:00+09:00 -> 2020-08-13T10:00:00 に変えてる
      DateToParse = json["dateTime"].toString().substring(0, 19);
    }

    return Start(
      dateTime: DateTime.parse(DateToParse),
    );
  }

  Map<String, dynamic> toJson() => {
        "date": dateTime.toIso8601String(),
      };
}

class End {
  DateTime dateTime;

  End({
    this.dateTime,
  });

  factory End.fromJson(Map<String, dynamic> json) {
    String DateToParse;
    if (json["dateTime"] == null) {
      DateToParse = json["date"];
    } else {
      DateToParse = json["dateTime"].toString().substring(0, 19);
    }
    return End(
      dateTime: DateTime.parse(DateToParse),
    );
  }

  Map<String, dynamic> toJson() => {
        "date": dateTime.toIso8601String(),
      };
}
