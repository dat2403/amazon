import express from "express";
import { admin } from "../middlewares/admin.js";
import Product from "../models/product.js";

const adminRoute = express.Router();

adminRoute.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, price, quantity, images, category } = req.body;
    let product = new Product({
      name,
      description,
      price,
      quantity,
      images,
      category,
    });
    product = await product.save();
    return res.json(product);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

adminRoute.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    return res.json(products);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

adminRoute.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    let product = await Product.findByIdAndDelete(id);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default adminRoute;
