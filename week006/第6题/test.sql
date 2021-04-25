/*
 Navicat MySQL Data Transfer

 Source Server         : 瀚元
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : 47.244.103.84:3306
 Source Schema         : test

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 25/04/2021 22:05:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_cart
-- ----------------------------
DROP TABLE IF EXISTS `t_cart`;
CREATE TABLE `t_cart` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `uid` int(10) unsigned NOT NULL COMMENT '用户ID',
  `type` varchar(32) NOT NULL COMMENT '类型',
  `product_id` int(10) unsigned NOT NULL COMMENT '商品ID',
  `product_attr_unique` char(32) NOT NULL DEFAULT '' COMMENT '商品属性',
  `cart_num` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `add_time` int(13) unsigned NOT NULL COMMENT '添加时间',
  `is_pay` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 未购买 1 = 已购买',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为立即购买',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`uid`) USING BTREE,
  KEY `goods_id` (`product_id`) USING BTREE,
  KEY `uid` (`uid`,`is_pay`) USING BTREE,
  KEY `uid_2` (`uid`,`is_del`) USING BTREE,
  KEY `uid_3` (`uid`,`is_new`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='购物车表';

-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `uid` int(11) unsigned NOT NULL COMMENT '用户id',
  `real_name` varchar(32) NOT NULL COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL COMMENT '详细地址',
  `cart_id` varchar(256) NOT NULL DEFAULT '[]' COMMENT '购物车id',
  `freight_price` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '运费金额',
  `total_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `total_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '抵扣金额',
  `paid` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态',
  `pay_time` int(13) unsigned DEFAULT NULL COMMENT '支付时间',
  `pay_type` varchar(32) NOT NULL COMMENT '支付方式',
  `add_time` int(13) unsigned NOT NULL COMMENT '创建时间',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '订单状态（-1 : 申请退款 -2 : 退货成功 0：待发货；1：待收货；2：已收货；3：待评价；-1：已退款）',
  `refund_status` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` int(13) unsigned DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '发货类型',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `gain_integral` int(8) unsigned NOT NULL DEFAULT '0' COMMENT '消费赚取积分',
  `use_integral` int(8) unsigned NOT NULL DEFAULT '0' COMMENT '使用积分',
  `back_integral` int(8) unsigned DEFAULT '0' COMMENT '给用户退了多少积分',
  `mark` varchar(512) DEFAULT NULL COMMENT '备注',
  `is_del` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `unique` char(32) NOT NULL COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` int(3) unsigned NOT NULL DEFAULT '0' COMMENT '商户是否核销',
  `verify_code` varchar(12) NOT NULL DEFAULT '' COMMENT '核销码',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '成本价',
  `sales_id` int(11) DEFAULT NULL COMMENT '业务员id',
  `order_type` int(1) DEFAULT '0' COMMENT '订单状态(0：普通订单，1：货到付款)',
  `coupon_price` decimal(10,2) DEFAULT NULL COMMENT '使用优惠券金额',
  `area_code` int(10) DEFAULT NULL COMMENT '区号',
  `store_id` int(11) DEFAULT '0' COMMENT '门店id',
  `shipping_type` int(1) NOT NULL DEFAULT '1' COMMENT '配送方式 1=快递 ，2=门店自提',
  `is_channel` int(1) unsigned DEFAULT '0' COMMENT '支付渠道 1=微信，2=支付宝 3=货到付款',
  `is_remind` int(1) unsigned DEFAULT '0' COMMENT '消息提醒',
  `is_system_del` int(1) DEFAULT '0' COMMENT '后台是否删除',
  `invoice_id` int(10) DEFAULT NULL COMMENT '发票id',
  `content` varchar(600) DEFAULT NULL COMMENT '发票内容',
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
  KEY `is_del` (`is_del`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='订单表';

-- ----------------------------
-- Table structure for t_order_cart_info
-- ----------------------------
DROP TABLE IF EXISTS `t_order_cart_info`;
CREATE TABLE `t_order_cart_info` (
  `oid` bigint(20) unsigned NOT NULL COMMENT '订单id',
  `cart_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '购物车id',
  `product_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `cart_info` varchar(500) NOT NULL COMMENT '购买东西的详细信息',
  `unique` char(32) NOT NULL COMMENT '唯一id',
  UNIQUE KEY `oid` (`oid`,`unique`) USING BTREE,
  KEY `cart_id` (`cart_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='订单购物详情表';

-- ----------------------------
-- Table structure for t_product
-- ----------------------------
DROP TABLE IF EXISTS `t_product`;
CREATE TABLE `t_product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `mer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户Id(0为总后台管理员创建,不为0的时候是商户后台创建)',
  `image` varchar(256) NOT NULL COMMENT '商品图片',
  `slider_image` varchar(2000) NOT NULL COMMENT '轮播图',
  `store_name` varchar(128) NOT NULL COMMENT '商品名称',
  `store_info` varchar(256) NOT NULL COMMENT '商品简介',
  `keyword` varchar(256) DEFAULT NULL COMMENT '关键字',
  `address` varchar(255) DEFAULT NULL COMMENT '商品所在地',
  `bar_code` varchar(15) NOT NULL DEFAULT '' COMMENT '产品条码（一维码）',
  `cate_id` varchar(64) NOT NULL COMMENT '分类id',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '划线价',
  `price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品价格',
  `recede_price` decimal(8,2) DEFAULT NULL COMMENT '退瓶金额',
  `postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `unit_name` varchar(32) NOT NULL COMMENT '单位名',
  `sort` smallint(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `sales` mediumint(11) unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `stock` mediumint(11) unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `is_show` int(1) NOT NULL DEFAULT '1' COMMENT '状态（0：未上架，1：上架）',
  `is_best` int(1) NOT NULL DEFAULT '0' COMMENT '是否首页推荐',
  `is_good` int(1) NOT NULL DEFAULT '0' COMMENT '是否优品推荐',
  `is_new` int(1) NOT NULL DEFAULT '0' COMMENT '是否新品（显示活动价）',
  `description` text NOT NULL COMMENT '产品描述',
  `add_time` int(13) unsigned NOT NULL COMMENT '添加时间',
  `is_postage` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否包邮',
  `is_del` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `give_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '获得积分',
  `ficti` mediumint(11) DEFAULT '100' COMMENT '虚拟销量',
  `browse` int(11) DEFAULT '0' COMMENT '浏览量',
  `code_path` varchar(64) NOT NULL DEFAULT '' COMMENT '产品二维码地址(用户小程序海报)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cate_id` (`cate_id`) USING BTREE,
  KEY `is_hot` (`is_best`) USING BTREE,
  KEY `toggle_on_sale, is_del` (`is_del`) USING BTREE,
  KEY `price` (`price`) USING BTREE,
  KEY `is_show` (`is_show`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `sales` (`sales`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `is_postage` (`is_postage`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商品表';

-- ----------------------------
-- Records of t_product
-- ----------------------------
BEGIN;
INSERT INTO `t_product` VALUES (2, 0, 'http://datong.crmeb.net/public/uploads/attach/2019/01/15/5c3dbc27c69c7.jpg', '[\"http://datong.crmeb.net/public/uploads/attach/2019/01/15/5c3dbc6a38fab.jpg\"]', '智能马桶盖 AI版', '智能马桶盖 AI版', '智能马桶', NULL, '', '3,2', 1500.00, 0.01, 2.00, 5.00, '件', 0, 217, 938, 1, 1, 0, 0, '<p><img src=\"http://datong.crmeb.net/public/uploads/editor/20190115/5c3dc286862fd.jpg\"></p>', 1547516202, 1, 0, 1999.00, 20, 0, '');
INSERT INTO `t_product` VALUES (3, 0, 'http://datong.crmeb.net/public/uploads/attach/2019/01/15/5c3dc0ef27068.jpg', '[\"http://datong.crmeb.net/public/uploads/attach/2019/01/15/5c3dc0ef27068.jpg\",\"http://datong.crmeb.net/public/uploads/attach/2019/01/15/5c3dc15ba1972.jpg\"]', '智米加湿器 白色', '智米加湿器 白色', '加湿器', NULL, '', '3,2', 10.00, 249.00, 0.00, 0.00, '件', 0, 110, 3, 1, 1, 0, 0, '<p><img src=\"http://datong.crmeb.net/public/uploads/editor/20190115/5c3dc286862fd.jpg\"></p>', 1547551009, 1, 0, 249.00, 8, 0, '');
INSERT INTO `t_product` VALUES (4, 0, 'http://datong.crmeb.net/public/uploads/attach/2019/01/15/5c3dc23646fff.jpg', '[\"http:\\/\\/datong.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/01\\/15\\/5c3dc23646fff.jpg\",\"http:\\/\\/datong.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/01\\/15\\/5c3dc15ba1972.jpg\",\"http:\\/\\/datong.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/01\\/15\\/5c3dc0ef27068.jpg\"]', '互联网电热水器1A', '3000w双管速热，动态360L热水用量，双重漏电保护，智能APP操控', '电热水器', NULL, '', '3,2', 888.00, 999.00, NULL, 0.00, '件', 0, 87, 413, 1, 1, 0, 0, '<p><img src=\"http://datong.crmeb.net/public/uploads/editor/20190115/5c3dc286862fd.jpg\"/><img src=\"http://datong.crmeb.net/public/uploads/editor/20190115/5c3dc294a9a0a.jpg\"/><img src=\"http://datong.crmeb.net/public/uploads/editor/20190115/5c3dc2ba18a77.jpg\"/></p>', 1547551346, 1, 0, 999.00, 10, 0, '');
INSERT INTO `t_product` VALUES (5, 0, 'http://datong.crmeb.net/public/uploads/editor/20190115/5c3dbb513b06f.jpeg', '[\"http:\\/\\/datong.crmeb.net\\/public\\/uploads\\/editor\\/20190115\\/5c3dc294a9a0a.jpg\",\"http:\\/\\/datong.crmeb.net\\/public\\/uploads\\/editor\\/20190115\\/5c3dbb513b06f.jpeg\"]', '测试', '阿萨德啊', '去', NULL, '', '4,7,2,3,19', 1.00, 1.00, NULL, 0.00, '件', 0, 7, 94, 1, 1, 0, 0, '', 1554863537, 0, 1, 1.00, 1, 0, '');
INSERT INTO `t_product` VALUES (7, 0, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//6f2a1ece45e307f274e3384410a3bd3a.jpg', '[\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//6f2a1ece45e307f274e3384410a3bd3a.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//ec8484e93ac49309b5576bb5f96d202f.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//60fff157d277d17154d738403870a489.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//3bfee3357bbf0091c2cdfe7aa1da5eec.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//6f2bbcd0dffd379c6f91e95a308bcfb6.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//f92383a6a1be19a7588ccd227e458afd.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//353d754027763daf1ce61d94f7c3709a.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//5f273c529aa59d313f08a36a50a20380.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//27cf255f9990535ed3b333009f1df52c.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//a7dbbc6d4a2ecf16b592b880d937a770.jpg\"]', '【华为畅享9S】华为HUAWEI畅享9S6GB+64GB珊瑚红全网通2400万超广角三摄珍珠屏大存储移动联通电信4G手机双卡双待', '【华为畅享9S】华为HUAWEI畅享9S6GB+64GB珊瑚红全网通2400万超广角三摄珍珠屏大存储移动联通电信4G手机双卡双待', '件', NULL, '', '2', 1000.00, 100.00, NULL, 0.00, '件', 0, 27, 76, 1, 1, 0, 0, '1111111', 1559101322, 0, 0, 10.00, 0, 0, '');
INSERT INTO `t_product` VALUES (8, 0, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//71e85589cb7d3398d08f0d55bdb9031d.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/71e85589cb7d3398d08f0d55bdb9031d.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/996c4bad976844b4f3bcf73cbd6e0f15.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/e47f51861c11fc648a298b16c24d8627.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/105cf3b5bbe2e1c7e6366d09b71e88b2.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/e275a4c451e06248cecc0cfb2ed24fed.jpg\"]', '【AppleiPhone8】AppleiPhone8(A1863)256GB深空灰色移动联通电信4G手机', '【AppleiPhone8】AppleiPhone8(A1863)256GB深空灰色移动联通电信4G手机', '件', NULL, '', '2', 1000.00, 9999.00, NULL, 0.00, '件', 0, 20, 982, 1, 1, 0, 0, '<br><div skucode=\"100010\"></div><table id=\"__01\" width=\"750\" height=\"1272\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr><td><img src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//da410a5d704e8d94ada293edb79678a7.jpg\" alt=\"\" width=\"750\" height=\"249\" usemap=\"#Map01\" border=\"0\" <=\"\" d=\"\"></td></tr><tr><td><img src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//9ccac843781c262ae1e35bd176d43411.jpg\" width=\"750\" height=\"341\" alt=\"\"></td></tr><tr><td><img src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//57064ab7664452fef3b9dab19668f915.jpg\" width=\"750\" height=\"405\" alt=\"\" usemap=\"#Map02\" border=\"0\"></td></tr><tr><td><img src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/29//92d55c4dc01ade157aba628edc00be0b.jpg\" width=\"640\" alt=\"\" usemap=\"#Map03\"><map name=\"Map01\"><area shape=\"rect\" coords=\"5,41,98,177\" href=\"https://pro.m.jd.com/mall/active/bFBgZuiq1QFNCPfzog9sEHDfeN5/index.html\" target=\"_blank\"><area shape=\"rect\" coords=\"231,67,330,194\" href=\"https://mall.jd.com/view_page-86030491.html#jingzhunda\" target=\"_blank\"> <area shape=\"rect\" coords=\"418,67,517,195\" href=\"https://mall.jd.com/view_page-86030491.html#jingdongweixiu\" target=\"_blank\"> <area shape=\"rect\" coords=\"606,67,705,195\" href=\"https://mall.jd.com/view_page-86030491.html#yijiuhuanxin\" target=\"_blank\"> <map name=\"Map02\"><area shape=\"rect\" coords=\"3,38,250,402\" href=\"https://item.jd.com/4996353.html\" target=\"_blank\"> <area shape=\"rect\" coords=\"252,38,495,402\" href=\"https://item.jd.com/771942.html\" target=\"_blank\"> <area shape=\"rect\" coords=\"501,39,745,400\" href=\"https://item.jd.com/5164987.html\" target=\"_blank\"> </map><map name=\"Map03\"><area shape=\"rect\" coords=\"196,220,532,252\" href=\"https://support.apple.com/zh-cn/HT204073\" target=\"_blank\"> </map></map></td></tr></tbody></table><br><script></script><br>', 1559101359, 0, 0, 0.00, 0, 0, '');
INSERT INTO `t_product` VALUES (9, 0, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//51308e61ace45968fdef953b2ac6c241.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/51308e61ace45968fdef953b2ac6c241.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/d3f3999622cb39eddb966d8cc041cb79.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/c2a01686bee0024c0ae3d08367ef9836.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/7121d81126a84b20a4f8b7e1252d0306.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/a6cc4157d0cf8e79f5b4a7cac1423f25.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/29\\/\\/391618fe80748151243ce5e8650ee3bb.jpg\"]', '【雷神911Air星战】雷神(ThundeRobot)911Air星战二代旗舰版15.6英寸窄边框游戏笔记本电脑i79750H512GSSDRGB键盘GTX1650', '【雷神911Air星战】雷神(ThundeRobot)911Air星战二代旗舰版15.6英寸窄边框游戏笔记本电脑i79750H512GSSDRGB键盘GTX1650', '件', NULL, '', '2', 1000.00, 1000.00, NULL, 0.00, '件', 0, 23, 983, 1, 1, 0, 0, '<br><div id=\"zbViewModulesH\" value=\"12744\"></div><input id=\"zbViewModulesHeight\" type=\"hidden\" value=\"12744\"><div skudesign=\"100010\"></div><div class=\"ssd-module-wrap\">\n    <div class=\"ssd-module M15574696198181 animate-M15574696198181\" data-id=\"M15574696198181\">\n        \n</div>\n<div class=\"ssd-module M15574696198302 animate-M15574696198302\" data-id=\"M15574696198302\">\n        \n</div>\n<div class=\"ssd-module M15574696198423 animate-M15574696198423\" data-id=\"M15574696198423\">\n        \n</div>\n<div class=\"ssd-module M15574696198564 animate-M15574696198564\" data-id=\"M15574696198564\">\n        \n</div>\n<div class=\"ssd-module M15574696198705 animate-M15574696198705\" data-id=\"M15574696198705\">\n        \n</div>\n<div class=\"ssd-module M15574696198856 animate-M15574696198856\" data-id=\"M15574696198856\">\n        \n</div>\n<div class=\"ssd-module M15574696199077 animate-M15574696199077\" data-id=\"M15574696199077\">\n        \n</div>\n<div class=\"ssd-module M15574696199278 animate-M15574696199278\" data-id=\"M15574696199278\">\n        \n</div>\n<div class=\"ssd-module M15574696199519 animate-M15574696199519\" data-id=\"M15574696199519\">\n        \n</div>\n<div class=\"ssd-module M155746961996910 animate-M155746961996910\" data-id=\"M155746961996910\">\n        \n</div>\n<div class=\"ssd-module M155746961998811 animate-M155746961998811\" data-id=\"M155746961998811\">\n        \n</div>\n<div class=\"ssd-module M155746962001812 animate-M155746962001812\" data-id=\"M155746962001812\">\n        \n</div>\n<div class=\"ssd-module M155746962004613 animate-M155746962004613\" data-id=\"M155746962004613\">\n        \n</div>\n<div class=\"ssd-module M155746962006814 animate-M155746962006814\" data-id=\"M155746962006814\">\n        \n</div>\n<div class=\"ssd-module M155746962008915 animate-M155746962008915\" data-id=\"M155746962008915\">\n        \n</div>\n\n</div>\n<!-- 2019-05-10 02:27:40 --> <br><script></script><br>', 1559110455, 0, 0, 0.00, 20, 0, '');
INSERT INTO `t_product` VALUES (10, 0, 'http://activity.crmeb.net/public/uploads/attach/2019/05/30//b58f452dc89775b344bade7fdc3ede14.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/b58f452dc89775b344bade7fdc3ede14.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/fe90dcb696cfcef739565894f9e93d9d.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/75a24145aac82bce88931019f91e928a.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/cdbc02ce7907670aa099c486f8959154.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/f8c0ffa71bfc8efae28082bf05c8969a.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/5fda52231265c835f853dd284d7437f9.jpg\",\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/attach\\/2019\\/05\\/30\\/\\/0eaba55adaedcd7d0b17c7202225eed9.jpg\"]', '【华为华为10000mAh快充移动电源/充电宝】华为10000毫安充电宝/移动电源18W双向快充MicroUSB口输入白色适用于安卓/苹果/平板等', '【华为华为10000mAh快充移动电源/充电宝】华为10000毫安充电宝/移动电源18W双向快充MicroUSB口输入白色适用于安卓/苹果/平板等', '', NULL, '', '4', 400.00, 300.00, NULL, 0.00, '件', 0, 0, 100, 0, 1, 0, 0, '<br><div cssurl=\"//sku-market-gw.jd.com/css/pc/100002611539.css?t=1552645455602\"></div><div skucode=\"100010\"></div><center>\n<img src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//efbee681cb31fe72ed52c006b56f31cf.jpg\"> \n</center><br><script></script><br>', 1559198939, 0, 0, 0.00, 50, 0, '');
INSERT INTO `t_product` VALUES (11, 0, 'http://activity.crmeb.net/public/uploads/attach/2019/05/30//0eecbfbca9ebc315c2882590fd55a209.jpg', '[\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//0eecbfbca9ebc315c2882590fd55a209.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//1a730a7edcb0c373f8188b4d6090999e.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//1da1cff5adc9c053022373596032cbb4.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//d116eb69f06169eed8efd06fcd4dcb90.jpg\",\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//33f645b107441db0b05eaa428a888ac6.jpg\"]', '伊利酸奶畅轻整箱装乳酸菌燕麦黄桃草莓早餐奶250克9瓶风味发酵乳', '伊利酸奶畅轻整箱装乳酸菌燕麦黄桃草莓早餐奶250克9瓶风味发酵乳', '', NULL, '', '4', 90.00, 0.01, NULL, 0.00, '件', 0, 107, 893, 1, 1, 0, 0, '<div style=\"width: 790.0px;height: 13870.0px;overflow: hidden;\"><div style=\"width: 790.0px;height: 13870.0px;overflow: hidden;\"><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//4466609a8fd2572a4366a0786f7893a5.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//f37e16bbbc014195001bc16fcc6cae63.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//960bad190414f774241379ccdf073576.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//8f20a9984fd968785de5e32053be9747.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//c00e4506123402f687405c69b80bb5c8.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//e8bccebd6534055129a8af8c488528a3.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//547c56bac0eb97085b776234e6104d42.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//ebd3cccb57e2d1b7a06b18fb1ee19978.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//a2981e2259068977cb15205d5516046b.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//e768dca53e023a3a79215fe2f2cf25fb.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//57ad0f7b95a510e91f5c080cd0ef45f0.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//3b2c7bafc9bfba1e01da50f2d44da19c.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//4af68ddf547e251bc349daac6b7ddc21.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//c59c6f708dda1ac28df3f627b1543f4e.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//a4cfd1a15c188d1c7793dcd6762c607f.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//83d0a242bbf6c4fce431da5a45ba72dc.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//c56ca302f42d2d16a770d3f87796e614.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//7d2008368b7a9122465c34f459ed55d7.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//cfef919448f30e5b433572edbd316ef5.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//793c7f0f2d8cdc74c7d94dc9c5a3d125.jpg\"/><img style=\"display: block;width: 100.0%;\" src=\"http://activity.crmeb.net/public/uploads/attach/2019/05/30//0d8fd269982df7991462bffcb92904f1.jpg\"/></div></div>', 1559199293, 0, 0, 0.00, 10, 0, '');
INSERT INTO `t_product` VALUES (12, 0, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/editor\\/20190605\\/5cf737bf264e4.jpg\"]', '测撒测试', '测撒测试', '测撒测试', NULL, '', '3', 5.00, 10.00, NULL, 0.00, '件', 0, 4, 996, 1, 1, 0, 0, '', 1560650420, 1, 1, 0.00, 100, 0, '');
INSERT INTO `t_product` VALUES (13, 0, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/editor\\/20190605\\/5cf737bf264e4.jpg\"]', '测撒测试', '测撒测试', '测撒测试', NULL, '', '3', 5.00, 10.00, NULL, 0.00, '件', 0, 1, 999, 1, 1, 0, 0, '', 1560650420, 1, 1, 0.00, 100, 0, '');
INSERT INTO `t_product` VALUES (14, 0, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/editor\\/20190605\\/5cf737bf264e4.jpg\"]', '测撒测试', '测撒测试', '测撒测试', NULL, '', '3', 5.00, 10.00, NULL, 0.00, '件', 0, 3, 997, 1, 1, 0, 0, '', 1560650420, 1, 1, 0.00, 100, 0, '');
INSERT INTO `t_product` VALUES (15, 0, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '[\"http:\\/\\/activity.crmeb.net\\/public\\/uploads\\/editor\\/20190605\\/5cf737bf264e4.jpg\"]', '测撒测试', '测撒测试', '测撒测试', NULL, '', '3', 5.00, 10.00, NULL, 0.00, '件', 0, 15, 998, 1, 1, 0, 0, '', 1560650420, 1, 1, 0.00, 100, 0, '');
INSERT INTO `t_product` VALUES (19, 0, 'http://kaifa.crmeb.net/uploads/attach/2019/08/13/4e3396f4248e9e5ef2eab5505216ade0.jpg', '[\"http:\\/\\/kaifa.crmeb.net\\/uploads\\/attach\\/2019\\/08\\/13\\/4e3396f4248e9e5ef2eab5505216ade0.jpg\",\"http:\\/\\/kaifa.crmeb.net\\/uploads\\/attach\\/2019\\/08\\/13\\/5653627e73313cf61c9620725c45a376.jpg\",\"http:\\/\\/kaifa.crmeb.net\\/uploads\\/attach\\/2019\\/08\\/13\\/1d9d4158d2d7c7f0466e78207246e845.jpg\",\"http:\\/\\/kaifa.crmeb.net\\/uploads\\/attach\\/2019\\/08\\/13\\/3f9bfd12b76f290d3ed82ea44ebb399a.jpg\",\"http:\\/\\/kaifa.crmeb.net\\/uploads\\/attach\\/2019\\/08\\/13\\/e8c9d50e6b7cef371fe742ab08abd6a4.jpg\"]', '【直营】ZOJIRUSHI象印进口不锈钢便携保温杯KB48480ml日本tmall.hk天猫国际', '【直营】ZOJIRUSHI象印进口不锈钢便携保温杯KB48480ml日本tmall.hk天猫国际', '', NULL, '', '4', 22.00, 22.00, NULL, 0.00, '件', 0, 0, 222, 1, 0, 0, 0, '<div> <a name=\"hlg_list_1_17635940_start\"></a> </div> <div> <a name=\"hlg_list_1_17599564_end\"></a> </div> <div> <a name=\"hlg_list_1_17537058_start\"></a> </div> <table style=\"margin: 0.0px auto;\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">  <tbody><tr> <td> <div> &nbsp; </div> <div> <a href=\"https://detail.tmall.hk/hk/item.htm?id=575153295527\" target=\"_blank\"></a><a href=\"https://detail.tmall.hk/hk/item.htm?id=575153295527\" target=\"_blank\"></a> </div> </td> </tr>  </tbody></table> <div> &nbsp; </div> <div> <img width=\"790\" height=\"719\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/e882d4dffdca67b65a7a1e66fb209c4c.jpg\"><img width=\"790\" height=\"589\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/feb565a57f5d42c370c54df7bdacb050.jpg\"><img width=\"790\" height=\"581\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/12709ee798ac2dd5c21d7ab030aa4e13.png\"><img width=\"790\" height=\"1060\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/5cc24febd1722f8c7ec7d5cf74262743.png\"><img width=\"790\" height=\"1051\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/28ccd5e15404129a793045f57049f149.jpg\"><img width=\"790\" height=\"354\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/42cc797e7005e47baf26cc33655b4667.jpg\"><img width=\"790\" height=\"553\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/0a8d0d2e2cb85c94c0d5380058603c56.jpg\"><img width=\"790\" height=\"884\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/26b2896f313fb594884fb992e33c5fa8.jpg\"><img width=\"790\" height=\"891\" style=\"font-weight: bold;font-size: 1.5em;\" src=\"http://kaifa.crmeb.net/uploads/attach/2019/08/13/7d1991d9b7bf33e84782c6cd942224f6.jpg\"> </div>', 1565687845, 0, 0, 0.00, 22, 0, '');
INSERT INTO `t_product` VALUES (20, 0, 'https://wxapp-api.gd-mym.com/profile/upload/2020/01/19/a110aad55f5522f7234114a1e074c885.jpg', '[\"https://wxapp-api.gd-mym.com/profile/upload/2020/01/19/041e8c69da8db5492bae510b378dcaf4.png\",\"https://wxapp-api.gd-mym.com/profile/upload/2020/01/19/511141b69d6bed95a3be78652ca1aeaa.jpg\"]', '正宗法国进口银鳕鱼新鲜宝宝辅食深海包邮鳕鱼片冷冻雪鳕鱼排500g(分销商品)', '正宗法国进口银鳕鱼新鲜宝宝辅食深海包邮鳕鱼片冷冻雪鳕鱼排500g', '1', NULL, '', '4', 98.00, 98.00, NULL, 0.00, '件', 0, 114, 98, 1, 1, 1, 0, '%3Cp%3E%3Cimg%20src=%22https://img.alicdn.com/imgextra/i2/2924064868/O1CN01vDgGSi1lpabI5Rpvb_!!2924064868.jpg%22%3E%3C/p%3E', 1579418449, 1, 0, 0.00, 98, 0, '');
COMMIT;

-- ----------------------------
-- Table structure for t_product_attr
-- ----------------------------
DROP TABLE IF EXISTS `t_product_attr`;
CREATE TABLE `t_product_attr` (
  `product_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `attr_name` varchar(32) NOT NULL COMMENT '属性名',
  `attr_values` varchar(256) NOT NULL COMMENT '属性值',
  KEY `store_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商品属性表';

-- ----------------------------
-- Records of t_product_attr
-- ----------------------------
BEGIN;
INSERT INTO `t_product_attr` VALUES (3, '容量', '3L,4L');
INSERT INTO `t_product_attr` VALUES (15, '颜色', '黑色,白色,紫色');
INSERT INTO `t_product_attr` VALUES (15, '规则', '大,小');
INSERT INTO `t_product_attr` VALUES (7, '1', '2,3');
INSERT INTO `t_product_attr` VALUES (7, '3', '1');
INSERT INTO `t_product_attr` VALUES (8, '1', '1,3');
INSERT INTO `t_product_attr` VALUES (8, '2', '2');
INSERT INTO `t_product_attr` VALUES (20, '重量', '300g,500g');
INSERT INTO `t_product_attr` VALUES (3, '颜色', 'value');
INSERT INTO `t_product_attr` VALUES (2, '颜色', '黑色,白色');
INSERT INTO `t_product_attr` VALUES (2, ' 尺码', '大,小,中,xl');
COMMIT;

-- ----------------------------
-- Table structure for t_product_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `t_product_attr_value`;
CREATE TABLE `t_product_attr_value` (
  `product_id` bigint(20) unsigned NOT NULL COMMENT '商品ID',
  `suk` varchar(128) NOT NULL COMMENT '商品属性索引值 (attr_value|attr_value[|....])',
  `stock` int(10) unsigned NOT NULL COMMENT '属性对应的库存',
  `sales` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `price` decimal(8,2) unsigned NOT NULL COMMENT '属性金额',
  `image` varchar(128) DEFAULT '' COMMENT '图片',
  `unique` char(32) NOT NULL DEFAULT '' COMMENT '唯一值',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '成本价',
  `bar_code` varchar(50) NOT NULL DEFAULT '' COMMENT '产品条码',
  UNIQUE KEY `unique` (`unique`,`suk`) USING BTREE,
  KEY `store_id` (`product_id`,`suk`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商品属性值表';

-- ----------------------------
-- Records of t_product_attr_value
-- ----------------------------
BEGIN;
INSERT INTO `t_product_attr_value` VALUES (15, '小,白色', 997, 1, 40.00, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '08af4c92', 5.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '白色,xl', 0, 1, 50.00, NULL, '0b36e6e87d71ce89b41da50eff8d1a02', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (15, '大,黑色', 993, 5, 70.00, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '1bf9fad8', 5.00, '');
INSERT INTO `t_product_attr_value` VALUES (8, '1,2', 980, 2, 0.00, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//71e85589cb7d3398d08f0d55bdb9031d.jpg', '304d1fc7', 1000.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '白色,小', 0, 0, 0.00, NULL, '4370804ee96ee3a1d04b99ad74b02362', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (8, '2,3', 982, 0, 0.00, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//71e85589cb7d3398d08f0d55bdb9031d.jpg', '5fe3af25', 1000.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '黑色,中', 0, 0, 0.00, NULL, '6216f3a2ae514edf5df57390222b5fa1', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (7, '1,2', 71, 5, 100.00, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//6f2a1ece45e307f274e3384410a3bd3a.jpg', '76862ff5', 1000.00, '');
INSERT INTO `t_product_attr_value` VALUES (15, '大,紫色', 202, 0, 10.00, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', '7a06e7f9', 5.00, '');
INSERT INTO `t_product_attr_value` VALUES (3, '3L', 0, 0, 0.00, NULL, '7dad4e8e0dddcfe931bdee0b5ab14816', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '白色,大', 0, 0, 0.00, NULL, '8969fe61b424d7f808c71a6e1365b76e', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '白色,中', 0, 0, 0.00, NULL, '941f3cc4a36313ea6c3ae92ef95c8912', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '黑色,大', 0, 0, 0.00, NULL, '95021531fc8b1b07b89f9b9673f30164', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (2, '黑色,小', 0, 0, 0.00, NULL, 'a693bd3a9f112c5613985d6847ef6a2c', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (20, '500g', 19, 2, 100.00, NULL, 'b1e03a4e6797c0aefefeb2116a88829d', 100.00, '88888888');
INSERT INTO `t_product_attr_value` VALUES (2, '黑色,xl', 0, 0, 0.00, NULL, 'c30a1e354cb285da28bd9037829de98e', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (15, '小,紫色', 195, 5, 20.00, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', 'd630e29a', 5.00, '');
INSERT INTO `t_product_attr_value` VALUES (7, '1,3', 76, 0, 100.00, 'http://activity.crmeb.net/public/uploads/attach/2019/05/29//6f2a1ece45e307f274e3384410a3bd3a.jpg', 'd7b47f88', 1000.00, '');
INSERT INTO `t_product_attr_value` VALUES (3, '4L', 0, 0, 0.00, NULL, 'dc675554be7ca2e81786566b6a772ae9', 0.00, '');
INSERT INTO `t_product_attr_value` VALUES (15, '小,黑色', 997, 1, 60.00, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', 'e4d9a758', 5.00, '');
INSERT INTO `t_product_attr_value` VALUES (15, '大,白色', 997, 1, 50.00, 'http://activity.crmeb.net/public/uploads/editor/20190605/5cf737bf264e4.jpg', 'f208c727', 5.00, '');
INSERT INTO `t_product_attr_value` VALUES (20, '300g', 5, 16, 9.88, NULL, 'fb8839b45dfe186a4bc3b6043b16fe1e', 98.00, '88888888');
COMMIT;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `uid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `unionid` varchar(30) DEFAULT NULL COMMENT '只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段',
  `openid` varchar(30) DEFAULT NULL COMMENT '用户的标识，对当前公众号唯一',
  `session_key` varchar(32) DEFAULT NULL COMMENT '小程序用户会话密匙',
  `phone` char(11) DEFAULT NULL COMMENT '用户绑定手机号码',
  `pwd` varchar(256) DEFAULT NULL COMMENT '用户登录密码（加密）',
  `nickname` varchar(256) DEFAULT NULL COMMENT '用户的昵称',
  `headimgurl` varchar(256) DEFAULT NULL COMMENT '用户头像',
  `sex` tinyint(1) unsigned DEFAULT '0' COMMENT '用户的性别，值为1时是男性，值为2时是女性，值为0时是未知',
  `city` varchar(64) DEFAULT NULL COMMENT '用户所在城市',
  `language` varchar(64) DEFAULT NULL COMMENT '用户的语言，简体中文为zh_CN',
  `province` varchar(64) DEFAULT NULL COMMENT '用户所在省份',
  `country` varchar(64) DEFAULT NULL COMMENT '用户所在国家',
  `integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '用户剩余积分',
  `buy_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户订单数量',
  `buy_total_cash` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '用户消费总金额',
  `add_time` int(13) unsigned DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE KEY `phone` (`phone`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE,
  KEY `unionid` (`unionid`) USING BTREE,
  KEY `openid` (`openid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='微信用户表';

SET FOREIGN_KEY_CHECKS = 1;
