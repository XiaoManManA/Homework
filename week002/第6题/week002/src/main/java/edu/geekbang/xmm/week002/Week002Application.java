package edu.geekbang.xmm.week002;

import okhttp3.*;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.IOException;

/**
 * @author xiaomanman
 */
public class Week002Application {

	public static void main(String[] args) {
		OkHttpClient client = new OkHttpClient.Builder().build();
		Request request = new Request.Builder()
				.url("http://localhost:8801")
				.build();
		Call call = client.newCall(request);
		call.enqueue(new Callback() {
			@Override
			public void onFailure(Call call, IOException e) {
				System.out.println("request failure.");
				e.printStackTrace();
			}
			@Override
			public void onResponse(Call call, Response response) throws IOException {
				System.out.println(response.body().string());
			}
		});
	}
	

}
