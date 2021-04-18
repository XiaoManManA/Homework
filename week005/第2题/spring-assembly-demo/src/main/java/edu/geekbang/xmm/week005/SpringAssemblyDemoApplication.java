package edu.geekbang.xmm.week005;

import edu.geekbang.xmm.week005.bean.School;
import edu.geekbang.xmm.week005.bean.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author XiaoManMan
 */
@SpringBootApplication
public class SpringAssemblyDemoApplication implements CommandLineRunner {

//    @Autowired
//    School school;

    @Autowired
    Student student;

    public static void main(String[] args) {

        /**
         * 写代码实现 Spring Bean 的装配，方式越多越好（XML、Annotation），提交到Github
         *
         * 1. xml 装配 Bean，写 xml 配置文件
         * 2. xml 装配 Bean，使用自动扫描标签
         * 3. Java 自动扫描注解，显式配置
         * 4. Java 自动扫描注解，隐式配置
         */

        // 1. xml 装配 Bean，写 xml 配置文件
//        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
//        School school = (School) context.getBean("school");
//        school.ding();

        // 2. xml 装配 Bean，使用自动扫描标签。需要在代码里面加注解 @Autowire（按照类型装配）@Resource（按照名称装配）
        // <context:component-scan base-package="edu.geekbang.xmm.week005.*"/>
//        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
//        School school = (School) context.getBean("school");
//        school.ding();

        // 3. Java 自动扫描注解，显式配置
        // @ComponentScan + @Configuration + @Bean

        // 4. Java 自动扫描注解，隐式配置
        // @ComponentScan + @Component（@Controller、@Service、@Repository） + @Autowire（按照类型装配）+ @Resource（按照名称装配）

        SpringApplication.run(SpringAssemblyDemoApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        // school.ding();
        student.print();
    }
}
