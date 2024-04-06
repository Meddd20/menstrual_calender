class ApiEndPoints {
  static final String baseUrl = "http://10.0.2.2:8000/api/";
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'auth/login';
  final String regisUser = 'auth/register/User';
  final String requestVerification = 'auth/requestverification';
  final String verifyCode = 'auth/verifyverification';
  final String resetPassword = 'auth/changepassword';
  final String logOut = 'auth/logout';

  final String getAllArticle = 'articles/show-all-articles';
  final String getArticle = 'articles/show-articles';

  final String indexPeriodCycle = 'period/index';
  final String dateEvent = 'period/date-event';
  final String storePeriod = 'period/store-period';
  final String updatePeriod = 'period/update-period';

  final String profile = 'show-profile';

  final String logByDate = 'daily-log/read-log-by-date';
  final String logByTags = 'daily-log/read-log-by-tag';
  final String storeLog = 'daily-log/update-log';

  final String storeReminder = 'daily-log/store-reminder';
  final String editReminder = 'daily-log/edit-reminder';
  final String deleteReminder = 'daily-log/delete-reminder';
  final String getReminder = 'daily-log/get-reminder';
  final String getAllReminder = 'daily-log/get-all-reminder';

  final String storePregnancy = 'pregnancy/begin';

  final String storeComment = 'comments/create-comments';
  final String likeComment = 'comments/like-comments';
  final String deleteComment = 'comments/delete-comments';
}
