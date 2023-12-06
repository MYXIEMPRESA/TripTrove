
package com.javamaster.model;


public class MessageModel {
    
    private String content;
    private String userName;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "MessageModel{" + "content=" + content + ", userName=" + userName + '}';
    }
    
}
