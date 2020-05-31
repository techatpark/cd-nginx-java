package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class RestServiceApplication {

    @RequestMapping("/")
    String home() {
        return "Welcome";
    }

    @RequestMapping("/api")
    String api() {
        return "DATETIME";
    }

    public static void main(String[] args) throws InterruptedException {
        Thread.sleep(10000);
        SpringApplication.run(RestServiceApplication.class, args);
    }

}
