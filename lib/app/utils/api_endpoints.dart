class ApiEndPoints {
  static final String baseUrl = "http://10.0.2.2:8000";
  static final String apiUrl = "${baseUrl}/api/";
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String storeFcmToken = 'notifications/token';

  final String login = 'auth/login';
  final String regisUser = 'auth/register/user';
  final String requestVerification = 'auth/requestverification';
  final String verifyCode = 'auth/verifyverification';
  final String resetPassword = 'auth/changepassword';
  final String logOut = 'auth/logout';
  final String checkToken = 'auth/check-token';
  final String profile = 'auth/get-profile';
  final String editProfile = 'auth/update-profile';
  final String getSycData = 'auth/sync-data';
  final String deleteData = 'auth/delete-data';

  final String getAllArticle = 'articles/show-all-articles';
  final String getArticle = 'articles/show-articles';

  final String storePeriod = 'period/store-period';
  final String updatePeriod = 'period/update-period';

  final String storeLog = 'daily-log/update-log';

  final String storeReminder = 'reminder/store-reminder';
  final String editReminder = 'reminder/edit-reminder';
  final String deleteReminder = 'reminder/delete-reminder';

  final String pregnancyBegin = 'pregnancy/begin';
  final String pregnancyEnded = 'pregnancy/end';
  final String deletePregnancy = 'pregnancy/delete';
  final String editPregnancy = 'pregnancy/edit';

  final String initializeWeightGain = 'pregnancy/init-weight-gain';
  final String weeklyWeightGain = 'pregnancy/weekly-weight-gain';
  final String deleteWeeklyWeightGain = 'pregnancy/delete-weekly-weight-gain';

  final String storeComment = 'comments/create-comments';
  final String likeComment = 'comments/like-comments';
  final String deleteComment = 'comments/delete-comments';

  final String getMasterDataFood = 'master/get-food';
  final String getMasterDataPregnancy = 'master/get-pregnancy';
  final String getMasterDataVaccines = 'master/get-vaccines';
  final String getMasterDataVitamins = 'master/get-vitamins';
}
