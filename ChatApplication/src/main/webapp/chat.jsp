<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username =
            (String) session.getAttribute("username");

    if (username == null) {

        response.sendRedirect("index.jsp");

        return;
    }
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Chat Room</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>


<body>

<div class="chat-container">


    <!-- HEADER -->

    <div class="chat-header">

        <div>

            <h2>Chat Room</h2>

            <span>
                Logged in as:
                <strong><%= username %></strong>
            </span>

        </div>

        <a href="index.jsp"
           class="logout">
            Logout
        </a>

    </div>


    <!-- MESSAGES -->

    <div id="messages"
         class="messages">

    </div>


    <!-- MESSAGE INPUT -->

    <div class="message-area">

        <input
            type="text"
            id="messageInput"
            placeholder="Type your message..."
            autocomplete="off">

        <button onclick="sendMessage()">
            Send
        </button>

    </div>

</div>


<script>

    // Current logged-in user
    const username =
        "<%= username.replace("\\", "\\\\")
                     .replace("\"", "\\\"") %>";


    // Context path
    const contextPath =
        "<%= request.getContextPath() %>";


    // WebSocket protocol
    const protocol =
        window.location.protocol === "https:"
        ? "wss://"
        : "ws://";


    // WebSocket URL
    const socketURL =
        protocol
        + window.location.host
        + contextPath
        + "/chatSocket?username="
        + encodeURIComponent(username);


    console.log("Connecting to:");
    console.log(socketURL);


    // Create WebSocket
    const socket =
        new WebSocket(socketURL);


    // Connection opened
    socket.onopen = function() {

        console.log(
            "Connected to chat server"
        );

    };


    // Message received
    socket.onmessage = function(event) {

        const data =
            JSON.parse(event.data);

        displayMessage(
            data.username,
            data.message
        );

    };


    // Connection closed
    socket.onclose = function() {

        console.log(
            "Disconnected from server"
        );

    };


    // Error
    socket.onerror = function(error) {

        console.error(
            "WebSocket error:",
            error
        );

    };


    // Send message
    function sendMessage() {

        const input =
            document.getElementById(
                "messageInput"
            );

        const message =
            input.value.trim();


        if (message === "") {
            return;
        }


        if (socket.readyState !== WebSocket.OPEN) {

            alert(
                "Chat connection is not ready."
            );

            return;
        }


        socket.send(message);

        input.value = "";

        input.focus();
    }


    // Display message
    function displayMessage(
        username,
        message
    ) {

        const messages =
            document.getElementById(
                "messages"
            );


        const messageDiv =
            document.createElement("div");


        messageDiv.className =
            "message";


        const usernameElement =
            document.createElement("strong");


        usernameElement.textContent =
            username + ":";


        const messageElement =
            document.createElement("span");


        messageElement.textContent =
            " " + message;


        messageDiv.appendChild(
            usernameElement
        );


        messageDiv.appendChild(
            messageElement
        );


        messages.appendChild(
            messageDiv
        );


        messages.scrollTop =
            messages.scrollHeight;
    }


    // Press Enter to send
    document
        .getElementById("messageInput")
        .addEventListener(
            "keydown",
            function(event) {

                if (event.key === "Enter") {

                    sendMessage();

                }

            }
        );

</script>

</body>

</html>