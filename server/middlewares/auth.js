import jsonwebtoken from "jsonwebtoken";

export const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied!" });
    }
    const verified = jsonwebtoken.verify(token, "passwordKey");
    //Token generate từ _id => Có thể findById
    if (!verified) {
      return res.status(401).json({ msg: "Token invalid, access denied!" });
    }
    req.user = verified.id; //Gán thông tin cho req next
    req.token = token;
    next();
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
