//package edu.geekbang.xmm.week005;
//
//import edu.geekbang.xmm.week005.bean.Klass;
//import edu.geekbang.xmm.week005.bean.School;
//import edu.geekbang.xmm.week005.bean.Student;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//import java.util.Arrays;
//
///**
// * @author XiaoManMan
// */
//@Configuration
//public class AutoConfig {
//
//    @Bean
//    public Klass class100() {
//        Klass klass = new Klass();
//        klass.setStudents(Arrays.asList(student100()));
//        return klass;
//    }
//
//    @Bean
//    public Student student100() {
//        Student student = new Student();
//        student.setId(100);
//        student.setName("xmm100");
//        return student;
//    }
//
//    @Bean
//    public School school() {
//        School school = new School();
//        return school;
//    }
//
//}
