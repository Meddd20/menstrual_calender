class ApiEndPoints {
  // static final String baseUrl = "https://period-pregnancy.inovasi-digital.my.id";
  static final String baseUrl = "http://10.0.2.2:8000";
  static final String apiUrl = "${baseUrl}/api/";
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String connection = 'connection';
  final String storeFcmToken = 'notifications/token';

  final String login = 'login';
  final String regisUser = 'register/user';
  final String requestVerification = 'requestverification';
  final String verifyCode = 'verifyverification';
  final String resetPassword = 'changepassword';
  final String logOut = 'logout';
  final String checkToken = 'check-token';
  final String profile = 'get-profile';
  final String editProfile = 'update-profile';
  final String getSycData = 'sync-data';
  final String resycData = 'resync-data';
  final String resycPendingData = 'resync-pending-data';
  final String getSycMasterData = 'sync-master-data';
  final String deleteData = 'delete-data';

  final String getAllArticle = 'articles/show-all-articles';
  final String getArticle = 'articles/show-articles';

  final String storePeriod = 'period/store-period';
  final String updatePeriod = 'period/update-period';

  final String storeLog = 'daily-log/update-log';
  final String deleteLog = 'daily-log/delete-log';

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

  final String addPregnancyLog = 'pregnancy/add-pregnancy-log';
  final String deletePregnancyLog = 'pregnancy/delete-pregnancy-log';

  final String addBloodPressure = 'pregnancy/add-blood-pressure';
  final String editBloodPressure = 'pregnancy/edit-blood-pressure';
  final String deleteBloodPressure = 'pregnancy/delete-blood-pressure';

  final String addContractionTimer = 'pregnancy/add-contraction-timer';
  final String deleteContractionTimer = 'pregnancy/delete-contraction-timer';

  final String addKickCounter = 'pregnancy/add-kicks-counter';
  final String addKickCounterData = 'pregnancy/add-kicks-counter-data';
  final String deleteKickCounter = 'pregnancy/delete-kicks-counter';
}
