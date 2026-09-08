class AuthSession {
  final String token;
  final String refreshToken;
  final String userId;
  final String email;
  final String fullName;
  final String title;
  final List<String> roles;

  AuthSession({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.title,
    required this.roles,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      title: json['title'] ?? 'Ejecutivo Comercial',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class DashboardOverview {
  final String todayFormatted;
  final PortfolioRadar radar;
  final PortfolioHealth health;
  final LuppoFocusInsight focusInsight;
  final CommercialMetrics metrics;
  final DailyGoal todayGoals;
  final int overdueFollowUpsCount;
  final int todayFollowUpsCount;

  DashboardOverview({
    required this.todayFormatted,
    required this.radar,
    required this.health,
    required this.focusInsight,
    required this.metrics,
    required this.todayGoals,
    required this.overdueFollowUpsCount,
    required this.todayFollowUpsCount,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      todayFormatted: json['todayFormatted'] ?? 'Hoy',
      radar: PortfolioRadar.fromJson(json['radar'] ?? {}),
      health: PortfolioHealth.fromJson(json['health'] ?? {}),
      focusInsight: LuppoFocusInsight.fromJson(json['focusInsight'] ?? {}),
      metrics: CommercialMetrics.fromJson(json['metrics'] ?? {}),
      todayGoals: DailyGoal.fromJson(json['todayGoals'] ?? {}),
      overdueFollowUpsCount: (json['overdueFollowUpsCount'] as num?)?.toInt() ?? 0,
      todayFollowUpsCount: (json['todayFollowUpsCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class PortfolioRadar {
  final int kycCount;
  final int activeClientsCount;
  final int aliveCount;
  final int laterCount;
  final double totalQuotedValue;

  PortfolioRadar({
    required this.kycCount,
    required this.activeClientsCount,
    required this.aliveCount,
    required this.laterCount,
    required this.totalQuotedValue,
  });

  factory PortfolioRadar.fromJson(Map<String, dynamic> json) {
    return PortfolioRadar(
      kycCount: (json['kycCount'] as num?)?.toInt() ?? 0,
      activeClientsCount: (json['activeClientsCount'] as num?)?.toInt() ?? 0,
      aliveCount: (json['aliveCount'] as num?)?.toInt() ?? 0,
      laterCount: (json['laterCount'] as num?)?.toInt() ?? 0,
      totalQuotedValue: (json['totalQuotedValue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PortfolioHealth {
  final int score;
  final String title;
  final String description;
  final String statusLevel;

  PortfolioHealth({
    required this.score,
    required this.title,
    required this.description,
    required this.statusLevel,
  });

  factory PortfolioHealth.fromJson(Map<String, dynamic> json) {
    return PortfolioHealth(
      score: (json['score'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? 'Construyendo tu cartera',
      description: json['description'] ?? '',
      statusLevel: json['statusLevel'] ?? 'CONSTRUYENDO',
    );
  }
}

class LuppoFocusInsight {
  final String primaryInsight;
  final String category;
  final String actionLabel;
  final String actionRoute;
  final int priority;

  LuppoFocusInsight({
    required this.primaryInsight,
    required this.category,
    required this.actionLabel,
    required this.actionRoute,
    required this.priority,
  });

  factory LuppoFocusInsight.fromJson(Map<String, dynamic> json) {
    return LuppoFocusInsight(
      primaryInsight: json['primaryInsight'] ?? 'Cada oportunidad merece un próximo paso.',
      category: json['category'] ?? 'SALUD',
      actionLabel: json['actionLabel'] ?? 'Ver cartera',
      actionRoute: json['actionRoute'] ?? '/pipeline',
      priority: (json['priority'] as num?)?.toInt() ?? 3,
    );
  }
}

class CommercialMetrics {
  final double salesToDate;
  final double monthlyGoal;
  final double goalAchievementPercentage;
  final int potentialClosesCount;
  final int wonDealsCount;
  final double remainingAmountForGoal;
  final double commissionEarnedToDate;
  final double totalPotentialCommission;
  final double commissionRate;

  CommercialMetrics({
    required this.salesToDate,
    required this.monthlyGoal,
    required this.goalAchievementPercentage,
    required this.potentialClosesCount,
    required this.wonDealsCount,
    required this.remainingAmountForGoal,
    required this.commissionEarnedToDate,
    required this.totalPotentialCommission,
    required this.commissionRate,
  });

  factory CommercialMetrics.fromJson(Map<String, dynamic> json) {
    return CommercialMetrics(
      salesToDate: (json['salesToDate'] as num?)?.toDouble() ?? 0.0,
      monthlyGoal: (json['monthlyGoal'] as num?)?.toDouble() ?? 10000.0,
      goalAchievementPercentage: (json['goalAchievementPercentage'] as num?)?.toDouble() ?? 0.0,
      potentialClosesCount: (json['potentialClosesCount'] as num?)?.toInt() ?? 0,
      wonDealsCount: (json['wonDealsCount'] as num?)?.toInt() ?? 0,
      remainingAmountForGoal: (json['remainingAmountForGoal'] as num?)?.toDouble() ?? 0.0,
      commissionEarnedToDate: (json['commissionEarnedToDate'] as num?)?.toDouble() ?? 0.0,
      totalPotentialCommission: (json['totalPotentialCommission'] as num?)?.toDouble() ?? 0.0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 10.0,
    );
  }
}

class DailyGoal {
  final String? id;
  final int coldContactsTarget;
  final int coldContactsDone;
  final double coldContactsPercentage;
  final int callsTarget;
  final int callsDone;
  final double callsPercentage;
  final int followUpsTarget;
  final int followUpsDone;
  final double followUpsPercentage;
  final int emailsTarget;
  final int emailsDone;
  final double emailsPercentage;
  final double overallPercentage;
  final bool committed;
  final String statusMessage;

  DailyGoal({
    this.id,
    required this.coldContactsTarget,
    required this.coldContactsDone,
    required this.coldContactsPercentage,
    required this.callsTarget,
    required this.callsDone,
    required this.callsPercentage,
    required this.followUpsTarget,
    required this.followUpsDone,
    required this.followUpsPercentage,
    required this.emailsTarget,
    required this.emailsDone,
    required this.emailsPercentage,
    required this.overallPercentage,
    required this.committed,
    required this.statusMessage,
  });

  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      id: json['id'],
      coldContactsTarget: (json['coldContactsTarget'] as num?)?.toInt() ?? 3,
      coldContactsDone: (json['coldContactsDone'] as num?)?.toInt() ?? 0,
      coldContactsPercentage: (json['coldContactsPercentage'] as num?)?.toDouble() ?? 0.0,
      callsTarget: (json['callsTarget'] as num?)?.toInt() ?? 10,
      callsDone: (json['callsDone'] as num?)?.toInt() ?? 0,
      callsPercentage: (json['callsPercentage'] as num?)?.toDouble() ?? 0.0,
      followUpsTarget: (json['followUpsTarget'] as num?)?.toInt() ?? 8,
      followUpsDone: (json['followUpsDone'] as num?)?.toInt() ?? 0,
      followUpsPercentage: (json['followUpsPercentage'] as num?)?.toDouble() ?? 0.0,
      emailsTarget: (json['emailsTarget'] as num?)?.toInt() ?? 5,
      emailsDone: (json['emailsDone'] as num?)?.toInt() ?? 0,
      emailsPercentage: (json['emailsPercentage'] as num?)?.toDouble() ?? 0.0,
      overallPercentage: (json['overallPercentage'] as num?)?.toDouble() ?? 0.0,
      committed: json['committed'] ?? false,
      statusMessage: json['statusMessage'] ?? 'Define tus metas de hoy',
    );
  }
}

class Prospect {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String? company;
  final String? jobTitle;
  final String productQuoted;
  final double priceQuoted;
  final String proposalChannel;
  final bool activeClient;
  final String quotationMonth;
  final String ctaAction;
  final String? comments;
  final String status;
  final String stageCategory;
  final String? assignedUserName;

  Prospect({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.company,
    this.jobTitle,
    required this.productQuoted,
    required this.priceQuoted,
    required this.proposalChannel,
    required this.activeClient,
    required this.quotationMonth,
    required this.ctaAction,
    this.comments,
    required this.status,
    required this.stageCategory,
    this.assignedUserName,
  });

  factory Prospect.fromJson(Map<String, dynamic> json) {
    return Prospect(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      company: json['company'],
      jobTitle: json['jobTitle'],
      productQuoted: json['productQuoted'] ?? '',
      priceQuoted: (json['priceQuoted'] as num?)?.toDouble() ?? 0.0,
      proposalChannel: json['proposalChannel'] ?? 'Correo',
      activeClient: json['activeClient'] ?? false,
      quotationMonth: json['quotationMonth'] ?? '',
      ctaAction: json['ctaAction'] ?? 'Llamar',
      comments: json['comments'],
      status: json['status'] ?? 'NUEVO',
      stageCategory: json['stageCategory'] ?? 'Viva',
      assignedUserName: json['assignedUserName'],
    );
  }
}

class FollowUpItem {
  final String id;
  final String? prospectId;
  final String? prospectName;
  final String? prospectCompany;
  final String actionType;
  final String description;
  final DateTime scheduledDate;
  final String priority;
  final String status;
  final bool overdue;

  FollowUpItem({
    required this.id,
    this.prospectId,
    this.prospectName,
    this.prospectCompany,
    required this.actionType,
    required this.description,
    required this.scheduledDate,
    required this.priority,
    required this.status,
    required this.overdue,
  });

  factory FollowUpItem.fromJson(Map<String, dynamic> json) {
    return FollowUpItem(
      id: json['id'] ?? '',
      prospectId: json['prospectId'],
      prospectName: json['prospectName'],
      prospectCompany: json['prospectCompany'],
      actionType: json['actionType'] ?? 'Llamar',
      description: json['description'] ?? '',
      scheduledDate: DateTime.tryParse(json['scheduledDate'] ?? '') ?? DateTime.now(),
      priority: json['priority'] ?? 'MEDIA',
      status: json['status'] ?? 'PENDIENTE',
      overdue: json['overdue'] ?? false,
    );
  }
}
