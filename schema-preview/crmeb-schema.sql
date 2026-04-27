-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: crmeb
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `eb_agent_level`
--

DROP TABLE IF EXISTS `eb_agent_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_agent_level` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '等级名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '背景图',
  `one_brokerage` smallint NOT NULL DEFAULT '0' COMMENT '一级分拥上浮比例',
  `one_brokerage_percent` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '一级分佣比例',
  `two_brokerage` smallint NOT NULL DEFAULT '0' COMMENT '二级分拥上浮比例',
  `two_brokerage_percent` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '二级分佣比例',
  `grade` smallint NOT NULL DEFAULT '0' COMMENT '等级',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `task_total_num` int NOT NULL DEFAULT '0' COMMENT '总任务数量',
  `task_num` int NOT NULL DEFAULT '0' COMMENT '完成任务数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COMMENT='分销员等级表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_agent_level_task`
--

DROP TABLE IF EXISTS `eb_agent_level_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_agent_level_task` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `level_id` int NOT NULL DEFAULT '0' COMMENT '分销等级id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务类型',
  `number` int NOT NULL DEFAULT '0' COMMENT '任务限定数',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '任务描述',
  `is_must` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否必须达成0:其一1:所有',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='分销员等级任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_agent_level_task_record`
--

DROP TABLE IF EXISTS `eb_agent_level_task_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_agent_level_task_record` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `level_id` int NOT NULL DEFAULT '0' COMMENT '等级id',
  `task_id` int NOT NULL DEFAULT '0' COMMENT '任务id',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='分销员完成等级任务表记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_agreement`
--

DROP TABLE IF EXISTS `eb_agreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_agreement` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '协议类型  1：会员协议,2:代理商协议',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '协议名称',
  `content` longtext COMMENT '协议内容',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序倒序',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '1：显示：0：不显示',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='会员协议';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_app_version`
--

DROP TABLE IF EXISTS `eb_app_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_app_version` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '版本号',
  `platform` tinyint(1) NOT NULL DEFAULT '0' COMMENT '平台类型:1.安卓 2.IOS',
  `info` text COMMENT '升级信息',
  `url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '下载链接',
  `is_force` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否强制升级',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否最新',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='APP版本表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_article`
--

DROP TABLE IF EXISTS `eb_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_article` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '文章管理ID',
  `cid` varchar(255) NOT NULL DEFAULT '0' COMMENT '分类id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章标题',
  `author` varchar(255) NOT NULL DEFAULT '' COMMENT '文章作者',
  `image_input` varchar(255) NOT NULL DEFAULT '' COMMENT '文章图片',
  `synopsis` varchar(255) NOT NULL DEFAULT '' COMMENT '文章简介',
  `share_title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章分享标题',
  `share_synopsis` varchar(255) NOT NULL DEFAULT '' COMMENT '文章分享简介',
  `visit` varchar(255) NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '原文链接',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` varchar(255) NOT NULL DEFAULT '' COMMENT '添加时间',
  `hide` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员id',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品关联id',
  `is_hot` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否热门(小程序)',
  `is_banner` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否轮播图(小程序)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文章管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_article_category`
--

DROP TABLE IF EXISTS `eb_article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_article_category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '文章分类id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章分类标题',
  `intr` varchar(255) NOT NULL DEFAULT '' COMMENT '文章分类简介',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '文章分类图片',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '1删除0未删除',
  `add_time` varchar(255) NOT NULL DEFAULT '' COMMENT '添加时间',
  `hidden` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文章分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_article_content`
--

DROP TABLE IF EXISTS `eb_article_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_article_content` (
  `nid` int unsigned NOT NULL DEFAULT '0' COMMENT '文章id',
  `content` longtext COMMENT '文章内容',
  UNIQUE KEY `nid` (`nid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文章内容表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_auxiliary`
--

DROP TABLE IF EXISTS `eb_auxiliary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_auxiliary` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `binding_id` int NOT NULL DEFAULT '0' COMMENT '绑定id',
  `relation_id` int NOT NULL DEFAULT '0' COMMENT '关联id',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型0=客服转接辅助，1=商品和分类辅助，2=优惠券和商品辅助',
  `other` varchar(500) NOT NULL DEFAULT '' COMMENT '其他数据为json',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='辅助表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_cache`
--

