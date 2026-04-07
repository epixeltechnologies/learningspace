import pkg from "agora-access-token";
const { RtcTokenBuilder, RtcRole } = pkg;
import express from "express";
import cors from "cors";

const app = express();
app.use(cors());

const APP_ID = process.env.APP_ID;
const APP_CERTIFICATE = process.env.APP_CERTIFICATE;

app.get("/", (req, res) => {
  res.send("Agora Token Server Running");
});

app.get("/token", (req, res) => {
  if (!APP_ID || !APP_CERTIFICATE) {
    return res.status(500).json({ error: "Missing APP_ID or APP_CERTIFICATE" });
  }

  const channelName = req.query.channel;
  const uid = req.query.uid || 0;
  const expireTime = 3600;

  if (!channelName) {
    return res.status(400).json({ error: "Channel name required" });
  }

  const current = Math.floor(Date.now() / 1000);
  const expire = current + expireTime;

  const token = RtcTokenBuilder.buildTokenWithUid(
    APP_ID,
    APP_CERTIFICATE,
    channelName,
    uid,
    RtcRole.PUBLISHER,
    expire
  );

  res.json({ token });
});

app.listen(10000, () => {
  console.log("Server running on port 10000");
});