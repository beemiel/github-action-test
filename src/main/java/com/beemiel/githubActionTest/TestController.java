package com.beemiel.githubActionTest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @Value("${my-string.version}")
    private String version;

    @GetMapping("/testtest")
    public String test() {
        return "testtest" + version;
    }

}
