class Ticket {
  final int? id;
  final String? ticketId;
  final int? userId;
  final int? orderId;

  final String? category;
  final String? subCategory;
  final String? priority;
  final String? status;
  final String? sentiment;

  final String? description;

  final String? assignedTo;
  final String? assignedTeam;
  final double? aiConfidence;
  final String? aiStatus;
  final String? aiDecision;
  final String? resolution;

  Ticket({
    this.id,
    this.ticketId,
    this.userId,
    this.orderId,
    this.category,
    this.subCategory,
    this.priority,
    this.status,
    this.sentiment,
    this.description,
    this.assignedTo,
    this.assignedTeam,
    this.aiConfidence,
    this.aiStatus,
    this.aiDecision,
    this.resolution,
  });

  // JSON to Dart Object
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: (json['id'] as num?)?.toInt(),
      ticketId: json['ticketId'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      orderId: (json['orderId'] as num?)?.toInt(),

      category: json['category'] as String?,
      subCategory: json['subCategory'] as String?,
      priority: json['priority'] as String?,
      status: json['status'] as String?,
      sentiment: json['sentiment'] as String?,

      description: json['description'] as String?,

      assignedTo: json['assignedTo'] as String?,
      assignedTeam: json['assignedTeam'] as String?,
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble(),
      aiStatus: json['aiStatus'] as String?,
      aiDecision: json['aiDecision'] as String?,
      resolution: json['resolution'] as String?,
    );
  }

  // Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'userId': userId,
      'orderId': orderId,
      'category': category,
      'subCategory': subCategory,
      'priority': priority,
      'status': status,
      'sentiment': sentiment,
      'description': description,
      'assignedTo': assignedTo,
      'assignedTeam': assignedTeam,
      'aiConfidence': aiConfidence,
      'aiStatus': aiStatus,
      'aiDecision': aiDecision,
      'resolution': resolution,
    };
  }
}
