package repository;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import model.Product;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class ProductRepository {
    private static final String FILE_PATH = "products.json";
    private Gson gson = new Gson();

    public List<Product> getAllProducts() {
        try (InputStreamReader reader = new InputStreamReader(new FileInputStream(FILE_PATH), "UTF-8")) {
            Type listType = new TypeToken<ArrayList<Product>>(){}.getType();
            return gson.fromJson(reader, listType);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public void saveProduct(Product product) {
        List<Product> products = getAllProducts();
        products.add(product);
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(FILE_PATH), "UTF-8")) {
            gson.toJson(products, writer);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
