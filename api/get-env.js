export default function handler(req, res) {
  const authHeader = req.headers["authorization"];
  
  if (!authHeader || authHeader !== `Bearer ${process.env.ACCESS_TOKEN}`) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  res.setHeader("Content-Type", "text/plain");
  res.send(`GEMINI_API_KEY=${process.env.GEMINI_API_KEY}`);
}
