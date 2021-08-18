package org.cg.springboot;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class policy_bs {

    private List<policy_details> Policy_details = new ArrayList<>(Arrays.asList(
            new policy_details("PolicyA","Insurance for everyone","10000","10 years"),
                new policy_details("PolicyB","Insurance for older","10000","15 years"),
                new policy_details("PolicyC","Insurance for younger","10000","20 years")
                ));
    public List<policy_details> allpolicies(){
        return Policy_details;
    }
    public policy_details getpolicy(String name){
       return  Policy_details.stream().filter(p -> p.getPolicy_name().equals(name)).findFirst().get();
    }

    public void addpolicy(policy_details policy_detail){
        Policy_details.add(policy_detail);


    }

}
