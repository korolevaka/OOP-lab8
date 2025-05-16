package storage;

import model.Product;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class ProductFileStorage {
    private static final String FILE_PATH = "products.json";
    private static final ObjectMapper mapper = new ObjectMapper();

    public static List<Product> loadProducts() {
        try {
            File file = new File(FILE_PATH);
            if (!file.exists()) return new ArrayList<>();
            return mapper.readValue(file, new TypeReference<List<Product>>() {});
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static void saveProduct(Product product) {
        List<Product> products = loadProducts();
        products.add(product);
        try {
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(FILE_PATH), products);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

