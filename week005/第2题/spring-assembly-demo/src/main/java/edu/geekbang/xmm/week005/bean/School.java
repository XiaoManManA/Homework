package edu.geekbang.xmm.week005.bean;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.Resource;

/**
 * @author XiaoManMan
 */
@Data
public class School implements ISchool {

    @Resource(name = "class100")
    Klass class100;
    @Autowired
    Student student100;
    
    @Override
    public void ding(){
        System.out.println("Class1 have " + this.class100.getStudents().size() + " students and one is " + this.student100);
    }
    
}
