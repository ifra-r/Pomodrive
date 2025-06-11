<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Pomodrive - Login / Sign Up</title>
  <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/signup.css" />
</head>
<body>
  <div class="header">
    <h1>Pomodrive</h1>
    <p class="author">by ifra</p>
  </div>

  <div class="quote">Sign up, Lock in.</div>

    <!-- Add this wrapper -->
  <div class="form-container">

    <% String error = (String) request.getAttribute("errorMessage"); %>
    <% if (error != null) { %>
      <div class="error-message">
        <%= error %>
      </div>
    <% } %>

    <form action="signup" method="post">
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />
        <div class="buttons">
            <button type="submit">Sign Up</button>
            <p>Already have an account? 
              <a href="login.jsp">Login</a>
            </p>
        </div>
    </form> 


</body>
</html>
