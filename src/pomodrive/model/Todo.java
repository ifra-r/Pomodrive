package pomodrive.model;

import java.time.LocalDateTime;

public class Todo {
    private int id;
    private int userId;
    private String title;
    private String description;
    private boolean completed;
    private int priority;
    private LocalDateTime createdDate;
    private LocalDateTime completedDate;

    // Constructors
    public Todo() {
    }

    public Todo(int userId, String title, String description, int priority) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.priority = priority;
        this.completed = false;
        this.createdDate = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
        if (completed && completedDate == null) {
            this.completedDate = LocalDateTime.now();
        } else if (!completed) {
            this.completedDate = null;
        }
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(LocalDateTime completedDate) {
        this.completedDate = completedDate;
    }

    @Override
    public String toString() {
        return "Todo{" +
                "id=" + id +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", completed=" + completed +
                ", priority=" + priority +
                ", createdDate=" + createdDate +
                ", completedDate=" + completedDate +
                '}';
    }
}