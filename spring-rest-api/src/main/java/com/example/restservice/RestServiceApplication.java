package com.example.restservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class RestServiceApplication {
    @RequestMapping("/")
    String home() {
        return "Hello World 2.0!" ;
    }

    public static void main(String[] args) {
        SpringApplication.run(RestServiceApplication.class, args);
    }

}
