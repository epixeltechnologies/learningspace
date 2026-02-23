import WebSocket, { WebSocketServer } from "ws";
// import pkg from "pg";
// import dotenv from "dotenv";

// dotenv.config();

// const { Pool } = pkg;

// // Postgres DB
// const db = new Pool({
//   connectionString: process.env.DATABASE_URL,
//   ssl: { rejectUnauthorized: false }
// });

// WebSocket Server
const PORT = process.env.PORT || 10000;
const wss = new WebSocketServer({ port: PORT }, () =>
  console.log("WebSocket running on " + PORT),
);

// Store connected users
const clients = new Map();

wss.on("connection", (ws) => {
  console.log("Client connected");

  ws.on("message", async (msg) => {
    const data = JSON.parse(msg);

    // Register user to connection map
    if (data.type === "register") {
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

      return;
    }
    // if (data.type === "register") {
    //   clients.set(data.userId, ws);
    //   console.log("NewUser registered: " + data.userId);
    //   clients.forEach((client, uid) => {
    //      if (client.readyState === WebSocket.OPEN) {
    //       client.send(
    //         JSON.stringify({
    //           type: "User Register Success",
    //           time: new Date().toISOString(),
    //         })
    //       );
    //     }
    //   });
    //   return;
    // }

    // Send message
    if (data.type === "message") {
      const { chatId, senderId, text } = data;

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

      //   const result = await db.query(
      //     "SELECT * FROM messages WHERE chat_id = $1 ORDER BY id ASC",
      //     [chatId]
      //   );

      ws.send(
        JSON.stringify({
          type: "history",
          //   messages: result.rows,
        }),
      );
    }
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });
});
