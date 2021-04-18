package edu.geekbang.xmm.week005.bean;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.Resource;

/**
 * @author XiaoManMan
 */
@Data
public class School implements ISchool {

    @Autowired
    Klass class100;
    @Resource(name = "student100")
    Student student100;
    
    @Override
    public void ding(){
        System.out.println("Class1 have " + this.class100.getStudents().size() + " students and one is " + this.student100);
    }
    
}
