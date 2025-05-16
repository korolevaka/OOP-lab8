package repository;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import model.Category;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class CategoryRepository {
    private static final String FILE_PATH = "categories.json";
    private Gson gson = new Gson();

    public List<Category> getAllCategories() {
        try (InputStreamReader reader = new InputStreamReader(new FileInputStream(FILE_PATH), "UTF-8")) {
            Type listType = new TypeToken<ArrayList<Category>>(){}.getType();
            return gson.fromJson(reader, listType);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public void saveCategory(Category category) {
        List<Category> categories = getAllCategories();
        categories.add(category);
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(FILE_PATH), "UTF-8")) {
            gson.toJson(categories, writer);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
