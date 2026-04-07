import { RtcTokenBuilder, RtcRole } from "agora-access-token";

export default function handler(req, res) {
  const APP_ID = process.env.APP_ID;
  const APP_CERTIFICATE = process.env.APP_CERTIFICATE;

  if (!APP_ID || !APP_CERTIFICATE) {
    return res.status(500).json({ error: "APP_ID or APP_CERTIFICATE missing" });
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

  return res.status(200).json({ token });
}