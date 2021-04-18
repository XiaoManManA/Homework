package edu.geekbang.xmm.week005;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.*;

/**
 * @author XiaoManMan
 */
public class JdbcDemoApplication {

    static {
        //1.加载驱动程序
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private static final String URL = "jdbc:mysql://121.196.19.208:3306/jsgreatwallwine", USER = "root", PASSWORD = "qOFIDyxw2kZ4";

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        /**
         * 研究一下 JDBC 接口和数据库连接池，掌握它们的设计和用法：
         * 1）使用 JDBC 原生接口，实现数据库的增删改查操作。
         * 2）使用事务，PrepareStatement 方式，批处理方式，改进上述操作。
         * 3）配置 Hikari 连接池，改进上述操作。提交代码到 GitHub。
         */

        // 使用 JDBC 原生接口，实现数据库的增删改查操作。
//        insert();
//        delete();
//        update();
//        query();

        // 使用事务，PrepareStatement 方式，批处理方式，改进上述操作。
        // balance();

        // 配置 Hikari 连接池，改进上述操作。
        query();

    }

    public static void balance() throws SQLException {
        int mimic = 1, xmm = 2, money = 100;
        Connection conn = getConnection();
        PreparedStatement stmt = null;
        try {
            // 开启事务
            conn.setAutoCommit(false);

            // 扣 mimic
            String updateSql = "UPDATE tb_test SET money = money - ? WHERE id = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, money);
            stmt.setInt(2,mimic);
            stmt.execute();

            // throw Exception
            int result = 1 / 0;

            // 加 xmm
            updateSql = "UPDATE tb_test SET money = money + ? WHERE id = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, money);
            stmt.setInt(2,xmm);
            stmt.execute();

            // 提交事务
            conn.commit();
        } catch (Exception e) {
            // 回滚事务
            conn.rollback();
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            conn.close();
        }
    }

    public static void query() throws SQLException {
        Connection conn = getConnectionFromHikari();
        // query
        String updateSql = "SELECT * FROM tb_test WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(updateSql);
        stmt.setInt(1,1);
        ResultSet resultSet = stmt.executeQuery();
        while (resultSet.next()) {
            System.out.println(resultSet.getString("name") + "," + resultSet.getInt("money"));
        }
        stmt.close();
        conn.close();
    }

    public static void update() throws SQLException {
        Connection conn = getConnection();
        // update
        String updateSql = "UPDATE tb_test SET `name` = ? WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(updateSql);
        stmt.setString(1,"mimic");
        stmt.setInt(2,1);
        stmt.execute();
        stmt.close();
        conn.close();
    }

    public static void delete() throws SQLException {
        Connection conn = getConnection();
        // delete
        String deleteSql = "DELETE FROM tb_test WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(deleteSql);
        stmt.setInt(1,4);
        stmt.execute();
        stmt.close();
        conn.close();
    }

    public static void insert() throws SQLException {
        Connection conn = getConnection();
        // insert
        String insertSql = "INSERT INTO tb_test(`name`, money) VALUES(?, ?)";
        PreparedStatement stmt = conn.prepareStatement(insertSql);
        stmt.setString(1, "xmm");
        stmt.setInt(2,18);
        stmt.execute();
        stmt.close();
        conn.close();
    }

    public static Connection getConnectionFromHikari() throws SQLException {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(URL);
        config.setUsername(USER);
        config.setPassword(PASSWORD);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        HikariDataSource ds = new HikariDataSource(config);
        return ds.getConnection();
    }

    public static Connection getConnection() throws SQLException {
        //2. 获得数据库连接
        Connection result = DriverManager.getConnection(URL, USER, PASSWORD);
        return result;
    }

}
