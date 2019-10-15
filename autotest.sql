/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50727
 Source Host           : localhost:3306
 Source Schema         : autotest

 Target Server Type    : MySQL
 Target Server Version : 50727
 File Encoding         : 65001

 Date: 15/10/2019 16:38:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Browser
-- ----------------------------
DROP TABLE IF EXISTS `Browser`;
CREATE TABLE `Browser`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `installPath` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `driverPath` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Browser
-- ----------------------------
INSERT INTO `Browser` VALUES (1, '谷歌浏览器（无头执行）', 'chrome', NULL, '', '');
INSERT INTO `Browser` VALUES (2, '火狐浏览器（有头调试）', 'firefox', NULL, '', '');
INSERT INTO `Browser` VALUES (3, '手机浏览器', 'android', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for Environment
-- ----------------------------
DROP TABLE IF EXISTS `Environment`;
CREATE TABLE `Environment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` int(11) NULL DEFAULT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `host` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Environment
-- ----------------------------
INSERT INTO `Environment` VALUES (3, 2, '百度', 'https://www.baidu.com', '');

-- ----------------------------
-- Table structure for EnvironmentLogin
-- ----------------------------
DROP TABLE IF EXISTS `EnvironmentLogin`;
CREATE TABLE `EnvironmentLogin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loginId` int(11) NOT NULL,
  `environmentId` int(11) NOT NULL,
  `parameter` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for Result
-- ----------------------------
DROP TABLE IF EXISTS `Result`;
CREATE TABLE `Result`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `taskId` int(11) NULL DEFAULT NULL,
  `projectId` int(11) NOT NULL,
  `testcaseId` int(11) NOT NULL,
  `browsers` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `beforeLogin` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `environments` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `status` int(11) NOT NULL,
  `parameter` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `steps` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkType` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkValue` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `checkText` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `selectText` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 393 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Result
-- ----------------------------
INSERT INTO `Result` VALUES (388, '能否正常打开百度首页', 0, 2, 6, '[\"2\"]', '[]', '[\"3\"]', 30, '[{\"url\": \"https://www.baidu.com\", \"expect\": true}]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}]', 'url', 'https://www.baidu.com/', '2019-10-12 16:23:06.571041', '', '');
INSERT INTO `Result` VALUES (389, '能否正常打开百度首页', 0, 2, 6, '[\"1\"]', '[]', '[\"3\"]', 30, '[{\"url\": \"https://www.baidu.com\", \"expect\": true}]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}]', 'url', 'https://www.baidu.com/', '2019-10-12 16:23:29.459816', '', '');
INSERT INTO `Result` VALUES (390, '验证百度搜索selenium', 0, 2, 79, '[\"2\"]', '[]', '[\"3\"]', 30, '[{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"expect\": true}]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}, {\"keywordId\": \"16\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"location\", \"value\": \"144\"}, {\"isParameter\": true, \"type\": \"string\", \"key\": \"text\", \"value\": \"搜索内容\"}]}, {\"keywordId\": \"14\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"buttom\", \"value\": \"145\"}]}]', 'element', '146', '2019-10-12 16:29:12.848982', 'Selenium - Web Browser Automation', 'all');
INSERT INTO `Result` VALUES (391, '验证百度搜索selenium - 副本', 0, 2, 80, '[\"1\"]', '[]', '[\"3\"]', 30, '[{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"expect\": true}]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}, {\"keywordId\": \"16\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"location\", \"value\": \"144\"}, {\"isParameter\": true, \"type\": \"string\", \"key\": \"text\", \"value\": \"搜索内容\"}]}, {\"keywordId\": \"14\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"buttom\", \"value\": \"145\"}]}]', 'element', '146', '2019-10-12 16:34:05.871617', 'Selenium', 'in');

-- ----------------------------
-- Table structure for SplitResult
-- ----------------------------
DROP TABLE IF EXISTS `SplitResult`;
CREATE TABLE `SplitResult`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environmentId` int(11) NULL DEFAULT NULL,
  `browserId` int(11) NULL DEFAULT NULL,
  `resultId` int(11) NOT NULL,
  `loginStatus` int(11) NOT NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `startTime` datetime(6) NULL DEFAULT NULL,
  `finishTime` datetime(6) NULL DEFAULT NULL,
  `parameter` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expect` tinyint(1) NOT NULL,
  `status` int(11) NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of SplitResult
-- ----------------------------
INSERT INTO `SplitResult` VALUES (25, 3, 2, 387, 0, '2019-10-12 16:20:26.025574', '2019-10-12 16:20:26.194569', '2019-10-12 16:20:35.145384', '{\"url\": \"https://www.baidu.com\", \"expect\": true}', 1, 40, '执行测试用例第1步发生错误，请检查测试用例:(\"\'NoneType\' object has no attribute \'type\'\",)');
INSERT INTO `SplitResult` VALUES (26, 3, 2, 388, 0, '2019-10-12 16:23:06.629042', '2019-10-12 16:23:06.767044', '2019-10-12 16:23:17.798713', '{\"url\": \"https://www.baidu.com\", \"expect\": true}', 1, 30, '测试通过');
INSERT INTO `SplitResult` VALUES (27, 3, 1, 389, 0, '2019-10-12 16:23:29.511821', '2019-10-12 16:23:29.626816', '2019-10-12 16:23:46.464855', '{\"url\": \"https://www.baidu.com\", \"expect\": true}', 1, 30, '测试通过');
INSERT INTO `SplitResult` VALUES (28, 3, 2, 390, 0, '2019-10-12 16:29:12.872981', '2019-10-12 16:29:12.983979', '2019-10-12 16:29:23.899149', '{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"expect\": true}', 1, 30, '测试通过，预期断言值完全匹配实际断言值。');
INSERT INTO `SplitResult` VALUES (29, 3, 1, 391, 0, '2019-10-12 16:34:05.900614', '2019-10-12 16:34:05.999614', '2019-10-12 16:34:22.473060', '{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"expect\": true}', 1, 30, '测试通过，预期断言值包含匹配实际断言值。');
INSERT INTO `SplitResult` VALUES (30, 3, 2, 392, 0, '2019-10-12 16:50:31.737703', '2019-10-12 16:50:31.771703', '2019-10-12 16:50:46.350411', '{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"点击位置\": \"147\", \"点击位置name\": \"搜索结果第二行\", \"expect\": true}', 1, 40, '测试不通过,预期结果为[\"https://baike.baidu.com/item/selenium/18266\"], 但实际结果为[\"https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=selenium&rsv_pq=f5c3691100072bb4&rsv_t=ec7fMz%2FMbZo4KuTGxPySj5vJx0A2YdPgM3xlUXFLfyYJMio1kPm2sPYONYA&rqlang=cn&rsv_enter=0&rsv_dl=tb&rsv_sug3=8&inputT=339&rsv_sug4=339\"]');
INSERT INTO `SplitResult` VALUES (31, 3, 2, 392, 0, '2019-10-12 16:50:31.744708', '2019-10-12 16:50:31.783714', '2019-10-12 16:50:45.487978', '{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"点击位置\": \"148\", \"点击位置name\": \"搜索结果第三行\", \"expect\": true}', 1, 40, '测试不通过,预期结果为[\"https://baike.baidu.com/item/selenium/18266\"], 但实际结果为[\"https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=selenium&rsv_pq=d00154c30004cfb2&rsv_t=2a36HlFda%2Bw8wEt%2BHhxM8XG5FolwKxt%2BHyzb09aimaIt63mOdCjQaUD7qCg&rqlang=cn&rsv_enter=0&rsv_dl=tb&rsv_sug3=8&inputT=344&rsv_sug4=344\"]');
INSERT INTO `SplitResult` VALUES (32, 3, 2, 392, 0, '2019-10-15 15:36:10.264188', '2019-10-15 15:36:10.405185', '2019-10-15 15:36:20.879879', '{\"url\": \"https://www.baidu.com\", \"expect\": true}', 1, 30, '测试通过');

-- ----------------------------
-- Table structure for Task
-- ----------------------------
DROP TABLE IF EXISTS `Task`;
CREATE TABLE `Task`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `testcases` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `browsers` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `status` int(11) NULL DEFAULT NULL,
  `timing` int(11) NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add crontab', 7, 'add_crontabschedule');
INSERT INTO `auth_permission` VALUES (26, 'Can change crontab', 7, 'change_crontabschedule');
INSERT INTO `auth_permission` VALUES (27, 'Can delete crontab', 7, 'delete_crontabschedule');
INSERT INTO `auth_permission` VALUES (28, 'Can view crontab', 7, 'view_crontabschedule');
INSERT INTO `auth_permission` VALUES (29, 'Can add interval', 8, 'add_intervalschedule');
INSERT INTO `auth_permission` VALUES (30, 'Can change interval', 8, 'change_intervalschedule');
INSERT INTO `auth_permission` VALUES (31, 'Can delete interval', 8, 'delete_intervalschedule');
INSERT INTO `auth_permission` VALUES (32, 'Can view interval', 8, 'view_intervalschedule');
INSERT INTO `auth_permission` VALUES (33, 'Can add periodic task', 9, 'add_periodictask');
INSERT INTO `auth_permission` VALUES (34, 'Can change periodic task', 9, 'change_periodictask');
INSERT INTO `auth_permission` VALUES (35, 'Can delete periodic task', 9, 'delete_periodictask');
INSERT INTO `auth_permission` VALUES (36, 'Can view periodic task', 9, 'view_periodictask');
INSERT INTO `auth_permission` VALUES (37, 'Can add periodic tasks', 10, 'add_periodictasks');
INSERT INTO `auth_permission` VALUES (38, 'Can change periodic tasks', 10, 'change_periodictasks');
INSERT INTO `auth_permission` VALUES (39, 'Can delete periodic tasks', 10, 'delete_periodictasks');
INSERT INTO `auth_permission` VALUES (40, 'Can view periodic tasks', 10, 'view_periodictasks');
INSERT INTO `auth_permission` VALUES (41, 'Can add task state', 11, 'add_taskmeta');
INSERT INTO `auth_permission` VALUES (42, 'Can change task state', 11, 'change_taskmeta');
INSERT INTO `auth_permission` VALUES (43, 'Can delete task state', 11, 'delete_taskmeta');
INSERT INTO `auth_permission` VALUES (44, 'Can view task state', 11, 'view_taskmeta');
INSERT INTO `auth_permission` VALUES (45, 'Can add saved group result', 12, 'add_tasksetmeta');
INSERT INTO `auth_permission` VALUES (46, 'Can change saved group result', 12, 'change_tasksetmeta');
INSERT INTO `auth_permission` VALUES (47, 'Can delete saved group result', 12, 'delete_tasksetmeta');
INSERT INTO `auth_permission` VALUES (48, 'Can view saved group result', 12, 'view_tasksetmeta');
INSERT INTO `auth_permission` VALUES (49, 'Can add task', 13, 'add_taskstate');
INSERT INTO `auth_permission` VALUES (50, 'Can change task', 13, 'change_taskstate');
INSERT INTO `auth_permission` VALUES (51, 'Can delete task', 13, 'delete_taskstate');
INSERT INTO `auth_permission` VALUES (52, 'Can view task', 13, 'view_taskstate');
INSERT INTO `auth_permission` VALUES (53, 'Can add worker', 14, 'add_workerstate');
INSERT INTO `auth_permission` VALUES (54, 'Can change worker', 14, 'change_workerstate');
INSERT INTO `auth_permission` VALUES (55, 'Can delete worker', 14, 'delete_workerstate');
INSERT INTO `auth_permission` VALUES (56, 'Can view worker', 14, 'view_workerstate');
INSERT INTO `auth_permission` VALUES (57, 'Can add browser', 15, 'add_browser');
INSERT INTO `auth_permission` VALUES (58, 'Can change browser', 15, 'change_browser');
INSERT INTO `auth_permission` VALUES (59, 'Can delete browser', 15, 'delete_browser');
INSERT INTO `auth_permission` VALUES (60, 'Can view browser', 15, 'view_browser');
INSERT INTO `auth_permission` VALUES (61, 'Can add element', 16, 'add_element');
INSERT INTO `auth_permission` VALUES (62, 'Can change element', 16, 'change_element');
INSERT INTO `auth_permission` VALUES (63, 'Can delete element', 16, 'delete_element');
INSERT INTO `auth_permission` VALUES (64, 'Can view element', 16, 'view_element');
INSERT INTO `auth_permission` VALUES (65, 'Can add environment', 17, 'add_environment');
INSERT INTO `auth_permission` VALUES (66, 'Can change environment', 17, 'change_environment');
INSERT INTO `auth_permission` VALUES (67, 'Can delete environment', 17, 'delete_environment');
INSERT INTO `auth_permission` VALUES (68, 'Can view environment', 17, 'view_environment');
INSERT INTO `auth_permission` VALUES (69, 'Can add environment login', 18, 'add_environmentlogin');
INSERT INTO `auth_permission` VALUES (70, 'Can change environment login', 18, 'change_environmentlogin');
INSERT INTO `auth_permission` VALUES (71, 'Can delete environment login', 18, 'delete_environmentlogin');
INSERT INTO `auth_permission` VALUES (72, 'Can view environment login', 18, 'view_environmentlogin');
INSERT INTO `auth_permission` VALUES (73, 'Can add keyword', 19, 'add_keyword');
INSERT INTO `auth_permission` VALUES (74, 'Can change keyword', 19, 'change_keyword');
INSERT INTO `auth_permission` VALUES (75, 'Can delete keyword', 19, 'delete_keyword');
INSERT INTO `auth_permission` VALUES (76, 'Can view keyword', 19, 'view_keyword');
INSERT INTO `auth_permission` VALUES (77, 'Can add login config', 20, 'add_loginconfig');
INSERT INTO `auth_permission` VALUES (78, 'Can change login config', 20, 'change_loginconfig');
INSERT INTO `auth_permission` VALUES (79, 'Can delete login config', 20, 'delete_loginconfig');
INSERT INTO `auth_permission` VALUES (80, 'Can view login config', 20, 'view_loginconfig');
INSERT INTO `auth_permission` VALUES (81, 'Can add page', 21, 'add_page');
INSERT INTO `auth_permission` VALUES (82, 'Can change page', 21, 'change_page');
INSERT INTO `auth_permission` VALUES (83, 'Can delete page', 21, 'delete_page');
INSERT INTO `auth_permission` VALUES (84, 'Can view page', 21, 'view_page');
INSERT INTO `auth_permission` VALUES (85, 'Can add project', 22, 'add_project');
INSERT INTO `auth_permission` VALUES (86, 'Can change project', 22, 'change_project');
INSERT INTO `auth_permission` VALUES (87, 'Can delete project', 22, 'delete_project');
INSERT INTO `auth_permission` VALUES (88, 'Can view project', 22, 'view_project');
INSERT INTO `auth_permission` VALUES (89, 'Can add result', 23, 'add_result');
INSERT INTO `auth_permission` VALUES (90, 'Can change result', 23, 'change_result');
INSERT INTO `auth_permission` VALUES (91, 'Can delete result', 23, 'delete_result');
INSERT INTO `auth_permission` VALUES (92, 'Can view result', 23, 'view_result');
INSERT INTO `auth_permission` VALUES (93, 'Can add split result', 24, 'add_splitresult');
INSERT INTO `auth_permission` VALUES (94, 'Can change split result', 24, 'change_splitresult');
INSERT INTO `auth_permission` VALUES (95, 'Can delete split result', 24, 'delete_splitresult');
INSERT INTO `auth_permission` VALUES (96, 'Can view split result', 24, 'view_splitresult');
INSERT INTO `auth_permission` VALUES (97, 'Can add task', 25, 'add_task');
INSERT INTO `auth_permission` VALUES (98, 'Can change task', 25, 'change_task');
INSERT INTO `auth_permission` VALUES (99, 'Can delete task', 25, 'delete_task');
INSERT INTO `auth_permission` VALUES (100, 'Can view task', 25, 'view_task');
INSERT INTO `auth_permission` VALUES (101, 'Can add test case', 26, 'add_testcase');
INSERT INTO `auth_permission` VALUES (102, 'Can change test case', 26, 'change_testcase');
INSERT INTO `auth_permission` VALUES (103, 'Can delete test case', 26, 'delete_testcase');
INSERT INTO `auth_permission` VALUES (104, 'Can view test case', 26, 'view_testcase');
INSERT INTO `auth_permission` VALUES (105, 'Can add user', 27, 'add_user');
INSERT INTO `auth_permission` VALUES (106, 'Can change user', 27, 'change_user');
INSERT INTO `auth_permission` VALUES (107, 'Can delete user', 27, 'delete_user');
INSERT INTO `auth_permission` VALUES (108, 'Can view user', 27, 'view_user');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `first_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$120000$mANr4ItfvyJT$oZ8VQp1XRVBGQPvqYDayNIgBWlQ6qPaExHAycG2C9RU=', '2019-10-15 15:30:15.584046', 1, '少年', '', '', 'licetianyr@163.com', 1, 1, '2019-06-25 15:23:34.647242');
INSERT INTO `auth_user` VALUES (3, 'pbkdf2_sha256$120000$1250ZUe8JYWu$63fvWf6X7+5gDiJN+kfxG/tzkRpKoZVUhzp8TNJTKEo=', NULL, 0, 'guest', '', '', '', 1, 1, '2019-10-12 14:45:53.000000');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for celery_taskmeta
-- ----------------------------
DROP TABLE IF EXISTS `celery_taskmeta`;
CREATE TABLE `celery_taskmeta`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `status` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `result` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `date_done` datetime(6) NULL DEFAULT NULL,
  `traceback` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `hidden` tinyint(1) NOT NULL,
  `meta` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `task_id`(`task_id`) USING BTREE,
  INDEX `celery_taskmeta_hidden_23fd02dc`(`hidden`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for celery_tasksetmeta
-- ----------------------------
DROP TABLE IF EXISTS `celery_tasksetmeta`;
CREATE TABLE `celery_tasksetmeta`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskset_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `result` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date_done` datetime(6) NULL DEFAULT NULL,
  `hidden` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `taskset_id`(`taskset_id`) USING BTREE,
  INDEX `celery_tasksetmeta_hidden_593cfc24`(`hidden`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NULL DEFAULT NULL,
  `object_id` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2019-06-27 11:55:12.811877', '2', 'guest', 1, '[{\"added\": {}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (2, '2019-06-27 11:55:53.193607', '2', '普通用户', 2, '[{\"changed\": {\"fields\": [\"username\", \"is_staff\"]}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (3, '2019-06-27 11:56:28.150445', '2', 'guest', 2, '[{\"changed\": {\"fields\": [\"username\"]}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (4, '2019-10-12 14:45:30.640738', '2', 'guest', 3, '', 4, 1);
INSERT INTO `django_admin_log` VALUES (5, '2019-10-12 14:45:53.443225', '3', 'guest', 1, '[{\"added\": {}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (6, '2019-10-12 14:46:40.547983', '3', 'guest', 2, '[{\"changed\": {\"fields\": [\"is_staff\"]}}]', 4, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (7, 'djcelery', 'crontabschedule');
INSERT INTO `django_content_type` VALUES (8, 'djcelery', 'intervalschedule');
INSERT INTO `django_content_type` VALUES (9, 'djcelery', 'periodictask');
INSERT INTO `django_content_type` VALUES (10, 'djcelery', 'periodictasks');
INSERT INTO `django_content_type` VALUES (11, 'djcelery', 'taskmeta');
INSERT INTO `django_content_type` VALUES (12, 'djcelery', 'tasksetmeta');
INSERT INTO `django_content_type` VALUES (13, 'djcelery', 'taskstate');
INSERT INTO `django_content_type` VALUES (14, 'djcelery', 'workerstate');
INSERT INTO `django_content_type` VALUES (15, 'Product', 'browser');
INSERT INTO `django_content_type` VALUES (16, 'Product', 'element');
INSERT INTO `django_content_type` VALUES (17, 'Product', 'environment');
INSERT INTO `django_content_type` VALUES (18, 'Product', 'environmentlogin');
INSERT INTO `django_content_type` VALUES (19, 'Product', 'keyword');
INSERT INTO `django_content_type` VALUES (20, 'Product', 'loginconfig');
INSERT INTO `django_content_type` VALUES (21, 'Product', 'page');
INSERT INTO `django_content_type` VALUES (22, 'Product', 'project');
INSERT INTO `django_content_type` VALUES (23, 'Product', 'result');
INSERT INTO `django_content_type` VALUES (24, 'Product', 'splitresult');
INSERT INTO `django_content_type` VALUES (25, 'Product', 'task');
INSERT INTO `django_content_type` VALUES (26, 'Product', 'testcase');
INSERT INTO `django_content_type` VALUES (27, 'Product', 'user');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `applied` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'Product', '0001_initial', '2019-06-24 14:06:18.187314');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0001_initial', '2019-06-24 14:06:18.232466');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2019-06-24 14:06:18.779263');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0001_initial', '2019-06-24 14:06:18.921182');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0002_logentry_remove_auto_add', '2019-06-24 14:06:18.937173');
INSERT INTO `django_migrations` VALUES (6, 'admin', '0003_logentry_add_action_flag_choices', '2019-06-24 14:06:18.953164');
INSERT INTO `django_migrations` VALUES (7, 'contenttypes', '0002_remove_content_type_name', '2019-06-24 14:06:19.102079');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0002_alter_permission_name_max_length', '2019-06-24 14:06:19.209017');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0003_alter_user_email_max_length', '2019-06-24 14:06:19.270982');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0004_alter_user_username_opts', '2019-06-24 14:06:19.284974');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0005_alter_user_last_login_null', '2019-06-24 14:06:19.336944');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0006_require_contenttypes_0002', '2019-06-24 14:06:19.342940');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0007_alter_validators_add_error_messages', '2019-06-24 14:06:19.356933');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0008_alter_user_username_max_length', '2019-06-24 14:06:19.404907');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0009_alter_user_last_name_max_length', '2019-06-24 14:06:19.455876');
INSERT INTO `django_migrations` VALUES (16, 'contenttypes', '0003_auto_20190621_1205', '2019-06-24 14:06:19.461873');
INSERT INTO `django_migrations` VALUES (17, 'djcelery', '0001_initial', '2019-06-24 14:06:19.935603');
INSERT INTO `django_migrations` VALUES (18, 'sessions', '0001_initial', '2019-06-24 14:06:19.976579');
INSERT INTO `django_migrations` VALUES (19, 'Product', '0002_delete_user', '2019-06-26 15:23:14.686322');
INSERT INTO `django_migrations` VALUES (20, 'Product', '0003_remove_project_creator', '2019-06-27 14:58:26.135721');
INSERT INTO `django_migrations` VALUES (21, 'Product', '0004_project_creator', '2019-06-27 15:21:03.850146');
INSERT INTO `django_migrations` VALUES (22, 'Product', '0005_auto_20190627_1542', '2019-06-27 15:42:28.607815');
INSERT INTO `django_migrations` VALUES (23, 'Product', '0006_loginconfig_logintype', '2019-07-02 11:32:50.226296');
INSERT INTO `django_migrations` VALUES (24, 'Product', '0007_environmentlogin_logintype', '2019-07-02 14:42:49.383135');
INSERT INTO `django_migrations` VALUES (25, 'Product', '0008_auto_20190702_1507', '2019-07-02 15:07:32.320750');
INSERT INTO `django_migrations` VALUES (26, 'Product', '0009_auto_20190719_1135', '2019-07-19 11:36:42.967890');
INSERT INTO `django_migrations` VALUES (27, 'Product', '0010_auto_20190722_1136', '2019-07-22 11:36:32.421965');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expire_date` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('23xvlzm5h037ccfzkh48xcowm56xyd0z', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-07-22 19:58:27.596657');
INSERT INTO `django_session` VALUES ('byxzy2fnqfeytf6qjxe1qmorga7yatwm', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-08-01 16:53:22.812081');
INSERT INTO `django_session` VALUES ('hz7vguy3r2s4s206w8ivuj1f2z55g5to', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-08-14 11:41:05.926815');
INSERT INTO `django_session` VALUES ('m3911plbarr03vaqh3i2nqqythxo423x', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-09-23 09:57:27.664814');
INSERT INTO `django_session` VALUES ('ph4el25r8yhjjo6ohxp4s8gm6s08hvf1', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-08-21 16:40:04.397940');
INSERT INTO `django_session` VALUES ('u1225wwxkrwwm87ynodr1xy0d6y2o8s9', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-09-20 16:20:02.409440');
INSERT INTO `django_session` VALUES ('xznek451id1dnpufm5vjpc9aq2x7vyvy', 'MDM1Y2Y3NjFmYTc5ZGEzOTQ1ZTc0NTE4ZmRkZmJmMTEwZDU1YTVhMTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2ZTNhMDlmOWJiMjg4ZjYyN2E2YzAzN2U4OTdhNDQxYzEyMzdlYjVmIn0=', '2019-10-29 15:30:15.589046');
INSERT INTO `django_session` VALUES ('zm017hw31xm51vph2mf6ljh56fcby7hv', 'MzZlZjUyM2IyYTQwNTI4NjJhMmQxZWMyMWZiYWY2OTQ1NTM4MGU5NTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJkMzE1MDY0OTQwMjg5NWM5N2VmOGJiZTcwMjAwZGY0MDE0NzgxYTE1IiwidXNlciI6Ilx1NWMxMVx1NWU3NCJ9', '2019-08-23 08:46:12.172529');

-- ----------------------------
-- Table structure for djcelery_crontabschedule
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_crontabschedule`;
CREATE TABLE `djcelery_crontabschedule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minute` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `hour` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `day_of_week` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `day_of_month` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `month_of_year` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for djcelery_intervalschedule
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_intervalschedule`;
CREATE TABLE `djcelery_intervalschedule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `every` int(11) NOT NULL,
  `period` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for djcelery_periodictask
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_periodictask`;
CREATE TABLE `djcelery_periodictask`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `task` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `args` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `kwargs` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `queue` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `exchange` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `routing_key` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `expires` datetime(6) NULL DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `last_run_at` datetime(6) NULL DEFAULT NULL,
  `total_run_count` int(10) UNSIGNED NOT NULL,
  `date_changed` datetime(6) NULL DEFAULT NULL,
  `description` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `crontab_id` int(11) NULL DEFAULT NULL,
  `interval_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `djcelery_periodictas_crontab_id_75609bab_fk_djcelery_`(`crontab_id`) USING BTREE,
  INDEX `djcelery_periodictas_interval_id_b426ab02_fk_djcelery_`(`interval_id`) USING BTREE,
  CONSTRAINT `djcelery_periodictas_crontab_id_75609bab_fk_djcelery_` FOREIGN KEY (`crontab_id`) REFERENCES `djcelery_crontabschedule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `djcelery_periodictas_interval_id_b426ab02_fk_djcelery_` FOREIGN KEY (`interval_id`) REFERENCES `djcelery_intervalschedule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for djcelery_periodictasks
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_periodictasks`;
CREATE TABLE `djcelery_periodictasks`  (
  `ident` smallint(6) NOT NULL,
  `last_update` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`ident`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for djcelery_taskstate
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_taskstate`;
CREATE TABLE `djcelery_taskstate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `task_id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tstamp` datetime(6) NULL DEFAULT NULL,
  `args` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `kwargs` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `eta` datetime(6) NULL DEFAULT NULL,
  `expires` datetime(6) NULL DEFAULT NULL,
  `result` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `traceback` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `runtime` double NULL DEFAULT NULL,
  `retries` int(11) NOT NULL,
  `hidden` tinyint(1) NOT NULL,
  `worker_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `task_id`(`task_id`) USING BTREE,
  INDEX `djcelery_taskstate_state_53543be4`(`state`) USING BTREE,
  INDEX `djcelery_taskstate_name_8af9eded`(`name`) USING BTREE,
  INDEX `djcelery_taskstate_tstamp_4c3f93a1`(`tstamp`) USING BTREE,
  INDEX `djcelery_taskstate_hidden_c3905e57`(`hidden`) USING BTREE,
  INDEX `djcelery_taskstate_worker_id_f7f57a05_fk_djcelery_workerstate_id`(`worker_id`) USING BTREE,
  CONSTRAINT `djcelery_taskstate_worker_id_f7f57a05_fk_djcelery_workerstate_id` FOREIGN KEY (`worker_id`) REFERENCES `djcelery_workerstate` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for djcelery_workerstate
