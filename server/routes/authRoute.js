import express from "express";
import User from "../models/user.js";
import bcryptjs from "bcryptjs";
import jsonwebtoken from "jsonwebtoken";

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

export default authRoute;
