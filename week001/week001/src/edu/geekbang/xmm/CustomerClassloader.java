package edu.geekbang.xmm;

import java.io.*;
import java.lang.reflect.*;

/**
 * @author Xmm
 */
public class CustomerClassloader extends ClassLoader {

    /**
     * 作业思路：
     * 继承 ClassLoader 类，调用 defineClass 方法拿到 Class
     * 读取文件转换成 byte[] 数据
     * 对 byte[] 数据反码，x = 255 - x
     * 通过反射方式调用类方法
     */

    public static void main(String[] args) {
        try {
            String filePath = "src/Hello.xlass";
            String name = "Hello";
            Class<?> hello = new CustomerClassloader().findClass(name, filePath);
            Method method = hello.getMethod("hello");
            method.invoke(hello.newInstance());
        } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    private Class<?> findClass(String name, String filePath) {
        byte[] fileByteArray = fileToByteArray(filePath);
        decrypted(fileByteArray);
        return defineClass(name, fileByteArray, 0, fileByteArray.length);
    }

    private void decrypted(byte[] fileByteArray) {
        if (fileByteArray == null) {
            return;
        }
        for (int i = 0; i < fileByteArray.length; i++) {
            fileByteArray[i] = (byte) (255 - fileByteArray[i]);
        }
    }

    private byte[] fileToByteArray(String filePath) {
        File file = new File(filePath);
        byte[] result = null;
        try {
            FileInputStream fileInputStream = new FileInputStream(file);
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            byte[] b = new byte[1024];
            int len;
            while ((len = fileInputStream.read(b)) != -1) {
                byteArrayOutputStream.write(b, 0, len);
            }
            fileInputStream.close();
            byteArrayOutputStream.close();
            result = byteArrayOutputStream.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

}
