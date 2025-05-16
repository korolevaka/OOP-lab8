package controller;


import model.Product;
import storage.ProductFileStorage;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @GetMapping
    public List<Product> getAllProducts() {
        return ProductFileStorage.loadProducts();
    }

    @PostMapping
    public void addProduct(@RequestBody Product product) {
        ProductFileStorage.saveProduct(product);
    }
}

