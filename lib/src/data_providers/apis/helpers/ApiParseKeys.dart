class ApiParseKeys {
  static const String ID = "id";
  static const String ERROR_MESSAGE = "errMsg";
  static const String ERROR_CODE = "errCode";



  //-------------- GET FIELDS OF STUDY -----------------


  static const String NAME_AR = "nameAr";
  static const String NAME_EN = "nameEn";
  static const String DESCRIPTION_EN = "descriptionEn";
  static const String DESCRIPTION_AR = "descriptionAr";
  static const String FIELD_OF_STUDY_ID = "id";
  static const String USER_FIELD_OF_STUDY_ID = "fieldOfStudyID";

 //-------------- LOGIN ----------------------------------

  static const String USER_TOKEN = "token";
  static const String USER_DATA = "userData";
  static const String USER_FULL_NAME = "fullName";
  static const String USER_MAIL = "email";
  static const String USER_AGE = "age";
  static const String USER_BIRTHDAY = "birthDate";
  static const String USER_PROFILE_IMAGE = "profileImagePath";
  static const String USER_GENDER = "gender";
  static const String USER_FIELD_OF_STUDY = "fieldOfStudyID";
  static const String USER_EDUCATION = "education";
  static const String USER_MOBILE = "mobile";
  static const String USER_TYPE = "userType";
  static const String USER_COVER_IMAGE = "coverImagePath";


  //------------------------LOAD POSTS -----------------------------------

  static const String POSTS_DATA = "data";
  static const String POST_OWNER_ID = "userID";
  static const String POST_OWNER_NAME = "fullName";
  static const String POST_OWNER_IMAGE = "profileImagePath";
  static const String POST_USER_INTERACTION = "interactionTypeID";


  static const String POST_BODY = "text";
  static const String POST_NUMBER_OF_LIKES = "noOfLikes";

  static const String POST_NUMBER_OF_COMMENTS = "noOfComments";
  static const String POST_NUMBER_OF_OBJECTIONS = "noOfObjection";
  static const String POST_NUMBER_OF_SHARES = "noOfShares";
  static const String POST_SHARE_DESCRIPTION = "sahreDescription";
  static const String POST_ATTACHMENTS = "postAttachments";
  static const String POST_SINGLE_ATTACHMENT_PATH = "postAttachmentPath";
  static const String POST_ID = "id";
  static const String POST_TYPE = "techStatusID";
  static const String POST_COMMENTS = "postComments";


  //-------------------- GET ALL COURSES----------------------------------------



  static const String COURSE_ID = "id";
  static const String COURSE_TEACHER_NAME = "teacherName";
  static const String COURSE_NAME_AR = "nameAr";
  static const String COURSE_NAME_EN = "nameEn";
  static const String COURSE_TITLE_AR = "subjectAr";
  static const String COURSE_TITLE_EN = "subjectEn";
  static const String COURSE_GRADE = "grade";
  static const String COURSE_SUBSCRIPTION_PRICE = "price";
  static const String COURSE_IMAGE_PATH = "courseImagePath";

  static const String COURSE_OUTCOMES_EN = "learningOutcomesEn";
  static const String COURSE_OUTCOMES_AR = "learningOutcomesAr";
  static const String COURSE_END_DATE = "endDate";
  static const String COURSE_START_DATE = "startDate";
  static const String COURSE_LESSONS = "lessons";
  static const String COURSE_ALREADY_SUBSCRIBED = "isSubscibedBy";




  //----------------- GET SYSTEM GRADES --------------------------------------------

  static const String GRADE_NAME_AR = "nameAr";
  static const String GRADE_NAME_EN = "nameEn";

  //---------------- GET QUIZ QUESTION ---------------------------------------------

  static const String QUESTION = "questionBody";
  static const String ANSWER_NO = "choose";
  static const String CORRECT_ANSWER_INDEX = "rightChoose";





  //----------------- LESSON KEYS ------------------------------------------------
  static const String LESSON_ID = "id";
  static const String LESSON_NAME_AR = "lessonNameAr";
  static const String LESSON_NAME_EN = "lessonNameEn";
  static const String LESSON_DOC = "pdfPath";
  static const String LESSON_LEARNING_AR = "learningOutcomesAr";
  static const String LESSON_LEARNING_EN = "learningOutcomesEn";
  static const String LESSON_FLASH_CARD = "flashCard";
  static const String QUIZ_MARK = "mark";
  static const String LESSON_QUIZ_QUESTIONS = "lessonQuestions";
  static const String LESSON_VIDEO_URL = "videoPath";
  static const String LESSON_COMPLETED = "isCompleted";



  //-------------------- LOAD OTHER USER ---------------------------------------------

  static const String IS_FOLLOWER = "isFollowedBy";
  static const String COMMENT_OWNER_IMAGE = "profileImagePath";
  static const String COMMENT_OWNER_NAME = "fullName";
  static const String COMMENT_TEXT_BODY = "comment";
  static const String COMMENT_NUMBER_OF_LIKES = "noOfLikes";
  static const String COMMENT_OWNER_ID = "userCommentID";
  static const String COMMENT_TYPE = "interactionCommentTypeID";





}