<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Chat Application - Login</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<div class="login-container">

    <div class="login-box">

        <h1>Welcome to Chat</h1>

        <p>Enter your username to join the chat</p>


        <form action="${pageContext.request.contextPath}/login"
              method="post">

            <input
                type="text"
                name="username"
                placeholder="Enter your username"
                required
                autocomplete="off">


            <button type="submit">
                Join Chat
            </button>

        </form>

    </div>

</div>

</body>

</html>