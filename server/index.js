import express from "express";
import mongoose from "mongoose";
import authRoute from "./routes/authRoute.js";

const USERNAME = "roberthoang";
const PASSWORD = "xXYIW6P8dtj3gC8b";

const DB_URL =
  "mongodb+srv://roberthoang:xXYIW6P8dtj3gC8b@cluster0.cw2oh1p.mongodb.net/?retryWrites=true&w=majority";

const PORT = 4000;

const app = express();

app.use(express.json());

app.use(authRoute);

mongoose
  .connect(DB_URL)
  .then(() => {
    console.log("Database connected successfully");
  })
  .catch((e) => {
    console.log(e);
  });

// Android Emulator cần tham số thứ 2 => Tra thêm

app.listen(PORT, "0.0.0.0", () => {
  console.log("Server connected at port: ", PORT);
});
