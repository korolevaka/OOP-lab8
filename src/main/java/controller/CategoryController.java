package controller;

import model.Category;
import storage.CategoryFileStorage;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    @GetMapping
    public List<Category> getAllCategories() {
        return CategoryFileStorage.loadCategories();
    }

    @PostMapping
    public void addCategory(@RequestBody Category category) {
        CategoryFileStorage.saveCategory(category);
    }
}
