import mongoose from "mongoose";

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    trim: true,
    validate: {
      validator: (value) => {
        const reg = /^\S+@\S+\.\S+$/;
        return value.match(reg);
      },
      message: "Please enter a valid email",
    },
  },
  password: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    default: "",
  },
  //   Chỉ có 1 type user là ADMIN, chưa implement role Seller / User
  type: {
    type: String,
    default: "user",
  },
  //cart
});

const User = mongoose.model("User", userSchema);

export default User;
