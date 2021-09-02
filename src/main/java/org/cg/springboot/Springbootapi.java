package org.cg.springboot;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.List;
import java.util.List;


@SpringBootApplication
@RestController
public class Springbootapi {
    public static void main(String[] args){
        SpringApplication.run(Springbootapi.class, args);
    }
    @Autowired
    private policy_bs policy_bs;

    @GetMapping("/hello")
    public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
        return String.format("Hello TEAM %s!", name);
    }

    @GetMapping("/allpolicies")
    public List<policy_details> allpolicies(){
        return policy_bs.allpolicies();
    }

    @GetMapping("/policy/{name}")
    public policy_details getpolicy(@PathVariable String name){
        return policy_bs.getpolicy(name);
    }

    @PostMapping("/policy")
    public void addpolicy(@RequestBody policy_details policy_detail){
         policy_bs.addpolicy(policy_detail);
    }

    


}
