package edu.geekbang.xmm.week005.bean;

import lombok.Data;

import java.util.List;

/**
 * @author XiaoManMan
 */
@Data
public class Klass { 
    
    List<Student> students;
    
    public void dong(){
        System.out.println(this.getStudents());
    }
    
}
