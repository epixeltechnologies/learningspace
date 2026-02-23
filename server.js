import WebSocket, { WebSocketServer } from "ws";

// WebSocket Server
const PORT = process.env.PORT || 10000;
const wss = new WebSocketServer({ port: PORT }, () =>
  console.log("WebSocket running on " + PORT),
);

const chats = new Map();
// Store connected users
const clients = new Map();

wss.on("connection", (ws) => {
  console.log("Client connected");

  ws.on("message", async (msg) => {
    const data = JSON.parse(msg);

    // Register user to connection map
    if (data.type === "register") {
      try{
        clients.set(data.userId, ws);
      console.log("New User registered: " + data.userId);
      
      // Send confirmation to all registered users
      clients.forEach((clientWs, uid) => {
        if (clientWs.readyState === WebSocket.OPEN) {
          clientWs.send(
            JSON.stringify({
              type: "User Register Success",
              userId: data.userId,
              time: new Date().toISOString(),
            }),
          );
        }
      });
      }catch(e){
        console.log("New User Fail:::: " + e.toString());
      }

      return;
    }

    // Send message
    if (data.type === "message") {
      const { chatId, senderId, text } = data;
      // If chatId does not exist yet, initialize it
  if (!chats.has(chatId)) {
    chats.set(chatId, []); // value is an array
  } // Push message into the array
  chats.get(chatId).push({
    senderId,
    text,
    time: new Date().toISOString(),
  });
      
      // Save to DB
      //   await db.query(
      //     "INSERT INTO messages (chat_id, sender_id, text) VALUES ($1, $2, $3)",
      //     [chatId, senderId, text]
      //   );

      // Broadcast to all users in chat
      clients.forEach((client, uid) => {
        if (client.readyState === WebSocket.OPEN) {
          client.send(
            JSON.stringify({
              type: "message",
              chatId,
              senderId,
              text,
              time: new Date().toISOString(),
            }),
          );
        }
      });
    }

    // Load history
    if (data.type === "history") {
      const { chatId } = data;
      ws.send(
        JSON.stringify({
          type: "history",
          data:chats[chatId]
          //   messages: result.rows,
        }),
      );
    }
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });
});
