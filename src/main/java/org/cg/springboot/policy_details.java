package org.cg.springboot;

public class policy_details {
    private String policy_name;

    public String getPolicy_name() {
        return policy_name;
    }
    public policy_details() {

    }

    public policy_details(String policy_name, String policy_description, String premium, String duration) {
        this.policy_name = policy_name;
        this.policy_description = policy_description;
        this.premium = premium;
        this.duration = duration;
    }

    public void setPolicy_name(String policy_name) {
        this.policy_name = policy_name;
    }

    public String getPolicy_description() {
        return policy_description;
    }

    public void setPolicy_description(String policy_description) {
        this.policy_description = policy_description;
    }

    public String getPremium() {
        return premium;
    }

    public void setPremium(String premium) {
        this.premium = premium;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    private String policy_description;
    private String premium;
    private String duration;

}