DROP TABLE IF EXISTS `eb_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_cache` (
  `key` varchar(32) NOT NULL DEFAULT '' COMMENT '缓存key',
  `result` text COMMENT '缓存数据',
  `expire_time` int NOT NULL DEFAULT '0' COMMENT '失效时间0=永久',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '缓存时间',
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='微信缓存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_capital_flow`
--

DROP TABLE IF EXISTS `eb_capital_flow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_capital_flow` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `flow_id` varchar(32) NOT NULL DEFAULT '' COMMENT '流水id',
  `order_id` varchar(50) NOT NULL DEFAULT '' COMMENT '关联id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '电话',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '交易金额',
  `trading_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '交易类型',
  `pay_type` varchar(32) NOT NULL DEFAULT '' COMMENT '支付类型',
  `mark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '交易时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='资金流水表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_category`
--

DROP TABLE IF EXISTS `eb_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级id',
  `owner_id` int NOT NULL DEFAULT '0' COMMENT '所属人，为全部',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '分类类型0=标签分类，1=快捷短语分类',
  `other` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci COMMENT '其他参数',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `name` (`name`),
  KEY `is_be` (`owner_id`,`type`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='标签分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_delivery_service`
--

DROP TABLE IF EXISTS `eb_delivery_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_delivery_service` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '配送员uid',
  `avatar` varchar(250) NOT NULL DEFAULT '' COMMENT '配送员头像',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '配送员名称',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号码',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '0隐藏1显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='配送员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_division_agent_apply`
--

DROP TABLE IF EXISTS `eb_division_agent_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_division_agent_apply` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `agent_name` varchar(255) NOT NULL DEFAULT '' COMMENT '代理商名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名称',
  `phone` varchar(32) NOT NULL DEFAULT '0' COMMENT '代理商电话',
  `division_id` int NOT NULL DEFAULT '0' COMMENT '事业部id',
  `division_invite` int NOT NULL DEFAULT '0' COMMENT '邀请码',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '申请图片',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '申请时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '申请状态0申请，1同意，2拒绝',
  `refusal_reason` varchar(1000) NOT NULL DEFAULT '' COMMENT '拒绝理由',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='代理商申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_diy`
--

DROP TABLE IF EXISTS `eb_diy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_diy` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `version` varchar(255) NOT NULL DEFAULT '' COMMENT '版本号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '页面名称',
  `template_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模版名称',
  `value` longtext COMMENT '页面数据',
  `default_value` longtext COMMENT '默认页面数据',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否使用',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '页面类型',
  `is_show` tinyint(1) NOT NULL DEFAULT '0' COMMENT '显示首页',
  `is_bg_color` tinyint(1) NOT NULL DEFAULT '0' COMMENT '颜色是否选中',
  `is_bg_pic` tinyint(1) NOT NULL DEFAULT '0' COMMENT '背景图是否选中',
  `color_picker` varchar(50) NOT NULL DEFAULT '' COMMENT '背景颜色',
  `bg_pic` varchar(256) NOT NULL DEFAULT '' COMMENT '背景图',
  `bg_tab_val` tinyint(1) NOT NULL DEFAULT '0' COMMENT '背景图图片样式',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '个人中心订单样式',
  `my_banner_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '个人中心banner是否显示',
  `my_menus_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '个人中心我的服务样式',
  `business_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '个人中心商家管理样式',
  `is_diy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否diy',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'diy顶部title',
  `is_pro` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否新版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COMMENT='DIY数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_express`
--

DROP TABLE IF EXISTS `eb_express`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_express` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '快递公司id',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '快递公司简称',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '快递公司全称',
  `partner_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要月结账号',
  `partner_key` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要月结密码',
  `net` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要取件网店',
  `check_man` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否填写电子面单承载快递员名',
  `partner_name` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否填写电子面单客户账户名称',
  `is_code` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否填写电子面单承载编号',
  `courier_name` varchar(100) NOT NULL DEFAULT '' COMMENT '承载快递员名',
  `customer_name` varchar(100) NOT NULL DEFAULT '' COMMENT '客户账户名称',
  `code_name` varchar(100) NOT NULL DEFAULT '' COMMENT '电子面单承载编号',
  `account` varchar(100) NOT NULL DEFAULT '' COMMENT '账号',
  `key` varchar(100) NOT NULL DEFAULT '' COMMENT '密码',
  `net_name` varchar(100) NOT NULL DEFAULT '' COMMENT '网点名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1102 DEFAULT CHARSET=utf8mb3 COMMENT='快递公司表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_lang_code`
--

DROP TABLE IF EXISTS `eb_lang_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_lang_code` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type_id` int NOT NULL DEFAULT '0' COMMENT '语言类型',
  `code` varchar(255) NOT NULL DEFAULT '' COMMENT '状态码',
  `remarks` varchar(255) NOT NULL DEFAULT '' COMMENT '备注说明',
  `lang_explain` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `is_admin` tinyint(1) NOT NULL DEFAULT '0' COMMENT '服务端1，用户端2',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25231 DEFAULT CHARSET=utf8mb3 COMMENT='语言code表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_lang_country`
--

DROP TABLE IF EXISTS `eb_lang_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_lang_country` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type_id` int NOT NULL DEFAULT '0' COMMENT '管理语言类型',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '国家标识',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '国家名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8mb3 COMMENT='浏览器语言类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_lang_type`
--

DROP TABLE IF EXISTS `eb_lang_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_lang_type` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `language_name` varchar(50) NOT NULL DEFAULT '' COMMENT '语言名称',
  `file_name` varchar(20) DEFAULT '' COMMENT '配置文件名称',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1启用0禁用',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认语言',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COMMENT='语言类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_live_anchor`
--

DROP TABLE IF EXISTS `eb_live_anchor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_live_anchor` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '主播名称',
  `cover_img` varchar(255) NOT NULL DEFAULT '' COMMENT '主播图像',
  `wechat` varchar(50) NOT NULL DEFAULT '' COMMENT '主播微信号',
  `phone` varchar(32) NOT NULL DEFAULT '' COMMENT '手机号',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='直播主播表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_live_goods`
--

DROP TABLE IF EXISTS `eb_live_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_live_goods` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '微信商品ID',
  `audit_id` int NOT NULL DEFAULT '0' COMMENT '审核ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '商品名称',
  `cover_img` varchar(255) NOT NULL DEFAULT '' COMMENT '商品图片链接',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '商品小程序链接',
  `price_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '价格类型（1:一口价，此时读price字段; 2:价格区间，此时price字段为左边界，price2字段为右边界; 3:折扣价，此时price字段为原价，price2字段为现价；）',
  `cost_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '一口价/最低价',
  `price2` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '最高价',
  `audit_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '审核状态（0：未审核，1：审核中，2:审核通过，3审核失败）',
  `third_part_tag` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1、2：表示是为 API 添加商品，否则是直播控制台添加的商品',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='直播商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_live_room`
--

DROP TABLE IF EXISTS `eb_live_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_live_room` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `room_id` int unsigned NOT NULL DEFAULT '0' COMMENT '直播间 id',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '直播间名字',
  `cover_img` varchar(255) NOT NULL DEFAULT '' COMMENT '背景图',
  `share_img` varchar(255) NOT NULL DEFAULT '' COMMENT '分享图',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '直播计划开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '直播计划结束时间',
  `anchor_name` varchar(50) NOT NULL DEFAULT '' COMMENT '主播昵称',
  `anchor_wechat` varchar(50) NOT NULL DEFAULT '' COMMENT '主播微信号',
  `phone` varchar(32) NOT NULL DEFAULT '' COMMENT '主播手机号',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '直播间类型 【1: 推流，0：手机直播】',
  `screen_type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '横屏、竖屏 【1：横屏，0：竖屏】',
  `close_like` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否关闭点赞',
  `close_goods` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否关闭货架',
  `close_comment` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否关闭评论',
  `error_msg` varchar(255) NOT NULL DEFAULT '' COMMENT '未通过原因',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '审核状态0=未审核1=微信审核2=审核通过-1=审核未通过',
  `live_status` smallint unsigned NOT NULL DEFAULT '102' COMMENT '直播状态101：直播中，102：未开始，103已结束，104禁播，105：暂停，106：异常，107：已过期',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `replay_status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '回放状态',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '是否显示',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='直播间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_live_room_goods`
--

DROP TABLE IF EXISTS `eb_live_room_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_live_room_goods` (
  `live_room_id` int unsigned NOT NULL DEFAULT '0' COMMENT '直播间id',
  `live_goods_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  KEY `broadcast_room_id` (`live_room_id`,`live_goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='直播间导入商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_luck_lottery`
--

DROP TABLE IF EXISTS `eb_luck_lottery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_luck_lottery` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '抽奖类型1:九宫格2：大转盘3：九宫格升级版 4：幸运翻牌',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '抽奖活动名称',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '活动描述',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '活动背景图',
  `factor` tinyint(1) NOT NULL DEFAULT '1' COMMENT '抽奖消耗：1:积分2：余额3：下单支付成功4：关注5：订单评价',
  `factor_num` smallint NOT NULL DEFAULT '10' COMMENT '获取一次抽奖的条件数量',
  `attends_user` tinyint(1) NOT NULL DEFAULT '1' COMMENT '参与用户1：所有2：部分',
  `user_level` text COMMENT '参与用户等级',
  `user_label` text COMMENT '参与用户标签',
  `is_svip` tinyint(1) NOT NULL DEFAULT '1' COMMENT '参与用户是否付费会员',
  `prize_num` smallint NOT NULL DEFAULT '0' COMMENT '奖品数量',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '结束时间',
  `lottery_num_term` tinyint(1) NOT NULL DEFAULT '1' COMMENT '抽奖次数限制：1：每天2：每人',
  `lottery_num` smallint NOT NULL DEFAULT '1' COMMENT '抽奖次数',
  `spread_num` smallint NOT NULL DEFAULT '1' COMMENT '关注推广获取抽奖次数',
  `is_all_record` tinyint(1) NOT NULL DEFAULT '1' COMMENT '中奖纪录展示',
  `is_personal_record` tinyint(1) NOT NULL DEFAULT '1' COMMENT '个人中奖纪录展示',
  `is_content` tinyint(1) NOT NULL DEFAULT '1' COMMENT '活动规格是否展示',
  `content` longtext COMMENT '活动文案抽奖协议之类',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `is_use` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否使用',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='抽奖列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_luck_lottery_record`
--

DROP TABLE IF EXISTS `eb_luck_lottery_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_luck_lottery_record` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `wechat_order_id` varchar(255) NOT NULL DEFAULT '' COMMENT '订单id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `lottery_id` int NOT NULL DEFAULT '0' COMMENT '活动id',
  `prize_id` int NOT NULL DEFAULT '0' COMMENT '奖品id',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '奖品类型1：未中奖2：积分3:余额4：红包5:优惠券6：站内商品7：等级经验8：用户等级 9：svip天数',
  `num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '积分、余额、svip天数、红包',
  `is_receive` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否领取',
  `receive_time` int NOT NULL DEFAULT '0' COMMENT '领取时间',
  `receive_info` text COMMENT '收获地址、备注等',
  `is_deliver` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发货',
  `deliver_time` int NOT NULL DEFAULT '0' COMMENT '发货处理时间',
  `deliver_info` text COMMENT '发货单号、备注等',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `channel_type` varchar(32) NOT NULL DEFAULT '' COMMENT '抽奖来源',
  `out_bill_no` varchar(255) NOT NULL DEFAULT '' COMMENT '商户单号',
  `transfer_bill_no` varchar(255) NOT NULL DEFAULT '' COMMENT '微信转账单号',
  `state` varchar(32) NOT NULL DEFAULT '' COMMENT '单据状态',
  `package_info` varchar(2000) NOT NULL DEFAULT '' COMMENT '跳转领取页面的package信息',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `prize_id` (`prize_id`),
  KEY `lottery_id` (`lottery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='抽奖记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_luck_prize`
--

DROP TABLE IF EXISTS `eb_luck_prize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_luck_prize` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '奖品主键id',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '奖品类型1：未中奖2：积分3:余额4：红包5:优惠券6：站内商品7：等级经验8：用户等级 9：svip天数',
  `lottery_id` int NOT NULL DEFAULT '0' COMMENT '抽奖活动id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '奖品名称',
  `prompt` varchar(255) NOT NULL DEFAULT '' COMMENT '中奖提示语',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '奖品图片',
  `chance` smallint NOT NULL DEFAULT '10' COMMENT '中奖基数',
  `percent` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '中奖概率',
  `total` smallint NOT NULL DEFAULT '1' COMMENT '奖品数量',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '关联优惠券id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `unique` varchar(20) NOT NULL DEFAULT '' COMMENT '关联商品规格唯一值',
  `num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '积分 经验 会员天数',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `lottery_id` (`lottery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3 COMMENT='抽奖商品列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_member_card`
--

DROP TABLE IF EXISTS `eb_member_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_member_card` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `card_batch_id` int unsigned NOT NULL DEFAULT '0' COMMENT '卡批次id',
  `card_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '卡号',
  `card_password` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '密码',
  `use_uid` int NOT NULL DEFAULT '0' COMMENT '使用用户',
  `use_time` int NOT NULL DEFAULT '0' COMMENT '使用时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '卡状态：0：冻结；1：激活',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`,`card_batch_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='会员卡表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_member_card_batch`
--

DROP TABLE IF EXISTS `eb_member_card_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_member_card_batch` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(100) NOT NULL DEFAULT '0' COMMENT '批次名称',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '生成卡数量',
  `use_start_time` int unsigned NOT NULL DEFAULT '7' COMMENT '体验开始时间',
  `use_end_time` int NOT NULL DEFAULT '0' COMMENT '体验结束时间',
  `use_day` int NOT NULL DEFAULT '0' COMMENT '体验天数',
  `use_num` int unsigned NOT NULL DEFAULT '0' COMMENT '使用',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否生效,控制此批次所有卡0：不生效；1：生效',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `qrcode` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码图路径',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '备注',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='会员卡批次表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_member_right`
--

DROP TABLE IF EXISTS `eb_member_right`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_member_right` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `right_type` varchar(100) NOT NULL DEFAULT '' COMMENT '权益类别',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT ' 权益名称',
  `show_title` varchar(255) NOT NULL DEFAULT '' COMMENT '显示权益名称',
  `image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '权益图标',
  `explain` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '权益介绍',
  `number` int NOT NULL DEFAULT '1' COMMENT '规则数字',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序倒序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0:禁用，1：启用',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`,`right_type`) USING BTREE,
  KEY `type` (`right_type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='会员权益';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_member_ship`
--

DROP TABLE IF EXISTS `eb_member_ship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_member_ship` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` varchar(20) NOT NULL DEFAULT 'month' COMMENT '会员类别month:月卡会员；quarter:季卡；year:年卡；ever:永久；free:免费',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '会员名称',
  `vip_day` int NOT NULL DEFAULT '0' COMMENT '会员时间(天)',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '原价',
  `pre_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '优惠后价格',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序倒序',
  `is_del` int NOT NULL DEFAULT '0' COMMENT '删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='会员类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_message_system`
--

DROP TABLE IF EXISTS `eb_message_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_message_system` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `mark` varchar(50) NOT NULL DEFAULT '' COMMENT '标识',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `title` varchar(256) NOT NULL DEFAULT '' COMMENT '通知标题',
  `content` varchar(512) NOT NULL DEFAULT '' COMMENT '通知内容',
  `data` varchar(5000) NOT NULL DEFAULT '' COMMENT '站内信参数',
  `look` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否查看',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1:普通用户，2：管理员',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '通知时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='系统通知';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_catalog_cursor`
--

DROP TABLE IF EXISTS `eb_nfr_1688_catalog_cursor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_catalog_cursor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `cursor_code` varchar(64) NOT NULL DEFAULT '' COMMENT 'Cursor code',
  `cursor_scope` varchar(64) NOT NULL DEFAULT '' COMMENT 'Cursor scope',
  `cursor_value` varchar(255) NOT NULL DEFAULT '' COMMENT 'Cursor value',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_cursor_code` (`cursor_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Catalog incremental cursor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_category_switch`
--

DROP TABLE IF EXISTS `eb_nfr_1688_category_switch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_category_switch` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `category_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB category id',
  `enabled_sync` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Enable sync',
  `enabled_sale` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Enable sale',
  `collect_top_n` int unsigned NOT NULL DEFAULT '100' COMMENT 'Top N collection limit',
  `notes` varchar(255) NOT NULL DEFAULT '' COMMENT 'Operator notes',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_category_id` (`category_id`),
  KEY `idx_enabled_sync` (`enabled_sync`),
  KEY `idx_enabled_sale` (`enabled_sale`)
) ENGINE=InnoDB AUTO_INCREMENT=1683 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='1688 category switch center';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_collect_batch`
--

DROP TABLE IF EXISTS `eb_nfr_1688_collect_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_collect_batch` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `plan_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Collect plan id',
  `category_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB category id',
  `batch_code` varchar(64) NOT NULL DEFAULT '' COMMENT 'Batch code',
  `status` varchar(32) NOT NULL DEFAULT 'queued' COMMENT 'queued/running/success/error',
  `target_total` int unsigned NOT NULL DEFAULT '0' COMMENT 'Target collect total',
  `success_total` int unsigned NOT NULL DEFAULT '0' COMMENT 'Success total',
  `failed_total` int unsigned NOT NULL DEFAULT '0' COMMENT 'Failed total',
  `started_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Started timestamp',
  `ended_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Ended timestamp',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_batch_code` (`batch_code`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='1688 collection batches';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_collect_plan`
--

DROP TABLE IF EXISTS `eb_nfr_1688_collect_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_collect_plan` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `plan_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'Plan name',
  `category_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB category id',
  `top_n` int unsigned NOT NULL DEFAULT '100' COMMENT 'Collect top N',
  `collect_mode` varchar(32) NOT NULL DEFAULT 'top' COMMENT 'top/manual/tag',
  `auto_listing` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Auto create CRMEB goods',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Plan enabled',
  `last_run_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last run timestamp',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_is_enabled` (`is_enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='1688 product collection plan';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_config`
--

DROP TABLE IF EXISTS `eb_nfr_1688_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `config_group` varchar(64) NOT NULL DEFAULT '' COMMENT 'Config group',
  `config_key` varchar(128) NOT NULL DEFAULT '' COMMENT 'Config key',
  `config_value` longtext COMMENT 'Config value',
  `is_secret` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Secret flag',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_config_key` (`config_key`),
  KEY `idx_config_group` (`config_group`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bridge configuration center';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_conversation`
--

DROP TABLE IF EXISTS `eb_nfr_1688_conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_conversation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `supplier_id` varchar(128) NOT NULL DEFAULT '' COMMENT '1688 supplier id',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB product id',
  `order_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB order id',
  `conversation_status` varchar(32) NOT NULL DEFAULT 'draft' COMMENT 'draft/open/closed',
  `channel_code` varchar(32) NOT NULL DEFAULT '' COMMENT 'Channel code',
  `remote_thread_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Remote thread id',
  `last_message_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last message timestamp',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_supplier_id` (`supplier_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Supplier conversation mapping';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_conversation_message`
--

DROP TABLE IF EXISTS `eb_nfr_1688_conversation_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_conversation_message` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `conversation_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Conversation id',
  `direction` varchar(16) NOT NULL DEFAULT 'outbound' COMMENT 'outbound/inbound',
  `sender_type` varchar(32) NOT NULL DEFAULT '' COMMENT 'bridge/operator/supplier',
  `message_type` varchar(32) NOT NULL DEFAULT 'text' COMMENT 'text/image/system',
  `content` longtext COMMENT 'Message content',
  `remote_message_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Remote message id',
  `send_status` varchar(32) NOT NULL DEFAULT 'pending' COMMENT 'pending/sent/error',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_conversation_id` (`conversation_id`),
  KEY `idx_send_status` (`send_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Supplier conversation messages';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_event_log`
--

DROP TABLE IF EXISTS `eb_nfr_1688_event_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_event_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `event_type` varchar(64) NOT NULL DEFAULT '' COMMENT 'Event type',
  `source_system` varchar(32) NOT NULL DEFAULT '' COMMENT 'crmeb/1688/bridge',
  `source_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Source id',
  `event_status` varchar(32) NOT NULL DEFAULT 'new' COMMENT 'new/processed/error',
  `payload_json` longtext COMMENT 'Payload json',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_source_system` (`source_system`),
  KEY `idx_event_status` (`event_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bridge event logs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_manual_action`
--

DROP TABLE IF EXISTS `eb_nfr_1688_manual_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_manual_action` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `target_type` varchar(32) NOT NULL DEFAULT '' COMMENT 'log/order/product/supplier/category',
  `target_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Target id',
  `action_code` varchar(64) NOT NULL DEFAULT '' COMMENT 'Action code',
  `action_note` varchar(500) NOT NULL DEFAULT '' COMMENT 'Action note',
  `operator_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'Operator name',
  `result_status` varchar(32) NOT NULL DEFAULT 'pending' COMMENT 'pending/done/error',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`,`target_id`),
  KEY `idx_result_status` (`result_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Manual intervention center';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_order_map`
--

DROP TABLE IF EXISTS `eb_nfr_1688_order_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_order_map` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `order_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB order id',
  `order_no` varchar(64) NOT NULL DEFAULT '' COMMENT 'CRMEB order number',
  `out_order_id` varchar(64) NOT NULL DEFAULT '' COMMENT '1688 external order id',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB product id',
  `offer_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '1688 offer id',
  `supplier_id` varchar(128) NOT NULL DEFAULT '' COMMENT '1688 supplier id',
  `alibaba_order_id` varchar(128) NOT NULL DEFAULT '' COMMENT '1688 order id',
  `bridge_status` varchar(32) NOT NULL DEFAULT 'pending' COMMENT 'pending/pushed/error',
  `sync_status` varchar(32) NOT NULL DEFAULT 'pending' COMMENT 'pending/synced/error',
  `isv_biz_type_str` varchar(64) NOT NULL DEFAULT 'fenxiaoMedia' COMMENT '1688 compliance business type',
  `dry_run` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=dry run only, 0=real push allowed',
  `order_snapshot` longtext COMMENT 'CRMEB order snapshot at bridge time',
  `address_payload` longtext COMMENT '1688 address param snapshot',
  `cargo_payload` longtext COMMENT '1688 cargo param list snapshot',
  `request_payload` longtext COMMENT '1688 order create payload snapshot',
  `response_payload` longtext COMMENT '1688 order create response snapshot',
  `error_message` varchar(500) NOT NULL DEFAULT '' COMMENT 'Last bridge error message',
  `pushed_at` int unsigned NOT NULL DEFAULT '0' COMMENT '1688 order push timestamp',
  `last_sync_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last sync timestamp',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_order_id` (`order_id`),
  KEY `idx_alibaba_order_id` (`alibaba_order_id`),
  KEY `idx_supplier_id` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CRMEB to 1688 order mapping';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_product_map`
--

DROP TABLE IF EXISTS `eb_nfr_1688_product_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_product_map` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'CRMEB product id',
  `offer_id` bigint unsigned DEFAULT NULL COMMENT '1688 offer id',
  `open_offer_id` varchar(128) DEFAULT NULL COMMENT 'Encrypted 1688 offer id',
  `source_url` varchar(500) NOT NULL DEFAULT '' COMMENT '1688 offer url',
  `supplier_id` varchar(128) NOT NULL DEFAULT '' COMMENT '1688 supplier id',
  `supplier_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Supplier name',
  `category_id_1688` bigint unsigned NOT NULL DEFAULT '0' COMMENT '1688 category id',
  `sync_mode` varchar(32) NOT NULL DEFAULT 'light' COMMENT 'light/detail',
  `sync_status` varchar(32) NOT NULL DEFAULT 'pending' COMMENT 'pending/synced/error',
  `last_sync_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last sync timestamp',
  `last_price_sync_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last price sync timestamp',
  `last_stock_sync_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last stock sync timestamp',
  `last_detail_sync_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last detail sync timestamp',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_product_id` (`product_id`),
  UNIQUE KEY `uniq_offer_id` (`offer_id`),
  UNIQUE KEY `uniq_open_offer_id` (`open_offer_id`),
  KEY `idx_supplier_id` (`supplier_id`),
  KEY `idx_sync_status` (`sync_status`)
) ENGINE=InnoDB AUTO_INCREMENT=3909 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CRMEB to 1688 product mapping';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_supplier_map`
--

DROP TABLE IF EXISTS `eb_nfr_1688_supplier_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_supplier_map` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `supplier_id` varchar(128) NOT NULL DEFAULT '' COMMENT '1688 supplier id',
  `seller_login_id` varchar(128) NOT NULL DEFAULT '' COMMENT '1688 seller login id',
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Company name',
  `shop_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Shop name',
  `shop_url` varchar(500) NOT NULL DEFAULT '' COMMENT 'Shop url',
  `contact_status` varchar(32) NOT NULL DEFAULT 'unknown' COMMENT 'unknown/linked/blocked',
  `last_sync_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last sync timestamp',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_supplier_id` (`supplier_id`),
  KEY `idx_seller_login_id` (`seller_login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4297 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='1688 supplier mapping';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_sync_job`
--

DROP TABLE IF EXISTS `eb_nfr_1688_sync_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_sync_job` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `job_code` varchar(64) NOT NULL DEFAULT '' COMMENT 'Job code',
  `job_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'Job name',
  `job_group` varchar(64) NOT NULL DEFAULT '' COMMENT 'Job group',
  `schedule_type` varchar(32) NOT NULL DEFAULT 'manual' COMMENT 'manual/interval/cron/event',
  `schedule_value` varchar(128) NOT NULL DEFAULT '' COMMENT 'Schedule value',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Enabled flag',
  `run_status` varchar(32) NOT NULL DEFAULT 'idle' COMMENT 'idle/running/error',
  `last_run_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last run timestamp',
  `last_success_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last success timestamp',
  `last_error_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Last error timestamp',
  `last_error_message` varchar(500) NOT NULL DEFAULT '' COMMENT 'Last error message',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  `updated_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_job_code` (`job_code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bridge sync jobs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_nfr_1688_sync_log`
--

DROP TABLE IF EXISTS `eb_nfr_1688_sync_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_nfr_1688_sync_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `job_code` varchar(64) NOT NULL DEFAULT '' COMMENT 'Job code',
  `target_type` varchar(32) NOT NULL DEFAULT '' COMMENT 'product/order/supplier/chat/system',
  `target_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Target id',
  `status` varchar(32) NOT NULL DEFAULT 'info' COMMENT 'success/error/warn/info',
  `message` varchar(500) NOT NULL DEFAULT '' COMMENT 'Log message',
  `payload_json` longtext COMMENT 'Payload json',
  `created_at` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_job_code` (`job_code`),
  KEY `idx_target_type` (`target_type`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bridge sync logs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_other_order`
--

DROP TABLE IF EXISTS `eb_other_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_other_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '区别 \r\n0：免费领取\r\n1：购买会员卡 \r\n2：卡密领取会员卡',
  `order_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '订单号',
  `member_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '会员类型 \r\n月卡：month\r\n季卡：quarter\r\n年卡：year\r\n永久：ever\r\n免费：free',
  `code` varchar(20) NOT NULL DEFAULT '' COMMENT '卡号',
  `pay_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '支付方式',
  `paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '支付状态 0:  未支付 1：已支付',
  `pay_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `member_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '会员卡价格',
  `pay_time` int unsigned NOT NULL DEFAULT '0' COMMENT '会员购买时间',
  `trade_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '支付宝支付,支付宝交易订单号',
  `channel_type` varchar(10) NOT NULL DEFAULT '' COMMENT '支付渠道(微信公众号 h5 小程序)',
  `is_free` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否免费',
  `is_permanent` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否永久',
  `overdue_time` bigint unsigned NOT NULL DEFAULT '0' COMMENT '会员过期时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除',
  `vip_day` int NOT NULL DEFAULT '0' COMMENT '会员有效天数',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `money` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '原价格',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='会员购买记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_other_order_status`
--

DROP TABLE IF EXISTS `eb_other_order_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_other_order_status` (
  `oid` int unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `change_type` varchar(32) NOT NULL DEFAULT '' COMMENT '操作类型',
  `change_message` varchar(256) NOT NULL DEFAULT '' COMMENT '操作备注',
  `shop_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '订单类型 1：会员卡',
  `change_time` int NOT NULL DEFAULT '0' COMMENT '订单修改时间',
  KEY `oid` (`oid`) USING BTREE,
  KEY `change_type` (`change_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='订单操作记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_out_account`
--

DROP TABLE IF EXISTS `eb_out_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_out_account` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `appid` varchar(50) NOT NULL DEFAULT '' COMMENT '账号',
  `appsecret` varchar(100) NOT NULL DEFAULT '' COMMENT '密钥',
  `apppwd` varchar(255) NOT NULL DEFAULT '' COMMENT '密钥明文',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `rules` text COMMENT '权限',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `last_time` int NOT NULL DEFAULT '0' COMMENT '最后一次登录时间',
  `ip` varchar(30) NOT NULL DEFAULT '' COMMENT 'IP',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `push_open` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否推送',
  `push_account` varchar(255) NOT NULL COMMENT '推送账号',
  `push_password` varchar(255) NOT NULL COMMENT '推送密码',
  `push_token_url` varchar(255) NOT NULL COMMENT '获取推送token接口',
  `user_update_push` varchar(255) NOT NULL COMMENT '用户推送接口',
  `order_create_push` varchar(255) NOT NULL DEFAULT '' COMMENT '订单创建推送接口',
  `order_pay_push` varchar(255) NOT NULL DEFAULT '' COMMENT '订单支付推送接口',
  `refund_create_push` varchar(255) NOT NULL DEFAULT '' COMMENT '售后订单创建推送接口',
  `refund_cancel_push` varchar(255) NOT NULL DEFAULT '' COMMENT '售后订单取消推送接口',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='对外接口账号';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_out_interface`
--

DROP TABLE IF EXISTS `eb_out_interface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_out_interface` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级pid',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0菜单，1接口',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '接口名称',
  `describe` text COMMENT '功能描述',
  `method` varchar(255) NOT NULL DEFAULT '' COMMENT '接口类型',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '接口地址',
  `request_params` text COMMENT '请求参数',
  `return_params` text COMMENT '返回参数',
  `request_example` text COMMENT '请求示例',
  `return_example` text COMMENT '返回示例',
  `error_code` text COMMENT '错误返回',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对外接口';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_page_categroy`
--

DROP TABLE IF EXISTS `eb_page_categroy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_page_categroy` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父类id',
  `type` varchar(50) NOT NULL DEFAULT 'link' COMMENT '类型:link、special、product、product_category、custom',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3 COMMENT='页面链接分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_page_link`
--

DROP TABLE IF EXISTS `eb_page_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_page_link` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '分组1:基础2:分销3:个人中心',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '页面名称',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '页面链接',
  `param` varchar(255) NOT NULL DEFAULT '' COMMENT '参数',
  `example` varchar(255) NOT NULL DEFAULT '' COMMENT '事例',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb3 COMMENT='页面链接';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_qrcode`
--

DROP TABLE IF EXISTS `eb_qrcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_qrcode` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '微信二维码ID',
  `third_type` varchar(32) NOT NULL DEFAULT '' COMMENT '二维码类型',
  `third_id` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `ticket` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码参数',
  `expire_seconds` int unsigned NOT NULL DEFAULT '0' COMMENT '二维码有效时间',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` varchar(255) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '微信访问url',
  `qrcode_url` varchar(255) NOT NULL DEFAULT '' COMMENT '微信二维码url',
  `scan` int unsigned NOT NULL DEFAULT '0' COMMENT '被扫的次数',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '二维码所属平台1=小程序，2=公众号，3=H5',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `third_type` (`third_type`,`third_id`) USING BTREE,
  KEY `ticket` (`ticket`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='微信二维码管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_routine_scheme`
--

DROP TABLE IF EXISTS `eb_routine_scheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_routine_scheme` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '小程序页面地址',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '生成链接地址',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `expire_type` int NOT NULL DEFAULT '-1' COMMENT '到期类型',
  `expire_interval` int NOT NULL DEFAULT '0' COMMENT '到期天数',
  `expire_time` int NOT NULL DEFAULT '0' COMMENT '到期时间',
  `is_del` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COMMENT='小程序外链';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_shipping_templates`
--

DROP TABLE IF EXISTS `eb_shipping_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_shipping_templates` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计费方式',
  `appoint` tinyint(1) NOT NULL DEFAULT '0' COMMENT '指定包邮',
  `no_delivery` tinyint(1) NOT NULL DEFAULT '0' COMMENT '指定不送达',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='运费模板表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_shipping_templates_free`
--

DROP TABLE IF EXISTS `eb_shipping_templates_free`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_shipping_templates_free` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '模板ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市ID',
  `number` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '包邮件数',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '包邮金额',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计费方式',
  `uniqid` varchar(32) NOT NULL DEFAULT '' COMMENT '分组唯一值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='运费模板指定包邮关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_shipping_templates_no_delivery`
--

DROP TABLE IF EXISTS `eb_shipping_templates_no_delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_shipping_templates_no_delivery` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '模板ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市ID',
  `uniqid` varchar(32) NOT NULL DEFAULT '' COMMENT '分组唯一值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='运费模板指定不送达表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_shipping_templates_region`
--

DROP TABLE IF EXISTS `eb_shipping_templates_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_shipping_templates_region` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '模板ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市ID',
  `first` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '首件',
  `first_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '首件运费',
  `continue` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '续件',
  `continue_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '续件运费',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计费方式',
  `uniqid` varchar(32) NOT NULL DEFAULT '' COMMENT '分组唯一值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='运费模板指定城市运费表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_sms_record`
--

DROP TABLE IF EXISTS `eb_sms_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_sms_record` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '短信发送记录编号',
  `uid` varchar(255) NOT NULL DEFAULT '' COMMENT '短信平台账号',
  `phone` char(11) NOT NULL DEFAULT '' COMMENT '接受短信的手机号',
  `content` text COMMENT '短信内容',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '发送短信时间',
  `add_ip` varchar(16) NOT NULL DEFAULT '' COMMENT '添加记录ip',
  `template` varchar(255) NOT NULL DEFAULT '' COMMENT '短信模板ID',
  `resultcode` int unsigned NOT NULL DEFAULT '0' COMMENT '状态码 100=成功,130=失败,131=空号,132=停机,133=关机,134=无状态',
  `record_id` int unsigned NOT NULL DEFAULT '0' COMMENT '发送记录id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='短信发送记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_spread_apply`
--

DROP TABLE IF EXISTS `eb_spread_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_spread_apply` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `real_name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名称',
  `phone` varchar(32) NOT NULL DEFAULT '0' COMMENT '用户电话',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '申请状态0申请，1同意，2拒绝',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '申请时间',
  `status_time` int NOT NULL DEFAULT '0' COMMENT '审核时间',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '自荐内容',
  `refusal_reason` varchar(1000) NOT NULL DEFAULT '' COMMENT '拒绝理由',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='分销员申请';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_activity`
--

DROP TABLE IF EXISTS `eb_store_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_activity` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1:秒杀',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '活动名称',
  `start_day` int NOT NULL DEFAULT '0' COMMENT '开始日期',
  `end_day` int NOT NULL DEFAULT '0' COMMENT '结束日期',
  `time_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '时间段ID多个',
  `once_num` int unsigned NOT NULL DEFAULT '0' COMMENT '活动期间每人每日购买数量，0不限制',
  `num` int unsigned NOT NULL DEFAULT '0' COMMENT '全部活动期间，用户购买总数限制，0不限制',
  `is_commission` int NOT NULL DEFAULT '0' COMMENT '是否参与分佣',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否显示',
  `link_id` int unsigned NOT NULL DEFAULT '0' COMMENT '关联ID',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `start_day` (`start_day`,`end_day`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='活动表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_advance`
--

DROP TABLE IF EXISTS `eb_store_advance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_advance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '预售商品id',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '商品主图',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '活动标题',
  `info` varchar(255) NOT NULL DEFAULT '' COMMENT '简介',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '价格',
  `ot_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '原价',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `unit_name` varchar(16) NOT NULL DEFAULT '' COMMENT '单位名',
  `start_time` varchar(128) NOT NULL DEFAULT '' COMMENT '开始时间',
  `stop_time` varchar(128) NOT NULL DEFAULT '' COMMENT '结束时间',
  `add_time` varchar(128) NOT NULL DEFAULT '' COMMENT '添加时间',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '商品状态',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '删除 0未删除1已删除',
  `type` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '类型 0全款1定金',
  `deposit` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '定金金额',
  `pay_start_time` varchar(128) NOT NULL DEFAULT '' COMMENT '尾款支付开始时间',
  `pay_stop_time` varchar(128) NOT NULL DEFAULT '' COMMENT '尾款支付结束时间',
  `deliver_time` int NOT NULL DEFAULT '0' COMMENT '付款后几天后发货',
  `num` int unsigned NOT NULL DEFAULT '1' COMMENT '最多购买几个',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '运费模板ID',
  `quota` int NOT NULL DEFAULT '0' COMMENT '限购总数',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '限购总数显示',
  `once_num` int NOT NULL DEFAULT '0' COMMENT '单次购买个数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='预售商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_bargain`
--

DROP TABLE IF EXISTS `eb_store_bargain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_bargain` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '砍价商品ID',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '关联商品ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '砍价活动名称',
  `image` varchar(150) NOT NULL DEFAULT '' COMMENT '砍价活动图片',
  `unit_name` varchar(16) NOT NULL DEFAULT '' COMMENT '单位名称',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '砍价商品轮播图',
  `start_time` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价开启时间',
  `stop_time` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价结束时间',
  `store_name` varchar(255) NOT NULL DEFAULT '' COMMENT '砍价商品名称',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '砍价金额',
  `min_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '砍价商品最低价',
  `num` int unsigned NOT NULL DEFAULT '1' COMMENT '可购买砍价商品数量',
  `bargain_max_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '用户每次砍价的最大金额',
  `bargain_min_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '用户每次砍价的最小金额',
  `bargain_num` int unsigned NOT NULL DEFAULT '1' COMMENT '用户帮砍的次数',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '砍价状态 0(到砍价时间不自动开启)  1(到砍价时间自动开启时间)',
  `give_integral` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '反多少积分',
  `info` varchar(255) NOT NULL DEFAULT '' COMMENT '砍价活动简介',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `is_hot` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否推荐0不推荐1推荐',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除 0未删除 1删除',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_postage` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '是否包邮 0不包邮 1包邮',
  `postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `rule` longtext COMMENT '砍价规则',
  `look` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价商品浏览量',
  `share` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价商品分享量',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '运费模板ID',
  `weight` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `volume` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '体积',
  `quota` int NOT NULL DEFAULT '0' COMMENT '限购总数',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '限量总数显示',
  `people_num` int NOT NULL DEFAULT '1' COMMENT '用户帮砍的次数',
  `logistics` varchar(11) NOT NULL DEFAULT '1,2' COMMENT '物流方式',
  `freight` tinyint(1) NOT NULL DEFAULT '2' COMMENT '运费设置',
  `custom_form` varchar(2000) NOT NULL DEFAULT '' COMMENT '自定义表单',
  `virtual_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `is_commission` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否返佣',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='砍价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_bargain_user`
--

DROP TABLE IF EXISTS `eb_store_bargain_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_bargain_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户参与砍价表ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `bargain_id` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价商品id',
  `bargain_price_min` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '砍价的最低价',
  `bargain_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '砍价金额',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '砍掉的价格',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '状态 1参与中 2 活动结束参与失败 3活动结束参与成功',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '参与时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否取消',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户参与砍价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_bargain_user_help`
--

DROP TABLE IF EXISTS `eb_store_bargain_user_help`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_bargain_user_help` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '砍价用户帮助表ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '帮助的用户id',
  `bargain_id` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价商品ID',
  `bargain_user_id` int unsigned NOT NULL DEFAULT '0' COMMENT '用户参与砍价表id',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '帮助砍价多少金额',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否自己砍价',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='砍价用户帮助表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_cart`
--

DROP TABLE IF EXISTS `eb_store_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_cart` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '类型',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_attr_unique` varchar(16) NOT NULL DEFAULT '' COMMENT '商品属性',
  `cart_num` smallint unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_pay` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 未购买 1 = 已购买',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为立即购买',
  `combination_id` int unsigned NOT NULL DEFAULT '0' COMMENT '拼团id',
  `seckill_id` int unsigned NOT NULL DEFAULT '0' COMMENT '秒杀商品ID',
  `bargain_id` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价id',
  `advance_id` int NOT NULL DEFAULT '0' COMMENT '预售商品id',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '购物车商品状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`product_id`) USING BTREE,
  KEY `uid` (`uid`,`is_pay`) USING BTREE,
  KEY `uid_2` (`uid`,`is_del`) USING BTREE,
  KEY `uid_3` (`uid`,`is_new`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_category`
--

DROP TABLE IF EXISTS `eb_store_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品分类表ID',
  `pid` bigint NOT NULL DEFAULT '0' COMMENT '父id',
  `cate_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `pic` varchar(128) NOT NULL DEFAULT '' COMMENT '图标',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否推荐',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `big_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '分类大图',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE,
  KEY `is_base` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3168800013143 DEFAULT CHARSET=utf8mb3 COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_combination`
--

DROP TABLE IF EXISTS `eb_store_combination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_combination` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户id',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '推荐图',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '活动标题',
  `attr` varchar(255) NOT NULL DEFAULT '' COMMENT '活动属性',
  `people` int unsigned NOT NULL DEFAULT '0' COMMENT '参团人数',
  `info` varchar(255) NOT NULL DEFAULT '' COMMENT '简介',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '价格',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `add_time` varchar(128) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_host` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '推荐',
  `is_show` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '商品状态',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `combination` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '拼团',
  `mer_use` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '商户是否可用1可用0不可用',
  `is_postage` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否包邮1是0否',
  `postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `start_time` int unsigned NOT NULL DEFAULT '0' COMMENT '拼团开始时间',
  `stop_time` int unsigned NOT NULL DEFAULT '0' COMMENT '拼团结束时间',
  `effective_time` int NOT NULL DEFAULT '0' COMMENT '拼团订单有效时间',
  `cost` int unsigned NOT NULL DEFAULT '0' COMMENT '拼图商品成本',
  `browse` int NOT NULL DEFAULT '0' COMMENT '浏览量',
  `unit_name` varchar(32) NOT NULL DEFAULT '' COMMENT '单位名',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '运费模板ID',
  `weight` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `volume` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '体积',
  `num` int NOT NULL DEFAULT '0' COMMENT '单次购买数量',
  `once_num` int NOT NULL DEFAULT '0' COMMENT '每个订单可购买数量',
  `quota` int NOT NULL DEFAULT '0' COMMENT '限购总数',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '限量总数显示',
  `virtual` int NOT NULL DEFAULT '100' COMMENT '虚拟成团百分比',
  `logistics` varchar(11) NOT NULL DEFAULT '1,2' COMMENT '物流方式',
  `freight` tinyint(1) NOT NULL DEFAULT '2' COMMENT '运费设置',
  `custom_form` varchar(2000) NOT NULL DEFAULT '' COMMENT '自定义表单',
  `virtual_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `is_commission` tinyint(1) NOT NULL DEFAULT '0' COMMENT '拼团是否返佣',
  `head_commission` int NOT NULL DEFAULT '0' COMMENT '团长佣金比例',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='拼团商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_coupon_issue`
--

DROP TABLE IF EXISTS `eb_store_coupon_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_coupon_issue` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `cid` int NOT NULL DEFAULT '0' COMMENT '优惠券ID',
  `coupon_title` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '优惠券领取开启时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '优惠券领取结束时间',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '优惠券领取数量',
  `remain_count` int NOT NULL DEFAULT '0' COMMENT '优惠券剩余领取数量',
  `receive_limit` int NOT NULL DEFAULT '0' COMMENT '每个人个领取的优惠券数量',
  `is_permanent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否无限张数',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 正常 0 未开启 -1 已无效',
  `is_give_subscribe` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否首次关注赠送 0-否(默认) 1-是',
  `is_full_give` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否满赠0-否(默认) 1-是',
  `full_reduction` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '消费满多少赠送优惠券',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '优惠券添加时间',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `integral` int unsigned NOT NULL DEFAULT '0' COMMENT '兑换消耗积分值',
  `coupon_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '兑换的优惠券面值',
  `use_min_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '最低消费多少金额可用优惠券',
  `coupon_time` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券有效期限（单位：天）',
  `product_id` varchar(2000) NOT NULL DEFAULT '' COMMENT '所属商品id',
  `category_id` varchar(2000) NOT NULL DEFAULT '' COMMENT '分类id',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '优惠券类型 0-通用 1-品类券 2-商品券',
  `receive_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 手动领取，2 新人券，3赠送券，4会员券',
  `start_use_time` int NOT NULL DEFAULT '0' COMMENT '优惠券使用开始时间',
  `end_use_time` int NOT NULL DEFAULT '0' COMMENT '优惠券使用结束时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cid` (`cid`) USING BTREE,
  KEY `start_time` (`start_time`,`end_time`) USING BTREE,
  KEY `remain_count` (`remain_count`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `coupon_time` (`coupon_time`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='优惠券前台领取表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_coupon_issue_user`
--

DROP TABLE IF EXISTS `eb_store_coupon_issue_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_coupon_issue_user` (
  `uid` int NOT NULL DEFAULT '0' COMMENT '领取优惠券用户ID',
  `issue_coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券前台领取ID',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '领取时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='优惠券前台用户领取记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_coupon_product`
--

DROP TABLE IF EXISTS `eb_store_coupon_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_coupon_product` (
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券模板id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `category_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  KEY `coupon_id` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='优惠券模板关联列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_coupon_user`
--

DROP TABLE IF EXISTS `eb_store_coupon_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_coupon_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '优惠券发放记录id',
  `cid` int unsigned NOT NULL DEFAULT '0' COMMENT '兑换的项目id',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券所属用户',
  `coupon_title` varchar(32) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠券的面值',
  `use_min_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '最低消费多少金额可用优惠券',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券创建时间',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '优惠券开始时间',
  `end_time` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券结束时间',
  `use_time` int unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `type` varchar(32) NOT NULL DEFAULT 'send' COMMENT '获取方式',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态（0：未使用，1：已使用, 2:已过期）',
  `is_fail` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否有效',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cid` (`cid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `end_time` (`end_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_fail` (`is_fail`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='优惠券发放记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_integral`
--

DROP TABLE IF EXISTS `eb_store_integral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_integral` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '积分商品ID',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '活动标题',
  `price` int NOT NULL DEFAULT '0' COMMENT '兑换积分',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `unit_name` varchar(16) NOT NULL DEFAULT '' COMMENT '单位名',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `add_time` varchar(128) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_host` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '推荐',
  `is_show` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '商品状态',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '删除',
  `num` int NOT NULL DEFAULT '0' COMMENT '最多积分几个',
  `quota` int NOT NULL DEFAULT '0' COMMENT '限购总数',
  `once_num` int NOT NULL DEFAULT '0' COMMENT '单次购买个数',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '限购显示',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='积分商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_integral_order`
--

DROP TABLE IF EXISTS `eb_store_integral_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_integral_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '订单号',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL DEFAULT '' COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL DEFAULT '' COMMENT '详细地址',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `suk` varchar(128) NOT NULL DEFAULT '' COMMENT '规格',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `total_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总积分',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1：待发货；2：待收货；3：已完成；',
  `delivery_name` varchar(64) NOT NULL DEFAULT '' COMMENT '快递名称/送货人姓名',
  `delivery_code` varchar(50) NOT NULL DEFAULT '' COMMENT '快递公司编码',
  `delivery_type` varchar(32) NOT NULL DEFAULT '' COMMENT '发货类型',
  `delivery_id` varchar(64) NOT NULL DEFAULT '' COMMENT '快递单号/手机号',
  `fictitious_content` varchar(500) NOT NULL DEFAULT '' COMMENT '虚拟发货内容',
  `delivery_uid` int NOT NULL DEFAULT '0' COMMENT '配送员id',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '管理员备注',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint unsigned NOT NULL DEFAULT '0',
  `is_remind` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '消息提醒',
  `is_system_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '后台是否删除',
  `channel_type` varchar(255) NOT NULL DEFAULT '' COMMENT '用户访问端标识',
  `province` varchar(255) NOT NULL DEFAULT '' COMMENT '用户省份',
  `express_dump` varchar(502) NOT NULL DEFAULT '' COMMENT '订单面单打印信息',
  `verify_code` varchar(125) NOT NULL DEFAULT '' COMMENT '核销码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`uid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='积分订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_integral_order_status`
--

DROP TABLE IF EXISTS `eb_store_integral_order_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_integral_order_status` (
  `oid` int unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `change_type` varchar(32) NOT NULL DEFAULT '' COMMENT '操作类型',
  `change_message` varchar(256) NOT NULL DEFAULT '' COMMENT '操作备注',
  `change_time` int unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  KEY `oid` (`oid`) USING BTREE,
  KEY `change_type` (`change_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='积分订单操作记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_order`
--

DROP TABLE IF EXISTS `eb_store_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父类订单id',
  `order_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '订单号',
  `trade_no` varchar(100) NOT NULL DEFAULT '' COMMENT '支付宝订单号',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL DEFAULT '' COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL DEFAULT '' COMMENT '详细地址',
  `cart_id` text COMMENT '购物车id',
  `freight_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '运费金额',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `total_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '支付状态',
  `pay_time` int unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `pay_type` varchar(32) NOT NULL DEFAULT '' COMMENT '支付方式',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态（-1 : 申请退款 -2 : 退货成功 0：待发货；1：待收货；2：已收货；3：待评价；-1：已退款）',
  `is_stock_up` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否备货中',
  `refund_status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '退款申请类型',
  `refund_express` varchar(255) NOT NULL DEFAULT '' COMMENT '退货快递单号',
  `refund_express_name` varchar(255) NOT NULL DEFAULT '' COMMENT '退货快递名称',
  `refund_reason_wap_img` varchar(2000) NOT NULL DEFAULT '' COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) NOT NULL DEFAULT '' COMMENT '退款用户说明',
  `refund_reason_time` int unsigned NOT NULL DEFAULT '0' COMMENT '退款时间',
  `refund_reason_wap` varchar(255) NOT NULL DEFAULT '' COMMENT '前台退款原因',
  `refund_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '不退款的理由',
  `refund_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `delivery_name` varchar(64) NOT NULL DEFAULT '' COMMENT '快递名称/送货人姓名',
  `delivery_code` varchar(50) NOT NULL DEFAULT '' COMMENT '快递公司编码',
  `delivery_type` varchar(32) NOT NULL DEFAULT '' COMMENT '发货类型',
  `delivery_id` varchar(64) NOT NULL DEFAULT '' COMMENT '快递单号/手机号',
  `kuaidi_label` varchar(255) NOT NULL DEFAULT '' COMMENT '快递单号图片',
  `kuaidi_task_id` varchar(64) NOT NULL DEFAULT '' COMMENT '快递单任务id',
  `kuaidi_order_id` varchar(64) NOT NULL DEFAULT '' COMMENT '快递单订单号',
  `fictitious_content` varchar(500) NOT NULL DEFAULT '' COMMENT '虚拟发货内容',
  `delivery_uid` int NOT NULL DEFAULT '0' COMMENT '配送员id',
  `gain_integral` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '消费赚取积分',
  `use_integral` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '使用积分',
  `back_integral` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '给用户退了多少积分',
  `spread_uid` int NOT NULL DEFAULT '0' COMMENT '推广人uid',
  `spread_two_uid` int NOT NULL DEFAULT '0' COMMENT '上上级推广人uid',
  `one_brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '一级返佣金额',
  `two_brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '二级返佣金额',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_cancel` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否取消',
  `unique` char(32) NOT NULL DEFAULT '' COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) NOT NULL DEFAULT '' COMMENT '管理员备注',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '商户上传',
  `combination_id` int unsigned NOT NULL DEFAULT '0' COMMENT '拼团商品id0一般商品',
  `pink_id` int unsigned NOT NULL DEFAULT '0' COMMENT '拼团id 0没有拼团',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `seckill_id` int unsigned NOT NULL DEFAULT '0' COMMENT '秒杀商品ID',
  `bargain_id` int unsigned NOT NULL DEFAULT '0' COMMENT '砍价id',
  `advance_id` int NOT NULL DEFAULT '0' COMMENT '预售商品id',
  `verify_code` varchar(12) NOT NULL DEFAULT '' COMMENT '核销码',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `shipping_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '配送方式 1=快递 ，2=门店自提',
  `clerk_id` int NOT NULL DEFAULT '0' COMMENT '店员id',
  `is_channel` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_remind` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '消息提醒',
  `is_system_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '后台是否删除',
  `channel_type` varchar(255) NOT NULL DEFAULT '' COMMENT '用户访问端标识',
  `province` varchar(255) NOT NULL DEFAULT '' COMMENT '用户省份',
  `express_dump` varchar(502) NOT NULL DEFAULT '' COMMENT '订单面单打印信息',
  `virtual_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '虚拟商品类型',
  `virtual_info` varchar(255) NOT NULL DEFAULT '' COMMENT '虚拟商品信息',
  `pay_uid` int NOT NULL DEFAULT '0' COMMENT '支付用户uid',
  `custom_form` text COMMENT '自定义表单',
  `staff_id` int NOT NULL DEFAULT '0' COMMENT '员工id',
  `agent_id` int NOT NULL DEFAULT '0' COMMENT '代理id',
  `division_id` int NOT NULL DEFAULT '0' COMMENT '事业部id',
  `staff_brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '员工返佣',
  `agent_brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '代理返佣',
  `division_brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '事业部返佣',
  `is_gift` int NOT NULL DEFAULT '0' COMMENT '是否礼品订单',
  `gift_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '礼品附加费',
  `gift_uid` int NOT NULL DEFAULT '0' COMMENT '接受礼品用户uid',
  `gift_mark` varchar(255) NOT NULL DEFAULT '' COMMENT '礼物留言',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`uid`) USING BTREE,
  UNIQUE KEY `unique` (`unique`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `pay_price` (`pay_price`) USING BTREE,
  KEY `paid` (`paid`) USING BTREE,
  KEY `pay_time` (`pay_time`) USING BTREE,
  KEY `pay_type` (`pay_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_order_cart_info`
--

DROP TABLE IF EXISTS `eb_store_order_cart_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_order_cart_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `oid` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `cart_id` varchar(50) NOT NULL DEFAULT '0' COMMENT '购物车id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `old_cart_id` varchar(50) NOT NULL DEFAULT '' COMMENT '拆单前cart_id',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '数量',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款件数',
  `surplus_num` int NOT NULL DEFAULT '0' COMMENT '拆分后剩余数量',
  `split_status` int NOT NULL DEFAULT '0' COMMENT '0:未拆分1:还可以拆分2：拆分完成',
  `cart_info` text COMMENT '购买东西的详细信息',
  `unique` char(32) NOT NULL DEFAULT '' COMMENT '唯一id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `oid` (`oid`,`unique`) USING BTREE,
  KEY `cart_id` (`cart_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='订单购物详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_order_economize`
--

DROP TABLE IF EXISTS `eb_store_order_economize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_order_economize` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` varchar(32) NOT NULL DEFAULT '' COMMENT '订单号',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `order_type` tinyint(1) unsigned zerofill NOT NULL DEFAULT '1' COMMENT '配送方式 1=商品订单 ，2=线下订单',
  `pay_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `postage_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费优惠金额',
  `member_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '会员优惠金额',
  `offline_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '线下优惠金额',
  `coupon_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠券优惠金额',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`,`order_id`,`uid`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`uid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `pay_price` (`pay_price`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户资金节省表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_order_invoice`
--

DROP TABLE IF EXISTS `eb_store_order_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_order_invoice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `category` varchar(10) NOT NULL DEFAULT 'order' COMMENT '开票分类 order:订单',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `invoice_id` int NOT NULL DEFAULT '0' COMMENT '发票id',
  `header_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '抬头类型',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '发票类型',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称（发票抬头）',
  `duty_number` varchar(50) NOT NULL DEFAULT '' COMMENT '税号',
  `drawer_phone` varchar(30) NOT NULL DEFAULT '' COMMENT '开票人手机号',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '开票人邮箱',
  `tell` varchar(30) NOT NULL DEFAULT '' COMMENT '注册电话',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '注册地址',
  `bank` varchar(50) NOT NULL DEFAULT '' COMMENT '开户行',
  `card_number` varchar(50) NOT NULL DEFAULT '' COMMENT '银行卡号',
  `is_pay` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否支付',
  `is_refund` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单是否退款',
  `is_invoice` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开票',
  `invoice_number` varchar(50) NOT NULL DEFAULT '' COMMENT '开票票号',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `invoice_time` int NOT NULL DEFAULT '0' COMMENT '开票时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `unique_num` varchar(255) NOT NULL DEFAULT '' COMMENT '唯一值',
  `invoice_num` varchar(255) NOT NULL DEFAULT '' COMMENT '发票号码',
  `invoice_type` varchar(255) NOT NULL DEFAULT '' COMMENT '发票类型',
  `invoice_serial_number` varchar(255) NOT NULL DEFAULT '' COMMENT '发票流水号',
  `red_invoice_num` varchar(255) NOT NULL DEFAULT '' COMMENT '发票红字编码',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='订单发票表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_order_refund`
--

DROP TABLE IF EXISTS `eb_store_order_refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_order_refund` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `store_order_id` int NOT NULL DEFAULT '0' COMMENT '订单表ID',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店ID',
  `order_id` varchar(50) NOT NULL DEFAULT '' COMMENT '订单号',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户UID',
  `refund_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '退款申请类型',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `refunded_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '已退款金额',
  `refund_phone` varchar(32) NOT NULL DEFAULT '' COMMENT '退款电话',
  `refund_express` varchar(100) NOT NULL DEFAULT '' COMMENT '退货快递单号',
  `refund_express_name` varchar(255) NOT NULL DEFAULT '' COMMENT '退货快递名称',
  `refund_explain` varchar(255) NOT NULL DEFAULT '' COMMENT '退款用户说明',
  `refund_img` text COMMENT '退款图片',
  `refund_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '不退款的理由',
  `refuse_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `refunded_time` int NOT NULL DEFAULT '0' COMMENT '处理时间',
  `cart_info` longtext COMMENT '退款商品信息',
  `is_cancel` tinyint(1) NOT NULL DEFAULT '0' COMMENT '用户是否取消',
  `is_pink_cancel` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否拼团自动取消',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '取消申请',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '申请退款时间',
  `is_system_del` tinyint(1) DEFAULT '0' COMMENT '系统删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='退款订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_order_status`
--

DROP TABLE IF EXISTS `eb_store_order_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_order_status` (
  `oid` int unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `change_type` varchar(32) NOT NULL DEFAULT '' COMMENT '操作类型',
  `change_message` varchar(256) NOT NULL DEFAULT '' COMMENT '操作备注',
  `change_time` int unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  KEY `oid` (`oid`) USING BTREE,
  KEY `change_type` (`change_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='订单操作记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_pink`
--

DROP TABLE IF EXISTS `eb_store_pink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_pink` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `avatar` varchar(256) NOT NULL DEFAULT '' COMMENT '用户头像',
  `order_id` varchar(32) NOT NULL DEFAULT '' COMMENT '订单id 生成',
  `order_id_key` int unsigned NOT NULL DEFAULT '0' COMMENT '订单id  数据库',
  `total_num` int unsigned NOT NULL DEFAULT '0' COMMENT '购买商品个数',
  `total_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '购买总金额',
  `cid` int unsigned NOT NULL DEFAULT '0' COMMENT '拼团商品id',
  `pid` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `people` int unsigned NOT NULL DEFAULT '0' COMMENT '拼图总人数',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '拼团商品单价',
  `add_time` varchar(24) NOT NULL DEFAULT '0' COMMENT '开始时间',
  `stop_time` varchar(24) NOT NULL DEFAULT '0' COMMENT '结束时间',
  `k_id` int unsigned NOT NULL DEFAULT '0' COMMENT '团长id 0为团长',
  `is_tpl` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否发送模板消息0未发送1已发送',
  `is_refund` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否退款 0未退款 1已退款',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态1进行中2已完成3未完成',
  `is_virtual` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否虚拟拼团',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='拼团表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product`
--

DROP TABLE IF EXISTS `eb_store_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product` (
  `id` mediumint NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `mer_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户Id(0为总后台管理员创建,不为0的时候是商户后台创建)',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '商品图片',
  `recommend_image` varchar(256) NOT NULL DEFAULT '' COMMENT '推荐图',
  `slider_image` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图',
  `store_name` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `store_info` varchar(256) NOT NULL DEFAULT '' COMMENT '商品简介',
  `keyword` varchar(256) NOT NULL DEFAULT '' COMMENT '关键字',
  `bar_code` varchar(15) NOT NULL DEFAULT '' COMMENT '商品条码（一维码）',
  `cate_id` varchar(64) NOT NULL DEFAULT '' COMMENT '分类id',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品价格',
  `vip_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '会员价格',
  `ot_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '市场价',
  `postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `unit_name` varchar(32) NOT NULL DEFAULT '' COMMENT '单位名',
  `sort` smallint NOT NULL DEFAULT '0' COMMENT '排序',
  `sales` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `stock` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（0：未上架，1：上架）',
  `is_hot` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否热卖',
  `is_benefit` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否优惠',
  `is_best` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否精品',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否新品',
  `is_virtual` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品是否是虚拟商品',
  `virtual_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '虚拟商品类型',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_postage` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否包邮',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `mer_use` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '商户是否代理 0不可代理1可代理',
  `give_integral` int unsigned NOT NULL DEFAULT '0' COMMENT '获得积分',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `is_seckill` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '秒杀状态 0 未开启 1已开启',
  `is_bargain` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '砍价状态 0未开启 1开启',
  `is_good` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否优品推荐',
  `is_sub` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否单独分佣',
  `is_vip` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启会员价格',
  `ficti` mediumint NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `browse` int NOT NULL DEFAULT '0' COMMENT '浏览量',
  `code_path` varchar(64) NOT NULL DEFAULT '' COMMENT '商品二维码地址(用户小程序海报)',
  `soure_link` varchar(255) NOT NULL DEFAULT '' COMMENT '淘宝京东1688类型',
  `video_link` varchar(500) NOT NULL DEFAULT '' COMMENT '主图视频链接',
  `temp_id` int NOT NULL DEFAULT '1' COMMENT '运费模板ID',
  `spec_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '规格 0单 1多',
  `activity` varchar(255) NOT NULL DEFAULT '' COMMENT '活动显示排序1=秒杀，2=砍价，3=拼团',
  `spu` char(13) NOT NULL DEFAULT '' COMMENT '商品SPU',
  `label_id` varchar(64) NOT NULL DEFAULT '' COMMENT '标签ID',
  `command_word` varchar(255) NOT NULL DEFAULT '' COMMENT '复制口令',
  `recommend_list` varchar(255) NOT NULL DEFAULT '' COMMENT '推荐商品id',
  `vip_product` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否会员专属商品',
  `vip_product_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0仅付费会员可见,1仅付费会员可购买',
  `presale` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否预售商品',
  `presale_start_time` int NOT NULL DEFAULT '0' COMMENT '预售开始时间',
  `presale_end_time` int NOT NULL DEFAULT '0' COMMENT '预售结束时间',
  `presale_day` int NOT NULL DEFAULT '0' COMMENT '预售结束后几天内发货',
  `logistics` varchar(10) NOT NULL DEFAULT '1,2' COMMENT '物流方式',
  `freight` tinyint(1) NOT NULL DEFAULT '2' COMMENT '运费设置',
  `custom_form` varchar(2000) NOT NULL DEFAULT '' COMMENT '自定义表单',
  `is_limit` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启限购',
  `limit_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '限购类型1单次限购2永久限购',
  `limit_num` int NOT NULL DEFAULT '0' COMMENT '限购数量',
  `min_qty` int NOT NULL DEFAULT '1' COMMENT '起购数量',
  `default_sku` varchar(255) NOT NULL DEFAULT '' COMMENT '默认规格',
  `params_list` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品参数',
  `label_list` varchar(255) NOT NULL DEFAULT '' COMMENT '商品标签',
  `protection_list` varchar(255) NOT NULL DEFAULT '' COMMENT '商品保障',
  `is_gift` int NOT NULL DEFAULT '0' COMMENT '是否是礼品',
  `gift_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '礼品附加费',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE,
  KEY `is_hot` (`is_hot`) USING BTREE,
  KEY `is_benefit` (`is_benefit`) USING BTREE,
  KEY `is_best` (`is_best`) USING BTREE,
  KEY `is_new` (`is_new`) USING BTREE,
  KEY `toggle_on_sale, is_del` (`is_del`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `sales` (`sales`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `is_postage` (`is_postage`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104305 DEFAULT CHARSET=utf8mb3 COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_attr`
--

DROP TABLE IF EXISTS `eb_store_product_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_attr` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `attr_name` varchar(32) NOT NULL DEFAULT '' COMMENT '属性名',
  `attr_values` longtext COMMENT '属性值',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  PRIMARY KEY (`id`),
  KEY `store_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7478 DEFAULT CHARSET=utf8mb3 COMMENT='商品属性表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_attr_result`
--

DROP TABLE IF EXISTS `eb_store_product_attr_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_attr_result` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `result` longtext COMMENT '商品属性参数',
  `change_time` int unsigned NOT NULL DEFAULT '0' COMMENT '上次修改时间',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4341 DEFAULT CHARSET=utf8mb3 COMMENT='商品属性详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_attr_value`
--

DROP TABLE IF EXISTS `eb_store_product_attr_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_attr_value` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `suk` varchar(128) NOT NULL DEFAULT '' COMMENT '商品属性索引值 (attr_value|attr_value[|....])',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '属性对应的库存',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '属性金额',
  `image` varchar(128) NOT NULL DEFAULT '' COMMENT '图片',
  `unique` char(8) NOT NULL DEFAULT '' COMMENT '唯一值',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本价',
  `bar_code` varchar(50) NOT NULL DEFAULT '' COMMENT '商品条码',
  `bar_code_number` varchar(50) NOT NULL DEFAULT '' COMMENT '条形码',
  `ot_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '原价',
  `vip_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '会员专享价',
  `weight` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '重量',
  `volume` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '体积',
  `brokerage` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '一级返佣',
  `brokerage_two` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '二级返佣',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '活动类型 0=商品，1=秒杀，2=砍价，3=拼团',
  `quota` int NOT NULL DEFAULT '0' COMMENT '活动限购数量',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '活动限购数量显示',
  `is_virtual` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否虚拟商品',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `disk_info` text COMMENT '虚拟信息内容',
  `is_show` int NOT NULL DEFAULT '1' COMMENT '是否显示',
  `is_default_select` int NOT NULL DEFAULT '0' COMMENT '是否默认规格',
  PRIMARY KEY (`id`),
  KEY `unique` (`unique`,`suk`) USING BTREE,
  KEY `store_id` (`product_id`,`suk`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=151666 DEFAULT CHARSET=utf8mb3 COMMENT='商品属性值表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_cate`
--

DROP TABLE IF EXISTS `eb_store_product_cate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_cate` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `cate_id` bigint NOT NULL DEFAULT '0' COMMENT '分类id',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `cate_pid` bigint NOT NULL DEFAULT '0' COMMENT '一级分类id',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3 COMMENT='商品分类辅助表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_coupon`
--

DROP TABLE IF EXISTS `eb_store_product_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_coupon` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `issue_coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠劵id',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COMMENT='商品关联优惠券表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_description`
--

DROP TABLE IF EXISTS `eb_store_product_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_description` (
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `description` longtext COMMENT '商品详情',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  KEY `product_id` (`product_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_label`
--

DROP TABLE IF EXISTS `eb_store_product_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_label` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `type` int NOT NULL DEFAULT '0' COMMENT '效果设置0自定义1图片',
  `font_color` varchar(255) NOT NULL DEFAULT '' COMMENT '字体颜色',
  `bg_color` varchar(255) NOT NULL DEFAULT '' COMMENT '背景颜色',
  `border_color` varchar(255) NOT NULL DEFAULT '' COMMENT '边框颜色',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `is_show` int NOT NULL DEFAULT '1' COMMENT '移动端展示',
  `status` int NOT NULL DEFAULT '1' COMMENT '是否开启',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品标签';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_label_cate`
--

DROP TABLE IF EXISTS `eb_store_product_label_cate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_label_cate` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品标签分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_log`
--

DROP TABLE IF EXISTS `eb_store_product_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` enum('visit','cart','order','pay','collect','refund') NOT NULL COMMENT '类型',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `visit_num` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否浏览',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '下单数量',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '支付数量',
  `pay_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `cost_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '商品成本价',
  `pay_uid` int NOT NULL DEFAULT '0' COMMENT '支付用户ID',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款数量',
  `refund_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `collect_num` tinyint(1) NOT NULL DEFAULT '0' COMMENT '收藏',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb3 COMMENT='商品统计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_param`
--

DROP TABLE IF EXISTS `eb_store_product_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_param` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '参数名称',
  `value` text COMMENT '参数内容',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  `status` int NOT NULL DEFAULT '1' COMMENT '参数状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品参数表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_protection`
--

DROP TABLE IF EXISTS `eb_store_product_protection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_protection` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(2000) NOT NULL DEFAULT '' COMMENT '内容',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `num` int NOT NULL DEFAULT '0' COMMENT '使用数量',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品保障表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_relation`
--

DROP TABLE IF EXISTS `eb_store_product_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_relation` (
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '类型(收藏(collect）、点赞(like))',
  `category` varchar(32) NOT NULL DEFAULT '' COMMENT '某种类型的商品(普通商品、秒杀商品)',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  UNIQUE KEY `uid` (`uid`,`product_id`,`type`,`category`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `category` (`category`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品点赞和收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_reply`
--

DROP TABLE IF EXISTS `eb_store_product_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_reply` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `oid` int NOT NULL DEFAULT '0' COMMENT '订单ID',
  `unique` char(32) NOT NULL DEFAULT '' COMMENT '唯一id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `reply_type` varchar(32) NOT NULL DEFAULT 'product' COMMENT '某种商品类型(普通商品、秒杀商品）',
  `product_score` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品分数',
  `service_score` tinyint(1) NOT NULL DEFAULT '0' COMMENT '服务分数',
  `comment` varchar(512) NOT NULL DEFAULT '' COMMENT '评论内容',
  `pics` text COMMENT '评论图片',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '评论时间',
  `merchant_reply_content` varchar(300) NOT NULL DEFAULT '' COMMENT '管理员回复内容',
  `merchant_reply_time` int NOT NULL DEFAULT '0' COMMENT '管理员回复时间',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0未删除1已删除',
  `is_reply` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0未回复1已回复',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '用户名称',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '用户头像',
  `suk` varchar(255) NOT NULL DEFAULT '' COMMENT '规格名称',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '评论状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`oid`,`unique`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `parent_id` (`reply_type`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `product_score` (`product_score`) USING BTREE,
  KEY `service_score` (`service_score`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_rule`
--

DROP TABLE IF EXISTS `eb_store_product_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_rule` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `rule_name` varchar(32) NOT NULL DEFAULT '' COMMENT '规格名称',
  `rule_value` text COMMENT '规格值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='商品规则值(规格)表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_product_virtual`
--

DROP TABLE IF EXISTS `eb_store_product_virtual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_product_virtual` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `attr_unique` varchar(20) NOT NULL DEFAULT '' COMMENT '对应商品规格',
  `card_no` varchar(255) NOT NULL DEFAULT '' COMMENT '卡密卡号',
  `card_pwd` varchar(255) NOT NULL DEFAULT '' COMMENT '卡密密码',
  `card_unique` varchar(32) NOT NULL DEFAULT '' COMMENT '虚拟卡密唯一值',
  `order_id` varchar(255) NOT NULL DEFAULT '' COMMENT '购买订单id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '购买人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='虚拟商品卡密表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_seckill`
--

DROP TABLE IF EXISTS `eb_store_seckill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_seckill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品秒杀商品表id',
  `activity_id` int unsigned NOT NULL DEFAULT '0' COMMENT '活动id',
  `product_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '推荐图',
  `images` varchar(2000) NOT NULL DEFAULT '' COMMENT '轮播图',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '活动标题',
  `info` varchar(255) NOT NULL DEFAULT '' COMMENT '简介',
  `price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '价格',
  `cost` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '成本',
  `ot_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '原价',
  `give_integral` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '返多少积分',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `stock` int unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `sales` int unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `unit_name` varchar(16) NOT NULL DEFAULT '' COMMENT '单位名',
  `postage` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `start_time` varchar(128) NOT NULL DEFAULT '' COMMENT '开始时间',
  `stop_time` varchar(128) NOT NULL DEFAULT '' COMMENT '结束时间',
  `add_time` varchar(128) NOT NULL DEFAULT '' COMMENT '添加时间',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '商品状态',
  `is_postage` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否包邮',
  `is_hot` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '热门推荐',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '删除 0未删除1已删除',
  `num` int unsigned NOT NULL DEFAULT '1' COMMENT '最多秒杀几个',
  `is_show` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '显示',
  `time_id` varchar(255) NOT NULL DEFAULT '' COMMENT '时间段ID',
  `temp_id` int NOT NULL DEFAULT '0' COMMENT '运费模板ID',
  `weight` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '商品重量',
  `volume` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '商品体积',
  `quota` int NOT NULL DEFAULT '0' COMMENT '限购总数',
  `quota_show` int NOT NULL DEFAULT '0' COMMENT '限购总数显示',
  `once_num` int NOT NULL DEFAULT '0' COMMENT '单次购买个数',
  `logistics` varchar(10) NOT NULL DEFAULT '1,2' COMMENT '物流类型',
  `freight` tinyint(1) NOT NULL DEFAULT '2' COMMENT '运费设置',
  `custom_form` varchar(2000) NOT NULL DEFAULT '' COMMENT '自定义表单',
  `virtual_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `is_commission` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否返佣',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `start_time` (`start_time`,`stop_time`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `is_hot` (`is_hot`) USING BTREE,
  KEY `is_show` (`status`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `is_postage` (`is_postage`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品秒杀商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_seckill_time`
--

DROP TABLE IF EXISTS `eb_store_seckill_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_seckill_time` (
  `seckill_id` int NOT NULL DEFAULT '0' COMMENT '秒杀活动ID',
  `time_id` int NOT NULL DEFAULT '0' COMMENT '秒杀时间段ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='秒杀时段表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_service`
--

DROP TABLE IF EXISTS `eb_store_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_service` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '客服id',
  `mer_id` int NOT NULL DEFAULT '0' COMMENT '商户id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '客服uid',
  `online` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在线',
  `account` varchar(255) NOT NULL DEFAULT '' COMMENT '账号',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `avatar` varchar(250) NOT NULL DEFAULT '' COMMENT '客服头像',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '代理名称',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '客服电话',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '0隐藏1显示',
  `notify` int NOT NULL DEFAULT '0' COMMENT '订单通知1开启0关闭',
  `customer` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示统计管理',
  `uniqid` varchar(35) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='客服表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_service_feedback`
--

DROP TABLE IF EXISTS `eb_store_service_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_service_feedback` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户UID',
  `rela_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `phone` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '电话',
  `content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '反馈内容',
  `make` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态0=未查看，1=已查看',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='反馈';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_service_log`
--

DROP TABLE IF EXISTS `eb_store_service_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_service_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '客服用户对话记录表ID',
  `mer_id` int NOT NULL DEFAULT '0' COMMENT '商户id',
  `msn` text COMMENT '消息内容',
  `uid` int NOT NULL DEFAULT '1' COMMENT '发送人uid',
  `to_uid` int NOT NULL DEFAULT '1' COMMENT '接收人uid',
  `is_tourist` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1=游客模式，0=非游客',
  `time_node` tinyint(1) NOT NULL DEFAULT '0' COMMENT '时间节点',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '发送时间',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读（0：否；1：是；）',
  `remind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否提醒过',
  `msn_type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '消息类型 1=文字 2=表情 3=图片 4=语音',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='客服用户对话记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_service_record`
--

DROP TABLE IF EXISTS `eb_store_service_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_service_record` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int NOT NULL DEFAULT '0' COMMENT '发送人的uid',
  `to_uid` int NOT NULL DEFAULT '0' COMMENT '送达人的uid',
  `nickname` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '用户昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '用户头像',
  `is_tourist` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是游客',
  `online` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在线',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = pc,1=微信，2=小程序，3=H5',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `mssage_num` int NOT NULL DEFAULT '0' COMMENT '消息条数',
  `message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci COMMENT '内容',
  `message_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息类型',
  PRIMARY KEY (`id`),
  KEY `to_uid` (`to_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='客服聊天用户记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_service_speechcraft`
--

DROP TABLE IF EXISTS `eb_store_service_speechcraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_service_speechcraft` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `kefu_id` int NOT NULL DEFAULT '0' COMMENT '0为全局话术',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '0为不分类全局话术',
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '话术标题',
  `message` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '话术内容',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `kefu_id` (`kefu_id`),
  KEY `cate_id` (`cate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='客服话术';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_store_visit`
--

DROP TABLE IF EXISTS `eb_store_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_store_visit` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `product_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_type` varchar(32) NOT NULL DEFAULT '' COMMENT '商品类型',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '商品分类ID',
  `type` char(50) NOT NULL DEFAULT '' COMMENT '商品类型',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `count` int NOT NULL DEFAULT '0' COMMENT '访问次数',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '备注描述',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COMMENT='商品浏览分析表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_admin`
--

DROP TABLE IF EXISTS `eb_system_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_admin` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT COMMENT '后台管理员表ID',
  `account` varchar(32) NOT NULL DEFAULT '' COMMENT '后台管理员账号',
  `head_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '管理员头像',
  `pwd` varchar(100) NOT NULL DEFAULT '' COMMENT '后台管理员密码',
  `real_name` varchar(16) NOT NULL DEFAULT '' COMMENT '后台管理员姓名',
  `roles` varchar(128) NOT NULL DEFAULT '' COMMENT '后台管理员权限(menus_id)',
  `last_ip` varchar(16) NOT NULL DEFAULT '' COMMENT '后台管理员最后一次登录ip',
  `last_time` int unsigned NOT NULL DEFAULT '0' COMMENT '后台管理员最后一次登录时间',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '后台管理员添加时间',
  `login_count` int unsigned NOT NULL DEFAULT '0' COMMENT '登录次数',
  `level` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '后台管理员级别',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '后台管理员状态 1有效0无效',
  `division_id` int NOT NULL DEFAULT '0' COMMENT '事业部id',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `account` (`account`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='后台管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_attachment`
--

DROP TABLE IF EXISTS `eb_system_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_attachment` (
  `att_id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '附件名称',
  `att_dir` varchar(200) NOT NULL DEFAULT '' COMMENT '附件路径',
  `satt_dir` varchar(200) NOT NULL DEFAULT '' COMMENT '压缩图片路径',
  `att_size` char(30) NOT NULL DEFAULT '' COMMENT '附件大小',
  `att_type` char(30) NOT NULL DEFAULT '' COMMENT '附件类型',
  `pid` int NOT NULL DEFAULT '0' COMMENT '分类ID0编辑器,1商品图片,2拼团图片,3砍价图片,4秒杀图片,5文章图片,6组合数据图',
  `time` int NOT NULL DEFAULT '0' COMMENT '上传时间',
  `image_type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '图片上传类型 1本地 2七牛云 3OSS 4COS ',
  `module_type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '图片上传模块类型 1 后台上传 2 用户生成',
  `real_name` varchar(255) NOT NULL DEFAULT '' COMMENT '原始文件名',
  `scan_token` varchar(32) NOT NULL DEFAULT '' COMMENT '扫码上传的token',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型，0图片，1视频',
  PRIMARY KEY (`att_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb3 COMMENT='附件管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_attachment_category`
--

DROP TABLE IF EXISTS `eb_system_attachment_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_attachment_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级ID',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '分类名称',
  `enname` varchar(50) NOT NULL DEFAULT '' COMMENT '分类目录',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型，0图片，1视频',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COMMENT='附件分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_city`
--

DROP TABLE IF EXISTS `eb_system_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_city` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市id',
  `level` int NOT NULL DEFAULT '0' COMMENT '省市级别',
  `parent_id` int NOT NULL DEFAULT '0' COMMENT '父级id',
  `area_code` varchar(30) NOT NULL DEFAULT '' COMMENT '区号',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称',
  `merger_name` varchar(255) NOT NULL DEFAULT '' COMMENT '合并名称',
  `lng` varchar(50) NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(50) NOT NULL DEFAULT '' COMMENT '纬度',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否展示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3975 DEFAULT CHARSET=utf8mb3 COMMENT='城市表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_config`
--

DROP TABLE IF EXISTS `eb_system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '配置id',
  `menu_name` varchar(255) NOT NULL DEFAULT '' COMMENT '字段名称',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '类型(文本框,单选按钮...)',
  `input_type` varchar(20) NOT NULL DEFAULT 'input' COMMENT '表单类型',
  `config_tab_id` int unsigned NOT NULL DEFAULT '0' COMMENT '配置分类id',
  `parameter` varchar(255) NOT NULL DEFAULT '' COMMENT '规则 单选框和多选框',
  `upload_type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '上传文件格式1单图2多图3文件',
  `required` varchar(255) NOT NULL DEFAULT '' COMMENT '规则',
  `width` int unsigned NOT NULL DEFAULT '0' COMMENT '多行文本框的宽度',
  `high` int unsigned NOT NULL DEFAULT '0' COMMENT '多行文框的高度',
  `value` varchar(5000) NOT NULL DEFAULT '' COMMENT '默认值',
  `info` varchar(255) NOT NULL DEFAULT '' COMMENT '配置名称',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '配置简介',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `level` int NOT NULL DEFAULT '0' COMMENT '配置层级0顶级1次级',
  `link_id` int NOT NULL DEFAULT '0' COMMENT '关联上级配置id',
  `link_value` int NOT NULL DEFAULT '0' COMMENT '关联上级配置的值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=492 DEFAULT CHARSET=utf8mb3 COMMENT='配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_config_tab`
--

DROP TABLE IF EXISTS `eb_system_config_tab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_config_tab` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '配置分类id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '配置分类名称',
  `eng_title` varchar(255) NOT NULL DEFAULT '' COMMENT '配置分类英文名称',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '配置分类状态',
  `info` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '配置分类是否显示',
  `icon` varchar(30) NOT NULL DEFAULT '' COMMENT '图标',
  `type` int NOT NULL DEFAULT '0' COMMENT '配置类型',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `menus_id` int NOT NULL DEFAULT '0' COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb3 COMMENT='配置分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_crud`
--

DROP TABLE IF EXISTS `eb_system_crud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_crud` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pid` int NOT NULL DEFAULT '0' COMMENT '菜单上级id',
  `name` varchar(200) NOT NULL COMMENT '菜单名称',
  `menu_id` int NOT NULL DEFAULT '0' COMMENT '主菜单id',
  `model_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名',
  `table_name` varchar(50) NOT NULL COMMENT '表明',
  `field` text NOT NULL COMMENT '参数内容',
  `menu_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '生成的菜单id',
  `route_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '权限id',
  `make_path` varchar(500) NOT NULL DEFAULT '' COMMENT '文件路径',
  `table_collation` varchar(100) NOT NULL DEFAULT '' COMMENT '字符集',
  `table_comment` varchar(255) NOT NULL DEFAULT '' COMMENT '表备注',
  `add_time` int NOT NULL COMMENT '添加时间',
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='crud生成记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_crud_data`
--

DROP TABLE IF EXISTS `eb_system_crud_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_crud_data` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cid` int NOT NULL DEFAULT '0' COMMENT '列表id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称',
  `value` text NOT NULL COMMENT '数据内容JSON',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='crud数据字典';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_crud_list`
--

DROP TABLE IF EXISTS `eb_system_crud_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_crud_list` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '标识',
  `level` int NOT NULL DEFAULT '0' COMMENT '层级0一级，1多级',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='crud数据字典列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_event`
--

DROP TABLE IF EXISTS `eb_system_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '事件名称',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '标签',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_open` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启',
  `customCode` text NOT NULL COMMENT '执行代码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='自定义事件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_event_data`
--

DROP TABLE IF EXISTS `eb_system_event_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_event_data` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `label` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT '类型',
  `data` text NOT NULL COMMENT '数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COMMENT='事件参数';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_file`
--

DROP TABLE IF EXISTS `eb_system_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_file` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '文件对比ID',
  `cthash` char(32) NOT NULL DEFAULT '' COMMENT '文件内容',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT '文价名称',
  `atime` char(12) NOT NULL DEFAULT '' COMMENT '上次访问时间',
  `mtime` char(12) NOT NULL DEFAULT '' COMMENT '上次修改时间',
  `ctime` char(12) NOT NULL DEFAULT '' COMMENT '上次改变时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文件对比表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_file_info`
--

DROP TABLE IF EXISTS `eb_system_file_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_file_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '目录或文件名称',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '目录或文件路径',
  `full_path` varchar(255) NOT NULL DEFAULT '' COMMENT '完整路径',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT 'dir目录1 ,file文件',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '修改时间',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13189 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文件管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_file_md5`
--

DROP TABLE IF EXISTS `eb_system_file_md5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_file_md5` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径',
  `md5` varchar(255) NOT NULL DEFAULT '' COMMENT '文件md5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1076 DEFAULT CHARSET=utf8mb3 COMMENT='文件md5';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_group`
--

DROP TABLE IF EXISTS `eb_system_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_group` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '组合数据ID',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '数据组名称',
  `info` varchar(256) NOT NULL DEFAULT '' COMMENT '数据提示',
  `config_name` varchar(50) NOT NULL DEFAULT '' COMMENT '数据字段',
  `fields` text COMMENT '数据组字段以及类型（json数据）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `config_name` (`config_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb3 COMMENT='组合数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_group_data`
--

DROP TABLE IF EXISTS `eb_system_group_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_group_data` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '组合数据详情ID',
  `gid` int NOT NULL DEFAULT '0' COMMENT '对应的数据组id',
  `value` text COMMENT '数据组对应的数据值（json数据）',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加数据时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '数据排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（1：开启；2：关闭；）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1073 DEFAULT CHARSET=utf8mb3 COMMENT='组合数据详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_log`
--

DROP TABLE IF EXISTS `eb_system_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '管理员操作记录ID',
  `admin_id` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员id',
  `admin_name` varchar(64) NOT NULL DEFAULT '' COMMENT '管理员姓名',
  `path` varchar(128) NOT NULL DEFAULT '' COMMENT '链接',
  `page` varchar(64) NOT NULL DEFAULT '' COMMENT '行为',
  `method` varchar(12) NOT NULL DEFAULT '' COMMENT '访问类型',
  `ip` varchar(16) NOT NULL DEFAULT '' COMMENT '登录IP',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '类型',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `merchant_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商户id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `admin_id` (`admin_id`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1083 DEFAULT CHARSET=utf8mb3 COMMENT='管理员操作记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_menus`
--

DROP TABLE IF EXISTS `eb_system_menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_menus` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `pid` smallint unsigned NOT NULL DEFAULT '0' COMMENT '父级id',
  `icon` varchar(16) NOT NULL DEFAULT '' COMMENT '图标',
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT '按钮名',
  `module` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT '模块名',
  `controller` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT '控制器',
  `action` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT '方法名',
  `api_url` varchar(100) NOT NULL DEFAULT '' COMMENT 'api接口地址',
  `methods` varchar(10) NOT NULL DEFAULT '' COMMENT '提交方式POST GET PUT DELETE',
  `params` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '[]' COMMENT '参数',
  `sort` tinyint NOT NULL DEFAULT '1' COMMENT '排序',
  `is_show` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '是否为隐藏菜单0=隐藏菜单,1=显示菜单',
  `is_show_path` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为隐藏菜单供前台使用',
  `access` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '子管理员是否可用',
  `menu_path` varchar(128) NOT NULL DEFAULT '' COMMENT '路由名称 前端使用',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '路径',
  `auth_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为菜单 1菜单 2功能',
  `header` varchar(50) NOT NULL DEFAULT '' COMMENT '顶部菜单标示',
  `is_header` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否顶部菜单1是0否',
  `unique_auth` varchar(150) NOT NULL DEFAULT '' COMMENT '前台唯一标识',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `mark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pid` (`pid`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `access` (`access`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3466 DEFAULT CHARSET=utf8mb3 COMMENT='菜单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_notice`
--

DROP TABLE IF EXISTS `eb_system_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_notice` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '通知模板id',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '通知标题',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '通知类型',
  `icon` varchar(16) NOT NULL DEFAULT '' COMMENT '图标',
  `url` varchar(64) NOT NULL DEFAULT '' COMMENT '链接',
  `table_title` varchar(256) NOT NULL DEFAULT '' COMMENT '通知数据',
  `template` varchar(64) NOT NULL DEFAULT '' COMMENT '通知模板',
  `push_admin` varchar(128) NOT NULL DEFAULT '' COMMENT '通知管理员id',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `type` (`type`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='通知模板表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_notice_admin`
--

DROP TABLE IF EXISTS `eb_system_notice_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_notice_admin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '通知记录ID',
  `notice_type` varchar(64) NOT NULL DEFAULT '' COMMENT '通知类型',
  `admin_id` smallint unsigned NOT NULL DEFAULT '0' COMMENT '通知的管理员',
  `link_id` int unsigned NOT NULL DEFAULT '0' COMMENT '关联ID',
  `table_data` text COMMENT '通知的数据',
  `is_click` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '点击次数',
  `is_visit` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '访问次数',
  `visit_time` int NOT NULL DEFAULT '0' COMMENT '访问时间',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '通知时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `admin_id` (`admin_id`,`notice_type`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `is_visit` (`is_visit`) USING BTREE,
  KEY `is_click` (`is_click`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='通知记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_notification`
--

DROP TABLE IF EXISTS `eb_system_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_notification` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `mark` varchar(50) NOT NULL DEFAULT '' COMMENT '标识',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '通知类型',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '通知场景说明',
  `is_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT '站内信（0：不存在，1：开启，2：关闭）',
  `system_title` varchar(256) NOT NULL DEFAULT '' COMMENT '站内信标题',
  `system_text` varchar(512) NOT NULL DEFAULT '' COMMENT '系统消息id',
  `is_wechat` tinyint(1) NOT NULL DEFAULT '0' COMMENT '公众号模板消息（0：不存在，1：开启，2：关闭）',
  `wechat_tempkey` varchar(255) NOT NULL DEFAULT '' COMMENT '模版消息tempkey',
  `wechat_content` varchar(255) NOT NULL DEFAULT '' COMMENT '模版消息内容',
  `wechat_kid` varchar(255) NOT NULL DEFAULT '' COMMENT '模版消息kid',
  `wechat_tempid` varchar(255) NOT NULL DEFAULT '' COMMENT '模版消息tempid',
  `wechat_data` varchar(255) NOT NULL DEFAULT '' COMMENT '模版消息参数',
  `wechat_link` varchar(255) NOT NULL DEFAULT '' COMMENT '模版消息链接',
  `wechat_to_routine` int NOT NULL DEFAULT '0' COMMENT '模版消息跳转小程序',
  `is_routine` tinyint(1) NOT NULL DEFAULT '0' COMMENT '小程序订阅消息（0：不存在，1：开启，2：关闭）',
  `routine_tempkey` varchar(255) NOT NULL DEFAULT '' COMMENT '订阅消息id',
  `routine_content` varchar(255) NOT NULL DEFAULT '' COMMENT '订阅消息内容',
  `routine_kid` varchar(255) NOT NULL DEFAULT '' COMMENT '订阅消息kid',
  `routine_tempid` varchar(255) NOT NULL DEFAULT '' COMMENT '订阅消息tempid',
  `routine_data` varchar(255) NOT NULL DEFAULT '' COMMENT '订阅消息参数',
  `routine_link` varchar(255) NOT NULL DEFAULT '' COMMENT '订阅消息链接',
  `is_sms` tinyint(1) NOT NULL DEFAULT '0' COMMENT '发送短信（0：不存在，1：开启，2：关闭）',
  `sms_id` varchar(32) NOT NULL DEFAULT '' COMMENT '短信id',
  `sms_text` varchar(255) NOT NULL DEFAULT '' COMMENT '短信模版内容',
  `is_ent_wechat` tinyint(1) NOT NULL DEFAULT '0' COMMENT '企业微信群通知（0：不存在，1：开启，2：关闭）',
  `ent_wechat_text` varchar(512) NOT NULL DEFAULT '' COMMENT '企业微信消息',
  `url` varchar(512) NOT NULL DEFAULT '' COMMENT '群机器人链接',
  `is_app` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'APP推送（0：不存在，1：开启，2：关闭）',
  `app_id` int NOT NULL DEFAULT '0' COMMENT 'app推送id',
  `variable` varchar(256) NOT NULL DEFAULT '' COMMENT '变量',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型（1：用户，2：管理员）',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `custom_trigger` varchar(255) NOT NULL DEFAULT '' COMMENT '自定义消息触发位置',
  `custom_variable` varchar(1000) NOT NULL DEFAULT '' COMMENT '自定义消息变量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3 COMMENT='通知设置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_pem`
--

DROP TABLE IF EXISTS `eb_system_pem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_pem` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '证书类型',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '证书名称',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '证书文件名',
  `content` text COMMENT '证书内容',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='证书表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_role`
--

DROP TABLE IF EXISTS `eb_system_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_role` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '身份管理id',
  `role_name` varchar(32) NOT NULL DEFAULT '' COMMENT '身份管理名称',
  `rules` text COMMENT '身份管理权限(menus_id)',
  `level` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '管理员等级',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='身份管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_route`
--

DROP TABLE IF EXISTS `eb_system_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_route` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类',
  `app_name` varchar(20) NOT NULL DEFAULT 'api' COMMENT '应用名',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '路由名称',
  `describe` text NOT NULL COMMENT '功能描述',
  `path` varchar(100) NOT NULL DEFAULT '' COMMENT '路由路径',
  `method` enum('POST','GET','DELETE','PUT','*') NOT NULL DEFAULT 'GET' COMMENT '路由请求方式',
  `file_path` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径',
  `action` varchar(255) NOT NULL DEFAULT '' COMMENT '方法名称',
  `query` longtext NOT NULL COMMENT 'get请求参数',
  `header` longtext NOT NULL COMMENT 'header',
  `request` longtext NOT NULL COMMENT '请求数据',
  `request_type` varchar(100) NOT NULL DEFAULT '' COMMENT '请求类型',
  `response` longtext NOT NULL COMMENT '返回数据',
  `request_example` longtext NOT NULL COMMENT '请求示例',
  `response_example` longtext NOT NULL COMMENT '返回示例',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型',
  `add_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `delete_time` timestamp NULL DEFAULT NULL COMMENT '删除字段',
  `error_code` longtext NOT NULL COMMENT '错误码',
  PRIMARY KEY (`id`),
  KEY `path` (`path`)
) ENGINE=InnoDB AUTO_INCREMENT=1698 DEFAULT CHARSET=utf8mb3 COMMENT='路由规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_route_cate`
--

DROP TABLE IF EXISTS `eb_system_route_cate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_route_cate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级id',
  `app_name` varchar(20) NOT NULL DEFAULT '' COMMENT '应用名',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `mark` varchar(32) NOT NULL DEFAULT '' COMMENT '分组标识',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '路径',
  `sort` int NOT NULL DEFAULT '0',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `app_name` (`app_name`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb3 COMMENT='路由规分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_sign_reward`
--

DROP TABLE IF EXISTS `eb_system_sign_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_sign_reward` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型，0连续签到奖励，1累计签到奖励',
  `days` int NOT NULL DEFAULT '0' COMMENT '天数',
  `point` int NOT NULL DEFAULT '0' COMMENT '赠送积分',
  `exp` int NOT NULL DEFAULT '0' COMMENT '赠送经验',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COMMENT='系统签到奖励表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_storage`
--

DROP TABLE IF EXISTS `eb_system_storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_storage` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `access_key` varchar(100) NOT NULL DEFAULT '' COMMENT 'access_key',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=本地存储,2=七牛,3=oss,4=cos',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '空间名',
  `region` varchar(100) NOT NULL DEFAULT '' COMMENT '地域',
  `acl` enum('private','public-read','public-read-write') NOT NULL DEFAULT 'public-read' COMMENT '权限',
  `domain` varchar(100) NOT NULL DEFAULT '' COMMENT '空间域名',
  `cdn` varchar(255) NOT NULL DEFAULT '' COMMENT 'CDN加速域名',
  `cname` varchar(255) NOT NULL DEFAULT '' COMMENT 'CNAME值',
  `is_ssl` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=http,1=https',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL COMMENT '添加事件',
  `update_time` int NOT NULL COMMENT '更新事件',
  PRIMARY KEY (`id`),
  KEY `is_delete` (`is_delete`),
  KEY `status` (`status`),
  KEY `access_key` (`access_key`,`type`,`is_delete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='云储存';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_store`
--

DROP TABLE IF EXISTS `eb_system_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_store` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '门店名称',
  `introduction` varchar(1000) NOT NULL DEFAULT '' COMMENT '简介',
  `phone` char(25) NOT NULL DEFAULT '' COMMENT '手机号码',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '省市区',
  `detailed_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '门店logo',
  `oblong_image` varchar(255) NOT NULL DEFAULT '' COMMENT '门店推荐图',
  `latitude` char(25) NOT NULL DEFAULT '' COMMENT '纬度',
  `longitude` char(25) NOT NULL DEFAULT '' COMMENT '经度',
  `valid_time` varchar(100) NOT NULL DEFAULT '' COMMENT '核销有效日期',
  `day_time` varchar(100) NOT NULL DEFAULT '' COMMENT '每日营业开关时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_show` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='门店自提';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_store_staff`
--

DROP TABLE IF EXISTS `eb_system_store_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_store_staff` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '微信用户id',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '店员头像',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `staff_name` varchar(64) NOT NULL DEFAULT '' COMMENT '店员名称',
  `phone` char(15) NOT NULL DEFAULT '' COMMENT '手机号码',
  `verify_status` tinyint NOT NULL DEFAULT '0' COMMENT '核销开关',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='门店店员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_ticket`
--

DROP TABLE IF EXISTS `eb_system_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_ticket` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '平台选择，1易联云，2飞鹅云',
  `print_name` varchar(255) NOT NULL DEFAULT '' COMMENT '打印机名称',
  `yly_user_id` varchar(255) NOT NULL DEFAULT '' COMMENT '易联云用户id',
  `yly_app_id` varchar(255) NOT NULL DEFAULT '' COMMENT '易联云应用ID',
  `yly_app_secret` varchar(255) NOT NULL DEFAULT '' COMMENT '易联云应用密钥',
  `yly_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '易联云终端号',
  `fey_user` varchar(255) NOT NULL DEFAULT '' COMMENT '飞鹅云user',
  `fey_ukey` varchar(255) NOT NULL DEFAULT '' COMMENT '飞鹅云ukey',
  `fey_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '飞鹅云SN',
  `times` int NOT NULL DEFAULT '0' COMMENT '打印联数',
  `print_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '打印时机，1支付后，2下单后',
  `print_content` longtext COMMENT '打印内容',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '申请状态，0关闭，1开启',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='小票打印机列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_timer`
--

DROP TABLE IF EXISTS `eb_system_timer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_timer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '定时器名称',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '标签',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '说明',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '周期状态 1=每隔多少秒 2=每隔多少分钟 3=每隔多少小时 4=每隔多少天 5=每天几点执行 6=每周周几几点执行 7=每月几号几点执行',
  `month` int NOT NULL DEFAULT '0' COMMENT '月',
  `week` int NOT NULL DEFAULT '0' COMMENT '周',
  `day` int NOT NULL DEFAULT '0' COMMENT '日',
  `hour` int NOT NULL DEFAULT '0' COMMENT '时',
  `minute` int NOT NULL DEFAULT '0' COMMENT '分',
  `second` int NOT NULL DEFAULT '0' COMMENT '秒',
  `last_execution_time` int NOT NULL DEFAULT '0' COMMENT '上次执行时间',
  `next_execution_time` int NOT NULL DEFAULT '0' COMMENT '下次执行时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_open` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启',
  `customCode` text NOT NULL COMMENT '执行代码',
  `timeStr` varchar(255) NOT NULL DEFAULT '' COMMENT '时间代码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COMMENT='定时器';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_system_user_level`
--

DROP TABLE IF EXISTS `eb_system_user_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_system_user_level` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `mer_id` int NOT NULL DEFAULT '0' COMMENT '商户id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '会员名称',
  `money` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '购买金额',
  `valid_date` int NOT NULL DEFAULT '0' COMMENT '有效时间',
  `is_forever` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为永久会员',
  `is_pay` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否购买,1=购买,0=不购买',
  `is_show` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示 1=显示,0=隐藏',
  `grade` int NOT NULL DEFAULT '0' COMMENT '会员等级',
  `discount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '享受折扣',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '会员卡背景',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '会员图标',
  `explain` text COMMENT '说明',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除.1=删除,0=未删除',
  `exp_num` int NOT NULL DEFAULT '0' COMMENT '升级经验',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COMMENT='设置用户等级表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_theme`
--

DROP TABLE IF EXISTS `eb_theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_theme` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `version` varchar(255) NOT NULL DEFAULT '' COMMENT '版本号',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '主题名称',
  `info` varchar(255) NOT NULL DEFAULT '' COMMENT '主题简介',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '主题类型，0:自建主题，1:广场主题',
  `home_data` longtext COMMENT '首页数据',
  `home_image` varchar(255) NOT NULL DEFAULT '' COMMENT '首页图片',
  `home_data_id` int NOT NULL DEFAULT '0' COMMENT '首页数据来源id',
  `home_data_update_time` int NOT NULL DEFAULT '0' COMMENT '首页数据更新时间',
  `category_data` longtext COMMENT '分类页数据',
  `category_image` varchar(255) NOT NULL DEFAULT '' COMMENT '分类页图片',
  `category_data_id` int NOT NULL DEFAULT '0' COMMENT '分类页数据来源id',
  `category_data_update_time` int NOT NULL DEFAULT '0' COMMENT '分类页数据更新时间',
  `detail_data` longtext COMMENT '商品详情页数据',
  `detail_image` varchar(255) NOT NULL DEFAULT '' COMMENT '商城详情页图片',
  `detail_data_id` int NOT NULL DEFAULT '0' COMMENT '商品详情页数据来源id',
  `detail_data_update_time` int NOT NULL DEFAULT '0' COMMENT '商品详情页数据更新时间',
  `user_data` longtext COMMENT '个人中心数据',
  `user_image` varchar(255) NOT NULL DEFAULT '' COMMENT '个人中心图片',
  `user_data_id` int NOT NULL DEFAULT '0' COMMENT '个人中心数据来源id',
  `user_data_update_time` int NOT NULL DEFAULT '0' COMMENT '个人中心数据更新时间',
  `theme_data` longtext COMMENT '主题风格数据',
  `theme_data_id` int NOT NULL DEFAULT '0' COMMENT '主题风格数据来源id',
  `theme_data_update_time` int NOT NULL DEFAULT '0' COMMENT '主题风格数据更新时间',
  `home_default_data` longtext COMMENT '首页默认数据',
  `home_default_image` varchar(255) NOT NULL DEFAULT '' COMMENT '首页默认图片',
  `category_default_data` longtext COMMENT '分类页默认数据',
  `category_default_image` varchar(255) NOT NULL DEFAULT '' COMMENT '分类页默认图片',
  `detail_default_data` longtext COMMENT '商品详情页默认数据',
  `detail_default_image` varchar(255) NOT NULL DEFAULT '' COMMENT '商城详情页默认图片',
  `user_default_data` longtext COMMENT '个人中心默认数据',
  `user_default_image` varchar(255) NOT NULL DEFAULT '' COMMENT '个人中心默认图片',
  `theme_default_data` longtext COMMENT '主题风格默认数据',
  `page_type` varchar(255) NOT NULL DEFAULT 'theme' COMMENT '页面类型：theme主题，micro微页面',
  `is_use` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否使用',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `up_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COMMENT='主题表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_theme_download`
--

DROP TABLE IF EXISTS `eb_theme_download`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_theme_download` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '模版名称',
  `tid` int NOT NULL DEFAULT '0' COMMENT '模版ID',
  `download_time` int NOT NULL DEFAULT '0' COMMENT '下载时间',
  `download_url` varchar(500) NOT NULL DEFAULT '' COMMENT '下载地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主题下载记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_upgrade_log`
--

DROP TABLE IF EXISTS `eb_upgrade_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_upgrade_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(120) NOT NULL DEFAULT '' COMMENT '标题说明',
  `content` text NOT NULL COMMENT '更新内容',
  `first_version` char(3) NOT NULL DEFAULT '' COMMENT '版本号第一位',
  `second_version` char(3) NOT NULL DEFAULT '' COMMENT '版本号第二位',
  `third_version` char(3) NOT NULL DEFAULT '' COMMENT '版本号第三位',
  `fourth_version` char(3) NOT NULL DEFAULT '' COMMENT '版本号第四位',
  `error_data` text NOT NULL COMMENT '错误内容',
  `upgrade_time` int NOT NULL DEFAULT '0' COMMENT '升级时间',
  `package_link` varchar(255) NOT NULL DEFAULT '' COMMENT '文件备份地址',
  `data_link` varchar(255) NOT NULL DEFAULT '' COMMENT '数据备份地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='升级记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user`
--

DROP TABLE IF EXISTS `eb_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user` (
  `uid` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `account` varchar(32) NOT NULL DEFAULT '' COMMENT '用户账号',
  `pwd` varchar(32) NOT NULL DEFAULT '' COMMENT '用户密码',
  `real_name` varchar(25) NOT NULL DEFAULT '' COMMENT '真实姓名',
  `birthday` int NOT NULL DEFAULT '0' COMMENT '生日',
  `card_id` varchar(20) NOT NULL DEFAULT '' COMMENT '身份证号码',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '用户备注',
  `partner_id` int NOT NULL DEFAULT '0' COMMENT '合伙人id',
  `group_id` int NOT NULL DEFAULT '0' COMMENT '用户分组id',
  `nickname` varchar(60) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `avatar` varchar(256) NOT NULL DEFAULT '' COMMENT '用户头像',
  `phone` char(15) NOT NULL DEFAULT '' COMMENT '手机号码',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `add_ip` varchar(16) NOT NULL DEFAULT '' COMMENT '添加ip',
  `last_time` int unsigned NOT NULL DEFAULT '0' COMMENT '最后一次登录时间',
  `last_ip` varchar(16) NOT NULL DEFAULT '' COMMENT '最后一次登录ip',
  `now_money` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '用户余额',
  `brokerage_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '佣金金额',
  `integral` int unsigned NOT NULL DEFAULT '0' COMMENT '用户剩余积分',
  `exp` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '会员经验',
  `sign_num` int NOT NULL DEFAULT '0' COMMENT '连续签到天数',
  `sign_remind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '签到提醒状态',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1为正常，0为禁止',
  `level` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `agent_level` int NOT NULL DEFAULT '0' COMMENT '分销等级',
  `spread_open` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有推广资格',
  `spread_uid` int unsigned NOT NULL DEFAULT '0' COMMENT '推广元id',
  `spread_time` int unsigned NOT NULL DEFAULT '0' COMMENT '推广员关联时间',
  `user_type` varchar(32) NOT NULL DEFAULT '' COMMENT '用户类型',
  `is_promoter` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否为推广员',
  `pay_count` int unsigned NOT NULL DEFAULT '0' COMMENT '用户购买次数',
  `spread_count` int NOT NULL DEFAULT '0' COMMENT '下级人数',
  `clean_time` int NOT NULL DEFAULT '0' COMMENT '清理会员时间',
  `addres` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `adminid` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员编号 ',
  `login_type` varchar(36) NOT NULL DEFAULT '' COMMENT '用户登陆类型，h5,wechat,routine',
  `record_phone` varchar(11) NOT NULL DEFAULT '0' COMMENT '记录临时电话',
  `is_money_level` tinyint(1) NOT NULL DEFAULT '0' COMMENT '会员来源  0: 购买商品升级   1：花钱购买的会员2: 会员卡领取',
  `is_ever_level` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否永久性会员  0: 非永久会员  1：永久会员',
  `overdue_time` bigint NOT NULL DEFAULT '0' COMMENT '会员到期时间',
  `uniqid` varchar(32) NOT NULL DEFAULT '' COMMENT '用户唯一值',
  `division_name` varchar(255) NOT NULL DEFAULT '' COMMENT '事业部/代理商名称',
  `division_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '代理类型：0普通，1事业部，2代理，3员工',
  `division_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '代理状态',
  `is_division` tinyint(1) NOT NULL DEFAULT '0' COMMENT '事业部状态',
  `is_agent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '代理状态',
  `is_staff` tinyint(1) NOT NULL DEFAULT '0' COMMENT '员工状态',
  `division_id` int NOT NULL DEFAULT '0' COMMENT '事业部id',
  `agent_id` int NOT NULL DEFAULT '0' COMMENT '代理商id',
  `staff_id` int NOT NULL DEFAULT '0' COMMENT '员工id',
  `division_percent` int NOT NULL DEFAULT '0' COMMENT '分佣比例',
  `division_change_time` int NOT NULL DEFAULT '0' COMMENT '事业部/代理/员工修改时间',
  `division_end_time` int NOT NULL DEFAULT '0' COMMENT '事业部/代理/员工结束时间',
  `division_invite` int NOT NULL DEFAULT '0' COMMENT '代理商邀请码',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否注销',
  PRIMARY KEY (`uid`) USING BTREE,
  KEY `account` (`account`) USING BTREE,
  KEY `spreaduid` (`spread_uid`) USING BTREE,
  KEY `level` (`level`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_promoter` (`is_promoter`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_address`
--

DROP TABLE IF EXISTS `eb_user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_address` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户地址id',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `phone` varchar(16) NOT NULL DEFAULT '' COMMENT '收货人电话',
  `province` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人所在省',
  `city` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人所在市',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市id',
  `district` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人所在区',
  `detail` varchar(256) NOT NULL DEFAULT '' COMMENT '收货人详细地址',
  `post_code` int unsigned NOT NULL DEFAULT '0' COMMENT '邮编',
  `longitude` varchar(16) NOT NULL DEFAULT '0' COMMENT '经度',
  `latitude` varchar(16) NOT NULL DEFAULT '0' COMMENT '纬度',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否默认',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `is_default` (`is_default`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='用户地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_bill`
--

DROP TABLE IF EXISTS `eb_user_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户账单id',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `link_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '关联id',
  `pm` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '账单标题',
  `category` varchar(64) NOT NULL DEFAULT '' COMMENT '明细种类',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '明细类型',
  `number` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '明细数字',
  `balance` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '剩余',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 = 带确定 1 = 有效 -1 = 无效',
  `take` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 未收货 1 = 已收货',
  `frozen_time` int NOT NULL DEFAULT '0' COMMENT '积分冻结时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `openid` (`uid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `pm` (`pm`) USING BTREE,
  KEY `type` (`category`,`type`,`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='用户账单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_brokerage`
--

DROP TABLE IF EXISTS `eb_user_brokerage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_brokerage` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户佣金id',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `link_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '关联id',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '明细类型',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '账单标题',
  `number` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '明细数字',
  `balance` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '剩余',
  `pm` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 = 带确定 1 = 有效 -1 = 无效',
  `take` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 未收货 1 = 已收货',
  `frozen_time` int unsigned NOT NULL DEFAULT '0' COMMENT '冻结到期时间',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `pm` (`pm`) USING BTREE,
  KEY `type` (`type`,`link_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户分佣账单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_brokerage_frozen`
--

DROP TABLE IF EXISTS `eb_user_brokerage_frozen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_brokerage_frozen` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `uill_id` int NOT NULL DEFAULT '0' COMMENT '关联id',
  `frozen_time` int NOT NULL DEFAULT '0' COMMENT '冻结到期时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否有效',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `order_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '' COMMENT '订单id',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='用户佣金冻结记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_cancel`
--

DROP TABLE IF EXISTS `eb_user_cancel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_cancel` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '用户提交申请时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1通过，2拒绝',
  `up_time` int NOT NULL DEFAULT '0' COMMENT '操作时间',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户注销表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_enter`
--

DROP TABLE IF EXISTS `eb_user_enter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_enter` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商户申请ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `province` varchar(32) NOT NULL DEFAULT '' COMMENT '商户所在省',
  `city` varchar(32) NOT NULL DEFAULT '' COMMENT '商户所在市',
  `district` varchar(32) NOT NULL DEFAULT '' COMMENT '商户所在区',
  `address` varchar(256) NOT NULL DEFAULT '' COMMENT '商户详细地址',
  `merchant_name` varchar(256) NOT NULL DEFAULT '' COMMENT '商户名称',
  `link_user` varchar(32) NOT NULL DEFAULT '' COMMENT '关联用户',
  `link_tel` varchar(16) NOT NULL DEFAULT '' COMMENT '商户电话',
  `charter` varchar(512) NOT NULL DEFAULT '' COMMENT '商户证书',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `apply_time` int unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `success_time` int NOT NULL DEFAULT '0' COMMENT '通过时间',
  `fail_message` varchar(256) NOT NULL DEFAULT '' COMMENT '未通过原因',
  `fail_time` int unsigned NOT NULL DEFAULT '0' COMMENT '未通过时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '-1 审核未通过 0未审核 1审核通过',
  `is_lock` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 = 开启 1= 关闭',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `province` (`province`,`city`,`district`) USING BTREE,
  KEY `is_lock` (`is_lock`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商户申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_extract`
--

DROP TABLE IF EXISTS `eb_user_extract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_extract` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `wechat_order_id` varchar(32) NOT NULL DEFAULT '' COMMENT '微信订单ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
  `user_name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `extract_type` varchar(32) NOT NULL DEFAULT 'bank' COMMENT 'bank = 银行卡 alipay = 支付宝wx=微信',
  `bank_code` varchar(32) NOT NULL DEFAULT '0' COMMENT '银行卡',
  `bank_address` varchar(256) NOT NULL DEFAULT '' COMMENT '开户地址',
  `alipay_code` varchar(64) NOT NULL DEFAULT '' COMMENT '支付宝账号',
  `extract_price` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '提现金额',
  `extract_fee` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '提现手续费',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `balance` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '提现前佣金',
  `fail_msg` varchar(128) NOT NULL DEFAULT '' COMMENT '无效原因',
  `fail_time` int unsigned NOT NULL DEFAULT '0' COMMENT '无效时间',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '-1 未通过 0 审核中 1 已提现',
  `wechat` varchar(50) NOT NULL DEFAULT '' COMMENT '微信号',
  `qrcode_url` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码地址',
  `channel_type` varchar(32) NOT NULL DEFAULT '' COMMENT '提现来源',
  `out_bill_no` varchar(255) NOT NULL DEFAULT '' COMMENT '商户单号',
  `transfer_bill_no` varchar(255) NOT NULL DEFAULT '' COMMENT '微信转账单号',
  `state` varchar(32) NOT NULL DEFAULT '' COMMENT '单据状态',
  `package_info` varchar(2000) NOT NULL DEFAULT '' COMMENT '跳转领取页面的package信息',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `extract_type` (`extract_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `openid` (`uid`) USING BTREE,
  KEY `fail_time` (`fail_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户提现表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_friends`
--

DROP TABLE IF EXISTS `eb_user_friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_friends` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `friends_uid` int NOT NULL DEFAULT '0' COMMENT '好友uid',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='用户好友关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_group`
--

DROP TABLE IF EXISTS `eb_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_group` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `group_name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户分组名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COMMENT='用户分组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_invoice`
--

DROP TABLE IF EXISTS `eb_user_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_invoice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `header_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '抬头类型1:个人2：企业',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '发票类型1：普通2：专用',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称（发票抬头）',
  `duty_number` varchar(50) NOT NULL DEFAULT '' COMMENT '税号',
  `drawer_phone` varchar(30) NOT NULL DEFAULT '' COMMENT '开票人手机号',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '开票人邮箱',
  `tell` varchar(30) NOT NULL DEFAULT '' COMMENT '注册电话',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '注册地址',
  `bank` varchar(50) NOT NULL DEFAULT '' COMMENT '注册开户银行',
  `card_number` varchar(50) NOT NULL DEFAULT '' COMMENT '银行卡号',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户发票管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_label`
--

DROP TABLE IF EXISTS `eb_user_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_label` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `label_cate` int NOT NULL DEFAULT '0' COMMENT '标签分类',
  `label_name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  PRIMARY KEY (`id`),
  KEY `label_cate` (`label_cate`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3 COMMENT='用户标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_label_relation`
--

DROP TABLE IF EXISTS `eb_user_label_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_label_relation` (
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户ID',
  `label_id` int NOT NULL DEFAULT '0' COMMENT '标签ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户标签关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_level`
--

DROP TABLE IF EXISTS `eb_user_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_level` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `level_id` int NOT NULL DEFAULT '0' COMMENT '等级vip',
  `grade` int NOT NULL DEFAULT '0' COMMENT '会员等级',
  `valid_time` int NOT NULL DEFAULT '0' COMMENT '过期时间',
  `is_forever` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否永久',
  `mer_id` int NOT NULL DEFAULT '0' COMMENT '商户id',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0:禁止,1:正常',
  `mark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `remind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已通知',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除,0=未删除,1=删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `discount` int NOT NULL DEFAULT '0' COMMENT '享受折扣',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='用户等级记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_money`
--

DROP TABLE IF EXISTS `eb_user_money`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_money` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户余额id',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '用户uid',
  `link_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '关联id',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT '明细类型',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '账单标题',
  `number` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '明细数字',
  `balance` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '剩余',
  `pm` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `mark` varchar(512) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 = 带确定 1 = 有效 -1 = 无效',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `pm` (`pm`) USING BTREE,
  KEY `type` (`type`,`link_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='用户余额账单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_notice`
--

DROP TABLE IF EXISTS `eb_user_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_notice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` text COMMENT '接收消息的用户id（类型：json数据）',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '消息通知类型（1：系统消息；2：用户通知）',
  `user` varchar(20) NOT NULL DEFAULT '' COMMENT '发送人',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '通知消息的标题信息',
  `content` varchar(500) NOT NULL DEFAULT '' COMMENT '通知消息的内容',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '通知消息发送的时间',
  `is_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发送（0：未发送；1：已发送）',
  `send_time` int NOT NULL DEFAULT '0' COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户通知表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_notice_see`
--

DROP TABLE IF EXISTS `eb_user_notice_see`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_notice_see` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `nid` int NOT NULL DEFAULT '0' COMMENT '查看的通知id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '查看通知的用户id',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '查看通知的时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户通知发送记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_recharge`
--

DROP TABLE IF EXISTS `eb_user_recharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_recharge` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '充值用户UID',
  `order_id` varchar(32) NOT NULL DEFAULT '' COMMENT '订单号',
  `trade_no` varchar(100) NOT NULL DEFAULT '' COMMENT '微信订单号',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '充值金额',
  `give_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '购买赠送金额',
  `recharge_type` varchar(32) NOT NULL DEFAULT '' COMMENT '充值类型',
  `paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否充值',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '充值支付时间',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '充值时间',
  `refund_price` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `channel_type` varchar(255) NOT NULL DEFAULT '' COMMENT '用户访问端标识',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id` (`order_id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `recharge_type` (`recharge_type`) USING BTREE,
  KEY `paid` (`paid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户充值表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_search`
--

DROP TABLE IF EXISTS `eb_user_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_search` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `keyword` varchar(255) NOT NULL DEFAULT '' COMMENT '搜索关键词',
  `vicword` varchar(1000) NOT NULL DEFAULT '' COMMENT '关键词分词',
  `num` int NOT NULL DEFAULT '1' COMMENT '搜索次数',
  `result` text COMMENT '搜索结果',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COMMENT='用户搜索记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_sign`
--

DROP TABLE IF EXISTS `eb_user_sign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_sign` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '签到说明',
  `number` int NOT NULL DEFAULT '0' COMMENT '获得积分',
  `balance` int NOT NULL DEFAULT '0' COMMENT '剩余积分',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='签到记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_spread`
--

DROP TABLE IF EXISTS `eb_user_spread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_spread` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `spread_uid` int NOT NULL DEFAULT '0' COMMENT '推广人uid',
  `spread_time` int NOT NULL DEFAULT '0' COMMENT '推广时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE,
  KEY `spread_uid` (`spread_uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户推广关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_user_visit`
--

DROP TABLE IF EXISTS `eb_user_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_user_visit` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户uid',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '访问路径',
  `ip` varchar(255) NOT NULL DEFAULT '' COMMENT '用户ip',
  `stay_time` int NOT NULL DEFAULT '0' COMMENT '页面停留时间(秒)',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '访问时间',
  `channel_type` varchar(255) NOT NULL DEFAULT '' COMMENT '用户访问端标识',
  `province` varchar(255) NOT NULL DEFAULT '' COMMENT '用户省份',
  PRIMARY KEY (`id`),
  KEY `time` (`channel_type`,`add_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户访问表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_key`
--

DROP TABLE IF EXISTS `eb_wechat_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_key` (
  `id` mediumint NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `reply_id` mediumint NOT NULL DEFAULT '0' COMMENT '回复内容id',
  `keys` varchar(64) NOT NULL DEFAULT '' COMMENT '关键词',
  `key_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '回复类型，0公众号自动回复，1客服自动回复',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='微信回复关键词辅助表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_media`
--

DROP TABLE IF EXISTS `eb_wechat_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_media` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '微信视频音频id',
  `type` varchar(16) NOT NULL DEFAULT '' COMMENT '回复类型',
  `path` varchar(128) NOT NULL DEFAULT '' COMMENT '文件路径',
  `media_id` varchar(64) NOT NULL DEFAULT '' COMMENT '微信服务器返回的id',
  `url` varchar(256) NOT NULL DEFAULT '' COMMENT '地址',
  `temporary` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否永久或者临时 0永久1临时',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `type` (`type`,`media_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='微信回复表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_message`
--

DROP TABLE IF EXISTS `eb_wechat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_message` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用户行为记录id',
  `openid` varchar(32) NOT NULL DEFAULT '' COMMENT '用户openid',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '操作类型',
  `result` varchar(512) NOT NULL DEFAULT '' COMMENT '操作详细记录',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `openid` (`openid`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户行为记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_news_category`
--

DROP TABLE IF EXISTS `eb_wechat_news_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_news_category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '图文消息管理ID',
  `cate_name` varchar(255) NOT NULL DEFAULT '' COMMENT '图文名称',
  `sort` int unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `new_id` varchar(255) NOT NULL DEFAULT '' COMMENT '文章id',
  `add_time` varchar(255) NOT NULL DEFAULT '' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='图文消息管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_qrcode`
--

DROP TABLE IF EXISTS `eb_wechat_qrcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_qrcode` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码名称',
  `image` varchar(500) NOT NULL DEFAULT '' COMMENT '二维码图片',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `label_id` varchar(32) NOT NULL DEFAULT '' COMMENT '标签id',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '回复类型',
  `content` text COMMENT '回复内容',
  `data` text COMMENT '发送数据',
  `follow` int NOT NULL DEFAULT '0' COMMENT '关注人数',
  `scan` int NOT NULL DEFAULT '0' COMMENT '扫码人数',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `continue_time` int NOT NULL DEFAULT '0' COMMENT '有效期',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '到期时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='二维码表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_qrcode_cate`
--

DROP TABLE IF EXISTS `eb_wechat_qrcode_cate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_qrcode_cate` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `cate_name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道码分类名称',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COMMENT='二维码类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_qrcode_record`
--

DROP TABLE IF EXISTS `eb_wechat_qrcode_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_qrcode_record` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `qid` int NOT NULL DEFAULT '0' COMMENT '渠道码id',
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `is_follow` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否关注',
  `add_time` int NOT NULL DEFAULT '0' COMMENT '扫码时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='渠道码扫码记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_reply`
--

DROP TABLE IF EXISTS `eb_wechat_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_reply` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT COMMENT '微信关键字回复id',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '回复类型',
  `data` text COMMENT '回复数据',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '0=不可用  1 =可用',
  `hide` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `hide` (`hide`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='微信关键字回复表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eb_wechat_user`
--

DROP TABLE IF EXISTS `eb_wechat_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eb_wechat_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '微信用户id',
  `unionid` varchar(30) NOT NULL DEFAULT '' COMMENT '只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段',
  `openid` varchar(255) NOT NULL DEFAULT '' COMMENT '用户的标识，对当前公众号唯一',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '用户的昵称',
  `headimgurl` varchar(256) NOT NULL DEFAULT '' COMMENT '用户头像',
  `sex` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '用户的性别，值为1时是男性，值为2时是女性，值为0时是未知',
  `city` varchar(64) NOT NULL DEFAULT '' COMMENT '用户所在城市',
  `language` varchar(64) NOT NULL DEFAULT '' COMMENT '用户的语言，简体中文为zh_CN',
  `province` varchar(64) NOT NULL DEFAULT '' COMMENT '用户所在省份',
  `country` varchar(64) NOT NULL DEFAULT '' COMMENT '用户所在国家',
  `remark` varchar(256) NOT NULL DEFAULT '' COMMENT '公众号运营者对粉丝的备注，公众号运营者可在微信公众平台用户管理界面对粉丝添加备注',
  `groupid` smallint unsigned NOT NULL DEFAULT '0' COMMENT '用户所在的分组ID（兼容旧的用户分组接口）',
  `tagid_list` varchar(256) NOT NULL DEFAULT '' COMMENT '用户被打上的标签ID列表',
  `subscribe` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '用户是否订阅该公众号标识',
  `subscribe_time` int unsigned NOT NULL DEFAULT '0' COMMENT '关注公众号时间',
  `add_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `second` int unsigned NOT NULL DEFAULT '0' COMMENT '二级推荐人',
  `user_type` varchar(32) NOT NULL DEFAULT 'wechat' COMMENT '用户类型',
  `is_complete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '信息是否完善',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否注销',
  PRIMARY KEY (`id`),
  UNIQUE KEY `openid` (`openid`,`uid`) USING BTREE,
  KEY `groupid` (`groupid`) USING BTREE,
  KEY `subscribe_time` (`subscribe_time`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `subscribe` (`subscribe`) USING BTREE,
  KEY `unionid` (`unionid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='微信用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'crmeb'
--

--
-- Dumping routines for database 'crmeb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-27 12:52:14
