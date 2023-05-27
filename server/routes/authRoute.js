import express from "express";
import User from "../models/user.js";
import bcryptjs from "bcryptjs";
import jsonwebtoken from "jsonwebtoken";
import { auth } from "../middlewares/auth.js";

const authRoute = express.Router();

authRoute.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);
    let user = new User({
      email,
      name,
      password: hashedPassword,
    });
    user = await user.save();
    return res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

authRoute.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (!existingUser) {
      res.status(404).json({ msg: "User with this email does not exist!" });
    }
    const isPasswordMatch = await bcryptjs.compare(
      password,
      existingUser.password
    );
    if (!isPasswordMatch) {
      return res.status(401).json({ msg: "Incorrect password!" });
    }
    const token = jsonwebtoken.sign({ id: existingUser._id }, "passwordKey");
    return res.status(200).json({ ...existingUser._doc, token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

authRoute.post("/token-valid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.json(false);
    }
    const verified = jsonwebtoken.verify(token, "passwordKey");
    //Token generate từ _id => Có thể findById
    if (!verified) {
      return res.json(false);
    }
    const user = await User.findById(verified.id);
    if (!user) {
      return res.json(false);
    }
    return res.json(true);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

authRoute.get("/me", auth, async (req, res) => {
  const user = User.findById(req.user);
  return res.json({ ...user._doc, token: req.token });
});

export default authRoute;
