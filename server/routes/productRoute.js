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
productRoute.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: new RegExp(req.params.name, "i"),
    });
    return res.json(products);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

productRoute.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);
    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }
    const ratingSchema = {
      userId: req.user,
      rating: rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

productRoute.get("/api/error", auth, async (req, res) => {
  return res.status(401).json({ error: error.message });
});

export default productRoute;
