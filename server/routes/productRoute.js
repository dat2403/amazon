import express from "express";
import { auth } from "../middlewares/auth.js";
import Product from "../models/product.js";

const productRoute = express.Router();

productRoute.get("/api/products", auth, async (req, res) => {
  try {
    const { category } = req.query;
    const products = await Product.find({ category: category });
    return res.json(products);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

productRoute.get("/api/error", auth, async (req, res) => {
  return res.status(401).json({ error: error.message });
});

export default productRoute;
