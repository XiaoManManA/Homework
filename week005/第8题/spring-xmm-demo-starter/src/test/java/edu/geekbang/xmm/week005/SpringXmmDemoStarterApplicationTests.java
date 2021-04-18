package edu.geekbang.xmm.week005;

import edu.geekbang.xmm.week005.bean.School;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = DemoAutoConfiguration.class)
class SpringXmmDemoStarterApplicationTests {

    @Autowired(required = false)
    School school;

    @Test
    public void contextLoads() {
        school.ding();
    }

}
