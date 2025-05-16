package storage;

import model.Category;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class CategoryFileStorage {
    private static final String FILE_PATH = "categories.json";
    private static final ObjectMapper mapper = new ObjectMapper();

    public static List<Category> loadCategories() {
        try {
            File file = new File(FILE_PATH);
            if (!file.exists()) return new ArrayList<>();
            return mapper.readValue(file, new TypeReference<List<Category>>() {});
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static void saveCategory(Category category) {
        List<Category> categories = loadCategories();
        categories.add(category);
        try {
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(FILE_PATH), categories);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