-- ----------------------------
DROP TABLE IF EXISTS `djcelery_workerstate`;
CREATE TABLE `djcelery_workerstate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_heartbeat` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `hostname`(`hostname`) USING BTREE,
  INDEX `djcelery_workerstate_last_heartbeat_4539b544`(`last_heartbeat`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of djcelery_workerstate
-- ----------------------------
INSERT INTO `djcelery_workerstate` VALUES (1, 'celery@M62GRUK28YMRNJE', '2019-07-22 10:27:04.563595');

-- ----------------------------
-- Table structure for element
-- ----------------------------
DROP TABLE IF EXISTS `element`;
CREATE TABLE `element`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` int(11) NOT NULL,
  `pageId` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `by` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `locator` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 149 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of element
-- ----------------------------
INSERT INTO `element` VALUES (144, 2, 2, '输入框', '', '2019-10-12 14:54:39.941514', 'xpath', '//*[@id=\"kw\"]');
INSERT INTO `element` VALUES (145, 2, 2, '百度一下', '', '2019-10-12 15:07:17.249861', 'xpath', '//*[@id=\"su\"]');
INSERT INTO `element` VALUES (146, 2, 3, '搜索内容第一行', '', '2019-10-12 15:11:58.987028', 'xpath', '//*[@id=\"1\"]/h3/a[1]');
INSERT INTO `element` VALUES (147, 2, 3, '搜索结果第二行', '', '2019-10-12 15:12:28.291733', 'xpath', '//*[@id=\"2\"]/h3/a');
INSERT INTO `element` VALUES (148, 2, 3, '搜索结果第三行', '', '2019-10-12 16:38:54.347938', 'xpath', '//*[@id=\"3\"]/h3/a');

-- ----------------------------
-- Table structure for keyword
-- ----------------------------
DROP TABLE IF EXISTS `keyword`;
CREATE TABLE `keyword`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` int(11) NOT NULL,
  `package` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `clazz` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `method` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `params` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `steps` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of keyword
-- ----------------------------
INSERT INTO `keyword` VALUES (13, 3, '打开url', 1, 'Autotest_platform.PageObject.Base', 'PageObject', 'open_url', '[{\"type\": \"string\", \"key\": \"url\"}]', '[]', '2019-10-12 15:07:53.735189', '');
INSERT INTO `keyword` VALUES (14, 3, '左键点击', 1, 'Autotest_platform.PageObject.Base', 'PageObject', 'click', '[{\"type\": \"element\", \"key\": \"buttom\"}]', '[]', '2019-10-12 15:09:20.705260', '');
INSERT INTO `keyword` VALUES (15, 3, '隐式等待', 1, 'Autotest_platform.PageObject.Base', 'PageObject', 'wait', '[{\"type\": \"string\", \"key\": \"time\"}]', '[]', '2019-10-12 15:10:04.481652', '');
INSERT INTO `keyword` VALUES (16, 3, '输入文本', 1, 'Autotest_platform.PageObject.Base', 'PageObject', 'send_keys', '[{\"type\": \"element\", \"key\": \"location\"}, {\"type\": \"string\", \"key\": \"text\"}]', '[]', '2019-10-12 15:13:56.186687', '');

-- ----------------------------
-- Table structure for login
-- ----------------------------
DROP TABLE IF EXISTS `login`;
CREATE TABLE `login`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `checkType` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkValue` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `steps` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `params` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `checkText` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `selectText` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for page
-- ----------------------------
DROP TABLE IF EXISTS `page`;
CREATE TABLE `page`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of page
-- ----------------------------
INSERT INTO `page` VALUES (2, 2, '百度首页', '', '2019-06-28 16:44:27.487093');
INSERT INTO `page` VALUES (3, 2, '百度搜索页', '', '2019-06-28 17:22:47.962652');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `creator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (2, '百度', '', '2019-06-27 15:46:04.083959', 'guest');
INSERT INTO `project` VALUES (3, 'selenium关键字封装', 'PC端selenium封装', '2019-07-01 09:23:50.787666', '少年');

-- ----------------------------
-- Table structure for testcase
-- ----------------------------
DROP TABLE IF EXISTS `testcase`;
CREATE TABLE `testcase`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectId` int(11) NOT NULL,
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` int(11) NOT NULL,
  `beforeLogin` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `steps` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `parameter` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkType` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkValue` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `createTime` datetime(6) NULL DEFAULT NULL,
  `remark` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `checkText` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `selectText` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of testcase
-- ----------------------------
INSERT INTO `testcase` VALUES (6, 2, '能否正常打开百度首页', 3, '[]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}]', '[{\"url\": \"https://www.baidu.com\", \"expect\": true}]', 'url', 'https://www.baidu.com/', '2019-06-28 18:36:44.911484', '断言 url', '', '');
INSERT INTO `testcase` VALUES (79, 2, '验证百度搜索selenium', 3, '[]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}, {\"keywordId\": \"16\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"location\", \"value\": \"144\"}, {\"isParameter\": true, \"type\": \"string\", \"key\": \"text\", \"value\": \"搜索内容\"}]}, {\"keywordId\": \"14\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"buttom\", \"value\": \"145\"}]}]', '[{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"expect\": true}]', 'element', '146', '2019-10-12 16:24:42.283999', '完全匹配', 'Selenium - Web Browser Automation', 'all');
INSERT INTO `testcase` VALUES (80, 2, '验证百度搜索selenium - 副本', 3, '[]', '[{\"keywordId\": \"13\", \"values\": [{\"isParameter\": true, \"type\": \"string\", \"key\": \"url\", \"value\": \"url\"}]}, {\"keywordId\": \"16\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"location\", \"value\": \"144\"}, {\"isParameter\": true, \"type\": \"string\", \"key\": \"text\", \"value\": \"搜索内容\"}]}, {\"keywordId\": \"14\", \"values\": [{\"isParameter\": false, \"type\": \"element\", \"key\": \"buttom\", \"value\": \"145\"}]}]', '[{\"url\": \"https://www.baidu.com\", \"搜索内容\": \"selenium\", \"expect\": true}]', 'element', '146', '2019-10-12 16:33:42.333951', '包含匹配', 'Selenium', 'in');

SET FOREIGN_KEY_CHECKS = 1;
