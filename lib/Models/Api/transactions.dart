import 'package:ion_application/Utils/extensions.dart';

class Transaction {
  int? id;
  String? mqttTopic;
  String? duration;
  DateTime? startDate;
  DateTime? date;
  DateTime? time;
  String? mobile;
  String? type;
  String? source;
  String? description;
  double? amount;
  int? sessionId;
  String? voucherId;
  int? lateFees;
  int? bookFees;
  double? kwh;
  int? tariff;
  String? tariffType;
  double? total;

  Transaction(
      {this.id,
        this.date,
        this.time,
        this.mobile,
        this.type,
        this.source,
        this.description,
        this.amount,
        this.sessionId,
        this.voucherId,
        this.duration,
        this.lateFees,
        this.bookFees,
        this.kwh,
        this.tariff,
        this.tariffType,
        this.total,
        this.mqttTopic,
        this.startDate
        });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = DateTime.tryParse(json['timestamp']??"");
    time = DateTime.tryParse(json['timestamp']??"");
    duration = json['duration'];
    startDate = json['startDate']!=null? json['startDate']!.toString().getDateFromString():null;
    mobile = json['mobile'];
    type = json['type'];
    source = json['source'];
    description = json['description'];
    amount = double.tryParse(json['amount'].toString());
    sessionId = json['session_id'];
    voucherId = json['voucher_id'];
    lateFees = json['late_fees'];
    bookFees = json['book_fees'];
    kwh = double.tryParse(json['kwh'].toString());
    tariff =json['tariff']!=null? int.tryParse(json['tariff'].toString()):null;
    tariffType = json['tariff_type'];
    total = double.tryParse(json['total'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mqttTopic'] = this.mqttTopic;
    data['startDate'] = this.startDate;
    data['mobile'] = this.mobile;
    data['type'] = this.type;
    data['source'] = this.source;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['session_id'] = this.sessionId;
    data['voucher_id'] = this.voucherId;
    data['duration'] = this.duration;
    data['late_fees'] = this.lateFees;
    data['book_fees'] = this.bookFees;
    data['kwh'] = this.kwh;
    data['tariff'] = this.tariff;
    data['tariff_type'] = this.tariffType;
    data['total'] = this.total;
    return data;
  }
}